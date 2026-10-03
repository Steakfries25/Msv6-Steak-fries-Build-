if not colorsUltimate then rawset(_G, 'colorsUltimate', {}) end
colorsUltimate[1] = 0 --colors Ultimate X offset (set to 1 for extreme trolling)


-- v is the drawer
-- x, y are screen coordinates
-- text is the string to display
-- font is the patch prefix
-- flags is just like any other HUD function
-- alignment: -1 = right-aligned, 1 = left-aligned
-- color is a skincolor
rawset(_G, "DrawMotdString", function(v, x, y, scale, text, font, flags, alignment, color)
  local right
  local colormap = v.getColormap(0, color)
  local start
  local finish
  alignment = $ or 1
  color = $ or 0
  right = alignment < 0
  text = tostring(text)

  if right
    start = text:len()
    finish = 1
  else
    start = 1
    finish = text:len()
  end

  for i = start, finish, alignment
    local letter = font .. text:sub(i, i)
    if not v.patchExists(letter) then continue end

    local patch = v.cachePatch(letter)

    if right -- right aligned, change offset before drawing
      x = $ - patch.width*scale
    end

    v.drawScaled(x, y, scale, patch, flags, colormap)

    if not right -- left aligned, change offset after drawing
      x = $ + patch.width*scale
    end
  end
end)

/*hud.add(function(v, p)
	v.drawString(316, 182, "trickable: "+ (p.trickable), V_REDMAP, "right")
	v.drawString(316, 190, "tricktimer: "+ (p.trickcooldown), V_REDMAP, "right")
end, "game")*/

local function modernboostlines(v, player, camera)
    if player.mo and player.mo.skin == "modernsonic"
        if player.playerstate == PST_LIVE
        and player.modernmenu.contents[3][2].value == 1 -- Speedlines
            if (abs(player.speed) > FixedMul(65*FRACUNIT, player.mo.scale) and not (player.powers[pw_carry] == CR_MINECART) and not (player.powers[pw_sneakers]) and not (player.powers[pw_nocontrol]))
            or player.minecartboost == true
            or (player.customhoming and player.customhoming > 0)
                if player.boostlinetimer
                    local patch = v.cachePatch("BSTFX"..tostring(player.boostlinetimer))
                    v.drawStretched(0, 0, v.width()*FU/patch.width, v.height()*FU/patch.height, patch, V_60TRANS|V_PERPLAYER|V_SNAPTOLEFT|V_SNAPTOTOP|V_NOSCALESTART|V_NOSCALEPATCH, v.getColormap(TC_DEFAULT, SKINCOLOR_SILVER))
                end
            end
        end
    end
end
hud.add(modernboostlines)

////////////////////////////////////////////////////////////////////////
--
-- Originally was Boss HUD rendering code.
-- (c) Inuyasha 2014.
-- Permissionwas granted by Inuyasha to use this code
-- and the associated graphics in other mods.
--
local posy = 0
local posx = 0
local posy2 = 0
local posx2 = 0
local client
local rushstary
local function modernhuddisable(v, player)
		if (player.realmo and player.realmo.skin != "modernsonic" and player.wasjustmodern)
		or player.mo.skin == "modernsonic" and player.modernmenu.contents[3][1].value == 7 -- HUDStyle
		and not (G_RingSlingerGametype())
			if not hud.enabled("lives")
				hud.enable("lives")
			end
			if not hud.enabled("rings")
				hud.enable("rings")
			end
			if not hud.enabled("time")
				hud.enable("time")
			end
			if not hud.enabled("score")
				hud.enable("score")
			end
		elseif player.realmo and player.realmo.skin == "modernsonic"
			if not (G_RingSlingerGametype())
			and player.wasjustmodern
				if hud.enabled("time")
					hud.disable("time")
				end
				if hud.enabled("score")
					hud.disable("score")
				end
				if hud.enabled("lives")
					hud.disable("lives")
				end
				if hud.enabled("rings")
					hud.disable("rings")
				end
			else
				if not hud.enabled("rings")
					hud.enable("rings")
				end
				if not hud.enabled("time")
					hud.enable("time")
				end
				if not hud.enabled("score")
					hud.enable("score")
				end
			end
		end
	end
hud.add(modernhuddisable)
/*
									ADDING CUSTOM SHIELDS
											WOO
*/
if not modernSonicCustomShields
	rawset(_G, "modernSonicCustomShields", {})
end
/*
	v, drawer
	initX, inital X position of the patch
	XGap, how far the patch moves per iteration
	Y, Y position of the patch
	scale, scale of the patch
	limit, how many characters used in the string (may overflow, use at own risk!)
	variable, number variable to track
	patch, font to use
	motdstring, default filler character is 'variable' is smaller than 'limit'
	flags, drawing flags
*/

local function extendedSporkString(v, initX, XGap, Y, scale, limit, variable, patch, motdstring, flags)
	if tostring(variable):len() < limit
		for i = 0, (limit-1)-(tostring(variable):len())
			DrawMotdString(v, initX, Y, scale, motdstring, patch, flags)
			initX = $ + XGap
		end
	end
	DrawMotdString(v, initX, Y, scale, variable, patch, flags)
end

--simple, v is the drawer, num is the desired transparency, do a truth check with function before drawing with it!
local function adjustHUDTrans(v, num)
	local theShift = min(10,(v.localTransFlag()>>V_ALPHASHIFT)+num)
	if theShift >= 10
		return false
	end
	return (theShift<<V_ALPHASHIFT)
end

--shorthand motherfuckers

local TLF = V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER
local TRF = V_SNAPTOTOP|V_SNAPTORIGHT|V_PERPLAYER
local BLF = V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER
local BRF = V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER
local HTF = V_HUDTRANS
/*
hud.add(function(v,p,c)
	if p.mo	and p.mo.skin == 'modernsonic'
	and p == displayplayer
		if p.rettarget
		and p.ret
		and CV_FindVar("chasecam").value
		
			local dupx, dupy = v.dupy()
			local getYTotal = FixedDiv(v.height(), dupx)
			dupy, dupx = v.dupx()
			local getXTotal = FixedDiv(v.width(), dupy)

			-- Stealing this from Sparkizard, sorry!!
			
			local sx = c.angle - R_PointToAngle(p.ret.x, p.ret.y)
			local visible = false

			-- Get the h distance from the target
			local hdist = R_PointToDist(p.ret.x, p.ret.y)
			if sx > ANGLE_90 or sx < ANGLE_270 then
				visible = false
			else
				sx = FixedMul(getXTotal/2, tan($1)) + (getXTotal/2)
				visible = true
			end

			local sy = (getYTotal/2) + (getYTotal/FU) * (tan(c.aiming) - FixedDiv(p.ret.z-c.z, 1 + FixedMul(hdist, cos(c.angle - R_PointToAngle(p.ret.x, p.ret.y))) ))
			

			local transparencies = {0, V_20TRANS, V_40TRANS, V_60TRANS, V_80TRANS, V_90TRANS}
			
			if visible
				v.drawScaled(sx, sy,  p.ret.scale/4, v.getSpritePatch('RETT', A, 0, p.ret.rollangle), TLF|transparencies[p.ret.lifetime], v.getColormap(TC_DEFAULT, p.ret.color))
				if p.ret.ring1
					v.drawScaled(sx, sy, p.ret.ring1.scale/2, v.getSpritePatch('JCRC', A, 0, 0), TLF|V_30TRANS, v.getColormap(TC_DEFAULT, p.ret.ring1.color))
				end
				if p.ret.ring2
					v.drawScaled(sx, sy, p.ret.ring2.scale/2, v.getSpritePatch('JCRC', B, 0, 0), TLF, v.getColormap(TC_DEFAULT, SKINCOLOR_WHITE))
				end
			end
			
		end
	end
end)
*/

local clamp = function(num, minimum, maximum)
	return min(maximum, max(num, minimum))
end

local modernhudfunction = function(x, y, z, camz, ang, aim, realwidth, realheight, mobjflip)
	
	z = $ - camz
	aim = clamp(aim, -ANGLE_90 + 1, ANGLE_90 - 1)
	
	local width = realwidth/2
	local height = realheight/2
	
	//FOV calcs
	local FOV = CV_FindVar("fov").value * FRACUNIT
	local fovang2 = (FOV + (consoleplayer and consoleplayer.fovadd or 90*FRACUNIT))/2
	local fovtan = tan(FixedAngle(fovang2))
	local fg = width*fovtan
	//Screen width calculations
	local diffwidth = realwidth-(width*2) 
	local clampang = ANGLE_45 + (ANG1*5/64)*diffwidth
	
	//Horizontal
	local h = R_PointToDist(x, y)
	local diffang = ang - R_PointToAngle(x, y)
	local da = clamp(diffang, -clampang, clampang)
	local clampedh = 0
	if da > diffang
		clampedh = 1//left side of screen
	elseif da < diffang
		clampedh = 2//right side of screen
	end
	
	//Screen height calculations
	local diffheight = realheight-(height*2)
	local clampvert = FRACUNIT*3/5 + (FRACUNIT*3/50/16)*diffheight
	
	//Vertical
	local diffaim = tan(aim) - FixedDiv(z, 1 + FixedMul(cos(da), h))
	local dv = clamp(diffaim, -clampvert, clampvert)
	local clampedv = 0
	if dv > diffaim
		clampedv = 1//top side of screen
	elseif dv < diffaim
		clampedv = 2//bottom side of screen
	end
	
	//Final hud position calcs
	local sx = width<<FRACBITS + FixedMul(tan(da), fg)
	
	local sy
	if (mobjflip == -1)
	and (CV_FindVar("flipcam").value or not CV_FindVar("chasecam").value)
		sy = height<<FRACBITS - FixedMul(dv, fg)
	else
		sy = height<<FRACBITS + FixedMul(dv, fg)
	end
	
	
	local scale = FixedDiv(width<<FRACBITS, h+1)
	
	return sx, sy, scale, clampedv, clampedh
end
local function radar(v, player, cam)
	local pmo = player.mo
	
	if not (pmo)
	or not (pmo.valid)
		return
	end
	local p = player
	local t = p.ret
	local scale = FRACUNIT/2
	local trans = V_10TRANS
	local fade = 0
	local fade2 = 0
	local patch
	local patch_arrow
	local center = false
	local yoff = false
	
	//Get camera info
	local xx = cam.x
	local yy = cam.y
	local zz = cam.z
	if p.awayviewmobj
	and p.awayviewtics 
		xx = p.awayviewmobj.x
		yy = p.awayviewmobj.y
		zz = p.awayviewmobj.z
	end
	local angle = 0
	local aiming = cam.aiming
	if player.playerstate == PST_LIVE
		if p.awayviewmobj
		and p.awayviewtics 
			angle = p.awayviewmobj.angle
			aiming = p.awayviewaiming
		else
			angle = cam.angle
		end
		if (player.spectator or not cam.chase)//Use the realmo coordinates when not using chasecam
			xx = pmo.x
			yy = pmo.y
			if P_MobjFlip(player.mo) == -1
				zz = pmo.z - pmo.height
			else
				zz = pmo.z + pmo.height
			end 
			angle = player.cmd.angleturn<<FRACBITS
			aiming = player.cmd.aiming<<FRACBITS
		end
	end
	
	if p.rettarget
	and p.ret
		local mo = t
		if not(mo.valid and mo.health) return end
		local yoffset = 0
		if center
			yoffset = mo.height / 2
		elseif yoff
			yoffset = yoff
		end
		
					
		//Calculate
		local dx, dy, ds, clampedv, clampedh = modernhudfunction(mo.x, mo.y, mo.z, zz, angle, aiming, v.width()/v.dupx(), v.height()/v.dupy(), P_MobjFlip(player.mo))
		
		//Check distance
		local final_trans = trans
		local final_patch = patch
		local dist = R_PointToDist(mo.x,mo.y)
		local clampscale = true
		
		//Clamped objects lose scale
		if clampscale
			ds = min(FRACUNIT*2/3, ds)
		end
		local visible = true
		//Finally draw the damn thing
		local transparencies = {0, V_20TRANS, V_40TRANS, V_60TRANS, V_80TRANS, V_90TRANS}
		v.drawScaled(dx, dy,  p.ret.scale/4, v.getSpritePatch('RETT', A, 0, p.ret.rollangle), TLF|transparencies[p.ret.lifetime], v.getColormap(TC_DEFAULT, p.ret.color))
		if p.ret.ring1
			v.drawScaled(dx, dy, p.ret.ring1.scale/2, v.getSpritePatch('JCRC', A, 0, 0), TLF|V_30TRANS, v.getColormap(TC_DEFAULT, p.ret.ring1.color))
		end
		if p.ret.ring2
			v.drawScaled(dx, dy, p.ret.ring2.scale/2, v.getSpritePatch('JCRC', B, 0, 0), TLF, v.getColormap(TC_DEFAULT, SKINCOLOR_WHITE))
		end
	end
