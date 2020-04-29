-- Name：Print all SameMaps for Scene
-- Author：Kakarrot
-- Time：2019.4.4

global PrintallSameMaps
try(destroyDialog PrintallSameMaps)catch()

rollout PrintallSameMaps "JiXuan" width:210 height:100
(
	HyperLink 'website' "By:Kakarrot & 极渲染" pos:[5,10] width:150 height:15 color:(color 93 102 106) hovercolor:(color 120 170 207) visitedcolor:(color 93 102 106) address:"http://www.jixuanran.com" align:#left
	button 'btn1' "打印重复贴图" pos:[5,30] width:90 height:25 align:#left
	label 'lab1' "点击按钮，在侦听器窗口查看结果。" pos:[5,70] width:192 height:13 align:#left
	
	fn CheckSameTexture =(
		allMaps = #()   	--贴图数组
		allFileName = #()   --贴图文件名数组
		sameMaps = #()      --重复贴图数组
		Message = #()		--重复贴图错误数组
		str = ""			--错误信息
		
		ATSops.GetFiles(&allMaps)
		for i in allMaps do append allFileName (filenameFromPath i)
		sort allFileName
		
		--添加重复贴图数组
		for n = 1 to allFileName.count do(
			if allFileName[n] == allFileName[n+1] then(
				appendIfUnique sameMaps allFileName[n]
			)
		)
		
		--丢失的文件, 排除
		for i in sameMaps do(
			shouldContinue = false
			shouldRemove = true
			for j in allMaps do(
				fname = filenameFromPath j
				if i == fname do(
					if (ATSops.TestFileSystemStatus j #Found) or (ATSops.TestFileSystemStatus j #ok) do(
						shouldContinue = true
						shouldRemove = false
						exit
					)
				)
			)
			--移除掉全部丢失的贴图
			if shouldRemove do(deleteItem sameMaps (findItem sameMaps i))
			if shouldContinue do(continue)
		)
		
		-- 输出提醒
		if sameMaps.count != 0 do(
			for i in sameMaps do(
				str += i as string + " \n"
			)
			appendIfUnique Message str
		)
		
		if Message.count != 0 then(
			for i = 1 to Message.count do(
				str = Message[i] + "\n" --把错误信息从数组中取出
			)
		)else(str = "无重复贴图！")
		
		print str 
	)
	
	on btn1 pressed do(
		print("场景中的重复贴图：")
		CheckSameTexture()
	)
	
	
)createdialog PrintallSameMaps style:#(#style_minimizebox, #style_titlebar, #style_sysmenu)
