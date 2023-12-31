--> !!IMPORTANT!! 
--> PLAYIT.gg required as of 10/01/2023 (MM/DD/YYYY)
local PLAYIT_ENABLED = true
local PLAYIT_ADDR = ""
local PLAYIT_PORT = 0

local masterServerAddr = "209.25.140.181:45279" --> Brickline
local ServerName = "Novetus | %MAP% | %CLIENT%"
--> Note: %MAP% and %CLIENT% are variables and will automatically get replaced by the client and map name.

--> DO NOT EDIT BELOW!!!
--> For developers, the source code is available at https://github.com/N0THSA/brickline





































local function rndID(length)
	local res = ""
	for i = 1, length do
		res = res .. string.char(math.random(97, 122))
	end
	return res
end


local function getPlayerCount(max)
    local count = game.Players:GetChildren()

    for _, v in ipairs(count) do 
        if v.Name == "[SERVER]" and not v.Character then
            return tostring(#count - 1).."/"..tostring(max - 1)
        end
    end

    return tostring(#count).."/"..tostring(max)
end


local function masterServerPinger()
    --> Init
    local ID         = rndID(50)
    local maxPlayers = game.Players.MaxPlayers
    local ClientVer  = game.Lighting.Version.Value
    local num        = 0
    local mapName    = tostring(game)
    local port       = game.NetworkServer.Port
    local requestURI = "?id="..tostring(ID).."&client="..ClientVer.."&map="..mapName.."&name="..ServerName
    local ipAddr     = ""

    if PLAYIT_ENABLED and PLAYIT_ADDR ~= "" and PLAYIT_PORT >= 1 and PLAYIT_PORT <= 65535 then
        port   = PLAYIT_PORT
        ipAddr = PLAYIT_ADDR
    end

    print("Creating new server on master server: " .. masterServerAddr)

    local callServer = Instance.new("Sound", game.Lighting)
        callServer.Name = "Create server"
        callServer.SoundId = "http://"..masterServerAddr.."/server/create"..requestURI.."&players="..getPlayerCount(maxPlayers).."&playitIP="..ipAddr.."&port="..port

    --> Done creating new server on master
    callServer:remove()
    print("Done creating server on master server.")

    while wait(5) do
        --> This is because roblox will block request making requests to the same URI multiple times.
        num = num + 1

        local keepAlive = Instance.new("Sound", game.Lighting)
            keepAlive.Name = "Pinging master server"
            keepAlive.SoundId = "http://"..masterServerAddr.."/server/keepAlive"..num..requestURI.."&players="..getPlayerCount(maxPlayers).."&playitIP="..ipAddr.."&port="..port

        keepAlive:remove()
    end
end


this = {}

function this:Name()
    return "Custom master server script by enuf"
end

function this:PostInit()
    print("\nHello from addon\n")

    --> If studio type isn't a server, then stop don't execute.
    if game.Lighting.ScriptLoaded.Value ~= "Server" then
        print("This is not a server. Stopping master server script.") return end

    local MSC = coroutine.create(masterServerPinger)
    coroutine.resume(MSC)

end

function AddModule(t)
    print("AddonLoader: Adding " .. this:Name())
    table.insert(t, this)
end

_G.CSScript_AddModule=AddModule
