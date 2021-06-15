-- Attempt to just get the internals to enable calls to work (Auto-Detect)
local default = rawget(_G, "default") or nil
-- support for MT game translation.
local S = minetest.get_translator("item_generator")

function igen.add_generator(itemstring, perprocess, processdelay)
    -- Here is where we would add a generator to crafting
    local infotext_name = igen_internal.split(itemstring, ':')[2]
    if igen_internal.default ~= nil then
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
        if igen_allow_insecure_generators then
            igen_internal.register_insecure_chest("item_generator:generator_"..infotext_name.."_pub", {
                description = S("Public Generator "..igen_internal.firstToUpper(infotext_name)),
                tiles = {
                    "default_chest_top.png",
                    "default_chest_top.png",
                    "default_chest_side.png",
                    "default_chest_side.png",
                    "default_chest_front.png",
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
        end
    end

    -- Make a craft simular to the locked chest
    if igen_internal.default ~= nil then
        minetest.register_craft({
            output = "item_generator:generator_"..infotext_name,
            recipe = {
                {"group:wood", itemstring, "group:wood"},
                {"group:wood", "default:steel_ingot", "group:wood"},
                {"group:wood", "group:wood", "group:wood"},
            }
        })
        if igen_allow_insecure_generators then
            minetest.register_craft({
                output = "item_generator:generator_"..infotext_name.."_pub",
                recipe = {
                    {"group:wood", itemstring, "group:wood"},
                    {"group:wood", "", "group:wood"},
                    {"group:wood", "group:wood", "group:wood"},
                }
            })
        end
    end

    -- Also include conversion methods for locked chests to item generators
    if igen_internal.default ~= nil then
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
        if igen_allow_insecure_generators then
            minetest.register_craft({
                type = "shapeless",
                output = "item_generator:generator_"..infotext_name.."_pub",
                recipe = {
                    "default:chest",
                    itemstring,
                }
            })
            -- Downgrade Option, Incase you want a chest back
            minetest.register_craft({
                type = "cooking",
                output = "default:chest",
                recipe = "item_generator:generator_"..infotext_name.."_pub",
                cooktime = 5,
            })
        end
    end

    -- Fuel Option, Incase you really want to dispose of the generator
    if igen_internal.default ~= nil then
        minetest.register_craft({
            type = "fuel",
            recipe = "item_generator:generator_"..infotext_name,
            burntime = 35, -- About 5 more seconds compared to default:chest and default:chest_locked
        })
        if igen_allow_insecure_generators then
            minetest.register_craft({
                type = "fuel",
                recipe = "item_generator:generator_"..infotext_name.."_pub",
                burntime = 35, -- About 5 more seconds compared to default:chest and default:chest_locked
            })
        end
    end

    minetest.log("action", "[item_generator] Added Generator for '"..itemstring.."' @ "..perprocess.."/"..processdelay)
end
