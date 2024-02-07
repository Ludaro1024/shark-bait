Citizen.CreateThread(function()
	while true do
		::checkagain::
		Wait(Config.RefreshTime * 1000)
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		local isinwater = IsPedSwimming(ped)
		local waterheight = PerformRaycastFromPed(ped)
		local indanger = isinwater and (waterheight or 0) >= Config.WaterHeight and GetVehiclePedIsIn(ped, false) == 0 and
			IsInConfigRange()
		local inAttack = IsEntityPlayingAnim(ped, "creatures@shark@melee@streamed_core@", "attack_player", 3)
		if Config.Debug then
			if indanger then
				local waterheight = PerformRaycastFromPed(ped)
				print("You are " ..
					math.round(waterheight) .. " m deep " .. "and in the danger zone! (" .. Config.WaterHeight .. "m)")
			elseif isinwater == false then
				print("You are not even in da water")
			else
				print("You are " ..
					math.round(waterheight) ..
					" m deep " .. "and not in the danger zone! (" .. Config.WaterHeight .. "m)")
			end
		end
		if indanger then
			if DoesEntityExist(shark) then
				DespawnShark(shark)
			else
				shark = SpawnAgressiveShark(coords)
				Citizen.Wait(Config.TimeUntilAttack * 1000)
				if indanger and isinwater then
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

function IsInConfigRange()
	for i = 1, #Config.Zones do
		if isInRange(Config.Zones[i][1], Config.Zones[i][2]) then
			return true
		end
	end
	return false
end

function isInRange(coords, range)
	local distance = #(GetEntityCoords(PlayerPedId()) - coords)
	return distance <= range
end

function sharkAttack(shark)
	waterheight = PerformRaycastFromPed(PlayerPedId())
	isinrange = (waterheight or 0) >= Config.WaterHeight
	if IsPedSwimming(PlayerPedId()) == false or isinrange == false then
		DespawnShark(shark, false)
		return
	end
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
	TaskGoToCoordAnyMeans(shark, 0.0, 0.0, 0.0, 1.0, 0, false, 786603, 0xbf800000)
	RemoveBlip(aggresiveblip)

	NetworkStopSynchronisedScene(scene)
	Citizen.Wait(1000)
	Config_Framework_SetDead_Client()
	DoScreenFadeIn(1000)
	Citizen.Wait(2000)
	DeleteEntity(shark)
	attack = nil
end

function DespawnShark(shark)
	if DoesEntityExist(shark) == false then
		return
	end
	Config_Framework_Notify_Client(Locale("sharkdespawned"))
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
