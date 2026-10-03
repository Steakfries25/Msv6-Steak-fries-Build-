addHook("MobjThinker", function(minecart)
	if minecart and minecart.valid
	and minecart.target and minecart.target.valid
	and minecart.target.player
	and minecart.target.type == MT_PLAYER
	and minecart.target.skin == "modernsonic"
	and minecart.target.health
		minecart.flags2 = $|MF2_DONTDRAW
		if minecart.target.player.boosting == true
			minecart.target.player.boosting = false
			minecart.target.player.minecartboost = true
		end
		if not (P_IsObjectOnGround(minecart))
			minecart.target.player.jumptimer = 4
			minecart.target.player.minecartjumpframe = $1+1
			minecart.target.state = S_PLAY_JUMP
			if minecart.target.player.minecartjumpframe <= 1
				minecart.target.frame = A
			elseif minecart.target.player.minecartjumpframe < 2
				minecart.target.frame = B
			elseif minecart.target.player.minecartjumpframe < 3
				minecart.target.frame = C
			elseif minecart.target.player.minecartjumpframe < 4
				minecart.target.frame = D
			elseif minecart.target.player.minecartjumpframe < 5
				minecart.target.frame = E
			else
				minecart.target.frame = F
			end
			if minecart.target.player.powers[pw_super]
				minecart.target.frame = $|FF_FULLBRIGHT
			end
		else
			minecart.target.state = S_PLAY_MODERNGRIND
			if leveltime & 2 and minecart.target.state != S_PLAY_SPRING
				minecart.target.frame = B
				if minecart.target.player.powers[pw_super]
					minecart.target.frame = $|FF_FULLBRIGHT
				end
			end
		end
		
		if P_IsObjectOnGround(minecart)
			if minecart.target.player.minecartboost == true
				P_InstaThrust(minecart, minecart.angle, 60*FRACUNIT)
			else
				local speed = FixedHypot(minecart.momx, minecart.momy)
				if speed > FixedMul(35*FRACUNIT, minecart.target.scale)
					P_InstaThrust(minecart, minecart.angle, min(speed*5/7,20*FRACUNIT))
				end
				minecart.target.player.boostregentimer = 4*TICRATE+1
			end
			if not S_SoundPlaying(minecart.target,sfx_grind) then
					S_StartSoundAtVolume(minecart.target,sfx_grind,191)
				end
		elseif minecart.target.player.minecartboost
			--minecart.target.player.minecartboost = false
			if S_SoundPlaying(minecart.target, sfx_grind)
				S_StopSoundByID(minecart.target, sfx_grind)
			end
			//local speed = FixedHypot(minecart.momx, minecart.momy)
			//if speed > FixedMul(20*FRACUNIT, minecart.target.scale)
			//	minecart.momx = $1*5/6
			//	minecart.momy = $1*5/6
			//end
		end
		
		if S_SoundPlaying(minecart, sfx_s3k51)
			if (minecart.eflags & MFE_UNDERWATER)
				if minecart.target.player.mysticsuper
					S_StartSound(minecart.target, sfx_bljpw)
				else
					if minecart.target.player.modernmenu.contents[6][6].value == 0
						S_StartSound(minecart.target, sfx_jumpwt)
					elseif minecart.target.player.modernmenu.contents[6][6].value == 1
						S_StartSound(minecart.target, sfx_jmpwt2)
					elseif minecart.target.player.modernmenu.contents[6][6].value == 2
						S_StartSound(minecart.target, sfx_jmpwt3)
						elseif minecart.target.player.modernmenu.contents[6][6].value == 3
						S_StartSound(minecart.target, sfx_jmpwt5)
					end
				end
			else
				if minecart.target.player.mysticsuper
					S_StartSound(minecart.target, sfx_bljp)
				else
					if minecart.target.player.modernmenu.contents[6][6].value == 0
						S_StartSound(minecart.target, sfx_mjump)
					elseif minecart.target.player.modernmenu.contents[6][6].value == 1
						S_StartSound(minecart.target, sfx_mjump2)
					elseif minecart.target.player.modernmenu.contents[6][6].value == 2
						S_StartSound(minecart.target, sfx_mjump3)
						elseif minecart.target.player.modernmenu.contents[6][6].value == 3
						S_StartSound(minecart.target, sfx_mjump5)
					end
				end
			end
			S_StopSoundByID(minecart, sfx_s3k51)
		end
		if S_SoundPlaying(minecart, sfx_s3k76)
			S_StopSoundByID(minecart, sfx_s3k76)
		end
		if S_SoundPlaying(minecart, sfx_s3k96)
			S_StopSoundByID(minecart, sfx_s3k96)
		end
		if minecart.target.player.cmd.buttons&BT_JUMP
			P_KillMobj(minecart)
		elseif minecart.target.player.cmd.buttons&BT_USE
		and not P_IsObjectOnGround(minecart)
			P_KillMobj(minecart)
		end
	end
end, MT_MINECART)

//Prevent Minecart death
addHook("MobjDeath", function(s, i, so)
	if s and s.valid and s.target and s.target.player and s.target.skin == "modernsonic" and s.target.health
		s.target.player.powers[pw_carry] = 0
		s.target.momx = s.momx
		s.target.momy = s.momy
		s.target.momz = s.momz
		if s.target.player.cmd.buttons&BT_JUMP
			s.target.player.justjumped = true
			P_DoJump(s.target.player)
		end
		s.target = nil
		s.state = S_NULL return true --
	end
end, MT_MINECART)

//borrowing from XSonic (Love ya Shine)
addHook("MobjThinker", function(s)
	if s.valid
		if (s.state != s.info.spawnstate)
		or (s.tics < 0)
		or (s.tics > 9999)	
			if not (s.modernsign)
				for m in mobjs.iterate(mobjs)
					if m and m.valid and (m.state==S_PLAY_SIGN) and not (m.type==MT_PLAYER) and not m.player
						local DIST = FixedHypot(s.x-m.x, s.y-m.y)
						if (DIST < 9<<16)					
							s.modernsign = m break --Topple, Launch, SMASH!!
						end
					end
				end	
			end
			if s.modernsign
				local t = s.modernsign
				if type(t)=="userdata" and t.valid and not (t.type==MT_PLAYER)
					if (t.state==S_PLAY_SIGN) and (t.skin=="modernsonic") 
						t.color = s.target.color
					end
				end
			end
		end
	end
end, MT_SIGN)