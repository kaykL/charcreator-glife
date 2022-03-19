
ESX								= nil
isRegistered = nil

local sexeSelect = 0
local teteSelect = 0
local colorPeauSelect = 0
local cheveuxSelect = 0
local bebarSelect = -1
local poilsCouleurSelect = 0
local ImperfectionsPeau = 0
local face, acne, skin, eyecolor, skinproblem, freckle, wrinkle, hair, haircolor, eyebrow, beard, beardcolor


function LoadingPrompt(loadingText, spinnerType)

    if IsLoadingPromptBeingDisplayed() then
        RemoveLoadingPrompt()
    end

    if (loadingText == nil) then
        BeginTextCommandBusyString(nil)
    else
        BeginTextCommandBusyString("STRING");
        AddTextComponentSubstringPlayerName(loadingText);
    end

    EndTextCommandBusyString(spinnerType)
end

ESX = nil
PMenu = {}
PMenu.Data = {}



Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function LoadingPrompt(loadingText, spinnerType)

    if IsLoadingPromptBeingDisplayed() then
        RemoveLoadingPrompt()
    end

    if (loadingText == nil) then
        BeginTextCommandBusyString(nil)
    else
        BeginTextCommandBusyString("STRING");
        AddTextComponentSubstringPlayerName(loadingText);
    end

    EndTextCommandBusyString(spinnerType)
end

function openCinematique()
    hasCinematic = not hasCinematic
    if not hasCinematic then -- show
        SendNUIMessage({openCinema = false})
        ESX.UI.HUD.SetDisplay(1.0)
        TriggerEvent('es:setMoneyDisplay', 1.0)
        TriggerEvent('esx_status:setDisplay', 1.0)
        DisplayRadar(true)
        TriggerEvent('ui:toggle', true)
    elseif hasCinematic then -- hide
        SendNUIMessage({openCinema = true})
        ESX.UI.HUD.SetDisplay(0.0)
        TriggerEvent('es:setMoneyDisplay', 0.0)
        TriggerEvent('esx_status:setDisplay', 0.0)
        DisplayRadar(false)
        TriggerEvent('ui:toggle', false)
    end
end

RegisterNetEvent('Linked:SpawnCharacter')
AddEventHandler('Linked:SpawnCharacter', function(spawn)
	openCinematique()
	CloseMenu('MyMenus')
	DisplayRadar(false)
    PlaySoundFrontend(-1, "CHARACTER_SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0)
    TriggerServerEvent('SavellPlayer')
	RenderScriptCams(0, 0, 1, 1, 1)
    ClearTimecycleModifier("scanline_cam_cheap")
    SetFocusEntity(GetPlayerPed(PlayerId()))
    DoScreenFadeOut(0)
	SetTimecycleModifier('rply_saturation')
	SetTimecycleModifier('rply_vignette')
    SetEntityCoords(PlayerPedId(), -491.0, -737.32, 23.92-0.98)
    SetEntityHeading(PlayerPedId(), 359.3586730957)
    ExecuteCommand('e sitchair4')
    FreezeEntityPosition(PlayerPedId(), false)
    DoScreenFadeIn(1500)
	Citizen.Wait(3500)
    ClearPedTasks(GetPlayerPed(-1))
    TaskPedSlideToCoord(PlayerPedId(), -491.68, -681.96, 33.2, 359.3586730957, 1.0)
	Citizen.Wait(33000)
	openCinematique()
    SetTimecycleModifier('')
	PlaySoundFrontend(-1, "CHARACTER_SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0)
    TriggerEvent('instance:close')
    for i = 0, 357 do
        EnableAllControlActions(i)
	end
	DisplayRadar(true)
	DrawSub("~g~Bienvenue à Los Santos ! ~w~Passez vos meilleures moments ici ! ", 5000)
end)

local sexe = { 
	"Homme",
	"Femme"
}

function KeyboardInput(TextEntry, ExampleText, MaxStringLength)
	AddTextEntry("FMMC_KEY_TIP1", TextEntry)
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end

	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result
	else
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end


function DrawSub(msg, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandPrint(time, 1)
end


local Character = {}

local pedlist ={
	"zeez",
	"Test",
	"DZD"
}

function CreateCam()
  --  cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 403.1680, -998.27, -99.00, 89.00, 300.00, 89.75, 30.00, false, 0)
  	cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 403.03, -998.33, -98.20, -20.00, 0.00, 0.00, 70.00, false, 0)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 2000, true, true) 
