local disableItemCount = false
local disableStacksize = false
local disableItemID = true
local disableIlevel = false
local GetItemInfo = GetItemInfo
local GetItem = GetItem
local GetItemCount = GetItemCount

local function ToID(link)
	if link then
		return tonumber(link) or tonumber(link:match('item:(%d+)') or tonumber(select(2, GetItemInfo(link)):match('item:(%d+)')))
	end
end

local lineAdded = false
local function OnTooltipSetItem(tooltip, ...)
	local _, link = GameTooltip:GetItem()
	if link then
		local _,itemLink,_,ilevel,_,_,_,maxstack,_,_ = GetItemInfo(link)
		if not lineAdded then
			if ilevel ~= nil then
				if not disableIlevel and GetCVar("ShowItemLevel") == "0" then
					tooltip:AddDoubleLine("Item level:", ilevel, 0,1,1,1,1,1)
				end
				if not disableItemCount then
					local itemCount = GetItemCount(link, false)
					local itemBankcount = GetItemCount(link, true) - itemCount
					if itemCount + itemBankcount > 0 then
						tooltip:AddDoubleLine("You have:", itemCount..(itemBankcount > 0 
and (" (|cff88ffff+"..itemBankcount.."|r)") or ""), 0,1,1,1,1,1)
					end
				end
				if not disableStacksize then
					if maxstack and maxstack > 1 then
						tooltip:AddDoubleLine("Stack size:", maxstack,0,1,1,1,1,1)
					end
				end
				if not disableItemID then
					if itemLink then
						tooltip:AddDoubleLine("Item ID:", ToID(itemLink), 0,1,1,1,1,1)
					end
				end
			end
		end
	end
	lineAdded = true
end

local function OnTooltipCleared(tooltip, ...)
	lineAdded = false
end

GameTooltip:HookScript("OnTooltipSetItem", OnTooltipSetItem)
GameTooltip:HookScript("OnTooltipCleared", OnTooltipCleared)
