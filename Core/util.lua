RS = {
    Role = {
        TANK = 0,
        HEALER = 1,
        DAMAGE_DEALER = 2
    },
    Zone = {
        MOLTEN_CORE = 1000,
        BLACK_WING_LAIR = 1002,
        AQ40 = 1005,
        NAXXRAMAS = 1006
    },
    GetData = function(self, region, server, player)
        local data = RS_Dataset[region][server][player]
        if not data then return nil end
        return {
            GetZone = function(self, zone)
                if not data[zone] then return nil end
                local zoneData = data[zone]
                return {
                    GetRole = function(self)
                        return zoneData[1]
                    end,
                    GetProgression = function(self)
                        return zoneData[2]
                    end,
                    GetRating = function(self)
                        return zoneData[3]
                    end
                }
            end
        }
    end,
    GetMaxScore = function(self)
        return 5000
    end,
    GetMaxProgression = function(self, zone)
        if not self.maxProgressions then
            self.maxProgressions = {}
            for _, serverData in pairs(RS_Dataset[self:GetRegion()]) do
                for _, playerData in pairs(serverData) do
                    for zoneID, zoneData in pairs(playerData) do
                        local progression = zoneData[2]
                        if self.maxProgressions[zoneID] == nil or self.maxProgressions[zoneID] < progression then
                            self.maxProgressions[zoneID] = progression
                        end
                    end
                end
            end
        end
        return self.maxProgressions[zone]
    end,
    GetRegion = function(self)
        return RS_Dataset.REGION
    end,
    GetServer = function(self)
        return GetRealmName()
    end
}