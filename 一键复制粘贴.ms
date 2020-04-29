-- Name：Copy Object
-- Author：Kakarrot
-- Time：2019.4.4

global CopyObject
try(destroyDialog CopyObject)catch()

rollout CopyObject "JiXuan" width:210 height:70
(
	HyperLink 'website' "By:Kakarrot & 极渲染" pos:[5,10] width:150 height:15 color:(color 93 102 106) hovercolor:(color 120 170 207) visitedcolor:(color 93 102 106) address:"http://www.jixuanran.com" align:#left
	button 'btn1' "复制模型" pos:[5,30] width:90 height:25 align:#left
	button 'btn2' "粘贴模型" pos:[105,30] width:90 height:25 align:#left
	
	on btn1 pressed do
	(
		thecopypastedir = getdir #autoback -- 将此更改为您想要的任何文件夹
		thecopypastefile = "\pastefile.max" --这是要保存为的文件名...
		thecopypastestring = thecopypastedir + thecopypastefile --这是完整的字符串
		
		if $ != undefined do 
			saveNodes $ thecopypastestring --这将对象保存（“复制”）为文件
		)
	on btn2 pressed do
	(
		thecopypastedir = getdir #autoback -- 将此更改为您想要的任何文件夹
		thecopypastefile = "\pastefile.max" --这是要保存为的文件名...
		thecopypastestring = thecopypastedir + thecopypastefile --这是完整的字符串
		mergemaxfile (thecopypastedir + thecopypastefile) #select --这合并（“粘贴”）并从文件中选择对象
		)
)
createdialog CopyObject style:#(#style_minimizebox, #style_titlebar, #style_sysmenu)
