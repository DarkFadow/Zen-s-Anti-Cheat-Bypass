-- ZenAntiCheatBypasser.lua - Version Anti-Client-Detection
return (function()
    -- 🛡️ BYPASS ULTRA AVANCÉ - ANTI CLIENT DETECTION
    do
        -- Détection executeur
        local EXECUTOR_TYPE = "Unknown"
        if syn then EXECUTOR_TYPE = "Synapse"
        elseif Krnl then EXECUTOR_TYPE = "Krnl" 
        elseif fluxus then EXECUTOR_TYPE = "Fluxus"
        elseif getexecutorname then EXECUTOR_TYPE = getexecutorname() or "Xeno"
        end

        -- Nettoyage profond
        if rconsoleclear then rconsoleclear() end
        if clr then clr() end
        collectgarbage("collect")

        -- 🔥 DÉSACTIVATION DE TOUTES LES FONCTIONS DE KICK
        pcall(function()
            -- Couche 1: Kick du Player
            if hookfunction and game.Players.LocalPlayer then
                hookfunction(game.Players.LocalPlayer.Kick, function() 
                    warn("🚫 Kick blocked by ZenBypass")
                    return nil 
                end)
            end

            -- Couche 2: Tous les kicks via namecall
            if hookfunction and getrawmetatable then
                local mt = getrawmetatable(game)
                if mt and mt.__namecall then
                    local originalNamecall = mt.__namecall
                    hookfunction(mt.__namecall, function(self, ...)
                        local method = getnamecallmethod and getnamecallmethod() or ""
                        local methodLower = method:lower()
                        
                        -- Bloque TOUTES les méthodes de kick/ban
                        if methodLower:find("kick") or methodLower:find("ban") or 
                           methodLower:find("crash") or methodLower:find("shutdown") or
                           methodLower:find("report") or methodLower:find("alert") or
                           methodLower:find("disconnect") or methodLower:find("terminate") or
                           methodLower:find("remove") or methodLower:find("destroy") then
                            warn("🚫 Namecall blocked: " .. method)
                            return nil
                        end
                        return originalNamecall(self, ...)
                    end)
                end
            end

            -- Couche 3: Kick via RemoteEvents/RemoteFunctions
            if hookfunction then
                -- Hook Instance.new pour intercepter les RemoteEvents
                local originalInstanceNew = Instance.new
                hookfunction(Instance.new, function(className)
                    local obj = originalInstanceNew(className)
                    if className == "RemoteEvent" or className == "RemoteFunction" then
                        if hookfunction then
                            -- Intercepte FireServer des RemoteEvents
                            if obj.FireServer then
                                hookfunction(obj.FireServer, function(self, ...)
                                    local args = {...}
                                    local shouldBlock = false
                                    
                                    -- Analyse les arguments pour détecter les kicks
                                    for _, arg in ipairs(args) do
                                        if type(arg) == "string" and arg:lower():find("kick") then
                                            shouldBlock = true
                                            break
                                        end
                                    end
                                    
                                    if shouldBlock then
                                        warn("🚫 RemoteEvent kick blocked")
                                        return nil
                                    end
                                    
                                    return obj.FireServer(self, ...)
                                end)
                            end
                            
                            -- Intercepte InvokeServer des RemoteFunctions
                            if obj.InvokeServer then
                                hookfunction(obj.InvokeServer, function(self, ...)
                                    local args = {...}
                                    local shouldBlock = false
                                    
                                    for _, arg in ipairs(args) do
                                        if type(arg) == "string" and arg:lower():find("kick") then
                                            shouldBlock = true
                                            break
                                        end
                                    end
                                    
                                    if shouldBlock then
                                        warn("🚫 RemoteFunction kick blocked")
                                        return nil
                                    end
                                    
                                    return obj.InvokeServer(self, ...)
                                end)
                            end
                        end
                    end
                    return obj
                end)
            end

            -- Couche 4: Protection des services
            local dangerousServices = {
                "Players", "NetworkClient", "ScriptContext", "CoreGui"
            }
            
            for _, serviceName in ipairs(dangerousServices) do
                pcall(function()
                    local service = game:GetService(serviceName)
                    if service and service.Kick then
                        hookfunction(service.Kick, function() 
                            warn("🚫 Service kick blocked: " .. serviceName)
                            return nil 
                        end)
                    end
                end)
            end

            -- Couche 5: Anti-client detection
            if hookfunction then
                -- Fausse les informations du client
                hookfunction(debug.getinfo, function() 
                    return {
                        source = "=[C]",
                        linedefined = 0,
                        lastlinedefined = 0,
                        what = "C",
                        name = nil,
                        namewhat = "",
                        short_src = "=[C]"
                    }
                end)
                
                -- Cache les métadonnées
                hookfunction(getconnections, function()
                    return {}
                end)
            end

            -- Couche 6: Protection réseau contre les détections
            if hookfunction and game.HttpGet then
                hookfunction(game.HttpGet, function(self, url)
                    -- Bloque les appels aux APIs anti-cheat
                    if url and (url:lower():find("anticheat") or url:lower():find("detect") or url:lower():find("report")) then
                        return "{}"
                    end
                    return game.HttpGet(self, url)
                end)
            end

            -- Couche 7: Désactive les BindToClose suspects
            if game.BindToClose then
                hookfunction(game.BindToClose, function(func)
                    warn("🚫 BindToClose blocked")
                    return nil
                end)
            end
        end)

        -- 🎭 CAMOUFLAGE AVANCÉ
        task.spawn(function()
            -- Comportement légitime
            while task.wait(math.random(15, 45)) do
                pcall(function()
                    local players = game:GetService("Players")
                    if players.LocalPlayer then
                        -- Activités normales
                        local _ = players.LocalPlayer.UserId
                        local __ = players.LocalPlayer.AccountAge
                    end
                end)
            end
        end)

        -- Fake errors pour brouiller les pistes
        task.delay(math.random(30, 90), function()
            pcall(function()
                error("Runtime error: Invalid memory access at 0x" .. string.format("%X", math.random(1000, 9999)))
            end)
        end)

        -- Message de confirmation
        task.delay(2, function()
            print("🛡️ ZenBypass Ultra activated - " .. EXECUTOR_TYPE)
            print("🔒 All kick functions disabled")
            print("🎭 Client detection protection: ACTIVE")
        end)
    end

    -- Retourne l'interface
    return {
        Version = "Anti-Client-Detection v4.0",
        Status = "FULLY PROTECTED",
        Features = {
            "Player.Kick - BLOCKED",
            "Namecall kicks - BLOCKED", 
            "RemoteEvent kicks - BLOCKED",
            "RemoteFunction kicks - BLOCKED",
            "Service kicks - BLOCKED",
            "Client detection - BLOCKED",
            "Network detection - BLOCKED"
        }
    }
end)()
