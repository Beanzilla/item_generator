# Item Generator

This mod provides special chests which produce items automatically.

See my [Item Generator Addon](https://github.com/Beanzilla/item_generator_addon) mod which uses the API this mod provides to incorperate some other mods not just default.

## Disclaimer

This mod was built for default Minetest, it will **NOT** work with MineClone2. (I was trying to get it to work but I am a single person working on this mod, with limited knowledge and resources)

## Goals

* Allow multiple generators for a single player. (Yes, you can have 50 gens and I could have 105 gens, there is multi-player support in this)
* Allow multiple mods to incorperate their own generator. (Just simply by using the API)
* Since we will use a `default:chest_locked` we gain security by that. (See [Skeleton Key](https://wiki.minetest.net/Skeleton_Key) on sharing a generator/locked chest) Or you can make the generator a public one at craft time.
* Allow unique settings to limit amount produced per "tick" and how many "ticks" need to pass till items are produced. (Per generator)
* Added settings to limit what gets thrown into your logs (debug.txt)

## News

* To "jumpstart" the project I will directly copy the `default:chest_locked` then use bit's and pieces of code from [fsg](https://github.com/AiTechEye/fsg).
* Added hopper mod support. (Want it? [Here](https://github.com/minetest-mods/hopper))
* Want to share say free food? but want that a generator? No problems, just omit the steel ingot (iron ingot) in the middle of the chest to make a Public Generator. (For those who want a generator Public)

## Security Minded

This mod was based off of the `default:chest_locked` to provide simple security automatically with a little difficulty for some folks to understand how to add others.

If you want you can allow `igen_allow_insecure_generators` (Basically it means there is a craftable public version that everyone can access)

### Adding another player to your generator (Non-Public Generators only)

Get a `default:gold_ingot` and stick it into crafting table to create a [Skeleton Key](https://wiki.minetest.net/Skeleton_Key).

Use the key on the chest (left click) which should convert to a plain Key.

Then give that Key to whom you wish to grant access to **THAT** generator (This doesn't allow them access to every generator, only to just that one).

Repeat as needed for other players and other generators. (To revoke access either get the Key back from them or replace the generator, which will break all keys)

## Hopper mod

Hoppers can insert only. (Due to the natural security issue of having goods directly extracted from the generator)

> Due to complexity of security, I will not be adding pipeworks as then someone else could extract resouces from your generators.

## Settings

Checkout the settings.lua file for your settings. (Edit to your liking)

Want to "adjust" a particular generator? (If it's a default item it will be located in `init.lua` starting at line 43.
(Or the particular mod_name in the item_generator_addon in the addons directory)
