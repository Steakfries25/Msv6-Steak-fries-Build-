/*
Ranks by Bluetorch. Use for whatever.

Rank Template

--  S rank should not be the same to the rest of the ranks 
	as you have to have all the requierments to get it. 
	Make these reasonable to get within your timelimit.

Lua.rank(S)_time =
Lua.rank(S)_score =
Lua.rank(S)_rings =

-- Copy this for all ranks A to E

Lua.rank(rankhere)_time =
Lua.rank(rankhere)_score =
Lua.rank(rankhere)_rings =

*/

local modname = "sonicunleashedranks"
local altmodname = "vanilla"

freeslot("S_PLAYERRANKSPAWN", "MT_PLAYERRANKSPAWN")

states[S_PLAYERRANKSPAWN] = {
sprite = SPR_NULL,
frame = A,
tics = -1,
var1 = -1,
var2 = -1,
nextstate = S_PLAYERRANKSPAWN,
}

mobjinfo[MT_PLAYERRANKSPAWN] = {
	--$Name Rank Spawn Point
	--$Sprite PLAYA0
	--$Category Sonic Unleashed Stuff
	doomednum = 3010,
	spawnstate = S_PLAYERRANKSPAWN,
	spawnhealth = 1,
	deathstate = S_NULL,
	height = 54*FRACUNIT,
	radius = 32*FRACUNIT
}

rawset(_G, "RANKTHING", {
	rankspawnx = 0,
	rankspawny = 0,
	rankspawnz = 0,
	rankspawnangle = 0,
	rankspawn = nil,
})

local rt = RANKTHING

addHook("PlayerSpawn", function(p) -- Player Spawn Values
	if p and p.mo and p.mo.valid
		p.rank = "E"
		p.rankfade = 0
		p.timebonus = 0
		p.ringbonus = 0
		p.lastscore = p.score
		p.cleartimer = -1
		p.lastlevelendtime = 0
	end
end)

