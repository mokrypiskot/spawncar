--   ██████╗ █████╗ ██████╗     ███████╗██████╗  █████╗ ██╗    ██╗███╗   ██╗
--  ██╔════╝██╔══██╗██╔══██╗    ██╔════╝██╔══██╗██╔══██╗██║    ██║████╗  ██║
--  ██║     ███████║██████╔╝    ███████╗██████╔╝███████║██║ █╗ ██║██╔██╗ ██║
--  ██║     ██╔══██║██╔══██╗    ╚════██║██╔═══╝ ██╔══██║██║███╗██║██║╚██╗██║
--  ╚██████╗██║  ██║██║  ██║    ███████║██║     ██║  ██║╚███╔███╔╝██║ ╚████║

local spawnedVehicle = nil
--- local zone = {x = -1257.2124, y = -1479.1840, z = 4.3483, height = 25.0, radius = 25.0} - this is safezone

local function deleteVehicle(vehicle, reason)
    if DoesEntityExist(vehicle) then
        SetEntityAsMissionEntity(vehicle, true, true)
        DeleteVehicle(vehicle)
        TriggerEvent('pNotify:SendNotification', {
            text = "<b>Car has been despawned:</b> " .. reason,
            type = "error",
            timeout = 3000,
            layout = "centerLeft"
        })
    end
end

--  ███████╗██████╗  █████╗ ██╗    ██╗███╗   ██╗     ██████╗ ██████╗ ███╗   ███╗███╗   ███╗ █████╗ ███╗   ██╗██████╗ 
--  ██╔════╝██╔══██╗██╔══██╗██║    ██║████╗  ██║    ██╔════╝██╔═══██╗████╗ ████║████╗ ████║██╔══██╗████╗  ██║██╔══██╗
--  ███████╗██████╔╝███████║██║ █╗ ██║██╔██╗ ██║    ██║     ██║   ██║██╔████╔██║██╔████╔██║███████║██╔██╗ ██║██║  ██║
--  ╚════██║██╔═══╝ ██╔══██║██║███╗██║██║╚██╗██║    ██║     ██║   ██║██║╚██╔╝██║██║╚██╔╝██║██╔══██║██║╚██╗██║██║  ██║
--  ███████║██║     ██║  ██║╚███╔███╔╝██║ ╚████║    ╚██████╗╚██████╔╝██║ ╚═╝ ██║██║ ╚═╝ ██║██║  ██║██║ ╚████║██████╔╝

RegisterCommand("ridecar", function(source, args, rawCommand)
    if spawnedVehicle then
        deleteVehicle(spawnedVehicle, "Car has been despawned because you used command again")
        spawnedVehicle = nil
    end

    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

--  ██╗   ██╗███████╗██╗     ██╗ ██████╗██╗  ██╗██╗     ███████╗███████╗
--  ██║   ██║██╔════╝██║     ██║██╔════╝██║  ██║██║     ██╔════╝██╔════╝
--  ██║   ██║█████╗  ██║     ██║██║     ███████║██║     █████╗  ███████╗
--  ╚██╗ ██╔╝██╔══╝  ██║     ██║██║     ██╔══██║██║     ██╔══╝  ╚════██║
--   ╚████╔╝ ███████╗███████╗██║╚██████╗██║  ██║███████╗███████╗███████║    

    local vehicleModels = {"aviator", "amggtbs", "bm_rx7", "bmwm4", "demonhawk", "Drippysenna", "fenyrsupersport", "G632021", "gr23", "hellcat15w", "joem3", "MG63PxxBK", "rmodessenza", "SonicMustang", "xevanh", "uzir8"}
    
    local randomModel = vehicleModels[math.random(#vehicleModels)]

    RequestModel(randomModel)
    while not HasModelLoaded(randomModel) do
        Wait(10)
    end

    spawnedVehicle = CreateVehicle(GetHashKey(randomModel), coords.x + 2.0, coords.y, coords.z, GetEntityHeading(playerPed), true, false)
    SetPedIntoVehicle(playerPed, spawnedVehicle, -1)
    SetModelAsNoLongerNeeded(randomModel)

    TriggerEvent('pNotify:SendNotification', {
        text = "<b>Car has been spawned:</b> " .. randomModel,
        type = "success",
        timeout = 3000,
        layout = "centerLeft"
    })

    CreateThread(function()
        while spawnedVehicle do
            Wait(500)
            if not IsPedInVehicle(playerPed, spawnedVehicle, false) then
                deleteVehicle(spawnedVehicle, "You have left the velichle")
                spawnedVehicle = nil
            end
        end
    end)

    CreateThread(function()
        while spawnedVehicle do
            Wait(1000)
            local vehicleCoords = GetEntityCoords(spawnedVehicle)
            local distance = #(vector3(zone.x, zone.y, zone.z) - vehicleCoords)
            if distance <= zone.radius then
                deleteVehicle(spawnedVehicle, "You entered safe-zone")
                spawnedVehicle = nil
            end
        end
    end)
end)

--   ██████╗██████╗ ███████╗ █████╗ ████████╗███████╗██████╗     ██████╗ ██╗   ██╗    ███╗   ███╗ ██████╗ ██╗  ██╗██████╗ ██╗   ██╗██████╗ ██╗███████╗██╗  ██╗ ██████╗ ████████╗
--  ██╔════╝██╔══██╗██╔════╝██╔══██╗╚══██╔══╝██╔════╝██╔══██╗    ██╔══██╗╚██╗ ██╔╝    ████╗ ████║██╔═══██╗██║ ██╔╝██╔══██╗╚██╗ ██╔╝██╔══██╗██║██╔════╝██║ ██╔╝██╔═══██╗╚══██╔══╝
--  ██║     ██████╔╝█████╗  ███████║   ██║   █████╗  ██║  ██║    ██████╔╝ ╚████╔╝     ██╔████╔██║██║   ██║█████╔╝ ██████╔╝ ╚████╔╝ ██████╔╝██║███████╗█████╔╝ ██║   ██║   ██║   
--  ██║     ██╔══██╗██╔══╝  ██╔══██║   ██║   ██╔══╝  ██║  ██║    ██╔══██╗  ╚██╔╝      ██║╚██╔╝██║██║   ██║██╔═██╗ ██╔══██╗  ╚██╔╝  ██╔═══╝ ██║╚════██║██╔═██╗ ██║   ██║   ██║   
--  ╚██████╗██║  ██║███████╗██║  ██║   ██║   ███████╗██████╔╝    ██████╔╝   ██║       ██║ ╚═╝ ██║╚██████╔╝██║  ██╗██║  ██║   ██║   ██║     ██║███████║██║  ██╗╚██████╔╝   ██║   
--   ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═════╝     ╚═════╝    ╚═╝       ╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝ ╚═════╝    ╚═╝ 

-- Created by mokrypiskot