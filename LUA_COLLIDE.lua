local function InDeathAnimation(mo)
  local state = mo.info.deathstate
  while state
    if mo.state == state
      return true
    end
    state = states[state].nextstate
  end
end

--BLOOPS TODO: TRICKALT
local function DoTrickPose(mo, type)
	if type == 1
		mo.state = S_PLAY_TRICK_1 --trickposes[P_RandomRange(1, 19)]
	else
		mo.state = S_PLAY_TRICK_2 --trickposes[P_RandomRange(20, 36)]
		mo.player.jt = 4
	end
end

--GS: Fusing all the MobjMoveCollides, even though they're useless.
local function GIT(v) return _G[v] end local function TypeExists(v) return pcall(GIT, v) end

--GS: Making a player collide with an object is much better for performance than giving a ton of other objects a mobjcollide.
--Also, Spork! MobjMoveCollide is for objects moving into YOU! That hook only matters if you're standing still!
--Legend:
--s is player.mo
--v is the object we're touching.
--p is player
--This function accounts for MobjCollide and MobjMoveCollide at the same time, so I recommend you use it instead of making new hooks.

local function Modern_Collide(s,v)
	if not (s and s.skin=="modernsonic" and v and v.valid and s.player) return end --
	local p = s.player
	
	if v.player
		--nah
	elseif (v.flags & (MF_ENEMY|MF_BOSS)) --Enemy or boss!
		if (v.type==MT_SPRINGSHELL) --Contrary to what Spork believes, this is an enemy, not a spring!
			if (v.health > 0)
				local tmz = (v.eflags & MFE_VERTICALFLIP and -((s.z + s.height) or 1) or s.z)
				local tmznext = (v.eflags & MFE_VERTICALFLIP and -s.momz or s.momz) + tmz
				local thzh = (v.eflags & MFE_VERTICALFLIP and -(v.z or 1) or v.z + v.height)
				local sprarea = FixedMul(8*FRACUNIT, v.scale) * P_MobjFlip(v)
				if (((tmznext <= thzh) and (tmz > thzh)) or ((tmznext > thzh - sprarea) and (tmznext < thzh)))
					p.springlocktimer = 15
					if p.stomping == true
						--p.springheight = v.info.mass
						p.powers[pw_strong] = STR_SPRING
						--S_StartSound(mobj, sfx_sprong)
						p.doubledamage = false
						p.boostshake = 8
					end
					p.trickable = true
					--p.tricking = false
					p.trickcooldown = 0
					p.boostcanceltimer = 10
					p.customhoming = 0
					p.doublejumped = false
				end
			end
		elseif (s.z <= v.z + v.height) and (v.z <= s.z + s.height) and ((v.health or 0) > 0)
			if ( ((s.state>=S_PLAY_TRICKALT_1 and s.state<=S_PLAY_TRICKE_3) or (s.state==S_PLAY_HOPFALL and p.usedhomingattack==true)) and p.pflags & PF_JUMPED)
				if not ((s.state>=S_PLAY_TRICKALT_1) and (s.state<=S_PLAY_TRICKE_3))
				and not s.state ==S_PLAY_TRICK_1 and not s.state==S_PLAY_TRICK_2
					s.state = S_PLAY_JUMP
					S_StartSound(s, (s.eflags & MFE_UNDERWATER) and sfx_spnwtr or sfx_airspn)
				end
				p.pflags = ($|PF_JUMPED) & ~PF_NOJUMPDAMAGE
			end
			if (p.boosting==true or p.superboosting==true) and not p.footsweepattack
			or p.sliding==1 or s.state==S_PLAY_AIRBOOST	//Allows the boost to damage bosses and enemies with extra health
				if not (v.flags2 & MF2_FRET) and not v.flung
					if (v.flags & MF_BOSS) and v.health > 1
						if p.boosting == true or p.superboosting == true or p.airboost==true
							P_DamageMobj(v, s, s.target, 2)
						else
							P_DamageMobj(v, s, s.target, 1)
						end
						p.boostmeter = $1+3
						p.boosting = false
						p.airboost = false
						p.airboostheld = false
						P_InstaThrust(s, R_PointToAngle2(s.x, s.y, (s.x-s.momx), (s.y-s.momy)), p.speed)
						return false --
					end
					if (v.flags & MF_ENEMY) and v.health >= 2
						P_DamageMobj(v, s, s.target, 1)
						p.boosting = false
						p.airboost = false
						p.airboostheld = false
						P_InstaThrust(s, R_PointToAngle2(s.x, s.y, (s.x-s.momx), (s.y-s.momy)), p.speed)
						p.powers[pw_nocontrol] = 3
						return false --
					end
				end
			end			
		end
		return --
	elseif (v.flags & MF_MONITOR) //Allows boosting, lightdashing, and sliding into monitors to break them
		if (p.sliding == 1 or p.boosting == true or p.lightdashing > 0 or p.stomping == true or p.superboost == true)
			if not (s.z > v.z+v.height+(10*s.scale)) and not (v.z > s.z+s.height+(10*s.scale))
				local intable
				if p.gotthismonitor --Duke Fix
					for i, m in ipairs(p.gotthismonitor)
						if m==v intable = true break end
					end
				end	
				if v.health
				and not (p.ctfteam==1 and v.type==MT_RING_BLUEBOX)
				and not (p.ctfteam==2 and v.type==MT_RING_REDBOX)
				and (intable!=true) --Duke monitor fix
					P_KillMobj(v, s, s) return false --
				end
			end
		end	
		return --
	end
	
	local type = v.type or 0
	if type==MT_NIGHTSBUMPER or type==MT_PULLEYHANDLE
		if (s.z <= v.z + v.height) and (v.z <= s.z + s.height)
			if type==MT_NIGHTSBUMPER p.trickable = true end
			p.customhoming = 0
			p.rettarget = nil
		end
	elseif (type==MT_BALLOON)
		if v.state ~= v.info.deathstate and v.health and not (InDeathAnimation(v))
		and (s.z <= v.z + v.height) and (v.z <= s.z + s.height)
			if (p.speed > 40*s.scale)
				s.momy = $*5/15
				s.momx = $*5/15
			end
