-- Initalize general settup
local ig_modpath = minetest.get_modpath("item_generator")
igen = {} -- For API
igen_internal = {} -- For internals (Do not expose to public, they should use the API)

-- Assistants
function igen_internal.firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function igen_internal.split(inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end


-- Call out to settings
dofile(ig_modpath.."/settings.lua")

-- Call out to defaulter
dofile(ig_modpath.."/defaulter.lua")

-- Call out to register
dofile(ig_modpath.."/register.lua")

-- Call out to the API
dofile(ig_modpath.."/api.lua")

-- If enabled populate a few generators
if igen_pregenerate_defaults == true and minetest.get_modpath("default") then
    igen.add_generator("default:cobble", 2, 20)
    -- Issue: This only allow Apple Trees to be used as generators
    igen.add_generator("default:tree", 1, 25)
    --igen.add_generator("default:wood", 1, 30) -- Can't use any wood since it's used in default:chest and default:chest_locked!
    igen.add_generator("default:apple", 4, 15)
    igen.add_generator("default:leaves", 2, 24)
    igen.add_generator("default:sapling", 1, 26)
    -- Ores
    igen.add_generator("default:coal_lump", 1, 35)
    igen.add_generator("default:iron_lump", 1, 36)
    igen.add_generator("default:gold_lump", 1, 37)
    igen.add_generator("default:copper_lump", 1, 38)
    igen.add_generator("default:tin_lump", 1, 39)
    igen.add_generator("default:mese_crystal", 1, 40)
    igen.add_generator("default:diamond", 1, 45)
    -- Buckets
    igen.add_generator("bucket:bucket_lava", 1, 100)
    igen.add_generator("bucket:bucket_water", 1, 90)
    -- Dyes
    igen.add_generator("dye:white", 4, 19)
    igen.add_generator("dye:black", 4, 19)
    igen.add_generator("dye:dark_grey", 4, 19)
    igen.add_generator("dye:grey", 4, 19)
    igen.add_generator("dye:blue", 4, 19)
    igen.add_generator("dye:cyan", 4, 19)
    igen.add_generator("dye:green", 4, 19)
    igen.add_generator("dye:dark_green", 4, 19)
    igen.add_generator("dye:yellow", 4, 19)
    igen.add_generator("dye:orange", 4, 19)
    igen.add_generator("dye:brown", 4, 19)
    igen.add_generator("dye:red", 4, 19)
    igen.add_generator("dye:pink", 4, 19)
    igen.add_generator("dye:magenta", 4, 19)
    igen.add_generator("dye:violet", 4, 19)
    -- And more!
    --igen.add_generator("wool:white", 1, 21) Use the Cotton generator to make cotton then make that into wool.
    igen.add_generator("default:torch", 1, 16)
    igen.add_generator("default:sand", 2, 21)
    igen.add_generator("default:dirt", 1, 10)
    igen.add_generator("default:papyrus", 3, 14)
    igen.add_generator("default:gravel", 1, 13)
    igen.add_generator("default:clay_lump", 1, 10)
    igen.add_generator("default:ice", 1, 15)
    igen.add_generator("default:snow", 9, 9)
    minetest.log("action", "[igen] default loaded!")
elseif igen_pregenerate_defaults == true and minetest.get_modpath("mcl_core") then
    igen.add_generator("mcl_core:tree", 1, 25)
    igen.add_generator("mcl_core:dirt", 1, 10)
    igen.add_generator("mcl_core:sand", 2, 21)
    --[[
    igen.add_generator("mcl_farming:wheat_item", 1, 12)
    igen.add_generator("mcl_farming:carrot_item", 1, 12)
    igen.add_generator("mcl_farming:beetroot_item", 1, 12)
    igen.add_generator("mcl_farming:potato_item", 1, 12)
    igen.add_generator("mcl_farming:pumpkin", 1, 12)
    igen.add_generator("mcl_farming:melon_item", 1, 12)
    igen.add_generator("mcl_core:coal_lump", 1, 35)
    igen.add_generator("mcl_core:stone_with_iron", 1, 36)
    igen.add_generator("mcl_core:stone_with_gold", 1, 37)
    igen.add_generator("mesecons:redstone", 1, 30)
    igen.add_generator("mcl_core:emerald", 1, 38)
    igen.add_generator("mcl_core:diamond", 1, 39)
    igen.add_generator("mcl_core:mycelium", 1, 20)
    igen.add_generator("mcl_core:gravel", 1, 22)
    igen.add_generator("mcl_core:redsand", 2, 22)
    igen.add_generator("mcl_core:clay", 1, 16)
    igen.add_generator("mcl_core:cobble", 2, 20)
    igen.add_generator("mcl_dye:white", 4, 19)
    igen.add_generator("mcl_dye:grey", 4, 19)
    igen.add_generator("mcl_dye:dark_grey", 4, 19)
    igen.add_generator("mcl_dye:black", 4, 19)
    igen.add_generator("mcl_dye:red", 4, 19)
    igen.add_generator("mcl_dye:violet", 4, 19)
    igen.add_generator("mcl_dye:yellow", 4, 19)
    igen.add_generator("mcl_dye:dark_green", 4, 19)
    igen.add_generator("mcl_dye:cyan", 4, 19)
    igen.add_generator("mcl_dye:blue", 4, 19)
    igen.add_generator("mcl_dye:magenta", 4, 19)
    igen.add_generator("mcl_dye:orange", 4, 19)
    igen.add_generator("mcl_dye:brown", 4, 19)
    igen.add_generator("mcl_dye:pink", 4, 19)
    igen.add_generator("mcl_dye:green", 4, 19)
    igen.add_generator("mcl_dye:lightblue", 4, 19)
    igen.add_generator("mcl_buckets:bucket_water", 1, 30)
    igen.add_generator("mcl_buckets:bucket_lava", 1, 40)
    igen.add_generator("mcl_mobitems:mutton", 1, 30)
    igen.add_generator("mcl_mobitems:beef", 1, 30)
    igen.add_generator("mcl_mobitems:chicken", 1, 30)
    igen.add_generator("mcl_mobitems:porkchop", 1, 30)
    igen.add_generator("mcl_mobitems:rabbit", 1, 30)
    igen.add_generator("mcl_mobitems:milk_bucket", 1, 35)
    igen.add_generator("mcl_mobitems:spider_eye", 1, 18)
    igen.add_generator("mcl_mobitems:rotten_flesh", 1, 18)
    igen.add_generator("mcl_mobitems:bone", 1, 18)
    igen.add_generator("mcl_mobitems:string", 1, 18)
    igen.add_generator("mcl_mobitems:blaze_rod", 1, 24)
    igen.add_generator("mcl_mobitems:magma_cream", 1, 18)
    igen.add_generator("mcl_mobitems:ghast_tear", 1, 18)
    igen.add_generator("mcl_mobitems:nether_star", 1, 64)
    igen.add_generator("mcl_mobitems:feather", 1, 14)
    igen.add_generator("mcl_mobitems:rabbit_hide", 1, 14)
    igen.add_generator("mcl_mobitems:rabbit_foot", 1, 28)
    igen.add_generator("mcl_mobitems:saddle", 1, 64)
    igen.add_generator("mcl_mobitems:shulker_shell", 1, 64)
    igen.add_generator("mcl_mobitems:slimeball", 1, 5)
    igen.add_generator("mcl_mobitems:gunpowder", 1, 12)
    igen.add_generator("mcl_mobitems:leather", 1, 14)
    igen.add_generator("mcl_throwing:egg", 1, 14)
    igen.add_generator("mcl_core:cactus", 1, 12)
    igen.add_generator("mcl_core:reeds", 1, 12)
    igen.add_generator("mcl_wool:white", 1, 16)
    igen.add_generator("mcl_sponges:sponge", 1, 64)
    igen.add_generator("mcl_mushrooms:mushroom_red", 1, 16)
    igen.add_generator("mcl_mushrooms:mushroom_brown", 1, 16)
    igen.add_generator("mcl_torches:torch", 2, 14)
    igen.add_generator("mobs_mc:totem", 1, 128)
    igen.add_generator("mcl_nether:glowstone_dust", 1, 20)
    igen.add_generator("mcl_nether:quartz", 1, 40)
    igen.add_generator("mcl_nether:netherrack", 2, 21)
    igen.add_generator("mcl_nether:magma", 1, 24)
    igen.add_generator("mcl_nether:soul_sand", 1, 22)
    igen.add_generator("mcl_end:end_stone", 2, 26)
    igen.add_generator("mcl_end:chorus_flower", 1, 30)
    igen.add_generator("mcl_end:chorus_fruit", 1, 32)
    igen.add_generator("mcl_end:purpur_block", 1, 30)
    igen.add_generator("mcl_end:end_rod", 1, 64)
    igen.add_generator("mcl_end:dragon_egg", 1, 128)
    igen.add_generator("mcl_end:ender_eye", 1, 30)
    igen.add_generator("mcl_throwing:ender_pearl", 1, 30)
    igen.add_generator("mcl_throwing:snowball", 1, 10)
    igen.add_generator("mcl_throwing:egg", 1, 12)
    ]]--
    minetest.log("action", "[igen] mineclone2 loaded!")
end
