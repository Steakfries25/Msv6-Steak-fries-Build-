--Golden Shine: Going to organize PreThinkFrames and PostThinkFrames in their own Lua file. Music here too.
local function FindMyColor(player, color, menunumber, effect)
	if player.mo and player.mo.valid
		if not player.powers[pw_super]
			if not menunumber
				return player.mo.color
			end
			if menunumber < 0
			or menunumber > 7
			or player.modernmenu.contents[8][menunumber].value == 0 -- Colors
				if player.mo.color == SKINCOLOR_UNLEASHED
					if effect == "srb2jump"
						return SKINCOLOR_SAPPHIRE
					elseif effect == "unleashedjump"
						return SKINCOLOR_UNLEASHEDBOOST
					elseif effect == "colorsjump"
						return SKINCOLOR_DREAM
					elseif effect == "frontiersjump"
						return SKINCOLOR_CERULEAN
					elseif effect == "rushjump"
						return SKINCOLOR_COBALT
					elseif effect == "stomp"
						return SKINCOLOR_CERULEAN
					elseif effect == "boost1"
						return SKINCOLOR_SKY
					elseif effect == "boost2"
						return SKINCOLOR_CORNFLOWER
					elseif effect == "boost3"
						return SKINCOLOR_CORNFLOWER
					elseif effect == "slide"
						return SKINCOLOR_CYAN
					elseif effect == "gens"
						return SKINCOLOR_UNLEASHEDBOOST
					elseif effect == "rush"
						return SKINCOLOR_SAPPHIRE
					elseif effect == "colors"
						return SKINCOLOR_RAINBOW
					elseif effect == "forces"
						return SKINCOLOR_SAPPHIRE
					else
						return player.mo.color
					end
				else
					return player.mo.color
				end
			else
				return player.modernmenu.contents[8][menunumber].value -- Colors
			end
		else
			if player.mo.color == SKINCOLOR_SUPER_SUNFLOWER1
			or player.mo.color == SKINCOLOR_SUPER_SUNFLOWER2
			or player.mo.color == SKINCOLOR_SUPER_SUNFLOWER3
			or player.mo.color == SKINCOLOR_SUPER_SUNFLOWER4
			or player.mo.color == SKINCOLOR_SUPER_SUNFLOWER5
				return color
			else
				return player.mo.color
			end
		end
	end
end

