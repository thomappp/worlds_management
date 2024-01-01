local Text = function(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(("~g~World: ~w~%s"):format(text))
    DrawNotification(true, true)
end

RegisterNetEvent("worlds_management:client:text")
AddEventHandler("worlds_management:client:text", function(text)
    Text(text)
end)
