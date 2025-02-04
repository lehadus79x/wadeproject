script_name("Season-Changer")
script_author("Wade")
script_version("work-in-progress")
script_url("@wadeadv on discord")

local imgui = require 'imgui'
local modsWindow = imgui.ImBool(false)
local currentSeason = nil

local summerImage = imgui.CreateTextureFromFile("moonloader/resources/seasons/summer_preview.png")
local winterImage = imgui.CreateTextureFromFile("moonloader/resources/seasons/winter_preview.png")

function main()
    sampRegisterChatCommand('season', function() modsWindow.v = not modsWindow.v end)
    sampRegisterChatCommand('switch', function() switchSeason() end)
    while true do
        wait(0)
        imgui.Process = modsWindow.v
    end
end

function imgui.OnDrawFrame()
    if modsWindow.v then
        local sw, sh = getScreenResolution()
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(1000, 400), imgui.Cond.FirstUseEver)

        imgui.Begin('Choose Your Season', modsWindow, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)

        imgui.SetCursorPosX((1000 - imgui.CalcTextSize("Welcome!").x) / 2)
        imgui.TextColored(imgui.ImVec4(1, 1, 1, 1), "\nSelect the season for your game environment.")
        imgui.Spacing()

        local imgWidth, imgHeight = 400, 200
        local btnWidth, btnHeight = 400, 60
        local spacing = 20

        imgui.SetCursorPosX((1000 - (2 * imgWidth + spacing)) / 2)

        imgui.BeginGroup()
        imgui.Image(summerImage, imgui.ImVec2(imgWidth, imgHeight))
        if imgui.Button('SUMMER☀️', imgui.ImVec2(btnWidth, btnHeight)) then
            if currentSeason == 'SUMMER' then
                sampAddChatMessage('{ffb853}SUMMER {ffffff}is already set!', -1)
            else
                setSeason('SUMMER', 'https://raw.githubusercontent.com/lehadus79x/sampwade/main/summer_modloader.ini')
            end
        end
        imgui.EndGroup()

        imgui.SameLine(0, spacing)

        imgui.BeginGroup()
        imgui.Image(winterImage, imgui.ImVec2(imgWidth, imgHeight))
        if imgui.Button('WINTER❄️', imgui.ImVec2(btnWidth, btnHeight)) then
            if currentSeason == 'WINTER' then
                sampAddChatMessage('{53d3ff}WINTER {ffffff}is already set!', -1)
            else
                setSeason('WINTER', 'https://raw.githubusercontent.com/lehadus79x/sampwade/main/winter_modloader.ini')
            end
        end
        imgui.EndGroup()

        imgui.Separator()
        imgui.SetCursorPosX((1000 - imgui.CalcTextSize("Current Season: " .. (currentSeason or 'None')).x) / 2)
        imgui.TextColored(imgui.ImVec4(0.6, 0.8, 1, 1), "\nCurrent Season: " .. (currentSeason or 'None'))

        imgui.SetCursorPos(imgui.ImVec2(10, 375))
        imgui.TextColored(imgui.ImVec4(0.6, 0.6, 0.6, 1), "made by WADE for phoenix.crowland.ro")

        imgui.End()
    end
end

function setSeason(season, url)
    currentSeason = season
    lua_thread.create(function()
        local seasonName = (season == 'SUMMER') and '{ffb853}Summer' or '{53d3ff}Winter'
        if doesFileExist('modloader/modloader.ini') then
            os.remove('modloader/modloader.ini')
        end

        local success = downloadUrlToFile(url, 'modloader/modloader.ini')
        if success then
            sampAddChatMessage('{ffffff}The change of season its being {00ff00}processed{fffff}!', -1)
            applySeasonCommand(season)
        else
            sampAddChatMessage('{FF0000}Error: Could not download config for ' .. seasonName .. '!', -1)
        end
    end)
end

function applySeasonCommand(season)
    if season == 'SUMMER' then
        sampSendChat("/sw 1")
    elseif season == 'WINTER' then
        sampSendChat("/sw 7")
    end
end

function switchSeason()
    if currentSeason == 'SUMMER' then
        setSeason('WINTER', 'https://raw.githubusercontent.com/lehadus79x/sampwade/main/winter_modloader.ini')
    elseif currentSeason == 'WINTER' then
        setSeason('SUMMER', 'https://raw.githubusercontent.com/lehadus79x/sampwade/main/summer_modloader.ini')
    else
        setSeason('SUMMER', 'https://raw.githubusercontent.com/lehadus79x/sampwade/main/summer_modloader.ini')
    end
end