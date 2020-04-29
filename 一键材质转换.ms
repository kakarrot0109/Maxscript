-- Name：Converter Materials
-- Author：Kakarrot
-- Time：2019.4.23

global ConverterMaterials
try(destroyDialog ConverterMaterials)catch()

rollout ConverterMaterials "JiXuan" width:210 height:70
(
	HyperLink 'website' "By:Kakarrot & 极渲染" pos:[5,10] width:150 height:15 color:(color 93 102 106) hovercolor:(color 120 170 207) visitedcolor:(color 93 102 106) address:"http://www.jixuanran.com" align:#left
	button 'btn1' "标准 > vRay" pos:[5,30] width:90 height:25 align:#left
    button 'btn2' "vRay > 标准" pos:[105,30] width:90 height:25 align:#left
    

	fn renderer_name =(
		if matchPattern (renderers.current as string) pattern:"V_ray*" then true
		else false
	)

    fn minus all arr =(	
        local a=all.count
        local b=arr.count
        for i=1 to b do(	
            for j=all.count to 1 by -1 do(		
                if all[j]==arr[i] do deleteItem all j
            )
        ) 
        return all
    )

    fn StandardToVRayMtl mtl =(
        local vm=VRayMtl()
        vm.name=mtl.name
        vm.diffuse=mtl.diffuse
        if mtl.diffuseMap != undefined then(
            vm.texmap_diffuse=mtl.diffuseMap
            vm.texmap_diffuse_on=mtl.diffuseMapEnable
            vm.texmap_diffuse_multiplier=mtl.diffuseMapAmount
        )
        if mtl.bumpMap != undefined then(
            vm.texmap_bump=mtl.bumpMap
            vm.texmap_bump_on=mtl.bumpMapEnable
            vm.texmap_bump_multiplier=mtl.bumpMapAmount
        )
        if mtl.displacementMap != undefined then (
            vm.texmap_displacement=mtl.displacementMap
            vm.texmap_displacement_on=mtl.displacementMapEnable
            vm.texmap_displacement_multiplier=mtl.displacementMapAmount
        )
        if mtl.opacityMap != undefined then(
            vm.texmap_opacity=mtl.opacityMap
            vm.texmap_opacity_on=mtl.opacityMapEnable
            vm.texmap_opacity_multiplier=mtl.opacityMapAmount
        )
        return vm
    )

    fn VRayMtlToStandard mtl =(
        local sm=Standard ()
        sm.name=mtl.name
        sm.diffuse=mtl.diffuse
        if mtl.texmap_bump != undefined then(
            sm.bumpMap = mtl.texmap_bump
            sm.bumpMapEnable = mtl.texmap_bump_on
            sm.bumpMapAmount=mtl.texmap_bump_multiplier
        )
        if mtl.texmap_displacement != undefined then(
            sm.displacementMap=mtl.texmap_displacement
            sm.displacementMapEnable=mtl.texmap_displacement_on
            sm.displacementMapAmount=mtl.texmap_displacement_multiplier
        )
        if mtl.texmap_diffuse != undefined then(
            sm.diffuseMap=mtl.texmap_diffuse
            sm.diffuseMapEnable=mtl.texmap_diffuse_on
            sm.diffuseMapAmount=mtl.texmap_diffuse_multiplier
        )
        if mtl.texmap_opacity != undefined then(
            sm.opacityMap=mtl.texmap_opacity
            sm.opacityMapEnable=mtl.texmap_opacity_on
            sm.opacityMapAmount=mtl.texmap_opacity_multiplier
        )
        return sm
    )

    fn CreateVRaymtl mtl =(	
        if classof mtl == Standardmaterial then mtl = StandardToVRayMtl mtl
        if classof mtl == Multimaterial then
        (	num = getNumSubMtls mtl
            for i=1 to num do (
                setSubMtl mtl i (CreateVRaymtl (getSubMtl mtl i))
            )
        )
        mtl
    )

    fn CreateStandard mtl =(	
        if classof mtl == VRayMtl then mtl = VRayMtlToStandard mtl
        if classof mtl == Multimaterial then
        (	num = getNumSubMtls mtl
            for i=1 to num do (
                setSubMtl mtl i (CreateStandard (getSubMtl mtl i))
            )
        )
        mtl
    )

    fn vrayTostandard objs libs =(	
        local mtl,obj=#()
        for i in libs do
        (	mtl = CreateStandard i
            for o in objs do
            (	if o.material==i then
                ( 	o.material = mtl
                    append obj o
                )
            )
            objs = minus objs obj 
            obj=#()
        )
    )

    fn standardTovray objs libs =(	
        local mtl ,obj=#()
        for i in libs do
        (	mtl = CreateVRaymtl i
            for o in objs do
            (	if o.material==i then
                ( 	o.material = mtl
                    append obj o
                )
            )
            objs = minus objs obj 
            obj=#()
        )
    )

	on btn1 pressed do(	
		if renderer_name() then(		
            sceneobjs = for i in objects where i.material != undefiend collect i
            scenemtls = for m in scenematerials where classof m == Standardmaterial or classof m == Multimaterial collect m
            if scenemtls.count != 0 then(
                standardTovray sceneobjs scenemtls
            )
            else messagebox "场景中没有材质！" title:"JiXuan"
		)
		else messagebox "请切换vRay渲染器！"
    )
    
	on btn2 pressed do(	
		if renderer_name() then(	
            sceneobjs = for i in objects where i.material != undefiend collect i
            scenemtls = for m in scenematerials where classof m == VRayMtl or classof m == Multimaterial collect m
            if scenemtls.count != 0 then(
                vrayTostandard sceneobjs scenemtls
            )
            else messagebox "场景中没有材质！" title:"JiXuan"
        )
		else messagebox "请切换vRay渲染器！"
	)
)createdialog ConverterMaterials