local function deleteVehicle(entity)
	local vehicle = Vehicle(entity)
	return vehicle and vehicle.store() or DeleteEntity(entity)
end

lib.addCommand('group.admin', 'car', function(source, args)
	local ped = GetPlayerPed(source)
	local entity = GetVehiclePedIsIn(ped)

	if entity then
		deleteVehicle(entity)
	end

	if args.owner and args.owner > 0 then
		args.owner = Player(args.owner)?.charid
	end

	local vehicle = Ox.CreateVehicle({
		owner = args.owner,
		model = args.model,
	}, GetEntityCoords(ped), GetEntityHeading(ped))

	for i = 1, 50 do
		Wait(0)
		SetPedIntoVehicle(ped, vehicle.entity, -1)

		if GetVehiclePedIsIn(ped, false) == vehicle.entity then
			break
		end
	end
end, {'model:string', 'owner:?number'})

lib.addCommand('group.admin', 'dv', function(source, args)
	local ped = GetPlayerPed(source)
	local entity = GetVehiclePedIsIn(ped)

	if entity > 0 then
		return deleteVehicle(entity)
	end

	local vehicles = lib.callback.await('ox:getNearbyVehicles', source, args.radius)

	for i = 1, #vehicles do
		entity = NetworkGetEntityFromNetworkId(vehicles[i])
		local vehicle = Vehicle(entity)

		if vehicle then
			if args.owned == 'true' then
				vehicle.store()
			end
		else
			DeleteEntity(entity)
		end
	end
end, {'radius:?number', 'owned:?string'})
