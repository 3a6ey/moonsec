getgenv().Avoid = getgenv().Avoid or false
getgenv().Items = getgenv().Items or false

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getRoot()
    return getCharacter():WaitForChild("HumanoidRootPart")
end

local function getHumanoid()
    return getCharacter():WaitForChild("Humanoid")
end

local function enableModeOnce()
    task.delay(5,function()
        pcall(function()
            local Event = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Player"):WaitForChild("ChangePlayerMode")
            Event:FireServer(true)
        end)
    end)
end

local function getNextbots()
    local bots = {}
    for _, v in pairs(workspace.Game.Players:GetChildren()) do
        if not v:FindFirstChildOfClass("LocalScript") and v:FindFirstChild("HumanoidRootPart") then
            table.insert(bots,v)
        end
    end
    return bots
end

local function isBotNear(dist)
    local root = getRoot()
    for _,bot in pairs(getNextbots()) do
        if (bot.HumanoidRootPart.Position - root.Position).Magnitude <= dist then
            return true
        end
    end
    return false
end

local floatForce

local function startFloat()
    if floatForce then floatForce:Destroy() end
    local root = getRoot()
    floatForce = Instance.new("BodyVelocity")
    floatForce.MaxForce = Vector3.new(0,math.huge,0)
    floatForce.Velocity = Vector3.new(0,2,0)
    floatForce.Parent = root
end

local function stopFloat()
    if floatForce then
        floatForce:Destroy()
        floatForce = nil
    end
end

local function evade()
    local root = getRoot()
    local offset = Vector3.new(math.random(-70,70),0,math.random(-70,70))
    root.CFrame = CFrame.new(root.Position + offset)
end

local function avoidLoop()
    task.spawn(function()
        while getgenv().Avoid do
            if isBotNear(15) then
                evade()
                task.wait(1)
            end
            task.wait(0.2)
        end
    end)
end

local function collectLoop()
    task.spawn(function()
        while getgenv().Items do
            if getgenv().Avoid and isBotNear(15) then
                task.wait(5)
            else
                pcall(function()
                    for _,v in pairs(workspace.Game.Effects.Tickets:GetChildren()) do
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
    stopFloat()
    if getgenv().Avoid then
        startFloat()
    end
    enableModeOnce()
end)

if getgenv().Avoid then
    startFloat()
    avoidLoop()
end

if getgenv().Items then
    collectLoop()
end

local gui = Instance.new("ScreenGui")
gui.Name = "EvadeEventUI"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

local frame = Instance.new("Frame",gui)
frame.Size = UDim2.new(0,180,0,120)
frame.Position = UDim2.new(0,10,0.4,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BorderSizePixel = 0

local uiCorner = Instance.new("UICorner",frame)
uiCorner.CornerRadius = UDim.new(0,12)

local function makeButton(text,posY,callback)
    local btn = Instance.new("TextButton",frame)
    btn.Size = UDim2.new(1,-20,0,40)
    btn.Position = UDim2.new(0,10,0,posY)
    btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = text
    btn.BorderSizePixel = 0
    local c = Instance.new("UICorner",btn)
    c.CornerRadius = UDim.new(0,10)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local avoidBtn = makeButton("Avoid: "..tostring(getgenv().Avoid),10,function()
    getgenv().Avoid = not getgenv().Avoid
    avoidBtn.Text = "Avoid: "..tostring(getgenv().Avoid)
    if getgenv().Avoid then
        startFloat()
        avoidLoop()
    else
        stopFloat()
    end
end)

local itemsBtn = makeButton("Items: "..tostring(getgenv().Items),60,function()
    getgenv().Items = not getgenv().Items
    itemsBtn.Text = "Items: "..tostring(getgenv().Items)
    if getgenv().Items then
        collectLoop()
    end
end)
