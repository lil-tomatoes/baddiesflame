local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local CharactersFolder = workspace:WaitForChild("Characters")

-- GUI variables
local gui = nil
local toggle = nil
local closeBtn = nil
local enabled = false
local guiClosed = false

-- Grab logic variables
local grabLoopConnection = nil
local SelectedNPCs = {}

-- Create GUI
local function createGUI()
    if gui and gui.Parent then
        gui:Destroy()
    end

    gui = Instance.new("ScreenGui")
    gui.Name = "NPC_Teleport_GUI"
    gui.ResetOnSpawn = false

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 180, 0, 120)
    frame.Position = UDim2.new(0, 20, 0, 200)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

    toggle = Instance.new("TextButton", frame)
    toggle.Size = UDim2.new(1, -10, 0, 50)
    toggle.Position = UDim2.new(0, 5, 0, 5)
    toggle.Text = "Teleport: OFF"
    toggle.BackgroundColor3 = Color3.fromRGB(180, 50, 50)

    closeBtn = Instance.new("TextButton", frame)
    closeBtn.Size = UDim2.new(1, -10, 0, 40)
    closeBtn.Position = UDim2.new(0, 5, 0, 60)
    closeBtn.Text = "Close"
    closeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

    gui.Parent = player:WaitForChild("PlayerGui")

    toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            toggle.Text = "Teleport: ON"
            toggle.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
        else
            toggle.Text = "Teleport: OFF"
            toggle.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        end
    end)

    closeBtn.MouseButton1Click:Connect(function()
        enabled = false
        guiClosed = true
        gui:Destroy()
    end)
end

-- Initial GUI
createGUI()

-- Track player root
local root = nil
local function updateCharacter(char)
    root = char:WaitForChild("HumanoidRootPart")
    if not guiClosed and not (gui and gui.Parent) then
        createGUI()
    end
end

if player.Character then
    updateCharacter(player.Character)
end
player.CharacterAdded:Connect(updateCharacter)

-- Get closest NPC with target names
local targetNames = {["Goat"]=true, ["Tree"]=true, ["Elf"]=true, ["Skull"]=true}

local function getClosestNPC()
    if not root then return nil end

    local closest = nil
    local closestDist = math.huge

    for _, npc in ipairs(CharactersFolder:GetChildren()) do
        local humanoid = npc:FindFirstChild("Humanoid")
        local npcHRP = npc:FindFirstChild("HumanoidRootPart")
        if humanoid and npcHRP then
            if npc == player.Character then continue end
            if Players:GetPlayerFromCharacter(npc) then continue end
            if not targetNames[npc.Name] then continue end

            local dist = (npcHRP.Position - root.Position).Magnitude
            if dist < closestDist then
                closestDist = dist
                closest = npc
            end
        end
    end

    return closest
end

-- Fill SelectedNPCs for grab logic
local function updateSelectedNPCs()
    SelectedNPCs = {}
    for _, npc in ipairs(CharactersFolder:GetChildren()) do
        if npc:FindFirstChild("HumanoidRootPart") and targetNames[npc.Name] then
            table.insert(SelectedNPCs, npc)
        end
    end
end

-- NPC grab logic
local function stopNPCGrab()
    if grabLoopConnection then
        grabLoopConnection:Disconnect()
        grabLoopConnection = nil
    end
    SelectedNPCs = {}
end

local function startNPCGrab()
    if grabLoopConnection then return end
    local myHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end

    grabLoopConnection = RunService.RenderStepped:Connect(function()
        local currentHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not currentHRP then
            stopNPCGrab()
            return
        end

        for i, npc in pairs(SelectedNPCs) do
            local npcHRP = npc:FindFirstChild("HumanoidRootPart")
            if npcHRP then
                local offset = Vector3.new(2,0,-10)
                local targetCFrame = currentHRP.CFrame * CFrame.new(offset)
                npcHRP.CanCollide = false
                npcHRP.CFrame = targetCFrame
                npcHRP.Velocity = Vector3.new(0,0,0)
            else
                table.remove(SelectedNPCs, i)
            end
        end

        if #SelectedNPCs == 0 then
            stopNPCGrab()
        end
    end)
end

-- Smooth follow + attack loop
local number = 0 -- initialize once at the top
task.spawn(function()
    while true do
        task.wait(0.05)
        if enabled and root then
            updateSelectedNPCs()
            startNPCGrab()

            local npc = getClosestNPC()
            if npc and npc:FindFirstChild("HumanoidRootPart") then

				ReplicatedStorage.Modules.Net["RE/sprayRemote"]:FireServer(1)
				game:GetService("ReplicatedStorage").Modules.Net["RE/flamethrowerFire"]:FireServer(1)
				game:GetService("ReplicatedStorage").Modules.Net["RE/GoldenFlameThrowerFire"]:FireServer(1)

				--number = number + 1
				--if number >= 500 then
				--    number = 0 -- reset
				game:GetService("ReplicatedStorage").Modules.Net["RE/GoldenFlameThrowerReload"]:FireServer(1)
				game:GetService("ReplicatedStorage").Modules.Net["RE/flamethrowerReload"]:FireServer(1)
				--end
			end
        end
    end
end)
