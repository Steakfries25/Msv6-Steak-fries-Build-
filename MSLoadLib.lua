/*
Modern Sonic Load Library
	by Lach

just lending a hand with compressing and parsing data from Modern Sonic's settings file for use with netcommands :D
don't touch this file without my permission :taerht:
*/

rawset(_G, "MSLoadLib", {})

// load sha2 if not it does not exist already
// I've been looking for a reason to use this >:3
if not sha2
	dofile("sha2-v1.0.lua")
end

// returns the maximum value of a Felix44 menu option
function MSLoadLib.GetOptionMaxValue(option)
	return (option.maxIOvalue or option.maxvalue or 2) - 1
end

// returns the menu hash, which is generated from all the menu option names and max values smooshed together
local menuHash
function MSLoadLib.GetMenuHash(menuContents)
	if menuHash == nil
		menuHash = ""
		
		for _, page in ipairs(menuContents)
			for _, option in ipairs(page)
				if (option.flags or 0) & MNF_NOSAVE
					continue
				end
				
				menuHash = $ .. option.name .. MSLoadLib.GetOptionMaxValue(option)
			end
		end
		
		menuHash = sha2($)
	end
	
	return menuHash
end

// verifies the hash from a freshly opened file matches the current hash of the menu contents
function MSLoadLib.VerifyFileVersion(file, menuContents)
	return file:read("*l") == MSLoadLib.GetMenuHash(menuContents)
end

// given a Modern Sonic configuration file and a Felix44 menu.contents table, returns a table of bitfields with all the data from the file.
function MSLoadLib.FileToBitfieldTable(file, menuContents)
	local data = {0}
	local index = 1
	local shift = 0
	for _, page in ipairs(menuContents)
		for _, option in ipairs(page)
			if (option.flags or 0) & MNF_NOSAVE // ignore anything that doesn't get saved
				continue
			end
			
			local maxValue = MSLoadLib.GetOptionMaxValue(option) // the maximum value that this option can be
			local value = tonumber(file:read("*l"))
			
			assert(maxValue > 0, "Maximum value of option '" .. option.name .. "' is too small!")
			assert(value ~= nil, "Value for option '".. option.name .. "' could not be read from the file!")
			
			local newShift = shift
			
			while maxValue
				newShift = $ + 1
				maxValue = $ >> 1
			end
			
			if newShift > 32 // storing this value will overflow the current number, so create another
				index = $ + 1
				data[index] = 0
				newShift = $ - shift
				shift = 0
			end
			
			data[index] = $ + (value << shift)
			shift = newShift
		end
	end
	return data
end

// given the arguments passed via command, checks for the presence of the "-load" flag and that all remaining entries are numbers
function MSLoadLib.ValidateArgs(args)
	local valid = false
	for i = #args, 1, -1
		local arg = args[i]
		if arg == "-load"
			valid = true
			table.remove(args, i)
		else
			arg = tonumber($)
			if arg == nil
				valid = false
				break
			end
			args[i] = arg
		end
	end
	return valid
end

// given VALIDATED arguments passed via command, sets up the variables used to parse their contents
local totalShift
local index
local arg
local currentArgs
function MSLoadLib.InitRead(args)
	totalShift = 0
	index = 1
	arg = args[index]
	currentArgs = args
end

// given a Felix44 menu option, sets its value to the appropriate data parsed from the variables
// returns true if successful
function MSLoadLib.ReadMenuOption(option)
	local shift = 0
	local maxValue = MSLoadLib.GetOptionMaxValue(option) // the maximum value that this option can be
	
	while maxValue
		shift = $ + 1
		maxValue = $ >> 1
	end
	totalShift = $ + shift
	if totalShift > 32
		totalShift = shift
		index = $ + 1
		arg = currentArgs[index]
		if arg == nil
			if player == consoleplayer
				error("File is too small; expected more settings to load!")
			else
				return
			end
		end
	end
	
	option.value = arg & ((1 << shift) - 1)
	arg = $ >> shift
	return true
end