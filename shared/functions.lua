function Config_Framework_Notify_Client(msg)
    TriggerEvent('chatMessage', "SYSTEM", { 255, 0, 0 }, msg)
    -- ESX.ShowNotification(msg)
end

function Config_Framework_SetDead_Client()
    -- local playerPed = PlayerPedId()
    -- SetEntityCoords(playerPed, 0.0, 0.0, 0.0, false, false, false, true) -- tp him to ambulance, (if oyu dont do this he will die on spot, and not be able to be revived probably)
    -- SetEntityHealth(playerPed, 0)
    --  TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)

    -- in my example i will play an animation that sets him to a random beach (predefined coords), and then plays an animation of him waking up, (simulating he died in rp)
    -- but your free to do the other things explained above or whatever you want
    SetEntityCoords(PlayerPedId(), -2127.6650, -510.0569, 2.1578, false, false, false, true)
    SetEntityHeading(PlayerPedId(), 109.2602)
    local dict = "anim@scripted@heist@ig25_beach@male@"
    RequestAnimDict(dict)
    repeat Wait(0) until HasAnimDictLoaded(dict)

    local playerPos = GetEntityCoords(PlayerPedId())
    local playerHead = GetEntityHeading(PlayerPedId())

    local scene = NetworkCreateSynchronisedScene(playerPos.x, playerPos.y, playerPos.z - 2, 0.0, 0.0, playerHead, 2,
        false,
        false, 8.0, 1000.0, 1.0)
    NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, dict, "action", 1000.0, 8.0, 0, 0, 1000.0, 8192)
    NetworkAddSynchronisedSceneCamera(scene, dict, "action_camera")
    NetworkStartSynchronisedScene(scene)
end
