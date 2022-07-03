Client = {
	CHAR_SELECT = vec4(-558.3258, -3781.111, 237.60, 93.2),
	DEFAULT_SPAWN = vec4(-262.849, 793.404, 118.087, 0.0),
	spawnModel = `player_zero`,
}

-- Feat decompiled scripts
LoadCharSelectArea = function()
	RequestImap(-1699673416)
	RequestImap(1679934574)
	RequestImap(183712523)

	Citizen.InvokeNative(0xBE83CAE8ED77A94F, joaat("SUNNY"))
	Citizen.InvokeNative(0xE28C13ECC36FF14E, 10, 0, 0, 0, true)
	
	SetTimecycleModifier("Online_Character_Editor")
end

SetSession = function(state)
    if state then
        if not NetworkIsInTutorialSession() then
            NetworkStartSoloTutorialSession()
            print('Adding to session.')
        end
    else
        if NetworkIsInTutorialSession() then
            NetworkEndTutorialSession()
            print('Removing from session.')
        end
    end
end

AddEventHandler('onClientMapStart', function()
	exports.spawnmanager:spawnPlayer({
		x = Client.CHAR_SELECT.x,
		y = Client.CHAR_SELECT.y,
		z = Client.CHAR_SELECT.z,
		heading = Client.CHAR_SELECT.w,
		model = Client.spawnModel,
		skipFade = true,
	})

	exports.spawnmanager:setAutoSpawn(false) -- This is needed, when player dies (spawnmanager is not going to change player ped)
	
	SetSession(true) -- Load solo session for new player
	DisplayRadar(false) -- Disable radar for charSelect

	TriggerServerEvent('ox:playerJoined')
end)