end
hud.add(radar, 'game')
//Unleashed
local function unleashedhud(v, player)
	client = player
	if player.cleartimer and player.cleartimer >= 1
		return
	end
	local moderninflife = CV_FindVar("cooplives")
		if player.mo and player.mo.skin == "modernsonic"
        and not (player.powers[pw_carry] == CR_NIGHTSMODE)
		and (player.modernmenu.contents[3][1].value == 0 -- HUDStyle
		or player.modernmenu.contents[3][1].value == 9) -- HUDStyle
		    local boostfill = 0;
			local boostcap = 0;
			local boostdrain = 0;
			if player.boostmeter == nil
				return
			end
			boostcap = $1 + 117
            boostfill = $1 + player.boostmeter
			boostdrain = $1 + player.boostmeter+1
 
			local p_ustartseg = v.cachePatch("UMTRENDL")
			local p_uonseg    = v.cachePatch("UMTRMIDL")
			local p_uoffseg   = v.cachePatch("UMTRMPTY")
			local p_uendseg   = v.cachePatch("UMTRENDR")
			local p_boost    = v.cachePatch("BOOST")
			local hammertime = v.cachePatch("UNSHINVC")
			local freshnikes = v.cachePatch("UNSHSHOE")
			local armashield = v.cachePatch("UNSHARMA")
			local elemshield = v.cachePatch("UNSHELEM")
			local bubbshield = v.cachePatch("UNSHBUBB")
			local flmeshield = v.cachePatch("UNSHFLME")
			local frc2shield = v.cachePatch("UNSHFRC2")
			local frc1shield = v.cachePatch("UNSHFRC1")
			local magnshield = v.cachePatch("UNSHMAGN")
			local pinkshield = v.cachePatch("UNSHPINK")
			local pityshield = v.cachePatch("UNSHPITY")
			local windshield = v.cachePatch("UNSHWIND")
			local lgtnshield = v.cachePatch("UNSHLGTN")
			local sorrynothing = v.cachePatch("NOTHING")
			local shielddisplay = v.cachePatch("UNSHIELD")
			local flag_red = v.cachePatch("UNSHRFLG")
			local flag_blue = v.cachePatch("UNSHBFLG")
			local gravboots = v.cachePatch("UNSHGRAV")			
			
			local shieldinuse = {
				[SH_WHIRLWIND] = windshield,
				[SH_ELEMENTAL] = elemshield,
				[SH_FLAMEAURA] = flmeshield,
				[SH_BUBBLEWRAP] = bubbshield,
				[SH_THUNDERCOIN] = lgtnshield,
				[SH_ARMAGEDDON] = armashield,
				[SH_PINK] = pinkshield,
				[SH_ATTRACT] = magnshield,
				[SH_PITY] = pityshield,
				[SH_NONE] = sorrynothing
			}
			
			for i = 1, #modernSonicCustomShields
				shieldinuse[modernSonicCustomShields[i].shieldName] = v.cachePatch(modernSonicCustomShields[i].unleashedPatch)
			end
			//print(modernSonicCustomShields['Boulder Shield'].shieldName)

			
			local forceshieldisstupid = (player.powers[pw_shield]&SH_FORCEHP) and frc1shield or frc2shield
			local shield = player.powers[pw_shield]
			local getshieldpatch = (shield & SH_FORCE) and forceshieldisstupid or shieldinuse[shield&SH_NOSTACK]
			local shieldoffset = 32
			
			posx = 186
			posy = 174
			
			local hasshield = ((shield&SH_NOSTACK) or (shield&SH_FORCE)) and getshieldpatch or nil
			local lmao = {}
			if player.powers[pw_sneakers]
				table.insert(lmao, freshnikes)
			end
			if player.powers[pw_invulnerability]
				table.insert(lmao, hammertime)
			end
			if player.powers[pw_gravityboots]
				table.insert(lmao, gravboots)
			end
			if player.gotflag
				local ctf_flag = (player.gotflag == 1) and flag_red or flag_blue
				table.insert(lmao, ctf_flag)
			end
			if hasshield
				table.insert(lmao, hasshield)
			end
			local dispx = (posx-68+shielddisplay.width)
			local invend = (player.powers[pw_invulnerability] <= 3*TICRATE and player.powers[pw_invulnerability] and leveltime % 2 == 0)
			local shoeend = (player.powers[pw_sneakers] <= 3*TICRATE and player.powers[pw_sneakers] and leveltime % 2 == 0)
			if (#lmao-1) >= 0
				v.draw(dispx - (shieldoffset*(#lmao)), posy-171, shielddisplay, TRF|HTF)
				for i = 0, #lmao-1
					local flasher = ((lmao[i+1] == hammertime and invend) or (lmao[i+1] == freshnikes and shoeend)) and V_90TRANS or HTF
					v.draw(posx+102 - (shieldoffset*i), posy-174, lmao[i+1], TRF|flasher)
				end
			end
			
			if G_RingSlingerGametype()
				posy = 160				
			end
			posx = $1 - (boostcap+1)
			
			v.draw(2, 166, v.cachePatch("UMTRENDL"), BLF|HTF)
			
			local boostMeter = (abs(FU*boostfill/boostcap)*110)/FU
			local boostPieces = {}
			for i = 1, 22
				local patchInsert = (i>9) and "UNBSTM" or "UNBSTM0"
				table.insert(boostPieces, patchInsert+tostring(i))
			end
			local theLoop =  min(22,max(0,(boostMeter/5)))
			for i = 1,theLoop
				if i == theLoop and not (boostfill == boostcap)
					local hudTrans = adjustHUDTrans(v, 11-(((boostMeter%5)+1)*2))
					if hudTrans
						v.draw(72, 175, v.cachePatch(boostPieces[i]), BLF|hudTrans)
					end
				else
					v.draw(72, 175, v.cachePatch(boostPieces[i]), BLF|HTF)
				end
			end
			
			v.draw(80, 176, v.cachePatch("ENERGY"), BLF|HTF)
			
			if player.rushmode
				local rushcolor = (leveltime % 2 == 0) and player.rushcolor or player.mo.color
				local rushnum = (((FU*player.rushmode/350)*20)/FU)+1
				local fslrpatch = (rushnum >= 10) and "RRUSHM" or "RRUSHM0"
				local fslrcache = v.cachePatch(fslrpatch..tostring(rushnum))
				v.draw(2, 166, fslrcache, V_10TRANS|BLF|HTF, v.getColormap(TC_DEFAULT, rushcolor))
			else
				if player.speed >  0
					--local speedvalue = (abs(player.speed) >= 56*FU) and 14 or ((abs(player.speed)/(4*FU)) + 1)
					local speedvalue = (((min(56*FU, abs(player.speed))/56)*19)/FU)+1
					local speedpatch = (speedvalue >= 10) and "SPEEDM" or "SPEEDM0"
					local speedcache = v.cachePatch(speedpatch..tostring(speedvalue))
					v.draw(2, 166, speedcache, V_10TRANS|BLF|HTF)
				end
			end
			
			local infbstpatch = (player.rushmode == 0) and v.cachePatch("SPEED") or v.cachePatch("URUSH")
			v.draw(35, 167, infbstpatch, V_30TRANS|BLF|HTF)
			
			local shitX = (player.rings > 999) and 27*FU or 35*FU
			extendedSporkString(v, shitX, 8*FU, 179*FU, FU, 3, player.rings, "UNLDHD1", "0", BLF|HTF)
			
			if not (gamemap >= 60 and gamemap <= 66)
			and not (G_RingSlingerGametype())
				--Life
				local supericon = (player.powers[pw_super]) and v.cachePatch("ULIFE2") or v.cachePatch("ULIFE1")
				v.draw(8, 8, supericon, TLF|HTF, v.getColormap(player.mo.skin, ((player.powers[pw_super] > 0 and player.powers[pw_super] < 2) and SKINCOLOR_SUPERSUNBEAM4 or player.mo.color)))

				if (moderninflife.value == 0 and multiplayer)
				or player.lives == INFLIVES
					v.drawScaled((33*FRACUNIT), (12*FRACUNIT), FRACUNIT, v.cachePatch("UNLDHDI"), TLF|HTF)
				else					
					extendedSporkString(v, 33*FU, 8*FU, 12*FU, FU, 2, player.lives, "UNLDHD1", "0", TLF|HTF)
				end
				
				--Time
				v.drawScaled((0), (30*FRACUNIT), FRACUNIT, v.cachePatch("UTIME"), TLF|HTF)
			
				local timers = {min(99, G_TicsToMinutes(player.realtime)), G_TicsToSeconds(player.realtime), G_TicsToCentiseconds(player.realtime)}
				local timerOffsets = {14,36,57}
				local theOffset
				for i =  1, 3
					theOffset = timerOffsets[i]*FU
					if timers[i] < 10
						DrawMotdString(v, theOffset, 40*FRACUNIT, FRACUNIT, "0", "UNLDHD2", TLF|HTF)
						theOffset = $ + 7*FU
					end
					DrawMotdString(v, theOffset, 40*FRACUNIT, FRACUNIT, timers[i], "UNLDHD2", TLF|HTF)
				end
				
				v.drawScaled((51*FRACUNIT), (41*FRACUNIT), FRACUNIT, v.cachePatch("UNLDHDS"), TLF|HTF)
				v.drawScaled((30*FRACUNIT), (41*FRACUNIT), FRACUNIT, v.cachePatch("UNLDHDS"), TLF|HTF)

				--Score
				v.drawScaled((0), (60*FRACUNIT), FRACUNIT, v.cachePatch("USCORE"), TLF|HTF)
				extendedSporkString(v, 8*FU, 7*FU, 70*FU, FU, 9, player.score, "UNLDHD2", "0", TLF|HTF)
			end
			for i = 1, #player.hudring3
				local hudringTrans = adjustHUDTrans(v, 10-(player.hudring3[i]))
				if player.hudring3[i]
				and hudringTrans
					v.drawScaled(22*FU, 186*FU, max(FU, (FU*(7-player.hudring3[i]))/4), v.cachePatch("RINGC"), V_ADD|hudringTrans|BLF)
				end
			end
		end
	end
hud.add(unleashedhud)


//Generations
local function generationshud(v, player)
	client = player
	if player.cleartimer and player.cleartimer >= 1
		return
	end
	local moderninflife = CV_FindVar("cooplives")
		if player.mo and player.mo.skin == "modernsonic"
        and not (player.powers[pw_carry] == CR_NIGHTSMODE)
		and (player.modernmenu.contents[3][1].value == 1 -- HUDStyle
		or player.modernmenu.contents[3][1].value == 9) -- HUDStyle
		    local boostfill = 0;
			local boostcap = 0;
			local boostdrain = 0;
			local rushfill = 0;
			local rushcap = 0;
			local rushdrain = 0;
			if player.boostmeter == nil
				return
			end
			boostcap = $1 + 117
            boostfill = $1 + player.boostmeter
			boostdrain = $1 + player.boostmeter+1
			rushcap = $1 + 10*TICRATE
            rushfill = $1 + player.rushmode
			rushdrain = $1 + player.rushmode+1
 
			local p_gstartseg = v.cachePatch("GMTRENDL")
			local p_gstartsega = v.cachePatch("GMTRENDA")
			local p_gonseg    = v.cachePatch("GMTRMIDL")
			local p_goffseg   = v.cachePatch("GMTRMPTY")
			local p_glife    = v.cachePatch("GLIFE")
			local p_gring    = v.cachePatch("GRING")
			local p_gtime    = v.cachePatch("GTIME")
			local p_gcolon	 = v.cachePatch("GENSHDS")	
			local p_gperiod	 = v.cachePatch("GENSHDP")	
			
			local frc1shield = v.cachePatch("NSHFRC1")
			local frc2shield = v.cachePatch("NSHFRC2")
			local armashield = v.cachePatch("NSHARMA")
			local magnshield = v.cachePatch("NSHMAGN")
			local elemshield = v.cachePatch("NSHELEM")
			local windshield = v.cachePatch("NSHWIND")
			local pityshield = v.cachePatch("NSHPITY")
			local pinkshield = v.cachePatch("NSHAMYS")
			local bubbshield = v.cachePatch("NSHBUBB")
			local flmeshield = v.cachePatch("NSHFLME")
			local lgtnshield = v.cachePatch("NSHLGTN")
			local sorrynothing = v.cachePatch("NOTHING")
			local shieldbg = v.cachePatch("GNSHIELD")
			
			local shieldinuse = {
				[SH_WHIRLWIND] = windshield,
				[SH_ELEMENTAL] = elemshield,
				[SH_FLAMEAURA] = flmeshield,
				[SH_BUBBLEWRAP] = bubbshield,
				[SH_THUNDERCOIN] = lgtnshield,
				[SH_ARMAGEDDON] = armashield,
				[SH_PINK] = pinkshield,
				[SH_ATTRACT] = magnshield,
				[SH_PITY] = pityshield,
				[SH_NONE] = sorrynothing
			}
			
			for i = 1, #modernSonicCustomShields
				shieldinuse[modernSonicCustomShields[i].shieldName] = v.cachePatch(modernSonicCustomShields[i].gens06Patch)
			end
			
			local forceshieldisstupid = (player.powers[pw_shield]&SH_FORCEHP) and frc1shield or frc2shield
			local shield = player.powers[pw_shield]
			local useshieldbg = ((shield&SH_FORCE)or(shield&SH_NOSTACK)) and shieldbg or sorrynothing
			local getshieldpatch = (shield & SH_FORCE) and forceshieldisstupid or shieldinuse[shield&SH_NOSTACK]
			
			if not getshieldpatch
				getshieldpatch = sorrynothing --lil failsafe for invalid shields!!
				useshieldbg = sorrynothing
			end
			
			v.draw(posx+24, posy-29, useshieldbg, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS);
			v.draw(posx+24, posy-29, getshieldpatch, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS);
			posx = 150
			posx2 = 150
			if G_RingSlingerGametype()
				posy = 160
				posy2 = 160
			else
				posy = 174 
				posy2 = 174
			end
			
			posx = $1 - 1
			posx2 = $1 - 1
			-- Step through backwards, to match the way we're drawing.
			for i = boostcap, 1, -1
				if boostfill >= i
					if (player.powers[pw_super])
						v.draw(posx, posy, p_gonseg, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS, v.getColormap("SKINCOLOR_YELLOW", ((player.powers[pw_super] > 0 and player.powers[pw_super] < 2) and SKINCOLOR_SUPERSUNBEAM4 or player.mo.color)))
					elseif player.boostmeter > 50
						v.draw(posx, posy, p_gonseg, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS, v.getColormap("SKINCOLOR_YELLOW", SKINCOLOR_EMERALD))
					elseif player.boostmeter > 49
						v.draw(posx, posy, p_gonseg, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS, v.getColormap("SKINCOLOR_APRICOT", SKINCOLOR_GREEN))
					elseif player.boostmeter > 20
						v.draw(posx, posy, p_gonseg, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS, v.getColormap("SKINCOLOR_ORANGE", SKINCOLOR_YELLOW))
					elseif player.boostmeter > 19
						v.draw(posx, posy, p_gonseg, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS, v.getColormap("SKINCOLOR_FLAME", SKINCOLOR_ORANGE))
					elseif player.boostmeter > 0
						v.draw(posx, posy, p_gonseg, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS, v.getColormap("SKINCOLOR_RED", SKINCOLOR_RED))
					end
				else
					v.draw(posx, posy, p_goffseg, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
				end
				posx = $1 - 1;
			end
			if player.rushmode > 0
				for i = rushcap, 1, -3
					if rushfill >= i
						if player.flashingtimer >= 8 and player.flashingtimer <= 9
							v.draw(posx2, posy2, p_gonseg, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS, v.getColormap("SKINCOLOR_YELLOW", SKINCOLOR_SUPERSKY5))
						elseif player.flashingtimer >= 6 and player.flashingtimer <= 7
						or player.flashingtimer >= 10 and player.flashingtimer <= 11
							v.draw(posx2, posy2, p_gonseg, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS, v.getColormap("SKINCOLOR_YELLOW", SKINCOLOR_SUPERSKY4))
						elseif player.flashingtimer >= 4 and player.flashingtimer <= 5
						or player.flashingtimer >= 12 and player.flashingtimer <= 13
							v.draw(posx2, posy2, p_gonseg, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS, v.getColormap("SKINCOLOR_YELLOW", SKINCOLOR_SUPERSKY3))
						elseif player.flashingtimer >= 2 and player.flashingtimer <= 3
						or player.flashingtimer >= 14 and player.flashingtimer <= 15
							v.draw(posx2, posy2, p_gonseg, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS, v.getColormap("SKINCOLOR_YELLOW", SKINCOLOR_SUPERSKY2))
						elseif player.flashingtimer >= 0 and player.flashingtimer <= 1
							v.draw(posx2, posy2, p_gonseg, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS, v.getColormap("SKINCOLOR_YELLOW", SKINCOLOR_SUPERSKY1))
						end
						
					end
					posx2 = $1 - 1;
				end
			end
			-- Start segment
			if player.modernmenu.contents[2][2].value == 1
				v.draw(posx, posy, p_gstartsega, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS);
			else
				v.draw(posx, posy, p_gstartseg, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS);
			end
			if not (gamemap >= 60 and gamemap <= 66)
			and not (G_RingSlingerGametype())
				--Ring
					if player.rings < 10
						DrawMotdString(v, 48*FRACUNIT, 50*FRACUNIT, FRACUNIT/3, player.rings, "GENSHD", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
						DrawMotdString(v, 40*FRACUNIT, 50*FRACUNIT, FRACUNIT/3, "0", "GENSHD", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
						DrawMotdString(v, 32*FRACUNIT, 50*FRACUNIT, FRACUNIT/3, "0", "GENSHD", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					elseif player.rings < 100
						DrawMotdString(v, 40*FRACUNIT, 50*FRACUNIT, FRACUNIT/3, player.rings, "GENSHD", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
						DrawMotdString(v, 32*FRACUNIT, 50*FRACUNIT, FRACUNIT/3, "0", "GENSHD", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					else
						DrawMotdString(v, 32*FRACUNIT, 50*FRACUNIT, FRACUNIT/3, player.rings, "GENSHD", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					end
					v.drawScaled((10*FRACUNIT), (45*FRACUNIT), 3*FRACUNIT/4, p_gring, V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
					
				--Life
					v.drawScaled((270*FRACUNIT), (15*FRACUNIT), 3*FRACUNIT/4, p_glife, V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap("SKINCOLOR_NONE", ((player.powers[pw_super] > 0 and player.powers[pw_super] < 2) and SKINCOLOR_SUPERSUNBEAM4 or player.mo.color)))
					if (moderninflife.value == 0 and multiplayer)
					or player.lives == INFLIVES
						v.drawScaled((294*FRACUNIT), (18*FRACUNIT), FRACUNIT, v.cachePatch("GENSHDI"), V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
					else
						if player.lives < 10
							DrawMotdString(v, 301*FRACUNIT, 20*FRACUNIT, FRACUNIT/3, player.lives, "GENSHD", V_SNAPTOTOP|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS)
							DrawMotdString(v, 293*FRACUNIT, 20*FRACUNIT, FRACUNIT/3, "0", "GENSHD", V_SNAPTOTOP|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS)
						else
							DrawMotdString(v, 293*FRACUNIT, 20*FRACUNIT, FRACUNIT/3, player.lives, "GENSHD", V_SNAPTOTOP|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS)
						end
					end
				--Time
					v.drawScaled((10*FRACUNIT), (15*FRACUNIT), 3*FRACUNIT/4, p_gtime, V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
					local minutes = min(99, G_TicsToMinutes(player.realtime))
					if G_TicsToMinutes(player.realtime) < 10
						DrawMotdString(v, 32*FRACUNIT, 20*FRACUNIT, FRACUNIT/3, "0", "GENSHD", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
						DrawMotdString(v, 40*FRACUNIT, 20*FRACUNIT, FRACUNIT/3, minutes, "GENSHD", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					else
						DrawMotdString(v, 32*FRACUNIT, 20*FRACUNIT, FRACUNIT/3, minutes, "GENSHD", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					end
					if G_TicsToSeconds(player.realtime) < 10
						DrawMotdString(v, 56*FRACUNIT, 20*FRACUNIT, FRACUNIT/3, "0", "GENSHD", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
						DrawMotdString(v, 64*FRACUNIT, 20*FRACUNIT, FRACUNIT/3, G_TicsToSeconds(player.realtime), "GENSHD", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					else
						DrawMotdString(v, 56*FRACUNIT, 20*FRACUNIT, FRACUNIT/3, G_TicsToSeconds(player.realtime), "GENSHD", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					end
					if G_TicsToCentiseconds(player.realtime) < 10
						DrawMotdString(v, 80*FRACUNIT, 23*FRACUNIT, FRACUNIT/4, "0", "GENSHD", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
						DrawMotdString(v, 88*FRACUNIT, 23*FRACUNIT, FRACUNIT/4, G_TicsToCentiseconds(player.realtime), "GENSHD", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					else
						DrawMotdString(v, 80*FRACUNIT, 23*FRACUNIT, FRACUNIT/4, G_TicsToCentiseconds(player.realtime), "GENSHD", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					end
					v.drawScaled(50*FRACUNIT, 21*FRACUNIT, FRACUNIT/3, p_gcolon, V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					v.drawScaled(74*FRACUNIT, 26*FRACUNIT, FRACUNIT/3, p_gperiod, V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
				
			end
		end
	end
hud.add(generationshud)

//Forces
local function forceshud(v, player)
	client = player
	if player.cleartimer and player.cleartimer >= 1
		return
	end
	local moderninflife = CV_FindVar("cooplives")
		if player.mo and player.mo.skin == "modernsonic"
        and not (player.powers[pw_carry] == CR_NIGHTSMODE)
		and (player.modernmenu.contents[3][1].value == 2 -- HUDStyle
		or player.modernmenu.contents[3][1].value == 9) -- HUDStyle
		    local boostfill = 0;
			local boostcap = 0;
			local boostdrain = 0;
			if player.boostmeter == nil
				return
			end
			boostcap = $1 + 117
            boostfill = $1 + player.boostmeter
			boostdrain = $1 + player.boostmeter+1
 
			local p_fstartseg = v.cachePatch("FMTRENDL")
			local p_fonseg    = v.cachePatch("FMTRMIDL")
			local p_foffseg   = v.cachePatch("FMTRMPTY")
			local p_fendseg   = v.cachePatch("FMTRENDR")
			local p_flife    = v.cachePatch("FLIFE")
			local p_fscore    = v.cachePatch("FSCORE")
			local p_fring    = v.cachePatch("FRING")
			local p_ftime    = v.cachePatch("FTIME")
			local p_fcolon	 = v.cachePatch("FORCHDS")	
			local p_fperiod	 = v.cachePatch("FORCHDP")	
			local p_fbost	 = v.cachePatch("FORCBST")
			local boosttilt  = 0
			posx = 130
			if G_RingSlingerGametype()
				posy = 155
			else
				posy = 170
			end
			
			v.draw(posx, posy, p_fendseg, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
			posx = $1 - 1
			-- Step through backwards, to match the way we're drawing.
			for i = boostcap, 1, -1
					if boostfill >= i
						if player.boostmeter >= 117
							if not (player.powers[pw_super])
							and not (player.mysticsuper)
								if player.rushmode
									if leveltime % 2 == 0
										v.draw(posx, posy, p_fonseg, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS, v.getColormap("SKINCOLOR_WAVE", player.mo.color))
									else
										v.draw(posx, posy, p_fonseg, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS, v.getColormap("SKINCOLOR_WAVE", player.rushcolor))
									end
								else
									v.draw(posx, posy, p_fonseg,V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS, v.getColormap("SKINCOLOR_YELLOW", SKINCOLOR_WAVE))
								end
							else
								v.draw(posx, posy, p_fonseg, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS, v.getColormap("SKINCOLOR_YELLOW", ((player.powers[pw_super] > 0 and player.powers[pw_super] < 2) and SKINCOLOR_SUPERSUNBEAM4 or player.mo.color)))
							end
						else
							v.draw(posx, posy, p_fonseg,V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS, v.getColormap("SKINCOLOR_YELLOW", SKINCOLOR_WAVE))
						end
					else
                        v.draw(posx, posy, p_foffseg, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
						
					end
					posx = $1 - 1;
			end
			-- Start segment
			v.draw(posx, posy, p_fstartseg, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS, v.getColormap("SKINCOLOR_YELLOW", ((player.powers[pw_super] > 0 and player.powers[pw_super] < 2) and SKINCOLOR_SUPERSUNBEAM4 or player.mo.color)));
			
			
			local rushcolor = (leveltime % 2 == 0) and player.rushcolor or player.mo.color
			if player.rushmode
				local fslrpatch = (((player.rushmode/25) + 1) >= 10) and "RRUSHF" or "RRUSHF0"
				local fslrcache = v.cachePatch(fslrpatch..tostring((player.rushmode/25) + 1))
				v.draw(3, posy-4, fslrcache, V_10TRANS|V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT, rushcolor))
			else
				if player.speed
					local speedvalue = (abs(player.speed) >= 56*FU) and 14 or ((abs(player.speed)/(4*FU)) + 1)
					local speedpatch = ( speedvalue >= 10) and "SPEEDF" or "SPEEDF0"
					local speedcache = v.cachePatch(speedpatch..tostring(speedvalue))
					v.draw(3, posy-4, speedcache, V_10TRANS|V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
				end
			end
			
			if player.boosting == true
			or (player.airboost == true and player.airboostheld == true)
			and player.cmd.buttons & BT_CUSTOM1
			or player.superboost == true
			or player.minecartboost == true
				if player.boostmeter >= 70
					boosttilt = 2
				elseif player.boostmeter >= 40
					boosttilt = 1
				else
					boosttilt = 0
				end
				local boostcolor = player.rushmode and (rushcolor) or SKINCOLOR_SAPPHIRE 
				local dumby = (leveltime % 2 == 0) and 8*FU or 10*FU
				local dumbscale = (leveltime % 2 == 0) and (3*FU)/4 or (18*FU)/20
				v.drawScaled(posx*FRACUNIT+boostfill*FRACUNIT+FRACUNIT, (posy-boosttilt)*FRACUNIT-dumby, dumbscale, p_fbost, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT, boostcolor))
			end
			if player.rushmode
				v.draw(posx-1, posy, v.cachePatch("FRUSH"), V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_PERPLAYER|V_HUDTRANS)
			end
			if not (gamemap >= 60 and gamemap <= 66)
			and not (G_RingSlingerGametype())
				--Ring
					v.drawScaled((0*FRACUNIT), (0*FRACUNIT), FRACUNIT, p_fring, V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap("SKINCOLOR_YELLOW", ((player.powers[pw_super] > 0 and player.powers[pw_super] < 2) and SKINCOLOR_SUPERSUNBEAM4 or player.mo.color)))
					if player.rings < 10
						DrawMotdString(v, 85*FRACUNIT+28, 7*FRACUNIT, FRACUNIT, player.rings, "FORCHD1", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					elseif player.rings < 100
						DrawMotdString(v, 78*FRACUNIT+28, 7*FRACUNIT, FRACUNIT, player.rings, "FORCHD1", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					elseif player.rings < 1000
						DrawMotdString(v, 67*FRACUNIT+28, 7*FRACUNIT, FRACUNIT, player.rings, "FORCHD1", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					else
						DrawMotdString(v, 56*FRACUNIT+28, 7*FRACUNIT, FRACUNIT, player.rings, "FORCHD1", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					end
					
					
					
				--Life
					if (moderninflife.value == 0 and multiplayer)
					or player.lives == INFLIVES
					
					else	
						local icontodraw = player.powers[pw_super] and v.cachePatch("FLIFE2") or v.cachePatch("FLIFE1")
						v.drawScaled((255*FRACUNIT), (5*FRACUNIT), 3*FRACUNIT/4, icontodraw, V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT, ((player.powers[pw_super] > 0 and player.powers[pw_super] < 2) and SKINCOLOR_SUPERSUNBEAM4 or player.mo.color)))
						if player.lives < 10
							DrawMotdString(v, 292*FRACUNIT, 12*FRACUNIT, FRACUNIT, player.lives, "FORCHD2", V_SNAPTOTOP|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS)
							DrawMotdString(v, 285*FRACUNIT, 12*FRACUNIT, FRACUNIT, "0", "FORCHD2", V_SNAPTOTOP|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS)
						else
							DrawMotdString(v, 282*FRACUNIT, 12*FRACUNIT, FRACUNIT, player.lives, "FORCHD2", V_SNAPTOTOP|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS)
						end
					end
					
				--Time
					v.drawScaled((13*FRACUNIT), (33*FRACUNIT), FRACUNIT, p_ftime, V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
					local minutes = min(99, G_TicsToMinutes(player.realtime))
					if G_TicsToMinutes(player.realtime) < 10
						//v.drawString(14, 41, "0", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
						//v.drawString(22, 41, minutes, V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
						DrawMotdString(v, 58*FRACUNIT, 33*FRACUNIT, FRACUNIT, "0", "FORCHD2", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
						DrawMotdString(v, 65*FRACUNIT, 33*FRACUNIT, FRACUNIT, minutes, "FORCHD2", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					else
						DrawMotdString(v, 58*FRACUNIT, 33*FRACUNIT, FRACUNIT, minutes, "FORCHD2", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					end
					if G_TicsToSeconds(player.realtime) < 10
						DrawMotdString(v, 78*FRACUNIT, 33*FRACUNIT, FRACUNIT, "0", "FORCHD2", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
						DrawMotdString(v, 85*FRACUNIT, 33*FRACUNIT, FRACUNIT, G_TicsToSeconds(player.realtime), "FORCHD2", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					else
						DrawMotdString(v, 78*FRACUNIT, 33*FRACUNIT, FRACUNIT, G_TicsToSeconds(player.realtime), "FORCHD2", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					end
					if G_TicsToCentiseconds(player.realtime) < 10
						DrawMotdString(v, 98*FRACUNIT, 33*FRACUNIT, FRACUNIT, "0", "FORCHD2", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
						DrawMotdString(v, 105*FRACUNIT, 33*FRACUNIT, FRACUNIT, G_TicsToCentiseconds(player.realtime), "FORCHD2", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					else
						DrawMotdString(v, 98*FRACUNIT, 33*FRACUNIT, FRACUNIT, G_TicsToCentiseconds(player.realtime), "FORCHD2", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					end
					v.drawScaled(73*FRACUNIT, 34*FRACUNIT, FRACUNIT, p_fcolon, V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					v.drawScaled(93*FRACUNIT, 38*FRACUNIT, FRACUNIT, p_fperiod, V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
				--Score
					v.drawScaled((12*FRACUNIT), (53*FRACUNIT), FRACUNIT, p_fscore, V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)

					local pscore = player.score
					local offx = 112*FRACUNIT
					local zerocount = 1
					
					while (pscore > 0) do
						pscore = $ / 10
						offx = $ - 7*FRACUNIT
						if (zerocount == 1) then offx = $ + FRACUNIT end --tiny little offset hack
						zerocount = $ - 1
					end
					
					local zstring = "0"
					DrawMotdString(v, 105*FRACUNIT, 53*FRACUNIT, FRACUNIT, zstring:sub(1,zerocount), "FORCHD2", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					//v.drawString(1, 71, zstring:sub(1,zerocount),  V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					if (player.score) then
						DrawMotdString(v, offx, 53*FRACUNIT, FRACUNIT, player.score, "FORCHD2", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
						//v.drawString(offx, 71, player.score, V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					end
			end
		end
	end
hud.add(forceshud)
//Colors
local function colorshud(v, player)
	client = player
	if player.cleartimer and player.cleartimer >= 1
		return
	end
	local moderninflife = CV_FindVar("cooplives")
		if player.mo and player.mo.skin == "modernsonic"
        and not (player.powers[pw_carry] == CR_NIGHTSMODE)
		and (player.modernmenu.contents[3][1].value == 3 -- HUDStyle
		or player.modernmenu.contents[3][1].value == 9) -- HUDStyle
			//Boost Meter
		    local boostfill = 0;
			local boostcap = 0;
			local boostdrain = 0;
			if player.boostmeter == nil
				return
			end
			boostcap = $1 + 117
            boostfill = $1 + player.boostmeter
			boostdrain = $1 + player.boostmeter+1
			//Rush Meter
			local rushfill = 0;
			local rushcap = 0;
			local rushdrain = 0;
			if player.rushmode == nil
				return
			end
			rushcap = $1 + 10*TICRATE
            rushfill = $1 + player.rushmode
			rushdrain = $1 + player.rushmode+1
 
			local p_cstartseg = v.cachePatch("CMTRENDL")
			local p_cstartseg2 = v.cachePatch("CMTRSS")
			local p_cstartrush = v.cachePatch("CMTRENDS")
			local p_conseg    = v.cachePatch("CMTRMIDL")
			local p_conseg2    = v.cachePatch("CMTRMIDS")
			local p_coffseg   = v.cachePatch("CMTRMPTY")
			local p_coffseg2   = v.cachePatch("CMTRMPTS")
			local p_cendseg   = v.cachePatch("CMTRENDR")
			local p_clife    = v.cachePatch("CLIFE")
			local p_clifes    = v.cachePatch("CLIFES")
			local p_cscore    = v.cachePatch("CSCORE")
			local p_cring    = v.cachePatch("CRING")
			local p_ctime    = v.cachePatch("CTIME")
			local p_ccolon	 = v.cachePatch("COLRHDS")	
			local p_cperiod	 = v.cachePatch("COLRHDP")	
			local p_cbost	 = v.cachePatch("COLRBST")
			local p_cemerald1	 = v.cachePatch("CEMERLD1")
			local p_cemerald2	 = v.cachePatch("CEMERLD2")
			local p_cemerald3	 = v.cachePatch("CEMERLD3")
			local p_cemerald4	 = v.cachePatch("CEMERLD4")
			local p_cemerald5	 = v.cachePatch("CEMERLD5")
			
			local frc1shield = v.cachePatch("CHSHFRC2")
			local frc2shield = v.cachePatch("CHSHFRC1")
			local pinkshield = v.cachePatch("CHSHEART")
			local magnshield = v.cachePatch("CHSHMAGT")
			local armashield = v.cachePatch("CHSHARMA")
			local elemshield = v.cachePatch("CHSHELEM")
			local windshield = v.cachePatch("CHSHWIND")
			local bubbshield = v.cachePatch("CHSHBUBL")
			local flmeshield = v.cachePatch("CHSHFIRE")
			local lgtnshield = v.cachePatch("CHSHTHDR")
			local pityshield = v.cachePatch("CHSHPITY")
			local sorrynothing = v.cachePatch("NOTHING")
			local freshnikes = v.cachePatch("CHSHSHOE")
			local invinsparkles = v.cachePatch("CHSHSPKL")
			
			local shieldinuse = {
				[SH_WHIRLWIND] = windshield,
				[SH_ELEMENTAL] = elemshield,
				[SH_FLAMEAURA] = flmeshield,
				[SH_BUBBLEWRAP] = bubbshield,
				[SH_THUNDERCOIN] = lgtnshield,
				[SH_ARMAGEDDON] = armashield,
				[SH_PINK] = pinkshield,
				[SH_ATTRACT] = magnshield,
				[SH_PITY] = pityshield,
				[SH_NONE] = sorrynothing
			}
			
			for i = 1, #modernSonicCustomShields
				shieldinuse[modernSonicCustomShields[i].shieldName] = v.cachePatch(modernSonicCustomShields[i].colorsPatch)
			end
			
			
			local superwhy = ((All7Emeralds(emeralds)) and (player.rings >= 50 or player.powers[pw_super]))
			local shieldpatch = ((superwhy) or (player.powers[pw_shield])) and p_cstartseg2 or p_cstartseg
			local forceshieldisstupid = (player.powers[pw_shield]&SH_FORCEHP) and frc1shield or frc2shield
			local nikes = (superwhy) and sorrynothing or ((player.powers[pw_sneakers]) and freshnikes or sorrynothing)
			local inv = (superwhy) and sorrynothing or ((player.powers[pw_invulnerability]) and invinsparkles or sorrynothing)
			local shield = player.powers[pw_shield]
			local emerald = p_cemerald1
			
			
			local animationXY_RUSH = {
				{-4,-3},
				{-3,-3},
				{-2,-1},
				{-2,-2},
				{0,0},
				{0,0},
				{0,0},
				{-1,-1},
				{-1,-1},
				{1,1},
				{0,0},
				{0,0},
				{-1,-1},
				{0,0},
				{0,0},
				{0,0}
			}
			local fr = animationXY_RUSH[((leveltime%#animationXY_RUSH)+1)]
			
			local animationXY_WISP = {
				{-1,-1},
				{-1,-1},
				{1,-1},
				{1,-1},
				{1,1},
				{1,1},
				{-1,1},
				{-1,1}
			}
			local fw = ((player.airboost and (player.boostheld)) or player.boosting) and animationXY_WISP[((leveltime%#animationXY_WISP)+1)] or {0,0}
			
			local animationXY_BOOST = {
				{-4,-3},
				{-3,-2},
				{0,1},
				{-2,-1},
				{-1,0},
				{-1,0},
				{-1,0},
				{-1,0},
				{-1,0}
			}
			local fb = ((player.airboost and (player.boostheld)) or player.boosting) and animationXY_BOOST[((leveltime%#animationXY_BOOST)+1)] or {-1,0}
			
			
			if player.powers[pw_super] --tod: shorten this lmao
				if player.flashingtimer >= 8 and player.flashingtimer <= 9
					emerald = p_cemerald5
				elseif player.flashingtimer >= 6 and player.flashingtimer <= 7
				or player.flashingtimer >= 10 and player.flashingtimer <= 11
					emerald = p_cemerald4
				elseif player.flashingtimer >= 4 and player.flashingtimer <= 5
				or player.flashingtimer >= 12 and player.flashingtimer <= 13
					emerald = p_cemerald3
				elseif player.flashingtimer >= 2 and player.flashingtimer <= 3
				or player.flashingtimer >= 14 and player.flashingtimer <= 15
					emerald = p_cemerald2
				elseif player.flashingtimer >= 0 and player.flashingtimer <= 1
					emerald = p_cemerald1
				end
			end
			
			local getshieldpatch = (shield & SH_FORCE) and forceshieldisstupid or shieldinuse[shield&SH_NOSTACK]
			local superpriority = (superwhy) and emerald or getshieldpatch
			
			if not getshieldpatch
				getshieldpatch = sorrynothing --lil failsafe for invalid shields!!
			end
			if not superpriority
				superpriority = sorrynothing
			end
			
			
			//Without Rush
			posx = 170
			if G_RingSlingerGametype()
				posy = 160
			else
				posy = 170
			end
			
			posx = $1 - (boostcap+1)
			
			-- Step through backwards, to match the way we're drawing.
			
			local color = (player.rushmode) and v.getColormap(TC_RAINBOW, SKINCOLOR_RASPBERRY) or nil
			local fuck = (shieldpatch == p_cstartseg2) and 5 or 0
			v.drawStretched((fb[1]+fuck+1+posx)*FU, (fb[2]+posy)*FU, 88*FU,FU, p_coffseg, BLF|HTF)
			v.drawStretched((fb[1]+fuck+1+posx)*FU, (fb[2]+posy)*FU, abs((FU*boostfill)/boostcap)*88,FU, p_conseg, BLF|HTF, color)
											
			//With Rush
			if player.rushmode
				posx2 = 57
				if G_RingSlingerGametype()
					posy2 = 143
				else
					posy2 = 153
				end
				local tempX = posx2
				if shieldpatch == p_cstartseg2
					tempX = $ + 3
				end
				local rushcolor = (leveltime % 2 == 0) and player.rushcolor or player.mo.color
				v.drawStretched((fr[1]+tempX)*FU, (fr[2]+posy2)*FU, 58*FU,FU, p_coffseg2, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
				v.drawStretched((fr[1]+tempX)*FU, (fr[2]+posy2)*FU, ((FU*rushfill)/rushcap)*58,FU, p_conseg2, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT, rushcolor))
			end
			
			-- Start segment 
			if player.rushmode
				local tempX = posx
				local fuckYou = colorsUltimate[1]
				if colorsUltimate[1]
					tempX = $ - 1
				end
				if shieldpatch == p_cstartseg2
					tempX = $ + 3
				end
				v.draw(tempX+fr[1], posy+fr[2], p_cstartrush, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS);
			end
			if true
				local tempX = posx
				local fuckYou = colorsUltimate[1]
				if colorsUltimate[1]
					tempX = $ - 1
				end
				if shieldpatch == p_cstartseg2
					tempX = $ + 5
				end
				v.draw(tempX+fb[1], posy+fb[2], v.cachePatch('CMTRBR'), V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
			end
			
			local patches = {shieldpatch, superpriority, nikes, inv}
			local invend = (player.powers[pw_invulnerability] <= 3*TICRATE and player.powers[pw_invulnerability] and leveltime % 2 == 0) 
            local shoeend = (player.powers[pw_sneakers] <= 3*TICRATE and player.powers[pw_sneakers] and leveltime % 2 == 0)            
            for i = 1, 4
				local tempX = posx
				local tempY = posy
				local fuckYou = colorsUltimate[1]
				if i == 1
				and colorsUltimate[1]
					tempX = $ - 1
				elseif i > 1
					tempX = $ - 41
					tempY = $ - 25
				end
                local flasher = ((patches[i] == invinsparkles and invend) or (patches[i] == freshnikes and shoeend)) and V_90TRANS or V_HUDTRANS
                v.draw(tempX+fw[1], tempY+fw[2], patches[i], V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|flasher);
            end
				
			if not (gamemap >= 60 and gamemap <= 66)
			and not (G_RingSlingerGametype())
				--Ring
					v.drawScaled((17*FRACUNIT), (20*FRACUNIT), FRACUNIT, p_cring, V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
					extendedSporkString(v, 52*FU, 8*FU, 29*FU, FU, 4, player.rings, "COLRHD", "0", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					
				--Life
					local lifetodraw = (player.powers[pw_super]) and p_clifes or p_clife
					v.drawScaled((17*FRACUNIT), (3*FRACUNIT), FRACUNIT, lifetodraw, V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT, ((player.powers[pw_super] > 0 and player.powers[pw_super] < 2) and SKINCOLOR_SUPERSUNBEAM4 or player.mo.color)))
					if (moderninflife.value == 0 and multiplayer)
					or player.lives == INFLIVES
						v.drawScaled((50*FRACUNIT), (25*FRACUNIT/2), FRACUNIT, v.cachePatch("COLRHDI"), V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
					else
						extendedSporkString(v, 52*FU, 8*FU, 12*FU, FU, 2, player.lives, "COLRHD", "0", TLF|HTF)
					end
					
				--Time
					v.drawScaled((17*FRACUNIT), (36*FRACUNIT), FRACUNIT, p_ctime, TLF|HTF)
					local timers = {min(99, G_TicsToMinutes(player.realtime)), G_TicsToSeconds(player.realtime), G_TicsToCentiseconds(player.realtime)}
					local timerOffsets = {52,72,92}
					local theOffset
					for i =  1, 3
						theOffset = timerOffsets[i]*FU
						if timers[i] < 10
							DrawMotdString(v, theOffset, 46*FRACUNIT, FRACUNIT, "0", "COLRHD", TLF|HTF)
							theOffset = $ + 8*FU
						end
						DrawMotdString(v, theOffset, 46*FRACUNIT, FRACUNIT, timers[i], "COLRHD", TLF|HTF)
					end
					v.drawScaled(68*FRACUNIT, 47*FRACUNIT, FRACUNIT, p_ccolon, TLF|HTF)
					v.drawScaled(87*FRACUNIT, 51*FRACUNIT, FRACUNIT, p_cperiod, TLF|HTF)
				--Score
					v.drawScaled((240*FRACUNIT), (14*FRACUNIT), FRACUNIT, p_cscore, TRF|HTF)
					extendedSporkString(v, 242*FU, 8*FU, 28*FU, FU, 8, player.score, "COLRHD", "0", TRF|HTF)
			end
		end
	end
hud.add(colorshud)
//06
local function nextgenhud(v, player)
	client = player
	if player.cleartimer and player.cleartimer >= 1
		return
	end
	local moderninflife = CV_FindVar("cooplives")
		if player.mo and player.mo.skin == "modernsonic"
        and not (player.powers[pw_carry] == CR_NIGHTSMODE)
		and (player.modernmenu.contents[3][1].value == 4 -- HUDStyle
		or player.modernmenu.contents[3][1].value == 9) -- HUDStyle
		    local boostfill = 0;
			local boostcap = 0;
			local boostdrain = 0;
			if player.boostmeter == nil
				return
			end
			boostcap = $1 + 117
            boostfill = $1 + player.boostmeter
			boostdrain = $1 + player.boostmeter+1
 
			local p_nstartseg = v.cachePatch("NMTRENDL")
			local p_nonseg    = v.cachePatch("NMTRMIDL")
			local p_noffseg   = v.cachePatch("NMTRMPTY")
			local p_nendseg   = v.cachePatch("NMTRENDR")
			local p_nlifen    = v.cachePatch("NLIFEN")
			local p_nlifes    = v.cachePatch("NLIFES")
			local p_nscore    = v.cachePatch("NSCORE")
			local p_nring    = v.cachePatch("NRING")
			local p_ntime    = v.cachePatch("NTIME")
			local p_ncolon	 = v.cachePatch("NGENHDS")	
			local p_nperiod	 = v.cachePatch("NGENHDP")	
			local p_nbost	 = v.cachePatch("NGENBST")
			local p_ngem	 = v.cachePatch("NGEM")
			
			local frc1shield = v.cachePatch("NSHFRC1")
			local frc2shield = v.cachePatch("NSHFRC2")
			local armashield = v.cachePatch("NSHARMA")
			local magnshield = v.cachePatch("NSHMAGN")
			local elemshield = v.cachePatch("NSHELEM")
			local windshield = v.cachePatch("NSHWIND")
			local pityshield = v.cachePatch("NSHPITY")
			local pinkshield = v.cachePatch("NSHAMYS")
			local bubbshield = v.cachePatch("NSHBUBB")
			local flmeshield = v.cachePatch("NSHFLME")
			local lgtnshield = v.cachePatch("NSHLGTN")
			local sorrynothing = v.cachePatch("NOTHING")
			
			local shieldinuse = {
				[SH_WHIRLWIND] = windshield,
				[SH_ELEMENTAL] = elemshield,
				[SH_FLAMEAURA] = flmeshield,
				[SH_BUBBLEWRAP] = bubbshield,
				[SH_THUNDERCOIN] = lgtnshield,
				[SH_ARMAGEDDON] = armashield,
				[SH_PINK] = pinkshield,
				[SH_ATTRACT] = magnshield,
				[SH_PITY] = pityshield,
				[SH_NONE] = sorrynothing
			}
			
			for i = 1, #modernSonicCustomShields
				shieldinuse[modernSonicCustomShields[i].shieldName] = v.cachePatch(modernSonicCustomShields[i].gens06Patch)
			end
			
			local forceshieldisstupid = (player.powers[pw_shield]&SH_FORCEHP) and frc1shield or frc2shield
			local shield = player.powers[pw_shield]
			local getshieldpatch = (shield & SH_FORCE) and forceshieldisstupid or shieldinuse[shield&SH_NOSTACK]
			
			if not getshieldpatch
				getshieldpatch = sorrynothing --lil failsafe for invalid shields!!
			end
			
			posx = 130
			if G_RingSlingerGametype()
				posy = 155
			else
				posy = 174 
			end
			
			v.draw(posx, posy, p_nendseg, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
			posx = $1 - 1
			v.draw(posx, posy, p_nstartseg, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS)
			v.drawScaled((285*FU), (159*FU), FRACUNIT*9/10, getshieldpatch, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_BLINK, SKINCOLOR_BLACK))
			v.drawScaled((284*FU), (158*FU), FRACUNIT*9/10, getshieldpatch, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS);
			
			if player.rushmode
				local rushcolor = (leveltime % 2 == 0) and player.rushcolor or player.mo.color
				v.drawScaled(291*FRACUNIT, 185*FRACUNIT, FRACUNIT, p_ngem, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT, rushcolor))
				if player.rushmode > 3*TICRATE
					v.drawScaled(297*FRACUNIT, 185*FRACUNIT, FRACUNIT, p_ngem, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT, rushcolor))
				end
				if player.rushmode > 6*TICRATE
					v.drawScaled(303*FRACUNIT, 185*FRACUNIT, FRACUNIT, p_ngem, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS, v.getColormap(TC_DEFAULT, rushcolor))
				end
			end
			
			-- Step through backwards, to match the way we're drawing.
			for i = boostcap, 1, -1
					if boostfill >= i
						if player.boostmeter >= 117
							if not (player.powers[pw_super])
							and not (player.mysticsuper)
								if leveltime % 2 == 0
									v.draw(posx, posy, p_nonseg, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS, v.getColormap("SKINCOLOR_WAVE", ((player.powers[pw_super] > 0 and player.powers[pw_super] < 2) and SKINCOLOR_SUPERSUNBEAM4 or player.mo.color)))
								else
									v.draw(posx, posy, p_nonseg, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS, v.getColormap("SKINCOLOR_WAVE", player.rushcolor))
								end
							else
								v.draw(posx, posy, p_nonseg, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS, v.getColormap("SKINCOLOR_YELLOW", ((player.powers[pw_super] > 0 and player.powers[pw_super] < 2) and SKINCOLOR_SUPERSUNBEAM4 or player.mo.color)))
							end
						else
							v.draw(posx, posy, p_nonseg,V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS, v.getColormap("SKINCOLOR_YELLOW", SKINCOLOR_SKY))
						end
					else
                        v.draw(posx, posy, p_noffseg, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER|V_HUDTRANS)
						
					end
					posx = $1 - 1;
			end
			-- Start segment
		//	v.draw(posx, posy, p_nstartseg, V_SNAPTOBOTTOM|V_SNAPTORIGHT|V_PERPLAYER);
			if not (gamemap >= 60 and gamemap <= 66)
			and not (G_RingSlingerGametype())
				--Ring
					v.drawScaled((0*FRACUNIT), (38*FRACUNIT), FRACUNIT/2, p_nring, V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
					if player.rings < 10
						DrawMotdString(v, 53*FRACUNIT, 44*FRACUNIT, FRACUNIT/2, "0", "NGENHD", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
						DrawMotdString(v, 60*FRACUNIT, 44*FRACUNIT, FRACUNIT/2, "0", "NGENHD", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
						DrawMotdString(v, 67*FRACUNIT, 44*FRACUNIT, FRACUNIT/2, player.rings, "NGENHD", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					elseif player.rings < 100
						DrawMotdString(v, 53*FRACUNIT, 44*FRACUNIT, FRACUNIT/2, "0", "NGENHD", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
						DrawMotdString(v, 60*FRACUNIT, 44*FRACUNIT, FRACUNIT/2, player.rings, "NGENHD", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					else
						DrawMotdString(v, 53*FRACUNIT, 44*FRACUNIT, FRACUNIT/2, player.rings, "NGENHD", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					end
					
					
				--Life
					local lifetodraw = player.powers[pw_super] and p_nlifes or p_nlifen
					v.drawScaled((0*FRACUNIT), (56*FRACUNIT), FRACUNIT/2, lifetodraw, V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap("SKINCOLOR_NONE", ((player.powers[pw_super] > 0 and player.powers[pw_super] < 2) and SKINCOLOR_SUPERSUNBEAM4 or player.mo.color)))
					if (moderninflife.value == 0 and multiplayer)
					or player.lives == INFLIVES
						v.drawScaled((60*FRACUNIT), (62*FRACUNIT), FRACUNIT/2, v.cachePatch("NGENHDI"), V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
					else
						if player.lives < 10
							DrawMotdString(v, 67*FRACUNIT, 62*FRACUNIT, FRACUNIT/2, player.lives, "NGENHD", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
							DrawMotdString(v, 60*FRACUNIT, 62*FRACUNIT, FRACUNIT/2, "0", "NGENHD", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
						else
							DrawMotdString(v, 60*FRACUNIT, 62*FRACUNIT, FRACUNIT/2, player.lives, "NGENHD", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
						end
					end
				--Time
					v.drawScaled((0*FRACUNIT), (23*FRACUNIT), FRACUNIT/2, p_ntime, V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
					local minutes = min(99, G_TicsToMinutes(player.realtime))
					if G_TicsToMinutes(player.realtime) < 10
						//v.drawString(14, 41, "0", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
						//v.drawString(22, 41, minutes, V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
						DrawMotdString(v, 45*FRACUNIT, 27*FRACUNIT, FRACUNIT/2, "0", "NGENHD", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
						DrawMotdString(v, 52*FRACUNIT, 27*FRACUNIT, FRACUNIT/2, minutes, "NGENHD", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					else
						DrawMotdString(v, 45*FRACUNIT, 27*FRACUNIT, FRACUNIT/2, minutes, "NGENHD", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					end
					if G_TicsToSeconds(player.realtime) < 10
						DrawMotdString(v, 65*FRACUNIT, 27*FRACUNIT, FRACUNIT/2, "0", "NGENHD", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
						DrawMotdString(v, 72*FRACUNIT, 27*FRACUNIT, FRACUNIT/2, G_TicsToSeconds(player.realtime), "NGENHD", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					else
						DrawMotdString(v, 65*FRACUNIT, 27*FRACUNIT, FRACUNIT/2, G_TicsToSeconds(player.realtime), "NGENHD", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					end
					if G_TicsToCentiseconds(player.realtime) < 10
						DrawMotdString(v, 87*FRACUNIT, 27*FRACUNIT, FRACUNIT/2, "0", "NGENHD", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
						DrawMotdString(v, 94*FRACUNIT, 27*FRACUNIT, FRACUNIT/2, G_TicsToCentiseconds(player.realtime), "NGENHD", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					else
						DrawMotdString(v, 87*FRACUNIT, 27*FRACUNIT, FRACUNIT/2, G_TicsToCentiseconds(player.realtime), "NGENHD", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					end
					v.drawScaled(60*FRACUNIT, 27*FRACUNIT, FRACUNIT/2, p_ncolon, V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					v.drawScaled(79*FRACUNIT, 27*FRACUNIT, FRACUNIT/2, p_nperiod, V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					
				--Score
					v.drawScaled((0*FRACUNIT), (5*FRACUNIT), FRACUNIT/2, p_nscore, V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
					local pscore = player.score
					local offx = 101*FRACUNIT
					local zerocount = 1
					
					while (pscore > 0) do
						pscore = $ / 10
						offx = $ - 7*FRACUNIT
						if (zerocount == 1) then offx = $ + FRACUNIT end --tiny little offset hack
						zerocount = $ - 1
					end
					
					local zstring = "0"
					DrawMotdString(v, 93*FRACUNIT, 9*FRACUNIT, FRACUNIT/2, zstring:sub(1,zerocount), "NGENHD", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					//v.drawString(1, 71, zstring:sub(1,zerocount),  V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					if (player.score) then
						DrawMotdString(v, offx, 9*FRACUNIT, FRACUNIT/2, player.score, "NGENHD", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
						//v.drawString(offx, 71, player.score, V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					end
			end
		end
	end
hud.add(nextgenhud)

//rush

addHook("ThinkFrame", function() -- TEMPORARY, MERGE TO MAIN LATER
	for p in players.iterate
		if p.mo and p.mo.valid
			local newBoostMeter = max(0,((p.boostmeter*FU)/117)*60/FU) --interpolation i think
			if not p.mo.rushBoostTable
				p.mo.rushBoostTable = {
					{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}, --blue
					{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}, --yellow
					{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0} --red
				}
				p.mo.prevRushBoostMeter = 0
			end
			for i = 1,3
				for j = 1, 20
					if p.mo.rushBoostTable[i][j]>=1
						p.mo.rushBoostTable[i][j] = max(1,$-1)
					end
				end
			end
			local boostPhase = (newBoostMeter-1)/20
			
			p.mo.rushBoostStep = $ or 0
			if newBoostMeter != p.mo.prevRushBoostMeter
				p.mo.rushBoostStep = $ + (newBoostMeter - p.mo.prevRushBoostMeter)
			end
			
			if p.mo.rushBoostStep
				--print(p.mo.rushBoostStep)
				local getPolarity = p.mo.rushBoostStep/(abs(p.mo.rushBoostStep)*-1)
				p.mo.rushBoostStep = $ + getPolarity
				
				local rushDest = (newBoostMeter-p.mo.rushBoostStep)
				--print(rushDest)
				
				rushDest = $ + max(0, getPolarity)
				local interpPhase = (rushDest-1)/20
				--print(interpPhase)
				p.mo.rushBoostTable[interpPhase+1][rushDest-(20*interpPhase)] = (getPolarity==-1) and ($ or 4) or 0 
			end
			
			p.mo.prevRushBoostMeter = newBoostMeter
			
			--RUSH TOKEN
			p.mo.rushModePhase = (({4, 3, 1})[min(3,(p.rushmode/116)+1)])
			local rushRings2 = {
				/*{base frame, 
					{ --animation starts
						frames to stall for
					}
				  }
					
					EG:
					{'A', --use the A frames
						{
							4, --frame 1 takes 4 tics to advance
							3, --frame 2 takes 3 tics to advance
							3  --frame 3 takes 3 tics to loop
						}
					}
				*/
				{'N',{1}},--phase 1 (none)
				{'A',{4,3,3}},--phase 2 (blue)
				{'B',{4,3,3,3,3,3}},--phase 3 (yellow)
				{'C',{p.mo.rushModePhase,p.mo.rushModePhase,p.mo.rushModePhase,p.mo.rushModePhase,p.mo.rushModePhase,p.mo.rushModePhase}}--rush mode (red)
			}
			
			p.mo.rushBoostPhase = (newBoostMeter/20)+1
			p.mo.rushFrameTimer = $ and $+1 or 1
			p.mo.rushDisplayFrame = $ or 1
			
			if p.mo.rushBoostPhase != p.mo.prevRushBoostPhase
			or p.mo.rushModePhase != p.mo.prevRushModePhase
				p.mo.rushFrameTimer = 0
				if p.mo.rushBoostPhase != p.mo.prevRushBoostPhase
					p.mo.rushDisplayFrame = 1
				end
			end
			if p.mo.rushFrameTimer == rushRings2[p.mo.rushBoostPhase][2][p.mo.rushDisplayFrame]
				p.mo.rushFrameTimer = 0
				p.mo.rushDisplayFrame = ($==#rushRings2[p.mo.rushBoostPhase][2]) and 1 or ($ + 1)
			end
			p.mo.curRushFrame = tostring(rushRings2[p.mo.rushBoostPhase][1])..tostring(p.mo.rushDisplayFrame)
			--hijack time LOL
			if p.powers[pw_super]
				if (((p.airboost or p.superboost) and (p.boostheld)) or p.boosting)
					p.mo.curRushFrame = 'C'..((leveltime%6)+1)
					p.mo.superBoostTimer = $ and $-1 or 20
					p.mo.rushBoostTable[3][p.mo.superBoostTimer] = 4
				else
					p.mo.curRushFrame = "C1"
					p.mo.superBoostTimer = 20
				end
			end
			
			p.mo.prevRushBoostPhase = p.mo.rushBoostPhase
			p.mo.prevRushModePhase = p.mo.rushModePhase
		end
	end
end)
-- lord fucking help me, i dont wanna tweak or fix any of this shit
local function rushhud(v, player)
	client = player
	if player.cleartimer and player.cleartimer >= 1
		return
	end
	local moderninflife = CV_FindVar("cooplives")
	if player.mo and player.mo.skin == "modernsonic"
	and not (player.powers[pw_carry] == CR_NIGHTSMODE)
	and (player.modernmenu.contents[3][1].value == 5 -- HUDStyle
	or player.modernmenu.contents[3][1].value == 9) -- HUDStyle
		local newBoostMeter = max(0,((player.boostmeter*FU)/117)*60/FU)
		local boostPhase = (newBoostMeter-1)/20
		local getALife = (player.powers[pw_super]) and 'S' or 'N'
		
		v.draw(3, 177, v.cachePatch("RLIFE"..getALife), BLF|HTF, v.getColormap(TR_DRFAULT, player.mo.color))
		v.draw(3, 3, v.cachePatch("RRING"), TLF|HTF)
		local fuckLength = (player.rings >= 1000) and 17*FU or 23*FU
		extendedSporkString(v, fuckLength, 10*FU, 6*FU, FU, 3, player.rings, "RUSHHD", "0", TLF|HTF)
		if (moderninflife.value == 0 and multiplayer)
		or player.lives == INFLIVES
			v.draw(34, 182, v.cachePatch("RUSHHDI"), BLF|HTF)
		else
			extendedSporkString(v, 34*FU, 10*FU, 182*FU, FU, 1, player.lives, "RUSHHD", "0", BLF|HTF)
		end
		local lol = v.cachePatch("SRHBAR")
		local rushColors = {
			'CERULEAN',
			'YELLOW',
			player.rushmode and ((leveltime % 4)+1 > 2 and 'RED' or 'YELLOW') or 'RED'
		}
		for i = 1, 20
			for j = 3,0,-1
				if j==0
					v.draw(3+lol.leftoffset, 175-(6*i)+lol.topoffset, lol, BLF|HTF, v.getColormap(TR_DRFAULT, SKINCOLOR_WHITE))
				else
					if player.mo.rushBoostTable[max(1,j)][i]>0
						local theNum = player.mo.rushBoostTable[max(1,j)][i]
						local maybeUseSuperColor = player.powers[pw_super] and player.mo.color or _G['SKINCOLOR_'..rushColors[max(1,j)]]
						v.drawStretched((3+lol.leftoffset)*FU, (175-(6*i)+lol.topoffset)*FU, max(FU,(FU*theNum)/2),max(FU,(FU*theNum)/3), lol, BLF|HTF, v.getColormap(TR_DRFAULT, maybeUseSuperColor))
						break
					end
				end
			end
		end
		v.draw(5, 40, v.cachePatch('RSSTR'..player.mo.curRushFrame), BLF|HTF)
		
		v.draw(109, 2, v.cachePatch("RTIME"), V_SNAPTOTOP|HTF)
		local timers = {min(99, G_TicsToMinutes(player.realtime)), G_TicsToSeconds(player.realtime), G_TicsToCentiseconds(player.realtime)}
		local timerOffsets = {127,153,179}
		local theOffset
		for i =  1, 3
			theOffset = timerOffsets[i]*FU
			if timers[i] < 10
				DrawMotdString(v, theOffset, 4*FRACUNIT, FRACUNIT, "0", "RUSHHD", V_SNAPTOTOP|HTF)
				theOffset = $ + 10*FU
			end
			DrawMotdString(v, theOffset, 4*FRACUNIT, FRACUNIT, timers[i], "RUSHHD", V_SNAPTOTOP|HTF)
		end
		v.draw(148, 6, v.cachePatch("RUSHHDS"), V_SNAPTOTOP|HTF)
		v.draw(174, 6, v.cachePatch("RUSHHDS"), V_SNAPTOTOP|HTF)
		/*for i = 1,3
			for j = 1,20
				v.drawString(j*8, i*8, player.mo.rushBoostTable[i][j])
			end
		end*/
	end
end
hud.add(rushhud)
//SRB2
local function defaulthud(v, player)
	client = player
	if player.cleartimer and player.cleartimer >= 1
		return
	end
	local moderninflife = CV_FindVar("cooplives")
		if player.mo and player.mo.skin == "modernsonic"
        and not (player.powers[pw_carry] == CR_NIGHTSMODE)
		and (player.modernmenu.contents[3][1].value == 7 -- HUDStyle
		or player.modernmenu.contents[3][1].value == 9) -- HUDStyle
		    local boostfill = 0;
			local boostcap = 0;
			local boostdrain = 0;
			if player.boostmeter == nil
				return
			end
			boostcap = $1 + 117
            boostfill = $1 + player.boostmeter
			boostdrain = $1 + player.boostmeter+1
 
			local p_sstartseg = v.cachePatch("SMTRENDL")
			local p_sonseg    = v.cachePatch("SMTRMIDL")
			local p_soffseg   = v.cachePatch("SMTRMPTY")
			local p_sendseg   = v.cachePatch("SMTRENDR")
			posx = 135
			if G_RingSlingerGametype()
				posy = 160
			else
				posy = 170
			end
			
			v.draw(posx, posy, p_sendseg, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
			posx = $1 - 1
			-- Step through backwards, to match the way we're drawing.
			for i = boostcap, 1, -1
					if boostfill >= i
						if player.boostmeter >= 117
							if not (player.powers[pw_super])
							and not (player.mysticsuper)
								if leveltime & 2
									v.draw(posx, posy, p_sonseg, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS, v.getColormap("SKINCOLOR_WAVE", ((player.powers[pw_super] > 0 and player.powers[pw_super] < 2) and SKINCOLOR_SUPERSUNBEAM4 or player.mo.color)))
								else
									v.draw(posx, posy, p_sonseg, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS, v.getColormap("SKINCOLOR_WAVE", player.rushcolor))
								end
							else
								v.draw(posx, posy, p_sonseg, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS, v.getColormap("SKINCOLOR_YELLOW", ((player.powers[pw_super] > 0 and player.powers[pw_super] < 2) and SKINCOLOR_SUPERSUNBEAM4 or player.mo.color)))
							end
						else
							if (player.boosting == true or (player.airboost == true and player.boostheld == true))
							and (((player.cmd.buttons & BT_USE) and player.actionswap == true) or ((player.cmd.buttons & BT_CUSTOM1) and player.actionswap == false))
								if leveltime & 2
									v.draw(posx, posy, p_sonseg, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS, v.getColormap("SKINCOLOR_WAVE", SKINCOLOR_RED))
								else
									v.draw(posx, posy, p_sonseg, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS, v.getColormap("SKINCOLOR_WAVE", SKINCOLOR_BONE))
								end
							else
								v.draw(posx, posy, p_sonseg,V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS, v.getColormap("SKINCOLOR_YELLOW", SKINCOLOR_EMERALD))	
							end
						end
					else
                        v.draw(posx, posy, p_soffseg, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
						
					end
					posx = $1 - 1;
			end
			-- Start segment
			v.draw(posx, posy, p_sstartseg, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS); 
			
			local useFucker = player.mo.storedEnemyCombo and player.mo.HUDEnemyTimerFade or 10
			local posY = 100 + (player.mo.HUDEnemyTimerInit*4) + ((10-useFucker)*10)
			local posX = 10 + (player.mo.HUDEnemyTimer*4)
			if player.mo.enemyCombo
			or player.mo.storedEnemyCombo
				local shitCantDecideWhatToDraw = player.mo.enemyCombo or player.mo.storedEnemyCombo
				local transValue = 0
				if player.mo.enemyComboTimer
					local ohGodOhFuck = (leveltime%2) and V_REDMAP or V_ORANGEMAP
					v.drawString(posX, posY-20, (player.mo.enemyComboTimer-1).. '!!!', ohGodOhFuck)
				end
				if not player.mo.enemyCombo
					transValue = 10-player.mo.HUDEnemyTimerFade
				end
				
				local lolTransparency = adjustHUDTrans(v, transValue)
				if lolTransparency
				or lolTransparency == 0
					v.drawString(posX, posY, shitCantDecideWhatToDraw.. ' Combo!!', lolTransparency|4096*((shitCantDecideWhatToDraw%14)+1))
				end
			end
		end
	end
hud.add(defaulthud)

//SRB2Gens
local function shithud(v, player)
	client = player
	if player.cleartimer and player.cleartimer >= 1
		return
	end
	local moderninflife = CV_FindVar("cooplives")
		if player.mo and player.mo.skin == "modernsonic"
        and not (player.powers[pw_carry] == CR_NIGHTSMODE)
		and (player.modernmenu.contents[3][1].value == 6 -- HUDStyle
		or player.modernmenu.contents[3][1].value == 9) -- HUDStyle
			local p_gstartseg = v.cachePatch("BMTRENDL")
			local p_gstartsega = v.cachePatch("BMTRENDA")
			local p_gonseg    = v.cachePatch("BMTRMIDL")
			local p_goffseg   = v.cachePatch("BMTRMPTY")
			local p_glife    = v.cachePatch("BLIFE")
			local p_glife2   = v.cachePatch("BLIFE2")
			local p_gscore   = v.cachePatch("BSCORE")
			local p_gring    = v.cachePatch("BRING")
			local p_gring2    = v.cachePatch("BRING2")
			local p_gtime    = v.cachePatch("BTIME")
			local p_gcolon	 = v.cachePatch("BCOLON")	
			posx = 40
			if G_RingSlingerGametype()
				posy = 170
			else
				posy = 190 
			end
			
			-- Start segment
			v.draw(posx, posy, p_gstartseg, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS);
			if not (gamemap >= 60 and gamemap <= 66)
			and not (G_RingSlingerGametype())
				--Ring
					v.drawNum(58, 56, player.rings, V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					if player.rings == 0
						if leveltime & 2
							v.drawScaled((10*FRACUNIT), (53*FRACUNIT), 3*FRACUNIT/4, p_gring, V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
						else
							v.drawScaled((10*FRACUNIT), (53*FRACUNIT), 3*FRACUNIT/4, p_gring2, V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
						end
					else
						v.drawScaled((10*FRACUNIT), (53*FRACUNIT), 3*FRACUNIT/4, p_gring, V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
					end
				--Life
					v.drawScaled((270*FRACUNIT), (10*FRACUNIT), 3*FRACUNIT/4, p_glife, V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap("SKINCOLOR_NONE", ((player.powers[pw_super] > 0 and player.powers[pw_super] < 2) and SKINCOLOR_SUPERSUNBEAM4 or player.mo.color)))
					v.drawScaled((18*FRACUNIT), (180*FRACUNIT), FRACUNIT/2, p_glife2, V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER|V_HUDTRANS, v.getColormap("SKINCOLOR_NONE", ((player.powers[pw_super] > 0 and player.powers[pw_super] < 2) and SKINCOLOR_SUPERSUNBEAM4 or player.mo.color)))
					if (moderninflife.value == 0 and multiplayer)
					or player.lives == INFLIVES
						v.drawScaled((294*FRACUNIT), (18*FRACUNIT), FRACUNIT, v.cachePatch("GENSHDI"), V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
					else
						v.drawNum(55, 183, player.lives, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					end
				--Time
					v.drawScaled((12*FRACUNIT), (30*FRACUNIT), 3*FRACUNIT/4, p_gtime, V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
					local minutes = min(99, G_TicsToMinutes(player.realtime))
					v.drawNum(40, 33, minutes, V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					if G_TicsToSeconds(player.realtime) < 10
						v.drawNum(56, 33, "0", V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					end
					v.drawNum(64, 33, G_TicsToSeconds(player.realtime), V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					v.draw(40, 33, p_gcolon, V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
				--Score
					v.drawScaled((12*FRACUNIT), (10*FRACUNIT), 3*FRACUNIT/4, p_gscore, V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS, v.getColormap("SKINCOLOR_NONE", ((player.powers[pw_super] > 0 and player.powers[pw_super] < 2) and SKINCOLOR_SUPERSUNBEAM4 or player.mo.color)))
					v.drawNum(74, 11, player.score, V_SNAPTOTOP|V_SNAPTOLEFT|V_PERPLAYER|V_HUDTRANS)
					
			end
		end
	end
hud.add(shithud)

local function unwiishedhud(v, player)
	client = player
	if player.cleartimer and player.cleartimer >= 1
		return
	end
	local moderninflife = CV_FindVar("cooplives")
		if player.mo and player.mo.skin == "modernsonic"
        and not (player.powers[pw_carry] == CR_NIGHTSMODE)
		and (player.modernmenu.contents[3][1].value == 8 -- HUDStyle
		or player.modernmenu.contents[3][1].value == 9) -- HUDStyle
		    local boostfill = 0;
			local boostcap = 0;
			local boostdrain = 0;
			if player.boostmeter == nil
				return
			end
			boostcap = $1 + 117
            boostfill = $1 + player.boostmeter
			boostdrain = $1 + player.boostmeter+1
			//Rush Meter
			local rushfill = 0;
			local rushcap = 0;
			local rushdrain = 0;
			if player.rushmode == nil
				return
			end
			rushcap = $1 + 10*TICRATE
            rushfill = $1 + player.rushmode
			rushdrain = $1 + player.rushmode+1
			
			--fml. stealing this from 06 hud
			
			local frc1shield = v.cachePatch("NSHFRC1")
			local frc2shield = v.cachePatch("NSHFRC2")
			local armashield = v.cachePatch("NSHARMA")
			local magnshield = v.cachePatch("NSHMAGN")
			local elemshield = v.cachePatch("NSHELEM")
			local windshield = v.cachePatch("NSHWIND")
			local pityshield = v.cachePatch("NSHPITY")
			local pinkshield = v.cachePatch("NSHAMYS")
			local bubbshield = v.cachePatch("NSHBUBB")
			local flmeshield = v.cachePatch("NSHFLME")
			local lgtnshield = v.cachePatch("NSHLGTN")
			local sorrynothing = v.cachePatch("NOTHING")
			
			local shieldinuse = {
				[SH_WHIRLWIND] = windshield,
				[SH_ELEMENTAL] = elemshield,
				[SH_FLAMEAURA] = flmeshield,
				[SH_BUBBLEWRAP] = bubbshield,
				[SH_THUNDERCOIN] = lgtnshield,
				[SH_ARMAGEDDON] = armashield,
				[SH_PINK] = pinkshield,
				[SH_ATTRACT] = magnshield,
				[SH_PITY] = pityshield,
				[SH_NONE] = sorrynothing
			}
			
			for i = 1, #modernSonicCustomShields
				shieldinuse[modernSonicCustomShields[i].shieldName] = v.cachePatch(modernSonicCustomShields[i].gens06Patch)
			end
			
			local forceshieldisstupid = (player.powers[pw_shield]&SH_FORCEHP) and frc1shield or frc2shield
			local shield = player.powers[pw_shield]
			local getshieldpatch = (shield & SH_FORCE) and forceshieldisstupid or shieldinuse[shield&SH_NOSTACK]
			
			if not getshieldpatch
				getshieldpatch = sorrynothing --lil failsafe for invalid shields!!
			elseif getshieldpatch != sorrynothing
				local yShit = 150
				v.draw(250, 19+yShit, v.cachePatch("UNWSHLD"), HTF|BRF)
				v.draw(248, 17+yShit, getshieldpatch, HTF|BRF)
			end
			
			--let's get this out of the way.
			
			
			
			--Boost Bar 
			
			v.drawStretched(FU*34,FU*182, 160*FU, FU, v.cachePatch("BSTBRMPT"), HTF|BLF)
			v.drawStretched(FU*34,FU*182, abs((FU*boostfill)/boostcap)*160, FU, v.cachePatch("BSTBRFLL"), HTF|BLF)
			
			local boostBarAssets = {v.cachePatch("BSTBR100"),v.cachePatch("BSTBR20"),v.cachePatch("BSTBR60"),v.cachePatch("BSTBR80")}
			local boostBarTransparency = {HTF, adjustHUDTrans(v, 2), adjustHUDTrans(v, 6), adjustHUDTrans(v, 8)}
			for i = 1, #boostBarAssets
				if boostBarTransparency[i]
					v.draw(29,179,boostBarAssets[i], boostBarTransparency[i]|BLF)
				end
			end
			
			local pulseTimer = abs(sin(FixedAngle(leveltime*(FU*360/140))))*10/FU
			
			local segX = 38
			for i = 1,((boostfill*6)/boostcap)
				v.draw(segX,181, v.cachePatch("BSTBRSGM"), HTF|BLF)
				local pulseLOL = adjustHUDTrans(v, max(1,pulseTimer+i))
				if pulseLOL
					v.draw(segX,181, v.cachePatch("BSTBRSGM"), pulseLOL|V_ADD|BLF)
				end
				segX = $ + 26
			end
			
			v.draw(1, 168, v.cachePatch("UNWRMTR"), BLF|HTF)
			if not (player.rings == 0 and (leveltime % 6)/2 == 0)
				if player.hudring2 > 1
					v.drawScaled(15*FU, 182*FU, max(FU/5*4, (FU*(player.hudring2))/3), v.cachePatch("UNWRING"), BLF|HTF)
					local transLOL = adjustHUDTrans(v, 6)
					if transLOL
						v.drawScaled(15*FU, 182*FU, max(FU/5*4, (FU*(player.hudring2))/3)+(FU/3), v.cachePatch("UNWRING2"), V_ADD|BLF|transLOL)
					end
				else
					v.drawScaled(15*FU, 182*FU, FU, v.cachePatch("UNWRING"), BLF|HTF)
				end
			end
			
			if player.rings
				extendedSporkString(v, 34*FU, 8*FU, 173*FU, max(FU, (FU*(player.hudring2))/4), 3, player.rings, "UNWII", "0", BLF|HTF)
			else
				if (leveltime % 6)/2
					for i = 0, 2
						v.draw(30+(8*i), 169, v.cachePatch("UNWIIR0"), BLF|HTF)
					end
				end
			end
			
			if player.rushmode
				for i = 0,5
					local stringToUse = i <= (((FU*rushfill)/rushcap)*6/FU) and "N" or "F"
					v.draw(69+(7*i), 166, v.cachePatch("UWRUSHO"..stringToUse), BLF|HTF)
					local theTrans = adjustHUDTrans(v, 6)
					if (leveltime % 6)/2 and theTrans and stringToUse == "N"
						v.draw(69+(7*i), 166, v.cachePatch("UWRUSHON"), BLF|theTrans|V_ADD)
					end
				end
			end
			
			v.draw(5,6, v.cachePatch("UNWLFE"), TLF|HTF)
			v.draw(7,35, v.cachePatch("UNWSCORE"), TLF|HTF)
			v.draw(7,51, v.cachePatch("UNWTIME"), TLF|HTF)
			
			
			
			--lives
			if (moderninflife.value == 0 and multiplayer)
			or player.lives == INFLIVES
				v.draw(36, 17, v.cachePatch("UNWIII"), TLF|HTF)
			else
				extendedSporkString(v, 36*FU, 9*FU, 17*FU, FU, 2, player.lives, "UNWII", "0", TLF|HTF)
			end
			--time
			
			local timers = {min(99, G_TicsToMinutes(player.realtime)), G_TicsToSeconds(player.realtime), G_TicsToMilliseconds(player.realtime)}
			local timerOffsets = {30,56,82}
			local theOffset
			for i =  1, 3
				theOffset = timerOffsets[i]*FU
				if timers[i] < 10 * (i==3 and 10 or 1)
					DrawMotdString(v, theOffset, 58*FRACUNIT, FRACUNIT, "0", "UNWII", TLF|HTF)
					theOffset = $ + 9*FU
				end
				DrawMotdString(v, theOffset, 58*FRACUNIT, FRACUNIT, timers[i], "UNWII", TLF|HTF)
			end
			if not G_TicsToMilliseconds(player.realtime)
				DrawMotdString(v, theOffset+(9*FU), 58*FRACUNIT, FRACUNIT, 0, "UNWII", TLF|HTF)
			end
			v.drawScaled(43*FRACUNIT, 54*FRACUNIT, FRACUNIT, v.cachePatch("UNWTMSCM"), TLF|HTF)
			v.drawScaled(69*FRACUNIT, 54*FRACUNIT, FRACUNIT, v.cachePatch("UNWTMCSM"), TLF|HTF) --nice
			--score
			extendedSporkString(v, 30*FU, 9*FU, 42*FU, FU, 9, player.score, "UNWII", "0", TLF|HTF)
			
			if player.mo.enemyCombo
			or player.mo.storedEnemyCombo
				if not player.mo.HUDEnemyTimerFade
					local comboTrans = adjustHUDTrans(v, max(0, player.mo.HUDEnemyTimerInit))
					if (comboTrans
					or comboTrans == 0)
						v.draw(50, 0, v.cachePatch("ACHNBG"), TLF|comboTrans)
						--combo timer deserves to be visible lmfao
						if player.mo.enemyComboTimer-1 >= 0
							--i feel dumb lol
							if player.mo.enemyComboTimer == 0
								for i = 0,1
									v.draw(276+(i*9), 30, v.cachePatch("UNWII0"), TLF|comboTrans)
								end
							else
								extendedSporkString(v, 276*FU, 9*FU, 30*FU, FU, 2, player.mo.enemyComboTimer-1, "UNWII", "0", TLF|comboTrans)
							end
						else
							v.draw(278, 30, v.cachePatch("UNWIII"), TLF|comboTrans)
						end
					end
					
					for i = 7, 1, -1
						if player.mo.HUDEnemyTimerInit <= i*3
							local comboTextTrans = adjustHUDTrans(v, max((i-1)*3, player.mo.HUDEnemyTimerInit)-((i-1)*3))
							if comboTextTrans
							or comboTextTrans == 0
								v.drawScaled(50*FU, 0, FU*(max(1,player.mo.HUDEnemyTimerInit-((i-1)*3))), v.cachePatch("ACHN__"..i), TLF|comboTextTrans)
							end
						end
					end
					local chainTrans = adjustHUDTrans(v, player.mo.HUDEnemyTimer)
					if chainTrans or chainTrans == 0
						local numberToUse = player.mo.enemyCombo --i'm losing my mind
						for i = 0, max(1,tostring(numberToUse):len()-1)
							local modString = (numberToUse>=10) and tostring(numberToUse) or ('0'..tostring(numberToUse))
							local divisor = modString:len() --lol
							local getChar = modString:sub((i+1),(i+1))
							local stretchX = (numberToUse%10==0)and max(FU,FU*player.mo.HUDEnemyTimer) or FU
							local stretchY = max(FU,(FU*player.mo.HUDEnemyTimer)/2) -- just to make these easier to work with
							local bumpX = ((36)*i)*FU
							local XLol= (divisor>2) and (((220-(divisor*2))*FU)+(bumpX*2/divisor)) or (220*FU)+bumpX
							v.drawStretched(XLol, 20*FU, stretchX*2/divisor, stretchY, v.cachePatch("ACHN_"..getChar), TLF|chainTrans)
						end
					end
				else
					local totalTrans = adjustHUDTrans(v, 10-player.mo.HUDEnemyTimerFade)
					if totalTrans
					or totalTrans == 0
						v.draw(50, 0, v.cachePatch("ACHNBG"), TLF|totalTrans)
						
						local numberToUse = player.mo.storedEnemyCombo
						
						for i = 0, max(1,tostring(numberToUse):len()-1)
							local modString = (numberToUse>=10) and tostring(numberToUse) or ('0'..tostring(numberToUse))
							local divisor = modString:len() --lol
							local getChar = modString:sub((i+1),(i+1))
							local stretchX = (numberToUse%10==0)and max(FU,FU*player.mo.HUDEnemyTimer) or FU
							local stretchY = max(FU,(FU*player.mo.HUDEnemyTimer)/2) -- just to make these easier to work with
							local bumpX = ((36)*i)*FU
							local XLol= (divisor>2) and (((220-(divisor*2))*FU)+(bumpX*2/divisor)) or (220*FU)+bumpX
							v.drawStretched(XLol, 20*FU, stretchX*2/divisor, stretchY, v.cachePatch("ACHN_"..getChar), TLF|totalTrans)
						end
					
						for i = 1, 7
							v.draw(50, 0, v.cachePatch("ACHN__"..i), TLF|totalTrans)
						end
						
					end	
				end
			end
		end
	end
hud.add(unwiishedhud)


addHook("ThinkFrame", do
	for player in players.iterate
		if player.mo and player.mo.skin == "modernsonic"
			if player.startimerone == nil
			or player.startimerone > 12
				player.startimerone = 0
			end
			if player.startimertwo == nil
			or player.startimertwo > 18
				player.startimertwo = 0
			end
			if player.startimerthree == nil
			or player.startimerthree > 56
				player.startimerthree = 0
			end
			if player.flashingtimer == nil
			or player.flashingtimer > 15
				player.flashingtimer = 0
			end
			if player.powers[pw_super]
			or player.rushmode > 0
				player.flashingtimer = $1+1
			else
				player.flashingtimer = 0
			end
			if player.modernmenu.contents[3][1].value == 5 -- HUDStyle
				if player.powers[pw_super]
					player.startimerthree = $1+8
				else
					if player.boostmeter >= 117
						if player.rushmode > 8*TICRATE
						or player.exiting
						or player.pflags & PF_FINISHED
							player.startimerthree = $1+8
						elseif player.rushmode > 5*TICRATE
							player.startimerthree = $1+4
						elseif player.rushmode > 2*TICRATE
							player.startimerthree = $1+2
						elseif player.rushmode > 0
							player.startimerthree = $1+1
						end
						player.startimertwo = 0
						player.startimerone = 0
					elseif player.boostmeter > 78
						player.startimerthree = 0
						player.startimertwo = $1+1
						player.startimerone = 0
					elseif player.boostmeter > 39
						player.startimerthree = 0
						player.startimertwo = 0
						player.startimerone = $1+1
					else
						player.startimerthree = 0
						player.startimertwo = 0
						player.startimerone = 0
					end
				end
			else
				player.startimerthree = 0
				player.startimertwo = 0
				player.startimerone = 0
			end
		end
	end
end)
			
			
			
