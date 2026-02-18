getgenv().Avoid = getgenv().Avoid or false
getgenv().Items = getgenv().Items or false

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local Event = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Player"):WaitForChild("ChangePlayerMode")

local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getRoot()
    return getCharacter():WaitForChild("HumanoidRootPart")
end

local function enableMode()
    pcall(function()
        Event:FireServer(true)
    end)
end

local function getNextbots()
    local bots = {}
    for _, v in pairs(workspace.Game.Players:GetChildren()) do
        if not v:FindFirstChildOfClass("LocalScript") and v:FindFirstChild("HumanoidRootPart") then
            table.insert(bots, v)
        end
    end
    return bots
end

local function isBotNear(distance)
    local root = getRoot()
    for _, bot in pairs(getNextbots()) do
        local dist = (bot.HumanoidRootPart.Position - root.Position).Magnitude
        if dist <= distance then
            return true
        end
    end
    return false
end

local function flyLoop()
    task.spawn(function()
        while getgenv().Avoid do
            local root = getRoot()
            root.Velocity = Vector3.zero
            root.CFrame = root.CFrame + Vector3.new(0, 25, 0)
            task.wait(0.15)
        end
    end)
end

local function evade()
    local root = getRoot()
    local offset = Vector3.new(math.random(-80,80), 35, math.random(-80,80))
    root.CFrame = CFrame.new(root.Position + offset)
end

local function avoidLoop()
    task.spawn(function()
        while getgenv().Avoid do
            if isBotNear(15) then
                evade()
                task.wait(0.3)
            end
            task.wait(0.1)
        end
    end)
end

local function collectLoop()
    task.spawn(function()
        while getgenv().Items do
            enableMode()
            if getgenv().Avoid and isBotNear(15) then
                evade()
                task.wait(5)
            else
                pcall(function()
                    for _, v in pairs(workspace.Game.Effects.Tickets:GetChildren()) do
                        if not getgenv().Items then break end
                        if getgenv().Avoid and isBotNear(15) then break end
                        getRoot().CFrame = CFrame.new(v.HumanoidRootPart.Position + Vector3.new(0,3,0))
                        task.wait(0.2)
                    end
                end)
            end
            task.wait()
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if getgenv().Avoid then
        flyLoop()
    end
end)

if getgenv().Avoid then
    flyLoop()
    avoidLoop()
end

if getgenv().Items then
    collectLoop()
end