-- 			DoTrickPose(s, 1)
			HandleHomingEnd(s, 0)
			p.pflags = ($|PF_JUMPED) & ~PF_THOKKED
			p.justhitballoon = true
		end
	elseif (type==MT_STEAM)
		if (s.z <= v.z + v.height) and (v.z <= s.z + s.height)
			p.trickable = true
			--p.tricking = false
			p.trickcooldown = 0
		end
	elseif (v.flags & MF_SPRING) --Reset some actions when touching a spring
		if (s.z <= v.z + v.height) and (v.z <= s.z + s.height)
			if p.stomping == true
			or p.doubledamage == true
				--p.springheight = v.info.mass
				p.powers[pw_strong] = STR_SPRING
				if v.flags2 & MF2_OBJECTFLIP and P_MobjFlip(s) == 1
				or not (v.flags2 & MF2_OBJECTFLIP) and P_MobjFlip(s) == -1
					p.isspringflipped = true
				else
					p.springlocktimer = 15
					p.stomping = false
				end
				--S_StartSound(s, sfx_sprong)
				p.doubledamage = false
				p.boostshake = 8
				
			end
			p.trickable = true
			--p.tricking = false
			p.trickcooldown = 0
			p.doublejumped = false
			p.boostcanceltimer = 10
			p.customhoming = 0
			if not (v.info.damage)
				if p.usedhomingattack and p.cmd.forwardmove == 0 and p.cmd.sidemove == 0
					s.momx,s.momy = 0,0
					p.usedhomingattack = false
				end
			elseif v.info.mass
				p.boosting = false
			end
			if p.setcamspeed
				COM_BufInsertText(p, "cam_speed " + tostring(p.setcamspeed))
			end
		end
	elseif type==MT_EGGSHIELD
		if p.boosting == false and p.superboost == false and s.state ~= S_PLAY_AIRBOOST
		and not p.powers[pw_super]
		and not p.footsweepattack
			return --
		end
		if (s.z > v.z+v.height)
		or (v.z > s.z+s.height)
			return -- 
		else
			v.health = 0
			S_StartSound(s, sfx_wbreak)
			if p.rushmode > 0
				S_StartSound(s, sfx_rstrck)
			end
			SpawnFaker(v, p)
			S_IncrementModernChain(s, 1, 20)
			//P_KillMobj(v, s, s)
			P_KillMobj(v.target, s, s)
			//S_IncrementModernChain(s, 1, 5)
			//p.boostmeter = $1+2
			if p.rushmode > 0 then p.rushmode = $+(TICRATE/5) end
			return false --
		end
	elseif type==MT_SPIKE
		if p.stomping == false
		and p.boostheld == false 
		and p.superboost == false
		and (s.state ~= S_PLAY_SPRING or s.state ~= S_PLAY_AIRBOOST)
		or p.sliding
			return --
		end
		if (s.z > v.z+v.height*4)
		or (v.z > s.z+s.height*2)
			return --
		else
			v.health = 0
			S_StartSound(s, v.info.deathsound)
			P_KillMobj(v, s, s)
			S_IncrementModernChain(s, 1, 5)
			p.boostshake = 8
			p.boostmeter = $1+2
			if p.rushmode > 0 then p.rushmode = $+(TICRATE/5) end
			if (((p.cmd.buttons & BT_USE) and p.modernmenu.contents[2][2].value == 0) or ((p.cmd.buttons & BT_CUSTOM1) and p.modernmenu.contents[2][2].value == 1)) -- Actionswap
				p.stomping = true
			end
			return false --
		end	
	elseif type==MT_WALLSPIKE --vertical spike killer
		if p.boosting == false and p.superboost == false
		and (s.state!=S_PLAY_AIRBOOST)
			return --
		end
		if (s.z > v.z+v.height)
		or (v.z > s.z+s.height)
			return --
		else
			v.health = 0
			S_StartSound(s, v.info.deathsound)
			p.boostshake = 8
			P_KillMobj(v, s, s)
			S_IncrementModernChain(s, 1, 5)
			p.boostmeter = $1+2
			if p.rushmode > 0 then p.rushmode = $+(TICRATE/5) end
			return false --
		end		
	elseif type==MT_SALOONDOOR or type==MT_SALOONDOORCENTER
		if (s.state==S_PLAY_AIRBOOST or p.boosting==true or p.superboost==true) and not v.deadlol
			v.flags = $|MF_NOCLIP|MF_NOCLIPTHING
			if v.type==MT_SALOONDOOR
				P_KillMobj(v)
				S_StartSound(s,sfx_wbreak) S_StartSound(s,sfx_s3k59)
				S_IncrementModernChain(s, 5)
			else
				Thoksplosion(v)
				v.deadlol = true
			end
			return false --
		end
--	else --Anything else?
--	
	end
end


addHook("MobjCollide", Modern_Collide, MT_PLAYER) --This way, we apply a Mobj Collide and MobjMoveCollide at the same time!
addHook("MobjMoveCollide", Modern_Collide, MT_PLAYER)