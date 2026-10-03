COM_AddCommand('Spawnobject', function(player, mo)
    
    local p = player
    
    if mo == nil 
        CONS_Printf(p, 'Spawnobject <mobj>: Spawnobject by using MT_*')
        CONS_Printf(p, 'Go to https://wiki.srb2.org/wiki/List_of_Object_types to get a list of Object Types.')
        return
    end
    
    mo = _G[string.upper(mo)]
     
    if mo == nil then 
        CONS_Printf(p, 'Sorry that does not exist.')
        return
    end
    
    if player.mo and player.mo.valid
        P_SpawnMobj(p.mo.x, p.mo.y, p.mo.z, mo)
    end
end)


COM_AddCommand('thokitem', function(player, mobj)
    if mobj == nil
        CONS_Printf(player, 'thokitem <ability>: Changes the thokitem.')
        return
    end
    
    mobj = _G[string.upper(mobj)]
    
    if mobj == nil
        CONS_Printf(player, 'Sorry. This isnt a thing.')
        return
    end

    if player.mo
        player.thokitem = mobj
    end
end)

COM_AddCommand('spinitem', function(player, mobj)
    if mobj == nil
        CONS_Printf(player, 'spinitem <ability>: Changes the spinitem.')
        return
    end
    
    mobj = _G[string.upper(mobj)]

    if mobj == nil
        CONS_Printf(player, 'Sorry. This isnt a thing.')
        return
    end
    
    if player.mo
        player.spinitem = mobj
    end
end)

COM_AddCommand('revitem', function(player, mobj)
    if mobj == nil
        CONS_Printf(player, 'revitem <ability>: Changes the revitem.')
        return
    end
    
    
    mobj = _G[string.upper(mobj)]
    
    if mobj == nil
        CONS_Printf(player, 'Sorry. This isnt a thing.')
        return
    end

    if player.mo
        player.revitem = mobj
    end
end)

COM_AddCommand('followitem', function(player, mobj)
    if mobj == nil
        CONS_Printf(player, 'followitem <ability>: Changes the followitem.')
        return
    end
    
    mobj = _G[string.upper(mobj)]
    
    if mobj == nil
        CONS_Printf(player, 'Sorry. This isnt a thing.')
        return
    end

    if player.mo
        player.followitem = mobj
    end
end)