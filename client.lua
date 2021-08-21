local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil
local HasAlreadyGotMessage = false
local display = false

--doors
local isopenleftfrontdoor = false
local isopenrightfrontdoor = false
local isopenleftreardoor = false
local isopenrightreardoor = false

local isopenFrontHood = false
local isopenRearHood = false
local isopenRearHood2 = false

local engine = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNUICallback("exit", function(data)
    SetDisplay(false)
end)

--open doors
RegisterNUICallback("openfleft", function(data)
    if isopenleftfrontdoor == false then
        isopenleftfrontdoor = true
        opendoors(0)
    else
        isopenleftfrontdoor = false
        closedoors(0)
    end
end)
RegisterNUICallback("openfright", function(data)
    if isopenrightfrontdoor == false then
        isopenrightfrontdoor = true
        opendoors(1)
    else
        isopenrightfrontdoor = false
        closedoors(1)
    end
end)
RegisterNUICallback("openRleft", function(data)
    if isopenleftreardoor == false then
        isopenleftreardoor = true
        opendoors(2)
    else
        isopenleftreardoor = false
        closedoors(2)
    end
end)
RegisterNUICallback("openRright", function(data)
    if isopenrightreardoor == false then
        isopenrightreardoor = true
        opendoors(3)
    else
        isopenrightreardoor = false
        closedoors(3)
    end
end)

--seat
RegisterNUICallback("setone", function(data)
    setseat(-1)
end)
RegisterNUICallback("settwo", function(data)
    setseat(0)
end)
RegisterNUICallback("setthree", function(data)
    setseat(1)
end)
RegisterNUICallback("setfour", function(data)
    setseat(2)
end)

--window
RegisterNUICallback("windowone", function(data)
    WindowControl(0, 0)
end)
RegisterNUICallback("windowtwo", function(data)
    WindowControl(1, 1)
end)
RegisterNUICallback("windowthree", function(data)
    WindowControl(2, 2)
end)
RegisterNUICallback("windowfour", function(data)
    WindowControl(3, 3)
end)

--extras
RegisterNUICallback("interiorLight", function()
	InteriorLightControl()
end)
RegisterNUICallback("extrasFrontHood", function() 
    if isopenFrontHood == false then
        isopenFrontHood = true
        opendoors(4)
    else
        isopenFrontHood = false
        closedoors(4)
    end
end)
RegisterNUICallback("extrasRearHood", function() 
    if isopenRearHood == false then
        isopenRearHood = true
        opendoors(5)
    else
        isopenRearHood = false
        closedoors(5)
    end
end)
RegisterNUICallback("extrasRearHood2", function() 
    if isopenRearHood2 == false then
        isopenRearHood2 = true
        opendoors(6)
    else
        isopenRearHood2 = false
        closedoors(6)
    end
end)

function setseat(seat)
    local playerPed = GetPlayerPed(-1)
	if (IsPedSittingInAnyVehicle(playerPed)) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		if IsVehicleSeatFree(vehicle, seat) then
			SetPedIntoVehicle(GetPlayerPed(-1), vehicle, seat)
		end
	end
end

function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
end

Citizen.CreateThread(function()
    while true do
        local coords = GetEntityCoords(PlayerPedId())
        local playerPed = GetPlayerPed(-1)
        if IsControlJustReleased(0, Keys['F5']) and IsPedSittingInAnyVehicle(playerPed) then
            SetDisplay(true)
        end

        if IsControlJustReleased(0, Keys['L']) then
            EngineControl()
        end
        Citizen.Wait(1)
    end
end)

Citizen.CreateThread(function()
    while display do
        Citizen.Wait(0)
        DisableControlAction(0, 1, display) -- LookLeftRight
        DisableControlAction(0, 2, display) -- LookUpDown
        DisableControlAction(0, 142, display) -- MeleeAttackAlternate
        DisableControlAction(0, 18, display) -- Enter
        DisableControlAction(0, 322, display) -- ESC
        DisableControlAction(0, 106, display) -- VehicleMouseControlOverride
    end
end)

function InteriorLightControl()
	local playerPed = GetPlayerPed(-1)
	if (IsPedSittingInAnyVehicle(playerPed)) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		if IsVehicleInteriorLightOn(vehicle) then
			SetVehicleInteriorlight(vehicle, false)
		else
			SetVehicleInteriorlight(vehicle, true)
		end
	end
end

function EngineControl()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
        SetVehicleEngineOn(vehicle, (not GetIsVehicleEngineRunning(vehicle)), false, true)
    end
end

function opendoors(door)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    SetVehicleDoorOpen(vehicle, door, false)
end

function closedoors(door)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    SetVehicleDoorShut(vehicle, door, false)
end

function WindowControl(window, door)
	local playerPed = GetPlayerPed(-1)
	if (IsPedSittingInAnyVehicle(playerPed)) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		if window == 0 then
			if windowState1 == true and DoesVehicleHaveDoor(vehicle, door) then
				RollDownWindow(vehicle, window)
				windowState1 = false
			else
				RollUpWindow(vehicle, window)
				windowState1 = true
			end
		elseif window == 1 then
			if windowState2 == true and DoesVehicleHaveDoor(vehicle, door) then
				RollDownWindow(vehicle, window)
				windowState2 = false
			else
				RollUpWindow(vehicle, window)
				windowState2 = true
			end
		elseif window == 2 then
			if windowState3 == true and DoesVehicleHaveDoor(vehicle, door) then
				RollDownWindow(vehicle, window)
				windowState3 = false
			else
				RollUpWindow(vehicle, window)
				windowState3 = true
			end
		elseif window == 3 then
			if windowState4 == true and DoesVehicleHaveDoor(vehicle, door) then
				RollDownWindow(vehicle, window)
				windowState4 = false
			else
				RollUpWindow(vehicle, window)
				windowState4 = true
			end
		end
	end
end

function FrontWindowControl()
	local playerPed = GetPlayerPed(-1)
	if (IsPedSittingInAnyVehicle(playerPed)) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		if windowState1 == true or windowState2 == true then
			RollDownWindow(vehicle, 0)
			RollDownWindow(vehicle, 1)
			windowState1 = false
			windowState2 = false
		else
			RollUpWindow(vehicle, 0)
			RollUpWindow(vehicle, 1)
			windowState1 = true
			windowState2 = true
		end
	end
end

function BackWindowControl()
	local playerPed = GetPlayerPed(-1)
	if (IsPedSittingInAnyVehicle(playerPed)) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		if windowState3 == true or windowState4 == true then
			RollDownWindow(vehicle, 2)
			RollDownWindow(vehicle, 3)
			windowState3 = false
			windowState4 = false
		else
			RollUpWindow(vehicle, 2)
			RollUpWindow(vehicle, 3)
			windowState3 = true
			windowState4 = true
		end
	end
end

function AllWindowControl()
	local playerPed = GetPlayerPed(-1)
	if (IsPedSittingInAnyVehicle(playerPed)) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		if windowState1 == true or windowState2 == true or windowState3 == true or windowState4 == true then
			RollDownWindow(vehicle, 0)
			RollDownWindow(vehicle, 1)
			RollDownWindow(vehicle, 2)
			RollDownWindow(vehicle, 3)
			windowState1 = false
			windowState2 = false
			windowState3 = false
			windowState4 = false
		else
			RollUpWindow(vehicle, 0)
			RollUpWindow(vehicle, 1)
			RollUpWindow(vehicle, 2)
			RollUpWindow(vehicle, 3)
			windowState1 = true
			windowState2 = true
			windowState3 = true
			windowState4 = true
		end
	end
end