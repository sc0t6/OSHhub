local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local GameId = game.GameId
local PlaceId = game.PlaceId
local UserId = LocalPlayer.UserId
local Username = LocalPlayer.Name
local Supported = (GameId == 6161235818)
local Executor = (type(identifyexecutor) == "function" and identifyexecutor()) or "Unknown Executor"
local ExecLevel = (type(getexecutorlevel) == "function" and getexecutorlevel()) or "Unknown"

local Window = Rayfield:CreateWindow({
    Name = "OSHhub",
    LoadingTitle = "Welcome to OSHhub",
    LoadingSubtitle = "Tester Version",
    Theme = "Ocean",
})

local HomeTab = Window:CreateTab("Home", "home")

local Name = HomeTab:CreateSection("OSHHub | V.1.0.1 | Tester Version")

local Credits = HomeTab:CreateSection("Thanks for using the script, made by sc0t6. I have worked quite hard on this for it to work :D")

local GameID = HomeTab:CreateSection("GameID: " .. GameId)
local PlaceID = HomeTab:CreateSection("\nPlaceID: " .. PlaceId)

local UserID = HomeTab:CreateSection("\nUserId: " .. UserId ..)

local Username = HomeTab:CreateSection("\nUsername: " .. Username ..)

local ExecutorName = HomeTab:CreateSection("\nExecutor: " .. Executor ..)

local ExecutorLVL = HomeTab:CreateSection("\nExecutor Level: " .. tostring(ExecLevel) ..)

local seeifsupportedgame = HomeTab:CreateSection("\nSupported: " .. tostring(Supported))

local admin = HomeTab:CreateButton({
        Name = "Infinite Yield",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
        end
    })

if GameId == 6161235818 then
    local TwistedTab = Window:CreateTab("Twisted", "party-popper")

    local TwistedB = TwistedTab:CreateButton({
        Name = "TwistedB",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/sc0t6/OSHhub/refs/heads/main/scripts/bypasstwisted.lua"))()
        end
    })
end

local GameDetect = HomeTab:CreateButton({
    Name = "Check Game Detection",
    Callback = function()
        if Supported then
            Rayfield:Notify({
                Title = "Supported Game",
                Content = "Twisted detected and loaded",
                Duration = 4
            })
        else
            Rayfield:Notify({
                Title = "Unsupported",
                Content = "No script available for this game",
                Duration = 4
            })
        end
    end
})

Rayfield:Notify({
    Title = "Welcome to OSHhub | Tester Version!",
    Content = "Feel free to share the script but only keep it off websites.",
    Duration = 3
  })

Rayfield:LoadConfiguration()
