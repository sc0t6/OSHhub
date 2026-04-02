local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local GameId = game.GameId
local PlaceId = game.PlaceId
local UserId = LocalPlayer.UserId
local Username = LocalPlayer.Name
local Supported = (GameId == 6161235818 or GameId == 2251388500)
local NDSSupport = (GameId == 189707)
local Executor = (type(identifyexecutor) == "function" and identifyexecutor()) or "Unknown Executor"
local ExecLevel = (type(getexecutorlevel) == "function" and getexecutorlevel()) or "Unknown"

local selectedTornado = nil
local interceptDistance = 100 
local tornadoVelocity = Vector3.new(0,0,0)
local lastTornadoPos = Vector3.new(0,0,0)
local lastProbePos = nil 

local Window = Rayfield:CreateWindow({
    Name = "OSHhub",
    LoadingTitle = "Welcome to OSHhub",
    LoadingSubtitle = "Tester Version",
    Theme = "Ocean",
    ConfigurationSaving = {Enabled = true, FolderName = "OSHhub", FileName = "Config"},
})

-- home tab
local HomeTab = Window:CreateTab("Home", "home")
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
    TwistedTab:CreateSection("When you die, press the button again so the anticheat doesnt occur")
    TwistedTab:CreateButton({
        Name = "TwistedB (Bypass, but expires when died)",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/sc0t6/OSHhub/refs/heads/main/scripts/bypasstwisted.lua"))()
        end
    })

TwistedTab:CreateSection("Tornado Interceptor")

    local function getTornadoList()
        local list = {}
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Model") and (v.Name:lower():find("tornado") or v.Name:lower():find("funnel")) then
                if not Players:GetPlayerFromCharacter(v) then
                    table.insert(list, v.Name)
                end
            end
        end
        
        if #list == 0 then 
            return {"No Tornadoes Found"} 
        end
        return list
    end

    local TornadoDropdown = TwistedTab:CreateDropdown({
        Name = "Select Target Tornado",
        Options = getTornadoList(),
        CurrentOption = {""},
        Flag = "TornadoDropdown", 
        Callback = function(Option)
            local selectedName = type(Option) == "table" and Option[1] or Option
            
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("Model") and v.Name == selectedName then
                    if not v.PrimaryPart then
                        v.PrimaryPart = v:FindFirstChildWhichIsA("BasePart")
                    end
                    
                    selectedTornado = v
                    if v.PrimaryPart then 
                        lastTornadoPos = v.PrimaryPart.Position 
                        Rayfield:Notify({Title = "Target Acquired", Content = "Tracking: " .. v.Name, Duration = 3})
                    else
                        Rayfield:Notify({Title = "Error", Content = "Tornado has no physical parts to track!", Duration = 3})
                    end
                    break
                end
            end
        end,
    })

    TwistedTab:CreateButton({
        Name = "Refresh Tornado List",
        Callback = function()
            TornadoDropdown:Refresh(getTornadoList(), true)
        end,
    })

    TwistedTab:CreateSlider({
        Name = "Intercept Distance",
        Range = {50, 500},
        Increment = 10,
        Suffix = "Studs",
        CurrentValue = 100,
        Flag = "DistSlider", 
        Callback = function(Value)
            interceptDistance = Value
        end,
    })

    -- TELEPORT TO INTERCEPT
    TwistedTab:CreateButton({
        Name = "Teleport to Intercept Path",
        Callback = function()
            if selectedTornado and (selectedTornado.PrimaryPart or selectedTornado:FindFirstChildWhichIsA("BasePart")) then
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local tPrim = selectedTornado.PrimaryPart or selectedTornado:FindFirstChildWhichIsA("BasePart")

                if root and tPrim then
                    local direction = tornadoVelocity.Unit
                    if direction.X ~= direction.X then direction = Vector3.new(1,0,0) end 
                    
                    local interceptPos = tPrim.Position + (direction * interceptDistance)
                    
                    local rayOrigin = interceptPos + Vector3.new(0, 100, 0)
                    local rayDirection = Vector3.new(0, -200, 0)
                    local raycastParams = RaycastParams.new()
                    raycastParams.FilterDescendantsInstances = {char, selectedTornado}
                    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
                    
                    local rayResult = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
                    local finalY = rayResult and (rayResult.Position.Y + 3) or (tPrim.Position.Y)

                    local finalPos = Vector3.new(interceptPos.X, finalY, interceptPos.Z)
                    lastProbePos = finalPos 
                    
                    root.CFrame = CFrame.new(finalPos, Vector3.new(tPrim.Position.X, finalY, tPrim.Position.Z))
                    Rayfield:Notify({Title = "Positioned", Content = "Waiting for intercept...", Duration = 3})
                end
            else
                Rayfield:Notify({Title = "Search Error", Content = "No active tornado selected or found.", Duration = 3})
            end
        end,
    })

    RunService.Heartbeat:Connect(function(deltaTime)
        if selectedTornado and (selectedTornado.PrimaryPart or selectedTornado:FindFirstChildWhichIsA("BasePart")) then
            local tPrim = selectedTornado.PrimaryPart or selectedTornado:FindFirstChildWhichIsA("BasePart")
            local currentPos = tPrim.Position
            local displacement = currentPos - lastTornadoPos
            tornadoVelocity = displacement / deltaTime
            lastTornadoPos = currentPos
        end
    end)
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
