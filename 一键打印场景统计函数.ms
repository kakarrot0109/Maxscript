-- Name：Print all Statistics for Scene
-- Author：Kakarrot
-- Time：2019.4.4

global PrintSceneStatistics
try(destroyDialog PrintSceneStatistics)catch()

rollout PrintSceneStatistics "JiXuan" width:210 height:100
(
	HyperLink 'website' "By:Kakarrot & 极渲染" pos:[5,10] width:150 height:15 color:(color 93 102 106) hovercolor:(color 120 170 207) visitedcolor:(color 93 102 106) address:"http://www.jixuanran.com" align:#left
	button 'btn1' "物体类型数量" pos:[5,30] width:90 height:25 align:#left
	button 'btn2' "材质类型数量" pos:[105,30] width:90 height:25 align:#left
	label 'lab1' "点击按钮，在侦听器窗口查看结果。" pos:[5,70] width:192 height:13 align:#left

	fn statistics obj =
	(
		local allClass = #()
		local allString = ""
		for i in obj do appendIfUnique allClass (classof i)
		for i in allClass do 
		(
			local mats = for m in obj where classof m == i collect m
			format "类型:% 总数:%\n" i mats.count
			-- allString += ("类型:" + (i as string) + "数量：" + (mats.count as string)) + "\n"
		)
		-- return allString
	)

	local str = "-----"
	
	on btn1 pressed do
	(
		print("物体统计：")
		statistics objects
		print(str)
	)
	on btn2 pressed do
	(
		print("材质统计：")
		statistics scenematerials
		print(str)
	)
)createdialog PrintSceneStatistics style:#(#style_minimizebox, #style_titlebar, #style_sysmenu)
