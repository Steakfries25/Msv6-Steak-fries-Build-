--I Wish i was good at math

local animaltable = {
[1] = {'FL13', 'FL03', 'FL06', 'FL02', 'FL11', 'FL15', 'FL16', 'FL01', 'FL14', 'FL07', 'FL05', 'FL10', 'FL09', 'FL12'},
}

addHook("ThinkFrame", do
	for player in players.iterate
		if player.mo and player.mo.skin == "modernsonic"
			--print(player.animal1sprite)
			/*player.normalspeed = 0
			if player.cmd.sidemove > 0
				player.centeranimalposition = $+1
			elseif player.cmd.sidemove < 0
				player.centeranimalposition = $-1
			end
			if player.cmd.forwardmove > 0
				player.animal1_yposition = $-1
			elseif player.cmd.forwardmove < 0
				player.animal1_yposition = $+1
			end*/
			local spritelist = animaltable[1] -- get the list of sounds for the sound type
			if player.animal1_yposition == 240
				local sprite1 = spritelist[P_RandomKey(#spritelist) + 1] -- choose a sound from the list
				player.animal1sprite = sprite1
			end
			if player.animal2_yposition == 240
				local sprite2 = spritelist[P_RandomKey(#spritelist) + 1] -- choose a sound from the list
				local sprite3 = spritelist[P_RandomKey(#spritelist) + 1] -- choose a sound from the list
				player.animal2sprite = sprite2
				player.animal3sprite = sprite3
			end
			if player.animal3_yposition == 240
				local sprite4 = spritelist[P_RandomKey(#spritelist) + 1] -- choose a sound from the list
				local sprite5 = spritelist[P_RandomKey(#spritelist) + 1] -- choose a sound from the list
				player.animal4sprite = sprite4
				player.animal5sprite = sprite5
			end
			if player.animal4_yposition == 240	
				local sprite6 = spritelist[P_RandomKey(#spritelist) + 1] -- choose a sound from the list
				local sprite7 = spritelist[P_RandomKey(#spritelist) + 1] -- choose a sound from the list
				player.animal6sprite = sprite6
				player.animal7sprite = sprite7
			end
			
			//Animal 1
			--if player.cmd.buttons & BT_CUSTOM3
			--	if player.upanddownanimal1 == 0
				--	player.upanddownanimal1 = 1
				--end
			--end
			if player.animal1_yposition >= 240
			and player.upanddownanimal1 == 2
				player.upanddownanimal1 = 0
				player.animal1_yposition = 240
			end
			if player.animal1_yposition == 140
			and player.upanddownanimal1 == 1
				player.upanddownanimal1 = 2
			end
			if player.upanddownanimal1 == 1
				if player.animal1_yposition < 141
					if leveltime % 2 == 1
						player.animal1_yposition = $-1
					end
				elseif player.animal1_yposition <= 144
					player.animal1_yposition = $-1
				elseif player.animal1_yposition < 148
					player.animal1_yposition = $-2
				elseif player.animal1_yposition < 160
					player.animal1_yposition = $-4
				else
					player.animal1_yposition = $-8
				end
				if player.animal1_yposition == 176
					player.upanddownanimal2 = 1
				end
			end
			if player.upanddownanimal1 == 2
				if player.animal1_yposition < 141
					if leveltime % 2 == 1
						player.animal1_yposition = $+1
					end
				elseif player.animal1_yposition <= 144
					player.animal1_yposition = $+1
				elseif player.animal1_yposition < 148
					player.animal1_yposition = $+2
				elseif player.animal1_yposition < 160
					player.animal1_yposition = $+4
				else
					player.animal1_yposition = $+8
				end
			end
			
			//Animal 2
			if player.animal2_yposition >= 240
			and player.upanddownanimal2 == 2
				player.upanddownanimal2 = 0
				player.animal2_yposition = 240
			end
			if player.animal2_yposition == 140
			and player.upanddownanimal2 == 1
				player.upanddownanimal2 = 2
			end
			if player.upanddownanimal2 == 1
				if player.animal2_yposition < 141
					if leveltime % 2 == 1
						player.animal2_yposition = $-1
					end
				elseif player.animal2_yposition <= 144
					player.animal2_yposition = $-1
				elseif player.animal2_yposition < 148
					player.animal2_yposition = $-2
				elseif player.animal2_yposition < 160
					player.animal2_yposition = $-4
				else
					player.animal2_yposition = $-8
				end
				if player.animal2_yposition == 176
				and player.trickcount >= 5
					player.upanddownanimal3 = 1
				end
			end
			if player.upanddownanimal2 == 2
				if player.animal2_yposition < 141
					if leveltime % 2 == 1
						player.animal2_yposition = $+1
					end
				elseif player.animal2_yposition <= 144
					player.animal2_yposition = $+1
				elseif player.animal2_yposition < 148
					player.animal2_yposition = $+2
				elseif player.animal2_yposition < 160
					player.animal2_yposition = $+4
				else
					player.animal2_yposition = $+8
				end
			end
			
			//Animal 3
			if player.animal3_yposition >= 240
			and player.upanddownanimal3 == 2
				player.upanddownanimal3 = 0
				player.animal3_yposition = 240
			end
			if player.animal3_yposition == 140
			and player.upanddownanimal3 == 1
				player.upanddownanimal3 = 2
			end
			if player.upanddownanimal3 == 1
				if player.animal3_yposition < 141
					if leveltime % 2 == 1
						player.animal3_yposition = $-1
					end
				elseif player.animal3_yposition <= 144
					player.animal3_yposition = $-1
				elseif player.animal3_yposition < 148
					player.animal3_yposition = $-2
				elseif player.animal3_yposition < 160
					player.animal3_yposition = $-4
				else
					player.animal3_yposition = $-8
				end
				if player.animal3_yposition == 176
				and player.trickcount >= 10
					player.upanddownanimal4 = 1
				end
			end
			if player.upanddownanimal3 == 2
				if player.animal3_yposition < 141
					if leveltime % 2 == 1
						player.animal3_yposition = $+1
					end
				elseif player.animal3_yposition <= 144
					player.animal3_yposition = $+1
				elseif player.animal3_yposition < 148
					player.animal3_yposition = $+2
				elseif player.animal3_yposition < 160
					player.animal3_yposition = $+4
				else
					player.animal3_yposition = $+8
				end
			end
			
			//Animal 4
			if player.animal4_yposition >= 240
			and player.upanddownanimal4 == 2
				player.upanddownanimal4 = 0
				player.animal4_yposition = 240
			end
			if player.animal4_yposition == 140
			and player.upanddownanimal4 == 1
				player.upanddownanimal4 = 2
			end
			if player.upanddownanimal4 == 1
				if player.animal4_yposition < 141
					if leveltime % 2 == 1
						player.animal4_yposition = $-1
					end
				elseif player.animal4_yposition <= 144
					player.animal4_yposition = $-1
				elseif player.animal4_yposition < 148
					player.animal4_yposition = $-2
				elseif player.animal4_yposition < 160
					player.animal4_yposition = $-4
				else
					player.animal4_yposition = $-8
				end
			end
			if player.upanddownanimal4 == 2
				if player.animal4_yposition < 141
					if leveltime % 2 == 1
						player.animal4_yposition = $+1
					end
				elseif player.animal4_yposition <= 144
					player.animal4_yposition = $+1
				elseif player.animal4_yposition < 148
					player.animal4_yposition = $+2
				elseif player.animal4_yposition < 160
					player.animal4_yposition = $+4
				else
					player.animal4_yposition = $+8
				end
			end
		end
	end
end)

--160 = center of screen
--224 = just below bottom of screen. Use 240 for multiples of 10
--140 = height i want animals to reach before going back down


local function trickhud(v, player, camera)
    if player.mo and player.mo.skin == "modernsonic"
	and player.modernmenu.contents[3][3].value == 1
	and player.centeranimalposition
	and player.animal1sprite
	--and player.animal2sprite
	--and player.animal2sprite
	--and player.animal2sprite
	--and player.animal2sprite
	--and player.animal2sprite
	--and player.animal2sprite
		--v.drawString(300, 0, 'y = '.. (player.animal1_yposition))
		--v.drawString(300, 10, 'x = '.. (player.centeranimalposition))
		
		--Center Animal
		v.drawScaled(player.centeranimalposition*FU, player.animal1_yposition*FU, FU*4/3, v.getSpritePatch(player.animal1sprite, A, 1), V_SNAPTOBOTTOM|V_PERPLAYER|V_HUDTRANS)
		--Left Animal 1
		v.drawScaled(player.centeranimalposition*FU -40*FU, player.animal2_yposition*FU, FU*4/3, v.getSpritePatch(player.animal2sprite, A, 1), V_SNAPTOBOTTOM|V_PERPLAYER|V_HUDTRANS) 
		--Right Animal 1
		v.drawScaled(player.centeranimalposition*FU +40*FU, player.animal2_yposition*FU, FU*4/3, v.getSpritePatch(player.animal3sprite, A, 1), V_SNAPTOBOTTOM|V_PERPLAYER|V_HUDTRANS) 
		
		--Left Animal 2
		v.drawScaled(player.centeranimalposition*FU -80*FU, player.animal3_yposition*FU, FU*4/3, v.getSpritePatch(player.animal4sprite, A, 1), V_SNAPTOBOTTOM|V_PERPLAYER|V_HUDTRANS) 
		--Right Animal 2
		v.drawScaled(player.centeranimalposition*FU +80*FU, player.animal3_yposition*FU, FU*4/3, v.getSpritePatch(player.animal5sprite, A, 1), V_SNAPTOBOTTOM|V_PERPLAYER|V_HUDTRANS) 
		
		--Left Animal 3
		v.drawScaled(player.centeranimalposition*FU -120*FU, player.animal4_yposition*FU, FU*4/3, v.getSpritePatch(player.animal6sprite, A, 1), V_SNAPTOBOTTOM|V_PERPLAYER|V_HUDTRANS) 
		--Right Animal 3
		v.drawScaled(player.centeranimalposition*FU +120*FU, player.animal4_yposition*FU, FU*4/3, v.getSpritePatch(player.animal7sprite, A, 1), V_SNAPTOBOTTOM|V_PERPLAYER|V_HUDTRANS) 
    
		
		--Trick Text
		if player.tricktexttimer
			if player.tricktext == 1
				if player.tricktexttimer >= 10
					v.drawScaled(160*FU, 80*FU, FU*3/4, v.cachePatch("MTRCK1"), V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
				elseif player.tricktexttimer == 9
					v.drawScaled(160*FU, 80*FU, FU*3/4, v.cachePatch("MTRCK1"), V_10TRANS|V_SNAPTOTOP|V_PERPLAYER)
				elseif player.tricktexttimer == 8
					v.drawScaled(160*FU, 80*FU, FU*3/4, v.cachePatch("MTRCK1"), V_20TRANS|V_SNAPTOTOP|V_PERPLAYER)
				elseif player.tricktexttimer == 7
					v.drawScaled(160*FU, 80*FU, FU*3/4, v.cachePatch("MTRCK1"), V_30TRANS|V_SNAPTOTOP|V_PERPLAYER)
				elseif player.tricktexttimer == 6
					v.drawScaled(160*FU, 80*FU, FU*3/4, v.cachePatch("MTRCK1"), V_40TRANS|V_SNAPTOTOP|V_PERPLAYER)
				elseif player.tricktexttimer == 5
					v.drawScaled(160*FU, 80*FU, FU*3/4, v.cachePatch("MTRCK1"), V_50TRANS|V_SNAPTOTOP|V_PERPLAYER)
				elseif player.tricktexttimer == 4 
					v.drawScaled(160*FU, 80*FU, FU*3/4, v.cachePatch("MTRCK1"), V_60TRANS|V_SNAPTOTOP|V_PERPLAYER)
				elseif player.tricktexttimer == 3
					v.drawScaled(160*FU, 80*FU, FU*3/4, v.cachePatch("MTRCK1"), V_70TRANS|V_SNAPTOTOP|V_PERPLAYER)
				elseif player.tricktexttimer == 2
					v.drawScaled(160*FU, 80*FU, FU*3/4, v.cachePatch("MTRCK1"), V_80TRANS|V_SNAPTOTOP|V_PERPLAYER)
				elseif player.tricktexttimer == 1
					v.drawScaled(160*FU, 80*FU, FU*3/4, v.cachePatch("MTRCK1"), V_90TRANS|V_SNAPTOTOP|V_PERPLAYER)
				end
			elseif player.tricktext == 2
				if player.tricktexttimer >= 10
					v.drawScaled(160*FU, 80*FU, FU*3/4, v.cachePatch("MTRCK2"), V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
				elseif player.tricktexttimer == 9
					v.drawScaled(160*FU, 80*FU, FU*3/4, v.cachePatch("MTRCK2"), V_10TRANS|V_SNAPTOTOP|V_PERPLAYER)
				elseif player.tricktexttimer == 8
					v.drawScaled(160*FU, 80*FU, FU*3/4, v.cachePatch("MTRCK2"), V_20TRANS|V_SNAPTOTOP|V_PERPLAYER)
				elseif player.tricktexttimer == 7
					v.drawScaled(160*FU, 80*FU, FU*3/4, v.cachePatch("MTRCK2"), V_30TRANS|V_SNAPTOTOP|V_PERPLAYER)
				elseif player.tricktexttimer == 6
					v.drawScaled(160*FU, 80*FU, FU*3/4, v.cachePatch("MTRCK2"), V_40TRANS|V_SNAPTOTOP|V_PERPLAYER)
				elseif player.tricktexttimer == 5
					v.drawScaled(160*FU, 80*FU, FU*3/4, v.cachePatch("MTRCK2"), V_50TRANS|V_SNAPTOTOP|V_PERPLAYER)
				elseif player.tricktexttimer == 4 
					v.drawScaled(160*FU, 80*FU, FU*3/4, v.cachePatch("MTRCK2"), V_60TRANS|V_SNAPTOTOP|V_PERPLAYER)
				elseif player.tricktexttimer == 3
					v.drawScaled(160*FU, 80*FU, FU*3/4, v.cachePatch("MTRCK2"), V_70TRANS|V_SNAPTOTOP|V_PERPLAYER)
				elseif player.tricktexttimer == 2
					v.drawScaled(160*FU, 80*FU, FU*3/4, v.cachePatch("MTRCK2"), V_80TRANS|V_SNAPTOTOP|V_PERPLAYER)
				elseif player.tricktexttimer == 1
					v.drawScaled(160*FU, 80*FU, FU*3/4, v.cachePatch("MTRCK2"), V_90TRANS|V_SNAPTOTOP|V_PERPLAYER)
				end
			elseif player.tricktext == 3
				if player.tricktexttimer >= 10
					v.drawScaled(160*FU, 80*FU, FU*3/4, v.cachePatch("MTRCK3"), V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
				elseif player.tricktexttimer == 9
					v.drawScaled(160*FU, 80*FU, FU*3/4, v.cachePatch("MTRCK3"), V_10TRANS|V_SNAPTOTOP|V_PERPLAYER)
				elseif player.tricktexttimer == 8
					v.drawScaled(160*FU, 80*FU, FU*3/4, v.cachePatch("MTRCK3"), V_20TRANS|V_SNAPTOTOP|V_PERPLAYER)
				elseif player.tricktexttimer == 7
					v.drawScaled(160*FU, 80*FU, FU*3/4, v.cachePatch("MTRCK3"), V_30TRANS|V_SNAPTOTOP|V_PERPLAYER)
				elseif player.tricktexttimer == 6
					v.drawScaled(160*FU, 80*FU, FU*3/4, v.cachePatch("MTRCK3"), V_40TRANS|V_SNAPTOTOP|V_PERPLAYER)
				elseif player.tricktexttimer == 5
					v.drawScaled(160*FU, 80*FU, FU*3/4, v.cachePatch("MTRCK3"), V_50TRANS|V_SNAPTOTOP|V_PERPLAYER)
				elseif player.tricktexttimer == 4 
					v.drawScaled(160*FU, 80*FU, FU*3/4, v.cachePatch("MTRCK3"), V_60TRANS|V_SNAPTOTOP|V_PERPLAYER)
				elseif player.tricktexttimer == 3
					v.drawScaled(160*FU, 80*FU, FU*3/4, v.cachePatch("MTRCK3"), V_70TRANS|V_SNAPTOTOP|V_PERPLAYER)
				elseif player.tricktexttimer == 2
					v.drawScaled(160*FU, 80*FU, FU*3/4, v.cachePatch("MTRCK3"), V_80TRANS|V_SNAPTOTOP|V_PERPLAYER)
				elseif player.tricktexttimer == 1
					v.drawScaled(160*FU, 80*FU, FU*3/4, v.cachePatch("MTRCK3"), V_90TRANS|V_SNAPTOTOP|V_PERPLAYER)
				end
			end
		end
	end
end
hud.add(trickhud)
		