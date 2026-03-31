local Players = game:GetService("Players")
local lp = Players.LocalPlayer

local function lobotomy()
    local char = lp.Character or lp.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    local pGui = lp:WaitForChild("PlayerGui")

    warn(">> Starting Lobotomy on CheatHandler...")

    -- Lobotomizes the nil parent cheathandler
    for _, conn in pairs(getconnections(hum.Changed)) do
        local func = conn.Function
        if func and getfenv(func).script and getfenv(func).script.Parent == nil then
            conn:Disable()
            warn("removed nil parent thingy")
        end
    end

    -- Removes checks
    for _, conn in pairs(getconnections(char.DescendantAdded)) do
        local func = conn.Function
        if func and getfenv(func).script and getfenv(func).script.Parent == nil then
            conn:Disable()
            warn("removed checks")
        end
    end

    -- Removes listener and gui monitor stuff
    for _, conn in pairs(getconnections(pGui.ChildAdded)) do
        local func = conn.Function
        if func and getfenv(func).script and getfenv(func).script.Parent == nil then
            conn:Disable()
            warn("disabled gui check")
        end
    end

    warn(">> Lobotomy complete. Rage away.")
end

-- Run it immediately for the first spawn
task.spawn(lobotomy)

-- Run it every time the character respawns thereafter
lp.CharacterAdded:Connect(function()
    -- Small delay to ensure all scripts have loaded into the new character
    task.wait(0.5) 
    lobotomy()
end)
