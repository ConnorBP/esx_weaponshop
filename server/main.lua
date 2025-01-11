
ESX.RegisterServerCallback('esx_weaponshop:buyLicense', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getMoney() >= Config.LicensePrice then
		xPlayer.removeMoney(Config.LicensePrice, "Weapon License")

		TriggerEvent('esx_license:addLicense', source, 'weapon', function()
			cb(true)
		end)
	else
		xPlayer.showNotification(TranslateCap('not_enough'))
		cb(false)
	end
end)

local function GetPrice(weaponName, zone)
	for i=1, #(Config.Zones[zone].Items) do
		if Config.Zones[zone].Items[i].name == weaponName then
			local weapon = Config.Zones[zone].Items[i]
			return weapon.price
		end
	end

	return -1
end

local function GetAmmoPrice(weaponName,zone)
	for i=1, #(Config.Zones[zone].Items) do
		if Config.Zones[zone].Items[i].name == weaponName then
			local weapon = Config.Zones[zone].Items[i]
			return weapon?.ammo_price or 0
		end
	end

	return 0
end

ESX.RegisterServerCallback('esx_weaponshop:buyWeapon', function(source, cb, weaponName, zone, ammoAmount)
	local xPlayer = ESX.GetPlayerFromId(source)
    local price = GetPrice(weaponName, zone)
    local ammoPrice = GetAmmoPrice(weaponName, zone) * ammoAmount

	if price <= 0 then

		print(('[^3WARNING^7] Player ^5%s^7 attempted to buy Invalid weapon - %s!'):format(source, weaponName))
		cb(false)
	else
		if xPlayer.hasWeapon(weaponName) then
			xPlayer.showNotification(TranslateCap('already_owned'))
			cb(false)
		else
            if zone == 'BlackWeashop' then
                local black_money = xPlayer.getAccount('black_money').money
				local total_price = price + ammoPrice
				if black_money >= total_price then
					xPlayer.removeAccountMoney('black_money', total_price, "Black Weapons Deal")
					xPlayer.addWeapon(weaponName, ammoAmount)
	
					cb(true)
				else
					xPlayer.showNotification(TranslateCap('not_enough_black'))
					cb(false)
				end
            else
                local money = xPlayer.getMoney()
				local total_price = price + ammoPrice
				if money >= total_price then
					xPlayer.removeMoney(total_price, "Weapons Deal")
					xPlayer.addWeapon(weaponName, ammoAmount)
					cb(true)
				else
					xPlayer.showNotification(TranslateCap('not_enough'))
					cb(false)
				end
			end
		end
	end
end)



