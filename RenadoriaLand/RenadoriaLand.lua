local VERSION = 3

local lastMana = nil
local regens = {}

local function OnEvent(self, event, ...)
	local time = GetTimePreciseSec()
	local tickTime = GetTickTime()

	if event == "UNIT_POWER_FREQUENT" then
		local unitTarget, powerType = ...

		if unitTarget == "player" and powerType == "MANA" then
			local mana = UnitPower("player", Enum.PowerType.Mana)
			local maxMana = UnitPowerMax("player", Enum.PowerType.Mana)

			if lastMana ~= nil then
				table.insert(RenadoriaLandData,
					{ "TICK", time, tickTime, mana, maxMana })
				print("Logged " .. time .. " " .. mana)
			elseif lastMana == nil then
				-- First tick since login, start the data
				if type(RenadoriaLandData) ~= "table" or
						#RenadoriaLandData < 1 or
						RenadoriaLandData[1][1] ~= "VERSION" or
						RenadoriaLandData[1][2] ~= VERSION then
					print("Starting log with new version " .. VERSION)
					RenadoriaLandData = {}
					table.insert(RenadoriaLandData, { "VERSION", VERSION })
				end

				table.insert(RenadoriaLandData,
					{ "START", time, tickTime, mana, maxMana })
			end

			lastMana = mana
		end
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("UNIT_POWER_FREQUENT")
f:SetScript("OnEvent", OnEvent)

-- GetManaRegen() works now it seems (doesn't factor in mp5 from items, it's just base)
-- Factors in things like 15% from priest talent, and 15% from t2 set bonus
--
-- 49.250999
-- 14.775999

