Citizen.CreateThread(function()
    while true do
        Wait(1000)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local isinwater = IsPedSwimming(ped)
        local waterheight = PerformRaycastFromPed(ped)
        -- Check if the player is in water and the water height is above the threshold
        if isinwater and (waterheight or 0 >= Config.WaterHeight or waterheight == 0.0) then
            print("Player is in water.")
            if DoesEntityExist(shark) then
                print("Shark already exists.")
            else
                local shark = SpawnAgressiveShark(coords)
                if shark then
                    print("Aggressive shark spawned.")
                    TaskCombatPed(shark, ped, 0, 16)
                    SetPedRelationshipGroupHash(shark, GetHashKey("SHARK"))
                    SetRelationshipBetweenGroups(5, GetHashKey("SHARK"), GetHashKey("PLAYER"))
                    SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), GetHashKey("SHARK"))
                    SetRelationshipBetweenGroups(5, GetHashKey("SHARK"), GetHashKey("CIVMALE"))
                end
            end
        end
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        if DoesEntityExist(shark) then
            DeleteEntity(shark)
        end
    end
end)

function sharkAttack(coords, shark)
    -- SetPedCombatAttributes(shark, 55, true)
    -- maybe
    -- dict = "creatures@shark@move"
    -- anim = "attack_jump"
    dict = "creatures@shark@melee@streamed_core@"
    anim = "attack"
    dict2 = "creatures@shark@move"
    anim2 = "attack_player"
    anim3 = "attack_cam"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(1)
    end

    RequestAnimDict(dict2)
    while not HasAnimDictLoaded(dict2) do
        Wait(1)
    end

    -- scene = NetworkCreateSynchronisedScene(coords.x, coords.y, coords.z, GetEntityRotation(PlayerPedId()), 2, false, true,
    --     1.0, 0.0,
    --     1000.0)
    -- NetworkAttachSynchronisedSceneToEntity(scene, shark, 0)
    -- NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, dict2, anim2, 1.0, -1.0, -1, 0, 0, 0)
    -- NetworkAddPedToSynchronisedScene(shark, scene, dict, anim, 1.0, -1.0, -1, 0, 0, 0)
    -- AttachEntityToEntity(shark, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0x2e28), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
    --     false,
    --     false, false, false, 2, true)
    -- NetworkStartSynchronisedScene(scene)
    -- localScene = NetworkGetLocalSceneFromNetworkId(scene)
    -- repeat Wait(0) until not IsSynchronizedSceneRunning(localScene)
    -- Citizen.Wait(3000)
    -- DetachEntity(shark, true, false)
    -- ClearPedTasksImmediately(shark)
    -- ClearPedTasksImmediately(PlayerPedId())
    -- -- blood here
    -- Citizen.Wait(2000)
    -- DoScreenFadeOut(1000)
    -- Wait(1000)

    -- Wait(2000)
    -- Wait(1000)
    -- DoScreenFadeIn(1000)

    scene = NetworkCreateSynchronisedScene(coords.x, coords.y, coords.z, GetEntityRotation(PlayerPedId()), 2, false, true,
        1.0, 0.0,
        1000.0)
    NetworkAttachSynchronisedSceneToEntity(scene, shark, 0)
    NetworkAttachSynchronisedSceneToEntity(scene, PlayerPedId(), 0) -- maybe not needed or wrong
    NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, dict2, anim2, 1.0, -1.0, -1, 0, 0, 0)
    NetworkAddPedToSynchronisedScene(shark, scene, dict, anim, 1.0, -1.0, -1, 0, 0, 0)
    NetworkAddSynchronisedSceneCamera(scene, GetHashKey(dict2), anim3, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0,
        0.0)
    NetworkStartSynchronisedScene(scene)
    localScene = NetworkGetLocalSceneFromNetworkId(scene)
    repeat Wait(0) until not IsSynchronizedSceneRunning(localScene)
    Citizen.Wait(3000)
    ClearPedTasksImmediately(shark)
    ClearPedTasksImmediately(PlayerPedId())
    -- blood here
end

function SpawnAgressiveShark(coords)
    print("spawning shark")
    model = GetHashKey('a_c_sharktiger')
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1)
    end
    shark = CreatePed(4, model, coords.x, coords.y, coords.z - 5, 0.0, true, true)
    sharkAttack(coords, shark)
    -- GiveWeaponToPed(shark, GetHashKey("WEAPON_BITE"), 1, true, true)
    -- SetEntityInvincible(shark, true)
    -- TaskCombatPed(shark, ped, 0, 16)
    -- FreezeEntityPosition(shark, false)
    -- SetPedNeverLeavesGroup(shark, false)
    -- SetPedConfigFlag(shark, 36, 0)
    -- SetPedConfigFlag(shark, 56, 1)
    -- SetPedConfigFlag(shark, 56, true)
    -- SetPedCombatAttributes(shark, 5, true)
    -- SetPedCombatAttributes(shark, 16, true)






    -- ClearPedSecondaryTask(PlayerPedId())
    -- StopAnimTask(PlayerPedId(), dictionary, animation, 1.0)
    -- SetPedNeverLeavesGroup(shark, false)
    -- ClearPedTasksImmediately(shark)
    -- SetBlockingOfNonTemporaryEvents(shark, true)
    -- SetPedFleeAttributes(shark, 0, 0)
    -- TaskCombatPed(shark, PlayerPedId(), 0, 16)
    -- ClearPedTasksImmediately()
    -- SetPedRelationshipGroupHash(shark, GetHashKey("SHARK"))
    -- Citizen.Wait(2000)
    -- lib = "cc"
    -- anim = "attack"

    -- RequestAnimDict(lib)
    -- while not HasAnimDictLoaded(lib) do
    --     Citizen.Wait(100)
    -- end
    -- print("anim loaded")
    -- TaskPlayAnim(shark, lib, anim, 8.0, 1.0, -1, 1, 0, 0, 0, 0)
end

-- Function to perform a raycast from a ped downward and return the Z coordinate if it hits a surface
function PerformRaycastFromPed(ped)
    local playerPos = GetEntityCoords(ped, true)
    local startPoint = vector3(playerPos.x, playerPos.y, playerPos.z)         -- Adjust the starting height as needed
    local endPoint = vector3(playerPos.x, playerPos.y, playerPos.z - 10000.0) -- Adjust the ray length as needed

    local rayHandle = StartShapeTestRay(startPoint.x, startPoint.y, startPoint.z, endPoint.x, endPoint.y, endPoint.z, -1,
        ped, 0)
    local _, hit, hitCoords, _, _ = GetShapeTestResult(rayHandle)

    if hit then
        -- A surface was hit
        return math.abs(hitCoords.z)
    else
        -- Raycast did not hit anything
        return 0
    end
end

Citizen.CreateThread(function()
    ped = shark
    SetPedRelationshipGroupHash(ped, GetHashKey("HATES_PLAYER"))
end)


RegisterCommand('tests', function(source, args, rawCommand)
    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_SHARK_SWIM", 0, true)
end)
