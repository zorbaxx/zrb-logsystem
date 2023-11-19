function DiscordLog(color, name, message, footer)
	local embed = {
		{
		    ["color"] = color,
			["title"] = "***".. name .."***",
			["description"] = message,
			["footer"] = {
			    ["text"] = footer,
			},
		}
	}
	PerformHttpRequest(Config.WebHook, function(err, text, headers) end, 'POST', json.encode({username = Config.SenderName, embeds = embed}), { ['Content-Type'] = 'application/json' })
end

function IDExtract(id)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

  for i = 0, GetNumPlayerIdentifiers(id) - 1 do
      local playerID = GetPlayerIdentifier(id, i)

      if string.find(playerID, "steam") then
          identifiers.steam = playerID
      elseif string.find(playerID, "ip") then
          identifiers.ip = playerID
      elseif string.find(playerID, "live") then
          identifiers.live = playerID
      elseif string.find(playerID, "discord") then
          identifiers.discord = playerID
      elseif string.find(playerID, "license") then
          identifiers.license = playerID
      elseif string.find(playerID, "xbl") then
          identifiers.xbl = playerID
      end
  end

  return identifiers
end

RegisterCommand(Config.CommandToClaimLog, function(source, args)
    local x = ESX.GetPlayerFromId(source)
    local SourceGroup = x.getGroup()
    if SourceGroup == 'admin' then
        local Player = ESX.GetPlayerFromId(args[1])
        local Name = Player.getName()
        local AdminRank = Player.getGroup()
        local RockstarIdentifier = Player.getIdentifier()
        local CharIdentifier = Player.identifier
        local Money = Player.getMoney()
        local Bank = Player.getAccount('bank').money
        local Job = Player.getJob()
        local LineaTrabajo = Job.label.." - "..Job.grade_label.." | Salario: "..Job.grade_salary.." "..Config.ServerCurrency..""
        local Accounts = Player.getAccounts()
        local Inventario = Player.getInventory()
        local WeightInv = Player.getWeight()
        local Coords = Player.getCoords(true)
        local NombreAdmin = GetPlayerName(source)
        local Identificadores = IDExtract(args[1])
        local Discord = "<@"..Identificadores.discord:gsub("discord:", "")..">"
        local Steam = Identificadores.steam
        local Live = Identificadores.live
        local XBL = Identificadores.xbl
        local IP = Identificadores.ip
        local License = Identificadores.license

        local mensajeLog = "***Informacion del Personaje***\n-\n***Nombre IC***: "..Name.."\n***Rango***: "..AdminRank.."\n***Char Identifier***: "..CharIdentifier.."\n***Dinero en Mano***: "..Money.." "..Config.ServerCurrency.."\n***Dinero en Banco***: "..Bank.." "..Config.ServerCurrency.."\n***Trabajo***: "..LineaTrabajo.."\n***Peso en Inventario***: "..WeightInv.." gramos\n***Coordenadas Actuales***: "..Coords.."\n\n***Identificadores Externos***\n-\n***Steam***: "..Steam.."\n***Live***: "..Live.."\n***XBL***: "..XBL.."\n***IP***: "..IP.."\n***Licencia***: "..License.."\n***Discord***: "..Discord..""

        if next(Inventario) ~= nil then
            local listaInventario = {}

            for _, o in pairs(Inventario) do
                local NombreObjeto = o.label
                local CantidadObjeto = o.count
                local PesoObjeto = o.weight
                local LineaInventario = "***Objeto***: "..NombreObjeto.." | ***Cantidad del Objeto***: "..CantidadObjeto.." | ***Peso del Objeto***: "..PesoObjeto.." gramos"
            
                table.insert(listaInventario, LineaInventario)
            end

            mensajeLog = mensajeLog .. "\n\n***Inventario:***\n" .. table.concat(listaInventario, "\n")
        end

        if next(Accounts) ~= nil then
            local listaCuentas = {}

            for k, v in pairs(Accounts) do
                local DineroCuentas = Player.getAccount(v.name).money
                local CuentaSeleccionada = v.label
                local LineaCuenta = "***Cuenta***: "..CuentaSeleccionada.." | ***Dinero en la cuenta***: "..DineroCuentas.." "..Config.ServerCurrency..""
            
                table.insert(listaCuentas, LineaCuenta)
            end

            mensajeLog = mensajeLog .. "\n\n***Cuentas:***\n" .. table.concat(listaCuentas, "\n")
        end

        DiscordLog(Config.EmbedColor, "ZRB-LogSystem", mensajeLog, "Log reclamado con el comando: "..Config.CommandToClaimLog.." por: "..NombreAdmin.."")
        x.showNotification('Información enviada al canal seleccionado de Discord')
    else
        x.showNotification('No tienes permiso para utilizar este comando')
    end
end)

RegisterCommand(Config.CommandCheckItem, function(source, args)
    local x = ESX.GetPlayerFromId(source)
    local SourceGroup = x.getGroup()
    if SourceGroup == 'admin' then
        local Player = ESX.GetPlayerFromId(args[1])
        local Item = tostring(args[2])
        local HasItem = Player.hasItem(Item)
        local NombreAdmin = GetPlayerName(source)
        if HasItem.count ~= 0 then
            DiscordLog(Config.EmbedColor, "ZRB-LogSystem", 'Se ha encontrado el objeto en el inventario del jugador, tiene: ***'..HasItem.count..'*** - ***'..HasItem.label..'***', "Log reclamado con el comando: "..Config.CommandCheckItem.." por: "..NombreAdmin.."")
            x.showNotification('Información enviada al canal seleccionado de Discord')
        else
            x.showNotification('No se ha encontrado ningun objeto en ese jugador')
        end
    else
        x.showNotification('No tienes permiso para utilizar este comando')
    end
end)