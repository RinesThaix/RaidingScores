local function formatRole(role)
    if role == RS.Role.TANK then return 'Танк'
    elseif role == RS.Role.HEALER then return 'Целитель'
    elseif role == RS.Role.DAMAGE_DEALER then return 'ДД'
    else return 'Неизвестная роль' end
end

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
    local role, progression, rating = zone:GetRole(), zone:GetProgression(), zone:GetRating()

    GameTooltip:AddDoubleLine(
        string.format('%s (%s, %d/%d)', translation, formatRole(role), progression, maxProgression),
        string.format('%s%d рейтинга', getColorByRating(rating), rating)
    )
end

C_Timer.After(1, function()
    GameTooltip:HookScript("OnTooltipSetUnit", function(self)
        local _, unit = self:GetUnit()
        if not unit or not UnitIsPlayer(unit) then return end
        local name, realm = UnitName(unit)
        if realm == nil then realm = RS:GetServer() end
        local data = RS:GetData(RS:GetRegion(), realm, name)
        if data == nil then return end

        GameTooltip:AddLine(' ')
        GameTooltip:AddLine('|cffffffffRaiding Scores')
        addZone(data, RS.Zone.NAXXRAMAS, 'Наксрамас')
        addZone(data, RS.Zone.AQ40, 'Храм Ан\'Киража')
        addZone(data, RS.Zone.BLACK_WING_LAIR, 'Логово Крыла Тьмы')
        addZone(data, RS.Zone.MOLTEN_CORE, 'Огненные Недра')
    end)
end)