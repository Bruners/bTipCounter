local disableItemCount = false
local disableStacksize = false
local disableItemID = true
local disableIlevel = false
local leftR, leftG, leftB = 0,1,1
local rightR, rightG, rightB = 1, 1, 1
local AddDoubleLine = AddDoubleLine
local GetItemInfo = GetItemInfo
local GetItem = GetItem
local GetItemCount = GetItemCount
local origs = {}

local function ToID(link)
	if link then
		return tonumber(link) or tonumber(link:match('item:(%d+)') or tonumber(select(2, GetItemInfo(link)):match('item:(%d+)')))
	end
end

local function OnTooltipSetItem(frame, ...)
	local _, link = frame:GetItem()
	if link then
		local _,itemLink,_,ilevel,_,_,_,maxstack,_,_ = GetItemInfo(link)
		if ilevel then
			if not disableIlevel and GetCVar("ShowItemLevel") == "0" then
				frame:AddDoubleLine("Item level:", ilevel, leftR,leftG,leftB,rightR,rightG,rightB)
			end
			if not disableItemCount then
				local itemCount = GetItemCount(link, false)
				local itemBankcount = GetItemCount(link, true) - itemCount
				if itemCount + itemBankcount > 0 then
					frame:AddDoubleLine("You have:", itemCount..(itemBankcount > 0 and (" (|cff88ffff+"..itemBankcount.."|r)") or ""), leftR,leftG,leftB,rightR,rightG,rightB)
				end
			end
			if not disableStacksize then
				if maxstack and maxstack > 1 then
					frame:AddDoubleLine("Stack size:", maxstack,leftR,leftG,leftB,rightR,rightG,rightB)
				end
			end
			if not disableItemID then
				if itemLink then
					frame:AddDoubleLine("Item ID:", ToID(itemLink), leftR,leftG,leftB,rightR,rightG,rightB)
				end
			end
		end
	end
	if origs[frame] then return origs[frame](frame, ...) end
end

for _,frame in pairs{GameTooltip, ItemRefTooltip, ShoppingTooltip1, ShoppingTooltip2} do
	origs[frame] = frame:GetScript("OnTooltipSetItem")
	frame:SetScript("OnTooltipSetItem", OnTooltipSetItem)
end
