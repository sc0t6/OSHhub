local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local GameId = game.GameId
local PlaceId = game.PlaceId
local UserId = LocalPlayer.UserId
local Username = LocalPlayer.Name
local Supported = (GameId == 6161235818 or GameId == 2251388500)
local Executor = (type(identifyexecutor) == "function" and identifyexecutor()) or "Unknown Executor"
local ExecLevel = (type(getexecutorlevel) == "function" and getexecutorlevel()) or "Unknown"

-- State variables
local selectedTornado = nil
local interceptDistance = 100 -- Default changed to 100
local tornadoVelocity = Vector3.new(0,0,0)
local lastTornadoPos = Vector3.new(0,0,0)
local lastProbePos = nil -- Stores where we last teleported to intercept

local Window = Rayfield:CreateWindow({
    Name = "OSHhub",
    LoadingTitle = "Welcome to OSHhub",
    LoadingSubtitle = "Tester Version",
    Theme = "Ocean",
    ConfigurationSaving = {Enabled = true, FolderName = "OSHhub", FileName = "Config"},
})

-- [[ HOME TAB ]] --
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
    Name = "Check Game Detection",
    Callback = function()
        if Supported then
            Rayfield:Notify({Title = "Supported Game", Content = "Twisted detected and loaded", Duration = 4})
        else
            Rayfield:Notify({Title = "Unsupported", Content = "No script available for this game", Duration = 4})
        end
    end
})

-- [[ TWISTED TAB ]] --
if Supported then
    local TwistedTab = Window:CreateTab("Twisted", "party-popper")

    TwistedTab:CreateSection("Bypasses")
    TwistedTab:CreateButton({
        Name = "TwistedB (Bypass)",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/sc0t6/OSHhub/refs/heads/main/scripts/bypasstwisted.lua"))()
        end
    })

    TwistedTab:CreateSection("Tornado Interceptor")

    -- Logic to find tornadoes
    local function getTornadoList()
        local list = {}
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Model") and (string.find(v.Name:lower(), "tornado") or string.find(v.Name:lower(), "funnel")) then
                table.insert(list, v.Name)
            end
        end
        if #list == 0 then table.insert(list, "No Tornadoes Found") end
        return list
    end

    local TornadoDropdown = TwistedTab:CreateDropdown({
        Name = "Select Target Tornado",
        Options = getTornadoList(),
        CurrentOption = "",
        Flag = "TornadoDropdown", 
        Callback = function(Option)
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("Model") and v.Name == Option[1] then
                    selectedTornado = v
                    if v.PrimaryPart then lastTornadoPos = v.PrimaryPart.Position end
                    Rayfield:Notify({Title = "Target Acquired", Content = "Tracking: " .. v.Name, Duration = 3})
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
        Range = {50, 300},
        Increment = 10,
        Suffix = "Studs",
        CurrentValue = 100,
        Flag = "DistSlider", 
        Callback = function(Value)
            interceptDistance = Value
        end,
    })

    -- TELEPORT TO INTERCEPT (MANUAL DROP)
    TwistedTab:CreateButton({
        Name = "Teleport to Intercept Path",
        Callback = function()
            if selectedTornado and selectedTornado.PrimaryPart then
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local root = char.HumanoidRootPart
                    local tPrim = selectedTornado.PrimaryPart
                    
                    -- Velocity Prediction
                    local direction = tornadoVelocity.Unit
                    if direction.X ~= direction.X then direction = Vector3.new(1,0,0) end -- NaN check
                    
                    local interceptPos = tPrim.Position + (direction * interceptDistance)
                    -- Ensure we are on the ground (approximate)
                    local rayOrigin = interceptPos + Vector3.new(0, 50, 0)
                    local rayDirection = Vector3.new(0, -100, 0)
                    local raycastParams = RaycastParams.new()
                    raycastParams.FilterDescendantsInstances = {char, selectedTornado}
                    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
                    
                    local rayResult = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
                    local finalY = tPrim.Position.Y 
                    
                    if rayResult then
                        finalY = rayResult.Position.Y + 3 -- 3 studs above ground
                    else
                        finalY = tPrim.Position.Y + 5 -- fallback
                    end

                    local finalPos = Vector3.new(interceptPos.X, finalY, interceptPos.Z)
                    
                    -- Store this spot so we can return to it later
                    lastProbePos = finalPos 
                    
                    root.CFrame = CFrame.new(finalPos, tPrim.Position) -- Look at tornado
                    Rayfield:Notify({Title = "Intercept", Content = "Teleported to path. Drop your probe!", Duration = 3})
                end
            else
                Rayfield:Notify({Title = "Error", Content = "Select a tornado first.", Duration = 3})
            end
        end,
    })

    -- RETURN TO PROBE
    TwistedTab:CreateButton({
        Name = "Return to Last Drop Site",
        Callback = function()
            if lastProbePos then
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = CFrame.new(lastProbePos)
                    Rayfield:Notify({Title = "Returned", Content = "Teleported to last drop site.", Duration = 3})
                end
            else
                Rayfield:Notify({Title = "Error", Content = "No previous drop site recorded.", Duration = 3})
            end
        end,
    })

    -- SUICIDE INTERCEPT (INSIDE TORNADO)
    TwistedTab:CreateButton({
        Name = "Teleport INSIDE Tornado (High Altitude)",
        Callback = function()
            if selectedTornado and selectedTornado.PrimaryPart then
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local tPos = selectedTornado.PrimaryPart.Position
                    -- Teleport 300 studs above the center
                    local highPos = Vector3.new(tPos.X, tPos.Y + 300, tPos.Z)
                    
                    char.HumanoidRootPart.CFrame = CFrame.new(highPos)
                    Rayfield:Notify({Title = "YOLO", Content = "Teleported inside funnel.", Duration = 3})
                end
            else
                Rayfield:Notify({Title = "Error", Content = "Select a tornado first.", Duration = 3})
            end
        end,
    })

    -- Background Velocity Calculator
    RunService.Heartbeat:Connect(function(deltaTime)
        if selectedTornado and selectedTornado.PrimaryPart then
            local currentPos = selectedTornado.PrimaryPart.Position
            local displacement = currentPos - lastTornadoPos
            tornadoVelocity = displacement / deltaTime
            lastTornadoPos = currentPos
        end
    end)
end

Rayfield:Notify({
    Title = "Welcome to OSHhub | Tester Version!",
    Content = "Feel free to share the script but only keep it off websites.",
    Duration = 3
})

Rayfield:LoadConfiguration()
