local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local myUserId = tostring(LocalPlayer.UserId)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local GameId = game.GameId
local PlaceId = game.PlaceId
local UserId = LocalPlayer.UserId
local Username = LocalPlayer.Name
local Supported = (GameId == 6161235818 or GameId == 2251388500)
local NDSSupport = (GameId == 189707)
local Executor = (type(identifyexecutor) == "function" and identifyexecutor()) or "Unknown Executor"

local Window = Rayfield:CreateWindow({
    Name = "OSHhub",
    LoadingTitle = "Welcome to OSHhub",
    LoadingSubtitle = "Tester Version",
    Theme = "Ocean",
    ConfigurationSaving = {Enabled = true, FolderName = "OSHhub", FileName = "Config"},
})

-- home tab
local HomeTab = Window:CreateTab("Home", "home")

local probesFolder = workspace:WaitForChild("player_related"):WaitForChild("probes")
local universalESP_Enabled = false
local personalESP_Enabled = false
local espObjects = {}

local function createESP(probe)
    if not probe:IsA("Model") and not probe:IsA("BasePart") then return end
    if espObjects[probe] then return end

    local isMine = (probe.Name == myUserId)

    local highlight = Instance.new("Highlight")
    highlight.Name = "ProbeESP_" .. probe.Name
    
    if isMine then
        highlight.FillColor = Color3.fromRGB(0, 255, 0)
    else
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
    end
    
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Adornee = probe
    highlight.Parent = game:GetService("CoreGui")
    
    if isMine then
        highlight.Enabled = personalESP_Enabled or universalESP_Enabled
    else
        highlight.Enabled = universalESP_Enabled
    end

    espObjects[probe] = { highlight = highlight, isMine = isMine }

    probe.AncestryChanged:Connect(function(_, parent)
        if not parent then
            if espObjects[probe] then
                espObjects[probe].highlight:Destroy()
                espObjects[probe] = nil
            end
        end
    end)
end

local function updateESPVisibility()
    for probe, data in pairs(espObjects) do
        if data.isMine then
            data.highlight.Enabled = personalESP_Enabled or universalESP_Enabled
        else
            data.highlight.Enabled = universalESP_Enabled
        end
    end
end

for _, probe in ipairs(probesFolder:GetChildren()) do
    createESP(probe)
end

probesFolder.ChildAdded:Connect(function(probe)
    task.wait(0.1)
    createESP(probe)
end)

HomeTab:CreateSection("OSHHub | V.1.0.2 | Tester Version")
HomeTab:CreateSection("Thanks for using the script, made by sc0t6.")
HomeTab:CreateSection("GameID: " .. GameId)
HomeTab:CreateSection("PlaceID: " .. PlaceId)
HomeTab:CreateSection("UserId: " .. UserId)
HomeTab:CreateSection("Username: " .. Username)
HomeTab:CreateSection("Executor: " .. Executor)
HomeTab:CreateSection("Executor Level: " .. tostring(ExecLevel))
HomeTab:CreateSection("Supported: " .. tostring(Supported))

HomeTab:CreateButton({
    Name = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end
})

HomeTab:CreateButton({
    Name = "Dex++",
    Callback = function()
        loadstring(game:HttpGet("https://github.com/AZYsGithub/DexPlusPlus/releases/latest/download/out.lua"))()
    end
})

HomeTab:CreateButton({
    Name = "Cobalt (Remote Spy)",
    Callback = function()
        loadstring(game:HttpGet("https://github.com/notpoiu/cobalt/releases/latest/download/Cobalt.luau"))()
    end
})

HomeTab:CreateButton({
    Name = "Check Game Detection",
    Callback = function()
        if Supported or NDSSupport then
            Rayfield:Notify({Title = "Supported Game", Content = "DetectedGame", Duration = 4})
        else
            Rayfield:Notify({Title = "Unsupported", Content = "No script available for this game", Duration = 4})
        end
    end
})

-- twisted tab
if Supported then
    local TwistedTab = Window:CreateTab("Twisted", "party-popper")

    TwistedTab:CreateSection("Bypasses")
    TwistedTab:CreateButton({
        Name = "TwistedB (Bypass)",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/sc0t6/OSHhub/refs/heads/main/scripts/bypasstwisted.lua"))()
        end
    })

    TwistedTab:CreateToggle({
    Name = "Universal Probe ESP (Red)",
    CurrentValue = false,
    Flag = "UniversalProbeESP",
    Callback = function(Value)
        universalESP_Enabled = Value
        updateESPVisibility()
    end,
})

TwistedTab:CreateToggle({
    Name = "Personal Probe ESP (Green)",
    CurrentValue = false,
    Flag = "PersonalProbeESP",
    Callback = function(Value)
        personalESP_Enabled = Value
        updateESPVisibility()
    end,
})
    
end

local customPos = nil

local function findSafePlatform()
    local best = nil
    local bestY = 0
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") 
        and not part.Parent:FindFirstChildOfClass("Humanoid")
        and part.Anchored
        and part.Size.X >= 8
        and part.Size.Z >= 8
        and part.Position.Y > bestY 
        and part.Position.Y < 500 then
            best = part
            bestY = part.Position.Y
        end
    end
    if best then
        return best.Position + Vector3.new(0, 4, 0)
    end
    return Vector3.new(0, safeHeight, 0)
end

local function tpTo(NDSpos)
    local hrp = getHRP()
    if hrp then
        hrp.CFrame = CFrame.new(NDSpos)
    end
end

if game.PlaceId == 189707 then
    local NDSTab = Window:CreateTab("NDS", 75756933857153)

    NDSTab:CreateSection("Removing fall damage is serversided so we didnt add it")
    NDSTab:CreateSection("Safety")   
        NDSTab:CreateButton({
        Name = "Teleport to Safe Zone (spawnpoint)",
        Callback = function()
            local char = LocalPlayer.Character
            if char then
                char:PivotTo(CFrame.new(-280, 179, 339))
            end
        end
    })
local DisasterSection = NDSTab:CreateSection("Current Status")

local DisasterLabel = NDSTab:CreateLabel("Current Disaster: None")

task.spawn(function()
    while task.wait(1) do
        local disasterName = "None"
        
        local playerUI = game.Players.LocalPlayer.PlayerGui:FindFirstChild("UI")
        if playerUI then
            for _, child in pairs(playerUI:GetChildren()) do
                if child.Name == "Disaster Warning" or child:FindFirstChild("warningText") then
                    local textLabel = child:FindFirstChild("warningText", true)
                    if textLabel and textLabel.Text ~= "" then
                        disasterName = textLabel.Text
                    end
                end
            end
        end

        if disasterName == "None" then
            local mainGui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("MainGui")
            local dLabel = mainGui and mainGui:FindFirstChild("DisasterFrame") and mainGui.DisasterFrame:FindFirstChild("DisasterLabel")
            if dLabel and dLabel.Visible and dLabel.Text ~= "" then
                disasterName = dLabel.Text
            end
        end

        -- Update the Rayfield Label
        DisasterLabel:Set("Current Disaster: " .. disasterName)
    end
end)
end

Rayfield:Notify({
    Title = "Welcome to OSHhub | Tester Version!",
    Content = "Feel free to share the script but only keep it off websites.",
    Duration = 3
})

Rayfield:LoadConfiguration()
