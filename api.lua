-- Attempt to just get the internals to enable calls to work
local default = rawget(_G, "default") or nil
local hopper = rawget(_G, "hopper") or nil
-- support for MT game translation.
local S = default.get_translator

function igen.add_generator(itemstring, perprocess, processdelay)
    -- Here is where we would add a generator to crafting
    local infotext_name = igen_internal.split(itemstring, ':')[2]
    igen_internal.register_chest("item_generator:generator_"..infotext_name, {
        description = S("Generator "..igen_internal.firstToUpper(infotext_name)),
        tiles = {
            "default_chest_top.png",
            "default_chest_top.png",
            "default_chest_side.png",
            "default_chest_side.png",
            "default_chest_lock.png",
            "default_chest_inside.png"
        },
        sounds = default.node_sound_wood_defaults(),
        sound_open = "default_chest_open",
        sound_close = "default_chest_close",
        groups = {choppy = 2, oddly_breakable_by_hand = 2},
        protected = true,
        product = itemstring,
        product_amt = perprocess,
        product_rate = processdelay,
    })

    -- Make a craft simular to the locked chest
    minetest.register_craft({
        output = "item_generator:generator_"..infotext_name,
        recipe = {
            {"group:wood", itemstring, "group:wood"},
            {"group:wood", "default:steel_ingot", "group:wood"},
            {"group:wood", "group:wood", "group:wood"},
        }
    })

    -- Also include conversion methods for locked chests to item generators
    minetest.register_craft({
        type = "shapeless",
        output = "item_generator:generator_"..infotext_name,
        recipe = {
            "default:chest_locked",
            itemstring,
        }
    })

    -- Downgrade Option, Incase you want a locked chest back
    minetest.register_craft({
        type = "cooking",
        output = "default:chest_locked",
        recipe = "item_generator:generator_"..infotext_name,
        cooktime = 5,
    })

    -- Fuel Option, Incase you really want to dispose of the generator
    minetest.register_craft({
        type = "fuel",
        recipe = "item_generator:generator_"..infotext_name,
        burntime = 35, -- About 5 more seconds compared to default:chest and default:chest_locked
    })
    if igen_log_generator_creation then
        minetest.log("action", "[item_generator] Added Generator for '"..itemstring.."' which will produce "..perprocess.." at a rate of "..processdelay.." seconds.")
    end

    if hopper and igen_hopper_support then -- Add hopper support for some things
        hopper:add_container({
            -- Allow hopper to extract resources (Not allowed since this could be a method of exploit)
		    --{"top", "item_generator:generator_"..infotext_name, "main"},
            -- Allow hopper to insert resources
		    {"bottom", "item_generator:generator_"..infotext_name, "main"},
            -- Allow hopper to insert resources
		    {"side", "item_generator:generator_"..infotext_name, "main"},
            -- Allow hopper to extract resources (Potential exploit)
		    --{"top", "item_generator:generator_"..infotext_name.."_open", "main"},
            -- Allow hopper to insert resources
		    {"bottom", "item_generator:generator_"..infotext_name.."_open", "main"},
            -- Allow hopper to insert resources
		    {"side", "item_generator:generator_"..infotext_name.."_open", "main"},
        })
    end
    if igen_log_hopper_support and igen_log_generator_creation then
        minetest.log("action", "[item_generator] Added hopper support for '"..itemstring.."' Generator.")
    end
end
