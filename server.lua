local Config = {
    SetWorldCommand = "setworld",
    GetWorldCommand = "getworld",
    Maximum = 100
}

local Text = function(playerId, text)
    TriggerClientEvent("worlds_management:client:text", playerId, text)
end

local CanUseCommand = function(command, playerId, targerId, worldId)

    if command == Config.SetWorldCommand then

        if type(targerId) ~= "number" or type(worldId) ~= "number" then
            Text(playerId, ("Usage: /%s [playerId] [worldId]"):format(command))
            Text(playerId, "[playerId] and [worldId] must be numbers.")
            return false
        elseif GetPlayerPed(targerId) == 0 then
            Text(playerId, "The player is not online.")
            return false
        elseif worldId > Config.Maximum or worldId < 0 then
            Text(playerId, ("World must be between 1 and %s."):format(Config.Maximum))
            return false
        elseif GetPlayerRoutingBucket(targerId) == worldId then
            Text(playerId, "The player is already in this world.")
            return false
        else
            return true
        end

    elseif command == Config.GetWorldCommand then

        if type(targerId) ~= "number" then
            Text(playerId, ("Usage: /%s [playerId]"):format(command))
            Text(playerId, "[playerId] must be a number.")
            return false
        elseif GetPlayerPed(targerId) == 0 then
            Text(playerId, "The player is not online.")
            return false
        else
            return true
        end

    else
        return false
    end
end

RegisterCommand(Config.SetWorldCommand, function(source, args)

    local playerId, targerId, worldId = source, tonumber(args[1]), tonumber(args[2])

    if CanUseCommand(Config.SetWorldCommand, playerId, targerId, worldId) then
        SetPlayerRoutingBucket(targerId, worldId)
        Text(playerId, ("You have placed %s in the world number %s."):format(GetPlayerName(targerId), worldId))
        Text(targerId, ("%s has placed you in the world number %s."):format(GetPlayerName(playerId), worldId))
    end
end)

RegisterCommand(Config.GetWorldCommand, function(source, args)

    local playerId = source
    local targerId = tonumber(args[1])

    if not targerId then
        local worldId = GetPlayerRoutingBucket(playerId)
        Text(playerId, ("You are in the world number %s."):format(worldId))
    else
        if CanUseCommand(Config.GetWorldCommand, playerId, targerId) then
            local worldId = GetPlayerRoutingBucket(targerId)
            Text(playerId, ("%s is in the world number %s."):format(GetPlayerName(targerId), worldId))

            if GetPlayerRoutingBucket(playerId) == worldId then
                Text(playerId, "You are in the same world.")
            end
        end
    end
end)