Player = class( nil )

function Player.client_onCreate( self )
    print("Minecraft in Scrap Mechanic: Player initialized")
    -- Initialize Minecraft-like HUD
    self.hudInitialized = false
    self.lastPunchTime = 0
    self.punchCooldown = 0.5 -- seconds between punches
end

function Player.client_onUpdate( self, dt )
    -- Update cooldown timers
    if self.punchCooldown > 0 then
        self.punchCooldown = self.punchCooldown - dt
    end

    -- Update Minecraft HUD elements
    if not self.hudInitialized then
        self:initializeMinecraftHUD()
        self.hudInitialized = true
    end

    -- Update HUD display (health, hunger, hotbar)
    self:updateHUD()
end

function Player.initializeMinecraftHUD( self )
    print("Minecraft in Scrap Mechanic: Initializing Minecraft-style HUD")
    -- TODO: Create custom HUD elements:
    -- - Hotbar with 9 slots (like Minecraft)
    -- - Health bar (hearts)
    -- - Hunger bar (if implementing survival)
    -- - Crosshair
    -- For now, we'll just print a message
    print("Minecraft HUD system initialized")
end

function Player.updateHUD( self )
    -- Update the HUD with current player stats
    local userData = self:getUserData()
    if userData then
        -- This would update the actual HUD elements
        -- For now, just print to console for debugging
        -- print(string.format("Health: %d/%d, Hunger: %d/%d",
        --     userData.currentHealth, userData.maxHealth, userData.hunger, 20))
    end
end

function Player.client_onInteract( self, character, state )
    -- Handle left-click (punch) to break/scrape resources
    if state == true then -- Pressed
        if self.punchCooldown <= 0 then
            self:handlePunch()
            self.punchCooldown = 0.5 -- Reset cooldown
        end
    end
end

function Player.handlePunch( self )
    print("Minecraft in Scrap Mechanic: Player punched")
    -- TODO: Implement punching logic:
    -- - Raycast from player position to check what's in front
    -- - If hitting a scrap/mechanic object, damage it and potentially yield scrap resources
    -- - If hitting a Minecraft block from our mod, potentially collect it or damage it
    -- - Play punch sound/animation

    -- For now, just simulate collecting some scrap
    local userData = self:getUserData()
    if userData then
        -- Add some scrap to inventory when punching (simplified)
        if not userData.inventory["scrap"] then
            userData.inventory["scrap"] = 0
        end
        userData.inventory["scrap"] = userData.inventory["scrap"] + 1
        print("Collected scrap! Total scrap: " .. userData.inventory["scrap"])

        -- Update our stored user data
        self:setUserData(userData)
    end
end

-- Hotbar functions
function Player.getSelectedItem( self )
    local userData = self:getUserData()
    if userData and userData.inventory then
        local slots = {}
        for item, count in pairs(userData.inventory) do
            table.insert(slots, {item = item, count = count})
        end

        -- Sort slots for consistent hotbar ordering (simplified)
        table.sort(slots, function(a, b) return a.item < b.item end)

        local selectedSlot = userData.selectedSlot or 1
        if selectedSlot > 0 and selectedSlot <= #slots then
            return slots[selectedSlot]
        end
    end
    return nil
end

function Player.addItemToInventory( self, itemName, amount )
    local userData = self:getUserData()
    if userData then
        if not userData.inventory then
            userData.inventory = {}
        end
        if not userData.inventory[itemName] then
            userData.inventory[itemName] = 0
        end
        userData.inventory[itemName] = userData.inventory[itemName] + amount
        self:setUserData(userData)
        print(string.format("Added %d %s to inventory. Total: %d",
            amount, itemName, userData.inventory[itemName]))
    end
end

function Player.useItemFromInventory( self, itemName, amount )
    local userData = self:getUserData()
    if userData and userData.inventory and userData.inventory[itemName] then
        if userData.inventory[itemName] >= amount then
            userData.inventory[itemName] = userData.inventory[itemName] - amount
            if userData.inventory[itemName] <= 0 then
                userData.inventory[itemName] = nil
            end
            self:setUserData(userData)
            return true
        end
    end
    return false
end