end
function CreateCame()
	SetCamActive(cam, false)
	RenderScriptCams(true, false, 2000, true, true) 
end

local MyMenus = {
	Base = { Header = {"commonmenu", "interaction_bgd"}, Color = {color_black}, HeaderColor = {255, 255, 255}, Title = "Mon personnage",  Blocked = true },
	Data = { currentMenu = "Création de personnage", "" },
	Events = {
		onSelected = function(self, _, btn, PMenu, menuData, currentButton, currentBtn, currentSlt, result, slide)
			PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
			local slide = btn.slidenum
			local btn = btn.name
			local check = btn.unkCheckbox
			local myIdentity = {}
			local data = {}
			local currentMenu, ped = menuData.currentMenu, GetPlayerPed(-1)
			if btn == "Sexe" then
				local result = KeyboardInput("Sexe", "M ou F", 25)
                if result ~= nil then
                    ResultSexe = result
				end
				print("Sexe " ..result)
			elseif btn == "Prénom" then
				local result = KeyboardInput("Prénom", "Prénom", 25)
                if result ~= nil then
                    ResultPrenom = result
				end
				print("Prénom " ..result)
			elseif btn == "Nom" then	
				local result = KeyboardInput("Nom", "Nom", 25)
                if result ~= nil then
                    ResultNom = result
				end
				print("Nom " ..result)
			elseif btn == "Date de naissance" then
				local result = KeyboardInput("Date de naissance", "12/09/2000", 25)
                if result ~= nil then
                    ResultDateDeNaissance = result
				end
				print("Date de naissance" ..result)
			elseif btn == "Taille (en CM)" then
				local result = KeyboardInput("Taille (cm)", "180", 25)
                if result ~= nil then
                	ResultTaille = result
				end
				print("Taille " ..result)
			elseif btn == "~g~Continuer" then
				TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 800.0, "drake-toosie-slide-lyrics-bass-boost", 0.6)
				TriggerServerEvent('Linkeed:saveOof', ResultSexe, ResultPrenom, ResultNom, ResultDateDeNaissance, ResultTaille)
                LoadingPrompt("Sauvegarde de votre identité en cours", 3)
				DisplayRadar(false)
				CreateCam()
				SetEntityInvincible(GetPlayerPed(-1), true) -- Set entity vinvcible
				SetEntityCoords(GetPlayerPed(-1), 402.770, -996.81, -100.00, 184.19132, 0, 0, 1)
				FreezeEntityPosition(GetPlayerPed(-1), true)
				RemoveLoadingPrompt()
       			OpenMenu('Choisi:')
				TriggerEvent('instance:create')
				DrawSub("~g~Invincible", 12000)
                Wait(2500)
			elseif btn == "~g~Choisir un personnage normal (H & F)" then
				OpenMenu('Étape suivantes: ')
			elseif btn == "Votre sexe" and slide == 1 then
				TriggerEvent('skinchanger:change', 'sex', 0)
			elseif btn == "Votre sexe" and slide == 2 then
				TriggerEvent('skinchanger:change', 'sex', 1)
			elseif btn == "~g~Validé votre sexe." then
				OpenMenu('Physique:')
			elseif btn == "Tête" then
				OpenMenu('Votre visage')
			elseif btn == "Pilosité facial" then
				OpenMenu('Votre barbe')
			elseif btn == "Yeux (Coloration)" then
				OpenMenu('Votre coloration des yeux')
			elseif btn == "Cheveux" then
				OpenMenu('Votre coupe de cheveux')
			elseif btn == "Sourcils" then
				OpenMenu('Vos sourcils')
			elseif btn == "Couleurs pilosité" then
				OpenMenu('Votre couleur')
			elseif btn == "~g~Validé votre visage." then
				OpenMenu('Personnalisation du personnage:')
			elseif btn == "Peau" then
				OpenMenu('Votre peau')
			elseif btn == "Acné" then
				OpenMenu('Votre acné')
			elseif btn == "Imperfections" then
				OpenMenu('Vos imperfections')
			elseif btn == "Rides" then
				OpenMenu('Vos rides')
			elseif btn == "Taches de rousseur" then
				OpenMenu('Vos taches de rousseur')
			elseif btn == "~g~Validé votre personnalisation." then
				OpenMenu('Continuer')
			elseif btn == "~g~Valider votre personnage" then
				print("Save is loading")
				TriggerEvent('skinchanger:getSkin', function(skin)
                    LastSkin = skin
                end)
                TriggerEvent('skinchanger:getSkin', function(skin)
                TriggerServerEvent('esx_skin:save', skin)
                end)
				print("Save is done") 
				TriggerEvent('Linked:SpawnCharacter')
				RemoveLoadingPrompt()
			elseif btn == "~g~Choisir un ped" then
				OpenMenu('Choisi ton ped:')
				LoadingPrompt("Sauvegarde de votr ped en cours", 3)
				DisplayRadar(false)
				CreateCam()
				SetEntityInvincible(GetPlayerPed(-1), true) -- Set entity vinvcible
				SetEntityCoords(GetPlayerPed(-1), 402.770, -996.81, -100.00, 184.19132, 0, 0, 1)
				FreezeEntityPosition(GetPlayerPed(-1), true)
				DrawSub("~g~Invincible", 12000)
                Wait(2500)
			elseif btn == "~g~Valider votre ped:" then
				OpenMenu('Continuer')
			end
		end,
			
		onSlide = function(menuData, currentButton, currentSlt, PMenu)
		
			local currentMenu, ped = menuData.currentMenu, GetPlayerPed(-1)
		
			--- Couleur Cheveux --
			if currentMenu == "Votre couleur" then
                if currentSlt ~= 1 then return end
                local currentButton = currentButton.slidenum - 1
        
                beardcolor = currentButton
				TriggerEvent('skinchanger:change', 'hair_color_2', beardcolor)

                --print("sourcils "..currentButton)
            end
			-- Sourcils --
			if currentMenu == "Vos sourcils" then
                if currentSlt ~= 1 then return end
                local currentButton = currentButton.slidenum - 1
        
                eyebrow = currentButton
				SetPedHeadOverlay(GetPlayerPed(-1), 2, eyebrow, 1.0)
				TriggerEvent('skinchanger:change', 'eyebrows_2', 10)
				TriggerEvent('skinchanger:change', 'eyebrows_1', eyebrow)
            end
			-- Tête --
			if currentMenu == "Votre visage" then
                if currentSlt ~= 1 then return end
                currentButton = currentButton.slidenum - 1

                face = currentButton
				TriggerEvent('skinchanger:change', 'face', face)
			end
			-- Peau --
			if currentMenu == "Votre peau" then
                if currentSlt ~= 1 then return end
                local currentButton = currentButton.slidenum - 1
        
                skin = currentButton
				TriggerEvent('skinchanger:change', 'skin', skin)
            end
			-- Barbe --
			if currentMenu == "Votre barbe" then
                if currentSlt ~= 1 then return end
                local currentButton = currentButton.slidenum - 1
        
                beard = currentButton
				SetPedHeadOverlay(GetPlayerPed(-1), 1, beard, 1.0)
				TriggerEvent('skinchanger:change', 'beard_2', 10)
				TriggerEvent('skinchanger:change', 'beard_1', beard)
			end
			-- Yeux--
			if currentMenu == "Votre coloration des yeux" then
                if currentSlt ~= 1 then return end
                local currentButton = currentButton.slidenum - 1
        
                eyecolor = currentButton
				TriggerEvent('skinchanger:change', 'eye_color', eyecolor)
			end
			-- Cheveux --
			if currentMenu == "Votre coupe de cheveux" then
                if currentSlt ~= 1 then return end
                local currentButton = currentButton.slidenum - 1
        
                hair = currentButton
				TriggerEvent('skinchanger:change', 'hair_2', 10)
				TriggerEvent('skinchanger:change', 'hair_1', hair)
			end
			--- Imperfections --
			if currentMenu == "Vos imperfections" then
                if currentSlt ~= 1 then return end
                local skinproblem = currentButton.slidenum - 1
        
				TriggerEvent('skinchanger:change', 'complexion_2', 10)
				TriggerEvent('skinchanger:change', 'complexion_1', skinproblem)
            end
			-- Taches de rousseur --
            if currentMenu == "Vos taches de rousseur" then
                if currentSlt ~= 1 then return end
                local freckle = currentButton.slidenum - 1
				TriggerEvent('skinchanger:change', 'moles_2', 10)
				TriggerEvent('skinchanger:change', 'moles_1', freckle)
            end
			--- Rides--
            if currentMenu == "Vos rides" then
                if currentSlt ~= 1 then return end
                local wrinkle = currentButton.slidenum - 1
        
				TriggerEvent('skinchanger:change', 'age_2', 10)
				TriggerEvent('skinchanger:change', 'age_1', freckle)
            end
			--- Acné ---
            if currentMenu == "Votre acné" then
                if currentSlt ~= 1 then return end
                local acne = currentButton.slidenum - 1
				TriggerEvent('skinchanger:change', 'blemishes_2', 10)
				TriggerEvent('skinchanger:change', 'blemishes_1', acne)
			end
			--- Choisi ton ped ---
			if currentMenu == "Choisi ton ped:" then
				if currentSlt ~= 1 then return end
				local pedlinkeeed = currentButton.slidenum - 1

				TriggerEvent('skinchanger:change', 'sex', pedlinkeeed)
			end
        
		end,
	},
	Menu = {
		["Création de personnage"] = {
			b = {
				{name = "Sexe", Description = "Homme = M / Femme = F"},
				{name = "Prénom"},
				{name = "Nom"},
				{name = "Date de naissance"},
				{name = "Lieu de naissance"},
				{name = "Taille (en CM)"},
				{name = "~g~Continuer", Description = "Êtes-vous sûr de vos informations si-dessus ? Si oui, continuez la création de votre personnage", ask = ">", askX = true}
			}
		},
		
		["Choisi:"] = {
			b = {
				{name = "~g~Choisir un ped", Description = "Personnage PNJ, customisation restreinte (Only)"},
				{name = "~g~Choisir un personnage normal (H & F)", Description = "Customisation complète de A à Z (Tête, bouche, héritage...)"}
			}
		},

		["Choisi ton ped:"] = {
			b = {
				{name = "~g~Ped:", Description = "Listes des peds disponibles sur FiveM/GTA V", slidemax = pedlist},
				{name = "~g~Valider votre ped:", Description = "~r~Attention.~w~Action irréversible. Choissiez bien votre personnage"}
			}
		},
		
		["Étape suivantes: "] = {
			b = {
				{name = "Votre sexe", Description = "Sexe du personnage.", slidemax = sexe},
				{name = "~g~Validé votre sexe.", Description = "~r~Attention.~w~Êtes-vous sûre de valider votre sexe, si oui appuyez sur ENTRER", ask = ">", askX = true}

			}
		},

		["Physique:"] = {
			b = {
				{name = "Tête", Description = "Sélectionner le visage qui vous convient.", ask = ">", askX = true},
				{name = "Pilosité facial", Description = "Sélectionner la barbe qui vous convient.", ask = ">", askX = true},
				{name = "Opacité barbe", ask = ">", askX = true},
				{name = "Yeux (Coloration)", Description = "Sélectionner la couleur de vos yeux qui vous convient.", ask = ">", askX = true},
				{name = "Cheveux", Description = "Sélectionner la coupe qui vous convient.", ask = ">", askX = true},
				{name = "Opacité cheveux", ask = ">", askX = true},
				{name = "Couleurs pilosité", Description = "Sélectionner la couleur qui vous convient.", ask = ">", askX = true},
				{name = "Sourcils", Description = "Sélectionner les sourcils qui vous convient.", ask = ">", askX = true},
				{name = "Opacité Sourcils", ask = ">", askX = true},
				{name = "~g~Validé votre visage.", Description = "~r~Attention.~w~Cette action est irréversible.", ask = ">", askX = true}

			}
		},

		["Personnalisation du personnage:"] = {
			b = {
				{name = "Peau", Description = "Sélectionner une couleur de peau qui vous convient.", ask = ">", askX = true},
				{name = "Acné", Description = "Sélectionner l'acné qui vous convient.", ask = ">", askX = true},
				{name = "Opacité Acné", ask = ">", askX = true},
				{name = "Imperfections", Description = "Sélectionner les imperfections de vos yeux qui vous convient.", ask = ">", askX = true},
				{name = "Opacité Imperfections", ask = ">", askX = true},
				{name = "Rides", Description = "Sélectionner les rides vous convient.", ask = ">", askX = true},
				{name = "Opacité Rides", ask = ">", askX = true},
				{name = "Taches de rousseur", Description = "Sélectionner les taches de rousseur qui vous convient.", ask = ">", askX = true},
				{name = "Opacité Taches de rousseurs", ask = ">", askX = true},
				{name = "~g~Validé votre personnalisation.", Description = "~r~Attention.~w~Cette action est irréversible.", ask = ">", askX = true}

			}
		},

		["Continuer"] = {
			b = {
				{name = "~g~Valider votre personnage", Description = "~r~Attention.~w~Cette action est irréversible."}

			}
		},

		["Votre peau"] = {
			b = {
				{ name = "Peau", slidemax = 45, Description = "La peau de votre personnage"},
			}
        },

		["Votre acné"] = {            
			b = {
                { name = "Acné", slidemax = 15},
            }
        },

        ["Vos rides"] = {            
			b = {
                { name = "Rides", slidemax = 15},
            }
        },

        ["Vos taches de rousseur"] = {            
			b = {
                { name = "Taches de rousseurs", slidemax = 15},
            }
        },

        ["Vos imperfections"] = {            
			b = {
                { name = "Imperfections", slidemax = 15},
            }
        },
		
		["Votre visage"] = {
			b = {
				{name = "Visage", Description = "Choissisez votre tête.", slidemax = 45}
			}
		},

		["Votre barbe"] = {
			b = {
				{name = "Barbe", Description = "Choissisez la barbe.", slidemax = 20}
			}
		},

		["Votre coloration des yeux"] = {
			b = {
				{name = "Couleurs des yeux", Description = "Choissisez la couleur des yeux.", slidemax = 31}
			}
		},

		["Votre coupe de cheveux"] = {
			b = {
				{name = "Coupe de cheveux", Description = "Choissisez la coupe qui vous va le mieux", slidemax = 73}
			}
		},

		["Votre couleur"] = {
			b = {
				{name = "Votre couleur", Description = "Choissisez la couleur qui vous va le mieux", slidemax = 73}
			}
		},

		["Vos sourcils"] = {
			b = {
				{ name = "Sourcils", slidemax = 20, Description = "Les sourcils de votre personnage"},
			}
        },
	}
}


--[[for i = 1, #ESX.PlayerData.accounts, 1 do
	if ESX.PlayerData.accounts[i].name == 'bank' then
		bankmoney =  ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money)
	end
end--]]

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)


RegisterCommand("charcreate", function()
	CreateMenu(MyMenus)
end)