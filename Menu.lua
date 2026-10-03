--FrostiiColorshit
freeslot("SKINCOLOR_MODMEN")

skincolors[SKINCOLOR_MODMEN] = {
    name = "MODMEN",
    ramp = {31,31,31,31,31,254,159,157,159,254,31,31,31,31,31,31},
    invcolor = SKINCOLOR_RUST,
    invshade = 0, 
    chatcolor = V_MAGENTAMAP,
    accessible = false 
}

local flashColors = {
    skincolors[SKINCOLOR_MODMEN],
}
local flashDelay = 2 //change this to how many tics it takes to animate

local rampPos = 1
local rampDir = true
local ramps = {}

for curcol = 1, table.maxn(flashColors), 1
    ramps[curcol] = {{}}
    for i = 0, 15, 1
        ramps[curcol][1][i+1] = flashColors[curcol].ramp[i]
    end

    for i = 2, 16,1
        ramps[curcol][i] = {{}}

        for pos,val in ipairs(ramps[curcol][i-1]) do
            if not (pos == 16) then
                ramps[curcol][i][pos+1] = val
            else
                ramps[curcol][i][1] = val
            end
        end
    end
end

local function RampWave()
    if not (leveltime % flashDelay) then

        rampPos = $1+1
        
        //too high, time to go back
        if not (ramps[1][rampPos])
            rampPos = 1
        end
        
        for i = 1, table.maxn(ramps), 1
            flashColors[i].ramp = ramps[i][rampPos]
        end
    end
end

addHook("ThinkFrame", RampWave)

rawset(_G, "LoadModernSettings", function(player)
	if player == consoleplayer // only open files if this player is the client
		local file = io.openlocal("client/ModernSettings.dat")
		if not file // if the file does not exist, the default settings don't need to be changed
			return
		end
		if MSLoadLib.VerifyFileVersion(file, player.modernmenu.contents)
			local data = MSLoadLib.FileToBitfieldTable(file, player.modernmenu.contents)
			if data ~= nil // make sure there was no error
				COM_BufInsertText(player, "loadmodernsettings -load " .. table.concat(data, " "))
			end
		end
		file:close()
	end
end)

local function RandomizeColors(player)
	if player.mo
	and player.modernmenu
	and player.modernmenu.contents
		for i = 1, 13
			player.modernmenu.contents[8][i].value = P_RandomRange(0, player.modernmenu.contents[8][i].maxvalue-1)
		end
	end
end
	
local function SetDefaultOption(player)
	if player.mo
	and player.modernmenu
	and player.modernmenu.contents
	and player.modernmenu.show
		if player.modernmenu.contents[player.modernmenu.pagepointer][player.modernmenu.pointer].defaultvalue ~= nil
			S_StartSound(player.mo, sfx_mmenu1, player)
			player.modernmenu.contents[player.modernmenu.pagepointer][player.modernmenu.pointer].value = player.modernmenu.contents[player.modernmenu.pagepointer][player.modernmenu.pointer].defaultvalue
			player.modernmenu.timer = 5
		end
	end
end

local function SetModernPreset(player, preset)
	if player.mo and player.mo.skin == "modernsonic"
		if preset == "Unleashed"
			player.modernmenu.contents[3][1].value = 0 --Unleashed HUD
			player.modernmenu.contents[6][1].value = 1 --Voices forced on
			player.modernmenu.contents[6][2].value = 0 --Voice Actor
			player.modernmenu.contents[6][3].value = 0 --Super Music
			player.modernmenu.contents[7][1].value = 1 --Boost Aura
			player.modernmenu.contents[7][2].value = 0 --Boost Trail
			player.modernmenu.contents[7][4].value = 0 --Jump Style
			player.modernmenu.contents[7][5].value = 1 --Jump Aura
			player.modernmenu.contents[10][1].value = 1 --Jump Sound
			player.modernmenu.contents[10][2].value = 2 --Boost Sound
			player.modernmenu.contents[10][3].value = 2 --Skidding Sound
			player.modernmenu.contents[10][4].value = 2 --Rolling Sound
			player.modernmenu.contents[10][5].value = 2 --Spindash Sound
			player.modernmenu.contents[10][6].value = 2 --Dropdash Sound
			player.modernmenu.contents[10][7].value = 3 --Dash Release Sound
			player.modernmenu.contents[10][8].value = 0 --Lock-On Sound
			player.modernmenu.contents[10][9].value = 2 --Homing Sound
			player.modernmenu.contents[10][10].value = 1 --Trick Sounds
		elseif preset == "Generations"
			player.modernmenu.contents[3][1].value = 1 --Generations HUD
			player.modernmenu.contents[6][1].value = 1 --Voices forced on
			player.modernmenu.contents[6][2].value = 1 --Voice Actor
			player.modernmenu.contents[6][3].value = 1 --Super Music
			player.modernmenu.contents[7][1].value = 2 --Boost Aura
			player.modernmenu.contents[7][2].value = 0 --Boost Trail
			player.modernmenu.contents[7][4].value = 0 --Jump Style
			player.modernmenu.contents[7][5].value = 1 --Jump Aura
			player.modernmenu.contents[10][1].value = 1 --Jump Sound
			player.modernmenu.contents[10][2].value = 2 --Boost Sound
			player.modernmenu.contents[10][3].value = 2 --Skidding Sound
			player.modernmenu.contents[10][4].value = 4 --Rolling Sound
			player.modernmenu.contents[10][5].value = 4 --Spindash Sound
			player.modernmenu.contents[10][6].value = 6 --Dropdash Sound
			player.modernmenu.contents[10][7].value = 4 --Dash Release Sound
			player.modernmenu.contents[10][8].value = 0 --Lock-On Sound
			player.modernmenu.contents[10][9].value = 2 --Homing Sound
			player.modernmenu.contents[10][10].value = 0 --Trick Sounds
		elseif preset == "Colors"
			player.modernmenu.contents[3][1].value = 3 --Colors HUD
			player.modernmenu.contents[6][1].value = 1 --Voices forced on
			player.modernmenu.contents[6][2].value = 1 --Voice Actor
			player.modernmenu.contents[6][3].value = 3 --Super Music
			player.modernmenu.contents[7][1].value = 3 --Boost Aura
			player.modernmenu.contents[7][2].value = 0 --Boost Trail
			player.modernmenu.contents[7][4].value = 1 --Jump Style
			player.modernmenu.contents[7][5].value = 2 --Jump Aura
			player.modernmenu.contents[10][1].value = 1 --Jump Sound
			player.modernmenu.contents[10][2].value = 2 --Boost Sound
			player.modernmenu.contents[10][3].value = 2 --Skidding Sound
			player.modernmenu.contents[10][4].value = 2 --Rolling Sound
			player.modernmenu.contents[10][5].value = 2 --Spindash Sound
			player.modernmenu.contents[10][6].value = 2 --Dropdash Sound
			player.modernmenu.contents[10][7].value = 3 --Dash Release Sound
			player.modernmenu.contents[10][8].value = 0 --Lock-On Sound
			player.modernmenu.contents[10][9].value = 2 --Homing Sound
			player.modernmenu.contents[10][10].value = 2 --Trick Sounds
		elseif preset == "Forces"
			player.modernmenu.contents[3][1].value = 2 --Forces HUD
			player.modernmenu.contents[6][1].value = 1 --Voices forced on
			player.modernmenu.contents[6][2].value = 1 --Voice Actor
			player.modernmenu.contents[6][3].value = 2 --Super Music
			player.modernmenu.contents[7][1].value = 5 --Boost Aura
			player.modernmenu.contents[7][2].value = 1 --Boost Trail
			player.modernmenu.contents[7][4].value = 3 --Jump Style
			player.modernmenu.contents[7][5].value = 4 --Jump Aura
			player.modernmenu.contents[10][1].value = 4 --Jump Sound
			player.modernmenu.contents[10][2].value = 3 --Boost Sound
			player.modernmenu.contents[10][3].value = 2 --Skidding Sound
			player.modernmenu.contents[10][4].value = 4 --Rolling Sound
			player.modernmenu.contents[10][5].value = 4 --Spindash Sound
			player.modernmenu.contents[10][6].value = 5 --Dropdash Sound
			player.modernmenu.contents[10][7].value = 3 --Dash Release Sound
			player.modernmenu.contents[10][8].value = 1 --Lock-On Sound
			player.modernmenu.contents[10][9].value = 2 --Homing Sound
			player.modernmenu.contents[10][10].value = 4 --Trick Sounds
		elseif preset == "Rush"
			player.modernmenu.contents[3][1].value = 5 --Rush HUD
			player.modernmenu.contents[6][1].value = 1 --Voices forced on
			player.modernmenu.contents[6][2].value = 0 --Voice Actor
			player.modernmenu.contents[6][3].value = 5 --Super Music
			player.modernmenu.contents[7][1].value = 4 --Boost Aura
			player.modernmenu.contents[7][2].value = 1 --Boost Trail
			player.modernmenu.contents[7][4].value = 2 --Jump Style
			player.modernmenu.contents[7][5].value = 3 --Jump Aura
			player.modernmenu.contents[10][1].value = 0 --Jump Sound
			player.modernmenu.contents[10][2].value = 0 --Boost Sound
			player.modernmenu.contents[10][3].value = 0 --Skidding Sound
			player.modernmenu.contents[10][4].value = 0 --Rolling Sound
			player.modernmenu.contents[10][5].value = 0 --Spindash Sound
			player.modernmenu.contents[10][6].value = 0 --Dropdash Sound
			player.modernmenu.contents[10][7].value = 0 --Dash Release Sound
			player.modernmenu.contents[10][8].value = 3 --Lock-On Sound
			player.modernmenu.contents[10][9].value = 0 --Homing Sound
			player.modernmenu.contents[10][10].value = 3 --Trick Sounds
		elseif preset == "2006"
			player.modernmenu.contents[3][1].value = 4 --06 HUD
			player.modernmenu.contents[6][1].value = 1 --Voices forced on
			player.modernmenu.contents[6][2].value = 0 --Voice Actor
			player.modernmenu.contents[6][3].value = 4 --Super Music
			player.modernmenu.contents[7][1].value = 6 --Boost Aura
			player.modernmenu.contents[7][2].value = 0 --Boost Trail
			player.modernmenu.contents[7][4].value = 0 --Jump Style
			player.modernmenu.contents[7][5].value = 3 --Jump Aura
			player.modernmenu.contents[10][1].value = 1 --Jump Sound
			player.modernmenu.contents[10][2].value = 1 --Boost Sound
			player.modernmenu.contents[10][3].value = 1 --Skidding Sound
			player.modernmenu.contents[10][4].value = 1 --Rolling Sound
			player.modernmenu.contents[10][5].value = 1 --Spindash Sound
			player.modernmenu.contents[10][6].value = 1 --Dropdash Sound
			player.modernmenu.contents[10][7].value = 1 --Dash Release Sound
			player.modernmenu.contents[10][8].value = 3 --Lock-On Sound
			player.modernmenu.contents[10][9].value = 1 --Homing Sound
			player.modernmenu.contents[10][10].value = 0 --Trick Sounds
		end
	end
