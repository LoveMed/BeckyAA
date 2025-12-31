local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local Camera = Workspace.CurrentCamera
local RunService = game:GetService("RunService")

local aimbotEnabled = false
local guiVisible = true
local smoothness = 0.01

local localPlayer = Players.LocalPlayer
local PlayerGui = localPlayer:WaitForChild("PlayerGui")

--====================================================
-- MAIN UI
--====================================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Beckys AA"
screenGui.Parent = PlayerGui

local image = Instance.new("ImageLabel")
image.Size = UDim2.new(0.5, 0, 0.5, 0)
image.Position = UDim2.new(0.25, 0, 0.25, 0)
image.BackgroundTransparency = 1
image.Parent = screenGui
image.Image = "rbxassetid://84523070105231"

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0.2, 0)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.Text = "Beckys AA"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.BackgroundTransparency = 1
titleLabel.TextScaled = true
titleLabel.Parent = image

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.5, 0, 0.2, 0)
toggleButton.Position = UDim2.new(0.25, 0, 0.4, 0)
toggleButton.Text = "Toggle Beckys AA"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.BackgroundTransparency = 1
toggleButton.TextScaled = true
toggleButton.Parent = image

--====================================================
-- ALWAYS-VISIBLE STATUS ICON
--====================================================

local statusGui = Instance.new("ScreenGui")
statusGui.Name = "StatusCircleUI"
statusGui.IgnoreGuiInset = true
statusGui.ResetOnSpawn = false
statusGui.Parent = PlayerGui

local statusIcon = Instance.new("Frame")
statusIcon.Size = UDim2.new(0, 18, 0, 18) -- small circle
statusIcon.AnchorPoint = Vector2.new(1, 1)
statusIcon.Position = UDim2.new(1, -20, 1, -20) -- bottom-right
statusIcon.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- red default (OFF)
statusIcon.BorderSizePixel = 0
statusIcon.ZIndex = 999999
statusIcon.Parent = statusGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = statusIcon

local function updateStatusIcon()
    if aimbotEnabled then
        statusIcon.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- green ON
    else
        statusIcon.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- red OFF
    end
end

updateStatusIcon() -- set initial color

--====================================================
-- TOGGLE FUNCTION
--====================================================

local function toggleAimbot()
    aimbotEnabled = not aimbotEnabled
    toggleButton.Text = aimbotEnabled and "BeckysAA ON" or "BeckysAA OFF"

    updateStatusIcon()

    print("BeckysAA toggled: " .. tostring(aimbotEnabled))
end

toggleButton.MouseButton1Click:Connect(toggleAimbot)

-- GUI Visibility Toggle
local function toggleGui()
    guiVisible = not guiVisible
    screenGui.Enabled = guiVisible
    print("GUI visibility toggled: " .. tostring(guiVisible))
end

-- Keybinds
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent then
        if input.KeyCode == Enum.KeyCode.Zero then
            toggleGui()
        elseif input.KeyCode == Enum.KeyCode.Q then
            toggleAimbot()
        end
    end
end)

--====================================================
-- AIMBOT SYSTEM
--====================================================

local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local myPosition = Camera.CFrame.Position
    local myTeam = Players.LocalPlayer.Team

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and player.Team ~= myTeam and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local torso = player.Character:FindFirstChild("UpperTorso") or player.Character:FindFirstChild("HumanoidRootPart")
                if torso then
                    local distance = (myPosition - torso.Position).magnitude
                    if distance < shortestDistance and distance <= 32 then
                        closestPlayer = player
                        shortestDistance = distance
                    end
                end
            end
        end
    end

    return closestPlayer
end

local function aimbot()
    if aimbotEnabled then
        local target = getClosestPlayer()
        if target and target.Character then
            local torso = target.Character:FindFirstChild("UpperTorso") or target.Character:FindFirstChild("HumanoidRootPart")
            if torso then
                local targetPosition = torso.Position
                local currentPosition = Camera.CFrame.Position

                if UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
                    Camera.CFrame = CFrame.new(currentPosition, targetPosition) -- first person
                else
                    local smoothPos = Camera.CFrame.Position:Lerp(targetPosition, smoothness)
                    Camera.CFrame = CFrame.new(smoothPos, targetPosition)
                end
            end
        end
    end
end

RunService.RenderStepped:Connect(aimbot)

-- Shoot functionality
local function onMouseClick()
    if aimbotEnabled then
        local target = getClosestPlayer()
        if target and target.Character then
            local torso = target.Character:FindFirstChild("UpperTorso") or target.Character:FindFirstChild("HumanoidRootPart")
            if torso then
                -- your shooting event here if needed
            end
        end
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent and input.UserInputType == Enum.UserInputType.MouseButton1 then
        onMouseClick()
    end
end)

queue_on_teleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/LoveMed/BeckyAA/main/Beckys%20AA.lua"))()')

print("Script loaded successfully!")


