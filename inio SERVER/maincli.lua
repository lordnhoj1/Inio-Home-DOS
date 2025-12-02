local serverIdentifier = "MAIN" -- this should stay as main
local userInput = nil

onNetworkEvent(function(data)
	local dataData = data:split("+++")
	if dataData[1] == serverIdentifier then
		print("REMOTE ("..dataData[3].."): "..dataData[2])
	end
end)

local events = { -- custom events go here
    ["ping"] = function(target)
        sendNetworkPacket(target.."+++RETURN-STATUS+++"..serverIdentifier)
    end,
}

wait(1)

local function main()
    while wait() do
        userInput = input()
        print("LOCAL: "..userInput)
        userInput = userInput:split("+")
        local succ,err = pcall(events[userInput[1]], unpack(userInput, 2, #userInput))
        if not succ then
            print("BAD EVENT AT: "..table.concat(userInput, "+"))
        end
    end
end

main()
