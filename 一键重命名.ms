-- Name：Batch Rename
-- Author：Kakarrot
-- Time：2019.5.8

global BatchRename
try(destroyDialog BatchRename)catch()
rollout BatchRename "一键重命名" width:165 height:250
(
	HyperLink 'website' "By:Kakarrot & 极渲染" pos:[5,10] width:150 height:15 color:(color 93 102 106) hovercolor:(color 120 170 207) visitedcolor:(color 93 102 106) address:"http://www.jixuanran.com" align:#left
    
	label 'lbl1' "前缀：" pos:[5,35] width:35 height:20 align:#left
	edittext 'edt1' "" pos:[40,30] width:110 height:20 align:#left
	--label 'lbl2' "后缀：" pos:[5,50] width:35 height:20 align:#left
	--edittext 'edt2' "" pos:[55,50] width:100 height:20 align:#left

    groupBox 'grp' "默认设置" pos:[5,75] width:150 height:90 align:#left
	label 'lbl3' "物体前缀：obj" pos:[20,100] width:80 height:20 align:#left
	label 'lbl4' "材质前缀：mtl" pos:[20,120] width:80 height:20 align:#left
	label 'lbl5' "贴图前缀：map" pos:[20,140] width:80 height:20 align:#left
    
	checkbox 'chk1' "物体重命名" pos:[5,185] width:83 height:20 align:#left
	checkbox 'chk2' "材质重命名" pos:[5,205] width:83 height:20 align:#left
	checkbox 'chk3' "贴图重命名" pos:[5,225] width:83 height:20 align:#left
	
	button 'btn' "开始" pos:[90,215] width:60 height:25 align:#left

	local allMaterials = #()
	local title = "JiXuan"

	-- 物体重命名
	fn rename_obj =(
		local objs = objects as array
		local num = 1
		for o in objs do(
			if edt1.text != "" then(
				o.name = edt1.text + num as string
				num = num + 1
			)
			if edt1.text == "" then(
				o.name = "obj_" + num as string
				num = num + 1
			)
		)
		messageBox("完成物体命名 " + objs.count as string + " 个！") title:title
	)
	-- 获得全部材质包括子材质
	fn get_Mtls_mtl mtl =(
		for m in mtl do(
			if ClassOf m == Multimaterial then (get_Mtls_mtl m)
			else(append allMaterials m)
		)
	)
	fn get_allmaterials =(
		for i in sceneMaterials do(
			if ClassOf i == Multimaterial then (get_Mtls_mtl i)
			else(append allMaterials i)
		)
		for i=allMaterials.count to 1 by -1 do(
			if allMaterials[i] == undefined then(
				deleteItem allMaterials i
			)
		)
		allMaterials
	)
	-- 材质重命名
	fn rename_mtl =(
		local mtls = get_allmaterials()
		local num = 1
		for m in mtls do(
			if edt1.text != "" then(
				m.name = edt1.text + num as string
				num = num + 1
			)
			if edt1.text == "" then(
				m.name = "mtl_" + num as string
				num = num + 1
			)
		)
		messageBox("完成材质命名 " + mtls.count as string + " 个！") title:title
	)
	-- 贴图重命名
	fn rename_map =(
		ATSOps.visible = true
		ATSOps.visible = false
		ATSOps.refresh()
		ATSOps.getFiles &map
		maps = for f in map where ATSOps.IsInputFile f and f != maxfilepath + maxfilename and(not doesfileExist f or getfilenamePath f == "") collect f
		ATSOps.SelectFiles maps
		ATSOps.ResolveSelectionRelativeToProjectFolder()
		ATSOps.getFiles &map
		maps = for f in map where ATSOps.IsInputFile f and f != maxfilepath + maxfilename and(not doesfileExist f or getfilenamePath f == "") collect f
		ATSOps.SelectFiles (for f in maps where getfilenamePath f != "" collect f)
		ATSOps.ResolveSelectionToAbsolute()
		ATSOps.refresh()
		ATSOps.getFiles &map
		
		local maps = for f in map where ATSOps.IsInputFile f and f != maxfilepath + maxfilename and doesfileExist f collect f
		local num = 1
		local ImgPath = maxfilePath + "重命名贴图" + "\\"
		makeDir ImgPath
		for m in maps do(
			if edt1.text != "" then(
				map_name = ImgPath + edt1.text + num as string + getFilenameType m
				num = num + 1
				copyFile m map_name
				ATSOps.clearSelection()
				ATSOps.SelectFiles m
				ATSOps.RetargetSelection map_name
			)
			if edt1.text == "" then(
				map_name = ImgPath + "map_" + num as string + getFilenameType m
				num = num + 1
				copyFile m map_name
				ATSOps.clearSelection()
				ATSOps.SelectFiles m
				ATSOps.RetargetSelection map_name
			)
		)
		ATSOps.refresh()
		messageBox("完成贴图命名 " + maps.count as string + " 个！") title:title
	)
	on btn pressed do(
		if maxfilePath == "" do messageBox("请保存场景文件！") title:title
		if chk1.checked then(
			rename_obj()
		)
		if chk2.checked then(
			rename_mtl()
		)
		if chk3.checked then(
			rename_map()
		)
	)
    
)createDialog BatchRename