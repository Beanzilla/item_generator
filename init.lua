
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

-- Call out to register
dofile(ig_modpath.."/register.lua")

-- Call out to the API
dofile(ig_modpath.."/api.lua")

-- If enabled populate a few generators
if igen_pregenerate_defaults == true then
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
end