addHook("PlayerThink", function(p) -- Rank Stuff
	if p.exiting and p.rank and p.mo.skin == "modernsonic"
	--and not (multiplayer or netgame) -- Multiplayer block
		if p.lastlevelendtime == 0
			p.lastlevelendtime = leveltime
		end
		if (p.ranktime and p.rankscore and p.rankrings)
			local timething = p.ranktime
			local scorething = p.rankscore
			local ringthing = p.rankrings
			
			if (p.lastlevelendtime <= timething*TICRATE) and (p.score-p.lastscore) >= scorething and p.rings >= ringthing -- PERFECT!
				p.rank = "S"
			else -- Everything Else
				local finalscore = (p.score-p.lastscore)+p.rings+(timething-p.lastlevelendtime)/TICRATE
				
				if finalscore >= scorething 
					p.rank = "A"
				elseif finalscore >= scorething/2
					p.rank = "B"
				elseif finalscore >= (scorething/2)/2
					p.rank = "C"
				elseif finalscore >= ((scorething/2)/2)/2
					p.rank = "D"
				else
					p.rank = "E"
				end
			end
		else
			p.rank = "E"
		end
		if p.exiting > TICRATE -- Change to clear Music
			if p.cleartimer < 5*TICRATE
			and mapmusname ~= "SUCLER"
			and mapmusname ~= "MCLRUS"
				S_ChangeMusic("SUCLER", false, p, 0, 0, 2*MUSICRATE, 0)
				mapmusname = "SUCLER"
				p.finalscore = (p.score-p.lastscore)+(p.rings*100)+p.enemyscore+p.trickscore+((p.topspeed/FU)*100)+((p.ranktime-p.lastlevelendtime)/TICRATE)
			end
		end
		if p.cleartimer >= 5*TICRATE
			if p.rank == "E"
			and mapmusname ~= "MCLRUE"
				mapmusname = "MCLRUE"
				S_ChangeMusic("MCLRUE", false, p, 0, 0, 2*MUSICRATE, 0)
			elseif p.rank ~= "E"
			and mapmusname ~= "MCLRUS"
				mapmusname = "MCLRUS"
				S_ChangeMusic("MCLRUS", false, p, 0, 0, 2*MUSICRATE, 0)
			end
		end
		if p.exiting <= 1*TICRATE
			p.exiting = 1*TICRATE
			if not (rt.rankspawn and rt.rankspawn.valid)
			and not (multiplayer or netgame)
				local ranker = P_SpawnMobjFromMobj(p.mo, FixedMul(cos(p.mo.angle), 100*FRACUNIT), FixedMul(sin(p.mo.angle), 100*FRACUNIT), p.mo.z, MT_PLAYERRANKSPAWN)
				local angle = R_PointToAngle2(camera.x, camera.y, ranker.x, ranker.y)
				local dist = -250*FRACUNIT
				local camdist = -180*FRACUNIT
				rt.rankspawnx = ranker.x/FRACUNIT-FixedMul(cos(rt.rankspawnangle-ANGLE_90), -10*FRACUNIT)
				rt.rankspawny = ranker.y/FRACUNIT-FixedMul(sin(rt.rankspawnangle-ANGLE_90), -10*FRACUNIT)
				rt.rankspawnz = ranker.z/FRACUNIT
				rt.rankspawnangle = ranker.angle*-1+ANGLE_90
				ranker.angle = p.mo.angle+ANGLE_90
				ranker.z = ranker.floorz
				ranker.playerspawned = true
				rt.rankspawn = ranker
				p.awayviewmobj = P_SpawnMobjFromMobj(rt.rankspawn, FixedMul(cos(angle+ANGLE_22h), camdist), FixedMul(sin(angle+ANGLE_22h), camdist), CV_FindVar("cam_height").value, MT_GFZFLOWER1)
				p.awayviewmobj.flags = MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOGRAVITY
				p.awayviewmobj.flags2 = MF2_DONTDRAW
				p.awayviewmobj.angle = angle
				p.awayviewtics = -1
			end
			p.cleartimer = $+1
			if p.rankfade > 0
			and not (multiplayer or netgame)
				p.rankfade = $-1
			end
		elseif p.exiting <= 2*TICRATE 
		and not (multiplayer or netgame)
			p.rankfade = $+1
		elseif not (multiplayer or netgame)
			if p.rankfade > 0
				p.rankfade = $-1
			end
		end
		if p.cleartimer >= 16*TICRATE or (p.cleartimer > 4*TICRATE and p.cmd.buttons & BT_JUMP)
			G_SetCustomExitVars(nil, 1) -- Skip Stats
			G_ExitLevel()
		end
	end
	
	if p.cleartimer != -1
		if not (multiplayer or netgame)
			local angle = R_PointToAngle2(camera.x, camera.y, rt.rankspawn.x, rt.rankspawn.y)
			if p.cleartimer == 0
				local dist = -250*FRACUNIT
				local camdist = -180*FRACUNIT
				P_SetOrigin(p.mo, rt.rankspawnx*FRACUNIT+FixedMul(cos(rt.rankspawnangle-ANGLE_90), -10*FRACUNIT), rt.rankspawny*FRACUNIT+FixedMul(sin(rt.rankspawnangle-ANGLE_90), -10*FRACUNIT), rt.rankspawnz*FRACUNIT)
				if not rt.rankspawn.playerspawned
					p.awayviewmobj = P_SpawnMobjFromMobj(rt.rankspawn, FixedMul(cos(angle+ANGLE_22h), camdist), FixedMul(sin(angle+ANGLE_22h), camdist), CV_FindVar("cam_height").value, MT_GFZFLOWER1)
					p.awayviewmobj.flags = MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOGRAVITY
					p.awayviewmobj.flags2 = MF2_DONTDRAW
					p.awayviewmobj.angle = angle
					p.awayviewtics = -1
				end
			end
			p.mo.target = nil -- No signpost. You will not mess with my camera
			p.mo.z = p.mo.floorz
			p.mo.angle = R_PointToAngle2(rt.rankspawn.x, rt.rankspawn.y, p.awayviewmobj.x, p.awayviewmobj.y)
			p.drawangle = R_PointToAngle2(rt.rankspawn.x, rt.rankspawn.y, p.awayviewmobj.x, p.awayviewmobj.y)+ANGLE_45
			camera.chase = true
		else
			p.drawangle = p.mo.angle - ANGLE_135
		end
	end
end)

addHook("ThinkFrame", do
	if not (rt.rankspawn and rt.rankspawn.valid)
		for mobj in mobjs.iterate()
			if mobj.type == MT_PLAYERRANKSPAWN
				rt.rankspawnx = mobj.x/FRACUNIT
				rt.rankspawny = mobj.y/FRACUNIT
				rt.rankspawnz = mobj.z/FRACUNIT
				rt.rankspawnangle = mobj.angle*-1
				rt.rankspawn = mobj
			end
		end
		for mobj in mobjs.iterate()
			if mobj.type == MT_SIGN and not (rt.rankspawn and rt.rankspawn.valid)
				local ranker = P_SpawnMobjFromMobj(mobj, FixedMul(cos(mobj.angle), 100*FRACUNIT), FixedMul(sin(mobj.angle), 100*FRACUNIT), mobj.z, MT_PLAYERRANKSPAWN)
				rt.rankspawnx = ranker.x/FRACUNIT
				rt.rankspawny = ranker.y/FRACUNIT
				rt.rankspawnz = ranker.z/FRACUNIT
				rt.rankspawnangle = ranker.angle*-1+ANGLE_90
				ranker.angle = mobj.angle+ANGLE_90
				ranker.z = ranker.floorz
				rt.rankspawn = ranker
			end
		end
	end
	for p in players.iterate
		p.ranktime = tonumber(mapheaderinfo[gamemap]["rank("..p.rank..")_time"]) or 60
		p.rankscore = tonumber(mapheaderinfo[gamemap]["rank("..p.rank..")_score"]) or 1000
		p.rankrings = tonumber(mapheaderinfo[gamemap]["rank("..p.rank..")_rings"]) or 50
	end
end)

