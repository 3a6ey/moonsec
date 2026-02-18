local CoreGui = game:GetService("CoreGui")

if CoreGui:FindFirstChild("ToraScript") then
    CoreGui.ToraScript:Destroy()
end


local library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/liebertsx/Tora-Library/main/src/librarynew",
    true
))()

-
local window = library:CreateWindow("Evade (EVENT)")


local main = window:AddFolder("Main")


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

                    pcall(function()
                        for _, v in pairs(workspace.Game.Effects.Tickets:GetChildren()) do
                            local plr = game.Players.LocalPlayer
                            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                                plr.Character.HumanoidRootPart.CFrame =
                                    CFrame.new(v.HumanoidRootPart.Position)
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
    end
})


main:AddLabel({
    text = "YouTube: Tora IsMe",
    type = "label"
})

library:Init()
