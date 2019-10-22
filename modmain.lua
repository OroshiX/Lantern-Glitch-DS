local function newTurnon(inst)
    if not inst.components.fueled:IsEmpty() then
        if not inst.components.machine.ison then
            if inst.components.fueled then
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
        end
    end
end

local function newTurnoff(inst)
    if inst.components.fueled then
        inst.components.fueled:StopConsuming()
    end

    inst.Light:Enable(false)
    inst.components.floatable:UpdateAnimations("idle_off_water", "idle_off")

    if inst.components.equippable:IsEquipped() then
        inst.components.inventoryitem.owner.AnimState:OverrideSymbol("swap_object", "swap_lantern", "swap_lantern_off")
        inst.components.inventoryitem.owner.AnimState:Hide("LANTERN_OVERLAY")
    end

    inst.components.machine.ison = false

    inst.SoundEmitter:KillSound("loop")
    inst.SoundEmitter:PlaySound("dontstarve/wilson/lantern_off")

    inst.components.inventoryitem:ChangeImageName("lantern")
end

local function newOnLoad(inst, data)
    if inst.components.machine and inst.components.machine.ison then
        newTurnon(inst)
    else
        newTurnoff(inst)
    end
end

local function newOndropped(inst)
    newTurnoff(inst)
    newTurnon(inst)
end

local function newOnpickup(inst)
    newTurnon(inst)
end

local function newOnputininventory(inst)
    newTurnoff(inst)
end

--
local function newOnequip(inst, owner)
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    owner.AnimState:OverrideSymbol("lantern_overlay", "swap_lantern", "lantern_overlay")

    if inst.components.fueled:IsEmpty() then
        owner.AnimState:OverrideSymbol("swap_object", "swap_lantern", "swap_lantern_off")
        owner.AnimState:Hide("LANTERN_OVERLAY")
    else
        owner.AnimState:OverrideSymbol("swap_object", "swap_lantern", "swap_lantern_on")
        owner.AnimState:Show("LANTERN_OVERLAY")
    end
    newTurnon(inst)
end

local function newOnunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    owner.AnimState:ClearOverrideSymbol("lantern_overlay")
    owner.AnimState:Hide("LANTERN_OVERLAY")
end

local function newNofuel(inst)
    local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
    if owner then
        owner:PushEvent("torchranout", { torch = inst })
    end

    newTurnoff(inst)
end

local function newTakefuel(inst)
    if inst.components.equippable and inst.components.equippable:IsEquipped() then
        newTurnon(inst)
    end
end
local function lerp(pos1, pos2, perc)
    return (1-perc)*pos1 + perc*pos2 -- Linear Interpolation
end

local function newFuelupdate(inst)
    local fuelpercent = inst.components.fueled:GetPercent()
    inst.Light:SetIntensity(lerp(0.4, 0.6, fuelpercent))
    inst.Light:SetRadius(lerp(3, 5, fuelpercent))
    inst.Light:SetFalloff(.9)
end

AddPrefabPostInit("lantern", function(inst)
    inst.components.fueled:SetUpdateFn(newFuelupdate)
    inst.components.fueled:SetDepletedFn(newNofuel)
    inst.components.inventoryitem:SetOnDroppedFn(newOndropped)
    inst.components.equippable:SetOnEquip(newOnequip)
    inst.OnLoad = newOnLoad
    inst.components.inventoryitem:SetOnPickupFn(newOnpickup)
    inst.components.inventoryitem:SetOnPutInInventoryFn(newOnputininventory)
    inst.components.equippable:SetOnUnequip(newOnunequip)
    inst.components.fueled.ontakefuelfn = newTakefuel
    inst.components.machine.turnofffn = newTurnoff
    inst.components.machine.turnonfn = newTurnon
    inst:ListenForEvent("startrowing", function(inst, data)
        --print("start rowing!!")
        newTurnoff(inst)
    end, inst)
    inst:ListenForEvent("stoprowing", function(inst, data)
        --print("stop rowing!!")
        newTurnon(inst)
    end, inst)

end)
