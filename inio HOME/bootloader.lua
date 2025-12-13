clear()

local startTime = os.time()
local console = {}
local drives = {}
local bootFile = nil
local bootFileDrive = 1
local drive = nil
local cliState = true
local http = GetService("HttpService")


-- function definintions

local function crash(sector, code)
	clear()
	print(string.format("%s fault\nerror: %s\n\nrestarting...", sector, code))
	wait(3)
    halt()
end

console.log = function(text)
	local currentTime = tostring(os.time()-startTime)
	print(string.format("[%s]: %s", currentTime, text))
end

console.warn = function(text)
    print("⚠ - "..text)
end

console.err = function(text)
    print("ⓧ - "..text)
end

local cmds = {
    ["Get-Help"] = function()
        print("WE GET IT")
        print("\nur a noob\n")
        print("Current commands:\nGet-Help | prints a list of commands to the terminal\nSet-Drive (int: drive number) | sets the current drive to the specified drive number\nExit-terminal | exits you out of the cli\nForce-Crash | forces the bootloader to crash and shut off\n")
    end,
    ["Set-Drive"] = function(Drive)
        if (drives[tonumber(Drive)])["port filled?"] == true then
            console.log(string.format("set current drive to %d", Drive))
            drive = disk.init(tonumber(Drive))
            bootFileDrive = Drive
        else
            console.err(string.format("no drive on input %s", Drive))
        end
    end,
    ["Exit-Terminal"] = function()
        cliState = false
    end,
    ["Force-Crash"] = function()
        crash("bootloader cli", "requested by user")
    end,
    ["Get-InioHome"] = function()
        (drives[tonumber(bootFileDrive)])["boot file"] = "boot.efi"
        local contents = http:GetAsync("https://raw.githubusercontent.com/lordnhoj1/Inio-DOS/refs/heads/main/inio%20HOME/maincli.lua")
        drive.writeFile("boot.efi", contents)
    end
}

local function cli()
    clear()
    print("inio bootloader cli\nGet-Help for help.")
    while cliState == true and wait() do
        write("\\ ")
        local userInput = input()
        print(userInput)
        local userInputTab = userInput:split(" ")
        local succ, err = pcall(cmds[userInputTab[1]], unpack(userInputTab, 2, #userInputTab))
        if not succ then
            console.warn("command not found.")
        end
    end
end


-- drive testing

print("testing for external drives.\nthis is mostly for backwards compatability")

for i = 1,6 do
    console.log(string.format("checking input %d", i))
    local driveTest = disk.init(i) or false
    if driveTest == false then
        console.log(string.format("no drive found at input %d", i))
        drives[i] = {["port filled?"] = false}
    else
        console.log(string.format("drive found at input %d", i))
        drives[i] = {["port filled?"] = true}
    end
    wait()
end

wait(math.random(3, 10)/10)

print("\nchecking filesystems.")

for i,v in pairs(drives) do
    if v["port filled?"] == true then
        local driveTest = disk.init(i)
        if driveTest.readFile("filememory.sys") then
            v["file system"] = "inioFMS"
            console.log(string.format("drive %d fs is inioFMS", i))
        elseif driveTest.readFile("fileJSON.sys") then
            v["file system"] = "inioJFMS"
        else
            v["file system"] = "RAW or undefined"
            console.log(string.format("drive %d fs is RAW or undefined", i))
        end
        wait()
    end
end

wait(math.random(3, 10)/10)
print("\nsearching for boot file in external drives.")

for i,v in pairs(drives) do
    if v["port filled?"] == true then
        local Drive = disk.init(i)
        bootFile = Drive.readFile("boot.efi") or false
        if not bootFile then
            v["boot file"] = false
            console.log(string.format("no boot file in drive %d", i))
            bootFile = false
        else
            v["boot file"] = "boot.efi"
            bootFileDrive = i
            bootFile = true
            break
        end
        wait()
    end
end

local function checkBoot()
    if bootFile == false then
        print("\nno boot file was found during the search.\nplease specify which file you would like to boot from.\ntype *cli to enter the command line.")
        write(">> ")
        local userInput = input()
        print(userInput)
        if userInput == "*cli" then
            cli()
            for i,v in pairs(drives) do
                if v["port filled?"] and v["boot file"] == "boot.efi" then
                    return true
                end
            end
        end
        bootFile = userInput
        print("\nwhich drive is this located in?")
        for i,v in pairs(drives) do
            if v["port filled?"] == true then
                print(string.format("drive %d", i))
            end
            wait()
        end
        write(">> ")
        local h = input()
        bootFileDrive = tonumber(h)
        print(h)
        local driveTest = disk.init(bootFileDrive)
        local BootFile = driveTest.readFile(bootFile) or false
        if not BootFile then
            print(string.format("no boot file named %s in drive %d.", bootFile, bootFileDrive))
            bootFile = false
            return false
        end
    else
        return true
    end
end

while wait() do
    local passed = checkBoot()
    if passed then
        print("\nbooting")
        wait(1)
        drive = disk.init(tonumber(bootFileDrive))
        local bootfile = (drives[tonumber(bootFileDrive)])["boot file"]
        local fileContents = drive.readFile(bootfile)
        local func = loadstring(fileContents)()
        func(drives)
        break
    else
        checkBoot()
    end
end

cli()

console.log("exiting...")
wait(1)
halt()