local function adjustHUDTrans(v, num)
	local theShift = min(10,(v.localTransFlag()>>V_ALPHASHIFT)+num)
	if theShift >= 10
		return false
	end
	return (theShift<<V_ALPHASHIFT)
end

local function endranks(v, p)
	if not (p and p.valid and p.mo and p.mo.valid)
		return
	end
	
	if p.rankfade
		v.fadeScreen(PAL_WHITE, min(p.rankfade, 10)) -- Background Fade
	end
	
	if p.cleartimer
	
		local text1 = "Results"
		local text1height = v.levelTitleHeight(text1)

		local rankx = -200
		local rank2y = -150
		local resultbarx = -300
		local resultbar2x = 400
		
		local rankstartx = -200
		local rank2starty = -150
		local resultbarstartx = -300
		local resultbar2startx = 400
		
		local rankdestx = 150
		local rank2desty = 20
		local resultbardestx = 0
		local resultbar2destx = 320
		
		local tanrankfade = 0
		
		local imnothere = v.cachePatch("MISSING")
		local resultbar = v.cachePatch("STAGSLCT1")
		local resultbar2 = v.cachePatch("RESULTBAR2")
		local resultbar3 = v.cachePatch("RESULTBAR3")
		local resultbar4 = v.cachePatch("RESULTBAR4")
		local resultbar5 = v.cachePatch("RESULTBAR5")
		local resultbar6 = v.cachePatch("RESULTBAR6")
		local resultbar7 = v.cachePatch("RESULTBAR7")
		local resultbar8 = v.cachePatch("RESULTBAR8")
		local rank = v.cachePatch("RANK"+p.rank)
		local ranktext = v.cachePatch("RANKTEXT"+p.rank)
		local tanthinglol = v.cachePatch("RANKTANTHING")
		
		--Mini Hud
		
		--Time Stuff
		local hours = G_TicsToHours(p.lastlevelendtime)
		local minutes = G_TicsToMinutes(p.lastlevelendtime, false)
		local seconds = G_TicsToSeconds(p.lastlevelendtime)
		local tictrn  = G_TicsToCentiseconds(p.lastlevelendtime)
		local spad, tpad = '', ''
		local extra = ''
		local extrac = ''
		--
		
		--padding
		if (seconds < 10) then spad = '0' end
		if (tictrn < 10) then tpad = '0' end
		
		local timex, timey = 100, 45
		local timetx = 5
				
		if hours > 0
			extrac = ":"
			if (minutes < 10)
				extrac = $.."0"
			end
		else
			hours = ''
		end
		--
		
		if p.cleartimer
			resultbarx = ease.outquint(FixedDiv(min(p.cleartimer, TICRATE), TICRATE), resultbarstartx, resultbardestx)
		end
			
		if p.cleartimer > 2*TICRATE
			rankx = ease.outquint(FixedDiv(min(p.cleartimer-2*TICRATE, TICRATE), TICRATE), rankstartx, rankdestx)
		end
		v.drawScaled(resultbarx*FRACUNIT, 10*FRACUNIT, FRACUNIT, resultbar, V_PERPLAYER|V_HUDTRANS|V_SNAPTOTOP|V_SNAPTOLEFT)
		--v.drawLevelTitle((resultbarx+40), 10+text1height, text1, V_PERPLAYER|V_HUDTRANS|V_SNAPTOTOP|V_SNAPTOLEFT)
		v.drawScaled((rankx-rankdestx)*FRACUNIT, 170*FRACUNIT, FRACUNIT*8/10, resultbar3, V_PERPLAYER|V_HUDTRANS|V_SNAPTOBOTTOM|V_SNAPTOLEFT)
		--v.drawScaled(rankx*FRACUNIT-50*FU, 175*FRACUNIT, FRACUNIT*7/10, rank, V_PERPLAYER|V_SNAPTOLEFT)
		local hudTrans = adjustHUDTrans(v, 11-p.clearranktimer)
		if hudTrans
			v.drawScaled(rankx*FRACUNIT-50*FU, 175*FRACUNIT, FRACUNIT*7/10, rank, V_PERPLAYER|V_SNAPTOLEFT|hudTrans)
			--v.draw(72, 175, v.cachePatch(boostPieces[i]), BLF|hudTrans)
		end
		if p.finalscore
			--v.drawString(rankx+130, 167, p.finalscore, V_PERPLAYER|V_SNAPTOBOTTOM|V_SNAPTOLEFT)
			DrawMotdString(v, rankx*FU+130*FU, 167*FU, FRACUNIT*85/100, p.finalscore, "UNLDHD2", V_PERPLAYER|V_SNAPTOBOTTOM|V_SNAPTOLEFT)
		end
		
		if p.cleartimer > 1*TICRATE
			resultbar2x = ease.outquint(FixedDiv(min(p.cleartimer-1*TICRATE, TICRATE), TICRATE), resultbar2startx, resultbar2destx)
			--v.drawScaled(resultbar2x*FRACUNIT, 80*FRACUNIT, FRACUNIT, resultbar2, V_PERPLAYER|V_SNAPTORIGHT|V_SNAPTOTOP)
			--v.drawScaled(resultbar2x*FRACUNIT, 100*FRACUNIT, FRACUNIT, resultbar2, V_PERPLAYER|V_SNAPTORIGHT|V_SNAPTOTOP)
			--v.drawScaled(resultbar2x*FRACUNIT, 120*FRACUNIT, FRACUNIT, resultbar2, V_PERPLAYER|V_SNAPTORIGHT|V_SNAPTOTOP)
			
			v.drawScaled(resultbar2x*FRACUNIT, 75*FRACUNIT, FRACUNIT*7/10, resultbar4, V_PERPLAYER|V_SNAPTORIGHT|V_SNAPTOTOP)
			v.drawScaled(resultbar2x*FRACUNIT, 95*FRACUNIT, FRACUNIT*7/10, resultbar5, V_PERPLAYER|V_SNAPTORIGHT|V_SNAPTOTOP)
			v.drawScaled(resultbar2x*FRACUNIT, 115*FRACUNIT, FRACUNIT*7/10, resultbar6, V_PERPLAYER|V_SNAPTORIGHT|V_SNAPTOTOP)
			v.drawScaled(resultbar2x*FRACUNIT, 135*FRACUNIT, FRACUNIT*7/10, resultbar7, V_PERPLAYER|V_SNAPTORIGHT|V_SNAPTOTOP)
			v.drawScaled(resultbar2x*FRACUNIT, 155*FRACUNIT, FRACUNIT*7/10, resultbar8, V_PERPLAYER|V_SNAPTORIGHT|V_SNAPTOTOP)
			
			--v.drawString(resultbar2x-80, 70, hours..extrac..minutes..":"..spad..seconds.."."..tictrn..tpad, V_PERPLAYER|V_SNAPTOTOP|V_SNAPTORIGHT)
			DrawMotdString(v, resultbar2x*FU-80*FU, 70*FU, FRACUNIT*85/100, hours..extrac..minutes.."S"..spad..seconds.."S"..tictrn..tpad, "UNLDHD2", V_PERPLAYER|V_SNAPTOTOP|V_SNAPTORIGHT)
			
			--v.drawString(resultbar2x-80, 90, p.rings.."00", V_PERPLAYER|V_SNAPTOTOP|V_SNAPTORIGHT)
			DrawMotdString(v, resultbar2x*FU-80*FU, 90*FU, FRACUNIT*85/100, p.rings.."00", "UNLDHD2", V_PERPLAYER|V_SNAPTOTOP|V_SNAPTORIGHT)
			--v.drawString(resultbar2x-80, 110, p.topspeed/FU.."00", V_PERPLAYER|V_SNAPTOTOP|V_SNAPTORIGHT)
			DrawMotdString(v, resultbar2x*FU-80*FU, 110*FU, FRACUNIT*85/100, p.topspeed/FU.."00", "UNLDHD2", V_PERPLAYER|V_SNAPTOTOP|V_SNAPTORIGHT)
			--v.drawString(resultbar2x-80, 130, p.enemyscore, V_PERPLAYER|V_SNAPTOTOP|V_SNAPTORIGHT)
			DrawMotdString(v, resultbar2x*FU-80*FU, 130*FU, FRACUNIT*85/100, p.enemyscore, "UNLDHD2", V_PERPLAYER|V_SNAPTOTOP|V_SNAPTORIGHT)
			--v.drawString(resultbar2x-80, 150, p.trickscore, V_PERPLAYER|V_SNAPTOTOP|V_SNAPTORIGHT)
			DrawMotdString(v, resultbar2x*FU-80*FU, 150*FU, FRACUNIT*85/100, p.trickscore, "UNLDHD2", V_PERPLAYER|V_SNAPTOTOP|V_SNAPTORIGHT)
		end
	end
end

addHook("HUD", function(v, p, c)
	if p and p.mo and p.mo.valid
		customhud.SetupItem("endranks", modname, endranks(v, p), "game")
	end
end)
