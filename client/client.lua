Citizen.CreateThread(function()
	while true do
		Wait(Config.RefreshTime)
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		local isinwater = IsPedSwimming(ped)
		local waterheight = PerformRaycastFromPed(ped)
		local indanger = isinwater and (waterheight or 0) >= Config.WaterHeight and GetVehiclePedIsIn(ped, false) == 0
		local inAttack = IsEntityPlayingAnim(ped, "creatures@shark@melee@streamed_core@", "attack_player", 3)
		-- Check if the player is in water and the water height is above the threshold
		print(indanger)
		if indanger then
			if DoesEntityExist(shark) then
			else
				shark = SpawnAgressiveShark(coords)
				Citizen.Wait(Config.TimeUntilAttack * 1000)
				if indanger then
					sharkAttack(shark)
				else
					Config_Framework_Notify_Client(Locale("sharkdespawned"))
					DespawnShark(shark)
				end
			end
		else
			if shark and not inAttack then
				DespawnShark(shark)
			end
		end
	end
end)

AddEventHandler("onResourceStop", function(resourceName)
	if resourceName == GetCurrentResourceName() then
		if DoesEntityExist(shark) then
			DespawnShark(shark)
		end
	end
end)

function sharkAttack(shark)
	local dict = "creatures@shark@move"
	local anim = "attack"
	local anim2 = "attack_player"
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Wait(1)
	end
	local ped = PlayerPedId()
	TaskPlayAnim(ped, dict, anim2, 8.0, 1.0, -1, 1, 0, 0, 0, 0)
	local model = GetHashKey("a_c_sharktiger")
	RequestModel(model)
	while not HasModelLoaded(model) do
		Wait(1)
	end
	local coords2 = GetEntityCoords(ped)
	local scene = NetworkCreateSynchronisedScene(
		coords2.x,
		coords2.y,
		coords2.z,
		GetEntityRotation(PlayerPedId()),
		2,
		true,
		false,
		1.0,
		0.0,
		1.0,
		-1,
		-1
	)
	NetworkAddSynchronisedSceneCamera(scene, dict, "attack_cam")
	NetworkAddPedToSynchronisedScene(shark, scene, dict, anim, 8.0, 8.0, 0, 0, 1.0, 1)
	NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, dict, "attack_player", 8.0, 8.0, 0.0, 0, 1.0, 1)
	NetworkStartSynchronisedScene(scene)
	Wait(0)
	local localScene = NetworkGetLocalSceneFromNetworkId(scene)
	Citizen.Wait(1000)
	DoScreenFadeOut(1000)
	Citizen.Wait(1000)
	repeat
		Wait(0)
	until GetSynchronizedScenePhase(localScene) >= 0.20
	makeBlood()
	repeat Wait(0) until GetSynchronizedScenePhase(localScene) >= 0.25
	ClearPedTasks(shark)
	TaskPlayAnim(shark, dict, "swim_turn_r", 8.0, 1.0, -1, 1, 0, 0, 0, 0)
	NetworkStopSynchronisedScene(scene)
	DespawnShark(shark, true)
	Citizen.Wait(1000)
	Config_Framework_SetDead_Client()
	DoScreenFadeIn(1000)
	attack = true
end

function makeBlood()
	-- dict = "core"
	-- name = "blood_shark_attack"
	-- coords = GetEntityCoords(PlayerPedId())
	-- x, y, z = table.unpack(coords)

	-- CreateThread(function()
	-- 	RequestNamedPtfxAsset(dict)
	-- 	-- Wait for the particle dictionary to load.
	-- 	while not HasNamedPtfxAssetLoaded(dict) do
	-- 		Citizen.Wait(0)
	-- 	end

	-- 	local a = 0
	-- 	while a < 4 do
	-- 		StartParticleFxNonLoopedAtCoord(name, x, y, z, 0.0, 0.0, 0.0, 0.2, false, false, false)

	-- 		a = a + 1

	-- 		-- Wait 500ms before triggering the next particle.
	-- 		Citizen.Wait(500)
	-- 	end
	-- end)
end

-- RegisterCommand('testan', function(source, args, rawCommand)
--     local dict = "creatures@shark@move"
--     local anim = "attack"

--     RequestAnimDict(dict)
--     while not HasAnimDictLoaded(dict) do
--         Wait(1)
--     end

--     local ped = PlayerPedId()

--     if DoesEntityExist(ped) then
--         TaskPlayAnim(ped, dict2, anim2, 8.0, 1.0, -1, 1, 0, 0, 0, 0)

--         local model = GetHashKey('a_c_sharktiger')
--         RequestModel(model)
--         while not HasModelLoaded(model) do
--             Wait(1)
--         end

--         local coords2 = GetEntityCoords(ped)
--         local shark = CreatePed(4, model, coords2.x, coords2.y, coords2.z, 0.0, true, true)

--         if DoesEntityExist(shark) then
--             -- Set the shark's health to a higher value to prevent it from dying
--             SetEntityHealth(shark, 200) -- Adjust the value as needed

--             local coords = GetEntityCoords(shark)
--             local scene = NetworkCreateSynchronisedScene(coords.x, coords.y, coords.z, GetEntityRotation(PlayerPedId()),
--                 2, true, false,
--                 1.0, 0.0, 1.0, -1, -1)

--             if scene ~= 0 then
--                 NetworkAddSynchronisedSceneCamera(scene, dict, "attack_cam")
--                 NetworkAddPedToSynchronisedScene(shark, scene, dict, anim, 8.0, 8.0, 0, 0, 1.0, 1)
--                 NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, dict, "attack_player", 8.0, 8.0, 0.0, 0, 1.0, 1)
--                 NetworkStartSynchronisedScene(scene)
--                 Wait(0)
--                 local localScene = NetworkGetLocalSceneFromNetworkId(scene)
--                 Citizen.Wait(1000)
--                 DoScreenFadeOut(1000)
--                 repeat
--                     Wait(0)
--                     -- print(GetSynchronizedScenePhase(localScene))
--                 until GetSynchronizedScenePhase(localScene) >= 0.25
--                 print("wat")
--                 ClearPedTasks(shark)
--                 TaskPlayAnim(shark, dict, "swim_turn_r", 8.0, 1.0, -1, 1, 0, 0, 0, 0)
--                 NetworkStopSynchronisedScene(scene)
--                 Citizen.Wait(1000)
--                 DoScreenFadeIn(1000)
--             else
--                 print("Failed to create synchronized scene")
--             end
--         else
--             print("Failed to create the shark ped.")
--         end
--     else
--         print("PlayerPedId() is invalid.")
--     end
-- end)

