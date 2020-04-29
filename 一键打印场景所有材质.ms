-- Name：Print all materials for Scene
-- Author：Kakarrot
-- Time：2019.4.4

global PrintSceneMaterials
try(destroyDialog PrintSceneMaterials)catch()

rollout PrintSceneMaterials "JiXuan" width:210 height:100
(
	HyperLink 'website' "By:Kakarrot & 极渲染" pos:[5,10] width:150 height:15 color:(color 93 102 106) hovercolor:(color 120 170 207) visitedcolor:(color 93 102 106) address:"http://www.jixuanran.com" align:#left
	button 'btn1' "打印场景材质" pos:[5,30] width:90 height:25 align:#left
	label 'lab1' "点击按钮，在侦听器窗口查看结果。" pos:[5,70] width:192 height:13 align:#left
	
	local allMaterials = #()
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
	fn get_Mtls_mtl mtl =(
		for m in mtl do(
			if ClassOf m == Multimaterial then (get_Mtls_mtl m)
			else(append allMaterials m)
		)
	)
	
	on btn1 pressed do(
		get_allmaterials()
		print("场景材质：")
		print(allMaterials)
	)
)createdialog PrintSceneMaterials style:#(#style_minimizebox, #style_titlebar, #style_sysmenu)
