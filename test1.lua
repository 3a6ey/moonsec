local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")

local dangerDistance = 5
local isEscaping = false
local autoFarmPaused = false
local teleportCooldown = false

local function getNextbots()
    local bots = {}
    local folder = workspace:FindFirstChild("Game")
    if folder and folder:FindFirstChild("Players") then
        for _, v in pairs(folder.Players:GetChildren()) do
            if not Players:FindFirstChild(v.Name) then
                table.insert(bots, v)
            end
        end
    end
    return bots
end

local function getDistance(bot)
    if bot:FindFirstChild("HumanoidRootPart") and hrp then
        return (bot.HumanoidRootPart.Position - hrp.Position).Magnitude
    end
    return math.huge
end

task.spawn(function()
    while getgenv().Avoid do
        task.wait(0.2)

        if not lp.Character then continue end
        hrp = lp.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end

        local bots = getNextbots()
        local danger = false

        for _, bot in pairs(bots) do
            if getDistance(bot) <= dangerDistance then
                danger = true
                break
            end
        end

        if danger and not isEscaping and not teleportCooldown then
            isEscaping = true
            autoFarmPaused = true
            teleportCooldown = true

            hrp.CFrame = CFrame.new(
                math.random(-200,200),
                20,
                math.random(-200,200)
            )

            task.wait(2)
            teleportCooldown = false
        end

        if isEscaping then
            local safe = true
            for _, bot in pairs(bots) do
                if getDistance(bot) <= dangerDistance then
                    safe = false
                    break
                end
            end

            if safe then
                isEscaping = false
                autoFarmPaused = false
            end
        end
    end
end)
