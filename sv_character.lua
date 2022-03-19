ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


local CurrentVersion = '1.5.2'
local GameModeLinkeed = 'Linked_gamemode'

print('\n')
print('^2Linkeeed back ;)')
print('^2Linked_gamemode = ' .. GameModeLinkeed)
print('^7Ton personnage a ete charger...')
print('^7Version now ^1' .. CurrentVersion)
print('^7\n')

RegisterServerEvent('Linkeed:saveOof')
AddEventHandler('Linkeed:saveOof', function(sexe, prenom, nom, datedenaissance, taille)
    _source = source
    mySteamID = GetPlayerIdentifiers(_source)
    mySteam = mySteamID[1]

    MySQL.Async.execute('UPDATE users SET firstname = @firstname, lastname = @lastname, dateofbirth = @dateofbirth, sex = @sex, height = @height WHERE identifier = @identifier', {
      ['@identifier']        = mySteam,
      ['@firstname']        = prenom,
      ['@lastname']        = nom,
      ['@dateofbirth']    = datedenaissance,
      ['@sex']            = sexe,
      ['@height']            = taille
    }, function(rowsChanged)
      if callback then
        callback(true)
      end
    end)
end)