addHook("PostThinkFrame", do
	if (gamestate!=GS_LEVEL) return end --Obviously only if in a level.
	if consoleplayer
		consoleplayer.modern_currentrenderer = CV_FindVar("renderer")	
	end
	for player in players.iterate
		if not (player.mo and player.mo.skin=="modernsonic") continue end --
		
		if (player.pflags & PF_JUMPED or player.powers[pw_carry] == CR_MINECART)
		and (player.mo.state == S_PLAY_JUMP)
		and player.mo.state ~= S_PLAY_HOP
		and (player.jumptimer > 3 or player.pflags & PF_THOKKED or player.powers[pw_carry] == CR_MINECART)
		and player.playerstate == PST_LIVE
		or (player.pflags & PF_SPINNING)
		and (player.mo.state == S_PLAY_ROLL)
		or (player.pflags & PF_SPINNING)
		and (player.mo.state == S_PLAY_SPINDASH)
		or player.dropdashing 
			if player.modernmenu.contents[7][4].value >= 1
			and player.modernmenu.contents[7][4].value != 4
				if not player.powers[pw_super]
					if player.rememberalpha == nil
						player.rememberalpha = player.mo.alpha
					end
					player.mo.alpha = 0
					local gs = P_SpawnMobjFromMobj(player.mo,0,0,0,MT_THOK)
					gs.skin = "modernsonic"
					gs.sprite = SPR_PLAY
					gs.sprite2 = player.mo.sprite2
					gs.frame = player.mo.frame
					gs.angle = player.drawangle
					gs.tics = 1
					gs.color = FindMyColor(player, SKINCOLOR_GOLDENROD, 10, "rushjump")
					gs.radius = player.mo.radius
					gs.shadowscale = player.mo.shadowscale
					gs.flags2 = player.mo.flags2
					gs.spritexscale = player.mo.spritexscale
					gs.spriteyscale = player.mo.spriteyscale
					gs.spriteyoffset = player.mo.spriteyoffset
				end
			end
		elseif player.rememberalpha != nil
			player.mo.alpha = player.rememberalpha
			player.rememberalpha = nil
		end
		
		if player.powers[pw_super]
			if player.modern_currentrenderer.value == 2
				for i = 1, 8
					local ghost = P_SpawnMobjFromMobj(player.mo,0,0,0,MT_THOK)
					ghost.target = player.mo
					ghost.tics = 1
					ghost.frame = (player.mo.frame & ~FF_TRANSMASK)|FF_TRANS90|FF_FULLBRIGHT
					ghost.renderflags = $|RF_NOCOLORMAPS
					if player.modernmenu.contents[8][13].value == 0
						ghost.color = player.mo.color
					else
						ghost.color = player.superauracolor
					end
					ghost.colorized = true
					ghost.angle = player.drawangle
					ghost.rollangle = player.mo.rollangle
					ghost.spritexscale = player.mo.spritexscale
					ghost.spriteyscale = player.mo.spriteyscale
					ghost.flags2 = player.mo.flags2
					ghost.skin = player.mo.skin
					ghost.sprite = player.mo.sprite
					ghost.sprite2 = player.mo.sprite2
					ghost.blendmode = AST_ADD
					ghost.info.dispoffset = -2
					ghost.spritexoffset = player.mo.spritexoffset
					ghost.spriteyoffset = player.mo.spriteyoffset
					if i == 1
						ghost.spritexoffset = $+1*FU
						ghost.spriteyoffset = $+1*FU
					elseif i == 2
						ghost.spritexoffset = $+0*FU
						ghost.spriteyoffset = $+1*FU
					elseif i == 3
						ghost.spritexoffset = $-1*FU
						ghost.spriteyoffset = $+1*FU
					elseif i == 4
						ghost.spritexoffset = $-1*FU
						ghost.spriteyoffset = $+0*FU
					elseif i == 5
						ghost.spritexoffset = $-1*FU
						ghost.spriteyoffset = $-1*FU
					elseif i == 6
						ghost.spritexoffset = $+0*FU
						ghost.spriteyoffset = $-1*FU
					elseif i == 7
						ghost.spritexoffset = $+1*FU
						ghost.spriteyoffset = $-1*FU
					elseif i == 8
						ghost.spritexoffset = $+1*FU
						ghost.spriteyoffset = $+0*FU
					end
				end
				for i = 1, 16
					local ghost = P_SpawnMobjFromMobj(player.mo,0,0,0,MT_THOK)
					ghost.target = player.mo
					ghost.tics = 1
					ghost.frame = (player.mo.frame & ~FF_TRANSMASK)|FF_TRANS90|FF_FULLBRIGHT
					ghost.renderflags = $|RF_NOCOLORMAPS
					if player.modernmenu.contents[8][13].value == 0
						ghost.color = player.mo.color
					else
						ghost.color = player.superauracolor
					end
					ghost.colorized = true
					ghost.angle = player.drawangle
					ghost.rollangle = player.mo.rollangle
					ghost.spritexscale = player.mo.spritexscale
					ghost.spriteyscale = player.mo.spriteyscale
					ghost.flags2 = player.mo.flags2
					ghost.skin = player.mo.skin
					ghost.sprite = player.mo.sprite
					ghost.sprite2 = player.mo.sprite2
					ghost.blendmode = AST_ADD
					ghost.info.dispoffset = -2
					ghost.spritexoffset = player.mo.spritexoffset
					ghost.spriteyoffset = player.mo.spriteyoffset
					if i == 1
						ghost.spritexoffset = $+2*FU
						ghost.spriteyoffset = $+2*FU
					elseif i == 2
						ghost.spritexoffset = $+1*FU
						ghost.spriteyoffset = $+2*FU
					elseif i == 3
						ghost.spritexoffset = $+0*FU
						ghost.spriteyoffset = $+2*FU
					elseif i == 4
						ghost.spritexoffset = $-1*FU
						ghost.spriteyoffset = $+2*FU
					elseif i == 5
						ghost.spritexoffset = $-2*FU
						ghost.spriteyoffset = $+2*FU
					elseif i == 6
						ghost.spritexoffset = $-2*FU
						ghost.spriteyoffset = $+1*FU
					elseif i == 7
						ghost.spritexoffset = $-2*FU
						ghost.spriteyoffset = $+0*FU
					elseif i == 8
						ghost.spritexoffset = $-2*FU
						ghost.spriteyoffset = $-1*FU
					elseif i == 9
						ghost.spritexoffset = $-2*FU
						ghost.spriteyoffset = $-2*FU
					elseif i == 10
						ghost.spritexoffset = $-1*FU
						ghost.spriteyoffset = $-2*FU
					elseif i == 11
						ghost.spritexoffset = $+0*FU
						ghost.spriteyoffset = $-2*FU
					elseif i == 12
						ghost.spritexoffset = $+1*FU
						ghost.spriteyoffset = $-2*FU
					elseif i == 13
						ghost.spritexoffset = $+2*FU
						ghost.spriteyoffset = $-2*FU
					elseif i == 14
						ghost.spritexoffset = $+2*FU
						ghost.spriteyoffset = $-1*FU
					elseif i == 15
						ghost.spritexoffset = $+2*FU
						ghost.spriteyoffset = $+0*FU
					elseif i == 16
						ghost.spritexoffset = $+2*FU
						ghost.spriteyoffset = $+1*FU
					end
				end
				
				for i = 1, 24
					local ghost = P_SpawnMobjFromMobj(player.mo,0,0,0,MT_THOK)
					ghost.target = player.mo
					ghost.tics = 1
					ghost.frame = (player.mo.frame & ~FF_TRANSMASK)|FF_TRANS90|FF_FULLBRIGHT
					ghost.renderflags = $|RF_NOCOLORMAPS
					if player.modernmenu.contents[8][13].value == 0
						ghost.color = player.mo.color
					else
						ghost.color = player.superauracolor
					end
					ghost.colorized = true
					ghost.angle = player.drawangle
					ghost.rollangle = player.mo.rollangle
					ghost.spritexscale = player.mo.spritexscale
					ghost.spriteyscale = player.mo.spriteyscale
					ghost.flags2 = player.mo.flags2
					ghost.skin = player.mo.skin
					ghost.sprite = player.mo.sprite
					ghost.sprite2 = player.mo.sprite2
					ghost.blendmode = AST_ADD
					ghost.info.dispoffset = -2
					ghost.spritexoffset = player.mo.spritexoffset
					ghost.spriteyoffset = player.mo.spriteyoffset
					if i == 1
						ghost.spritexoffset = $+3*FU
						ghost.spriteyoffset = $+3*FU
					elseif i == 2
						ghost.spritexoffset = $+2*FU
						ghost.spriteyoffset = $+3*FU
					elseif i == 3
						ghost.spritexoffset = $+1*FU
						ghost.spriteyoffset = $+3*FU
					elseif i == 4
						ghost.spritexoffset = $+0*FU
						ghost.spriteyoffset = $+3*FU
					elseif i == 5
						ghost.spritexoffset = $-1*FU
						ghost.spriteyoffset = $+3*FU
					elseif i == 6
						ghost.spritexoffset = $-2*FU
						ghost.spriteyoffset = $+3*FU
					elseif i == 7
						ghost.spritexoffset = $-3*FU
						ghost.spriteyoffset = $+3*FU
					elseif i == 8
						ghost.spritexoffset = $-3*FU
						ghost.spriteyoffset = $+2*FU
					elseif i == 9
						ghost.spritexoffset = $-3*FU
						ghost.spriteyoffset = $+1*FU
					elseif i == 10
						ghost.spritexoffset = $-3*FU
						ghost.spriteyoffset = $+0*FU
					elseif i == 11
						ghost.spritexoffset = $-3*FU
						ghost.spriteyoffset = $-1*FU
					elseif i == 12
						ghost.spritexoffset = $-3*FU
						ghost.spriteyoffset = $-2*FU
					elseif i == 13
						ghost.spritexoffset = $-3*FU
						ghost.spriteyoffset = $-3*FU
					elseif i == 14
						ghost.spritexoffset = $-2*FU
						ghost.spriteyoffset = $-3*FU
					elseif i == 15
						ghost.spritexoffset = $-1*FU
						ghost.spriteyoffset = $-3*FU
					elseif i == 16
						ghost.spritexoffset = $+0*FU
						ghost.spriteyoffset = $-3*FU
					elseif i == 17
						ghost.spritexoffset = $+1*FU
						ghost.spriteyoffset = $-3*FU
					elseif i == 18
						ghost.spritexoffset = $+2*FU
						ghost.spriteyoffset = $-3*FU
					elseif i == 19
						ghost.spritexoffset = $+3*FU
						ghost.spriteyoffset = $-3*FU
					elseif i == 20
						ghost.spritexoffset = $+3*FU
						ghost.spriteyoffset = $-2*FU
					elseif i == 21
						ghost.spritexoffset = $+3*FU
						ghost.spriteyoffset = $-1*FU
					elseif i == 22
						ghost.spritexoffset = $+3*FU
						ghost.spriteyoffset = $+0*FU
					elseif i == 23
						ghost.spritexoffset = $+3*FU
						ghost.spriteyoffset = $+1*FU
					elseif i == 24
						ghost.spritexoffset = $+3*FU
						ghost.spriteyoffset = $+2*FU
					end
				end
			elseif player.modern_currentrenderer.value == 1
				for i = 1, 4
					local ghost = P_SpawnMobjFromMobj(player.mo,0,0,0,MT_THOK)
					ghost.target = player.mo
					ghost.tics = 1
					ghost.frame = (player.mo.frame & ~FF_TRANSMASK)|FF_TRANS30|FF_FULLBRIGHT
					ghost.renderflags = $|RF_NOCOLORMAPS
					if player.modernmenu.contents[8][13].value == 0
						ghost.color = player.mo.color
					else
						ghost.color = player.superauracolor
					end
					ghost.colorized = true
					ghost.angle = player.drawangle
					ghost.rollangle = player.mo.rollangle
					ghost.spritexscale = player.mo.spritexscale
					ghost.spriteyscale = player.mo.spriteyscale
					ghost.flags2 = player.mo.flags2
					ghost.skin = player.mo.skin
					ghost.sprite = player.mo.sprite
					ghost.sprite2 = player.mo.sprite2
					ghost.blendmode = AST_ADD
					ghost.info.dispoffset = -2
					ghost.spritexoffset = player.mo.spritexoffset
					ghost.spriteyoffset = player.mo.spriteyoffset
					if i == 1
						ghost.spritexoffset = $+2*FU
						ghost.spriteyoffset = $+2*FU
					elseif i == 2
						ghost.spritexoffset = $-2*FU
						ghost.spriteyoffset = $+2*FU
					elseif i == 3
						ghost.spritexoffset = $-2*FU
						ghost.spriteyoffset = $-2*FU
					elseif i == 4
						ghost.spritexoffset = $+2*FU
						ghost.spriteyoffset = $-2*FU
					end
				end
			end
		end
		local s = player.mo
		local shoe = player.shoesoverlay
		
		
			
		if player.modernmenu.contents[8][11].value==player.modernmenu.contents[8][11].defaultvalue
			if shoe and shoe.valid --What are THOOOOOSE? /srs
				P_RemoveMobj(player.shoesoverlay)
			end
		else
			if not (shoe and shoe.valid)
				player.shoesoverlay = P_SpawnMobjFromMobj(s,0,0,0, MT_MODERNOVERLAY)
				shoe = player.shoesoverlay
				shoe.skin = "modernsonicshoes"
				shoe.state = s.state
				shoe.angle = player.drawangle
				shoe.tics = s.tics
				shoe.anim_duration = s.anim_duration
				shoe.frame = s.frame
				shoe.color = player.modernshoecolor
				shoe.sprite = SPR_PLAY
				shoe.sprite2 = s.sprite2
				shoe.target = s
				shoe.scale = s.scale
				shoe.spritexscale = s.spritexscale
				shoe.spriteyscale = s.spriteyscale
				shoe.spriteyoffset = s.spriteyoffset
				shoe.spritexoffset = s.spritexoffset
				shoe.rollangle = s.rollangle
				shoe.eflags = s.eflags
				shoe.flags2 = s.flags2
				shoe.mirrored = s.mirrored
				if s.renderflags & RF_HORIZONTALFLIP
					shoe.renderflags = $|RF_HORIZONTALFLIP
				end
				if s.renderflags & RF_VERTICALFLIP
					shoe.renderflags = $|RF_VERTICALFLIP
				end
			else
				shoe.skin = "modernsonicshoes"
				shoe.state = s.state
				shoe.tics = s.tics
				shoe.anim_duration = s.anim_duration
				shoe.sprite = SPR_PLAY
				shoe.frame = s.frame
				shoe.sprite2 = s.sprite2
				shoe.target = s
				shoe.rollangle = s.rollangle
				shoe.dispoffset = 2
				shoe.spritexscale = s.spritexscale
				shoe.spriteyscale = s.spriteyscale
				shoe.spriteyoffset = s.spriteyoffset
				shoe.spritexoffset = s.spritexoffset
				shoe.eflags = s.eflags
				shoe.flags2 = s.flags2
				shoe.scale = s.scale
				shoe.mirrored = s.mirrored
				--shoe.blendmode = AST_ADD
				shoe.color = player.modernshoecolor
				if s.renderflags & RF_HORIZONTALFLIP
					shoe.renderflags = $|RF_HORIZONTALFLIP
				end
				if s.renderflags & RF_VERTICALFLIP
					shoe.renderflags = $|RF_VERTICALFLIP
				end
				if s.eflags & MFE_VERTICALFLIP
				or shoe.frame & FF_VERTICALFLIP
					P_MoveOrigin(shoe, s.x,s.y,s.z+s.height)
				else
					P_MoveOrigin(shoe, s.x,s.y,s.z)
				end
				shoe.rollangle = s.rollangle
				shoe.angle = player.drawangle
			end
		end
		
		local cloth = player.clothoverlay
		
		if player.modernmenu.contents[8][12].value == player.modernmenu.contents[8][12].defaultvalue
			if cloth and cloth.valid
				P_RemoveMobj(player.clothoverlay)
			end
		else
			if not (cloth and cloth.valid)
				player.clothoverlay = P_SpawnMobjFromMobj(s,0,0,0, MT_MODERNOVERLAY)
				cloth = player.clothoverlay
				cloth.skin = "modernsoniccloth"
				cloth.state = s.state
				cloth.angle = player.drawangle
				cloth.tics = s.tics
				cloth.anim_duration = s.anim_duration
				cloth.frame = s.frame
				cloth.color = player.modernclothcolor
				cloth.sprite = SPR_PLAY
				cloth.sprite2 = s.sprite2
				cloth.target = s
				cloth.scale = s.scale
				cloth.spritexscale = s.spritexscale
				cloth.spriteyscale = s.spriteyscale
				cloth.spriteyoffset = s.spriteyoffset
				cloth.spritexoffset = s.spritexoffset
				cloth.rollangle = s.rollangle
				cloth.eflags = s.eflags
				cloth.flags2 = s.flags2
				cloth.mirrored = s.mirrored
				if s.renderflags & RF_HORIZONTALFLIP
					cloth.renderflags = $|RF_HORIZONTALFLIP
				end
				if s.renderflags & RF_VERTICALFLIP
					cloth.renderflags = $|RF_VERTICALFLIP
				end
			else
				cloth.skin = "modernsoniccloth"
				cloth.state = s.state
				cloth.tics = s.tics
				cloth.anim_duration = 1
				cloth.sprite = SPR_PLAY
				cloth.frame = s.frame
				cloth.sprite2 = s.sprite2
				cloth.target = s
	
				cloth.dispoffset = 2
				cloth.spritexscale = s.spritexscale
				cloth.spriteyscale = s.spriteyscale
				cloth.spriteyoffset = s.spriteyoffset
				cloth.spritexoffset = s.spritexoffset
				cloth.eflags = s.eflags
				cloth.flags2 = s.flags2
				cloth.scale = s.scale
				--cloth.blendmode = AST_ADD
				cloth.color = player.modernclothcolor
				cloth.mirrored = s.mirrored
				if s.renderflags & RF_HORIZONTALFLIP
					cloth.renderflags = $|RF_HORIZONTALFLIP
				end
				if s.renderflags & RF_VERTICALFLIP
					cloth.renderflags = $|RF_VERTICALFLIP
				end
				if s.eflags & MFE_VERTICALFLIP
				or cloth.frame & FF_VERTICALFLIP
					P_MoveOrigin(cloth, s.x,s.y,s.z+s.height)
				else
					P_MoveOrigin(cloth, s.x,s.y,s.z)
				end
				cloth.rollangle = s.rollangle
				cloth.angle = player.drawangle
			end
		end
	end
end)

