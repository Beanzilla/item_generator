-- Attempt to just get the internals to enable calls to work
local default = rawget(_G, "default") or nil
-- support for MT game translation.
local S = minetest.get_translator("item_generator")

function igen.add_generator(itemstring, perprocess, processdelay)
    -- Here is where we would add a generator to crafting
    local infotext_name = igen_internal.split(itemstring, ':')[2]
    if igen_secure_generators and not igen_mcl2_support then
        igen_internal.register_chest("item_generator:generator_"..infotext_name, {
            description = S("Generator "..igen_internal.firstToUpper(infotext_name)),
            tiles = {
                "igen_chest_top.png",
                "igen_chest_top.png",
                "igen_chest_side.png",
                "igen_chest_side.png",
                "igen_chest_lock.png",
                "igen_chest_inside.png"
            },
            sounds = igen_internal.node_sound_wood_defaults(),
            sound_open = "igen_chest_open",
            sound_close = "igen_chest_close",
            groups = {choppy = 2, oddly_breakable_by_hand = 2},
            protected = true,
            product = itemstring,
            product_amt = perprocess,
            product_rate = processdelay,
        })
    else
        igen_internal.register_unsecure_chest("item_generator:generator_"..infotext_name, {
            description = S("Generator "..igen_internal.firstToUpper(infotext_name)),
            tiles = {
                "igen_chest_top.png",
                "igen_chest_top.png",
                "igen_chest_side.png",
                "igen_chest_side.png",
                "igen_chest_lock.png",
                "igen_chest_inside.png"
            },
            sounds = igen_internal.node_sound_wood_defaults(),
            sound_open = "igen_chest_open",
            sound_close = "igen_chest_close",
            groups = {choppy = 2, oddly_breakable_by_hand = 2},
            protected = true,
            product = itemstring,
            product_amt = perprocess,
            product_rate = processdelay,
        })
    end

    -- Make a craft simular to the locked chest
    if default and igen_secure_generators then
        minetest.register_craft({
            output = "item_generator:generator_"..infotext_name,
            recipe = {
                {"group:wood", itemstring, "group:wood"},
                {"group:wood", "default:steel_ingot", "group:wood"},
                {"group:wood", "group:wood", "group:wood"},
            }
        })
    elseif default and not igen_secure_generators then
        minetest.register_craft({
            output = "item_generator:generator_"..infotext_name,
            recipe = {
                {"group:wood", itemstring, "group:wood"},
                {"group:wood", "", "group:wood"},
                {"group:wood", "group:wood", "group:wood"},
            }
        })
    elseif igen_mcl2_support then
        minetest.register_craft({
            output = "item_generator:generator_"..infotext_name,
            recipe = {
                {"group:wood", itemstring, "group:wood"},
                {"group:wood", "", "group:wood"},
                {"group:wood", "group:wood", "group:wood"},
            }
        })
    end

    -- Also include conversion methods for locked chests to item generators
    if default and igen_secure_generators then
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
    elseif default and not igen_secure_generators then
        minetest.register_craft({
            type = "shapeless",
            output = "item_generator:generator_"..infotext_name,
            recipe = {
                "default:chest",
                itemstring,
            }
        })

        -- Downgrade Option, Incase you want a locked chest back
        minetest.register_craft({
            type = "cooking",
            output = "default:chest",
            recipe = "item_generator:generator_"..infotext_name,
            cooktime = 5,
        })
    elseif igen_mcl2_support then
        minetest.register_craft({
            type = "shapeless",
            output = "item_generator:generator_"..infotext_name,
            recipe = {
                "mcl_chests:chest",
                itemstring,
            }
        })

        -- Downgrade Option, Incase you want a locked chest back
        minetest.register_craft({
            type = "cooking",
            output = "mcl_chests:chest",
            recipe = "item_generator:generator_"..infotext_name,
            cooktime = 5,
        })
    end

    -- Fuel Option, Incase you really want to dispose of the generator
    minetest.register_craft({
        type = "fuel",
        recipe = "item_generator:generator_"..infotext_name,
        burntime = 35, -- About 5 more seconds compared to default:chest and default:chest_locked
    })

    minetest.log("action", "[item_generator] Added Generator for '"..itemstring.."' which will produce "..perprocess.." at a rate of "..processdelay.." seconds.")
end
