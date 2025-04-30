local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local Camera = Workspace.CurrentCamera
local RunService = game:GetService("RunService")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Test"
screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local image = Instance.new("ImageLabel")
image.Size = UDim2.new(0.5, 0, 0.5, 0)
image.Position = UDim2.new(0.25, 0, 0.25, 0)
image.BackgroundTransparency = 1
image.Parent = screenGui
image.Image = "rbxassetid://84523070105231"

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0.2, 0)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.Text = "Test"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.BackgroundTransparency = 1
titleLabel.TextScaled = true
titleLabel.Parent = image

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.5, 0, 0.2, 0)
toggleButton.Position = UDim2.new(0.25, 0, 0.4, 0)
toggleButton.Text = "Test"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.BackgroundTransparency = 1
toggleButton.TextScaled = true
toggleButton.Parent = image

-- Toggle button functionality
local function toggleAimbot()
    aimbotEnabled = not aimbotEnabled
    toggleButton.Text = aimbotEnabled and "BeckysAA ON" or "BeckysAA OFF"
    
    local StarterGui = game:GetService("StarterGui")
    local message = aimbotEnabled and "BeckysAA Enabled" or "BeckysAA Disabled"

    StarterGui:SetCore("SendNotification", {
        Title = "Status",
        Text = message,
        Duration = 2
    })

    print("BeckysAA toggled: " .. tostring(aimbotEnabled))
end

toggleButton.MouseButton1Click:Connect(toggleAimbot)

-- Function to toggle GUI visibility
local function toggleGui()
    guiVisible = not guiVisible
    screenGui.Enabled = guiVisible
    print("GUI visibility toggled: " .. tostring(guiVisible))
end

-- Key press functionality
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent then
        if input.KeyCode == Enum.KeyCode.Zero then
            toggleGui()
        elseif input.KeyCode == Enum.KeyCode.Q then
            toggleAimbot()
        end
    end
end)

-- Aimbot functionality
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
                    local torsoPosition = torso.Position
                    local distance = (myPosition - torsoPosition).magnitude

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
                local direction = (targetPosition - currentPosition).unit

                -- Smooth aimbot logic for first-person and third-person
                if UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
                    -- First-person mode adjustments
                    Camera.CFrame = CFrame.new(currentPosition, targetPosition)
                else
                    -- Third-person mode adjustments
                    local smoothPosition = Camera.CFrame.Position:Lerp(targetPosition, smoothness)
                    Camera.CFrame = CFrame.new(smoothPosition, targetPosition)
                end
            end
        end
    end
end

-- Update aimbot on every frame
RunService.RenderStepped:Connect(function()
    aimbot()
end)

-- Shooting functionality
local function onMouseClick()
    if aimbotEnabled then
        local target = getClosestPlayer()
        if target and target.Character then
            local torso = target.Character:FindFirstChild("UpperTorso") or target.Character:FindFirstChild("HumanoidRootPart")
            if torso then
                -- Simulate shooting (example: fire a projectile or call a function)
                -- For example, you might trigger a RemoteEvent to shoot:
                -- game.ReplicatedStorage.ShootEvent:FireServer(torso.Position)
            end
        end
    end
end

-- Handle mouse click
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent and input.UserInputType == Enum.UserInputType.MouseButton1 then
        onMouseClick()
    end
end)

-- Debug print to confirm script execution
print("Script loaded successfully!")