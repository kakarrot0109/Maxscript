-- Name：Print all Things for Scene
-- Author：Kakarrot
-- Time：2019.4.4

global PrintallThings
try(destroyDialog PrintallThings)catch()

rollout PrintallThings "JiXuan" width:210 height:100
(
	HyperLink website "By:Kakarrot & 极渲染" pos:[5,10] width:150 height:15 color:(color 93 102 106) hovercolor:(color 120 170 207) visitedcolor:(color 93 102 106) address:"http://www.jixuanran.com"
	button 'btn1' "全部" pos:[5,30] width:50 height:25 align:#left
	button 'btn2' "贴图" pos:[55,30] width:50 height:25 align:#left
	button 'btn3' "光域网" pos:[105,30] width:50 height:25 align:#left
	button 'btn4' "光子" pos:[155,30] width:50 height:25 align:#left
	label 'lab1' "点击按钮，在侦听器窗口查看结果。" pos:[5,70] align:#left
	
	fn get_files file =(
		local allfiles = #()
		local mapfiles = #()
		local iesfiles = #()
		local vrmapfiles = #()
		if file == "all" then(
			join allfiles (usedMaps())
			append allfiles (maxfilepath + maxfilename)
			allfiles = makeUniqueArray allfiles
			return allfiles 
		)
		if file == "map" then(
			temp = makeUniqueArray (getClassInstances Bitmaptexture)
			for i in temp where i.filename != undefined or i.filename != "" do(
				append mapfiles i.filename
			)
			mapfiles = makeUniqueArray mapfiles
			return mapfiles
		)
		if file == "ies" then(
			temp = makeUniqueArray (getClassInstances Target_Light + getClassInstances Free_Light)
			for i in temp where i.webFile != undefined do(
				append iesfiles i.webFile
			)
			iesfiles = makeUniqueArray iesfiles
			return iesfiles
		)
		if file == "vrmap" then(
			if (renderers.current.adv_irradmap_mode == 2 and \
				renderers.current.adv_irradmap_loadFileName != undefined and \
				renderers.current.adv_irradmap_loadFileName != "")then(
					append vrmapfiles renderers.current.adv_irradmap_loadFileName
			)
			if (renderers.current.lightcache_mode == 2 and \
				renderers.current.lightcache_loadFileName != undefined and \
				renderers.current.lightcache_loadFileName != "")then(
					append vrmapfiles renderers.current.lightcache_loadFileName
			)
			vrmapfiles = makeUniqueArray vrmapfiles
			return vrmapfiles
		)
	)
	
	local str = "-----"
	
	on btn1 pressed do
	(
			print("场景所有素材文件：")
			print(get_files "all")
			print(str)
		)
	on btn2 pressed do
	(
			print("场景所有贴图文件：")
			print(get_files "map")
			print(str)
		)
	on btn3 pressed do
	(
			print("场景所有光域网文件：")
			print(get_files "ies")
			print(str)
		)
	on btn4 pressed do
	(
			print("场景所有光子文件：")
			print(get_files "vrmap")
			print(str)
		)
)createdialog PrintallThings style:#(#style_minimizebox, #style_titlebar, #style_sysmenu)
