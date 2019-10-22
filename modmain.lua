local assets =
{
    Asset("ANIM", "anim/lantern.zip"),
    Asset("ANIM", "anim/swap_lantern.zip"),
}

local function newLightup(inst)
    print("is Equipped?? -- in lightup ")
    print(inst.components.equippable:IsEquipped())
    if inst.components.fueled and inst.components.equippable:IsEquipped() then
        inst.components.fueled:StartConsuming()
    end

    inst.Light:Enable(true)
    inst.components.floatable:UpdateAnimations("idle_on_water", "idle_on")

    if inst.components.equippable:IsEquipped() then
        inst.components.inventoryitem.owner.AnimState:OverrideSymbol("swap_object", "swap_lantern", "swap_lantern_on")
        inst.components.inventoryitem.owner.AnimState:Show("LANTERN_OVERLAY")
    end
    inst.components.machine.ison = true

    inst.SoundEmitter:PlaySound("dontstarve/wilson/lantern_on")
    inst.SoundEmitter:PlaySound("dontstarve/wilson/lantern_LP", "loop")

    inst.components.inventoryitem:ChangeImageName("lantern_lit")
    --    if InfiniteLanternOn then
    --    end
end

local function newTurnon(inst)
    print("TURN ON!!!!!!!!")

    if not inst.components.fueled:IsEmpty() then
        if not inst.components.machine.ison then
            newLightup(inst)
        end
    end
end

local function newOnLoad(inst, data)
    print("ON LOAD!!!!!!!!")
    if inst.components.machine and inst.components.machine.ison then
        newLightup(inst)
    else
        turnoff(inst)
    end
end

local function newOnpickup(inst)
    print("ON PICK UP!!!!!!!!")
    newLightup(inst)
end

local function newTakeFuel(inst)
    print("TAKE FUEL!!!!!!!!")
    if inst.components.equippable and inst.components.equippable:IsEquipped() then
        newLightup(inst)
    end
end

AddPrefabPostInit("lantern", function(inst)
    inst.components.machine.turnonfn = newTurnon
    inst.components.fueled.ontakefuelfn = newTakeFuel
    inst.OnLoad = newOnLoad
    inst.components.inventoryitem:SetOnPickupFn(newOnpickup)
end)
