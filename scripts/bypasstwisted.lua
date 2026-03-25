local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local pGui = lp:WaitForChild("PlayerGui")

warn(">> Starting Lobotomy on CheatHandler...")

-- lobotmizes the nil parent cheathandler
for _, conn in pairs(getconnections(hum.Changed)) do
    local func = conn.Function
    if func and getfenv(func).script and getfenv(func).script.Parent == nil then
        conn:Disable()
        warn("removed nil parent thingy")
    end
end

-- removes checks
for _, conn in pairs(getconnections(char.DescendantAdded)) do
    local func = conn.Function
    if func and getfenv(func).script and getfenv(func).script.Parent == nil then
        conn:Disable()
        warn("removed checks")
    end
end

-- removes listener and gui monitor stuff thing
for _, conn in pairs(getconnections(pGui.ChildAdded)) do
    local func = conn.Function
    if func and getfenv(func).script and getfenv(func).script.Parent == nil then
        conn:Disable()
        warn("disabled gui check")
    end
end

warn(">> Lobotomy complete. Rage away.")
