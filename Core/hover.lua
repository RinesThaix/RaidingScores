local function getColorByRating(rating)
    local percentage = rating / RS:GetMaxScore()
    if percentage >= 0.99 then return '|cffe268a8'
    elseif percentage >= 0.95 then return '|cffff8000'
    elseif percentage >= 0.75 then return '|cffa335ee'
    elseif percentage >= 0.50 then return '|cff0070ff'
    elseif percentage >= 0.25 then return '|cff1eff00'
    else return '|cff808080' end
end

local function addZone(data, zone, translation)
    local maxProgression = RS:GetMaxProgression(zone)
    zone = data:GetZone(zone)
    if zone == nil then return end
    local role, roleProgression, totalProgression, rating = zone:GetRole(), zone:GetRoleProgression(), zone:GetTotalProgression(), zone:GetRating()

    local roleString = roleProgression .. '/' .. maxProgression
    if role ~= 'None' then roleString = role .. ' ' .. roleString end

    local left
    if roleProgression == totalProgression then
        left = string.format('%s (%s)', translation, roleString)
    else
        left = string.format('%s (%s, всего %d/%d)', translation, roleString, totalProgression, maxProgression)
    end
    GameTooltip:AddDoubleLine(
        left,
        string.format('%s%d рейтинга', getColorByRating(rating), rating)
    )
end

C_Timer.After(1, function()
    GameTooltip:HookScript("OnTooltipSetUnit", function(self)
        local _, unit = self:GetUnit()
        if not unit or not UnitIsPlayer(unit) then return end
        local name, realm = UnitName(unit)
        if realm == nil then realm = RS:GetServer() end
        local data = RS:GetData(realm, name)
        if data == nil then return end

        GameTooltip:AddLine(' ')
        if RS:IsDeveloper(realm, name) then
            GameTooltip:AddDoubleLine('|cffffffffRaiding Scores', '|cff00aaaaРазработчик')
        else
            GameTooltip:AddLine('|cffffffffRaiding Scores')
        end
        addZone(data, RS.Zone.NAXXRAMAS, 'Наксрамас')
        addZone(data, RS.Zone.AQ40, 'Храм Ан\'Киража')
        addZone(data, RS.Zone.BLACK_WING_LAIR, 'Логово Крыла Тьмы')
        addZone(data, RS.Zone.MOLTEN_CORE, 'Огненные Недра')
    end)
end)