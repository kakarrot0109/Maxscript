-- Name：HideOrShow Texture
-- Author：Kakarrot
-- Time：2019.4.4

global HideOrShowTexture
try(destroyDialog HideOrShowTexture)catch()


rollout HideOrShowTexture "JiXuan" width:210 height:70
(
	HyperLink 'website' "By:Kakarrot & 极渲染" pos:[5,10] width:150 height:15 color:(color 93 102 106) hovercolor:(color 120 170 207) visitedcolor:(color 93 102 106) address:"http://www.jixuanran.com" align:#left
	button 'btn1' "显示贴图" pos:[5,30] width:90 height:25 align:#left
	button 'btn2' "隐藏贴图" pos:[105,30] width:90 height:25 align:#left
	
	fn ShowTextures newState =
	(
		for matClass in material.classes do (
			for m in (getclassinstances matClass processChildren:true) do (
				if (refs.dependentNodes m).count>0 then (
					if classof m != Multimaterial then showTexturemap m newState
				)
			)
		)
	)
    on btn1 pressed do(
        ShowTextures true
    )
    on btn2 pressed do(
        ShowTextures false
    )
)
createdialog HideOrShowTexture style:#(#style_minimizebox, #style_titlebar, #style_sysmenu)
