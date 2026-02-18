local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("ToraScript") then
    CoreGui.ToraScript:Destroy()
end

local library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/liebertsx/Tora-Library/main/src/librarynew",
    true
))()

local window = library:CreateWindow("Evade (EVENT)")
local main = window:AddFolder("Main")

local function getRoot()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return LocalPlayer.Character.HumanoidRootPart
    end
end

local function isBotNear(dist)
    local root = getRoot()
    if not root then return false end

    for _, v in pairs(workspace.Game.Players:GetChildren()) do
        if not v:FindFirstChildOfClass("LocalScript") and v:FindFirstChild("HumanoidRootPart") then
            local magnitude = (v.HumanoidRootPart.Position - root.Position).Magnitude
            if magnitude <= dist then
                return true
            end
        end
    end

    return false
end

local function randomTeleport()
    local root = getRoot()
    if not root then return end
    local offset = Vector3.new(math.random(-120,120), 0, math.random(-120,120))
    root.CFrame = CFrame.new(root.Position + offset)
end

main:AddToggle({
    text = "Collect Items",
    flag = "collect_items",
    callback = function(state)
        _G.Items = state
        print("Items:", state)

        if state then
            task.spawn(function()
                while _G.Items do
                    task.wait()

                    if _G.Avoid and isBotNear(15) then
                        repeat
                            task.wait(0.5)
                        until not isBotNear(15) or not _G.Items
                    end

                    pcall(function()
                        for _, v in pairs(workspace.Game.Effects.Tickets:GetChildren()) do
                            if not _G.Items then break end
                            if _G.Avoid and isBotNear(15) then break end

                            local root = getRoot()
                            if root and v:FindFirstChild("HumanoidRootPart") then
                                root.CFrame = CFrame.new(v.HumanoidRootPart.Position)
                                task.wait(0.1)
                            end
                        end
                    end)
                end
            end)
        end
    end
})

main:AddToggle({
    text = "Avoid Nextbot",
    flag = "avoid_nextbot",
    callback = function(state)
        _G.Avoid = state
        print("Avoid:", state)

        if state then
            task.spawn(function()
                while _G.Avoid do
                    task.wait(0.2)

                    if isBotNear(15) then
                        randomTeleport()
                        task.wait(1)
                    end
                end
            end)
        end
    end
})

main:AddLabel({
    text = "YouTube: Tora IsMe",
    type = "label"
})

library:Init()
