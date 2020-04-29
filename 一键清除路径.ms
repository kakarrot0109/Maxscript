-- Name：Clear Files Path for Scene
-- Author：Kakarrot
-- Time：2019.4.4

global ClearFilesPath
try(destroyDialog ClearFilesPath)catch()

rollout ClearFilesPath "JiXuan" width:210 height:100
(
	HyperLink website "By:Kakarrot & 极渲染" pos:[5,10] width:150 height:15 color:(color 93 102 106) hovercolor:(color 120 170 207) visitedcolor:(color 93 102 106) address:"http://www.jixuanran.com"
	button 'btn1' "全部" pos:[5,30] width:50 height:25 align:#left
	button 'btn2' "贴图" pos:[55,30] width:50 height:25 align:#left
	button 'btn3' "光域网" pos:[105,30] width:50 height:25 align:#left
	button 'btn4' "光子" pos:[155,30] width:50 height:25 align:#left
	label 'lab1' "点击按钮，在资源追踪窗口查看结果。" pos:[5,70] align:#left

	fn clear_files_path file =(
		if file == "map" then(
			for i in getClassInstances Bitmaptexture do(
				if i.filename != undefined and i.filename != "" do(
					i.filename = filenameFromPath i.filename
				)
			)
		)
		if file == "ies" then(
			for i in getClassInstances Target_Light + getClassInstances Free_Light do(
				if i.webfile != undefined and i.webfile != "" do(
					i.webfile = filenameFromPath i.webfile
				)
			)
		)
		if file == "vrmap" then(
			if (renderers.current.adv_irradmap_mode == 2 and \
				renderers.current.adv_irradmap_loadFileName != undefined and \
				renderers.current.adv_irradmap_loadFileName != "")then(
					renderers.current.adv_irradmap_loadFileName = filenameFromPath renderers.current.adv_irradmap_loadFileName
			)
			if (renderers.current.lightcache_mode == 2 and \
				renderers.current.lightcache_loadFileName != undefined and \
				renderers.current.lightcache_loadFileName != "")then(
					renderers.current.lightcache_loadFileName = filenameFromPath renderers.current.lightcache_loadFileName
			)
		)
		if file == "xref" then(
			if xrefs.getXRefFileCount() != 0 then(
				for i=1 to xrefs.getXRefFileCount() do(
					if classof (xrefs.getXRefFile i).filename == VRayProxy and \
					(xrefs.getXRefFile i).filename  != "" then(
						(xrefs.getXRefFile i).filename = filenameFromPath (xrefs.getXRefFile i).filename 
					)
				)
			)
		)
	)
	
	on btn1 pressed do(
		clear_files_path "map"
	)
	on btn2 pressed do(
		clear_files_path "ies"
	)
	on btn3 pressed do(
		clear_files_path "vrmap"
	)
	on btn4 pressed do(
		clear_files_path "xref"
	)
)createdialog ClearFilesPath style:#(#style_minimizebox, #style_titlebar, #style_sysmenu)
