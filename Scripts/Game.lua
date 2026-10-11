Game = class( nil )

function Game.server_onCreate( self )
	print("Minecraft in Scrap Mechanic: Game loaded")
    self.sv = {}
	self.sv.saved = self.storage:load()
    if self.sv.saved == nil then
		self.sv.saved = {}
		self.sv.saved.world = sm.world.createWorld( "$CONTENT_DATA/Scripts/World.lua", "World" )
		self.storage:save( self.sv.saved )
	end
end

function Game.server_onPlayerJoined( self, player, isNewPlayer )
    print("Minecraft in Scrap Mechanic: Player joined")
    if isNewPlayer then
        if not sm.exists( self.sv.saved.world ) then
            sm.world.loadWorld( self.sv.saved.world )
        end
        self.sv.saved.world:loadCell( 0, 0, player, "sv_createPlayerCharacter" )
    end
end

function Game.sv_createPlayerCharacter( self, world, x, y, player, params )
    -- Create a character with Minecraft-like properties
    local character = sm.character.createCharacter( player, world, sm.vec3.new( x, y + 0.5, z ), 0, 0 )

    -- Make character more Minecraft-like: smaller and cubic proportions
    -- Scale down to make it more block-like (Minecraft characters are about 1.8m tall,
    -- but let's make it smaller to fit better with Scrap Mechanic scale)
    local scale = sm.vec3.new( 0.4, 0.4, 0.4 ) -- Makes it more cube-like
    character:setCharacterJointParameters( sm.character.jointParameters( scale.x, scale.y, scale.z ) )

    -- Set character color to a Minecraft-like green (Steve-like)
    -- Note: This might not work directly, but worth trying
    character:setColor( sm.color.new( 0x68, 0x9f, 0x38 ) ) -- Minecraft grass green

    player:setCharacter( character )

    -- Initialize player data for our mod
    self:initPlayerData( player )

    print("Minecraft in Scrap Mechanic: Character created with Minecraft-like properties")
end

function Game.initPlayerData( self, player )
    -- Store player-specific data for our mod
    local data = {
        inventory = { }, -- Will hold Minecraft blocks
        selectedSlot = 1, -- Currently selected hotbar slot
        maxHealth = 20,   -- Minecraft-style health (10 hearts)
        currentHealth = 20,
        hunger = 20,      -- Minecraft-style hunger
        punchCooldown = 0 -- Prevent spamming punches
    }
    player:setUserData( data )
end