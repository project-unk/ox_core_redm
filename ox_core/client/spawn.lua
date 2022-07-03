local cam
local hidePlayer

RegisterNUICallback('ox:setCharacter', function(data, cb)
	cb(1)

	if type(data) == 'number' then
		data = player.appearance[data + 1]

		if data then
			print('TODO: setPlayerAppearance [ox:setCharacter]')
			hidePlayer = nil
		end
	else
		hidePlayer = true
	end
end)

RegisterNUICallback('ox:selectCharacter', function(data, cb)
	cb(1)

	if type(data) == 'number' then
		data += 1
		player.appearance = player.appearance[data]
		Wait(200)
		DoScreenFadeOut(200)
	end

	SetNuiFocus(false, false)
	TriggerServerEvent('ox:selectCharacter', data)
end)

RegisterNUICallback('ox:deleteCharacter', function(data, cb)
	cb(1)
	hidePlayer = true
	TriggerServerEvent('ox:deleteCharacter', data)
end)

RegisterNetEvent('ox:selectCharacter', function(characters)
	if GetIsLoadingScreenActive() then
		SendLoadingScreenMessage(json.encode({
			fullyLoaded = true
		}))

		ShutdownLoadingScreenNui()

		while GetIsLoadingScreenActive() do
			DoScreenFadeOut(0)
			Wait(0)
		end
	end

	while not IsScreenFadedOut() do
		DoScreenFadeOut(0)
		Wait(0)
	end

	if player.loaded then
		table.wipe(player)
		TriggerEvent('ox:playerLogout')
	end

	CreateThread(function()
		while not player.loaded do
			DisableAllControlActions(0)

			if hidePlayer then
				-- SetLocalPlayerInvisibleLocally(true)
			end

			Wait(0)
		end

		DoScreenFadeIn(200)
		SetMaxWantedLevel(0)
		
		NetworkSetFriendlyFireOption(true)
		SetRelationshipBetweenGroups(5, joaat("PLAYER"), joaat("PLAYER"))

		SetPlayerInvincible(cache.playerId, false)
	end)

	SetPlayerInvincible(cache.playerId, true)
	StartPlayerTeleport(cache.playerId, Client.DEFAULT_SPAWN.x, Client.DEFAULT_SPAWN.y, Client.DEFAULT_SPAWN.z, Client.DEFAULT_SPAWN.w, false, true)

	while IsPlayerTeleportActive() do Wait(0) end

	if characters[1]?.appearance then
		-- exports['fivem-appearance']:setPlayerAppearance(characters[1].appearance)
		print('TODO: setPlayerAppearance [ox:selectCharacter]')
	else
		hidePlayer = true
	end

	cache.ped = PlayerPedId()

	local offset = GetOffsetFromEntityInWorldCoords(cache.ped, 0.0, 4.7, 0.2)
	cam = CreateCameraWithParams('DEFAULT_SCRIPTED_CAMERA', offset.x, offset.y, offset.z, 0.0, 0.0, 0.0, 30.0, false, 0)

	SetCamActive(cam, true)
	RenderScriptCams(cam, false, 0, true, true)
	PointCamAtCoord(cam, Client.DEFAULT_SPAWN.x, Client.DEFAULT_SPAWN.y, Client.DEFAULT_SPAWN.z + 0.1)

	player.appearance = {}

	for i = 1, #characters do
		local character = characters[i]
		character.location = Citizen.InvokeNative(0x43AD8FC02B429D33, character.x, character.y, character.z, -1)
		player.appearance[i] = character.appearance
		character.appearance = nil
	end

	SendNUIMessage({
		action = 'sendCharacters',
		data = {
			characters = characters,
			maxSlots = Shared.CHARACTER_SLOTS
		}
	})

	DoScreenFadeIn(500)
	Wait(500)
	SetNuiFocus(true, true)
	SetNuiFocusKeepInput(false)
end)

RegisterNetEvent('ox:playerLoaded', function(data, spawn)
	Wait(500)
	RenderScriptCams(false, false, 0, true, true)
	DestroyCam(cam, false)
	cam = nil
	hidePlayer = nil


	if not player.appearance or not player.appearance.model then
		local p = promise.new()

		print('TODO: Load charcreator. [ox:playerLoaded]')
		
		p:resolve()

		Citizen.Await(p)
	end

	if not spawn then spawn = Client.DEFAULT_SPAWN end

	StartPlayerTeleport(cache.playerId, spawn.x, spawn.y, spawn.z, spawn.w, false, true)

	while IsPlayerTeleportActive() do Wait(0) end

	
	SetSession(false)
	DisplayRadar(true)

	SetPlayerData(data)
	
	print('User is spawned.')
	
	cache.ped = PlayerPedId()

	if player.dead then
		OnPlayerDeath(true)
	end

	while player.loaded do
		Wait(200)
		cache.ped = PlayerPedId()

		if not player.dead and IsPedDeadOrDying(cache.ped) then
			OnPlayerDeath()
		end
	end
end)