end
		

--[[SIMPLE MENU v1.0
--follow the comments to use this Lua in your mod, if you find any issue let me know!
	--Felix44]]
--MENU FLAGS
rawset(_G, "MNF_SLIDER", 1) --makes a setting display a slider instead of a string as its value (works the same way as the "slider" parameter)
rawset(_G, "MNF_NOSAVE", 2) --a value with this flag will not be saved/loaded from the save file
rawset(_G, "MNF_SHOWVALUE", 4) --forces the setting to display it's value, since only function settings and page changer settings don't display theirs it should only be used for those (NOTE: function settings don't have any option parameter set to them by default, don't forget to include it!)
rawset(_G, "MNF_CHANGEPAGE", 8) --settings with this flag will change the page pointer, allowing to make more complex menus with more pages and stuff, selcting these settings will change the menu page to the one defined in its "value" parameter, I suggest to give these settings the MNF_NOSAVE flag too since usually the "value" of this setting wouldn't be able to change and thus wouldn't need to be saved

addHook("PlayerSpawn", function(player)
	player.modernmenu = {}
	player.modernmenu.pointer = 1
	player.modernmenu.pagepointer = 1
	player.modernmenu.pagename = "Main Menu"
	player.modernmenu.show = false
	player.modernmenu.timer = 0
	player.modernmenu.timerhold = 0
	player.modernmenu.contents = { --you can delete these elements of the menu or use them as reference, info to make yours is below!
		[1] = { -- Main menu
			{value = 2, name = "Gameplay", description = "Gameplay Settings", flags = MNF_CHANGEPAGE|MNF_NOSAVE, pagename = "Gameplay Settings", vflags = V_BLUEMAP},
			{value = 3, name = "Cosmetics", description = "Cosmetic Settings", flags = MNF_CHANGEPAGE|MNF_NOSAVE, pagename = "Cosmetic Settings", vflags = V_BLUEMAP},
			{value = 4, name = "Rush", description = "Rush Settings", flags = MNF_CHANGEPAGE|MNF_NOSAVE, pagename = "Rush Settings", vflags = V_BLUEMAP},
			{value = 9, name = "Presets", description = "Preset Menu", flags = MNF_CHANGEPAGE|MNF_NOSAVE, pagename = "Preset Settings", vflags = V_BLUEMAP}},
		[2] = { -- Gameplay menu
			{defaultvalue = 1, value = 1, name = "Jump Ability", description = "Changes mid-air ability (after double jump)", maxvalue = 4, options = {"None", "Double-Jump", "Air-Dash(U)", "Air-Dash(G)"}, vflags = V_GRAYMAP},
			{defaultvalue = 0, value = 0, name = "Actionswap", description = "Switches the boost and stomp buttons {ON/OFF}", vflags = V_GRAYMAP},
			{defaultvalue = 1, value = 1, name = "ModernFOV", description = "Toggles the FOV change when boosting {ON/OFF}", vflags = V_GRAYMAP},
			{defaultvalue = 1, value = 1, name = "Quakes", description = "Toggles quakes present in boost/stomp/homing attack {ON/OFF}", vflags = V_GRAYMAP},
			{defaultvalue = 0, value = 0, name = "Homing Cam", description = "Toggles Homing Cam!", maxvalue = 3, options = {"Off", "Gradual", "Static"}, vflags = V_GRAYMAP},
			{defaultvalue = 1, value = 1, name = "Drift", description = "Toggles Drift controls!", maxvalue = 3, options = {"Fixed", "Smooth", "Hybrid"}, vflags = V_GRAYMAP},
			{defaultvalue = 1, value = 1, name = "Ring Speed", description = "Toggles Ring Speed {ON/OFF}", vflags = V_GRAYMAP},
			{defaultvalue = 0, value = 0, name = "AutoTrick", description = "Toggles Auto Tricking!", maxvalue = 3, options = {"Off", "Assisted", "Automated"}, vflags = V_GRAYMAP},
			{defaultvalue = 0, value = 0, name = "Dropdash", description = "Toggles Dropdash", maxvalue = 3, options = {"Off", "On", "Easy"}, vflags = V_GRAYMAP},
			{defaultvalue = 0, value = 0, name = "Spindash", description = "Toggles the Spindash! {ON/OFF}", vflags = V_GRAYMAP},
			{defaultvalue = 1, value = 1, name = "Homing Attack", description = "Change the input used for the Homing Attack!", maxvalue = 3, options = {"Off", "Jump", "Fire Normal"}, vflags = V_GRAYMAP},
			{value = 1, name = "Back", description = "Go back to Main Menu", flags = MNF_CHANGEPAGE|MNF_NOSAVE, pagename = "Main Menu"}},
		[3] = { -- Cosmetics menu 
			{defaultvalue = 0, value = 0, name = "HUDStyle", description = "Toggles which HUD you use!", maxvalue = 10, options = {"Unleashed", "Generations", "Forces", "Colors", "Sonic 06", "Rush", "Legacy", "SRB2", "Unwiished", "All of it"}, vflags = V_GRAYMAP},
			{defaultvalue = 1, value = 1, name = "Speedlines", description = "Toggles Speedlines while Boosting {ON/OFF}", vflags = V_GRAYMAP},
			{defaultvalue = 1, value = 1, name = "Flickies", description = "Toggles cheering Flickies {ON/OFF}", vflags = V_GRAYMAP},
			{defaultvalue = 7, value = 7, name = "Effects", description = "Effect Settings", flags = MNF_CHANGEPAGE|MNF_NOSAVE, pagename = "Effect Settings", vflags = V_BLUEMAP},
			{defaultvalue = 5, value = 5, name = "Blending", description = "Blending Settings", flags = MNF_CHANGEPAGE|MNF_NOSAVE, pagename = "Blending Settings", vflags = V_BLUEMAP},
			{defaultvalue = 8, value = 8, name = "Colors", description = "Color Settings", flags = MNF_CHANGEPAGE|MNF_NOSAVE, pagename = "Color Settings", vflags = V_BLUEMAP},
			{defaultvalue = 6, value = 6, name = "Audio", description = "Audio Settings", flags = MNF_CHANGEPAGE|MNF_NOSAVE, pagename = "Audio Settings", vflags = V_BLUEMAP},
			{value = 1, name = "Back", description = "Go back to Main Menu", flags = MNF_CHANGEPAGE|MNF_NOSAVE, pagename = "Main Menu"}},
		[4] = { -- Rush menu
			{defaultvalue = 1, value = 1, name = "Rush Mode", description = "Toggles Rush Mode {ON/OFF}", vflags = V_GRAYMAP},
			{defaultvalue = 1, value = 1, name = "Rush Glow Blending", description = "Sets Rush Glow blending. {ON/OFF}", toggledby = 1, vflags = V_GRAYMAP},
			{defaultvalue = 1, value = 1, name = "Rush Glow", description = "Sets Rush Glow. {ON/OFF}", toggledby = 1, vflags = V_GRAYMAP},
			{defaultvalue = 0, value = 0, name = "Rush Glow Color", description = "Sets Rush Glow color. Currently ", flags = MNF_SLIDER, maxvalue = #skincolors, maxIOvalue = MAXSKINCOLORS, toggledby = 3, vflags = V_GRAYMAP},
			{value = 1, name = "Back", description = "Go back to Main Menu", flags = MNF_CHANGEPAGE|MNF_NOSAVE, pagename = "Main Menu"}},
		[5] = { -- Blending menu
			{defaultvalue = 1, value = 1, name = "Boost Trail Blending", description = "Toggles Boost Trail Blending {ON/OFF}"},
			{defaultvalue = 1, value = 1, name = "Jump Aura Blending", description = "Toggles Jump Aura Blending{ON/OFF}"},
			{defaultvalue = 1, value = 1, name = "Stomp Trail Blending", description = "Toggles Stomp Trail Blending {ON/OFF}"},
			{defaultvalue = 1, value = 1, name = "Stomp Aura Blending", description = "Toggles Stomp Aura Blending {ON/OFF}"},
			{defaultvalue = 1, value = 1, name = "Boost Aura Blending", description = "Toggles Boost Aura Blending {ON/OFF}"},
			{defaultvalue = 1, value = 1, name = "Kick Effect Blending", description = "Toggles Slide/HummingTop/SweepKick Blending {ON/OFF}"},
			{defaultvalue = 1, value = 1, name = "Homing Trail Blending", description = "Toggles Homing Trail Blending {ON/OFF}"},
			{value = 3, name = "Back", description = "Go back to Cosmetics", flags = MNF_CHANGEPAGE|MNF_NOSAVE, pagename = "Cosmetic Settings"}},
		[6] = { -- Audio menu
			{defaultvalue = 1, value = 1, name = "Voices", description = "Toggles Voices {ON/OFF}", vflags = V_GRAYMAP},
			{defaultvalue = 0, value = 0, name = "VA", description = "Choose your Voice Actor!", maxvalue = 6, options = {"Jason Griffith", "Roger Craig Smith", "Ryan Drummond", "Jun'ichi Kanemaru", "Feeling Good!", "Feeling Anime!"}, toggledby = 1, vflags = V_GRAYMAP},
			{defaultvalue = 0, value = 0, name = "Super Music", description = "Set the Super Music!", maxvalue = 7, options = {"Unleashed", "Generations", "Forces", "Colors", "Sonic 06", "Rush", "SRB2"}, vflags = V_GRAYMAP},
			{defaultvalue = 1, value = 1, name = "Footsteps", description = "Toggles the Footsteps {ON/OFF}"},
			{defaultvalue = 1, value = 1, name = "Super Aura", description = "Toggles Super Aura sound {ON/OFF}", vflags = V_GRAYMAP},
			{defaultvalue = 10, value = 10, name = "Sound Effects", description = "Sound Effect Settings", flags = MNF_CHANGEPAGE|MNF_NOSAVE, pagename = "Sound Effect Settings", vflags = V_BLUEMAP},
			{value = 3, name = "Back", description = "Go back to Cosmetics", flags = MNF_CHANGEPAGE|MNF_NOSAVE, pagename = "Cosmetic Settings"}},
		[7] = { -- Effects menu
			{defaultvalue = 0, value = 0, name = "Boost Aura", description = "Toggles which Boost Aura you use!", maxvalue = 9, options = {"SRB2", "Unleashed", "Generations", "Colors", "Rush", "Forces", "Frontiers", "Legacy", "All of it"}, vflags = V_GRAYMAP},
			{defaultvalue = 1, value = 1, name = "Boost Trail", description = "Toggles Boost Trail", maxvalue = 3, options = {"Off", "On", "Rush Mode"}, vflags = V_GRAYMAP},
			{defaultvalue = 1, value = 1, name = "Poses", description = "Toggles Posing after doing a Homing Attack {ON/OFF}", vflags = V_GRAYMAP},
			{defaultvalue = 0, value = 0, name = "Jump Style", description = "Toggles which Jump you use!", maxvalue = 5, options = {"Vanilla", "Ball", "Advance/Rush", "Legacy", "Smash"}, vflags = V_GRAYMAP},
			{defaultvalue = 1, value = 1, name = "Jump Aura", description = "Toggles which Jump Aura you use!", maxvalue = 5, options = {"SRB2", "Unleashed", "Colors", "None", "Frontiers"}, vflags = V_GRAYMAP},
			{defaultvalue = 0, value = 0, name = "Lightning Trail", description = "Toggles Lightning from the Boost Trail {ON/OFF}", vflags = V_GRAYMAP},
			{value = 3, name = "Back", description = "Go back to Cosmetics", flags = MNF_CHANGEPAGE|MNF_NOSAVE, pagename = "Cosmetic Settings"}},
		[8] = { -- Colors menu
			{defaultvalue = 0, value = 0, name = "Boost Aura", description = "Sets your Boost Aura color. Currently ", flags = MNF_SLIDER, maxvalue = #skincolors, maxIOvalue = MAXSKINCOLORS},
			{defaultvalue = 0, value = 0, name = "Boost Trail", description = "Sets your Boost Trail color. Currently ", flags = MNF_SLIDER, maxvalue = #skincolors, maxIOvalue = MAXSKINCOLORS},
			{defaultvalue = 0, value = 0, name = "Stomp", description = "Sets your Stomp color. Currently ", flags = MNF_SLIDER, maxvalue = #skincolors, maxIOvalue = MAXSKINCOLORS},
			{defaultvalue = 0, value = 0, name = "Stomp Trail", description = "Sets your Stomp Trail color. Currently ", flags = MNF_SLIDER, maxvalue = #skincolors, maxIOvalue = MAXSKINCOLORS},
			{defaultvalue = 0, value = 0, name = "Homing Trail", description = "Sets your Homing Trail color. Currently ", flags = MNF_SLIDER, maxvalue = #skincolors, maxIOvalue = MAXSKINCOLORS},
			{defaultvalue = 0, value = 0, name = "Jump Aura", description = "Sets your Jump Aura color. Currently ", flags = MNF_SLIDER, maxvalue = #skincolors, maxIOvalue = MAXSKINCOLORS},
			{defaultvalue = 0, value = 0, name = "Kick Effects", description = "Sets your Kick Effect color. Currently ", flags = MNF_SLIDER, maxvalue = #skincolors, maxIOvalue = MAXSKINCOLORS},
			{defaultvalue = 34, value = 34, name = "Reticle", description = "Sets your reticle color. Currently ", flags = MNF_SLIDER, maxvalue = #skincolors, maxIOvalue = MAXSKINCOLORS},
			{defaultvalue = 62, value = 62, name = "Perfect Ring", description = "Sets your PH Ring color. Currently ", flags = MNF_SLIDER, maxvalue = #skincolors, maxIOvalue = MAXSKINCOLORS},
			{defaultvalue = 0, value = 0, name = "SP Color", description = "Sets your Single Player Color. Currently ", flags = MNF_SLIDER, maxvalue = #skincolors, maxIOvalue = MAXSKINCOLORS},
			{defaultvalue = 33, value = 33, name = "Shoe Color", description = "Sets your Shoe Color. Currently ", flags = MNF_SLIDER, maxvalue = #skincolors, maxIOvalue = MAXSKINCOLORS},
			{defaultvalue = 3, value = 3, name = "Cloth Color", description = "Sets your Cloth Color. Currently ", flags = MNF_SLIDER, maxvalue = #skincolors, maxIOvalue = MAXSKINCOLORS},
			{defaultvalue = 157, value = 157, name = "Super Aura", description = "Sets your Super Aura Color. Currently ", flags = MNF_SLIDER, maxvalue = #skincolors, maxIOvalue = MAXSKINCOLORS},
			{value = 2, name = "Random", description = "Randomize Colors", display = true},
			{value = 3, name = "Back", description = "Go back Cosmetics", flags = MNF_CHANGEPAGE|MNF_NOSAVE, pagename = "Cosmetic Settings"}},
		[9] = { -- Presets menu
			{value = 1, name = "Unleashed", description = "Sonic Unleashed", display = true},
			{value = 1, name = "Generations", description = "Sonic Generations", display = true},
			{value = 1, name = "Colors", description = "Sonic Colors", display = true},
			{value = 1, name = "Forces", description = "Sonic Forces", display = true},
			{value = 1, name = "Rush", description = "Sonic Rush", display = true},
			{value = 1, name = "2006", description = "Sonic 2006", display = true},
			{value = 1, name = "Back", description = "Go back to Main Menu", flags = MNF_CHANGEPAGE|MNF_NOSAVE, pagename = "Main Menu"}},
		[10] = { -- Sounds menu
			{defaultvalue = 1, value = 1, name = "Jump", description = "Set the Jump sound!", maxvalue = 5, options = {"Rush", "Sonic 06", "Super Smash Bros.", "Lost World", "Forces"}, vflags = V_GRAYMAP},
			{defaultvalue = 2, value = 2, name = "Boost", description = "Set the Boost sound!", maxvalue = 5, options = {"Rush", "Sonic 06", "Unleashed", "Forces", "Frontiers"}, vflags = V_GRAYMAP},
			{defaultvalue = 2, value = 2, name = "Skidding", description = "Set the Skidding sound!", maxvalue = 4, options = {"Rush", "Sonic 06", "Unleashed", "Super Smash Bros."}, vflags = V_GRAYMAP},
			{defaultvalue = 2, value = 2, name = "Rolling", description = "Set the Rolling sound!", maxvalue = 5, options = {"Rush", "Sonic 06", "Unwiished", "Super Smash Bros.", "Generations"}, vflags = V_GRAYMAP},
			{defaultvalue = 4, value = 4, name = "Spindash", description = "Set the Spindash sound!", maxvalue = 5, options = {"Rush", "Sonic 06", "Unwiished", "Super Smash Bros.", "Generations"}, vflags = V_GRAYMAP},
			{defaultvalue = 5, value = 5, name = "Dropdash", description = "Set the Dropdash sound!", maxvalue = 7, options = {"Rush", "Sonic 06", "Unwiished", "Super Smash Bros.", "Lost World", "Frontiers", "SXS Generations"}, vflags = V_GRAYMAP},
			{defaultvalue = 3, value = 3, name = "Dash Release", description = "Set the Spindash/Dropdash Release sound!", maxvalue = 5, options = {"Rush", "Sonic 06", "Super Smash Bros.", "Lost World", "SXS Generations"}, vflags = V_GRAYMAP},
			{defaultvalue = 0, value = 0, name = "Lock-on", description = "Set the Lock-on sound!", maxvalue = 4, options = {"Unleashed", "Forces", "Frontiers"}, vflags = V_GRAYMAP},
			{defaultvalue = 2, value = 2, name = "Homing", description = "Set the Homing Attack/Air Dash sound!", maxvalue = 4, options = {"Rush", "Sonic 06", "Unleashed", "Super Smash Bros."}, vflags = V_GRAYMAP},
			{defaultvalue = 0, value = 0, name = "Tricking", description = "Set the Tricking sounds!", maxvalue = 5, options = {"Generations", "Unleashed", "Colors", "Rush", "Frontiers"}, vflags = V_GRAYMAP},
			{value = 6, name = "Back", description = "Go back to Audio", flags = MNF_CHANGEPAGE|MNF_NOSAVE, pagename = "Audio Settings"}},
		}
	for e = 1,#player.modernmenu.contents
		for i = 1,#player.modernmenu.contents[e]
			if not player.modernmenu.contents[e][i].flags then player.modernmenu.contents[e][i].flags = 0 end
			if not player.modernmenu.contents[e][i].selectedvflags then player.modernmenu.contents[e][i].selectedvflags = V_YELLOWMAP end
			if not player.modernmenu.contents[e][i].pagename then player.modernmenu.contents[e][i].pagename = "Page "..player.modernmenu.contents[e][i].value end
			if player.modernmenu.contents[e][i].func then continue end
			if not player.modernmenu.contents[e][i].maxvalue
					player.modernmenu.contents[e][i].maxvalue = 2
			elseif player.modernmenu.contents[e][i].maxvalue == 1
				CONS_Printf(player, "\133ERROR IN PAGE "..e.."\nSetting "..i.."'s maxvalue is 1! Are you sure it's intentional?")
				player.modernmenu.contents[e][i].maxvalue = 2
				CONS_Printf(player, "\133Maxvalue was set to 2.")
			elseif player.modernmenu.contents[e][i].maxvalue < 1
				CONS_Printf(player, "\133ERROR IN PAGE "..e.."\nSetting "..i.."'s maxvalue("..player.modernmenu.contents[e][i].maxvalue..") is too small! Are you sure it's intentional?")
				player.modernmenu.contents[e][i].maxvalue = 2
				CONS_Printf(player, "\133Maxvalue was set to 2.")
			end
			if not player.modernmenu.contents[e][i].options
			and not player.modernmenu.contents[e][i].display
				player.modernmenu.contents[e][i].options = {"OFF", "ON"}
			elseif player.modernmenu.contents[e][i].display
				player.modernmenu.contents[e][i].options = {" ", " "}
			elseif #player.modernmenu.contents[e][i].options < player.modernmenu.contents[e][i].maxvalue and not (player.modernmenu.contents[e][i].slider or player.modernmenu.contents[e][i].flags & MNF_SLIDER)
				CONS_Printf(player, "\133ERROR IN PAGE "..e.."\nSetting "..i.."'s options can't be fewer than maxvalue("..player.modernmenu.contents[e][i].maxvalue..")!")
				for a =1,player.modernmenu.contents[e][i].maxvalue
					if player.modernmenu.contents[e][i].options[a] then continue end
					player.modernmenu.contents[e][i].options[a] = "Missing!"
				end
			end
			if player.modernmenu.contents[e][i].flags & MNF_NOSAVE then continue end
		end
	end
	LoadModernSettings(player)
end)

--player.modernmenu.contents is the main part of the menu, every key in this table will refer to a page, if you only want a single page make a single key [1],
--you can put the elements of the menu pages inside these keys, you can have as many elements as you want, but it might be best not to have more than 10 for each page
--"value" sets their value, starting from 0, set this value to the setting's default value
--	use this for your checks in your Lua, an example is at the end of this Lua
--"name" is the name of the setting that will appear on the menu
--"description" is the small text that will appear on the bottom of the screen
--"toggledby" is an extra parameter for subsections, set it to the number of the setting which your subsection setting should be depending on
--	do note that if the setting that controls the subsecton is off, it will make the subsection not modifiable, but it will NOT set it to false automatically, remember that when making the checks in your other Luas
--"func" is an extra parameter for function setting, these settings can't be toggled on/off, selecting them will call the given function instead
--"maxvalue" is for a setting with more than 2 options, set this parameter to the amount of options your setting can be
--	do note that "value" starts from 0, so if for example you want a 3 option setting "value" will start from 0 and reach it's max at 2 (maxvalue would still have to be set to 3 though)
--	if this parameter is omitted it will be set to 2 (equivalent to an ON/OFF setting)
--"options" must be a table containing the names of all the possible setting's options, this table should be as long as maxvalue (example: if maxvalue is 3 the table should contain 3 strings)
--	if this parameter is omitted it will be set to {"OFF", "ON"}
--"slider" is a boolean parameter that when set to true it displays a slider instead of a string, thus "options" can be omitted
--	this parameter is deprecated since MNF_SLIDER now exists, but it can still be used and it will work the same way
--"flags" is the parameter for menu flags (MNF_*), you can see them and what they do near the start of the file
--"vflags" is the parameter for video flags (V_*), you could use this for example to give the text a different color when not selected,
--	this parameter accepts any video flags, but it's primarely meant for color flags (V_*MAP) and it might break with other video flags
--"selectedvflags" is a parameter that gives the specified video flags (V_*) when the setting is selected, this default to V_YELLOWMAP if omitted
--	this parameter accepts any video flags, but it's primarely meant for color flags (V_*MAP) and it might break with other video flags
--"pagename" is a parameter that sets the name of the page, this defaults to "Page " + the "value" parameter if omitted
--	this paramter will only work with MNF_CHANGEPAGE settings
--"defaultvalue" is the default value that all the settings are set to upon IO creation. this is used for a function to set options to their original value with the use of Custom1


addHook("PlayerThink", function(player)
	if player.mo and player.mo.skin ~= "modernsonic"
		if player.modernmenu.show
			player.modernmenu.show = false
			P_RestoreMusic(player)
			player.powers[pw_flashing] = 35
		end
	end
	if player.mo and player.mo.skin == "modernsonic"
		if player.modernmenuartx1 == nil
		or player.modernmenuartx2 == nil
		or player.modernmenuartx3 == nil
		or player.modernmenu.show == false
			player.modernmenuartx1 = 500
			player.modernmenuartx2 = 500
			player.modernmenuartx3 = 500
		end
	--Timer for Main Menu scrolling text
		if player.mmscrolling1 == nil
			player.mmscrolling1 = 100
			player.mmscrolling2 = -100
			player.mmscrolling3 = -300
		end
		if player.gsscrolling1 == nil
			player.gsscrolling1 = 150
			player.gsscrolling2 = -100
			player.gsscrolling3 = -350
		end
		if player.rsscrolling1 == nil
			player.rsscrolling1 = 100
			player.rsscrolling2 = -100
			player.rsscrolling3 = -300
		end
		if player.modernmenu.show
		//MainMenuTimer
			if player.mmscrolling1 == 400
				player.mmscrolling1 = -200
			else
				player.mmscrolling1 = min($+1, 400)
			end
			if player.mmscrolling2 == 400
				player.mmscrolling2 = -200
			else
				player.mmscrolling2 = min($+1, 400)
			end
			if player.mmscrolling3 == 400
				player.mmscrolling3 = -200
			else
				player.mmscrolling3 = min($+1, 400)
			end
		//Gameplay settings
			if player.gsscrolling1 == 450
				player.gsscrolling1 = -300
			else
				player.gsscrolling1 = min($+1, 450)
			end
			if player.gsscrolling2 == 450
				player.gsscrolling2 = -300
			else
				player.gsscrolling2 = min($+1, 450)
			end
			if player.gsscrolling3 == 450
				player.gsscrolling3 = -300
			else
				player.gsscrolling3 = min($+1, 450)
			end
		//Rush settings
			if player.rsscrolling1 == 300
				player.rsscrolling1 = -300
			else
				player.rsscrolling1 = min($+1, 300)
			end
			if player.rsscrolling2 == 300
				player.rsscrolling2 = -300
			else
				player.rsscrolling2 = min($+1, 300)
			end
			if player.rsscrolling3 == 300
				player.rsscrolling3 = -300
			else
				player.rsscrolling3 = min($+1, 300)
			end
			--player.powers[pw_nocontrol] = 1
			player.pflags = $1|PF_JUMPSTASIS
			player.powers[pw_flashing] = 1
			player.mo.momx = 0
			player.mo.momy = 0
			player.mo.momz = 0
			--S_ChangeMusic("MMENU", true, player)
			if player.modernmenu.pagepointer == 2
				if player.modernmenuartx2 == 500
				and player.modernmenuartx3 == 500
					player.modernmenuartx1 = max($-20, 220)
				end
			else
				player.modernmenuartx1 = min($+20, 500)
			end
			if player.modernmenu.pagepointer == 3
			or player.modernmenu.pagepointer == 5
			or player.modernmenu.pagepointer == 6
			or player.modernmenu.pagepointer == 7
			or player.modernmenu.pagepointer == 8
				if player.modernmenuartx1 == 500
				and player.modernmenuartx3 == 500
					player.modernmenuartx2 = max($-20, 220)
				end
			else
				player.modernmenuartx2 = min($+20, 500)
			end
			if player.modernmenu.pagepointer == 4
				if player.modernmenuartx1 == 500
				and player.modernmenuartx2 == 500
					player.modernmenuartx3 = max($-20, 220)
				end
			else
				player.modernmenuartx3 = min($+20, 500)
			end
		end
		if not player.modernmenutpos 
			player.modernmenutpos = 16
		else
			player.modernmenutpos = $-1
		end
		player.modernmenu.contents[4][4].maxvalue = #skincolors
		if player.modernmenu.contents[4][4].value > player.modernmenu.contents[4][4].maxvalue
			player.modernmenu.contents[4][4].value = 32
		end
		if player.modernmenu.contents[4][1].value == 0
			player.modernmenu.contents[4][2].value = 0
			player.modernmenu.contents[4][3].value = 0
		end
		for i = 1, 13
			player.modernmenu.contents[8][i].maxvalue = #skincolors
			if player.modernmenu.contents[8][i].value > player.modernmenu.contents[8][i].maxvalue
				player.modernmenu.contents[8][i].value = player.modernmenu.contents[8][i].defaultvalue
			end
		end
		local menu = player.modernmenu
		local contents = menu.contents[player.modernmenu.pagepointer]
		menu.timer = max($-1, 0)
		if player.cmd.sidemove < 10 and player.cmd.sidemove > -10
		and player.cmd.forwardmove < 10 and player.cmd.forwardmove > -10
		and not (player.cmd.buttons & BT_SPIN)
		and not (player.cmd.buttons & BT_JUMP)
		and not (player.cmd.buttons & BT_CUSTOM1)
			player.modernmenu.timerhold = 0
			player.modernmenu.timer = 0
		end
		if menu.show == false or menu.timer then return end
		if player.cmd.forwardmove > 10
			if menu.pointer == 1
				menu.pointer = #contents
			else
				menu.pointer = $-1
			end
			menu.timerhold = min($+1, 35)
			if menu.timerhold < 2
				menu.timer = 10
			elseif menu.timerhold < 8
				menu.timer = 5
			else
				menu.timer = 1
			end
			S_StartSound(player.mo, sfx_mmenu1, player)
		elseif player.cmd.forwardmove < -10
			if menu.pointer == #contents
				menu.pointer = 1
			else
				menu.pointer = $+1
			end
			menu.timerhold = min($+1, 35)
			if menu.timerhold < 2
				menu.timer = 10
			elseif menu.timerhold < 8
				menu.timer = 5
			else
				menu.timer = 1
			end
			S_StartSound(player.mo, sfx_mmenu1, player)
		end
		--set default value
		if player.cmd.buttons & BT_CUSTOM1
		--and player.modernmenu.timer == 0
			SetDefaultOption(player)
		end
		
		if player.cmd.buttons & BT_JUMP
		and not player.jumpdown2
			--randomize color
			if contents[menu.pointer].toggledby and contents[contents[menu.pointer].toggledby].value == 0 then return end
			if menu.pagepointer == 8
			and menu.pointer == 14
				menu.timer = 5
				S_StartSound(player.mo, sfx_mmenu1, player)
				RandomizeColors(player)
				return 
			end
			if menu.pagepointer == 9
			and menu.pointer < 7
				menu.timer = 5
				S_StartSound(player.mo, sfx_mmenu2, player) 
				SetModernPreset(player, player.modernmenu.contents[menu.pagepointer][menu.pointer].name)
				return
			end
			if contents[menu.pointer].func
				contents[menu.pointer].func()
			elseif contents[menu.pointer].flags & MNF_CHANGEPAGE
				menu.pagename = contents[menu.pointer].pagename
				menu.pagepointer = contents[menu.pointer].value
				menu.pointer = 1
				S_StartSound(player.mo, sfx_mmenu2, player)
			else
				S_StartSound(player.mo, sfx_mmenu1, player)
				contents[menu.pointer].value = ($+1)%contents[menu.pointer].maxvalue
			end
			menu.timer = 5
			
		end
		player.jumpdown2 = player.cmd.buttons & BT_JUMP
		if player.cmd.buttons & BT_SPIN
			if menu.pagepointer == 8 -- colors
				menu.timer = 5
				menu.pointer = 5
				S_StartSound(player.mo, sfx_mmenu3, player)
				menu.pagepointer = 3
				menu.pagename = "Cosmetics"
			elseif menu.pagepointer == 5 -- blending
				menu.timer = 5
				menu.pointer = 4
				S_StartSound(player.mo, sfx_mmenu3, player)
				menu.pagepointer = 3
				menu.pagename = "Cosmetics"
			elseif menu.pagepointer == 6 -- Audio
				menu.timer = 5
				menu.pointer = 6
				S_StartSound(player.mo, sfx_mmenu3, player)
				menu.pagepointer = 3
				menu.pagename = "Cosmetics"
			elseif menu.pagepointer == 7 -- effects
				menu.timer = 5
				menu.pointer = 3
				S_StartSound(player.mo, sfx_mmenu3, player)
				menu.pagepointer = 3
				menu.pagename = "Cosmetics"
			elseif menu.pagepointer == 9 -- Presets
				menu.timer = 5
				menu.pointer = 3
				S_StartSound(player.mo, sfx_mmenu3, player)
				menu.pagepointer = 1
				menu.pointer = 4
				menu.pagename = "Main Menu"
			elseif menu.pagepointer == 10 -- Sounds
				menu.timer = 5
				menu.pointer = 6
				S_StartSound(player.mo, sfx_mmenu3, player)
				menu.pagepointer = 6
				menu.pagename = "Audio"
			elseif menu.pagepointer ~= 1
				menu.timer = 5
				S_StartSound(player.mo, sfx_mmenu3, player)
				if menu.pagepointer ~= 1
					menu.pointer = menu.pagepointer-1
					menu.pagepointer = 1
					menu.pagename = "Main Menu"
				end
			else
				menu.timer = 5
				menu.pointer = 1
				S_StartSound(player.mo, sfx_mmenu3, player)
				menu.show = false
				player.boostheld = true
				player.airboostheld = true
				player.powers[pw_flashing] = 35
				P_RestoreMusic(player)
				if player == consoleplayer
					COM_BufInsertText(player, "savemodernsettings")
				end
			end
		end
		if (player.cmd.sidemove > 10 or player.cmd.sidemove < -10)
		and not (contents[menu.pointer].flags & MNF_CHANGEPAGE)
			if player.cmd.sidemove > 10
				contents[menu.pointer].value = ($+1)%contents[menu.pointer].maxvalue
			end
			if player.cmd.sidemove < -10
				if (contents[menu.pointer].value == 0)
					contents[menu.pointer].value = contents[menu.pointer].maxvalue-1
				else
					contents[menu.pointer].value = ($-1)%contents[menu.pointer].maxvalue
				end
			end
			if menu.timerhold < 2
				menu.timer = 10
			elseif menu.timerhold < 8
				menu.timer = 5
			else
				menu.timer = 1
			end
			menu.timerhold = min($+1, 35)
			S_StartSound(player.mo, sfx_mmenu1, player)
		end
	end
end)

COM_AddCommand("loadmodernsettings", function(player, ...) --you can change the command's name to anything you want
	if not (player.mo and player.mo.valid)
		CONS_Printf(player, "You must be in a level to use this.")
		return
	end
	
	// Lach: validate args
	local args = {...}
	
	if not MSLoadLib.ValidateArgs(args)
		return
	end
	
	MSLoadLib.InitRead(args)
	
	for e = 1,#player.modernmenu.contents
		for i = 1,#player.modernmenu.contents[e]
			if not player.modernmenu.contents[e][i].flags then player.modernmenu.contents[e][i].flags = 0 end
			if not player.modernmenu.contents[e][i].selectedvflags then player.modernmenu.contents[e][i].selectedvflags = V_AQUAMAP end
			if not player.modernmenu.contents[e][i].pagename then player.modernmenu.contents[e][i].pagename = "Page "..player.modernmenu.contents[e][i].value end
			if player.modernmenu.contents[e][i].func then continue end
			if not player.modernmenu.contents[e][i].maxvalue
					player.modernmenu.contents[e][i].maxvalue = 2
			elseif player.modernmenu.contents[e][i].maxvalue == 1
				CONS_Printf(player, "\133ERROR IN PAGE "..e.."\nSetting "..i.."'s maxvalue is 1! Are you sure it's intentional?")
				player.modernmenu.contents[e][i].maxvalue = 2
				CONS_Printf(player, "\133Maxvalue was set to 2.")
			elseif player.modernmenu.contents[e][i].maxvalue < 1
				CONS_Printf(player, "\133ERROR IN PAGE "..e.."\nSetting "..i.."'s maxvalue("..player.modernmenu.contents[e][i].maxvalue..") is too small! Are you sure it's intentional?")
				player.modernmenu.contents[e][i].maxvalue = 2
				CONS_Printf(player, "\133Maxvalue was set to 2.")
			end
			if not player.modernmenu.contents[e][i].options
				player.modernmenu.contents[e][i].options = {"OFF", "ON"}
			elseif #player.modernmenu.contents[e][i].options < player.modernmenu.contents[e][i].maxvalue and not (player.modernmenu.contents[e][i].slider or player.modernmenu.contents[e][i].flags & MNF_SLIDER)
				CONS_Printf(player, "\133ERROR IN PAGE "..e.."\nSetting "..i.."'s options can't be fewer than maxvalue("..player.modernmenu.contents[e][i].maxvalue..")!")
				for a =1,player.modernmenu.contents[e][i].maxvalue
					if player.modernmenu.contents[e][i].options[a] then continue end
					player.modernmenu.contents[e][i].options[a] = "Missing!"
				end
			end
			if player.modernmenu.contents[e][i].flags & MNF_NOSAVE then continue end
			
			if not MSLoadLib.ReadMenuOption(player.modernmenu.contents[e][i])
				return
			end
		end
	end	
end)

COM_AddCommand("savemodernsettings", function(player) --you can change the command's name to anything you want
	if not (player.mo and player.mo.valid)
		CONS_Printf(player, "You must be in a level to use this.")
		return
	end
	local file = io.openlocal("client/ModernSettings.dat", "w") --if you changed "Name" in the other lines, change it here too!
	file:write(MSLoadLib.GetMenuHash(player.modernmenu.contents) .. "\n") // Lach: write the "version" to the file
	for e = 1,#player.modernmenu.contents
		for i = 1,#player.modernmenu.contents[e]
			if player.modernmenu.contents[e][i].func or player.modernmenu.contents[e][i].flags & MNF_NOSAVE then continue end
			file:write(player.modernmenu.contents[e][i].value.."\n")
		end
	end
	file:close()
end, COM_LOCAL)

addHook("ShouldJingleContinue", function(player, musname)
    if musname != "MMENU" return end
    if player.mo.skin == "modernsonic" and player.modernmenu.show
		return true
    else
        return false
    end
end)

local mapColors = { --this changes the menu's color based on the player's, I guess you can change it if you want
	[0] = 0,
	[V_MAGENTAMAP] = 182,
	[V_YELLOWMAP] = 74,
	[V_GREENMAP] = 115,
	[V_BLUEMAP] = 159,
	[V_REDMAP] = 41,
	[V_GRAYMAP] = 20,
	[V_ORANGEMAP] = 58,
	[V_SKYMAP] = 141,
	[V_PURPLEMAP] = 187,
	[V_AQUAMAP] = 173,
	[V_PERIDOTMAP] = 94,
	[V_AZUREMAP] = 170,
	[V_BROWNMAP] = 249,
	[V_ROSYMAP] = 203,
	[V_INVERTMAP] = 31
} 

hud.add(function(v,player) --this draws the menu on the screen, you can change the values to what you prefer if you know what you are doing
	if not (player.modernmenu and player.modernmenu.show) then return end
	v.drawFill()
	v.drawScaled(0, 0, FRACUNIT, v.cachePatch("MMENUT2"), V_SNAPTOLEFT|V_SNAPTOTOP, v.getColormap(nil, SKINCOLOR_LAPIS))
	v.drawScaled(30*FRACUNIT, (player.modernmenutpos*FRACUNIT)-16*FRACUNIT, FRACUNIT, v.cachePatch("MMENUT1"), V_SNAPTOLEFT|V_SNAPTOTOP, v.getColormap(nil, SKINCOLOR_LAPIS)) 
	v.drawScaled(60*FRACUNIT, 10*FRACUNIT, FRACUNIT/4, v.cachePatch("MMENU"), V_PERPLAYER, v.getColormap(nil, SKINCOLOR_MODMEN)) --Background
	v.drawScaled(player.modernmenuartx1*FRACUNIT, 5*FRACUNIT, FRACUNIT/6, v.cachePatch("MBGART1"), V_PERPLAYER|V_TRANSLUCENT)
	v.drawScaled(player.modernmenuartx2*FRACUNIT, 5*FRACUNIT, FRACUNIT/6, v.cachePatch("MBGART2"), V_PERPLAYER|V_TRANSLUCENT)
	v.drawScaled(player.modernmenuartx3*FRACUNIT+15*FRACUNIT, 5*FRACUNIT, FRACUNIT/6, v.cachePatch("MBGART3"), V_PERPLAYER|V_TRANSLUCENT)
	--v.drawString(160, 30, "Modern Sonic Menu", V_BLUEMAP, "center") --you should probably change this to something that fits for your menu though
	if player.modernmenu.pagepointer == 1
		v.drawScaled(7*FRACUNIT, player.mmscrolling1*FRACUNIT, FRACUNIT, v.cachePatch("MMENUT3"), V_SNAPTOLEFT, v.getColormap(nil, SKINCOLOR_BLUE))
		v.drawScaled(7*FRACUNIT, player.mmscrolling2*FRACUNIT, FRACUNIT, v.cachePatch("MMENUT3"), V_SNAPTOLEFT, v.getColormap(nil, SKINCOLOR_BLUE))
		v.drawScaled(7*FRACUNIT, player.mmscrolling3*FRACUNIT, FRACUNIT, v.cachePatch("MMENUT3"), V_SNAPTOLEFT, v.getColormap(nil, SKINCOLOR_BLUE))
	elseif player.modernmenu.pagepointer == 2
		v.drawScaled(7*FRACUNIT, player.gsscrolling1*FRACUNIT, FRACUNIT, v.cachePatch("MMENUT4"), V_SNAPTOLEFT, v.getColormap(nil, SKINCOLOR_BLUE))
		v.drawScaled(7*FRACUNIT, player.gsscrolling2*FRACUNIT, FRACUNIT, v.cachePatch("MMENUT4"), V_SNAPTOLEFT, v.getColormap(nil, SKINCOLOR_BLUE))
		v.drawScaled(7*FRACUNIT, player.gsscrolling3*FRACUNIT, FRACUNIT, v.cachePatch("MMENUT4"), V_SNAPTOLEFT, v.getColormap(nil, SKINCOLOR_BLUE))
	elseif player.modernmenu.pagepointer == 3
	or player.modernmenu.pagepointer == 5
	or player.modernmenu.pagepointer == 6
	or player.modernmenu.pagepointer == 7
	or player.modernmenu.pagepointer == 8
	or player.modernmenu.pagepointer == 10
		v.drawScaled(7*FRACUNIT, player.gsscrolling1*FRACUNIT, FRACUNIT, v.cachePatch("MMENUT5"), V_SNAPTOLEFT, v.getColormap(nil, SKINCOLOR_BLUE))
		v.drawScaled(7*FRACUNIT, player.gsscrolling2*FRACUNIT, FRACUNIT, v.cachePatch("MMENUT5"), V_SNAPTOLEFT, v.getColormap(nil, SKINCOLOR_BLUE))
		v.drawScaled(7*FRACUNIT, player.gsscrolling3*FRACUNIT, FRACUNIT, v.cachePatch("MMENUT5"), V_SNAPTOLEFT, v.getColormap(nil, SKINCOLOR_BLUE))
	elseif player.modernmenu.pagepointer == 4
		v.drawScaled(7*FRACUNIT, player.rsscrolling1*FRACUNIT, FRACUNIT, v.cachePatch("MMENUT6"), V_SNAPTOLEFT, v.getColormap(nil, SKINCOLOR_BLUE))
		v.drawScaled(7*FRACUNIT, player.rsscrolling2*FRACUNIT, FRACUNIT, v.cachePatch("MMENUT6"), V_SNAPTOLEFT, v.getColormap(nil, SKINCOLOR_BLUE))
		v.drawScaled(7*FRACUNIT, player.rsscrolling3*FRACUNIT, FRACUNIT, v.cachePatch("MMENUT6"), V_SNAPTOLEFT, v.getColormap(nil, SKINCOLOR_BLUE))
	end
	if player.modernmenu.pagepointer == 4
		v.draw(84, 120, v.cachePatch("MCONT"), V_PERPLAYER, v.getColormap("SKINCOLOR_WHITE", player.rushcolor))
	end
	local pagename = player.modernmenu.pagename
	if #player.modernmenu.contents == 1 then pagename = "" end
	--v.drawString(257, 45+(10*#player.modernmenu.contents[player.modernmenu.pagepointer]), pagename, V_BLUEMAP, "small-right")
	for i = 1,#player.modernmenu.contents[player.modernmenu.pagepointer]
		local thecolor = V_BLUEMAP or 0 
		local thex = 0
		if player.modernmenu.pointer == i then thecolor = player.modernmenu.contents[player.modernmenu.pagepointer][i].selectedvflags end
		if player.modernmenu.contents[player.modernmenu.pagepointer][i].toggledby
			thex = 10
			if player.modernmenu.contents[player.modernmenu.pagepointer][player.modernmenu.contents[player.modernmenu.pagepointer][i].toggledby].value == 0
				thecolor = $|V_TRANSLUCENT
			end
		end
		local thename = "Missing name!"
		if player.modernmenu.contents[player.modernmenu.pagepointer][i].name and player.modernmenu.contents[player.modernmenu.pagepointer][i].name ~= ""
			thename = player.modernmenu.contents[player.modernmenu.pagepointer][i].name	
		end
		--if player.modernmenu.pagepointer == 1
			--v.drawString(125+thex, 15+(10*i), thename, thecolor|V_ALLOWLOWERCASE)
		--else
			v.drawString(65+thex, 15+(10*i), thename, thecolor|V_ALLOWLOWERCASE)
		--end
		if not (player.modernmenu.contents[player.modernmenu.pagepointer][i].slider or player.modernmenu.contents[player.modernmenu.pagepointer][i].flags & MNF_SLIDER)
			local thevalue = (player.modernmenu.contents[player.modernmenu.pagepointer][i].func or player.modernmenu.contents[player.modernmenu.pagepointer][i].display) and "" or player.modernmenu.contents[player.modernmenu.pagepointer][i].options[player.modernmenu.contents[player.modernmenu.pagepointer][i].value+1]
			if player.modernmenu.contents[player.modernmenu.pagepointer][i].flags & MNF_CHANGEPAGE then thevalue = "" end
			if player.modernmenu.contents[player.modernmenu.pagepointer][10] and player.modernmenu.pagepointer == 8 then thevalue = "" end
			if player.modernmenu.contents[player.modernmenu.pagepointer][i].flags & MNF_SHOWVALUE then thevalue = player.modernmenu.contents[player.modernmenu.pagepointer][i].options[player.modernmenu.contents[player.modernmenu.pagepointer][i].value+1] end
			v.drawString(255, 15+(10*i), thevalue, thecolor, "right")
		elseif not player.modernmenu.contents[player.modernmenu.pagepointer][i].func
			if player.modernmenu.pagepointer == 4
				local patchs = v.cachePatch("M_SLIDEL")
				local patchm = v.cachePatch("M_SLIDEM")
				local patche = v.cachePatch("M_SLIDER")
				local patchc = v.cachePatch("M_SLIDEC")
				if player.modernmenu.contents[4][4].value ~= 0
					v.draw(213, 15+(10*i), patchs, nil, v.getColormap(TC_RAINBOW, player.modernmenu.contents[4][4].value))
					for e = 1,8
						v.draw(215+(4*e), 15+(10*i), patchm, nil, v.getColormap(TC_RAINBOW, player.modernmenu.contents[4][4].value))
					end
					v.draw(249, 15+(10*i), patche, nil, v.getColormap(TC_RAINBOW, player.modernmenu.contents[4][4].value))
				else
					v.draw(213, 15+(10*i), patchs, nil, v.getColormap(TC_RAINBOW, player.rushcolor))
					for e = 1,8
						v.draw(215+(4*e), 15+(10*i), patchm, nil, v.getColormap(TC_RAINBOW, player.rushcolor))
					end
					v.draw(249, 15+(10*i), patche, nil, v.getColormap(TC_RAINBOW, player.rushcolor))
				end
				local value = player.modernmenu.contents[player.modernmenu.pagepointer][i].value
				local maxvalue = player.modernmenu.contents[player.modernmenu.pagepointer][i].maxvalue-1
				
				v.drawScaled(FRACUNIT*215 + 36*FixedDiv(value, maxvalue), FRACUNIT*15 + (10*i)*FRACUNIT, FRACUNIT, patchc)
			elseif player.modernmenu.pagepointer == 8
				local patchs = v.cachePatch("M_SLIDEL")
				local patchm = v.cachePatch("M_SLIDEM")
				local patche = v.cachePatch("M_SLIDER")
				local patchc = v.cachePatch("M_SLIDEC")
				//SLIDERS 
				if i == 1
					v.draw(213, 15+(10*i), patchs, nil, v.getColormap(TC_RAINBOW,  player.boostauracolor))
					for e = 1,8
						v.draw(215+(4*e), 15+(10*i), patchm, nil, v.getColormap(TC_RAINBOW,  player.boostauracolor))
					end
					v.draw(249, 15+(10*i), patche, nil, v.getColormap(TC_RAINBOW, player.boostauracolor))
					local value = player.modernmenu.contents[player.modernmenu.pagepointer][i].value
					local maxvalue = player.modernmenu.contents[player.modernmenu.pagepointer][i].maxvalue-1
					
					v.drawScaled(FRACUNIT*215 + 36*FixedDiv(value, maxvalue), FRACUNIT*15 + (10*i)*FRACUNIT, FRACUNIT, patchc)
				elseif i == 2
					v.draw(213, 15+(10*i), patchs, nil, v.getColormap(TC_RAINBOW,  player.boosttrailcolor))
					for e = 1,8
						v.draw(215+(4*e), 15+(10*i), patchm, nil, v.getColormap(TC_RAINBOW,  player.boosttrailcolor))
					end
					v.draw(249, 15+(10*i), patche, nil, v.getColormap(TC_RAINBOW, player.boosttrailcolor))
					local value = player.modernmenu.contents[player.modernmenu.pagepointer][i].value
					local maxvalue = player.modernmenu.contents[player.modernmenu.pagepointer][i].maxvalue-1
					
					v.drawScaled(FRACUNIT*215 + 36*FixedDiv(value, maxvalue), FRACUNIT*15 + (10*i)*FRACUNIT, FRACUNIT, patchc)	
				elseif i == 3
					v.draw(213, 15+(10*i), patchs, nil, v.getColormap(TC_RAINBOW,  player.stompcolor))
					for e = 1,8
						v.draw(215+(4*e), 15+(10*i), patchm, nil, v.getColormap(TC_RAINBOW,  player.stompcolor))
					end
					v.draw(249, 15+(10*i), patche, nil, v.getColormap(TC_RAINBOW, player.stompcolor))
					local value = player.modernmenu.contents[player.modernmenu.pagepointer][i].value
					local maxvalue = player.modernmenu.contents[player.modernmenu.pagepointer][i].maxvalue-1
					
					v.drawScaled(FRACUNIT*215 + 36*FixedDiv(value, maxvalue), FRACUNIT*15 + (10*i)*FRACUNIT, FRACUNIT, patchc)	
				elseif i == 4
					v.draw(213, 15+(10*i), patchs, nil, v.getColormap(TC_RAINBOW,  player.stomptrailcolor))
					for e = 1,8
						v.draw(215+(4*e), 15+(10*i), patchm, nil, v.getColormap(TC_RAINBOW,  player.stomptrailcolor))
					end
					v.draw(249, 15+(10*i), patche, nil, v.getColormap(TC_RAINBOW, player.stomptrailcolor))
					local value = player.modernmenu.contents[player.modernmenu.pagepointer][i].value
					local maxvalue = player.modernmenu.contents[player.modernmenu.pagepointer][i].maxvalue-1
					
					v.drawScaled(FRACUNIT*215 + 36*FixedDiv(value, maxvalue), FRACUNIT*15 + (10*i)*FRACUNIT, FRACUNIT, patchc)	
				elseif i == 5
					v.draw(213, 15+(10*i), patchs, nil, v.getColormap(TC_RAINBOW,  player.homingtrailcolor))
					for e = 1,8
						v.draw(215+(4*e), 15+(10*i), patchm, nil, v.getColormap(TC_RAINBOW,   player.homingtrailcolor))
					end
					v.draw(249, 15+(10*i), patche, nil, v.getColormap(TC_RAINBOW,  player.homingtrailcolor))
					local value = player.modernmenu.contents[player.modernmenu.pagepointer][i].value
					local maxvalue = player.modernmenu.contents[player.modernmenu.pagepointer][i].maxvalue-1
					
					v.drawScaled(FRACUNIT*215 + 36*FixedDiv(value, maxvalue), FRACUNIT*15 + (10*i)*FRACUNIT, FRACUNIT, patchc)	
				elseif i == 6
					v.draw(213, 15+(10*i), patchs, nil, v.getColormap(TC_RAINBOW,  player.jumpauracolor))
					for e = 1,8
						v.draw(215+(4*e), 15+(10*i), patchm, nil, v.getColormap(TC_RAINBOW,  player.jumpauracolor))
					end
					v.draw(249, 15+(10*i), patche, nil, v.getColormap(TC_RAINBOW, player.jumpauracolor))
					local value = player.modernmenu.contents[player.modernmenu.pagepointer][i].value
					local maxvalue = player.modernmenu.contents[player.modernmenu.pagepointer][i].maxvalue-1
					
					v.drawScaled(FRACUNIT*215 + 36*FixedDiv(value, maxvalue), FRACUNIT*15 + (10*i)*FRACUNIT, FRACUNIT, patchc)
				elseif i == 7
					v.draw(213, 15+(10*i), patchs, nil, v.getColormap(TC_RAINBOW,  player.slidesparkscolor))
					for e = 1,8
						v.draw(215+(4*e), 15+(10*i), patchm, nil, v.getColormap(TC_RAINBOW,  player.slidesparkscolor))
					end
					v.draw(249, 15+(10*i), patche, nil, v.getColormap(TC_RAINBOW, player.slidesparkscolor))
					local value = player.modernmenu.contents[player.modernmenu.pagepointer][i].value
					local maxvalue = player.modernmenu.contents[player.modernmenu.pagepointer][i].maxvalue-1
					
					v.drawScaled(FRACUNIT*215 + 36*FixedDiv(value, maxvalue), FRACUNIT*15 + (10*i)*FRACUNIT, FRACUNIT, patchc)	
				elseif i == 8
					v.draw(213, 15+(10*i), patchs, nil, v.getColormap(TC_RAINBOW,  player.reticlecolor))
					for e = 1,8
						v.draw(215+(4*e), 15+(10*i), patchm, nil, v.getColormap(TC_RAINBOW,  player.reticlecolor))
					end
					v.draw(249, 15+(10*i), patche, nil, v.getColormap(TC_RAINBOW, player.reticlecolor))
					local value = player.modernmenu.contents[player.modernmenu.pagepointer][i].value
					local maxvalue = player.modernmenu.contents[player.modernmenu.pagepointer][i].maxvalue-1
					
					v.drawScaled(FRACUNIT*215 + 36*FixedDiv(value, maxvalue), FRACUNIT*15 + (10*i)*FRACUNIT, FRACUNIT, patchc)
				elseif i == 9
					v.draw(213, 15+(10*i), patchs, nil, v.getColormap(TC_RAINBOW, player.perfectringcolor))
					for e = 1,8
						v.draw(215+(4*e), 15+(10*i), patchm, nil, v.getColormap(TC_RAINBOW, player.perfectringcolor))
					end
					v.draw(249, 15+(10*i), patche, nil, v.getColormap(TC_RAINBOW, player.perfectringcolor))
					local value = player.modernmenu.contents[player.modernmenu.pagepointer][i].value
					local maxvalue = player.modernmenu.contents[player.modernmenu.pagepointer][i].maxvalue-1
					
					v.drawScaled(FRACUNIT*215 + 36*FixedDiv(value, maxvalue), FRACUNIT*15 + (10*i)*FRACUNIT, FRACUNIT, patchc)
				elseif i == 10
					v.draw(213, 15+(10*i), patchs, nil, v.getColormap(TC_RAINBOW, player.spcolor))
					for e = 1,8
						v.draw(215+(4*e), 15+(10*i), patchm, nil, v.getColormap(TC_RAINBOW, player.spcolor))
					end
					v.draw(249, 15+(10*i), patche, nil, v.getColormap(TC_RAINBOW, player.spcolor))
					local value = player.modernmenu.contents[player.modernmenu.pagepointer][i].value
					local maxvalue = player.modernmenu.contents[player.modernmenu.pagepointer][i].maxvalue-1
					
					v.drawScaled(FRACUNIT*215 + 36*FixedDiv(value, maxvalue), FRACUNIT*15 + (10*i)*FRACUNIT, FRACUNIT, patchc)
				elseif i == 11
					v.draw(213, 15+(10*i), patchs, nil, v.getColormap(TC_RAINBOW, player.modernshoecolor))
					for e = 1,8
						v.draw(215+(4*e), 15+(10*i), patchm, nil, v.getColormap(TC_RAINBOW, player.modernshoecolor))
					end
					v.draw(249, 15+(10*i), patche, nil, v.getColormap(TC_RAINBOW, player.modernshoecolor))
					local value = player.modernmenu.contents[player.modernmenu.pagepointer][i].value
					local maxvalue = player.modernmenu.contents[player.modernmenu.pagepointer][i].maxvalue-1
					
					v.drawScaled(FRACUNIT*215 + 36*FixedDiv(value, maxvalue), FRACUNIT*15 + (10*i)*FRACUNIT, FRACUNIT, patchc)
				elseif i == 12
					v.draw(213, 15+(10*i), patchs, nil, v.getColormap(TC_RAINBOW, player.modernclothcolor))
					for e = 1,8
						v.draw(215+(4*e), 15+(10*i), patchm, nil, v.getColormap(TC_RAINBOW, player.modernclothcolor))
					end
					v.draw(249, 15+(10*i), patche, nil, v.getColormap(TC_RAINBOW, player.modernclothcolor))
					local value = player.modernmenu.contents[player.modernmenu.pagepointer][i].value
					local maxvalue = player.modernmenu.contents[player.modernmenu.pagepointer][i].maxvalue-1
					
					v.drawScaled(FRACUNIT*215 + 36*FixedDiv(value, maxvalue), FRACUNIT*15 + (10*i)*FRACUNIT, FRACUNIT, patchc)
				elseif i == 13
					v.draw(213, 15+(10*i), patchs, nil, v.getColormap(TC_RAINBOW, player.superauracolor))
					for e = 1,8
						v.draw(215+(4*e), 15+(10*i), patchm, nil, v.getColormap(TC_RAINBOW, player.superauracolor))
					end
					v.draw(249, 15+(10*i), patche, nil, v.getColormap(TC_RAINBOW, player.superauracolor))
					local value = player.modernmenu.contents[player.modernmenu.pagepointer][i].value
					local maxvalue = player.modernmenu.contents[player.modernmenu.pagepointer][i].maxvalue-1
					
					v.drawScaled(FRACUNIT*215 + 36*FixedDiv(value, maxvalue), FRACUNIT*15 + (10*i)*FRACUNIT, FRACUNIT, patchc)
				end
			end
		end
	end
	local patch = v.cachePatch("M_CURSOR")
	--if player.modernmenu.pagepointer == 1
		--v.draw(105, 15+(10*player.modernmenu.pointer), patch)
	--else
		v.draw(45, 15+(10*player.modernmenu.pointer), patch)
	--end
	local desctext = "No description found!"
	if player.modernmenu.contents[player.modernmenu.pagepointer][player.modernmenu.pointer].description and player.modernmenu.contents[player.modernmenu.pagepointer][player.modernmenu.pointer].description ~= ""
		desctext = player.modernmenu.contents[player.modernmenu.pagepointer][player.modernmenu.pointer].description
	end
	if player.modernmenu.pagepointer == 4
	and player.modernmenu.pointer == 4
		if player.modernmenu.contents[4][4].value == 0
			v.drawString(60, 180, desctext + "your Opposite Color.", V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
		else
			if R_GetNameByColor(player.rushcolor) == ""
				v.drawString(60, 180, desctext + "not defined.", V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
			else
				v.drawString(60, 180, desctext + R_GetNameByColor(player.rushcolor)+".", V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
			end
		end
	//PAGE 6 TEXT
	elseif player.modernmenu.pagepointer == 8
		//BOOST AURA
		if player.modernmenu.pointer == 1
			if player.modernmenu.contents[8][1].value == 0
				v.drawString(60, 180, desctext + "your Color.", V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
			else
				if R_GetNameByColor(player.modernmenu.contents[8][1].value) == ""
					v.drawString(60, 180, desctext + "not defined.", V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
				else
					v.drawString(60, 180, desctext + R_GetNameByColor(player.modernmenu.contents[8][1].value)+".", V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
				end
			end
		end
		//BOOST TRAIL
		if player.modernmenu.pointer == 2
			if player.modernmenu.contents[8][2].value == 0
				v.drawString(60, 180, desctext + "your Color.", V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
			else
				if R_GetNameByColor(player.modernmenu.contents[8][2].value) == ""
					v.drawString(60, 180, desctext + "not defined.", V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
				else
					v.drawString(60, 180, desctext + R_GetNameByColor(player.modernmenu.contents[8][2].value)+".", V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
				end
			end
		end
		//STOMP 
		if player.modernmenu.pointer == 3
			if player.modernmenu.contents[8][3].value == 0
				v.drawString(60, 180, desctext + "your Color.", V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
			else
				if R_GetNameByColor(player.modernmenu.contents[8][3].value) == ""
					v.drawString(60, 180, desctext + "not defined.", V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
				else
					v.drawString(60, 180, desctext + R_GetNameByColor(player.modernmenu.contents[8][3].value)+".", V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
				end
			end
		end
		//STOMP TRAIL
		if player.modernmenu.pointer == 4
			if player.modernmenu.contents[8][4].value == 0
				v.drawString(60, 180, desctext + "your Color.", V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
			else
				if R_GetNameByColor(player.modernmenu.contents[8][4].value) == ""
					v.drawString(60, 180, desctext + "not defined.", V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
				else
					v.drawString(60, 180, desctext + R_GetNameByColor(player.modernmenu.contents[8][4].value)+".", V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
				end
			end
		end
		//HOMING TRAIL
		if player.modernmenu.pointer == 5
			if player.modernmenu.contents[8][5].value == 0
				v.drawString(60, 180, desctext + "your Color.", V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
			else
				if R_GetNameByColor(player.modernmenu.contents[8][5].value) == ""
					v.drawString(60, 180, desctext + "not defined.", V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
				else
					v.drawString(60, 180, desctext + R_GetNameByColor(player.modernmenu.contents[8][5].value)+".", V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
				end
			end
		end
		//JUMP AURA
		if player.modernmenu.pointer == 6
			if player.modernmenu.contents[8][6].value == 0
				v.drawString(60, 180, desctext + "your Color.", V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
			else
				if R_GetNameByColor(player.modernmenu.contents[8][6].value) == ""
					v.drawString(60, 180, desctext + "not defined.", V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
				else
					v.drawString(60, 180, desctext + R_GetNameByColor(player.modernmenu.contents[8][6].value)+".", V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
				end
			end
		end
		//SLIDE SPARKS
		if player.modernmenu.pointer == 7
			if player.modernmenu.contents[8][7].value == 0
				v.drawString(60, 180, desctext + "your Color.", V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
			else
				if R_GetNameByColor(player.modernmenu.contents[8][7].value) == ""
					v.drawString(60, 180, desctext + "not defined.", V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
				else
					v.drawString(60, 180, desctext + R_GetNameByColor(player.modernmenu.contents[8][7].value)+".", V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
				end
			end
		end
		//RETICLE
		if player.modernmenu.pointer == 8
			if player.modernmenu.contents[8][8].value == 0
				v.drawString(60, 180, desctext + "your Opposite Color.", V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
			else
				if R_GetNameByColor(player.modernmenu.contents[8][8].value) == ""
					v.drawString(60, 180, desctext + "not defined.", V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
				else
					v.drawString(60, 180, desctext + R_GetNameByColor(player.modernmenu.contents[8][8].value)+".", V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
				end
			end
		end
		//PERFECT RING
		if player.modernmenu.pointer == 9
			if player.modernmenu.contents[8][9].value == 0
				v.drawString(60, 180, desctext + "reticle Opposite Color.", V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
			else
				if R_GetNameByColor(player.modernmenu.contents[8][9].value) == ""
					v.drawString(60, 180, desctext + "not defined.", V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
				else
					v.drawString(60, 180, desctext + R_GetNameByColor(player.modernmenu.contents[8][9].value)+".", V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
				end
			end
		end
		//SP COLOR
		if player.modernmenu.pointer == 10
			if player.modernmenu.contents[8][10].value == 0
				v.drawString(60, 180, desctext + "Unleashed.", V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
			else
				if R_GetNameByColor(player.modernmenu.contents[8][10].value) == ""
					v.drawString(60, 180, desctext + "not defined.", V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
				else
					v.drawString(60, 180, desctext + R_GetNameByColor(player.modernmenu.contents[8][10].value)+".", V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
				end
			end
		end
		//SHOE COLOR
		if player.modernmenu.pointer == 11
			if player.modernmenu.contents[8][11].value == 0
				v.drawString(60, 180, desctext + "your Opposite Color.", V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
			else
				if R_GetNameByColor(player.modernmenu.contents[8][11].value) == ""
					v.drawString(60, 180, desctext + "not defined.", V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
				else
					v.drawString(60, 180, desctext + R_GetNameByColor(player.modernmenu.contents[8][11].value)+".", V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
				end
			end
		end
		if player.modernmenu.pointer == 12
			if player.modernmenu.contents[8][12].value == 0
				v.drawString(60, 180, desctext + "your Color.", V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
			else
				if R_GetNameByColor(player.modernmenu.contents[8][12].value) == ""
					v.drawString(60, 180, desctext + "not defined.", V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
				else
					v.drawString(60, 180, desctext + R_GetNameByColor(player.modernmenu.contents[8][12].value)+".", V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
				end
			end
		end
		if player.modernmenu.pointer == 13
			if player.modernmenu.contents[8][13].value == 0
				v.drawString(60, 180, desctext + "your Color.", V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
			else
				if R_GetNameByColor(player.modernmenu.contents[8][13].value) == ""
					v.drawString(60, 180, desctext + "not defined.", V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
				else
					v.drawString(60, 180, desctext + R_GetNameByColor(player.modernmenu.contents[8][13].value)+".", V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
				end
			end
		end
		if player.modernmenu.pointer == 14
			v.drawString(60, 180, desctext, V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
		end
	else
		--if player.modernmenu.pagepointer == 1
			--v.drawString(125, 160, desctext, V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
		--else
			v.drawString(60, 180, desctext, V_BLUEMAP|V_ALLOWLOWERCASE, "thin")
		--end
	end
end)

local function bloopsWasHere(p, part, colour)
	if p
		local parts = {
			['boost'] = 1,
			['boost_aura'] = 1,
			['boostaura'] = 1,
			['boost_trail'] = 2,
			['boosttrail'] = 2,
			['stomp'] = 3,
			['stomp_trail'] = 4,
			['stomptrail'] = 4,
			['homing_trail'] = 5,
			['homingtrail'] = 5,
			['jump_aura'] = 6,
			['jumpaura'] = 6,
			['jumpsphere'] = 6,
			['jump_sphere'] = 6,
			['jump'] = 6,
			['kick_effects'] = 7,
			['kickeffects'] = 7,
			['kick'] = 7,
			['reticle'] = 8,
			['perfect_ring'] = 9,
			['perfectring'] = 9,
			['color'] = 10,
			['spcolor'] = 10,
			['sp_color'] = 10,
			['shoe_color'] = 11,
			['shoecolor'] = 11,
			['shoes'] = 11,
			['cloth'] = 12,
			['clothcolor'] = 12,
			['gloves'] = 12,
			['stripe'] = 12,
			['socks'] = 12,
			['aura'] = 13,
			['superaura'] = 13,
			['auracolor'] = 13,
			['rush'] = 14,
			['rush_glow'] = 14,
			['rushglow'] = 14,
			['all'] = 15,
			['everything'] = 15
		}
		if part
			if part == "random"
				RandomizeColors(p)
				COM_BufInsertText(p, "savemodernsettings")
			else
				local num = tonumber(part)
				if (num and num>0 and num<16)
				or parts[part:lower()]
				
					local usePart = num or parts[part:lower()]
					local colourNum = tonumber(colour)
					
					if colour
					and ((colourNum != nil and colourNum >= 0 and colourNum < #skincolors)
					or R_GetColorByName(colour)
					or colour:lower() == 'opposite'
					or colour:lower() == 'skincolor')
						--print(colourNum or colour)
						
						local useColour = 0 
						if colour:lower() == 'opposite'
							useColour = ColorOpposite(p.skincolor)
						elseif colour:lower() == 'skincolor'
							useColour = p.skincolor
						else
							useColour = (colourNum or R_GetColorByName(colour)) --funny
						end
						
						if usePart == 15
							for i = 1, 14
								if i == 14
									p.modernmenu.contents[4][4].value = useColour
								elseif i >= 16
									continue
								else
									p.modernmenu.contents[8][i].value = useColour
								end
							end
						elseif usePart == 14
							p.modernmenu.contents[4][4].value = useColour
						else
							p.modernmenu.contents[8][usePart].value = useColour
						end
						COM_BufInsertText(p, "savemodernsettings")
					elseif colour == "default"
						if usePart == 15
							for i = 1, 14
								if i == 14
									p.modernmenu.contents[4][4].value =  p.modernmenu.contents[4][4].defaultvalue
								elseif i >= 16
									continue
								else
									p.modernmenu.contents[8][i].value =  p.modernmenu.contents[8][i].defaultvalue
								end
							end
						elseif usePart == 14
							p.modernmenu.contents[4][4].value = p.modernmenu.contents[4][4].defaultvalue
						else
							p.modernmenu.contents[8][usePart].value = p.modernmenu.contents[8][usePart].defaultvalue
						end
						COM_BufInsertText(p, "savemodernsettings")
					else
						CONS_Printf(p, "You must enter a valid colour.")
					end
					
				else
					CONS_Printf(p, "You must enter a valid part.")
				end
			end
		else
			CONS_Printf(p,
					'Sets the following colourable parts of Modern Sonic'..
					'\n'..
					'boost\n'..
					'boost_trail\n'..
					'stomp\n'..
					'stomp_trail\n'..
					'homing_trail\n'..
					'jump_aura\n'..
					'kick_effects\n'..
					'reticle\n'..
					'perfect_ring\n'..
					'rush\n'..
					'spcolor\n'..
					'shoecolor\n'..
					'clothcolor\n'..
					'auracolor\n'..
					'all\n'..
					'these can be accessed by name or number (1-15)!\n'..
					'afterwards, enter a colour by name or number!'
				)
		end
	else
		CONS_Printf(p, "You must be in a level to use this command.")
	end
end

COM_AddCommand("setModernColours", bloopsWasHere)

local IOPath = 'client/ModernSonic - Color Presets/'

local function bloopsIsStillHere(p, colourName)
	if p
		if p.mo.skin == 'modernsonic'
			if colourName
				if io and p == consoleplayer
					local file = io.openlocal(IOPath..colourName..'.dat', 'w+')
					local theCompletedString = ''
					for i = 1, 14
						if i == 14
							theCompletedString = $..p.modernmenu.contents[4][4].value
						else
							theCompletedString = $..p.modernmenu.contents[8][i].value..'\n'
						end
					end
					file:write(theCompletedString)
					file:close()
				end
			else	
				CONS_Printf(p, "Saves a colour preset for Modern Sonic, type in a colour name to save its preset.")
			end
		else
			CONS_Printf(p, "You must be ModernSonic to use this command.")
		end
	else
		CONS_Printf(p, "You must be in a level to use this command.")
	end
end

COM_AddCommand("saveModernColours", bloopsIsStillHere)

local function bloopsSaysHi(p, colourName)
	if p
		if p.mo.skin == 'modernsonic'
			if colourName
				if io and p == consoleplayer
					io.open(IOPath..colourName..'.dat', 'r', function(file)
						if file
							local colourCount = 1
							local prevColours = {
							}
							for line in file:lines() do
								local colour = tonumber(line)
								local prevColour
								if colour == nil
									colourCount = $*-1
									break
								end
								if colourCount == 14
									p.modernmenu.contents[4][4].value = colour
									break
								else
									prevColour = p.modernmenu.contents[8][colourCount].value
									if colour <= #skincolors
										p.modernmenu.contents[8][colourCount].value = colour
									else
										p.modernmenu.contents[8][colourCount].value = p.modernmenu.contents[8][colourCount].defaultvalue
									end
								end
								table.insert(prevColours, prevColour)
								colourCount = $ + 1
							end
							if colourCount == 14
								COM_BufInsertText(p, "savemodernsettings")
								CONS_Printf(p,"Colour preset Loaded Hopefully!")
							else
								CONS_Printf(p, "Colour preset broken, line "..(colourCount*-1)..' malformed, perhaps?')
								if prevColours[1]
									for i = 1, #prevColours
										p.modernmenu.contents[8][i].value = prevColours[i]
										-- should rushcolor be invalid, it wont be set regardless, terrible futureproofing
									end
									CONS_Printf(p, "Colours reverted.")
								end
							end
						else
							CONS_Printf(p,"No file found!")
						end
					end)
				end
			else	
				CONS_Printf(p, "Loads a colour preset for Modern Sonic, type in a colour name to load its preset.")
			end
		else
			CONS_Printf(p, "You must be ModernSonic to use this command.")
		end
	else
		CONS_Printf(p, "You must be in a level to use this command.")
	end
end

COM_AddCommand("loadModernColours", bloopsSaysHi)

local function openMenu(p)
	if p
		if p.mo.skin == 'modernsonic'
			if not p.modernmenu.show
				p.modernmenu.show = true
				P_PlayJingleMusic(p, "MMENU", nil, true, JT_OTHER)
				p.custom3down = true
				LoadModernSettings(p)
			else
				p.modernmenu.show = false
				p.powers[pw_flashing] = 35
				P_RestoreMusic(p)
				if p == consoleplayer
					COM_BufInsertText(p, "savemodernsettings")
				end
			end
		else
			CONS_Printf(p, "You must be ModernSonic to use this command.")
		end
	else
		CONS_Printf(p, "You must be in a level to use this command.")
	end
end

COM_AddCommand("ModernMenu", openMenu)