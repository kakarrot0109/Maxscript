-- Name：Extract Object
-- Author：Kakarrot
-- Time：2019.4.4

global ExtractObject
try(destroyDialog ExtractObject)catch()

rollout ExtractObject "JiXuan" width:410 height:150
(
	HyperLink 'website' "By:Kakarrot & 极渲染" pos:[20,10] width:150 height:15 color:(color 93 102 106) hovercolor:(color 120 170 207) visitedcolor:(color 93 102 106) address:"http://www.jixuanran.com" align:#left
	label 'lbl1' "Max文件路径" pos:[20,30] width:70 height:15 align:#left
	edittext 'edt1' "" pos:[100,30] width:240 height:18 align:#left
	label 'lbl2' "Max文件名字" pos:[20,55] width:70 height:15 align:#left
	edittext 'edt2' "" pos:[100,55] width:240 height:18 align:#left
	button 'btn1' "提取" pos:[350,35] width:41 height:35 align:#left
	label 'lbl3' "使用说明：填写将要保存的max文件名以及路径" pos:[20,80] width:297 height:14 align:#left
	label 'lbl7' "例如：D:\整体模型1\沙发模型(可直接复制windows地址栏)" pos:[20,100] width:330 height:14 align:#left
	label 'lbl8' "例如：沙发模型" pos:[20,120] width:297 height:14 align:#left

	fn getFilesFromObjects objs =
	(
		local mats = makeUniqueArray (for o in objs where (o.material !=undefined) collect o.material)
		local totalFiles = #()
		for m in mats do
		(
			
			for b in getClassInstances bitmapTex target:m where b.filename != undefined do
			(
				if (doesFileExist b.filename ==false )then (b.filename=mapPaths.getFullFilePath b.filename)
				if (doesFileExist b.filename ==false )then ()else(appendIfUnique totalFiles b.filename)
			)
		)
		totalFiles
	)
	
	on btn1 pressed do
	(
		thecopypastedir = edt1.text + "\\" -- CHANGE THIS TO ANY FOLDER YOU WANT
		thecopypastefile = edt2.text --this is the filename to save as...
		thecopypastestring = thecopypastedir + thecopypastefile --this is the complete string
		
		--1先检测img目录存在不，不存在就自动建设一个。
		SavemaxfPath=thecopypastedir+"\素材\\"
		if((dotNetclass "System.IO.Directory").Exists SavemaxfPath) then 
		() 
		else(MakeDir(SavemaxfPath))
		
		if $ != undefined then
		(
			--2，检测img里有没有东西，如果有东西先删除。
			files = getFiles (savemaxfpath+"\\*.*")
			for f in files do (deletefile f)
			--3，开始复制模型
			saveNodes $ thecopypastestring
			--4，把模型需要的贴图，代理，光渔网 都复制到img里去。
		
			aa=getFilesFromObjects selection
	
			for k in aa do 
			(
				copyfile k (savemaxfpath+(filenameFromPath k))
			)
			--5,复制光渔网
			for obj in selection where ((IsKindOf obj Target_Light) or (IsKindOf obj Free_Light)or (IsKindOf obj Vrayies)) do
			(
				try (
					if (doesFileExist obj.ies_file ==false )then (obj.ies_file=mapPaths.getFullFilePath obj.ies_file)
					if (doesFileExist obj.ies_file ==false )then ()else(copyfile obj.ies_file (savemaxfpath+(filenameFromPath obj.ies_file) ))
					)
				catch(
					if (doesFileExist obj.webFile ==false )then (obj.webFile=mapPaths.getFullFilePath obj.webFile)
					if (doesFileExist obj.webFile ==false )then ()else(copyfile obj.webFile (savemaxfpath+(filenameFromPath obj.webFile) ))
					)
			)
			--复制代理文件
		
			for DL in selection where (IsKindof DL vrayproxy) do
			(
			   if (doesFileExist DL.filename ==false )then (DL.filename=mapPaths.getFullFilePath DL.filename)
			   if (doesFileExist DL.filename ==false )then ()else(copyfile DL.filename (savemaxfpath+(filenameFromPath DL.filename)))
			)
		) --this saves ("copies") the objects as a file
		else
		(
			messagebox "你没选中要保存的物体！"
		)
	)
)createdialog ExtractObject style:#(#style_minimizebox, #style_titlebar, #style_sysmenu)
