local shown = false
local isPed = false
local isFreeAiming = false
local getSelectedWeapon = false
Citizen.CreateThread(function()
	while(true) do
		isPed = PlayerPedId()
		isFreeAiming = IsPlayerFreeAiming(PlayerId())
		getSelectedWeapon = GetSelectedPedWeapon(isPed) == GetHashKey(cfg.radargun)

		if shown then
			if getSelectedWeapon then
				if isFreeAiming then
					player = isPed
					coordA = GetOffsetFromEntityInWorldCoords(player, 0.0, 1.0, 1.0)
					coordB = GetOffsetFromEntityInWorldCoords(player, 0.0, 105.0, 0.0)
					frontcar = StartShapeTestCapsule(coordA, coordB, 3.0, 10, player, 7)
					a, b, c, d, e = GetShapeTestResult(frontcar)
					playerId = PlayerId()
					pos = GetEntityCoords(e)
				end
			end
		end
		Citizen.Wait(500)
	end
end)

Citizen.CreateThread( function()
	while true do
		Citizen.Wait(1)


		-- ////////////////////////////////////////////////////////////////
		-- DISABLE Attack/Weapon firing and MeleeAttackAlternate
		if getSelectedWeapon then
			DisableControlAction( 0, 24, true ) -- Attack
			DisablePlayerFiring(isPed, true ) -- Disable weapon firing
			DisableControlAction( 0, 142, true ) -- MeleeAttackAlternate
		end
		-- ////////////////////////////////////////////////////////////////


		if IsControlJustPressed(1, cfg.menuopen) then --246 = Y

			if getSelectedWeapon then
				if shown == true then
					shown = false
					SendNUIMessage({
						action = "close",
					})
				else
					SendNUIMessage({
						action = "open",
					})
					shown = true
				end
			else
				if shown == true then
					SendNUIMessage({
						action = "close",
					})
					shown = false
				end
			end
		end

		if shown then
			if getSelectedWeapon then
				if IsControlJustPressed(1, cfg.bottomfreeze) then --38 = E
					if IsEntityAVehicle(e) then
						if isFreeAiming then
							PlaySoundFrontend(-1, "5_Second_Timer", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", false)
							if cfg.metric == true then
								local fvspeed = GetEntitySpeed(e)*3.6  -- m/s to kmh
								SendNUIMessage({
									speed = math.ceil(fvspeed),
                                    range = GetDistanceBetweenCoords(GetEntityCoords(isPed),GetEntityCoords(e), true)
								})
							else
								local fvspeed = GetEntitySpeed(e)*2.23694 -- m/s to mph
								SendNUIMessage({
									speed = math.ceil(fvspeed),
                                    range = GetDistanceBetweenCoords(GetEntityCoords(isPed),GetEntityCoords(e), true)
								})
							end
						end
					end
				end
			end
		end
	end
end)