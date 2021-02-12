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
    GetData = function(self, server, player)
        local data = RS_Dataset[server]
        if not data then return nil end
        data = data[player]
        if not data then return nil end
        return {
            GetZone = function(self, zone)
                if not data[zone] then return nil end
                local zoneData = data[zone]
                return {
                    GetRole = function(self)
                        return RS_Specs[zoneData[1]]
                    end,
                    GetRoleProgression = function(self)
                        return zoneData[2]
                    end,
                    GetTotalProgression = function(self)
                        return zoneData[3]
                    end,
                    GetRating = function(self)
                        return zoneData[4]
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
            for _, serverData in pairs(RS_Dataset) do
                for _, playerData in pairs(serverData) do
                    for zoneID, zoneData in pairs(playerData) do
                        local progression = zoneData[3]
                        if self.maxProgressions[zoneID] == nil or self.maxProgressions[zoneID] < progression then
                            self.maxProgressions[zoneID] = progression
                        end
                    end
                end
            end
        end
        return self.maxProgressions[zone]
    end,
    IsDeveloper = function(self, server, name)
        if server ~= 'Пламегор' then return false end
        if not self.developers then
            local developers = {'Махич', 'Коровобог', 'Шелкопрядица'}
            self.developers = {}
            for k, v in pairs(developers) do
                self.developers[v] = true
            end
        end
        return self.developers[name] or false
    end,
    GetServer = function(self)
        return GetRealmName()
    end
}