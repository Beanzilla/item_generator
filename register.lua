-- support for MT game translation.
local S = minetest.get_translator("item_generator")

local default = rawget(_G, "default") or nil

-- A Standard "Secure" generator
function igen_internal.register_chest(prefixed_name, d)
	local name = prefixed_name:sub(1,1) == ':' and prefixed_name:sub(2,-1) or prefixed_name
    local infotext_name = igen_internal.split(name, ':')[2]
    infotext_name = igen_internal.split(infotext_name, '_')[2]
	local def = table.copy(d)
	def.drawtype = "mesh"
	def.visual = "mesh"
	def.paramtype = "light"
	def.paramtype2 = "facedir"
	def.legacy_facedir_simple = true
	def.is_ground_content = false

    def.on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_string("infotext", S("Generator "..igen_internal.firstToUpper(infotext_name)))
        meta:set_string("name", name)
        meta:set_string("owner", "")
        meta:set_string("product", def.product)
        meta:set_int("product_amt", def.product_amt)
        meta:set_int("product_rate", def.product_rate)
        meta:set_int("product_at", 0) -- On construct we set the currently produced item to 0
        local inv = meta:get_inventory()
        inv:set_size("main", 8*4)
    end
    def.after_place_node = function(pos, placer)
        local meta = minetest.get_meta(pos)
        meta:set_string("owner", placer:get_player_name() or "")
        meta:set_string("infotext", S("Generator "..igen_internal.firstToUpper(infotext_name).." (owned by @1)", meta:get_string("owner")))
        -- Start a timer
        minetest.get_node_timer(pos):start(1)
    end
    def.can_dig = function(pos,player) -- Ignore if there is anything there in the inventory
        local meta = minetest.get_meta(pos);
        if default.can_interact_with_node(player, pos) == true then
            minetest.get_node_timer(pos):stop() -- Stop the timer if they can interact with it.
            -- This will attempt to "cleanup" any timer currently running but not needed.
        end
        return default.can_interact_with_node(player, pos)
    end
    def.on_timer = function(pos, elapsed)
        local meta=minetest.get_meta(pos)
        local process=meta:get_int("product_at")
        local inv=meta:get_inventory()
        if inv:room_for_item("main", meta:get_string("product")) == true then
            process = process + 1
            if process >= meta:get_int("product_rate") then
                for i=1,meta:get_int("product_amt"),1 do
                    if inv:room_for_item("main", meta:get_string("product")) == true then
                        inv:add_item("main", meta:get_string("product"))
                    end
                end
                process = 0
                if igen_log_item_generation then
                    minetest.log("action", "[item_generator] generator_"..igen_internal.split(meta:get_string("product"), ':')[2].." at ("..pos.x..", "..pos.y..", "..pos.z..") produced "..meta:get_int("product_amt").." of "..meta:get_string("product"))
                end
            end
            meta:set_int("product_at", process)
            -- Show the percent of the item completion.
            local percent = (process / meta:get_int("product_rate")) * 100
            local percent_format = string.format("%.2f %%", percent)
            meta:set_string("infotext", S("Generator "..igen_internal.firstToUpper(infotext_name).." (owned by @1) [@2%]", meta:get_string("owner"), percent_format))
        else
            meta:set_string("infotext", S("Generator "..igen_internal.firstToUpper(infotext_name).." (owned by @1) [FULL]", meta:get_string("owner")))
            -- Note: The node timer still will be fired (It's just nothing will happen)
        end
        return true
    end
    def.allow_metadata_inventory_move = function(pos, from_list, from_index,
            to_list, to_index, count, player)
        if not default.can_interact_with_node(player, pos) then
            return 0
        end
        return count
    end
    def.allow_metadata_inventory_put = function(pos, listname, index, stack, player)
        if not default.can_interact_with_node(player, pos) then
            return 0
        end
        return stack:get_count()
    end
    def.allow_metadata_inventory_take = function(pos, listname, index, stack, player)
        if not default.can_interact_with_node(player, pos) then
            return 0
        end
        return stack:get_count()
    end
    def.on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        if not default.can_interact_with_node(clicker, pos) then
            return itemstack
        end

        minetest.sound_play(def.sound_open, {gain = 0.3,
                pos = pos, max_hear_distance = 10}, true)
        minetest.after(0.2, minetest.show_formspec,
                clicker:get_player_name(),
                ":item_generator:generator_"..igen_internal.split(def.product, ':')[2], default.chest.get_chest_formspec(pos))
        default.chest.open_chests[clicker:get_player_name()] = { pos = pos,
                sound = def.sound_close, swap = name }
    end
    def.on_blast = function() end
    def.on_key_use = function(pos, player)
        local secret = minetest.get_meta(pos):get_string("key_lock_secret")
        local itemstack = player:get_wielded_item()
        local key_meta = itemstack:get_meta()

        if itemstack:get_metadata() == "" then
            return
        end

        if key_meta:get_string("secret") == "" then
            key_meta:set_string("secret", minetest.parse_json(itemstack:get_metadata()).secret)
            itemstack:set_metadata("")
        end

        if secret ~= key_meta:get_string("secret") then
            return
        end

        minetest.show_formspec(
            player:get_player_name(),
            ":item_generator:generator_"..igen_internal.split(def.product, ':')[2],
            default.chest.get_chest_formspec(pos)
        )
    end
    def.on_skeleton_key_use = function(pos, player, newsecret)
        local meta = minetest.get_meta(pos)
        local owner = meta:get_string("owner")
        local pn = player:get_player_name()

        -- verify placer is owner of lockable chest
        if owner ~= pn then
            minetest.record_protection_violation(pos, pn)
            minetest.chat_send_player(pn, S("You do not own this Generator."))
            return nil
        end

        local secret = meta:get_string("key_lock_secret")
        if secret == "" then
            secret = newsecret
            meta:set_string("key_lock_secret", secret)
        end

        return secret, S("a generator"), owner
    end

	def.on_metadata_inventory_move = function(pos, from_list, from_index,
			to_list, to_index, count, player)
        if igen_log_item_movements then
		    minetest.log("action", "[item_generator] ".. player:get_player_name() ..
    			" moves stuff in generator at " .. minetest.pos_to_string(pos))
        end
	end
	def.on_metadata_inventory_put = function(pos, listname, index, stack, player)
        if igen_log_item_movements then
		    minetest.log("action", "[item_generator] ".. player:get_player_name() ..
    			" moves " .. stack:get_name() ..
	    		" to generator at " .. minetest.pos_to_string(pos))
        end
	end
	def.on_metadata_inventory_take = function(pos, listname, index, stack, player)
        if igen_log_item_movements then
            minetest.log("action", "[item_generator] ".. player:get_player_name() ..
                " takes " .. stack:get_name() ..
                " from generator at " .. minetest.pos_to_string(pos))
        end
	end

	local def_opened = table.copy(def)
	local def_closed = table.copy(def)

	def_opened.mesh = "chest_open.obj"
	for i = 1, #def_opened.tiles do
		if type(def_opened.tiles[i]) == "string" then
			def_opened.tiles[i] = {name = def_opened.tiles[i], backface_culling = true}
		elseif def_opened.tiles[i].backface_culling == nil then
			def_opened.tiles[i].backface_culling = true
		end
	end
	def_opened.drop = name
	def_opened.groups.not_in_creative_inventory = 1
	def_opened.selection_box = {
		type = "fixed",
		fixed = { -1/2, -1/2, -1/2, 1/2, 3/16, 1/2 },
	}
	def_opened.can_dig = function()
		--return false
	end
	def_opened.on_blast = function() end

	def_closed.mesh = nil
	def_closed.drawtype = nil
	def_closed.tiles[6] = def.tiles[5] -- swap textures around for "normal"
	def_closed.tiles[5] = def.tiles[3] -- drawtype to make them match the mesh
	def_closed.tiles[3] = def.tiles[3].."^[transformFX"

	minetest.register_node(":item_generator:generator_"..igen_internal.split(def.product, ':')[2], def_closed)
	minetest.register_node(":item_generator:generator_"..igen_internal.split(def.product, ':')[2].."_open", def_opened)

end

-- ==================================================================================================================================================================== --

-- Our "Insecure" generator (I.E. A Public Generator)
function igen_internal.register_insecure_chest(prefixed_name, d)
	local name = prefixed_name:sub(1,1) == ':' and prefixed_name:sub(2,-1) or prefixed_name
    local infotext_name = igen_internal.split(name, ':')[2]
    infotext_name = igen_internal.split(infotext_name, '_')[2]
	local def = table.copy(d)
	def.drawtype = "mesh"
	def.visual = "mesh"
	def.paramtype = "light"
	def.paramtype2 = "facedir"
	def.legacy_facedir_simple = true
	def.is_ground_content = false

    def.on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_string("infotext", S("Public Generator "..igen_internal.firstToUpper(infotext_name)))
        meta:set_string("product", def.product)
        meta:set_int("product_amt", def.product_amt)
        meta:set_int("product_rate", def.product_rate)
        meta:set_int("product_at", 0) -- On construct we set the currently produced item to 0
        local inv = meta:get_inventory()
        inv:set_size("main", 8*4)
    end
    def.after_place_node = function(pos, placer)
        local meta = minetest.get_meta(pos)
        meta:set_string("owner", placer:get_player_name() or "")
        meta:set_string("infotext", S("Public Generator "..igen_internal.firstToUpper(infotext_name)))
        -- Start a timer
        minetest.get_node_timer(pos):start(1)
    end
    def.can_dig = function(pos,player) -- Ignore if there is anything there in the inventory
        minetest.get_node_timer(pos):stop() -- Stop the timer if they can interact with it.
        -- This will attempt to "cleanup" any timer currently running but not needed.
        return true
    end
    def.on_timer = function(pos, elapsed)
        local meta=minetest.get_meta(pos)
        local process=meta:get_int("product_at")
        local inv=meta:get_inventory()
        if inv:room_for_item("main", meta:get_string("product")) == true then
            process = process + 1
            if process >= meta:get_int("product_rate") then
                for i=1,meta:get_int("product_amt"),1 do
                    if inv:room_for_item("main", meta:get_string("product")) == true then
                        inv:add_item("main", meta:get_string("product"))
                    end
                end
                process = 0
                if igen_log_item_generation then
                    minetest.log("action", "[item_generator] generator_"..igen_internal.split(meta:get_string("product"), ':')[2].."_pub at ("..pos.x..", "..pos.y..", "..pos.z..") produced "..meta:get_int("product_amt").." of "..meta:get_string("product"))
                end
            end
            meta:set_int("product_at", process)
            -- Show the percent of the item completion.
            local percent = (process / meta:get_int("product_rate")) * 100
            local percent_format = string.format("%.2f %%", percent)
            meta:set_string("infotext", S("Public Generator "..igen_internal.firstToUpper(infotext_name).." [@1%]", percent_format))
        else
            meta:set_string("infotext", S("Public Generator "..igen_internal.firstToUpper(infotext_name).." [FULL]"))
            -- Note: The node timer still will be fired (It's just nothing will happen)
        end
        return true
    end
    def.allow_metadata_inventory_move = function(pos, from_list, from_index,
            to_list, to_index, count, player)
        return count
    end
    def.allow_metadata_inventory_put = function(pos, listname, index, stack, player)
        return stack:get_count()
    end
    def.allow_metadata_inventory_take = function(pos, listname, index, stack, player)
        return stack:get_count()
    end
    def.on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        minetest.sound_play(def.sound_open, {gain = 0.3,
                pos = pos, max_hear_distance = 10}, true)
        minetest.after(0.2, minetest.show_formspec,
                clicker:get_player_name(),
                ":item_generator:generator_"..igen_internal.split(def.product, ':')[2].."_pub", default.chest.get_chest_formspec(pos))
        default.chest.open_chests[clicker:get_player_name()] = { pos = pos,
                sound = def.sound_close, swap = name }
    end
    def.on_blast = function() end

	def.on_metadata_inventory_move = function(pos, from_list, from_index,
			to_list, to_index, count, player)
        if igen_log_item_movements then
		    minetest.log("action", "[item_generator] ".. player:get_player_name() ..
    			" moves stuff in pub generator at " .. minetest.pos_to_string(pos))
        end
	end
	def.on_metadata_inventory_put = function(pos, listname, index, stack, player)
        if igen_log_item_movements then
		    minetest.log("action", "[item_generator] ".. player:get_player_name() ..
    			" moves " .. stack:get_name() ..
	    		" to pub generator at " .. minetest.pos_to_string(pos))
        end
	end
	def.on_metadata_inventory_take = function(pos, listname, index, stack, player)
        if igen_log_item_movements then
            minetest.log("action", "[item_generator] ".. player:get_player_name() ..
                " takes " .. stack:get_name() ..
                " from pub generator at " .. minetest.pos_to_string(pos))
        end
	end

	local def_opened = table.copy(def)
	local def_closed = table.copy(def)

	def_opened.mesh = "chest_open.obj"
	for i = 1, #def_opened.tiles do
		if type(def_opened.tiles[i]) == "string" then
			def_opened.tiles[i] = {name = def_opened.tiles[i], backface_culling = true}
		elseif def_opened.tiles[i].backface_culling == nil then
			def_opened.tiles[i].backface_culling = true
		end
	end
	def_opened.drop = name
	def_opened.groups.not_in_creative_inventory = 1
	def_opened.selection_box = {
		type = "fixed",
		fixed = { -1/2, -1/2, -1/2, 1/2, 3/16, 1/2 },
	}
	def_opened.can_dig = function()
		--return false
	end
	def_opened.on_blast = function() end

	def_closed.mesh = nil
	def_closed.drawtype = nil
	def_closed.tiles[6] = def.tiles[5] -- swap textures around for "normal"
	def_closed.tiles[5] = def.tiles[3] -- drawtype to make them match the mesh
	def_closed.tiles[3] = def.tiles[3].."^[transformFX"

	minetest.register_node(":item_generator:generator_"..igen_internal.split(def.product, ':')[2].."_pub", def_closed)
	minetest.register_node(":item_generator:generator_"..igen_internal.split(def.product, ':')[2].."_pub_open", def_opened)

end