-- RegisterCommand('testan2', function(source, args, rawCommand)
--     dict = "creatures@shark@move"
--     anim = "attack"
--     dict2 = "creatures@shark@melee@streamed_core@"
--     anim2 = "attack_player"

--     RequestAnimDict(dict)
--     while not HasAnimDictLoaded(dict) do
--         Wait(1)
--     end

--     RequestAnimDict(dict2)
--     while not HasAnimDictLoaded(dict2) do
--         Wait(1)
--     end

--     local ped = PlayerPedId()

--     if DoesEntityExist(ped) then
--         TaskPlayAnim(ped, dict2, anim2, 8.0, 1.0, -1, 1, 0, 0, 0, 0)

--         local model = GetHashKey('a_c_sharktiger')
--         RequestModel(model)
--         while not HasModelLoaded(model) do
--             Wait(1)
--         end

--         local coords2 = GetEntityCoords(ped)
--         local shark = CreatePed(4, model, coords2.x, coords2.y, coords2.z, 0.0, true, true)

--         if DoesEntityExist(shark) then
--             -- Set the shark's health to a higher value to prevent it from dying
--             SetEntityHealth(shark, 200) -- Adjust the value as needed

--             local coords = GetEntityCoords(shark)
--             local scene = NetworkCreateSynchronisedScene(coords.x, coords.y, coords.z, GetEntityRotation(PlayerPedId()),
--                 2, true, false,
--                 1.0, 0.0, 1.0, -1, -1)

--             if scene ~= 0 then
--                 NetworkAddSynchronisedSceneCamera(scene, dict, "attack_cam")
--                 NetworkAddPedToSynchronisedScene(shark, scene, dict, anim, 8.0, 8.0,
--                     0)
--                 NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, dict, "attack_player", 8.0, 8.0, 0)
--                 NetworkStartSynchronisedScene(scene)
--                 TaskPlayAnim(shark, dict2, anim, 8.0, 1.0, -1, 1, 0, 0, 0, 0)
--                 Wait(0)
--                 local localScene = NetworkGetLocalSceneFromNetworkId(scene)
--                 repeat
--                     Wait(0)
--                     -- print(GetSynchronizedScenePhase(localScene))
--                 until GetSynchronizedScenePhase(localScene) >= 0.259
--                 ClearPedTasks(shark)
--                 TaskPlayAnim(shark, dict, "accelerate_turn_r", 8.0, 1.0, -1, 1, 0, 0, 0, 0)
--             end
--         end
--     end
-- end)

function DespawnShark(shark, attack)
	if DoesEntityExist(shark) == false then
		return
	end
	if attack == nil or false then
		Config_Framework_Notify_Client(Locale("sharkdespawned"))
	end
	TaskGoToCoordAnyMeans(shark, 0.0, 0.0, 0.0, 1.0, 0, false, 786603, 0xbf800000)
	RemoveBlip(aggresiveblip)
	Citizen.Wait(2000)
	DeleteEntity(shark)
	attack = nil
end

function SpawnAgressiveShark(coords)
	model = GetHashKey("a_c_sharktiger")
	RequestModel(model)
	while not HasModelLoaded(model) do
		Wait(1)
	end
	shark = CreatePed(4, model, coords.x + 5, coords.y + 5, coords.z - 5, 0.0, true, true)
	Config_Framework_Notify_Client(Locale("sharkspawned"))
	aggresiveblip = AddBlipForEntity(shark)
	SetBlipSprite(aggresiveblip, 68)
	SetBlipColour(aggresiveblip, 1)
	SetBlipScale(aggresiveblip, 0.8)
	SetBlipAsShortRange(aggresiveblip, false)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(Locale("sharkname"))
	EndTextCommandSetBlipName(aggresiveblip)
	TaskFollowToOffsetOfEntity(shark, PlayerPedId(), 5.0, 5.0, 0.0, 1, -1, 0.0, true)
	return shark
end

-- Function to perform a raycast from a ped downward and return the Z coordinate if it hits a surface
function PerformRaycastFromPed(ped)
	local playerPos = GetEntityCoords(ped, true)
	local startPoint = vector3(playerPos.x, playerPos.y, playerPos.z)    -- Adjust the starting height as needed
	local endPoint = vector3(playerPos.x, playerPos.y, playerPos.z - 250.0) -- A very large negative value

	local rayHandle = StartShapeTestRay(startPoint.x, startPoint.y, startPoint.z, endPoint.x, endPoint.y, endPoint.z, -1,
		ped, 0)
	local _, hit, hitCoords, _, _ = GetShapeTestResult(rayHandle)
	zone = GetNameOfZone(playerPos.x, playerPos.y, playerPos.z)
	if hit ~= 0 then
		-- A surface was hit
		return math.abs(hitCoords.z)
	elseif zone == "OCEANA" then
		return 300.0
	end
end

function Locale(msg)
	return Translation[Config.Locale][msg]
end
