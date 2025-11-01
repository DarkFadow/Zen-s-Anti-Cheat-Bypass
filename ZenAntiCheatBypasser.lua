-- ZEN ANTICHEAT BYPASSER - PROTECTION CIBLÉE (CORRIGÉE)
do
    -- 🔧 Détection executeur
    local EXECUTOR_TYPE = "Unknown"
    if syn then 
        EXECUTOR_TYPE = "Synapse"
    elseif Krnl then 
        EXECUTOR_TYPE = "Krnl" 
    elseif fluxus then 
        EXECUTOR_TYPE = "Fluxus"
    end

    -- 🛡️ Nettoyage compatible Roblox
    local function Clean()
        if rconsoleclear then 
            rconsoleclear() 
        end
        
        if gcinfo then
            gcinfo()
        end
    end

    -- 🔒 Hooks de protection UNIQUEMENT pour le script actuel
    local function InstallLocalHooks()
        -- Protection anti-kick SEULEMENT pour ce script
        pcall(function()
            if hookfunction and game.Players.LocalPlayer then
                local originalKick = game.Players.LocalPlayer.Kick
                hookfunction(originalKick, function(self, ...)
                    -- Vérifie si l'appel vient de notre script
                    local stack = debug.traceback()
                    if stack:find("ZenAntiCheatBypasser") or stack:find("ZEN AUTO-PROTECTION") then
                        return nil -- Bloque seulement pour notre script
                    end
                    return originalKick(self, ...)
                end)
            end
        end)
        
        -- Protection namecall CIBLÉE
        pcall(function()
            if hookfunction and getrawmetatable then
                local mt = getrawmetatable(game)
                if mt and mt.__namecall then
                    local originalNamecall = mt.__namecall
                    hookfunction(mt.__namecall, function(self, ...)
                        local method = getnamecallmethod and getnamecallmethod() or ""
                        local methodLower = method:lower()
                        
                        -- Vérifie si l'appel vient de notre contexte
                        local stack = debug.traceback()
                        local isOurScript = stack:find("ZenAntiCheatBypasser") or stack:find("ZEN AUTO-PROTECTION")
                        
                        if isOurScript and (methodLower:find("kick") or methodLower:find("ban")) then
                            return nil
                        end
                        
                        return originalNamecall(self, ...)
                    end)
                end
            end
        end)
    end

    -- 🛡️ PROTECTION UNIQUEMENT DU SCRIPT COURANT
    local function ProtectCurrentScript()
        -- Crée un environnement sécurisé SEULEMENT pour ce script
        local secureEnv = {
            print = print,
            warn = warn,
            error = error,
            task = task,
            game = game,
            _G = _G,
            script = script
        }
        
        -- Injecte la protection directement dans le contexte actuel
        pcall(function()
            -- Protection anti-detection locale
            if hookfunction then
                hookfunction(debug.getinfo, function(func)
                    local info = {
                        source = "=[C]",
                        linedefined = 0,
                        lastlinedefined = 0,
                        what = "C",
                        name = nil,
                        namewhat = "",
                        short_src = "=[C]"
                    }
                    return info
                end)
            end
        end)
        
        return secureEnv
    end

    -- 🔄 INTERCEPTION UNIQUEMENT POUR LE SCRIPT QUI NOUS CHARGE
    local function SetupTargetedInterception()
        -- Sauvegarde l'environnement original
        local originalLoadstring = loadstring
        
        -- Override loadstring POUR CE SCRIPT SEULEMENT
        getgenv().loadstring = function(code)
            if not code or type(code) ~= "string" then
                return originalLoadstring(code)
            end
            
            -- Vérifie si c'est NOTRE script qui charge du code
            local stack = debug.traceback()
            local isOurLoader = stack:find("ZenAntiCheatBypasser") or stack:find("ZEN AUTO-PROTECTION")
            
            if isOurLoader then
                -- Injection de protection UNIQUEMENT pour le code chargé par NOTRE script
                local protectionHeader = [[
                    -- ZEN AUTO-PROTECTION INJECTED
                    do
                        -- Protection locale pour ce script seulement
                        pcall(function()
                            if hookfunction and game.Players.LocalPlayer then
                                local originalKick = game.Players.LocalPlayer.Kick
                                hookfunction(originalKick, function(self, ...)
                                    local stack = debug.traceback()
                                    if stack:find("ZEN AUTO-PROTECTION") then
                                        return nil
                                    end
                                    return originalKick(self, ...)
                                end)
                            end
                        end)
                        
                        -- Environnement sécurisé local
                        local _ZenProtected = true
                    end
                    
                    -- CODE UTILISATEUR ORIGINAL CI-DESSOUS
                ]]
                
                local protectedCode = protectionHeader .. "\n" .. code
                return originalLoadstring(protectedCode)
            else
                -- Pour les autres scripts, pas de protection
                return originalLoadstring(code)
            end
        end
    end

    -- 🎯 Messages F9 discrets
    local function ShowMessages()
        task.delay(1, function()
            print("Script service initialized")
        end)
        
        task.delay(2, function()
            warn("Core modules loaded")
        end)
        
        task.delay(3, function()
            print("System: Operational")
        end)
        
        -- Message de confirmation Zen (discret)
        task.delay(4, function()
            warn("Zen: Local protection active")
        end)
    end

    -- ⚡ EXÉCUTION PRINCIPALE - PROTECTION CIBLÉE
    Clean()
    InstallLocalHooks()
    ProtectCurrentScript()
    SetupTargetedInterception()
    ShowMessages()
    
    print("✅ Zen protection active for this script only")
    
    -- Protection continue UNIQUEMENT pour ce script (CORRIGÉ)
    task.spawn(function()
        local protectionActive = true
        while protectionActive and task.wait(15) do
            pcall(function()
                -- Vérification que notre protection est toujours active
                local stack = debug.traceback()
                if not stack:find("ZenAntiCheatBypasser") then
                    -- Notre script a été déchargé, on arrête la protection
                    protectionActive = false
                end
            end)
        end
    end)
end
