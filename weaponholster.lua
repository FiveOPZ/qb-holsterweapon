------------------------------------------------------------------------
--- DO NOT CHANGE ANYTHING BELOW IF YOU DON'T KNOW WHAT YOU'RE DOING ---
------------------------------------------------------------------------
local QBCore = exports['qb-core']:GetCoreObject()

local holstered  = true
local blocked	 = false

local Weapons = {
	'WEAPON_KNIFE',
    'WEAPON_NIGHTSTICK',
    'WEAPON_BREAD',
    'WEAPON_FLASHLIGHT',
    'WEAPON_HAMMER',
    'WEAPON_BAT',
    'WEAPON_GOLFCLUB',
    'WEAPON_CROWBAR',
    'WEAPON_BOTTLE',
    'WEAPON_DAGGER',
    'WEAPON_HATCHET',
    'WEAPON_MACHETE',
    'WEAPON_BATTLEAXE',
    'WEAPON_POOLCUE',
    'WEAPON_WRENCH',
    'WEAPON_PISTOL',
    'WEAPON_PISTOL_MK2',
    'WEAPON_COMBATPISTOL',
    'WEAPON_APPISTOL',
    'WEAPON_PISTOL50',
    'WEAPON_REVOLVER',
    'WEAPON_SNSPISTOL',
    'WEAPON_HEAVYPISTOL',
    'WEAPON_VINTAGEPISTOL',
    'WEAPON_MICROSMG',
    'WEAPON_SMG',
    'WEAPON_ASSAULTSMG',
    'WEAPON_MINISMG',
    'WEAPON_MACHINEPISTOL',
    'WEAPON_COMBATPDW',
    'WEAPON_PUMPSHOTGUN',
    'WEAPON_SAWNOFFSHOTGUN',
    'WEAPON_ASSAULTSHOTGUN',
    'WEAPON_BULLPUPSHOTGUN',
    'WEAPON_HEAVYSHOTGUN',
    'WEAPON_ASSAULTRIFLE',
    'WEAPON_CARBINERIFLE',
    'WEAPON_ADVANCEDRIFLE',
    'WEAPON_SPECIALCARBINE',
    'WEAPON_BULLPUPRIFLE',
    'WEAPON_COMPACTRIFLE',
    'WEAPON_MG',
    'WEAPON_COMBATMG',
    'WEAPON_GUSENBERG',
    'WEAPON_SNIPERRIFLE',
    'WEAPON_HEAVYSNIPER',
    'WEAPON_MARKSMANRIFLE',
    'WEAPON_GRENADELAUNCHER',
    'WEAPON_RPG',
    'WEAPON_STINGER',
    'WEAPON_MINIGUN',
    'WEAPON_GRENADE',
    'WEAPON_STICKYBOMB',
    'WEAPON_SMOKEGRENADE',
    'WEAPON_BZGAS',
    'WEAPON_MOLOTOV',
    'WEAPON_DIGISCANNER',
    'WEAPON_FIREWORK',
    'WEAPON_MUSKET',
    'WEAPON_STUNGUN',
    'WEAPON_HOMINGLAUNCHER',
    'WEAPON_PROXMINE',
    'WEAPON_FLAREGUN',
    'WEAPON_MARKSMANPISTOL',
    'WEAPON_RAILGUN',
    'WEAPON_DBSHOTGUN',
    'WEAPON_AUTOSHOTGUN',
    'WEAPON_COMPACTLAUNCHER',
    'WEAPON_PIPEBOMB',
    'WEAPON_DOUBLEACTION',
}

local isLoggedIn = false
local PlayerData = {}

AddStateBagChangeHandler('isLoggedIn', nil, function(_, _, value) -- FiveM native method
    if value then
        isLoggedIn = true
        PlayerData = QBCore.Functions.GetPlayerData()
    else
        isLoggedIn = false
        PlayerData = {}
    end
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
    PlayerData = val
end)

local function loadAnimDict(dict)
	while ( not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Wait(0)
	end
end

local function CheckWeapon(ped)
	if IsEntityDead(ped) then
		blocked = false
			return false
		else
			for i = 1, #Weapons do
				if GetHashKey(Weapons[i]) == GetSelectedPedWeapon(ped) then
					return true
				end
			end
		return false
	end
end

CreateThread(function()
	while true do
		Wait(0)
		loadAnimDict("rcmjosh4")
		loadAnimDict("reaction@intimidation@cop@unarmed")
		loadAnimDict("reaction@intimidation@1h")
		local ped = PlayerPedId()
		if PlayerData.job and PlayerData.job.name == 'police' then
			if not IsPedInAnyVehicle(ped, false) then
				if GetVehiclePedIsTryingToEnter (ped) == 0 and (GetPedParachuteState(ped) == -1 or GetPedParachuteState(ped) == 0) and not IsPedInParachuteFreeFall(ped) then
					if CheckWeapon(ped) then
						if holstered then
							blocked   = true
								SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
								TaskPlayAnim(ped, "reaction@intimidation@cop@unarmed", "intro", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 ) -- Change 50 to 30 if you want to stand still when removing weapon
									Wait(700)
								SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
								TaskPlayAnim(ped, "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
									Wait(400)
								ClearPedTasks(ped)
							holstered = false
						else
							blocked = false
						end
					else
						if not holstered then

								TaskPlayAnim(ped, "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
									Wait(500)
								TaskPlayAnim(ped, "reaction@intimidation@cop@unarmed", "outro", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 ) -- Change 50 to 30 if you want to stand still when holstering weapon
									Wait(60)
								ClearPedTasks(ped)
							holstered = true
						end
					end
				else
					SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
				end
			else
				holstered = true
			end
		else
			if not IsPedInAnyVehicle(ped, false) then
				if GetVehiclePedIsTryingToEnter (ped) == 0 and (GetPedParachuteState(ped) == -1 or GetPedParachuteState(ped) == 0) and not IsPedInParachuteFreeFall(ped) then
					if CheckWeapon(ped) then
						if holstered then
							blocked   = true
								SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
								TaskPlayAnim(ped, "reaction@intimidation@1h", "intro", 5.0, 1.0, -1, 50, 0, 0, 0, 0 )
									Wait(1250)
								SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
									Wait(1700)
								ClearPedTasks(ped)
							holstered = false
						else
							blocked = false
						end
					else
						if not holstered then
								TaskPlayAnim(ped, "reaction@intimidation@1h", "outro", 8.0, 3.0, -1, 50, 0, 0, 0.125, 0 ) -- Change 50 to 30 if you want to stand still when holstering weapon
									Wait(1700)
								ClearPedTasks(ped)
							holstered = true
						end
					end
				else
					SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
				end
			else
				holstered = true
			end
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		if blocked then
			DisableControlAction(1, 25, true )
			DisableControlAction(1, 140, true)
			DisableControlAction(1, 141, true)
			DisableControlAction(1, 142, true)
			DisableControlAction(1, 23, true)
			DisableControlAction(1, 37, true) -- Disables INPUT_SELECT_WEAPON (TAB)
			DisablePlayerFiring(ped, true) -- Disable weapon firing
		end
	end
end)