-- Credit Frostii for this :)
local yourmom
addHook("PreThinkFrame", function(r)
	yourmom = S_GetMusicPosition()
    for player in players.iterate 
		if player.mo and player.mo.skin == "modernsonic"
			--bandage fix
			player.mo.sidestepping = 2
			--player.mo.sidetimer = 0
			--player.mo.sidestep = 0
		end
	end	
end)
addHook("PreThinkFrame", do
	for player in players.iterate
		if player.mo and player.mo.skin == "modernsonic" 
			--print(AngleFixed(player.mo.angle)/FU)
			--if player.candrift == false
			if not (player.manualdrifting)
				if (player.pflags & PF_ANALOGMODE)
				and not (player.pflags & PF_DIRECTIONCHAR)
				or not (player.pflags & PF_ANALOGMODE)
					player.mimicangle = R_PointToAngle2(0,0, player.mo.momx, player.mo.momy)
				else
					player.mimicangle = player.drawangle
				end
					--player.mimicangle = player.bsoldanalog and player.drawangle or player.mo.angle
			end
			if player.manualdrifting
				if (player.pflags & PF_ANALOGMODE)
					player.cmd.angleturn = player.mimicangle>>16
				else
-- 					player.mo.angle = player.mimicangle
				end
			end
		end
	end
end)

