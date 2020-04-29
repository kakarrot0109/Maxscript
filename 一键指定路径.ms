-- Name：Set Files Path for Scene
-- Author：Kakarrot
-- Time：2019.4.4

global SetFilesPath
try(destroyDialog SetFilesPath)catch()

rollout SetFilesPath "JiXuan" width:210 height:100
(
	HyperLink 'website' "By:Kakarrot & 极渲染" pos:[5,10] width:150 height:15 color:(color 93 102 106) hovercolor:(color 120 170 207) visitedcolor:(color 93 102 106) address:"http://www.jixuanran.com" align:#left
	button 'btn1' "指定材质路径" pos:[5,30] width:90 height:25 align:#left
	label 'lab1' "点击按钮，在资源追踪窗口查看结果。" pos:[5,70] width:192 height:13 align:#left

	Fn SetDirectoryAccessControlType inputDirectoryInfo = 
	(
		tempUserName = (DotNetClass "System.Environment").UserName
		fileSystemRights = (DotNetClass "System.Security.AccessControl.FileSystemRights").Modify
		accessControlType = (DotNetClass "System.Security.AccessControl.AccessControlType").Allow
		fileSystemAccessRule = DotNetObject "System.Security.AccessControl.FileSystemAccessRule" tempUserName fileSystemRights accessControlType 
		directorySecurity = inputDirectoryInfo .GetAccessControl()
		directorySecurity.AddAccessRule fileSystemAccessRule 
		inputDirectoryInfo .SetAccessControl directorySecurity 
	)

	Fn GetAllFiles targetPath fileFilter  =
	(
		local SearchOption,DotNetDirectoryInfo
		SearchOption = DotNetClass "System.IO.SearchOption"
		DotNetDirectoryInfo = DotNetObject "System.IO.DirectoryInfo" targetPath
		SetDirectoryAccessControlType DotNetDirectoryInfo
		result = for tfi in (DotNetDirectoryInfo.GetFiles fileFilter SearchOption.AllDirectories) collect tfi.FullName
		result
	)

	Fn GetStringParseCount inputString1 inputString2 = 
	(
		result = 0
		referenceString = inputString1
		if inputString1.count > inputString2.count do referenceString = inputString2
		for i = 0 to referenceString.count - 1 do
		( 
			if inputString1[inputString1.Count - i] == inputString2[inputString2.Count - i] then
			(
				result += 1
			)
			else
			(
				exit
			)
		)
		result 
	)

	Fn GetRootTrackNode = (refs.Dependents RootNode)[1]

	Fn RecursionProcessFilePath inputTargetNode inputNewPath = 
	(
		for i = 1 to inputTargetNode.numSubs do
		(
			tempSubAnim = getSubAnim  inputTargetNode i
			tempNode = (getSubAnim  inputTargetNode i).object 
			if ClassOf tempNode == Bitmaptexture do
			(
				oldFileFullName = tempNode.FileName
				if oldFileFullName != "" and  not DoesFileExist oldFileFullName do
				(
					oldFileName = FilenameFromPath oldFileFullName 
					newFilelist = GetAllFiles inputNewPath oldFileName 
					maxParseFileName = ""
					for tempFileName in newFilelist where
					(
						GetStringParseCount tempFileName oldFileName > GetStringParseCount tempFileName maxParseFileName
					)
					do
					(
						maxParseFileName = tempFileName 
					)
					if maxParseFileName != "" do tempNode.FileName =  maxParseFileName
				)
			)
			if tempSubAnim.numSubs > 0 do RecursionProcessFilePath tempSubAnim  inputNewPath
		)
	)
	
	on btn1 pressed do(
		local newPath = GetSavePath()
		if undefined !=  newpath do RecursionProcessFilePath (GetRootTrackNode()) newPath
	)
)
createdialog SetFilesPath style:#(#style_minimizebox, #style_titlebar, #style_sysmenu)