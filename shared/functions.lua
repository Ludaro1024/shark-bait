function Config_Framework_Notify_Client(msg)
    ESX.ShowNotification(msg)
end

function Config_Framework_SetDead_Client()
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, 0.0, 0.0, 0.0, false, false, false, true) -- tp him to ambulance, (if oyu dont do this he will die on spot, and not be able to be revived probably)
    SetEntityHealth(playerPed, 0)
    --  TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)
end