addHook("MusicChange", function(om, nm)
	if (consoleplayer and consoleplayer.mo and consoleplayer.mo.valid and consoleplayer.mo.health and consoleplayer.mo.skin == "modernsonic")
		local musname = "_1up"
		if nm == musname
			if consoleplayer.powers[pw_super]
				S_StartSound(consoleplayer.mo, sfx_mod1up, consoleplayer.mo.player)
				if consoleplayer.modernmenu.contents[6][3].value == 0 -- SuperMusic
					return "MSUPR1", 0, true, yourmom
				elseif consoleplayer.modernmenu.contents[6][3].value == 1 -- SuperMusic
					return "MSUPR2", 0, true, yourmom
				elseif consoleplayer.modernmenu.contents[6][3].value == 2 -- SuperMusic
					return "MSUPR3", 0, true, yourmom
				elseif consoleplayer.modernmenu.contents[6][3].value == 3 -- SuperMusic
					return "MSUPR4", 0, true, yourmom 
				elseif consoleplayer.modernmenu.contents[6][3].value == 4 -- SuperMusic
					return "MSUPR5", 0, true, yourmom
				elseif consoleplayer.modernmenu.contents[6][3].value == 5 -- SuperMusic
					return "MSUPR6", 0, true, yourmom
				elseif consoleplayer.modernmenu.contents[6][3].value == 6 -- SuperMusic
					return "_SUPERS", 0, true, yourmom
				end
			else
				S_StartSound(consoleplayer.mo, sfx_mod1up, consoleplayer.mo.player)
				return consoleplayer.musicplaying, 0, true, yourmom
			end
		end
	end
end)