local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")

local snowButton = Enum.KeyCode.ButtonY
local comboButton = Enum.KeyCode.ButtonL3
local rpgMacroButton = Enum.KeyCode.DPadLeft
local grenadeButton = Enum.KeyCode.DPadRight
local taserButton = Enum.KeyCode.DPadUp

local snowCooldown = 0.15
local comboCooldown = 0.2
local grenadeCooldown = 0.25
local floorComboCooldown = 0.2
local rpgMacroCooldown = 0.3

local canSnow = true
local canCombo = true
local canGrenade = true
local canTaser = true
local canRPGMacro = true

local function tapAim()
    local camera = workspace.CurrentCamera
    local size = camera.ViewportSize

    local aimX = size.X / 2
    local aimY = size.Y / 2 - 125 -- moves above controller crosshair

    VIM:SendMouseButtonEvent(aimX, aimY, 0, true, game, 0)
    VIM:SendMouseButtonEvent(aimX, aimY, 0, false, game, 0)
end

local function pressKey(key)
    VIM:SendKeyEvent(true, key, false, game)
    VIM:SendKeyEvent(false, key, false, game)
end

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    -- ❄️ Y = SNOW
    if input.KeyCode == snowButton and canSnow then
        canSnow = false

        pressKey(Enum.KeyCode.Three)
        tapAim()

        task.wait(0.05)

        pressKey(Enum.KeyCode.Four)
        tapAim()

        task.wait(0.05)

        pressKey(Enum.KeyCode.Two)
        tapAim()

        task.delay(snowCooldown, function()
            canSnow = true
        end)
    end


    -- ⚔️ L3 = COMBO
    if input.KeyCode == comboButton and canCombo then
        canCombo = false

        pressKey(Enum.KeyCode.Five)
        tapAim()

        task.wait(0.05)

        pressKey(Enum.KeyCode.Six)
        tapAim()

        task.wait(0.05)

        pressKey(Enum.KeyCode.Seven)
        tapAim()

        task.wait(0.05)

        pressKey(Enum.KeyCode.Eight)
        tapAim()

        task.wait(0.05)

        pressKey(Enum.KeyCode.Two)
        tapAim()

        task.delay(comboCooldown, function()
            canCombo = true
        end)
    end


    -- 🔥 DPAD LEFT = RPG MACRO (1 → R → 2)
    if input.KeyCode == rpgMacroButton and canRPGMacro then
        canRPGMacro = false

        pressKey(Enum.KeyCode.One)
		task.wait(0.1)
        tapAim()

        task.wait(0.1)

        pressKey(Enum.KeyCode.R)

        task.wait(0.1)

        pressKey(Enum.KeyCode.Two)
        tapAim()

        task.delay(rpgMacroCooldown, function()
            canRPGMacro = true
        end)
    end

    -- 💣 DPAD RIGHT = 9 → 0 → 2
    if input.KeyCode == grenadeButton and canGrenade then
        canGrenade = false

        pressKey(Enum.KeyCode.Nine)
        tapAim()

        task.wait(0.05)

        pressKey(Enum.KeyCode.Zero)
        tapAim()

        task.wait(0.05)

        pressKey(Enum.KeyCode.Two)
        tapAim()

        task.delay(grenadeCooldown, function()
            canGrenade = true
        end)
    end

    -- ⚡ DPAD UP = FLOOR COMBO
    if input.KeyCode == taserButton and canTaser then
        canTaser = false

        pressKey(Enum.KeyCode.Five)
        tapAim()

        task.wait(0.05)

        pressKey(Enum.KeyCode.Six)
        tapAim()

        task.wait(0.05)

        pressKey(Enum.KeyCode.Seven)
        tapAim()

        task.wait(0.05)

        pressKey(Enum.KeyCode.Eight)
        tapAim()

        task.delay(floorComboCooldown, function()
            canTaser = true
        end)
    end
end)
