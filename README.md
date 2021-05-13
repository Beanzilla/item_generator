# Item Generator

This mod provides special chests which produce items automatically.

See my [Item Generator Addon](#) mod which uses the API this mod provides to incorperate some other mods not just default.

## Goals

* Allow multiple `item_generator:generator_<resource>` for a single player. (Where `<resource>` could be anything: `cobble`, `stone`, `coal_lump`, etc)
* Allow multiple mods to incorperate their own generator. (Just simply by using an API)
* Since we will use a `default:chest_locked` we gain security by that. (See [Skeleton Key](https://wiki.minetest.net/Skeleton_Key) on sharing a generator/locked chest)
* Allow unique settings to limit amount produced per "tick" and how many "ticks" need to pass till items are produced. (Per generator)
* Added settings to limit what gets thrown into your logs (debug.txt)

## News

* To "jumpstart" the project I will directly copy the `default:chest_locked` then use bit's and pieces of code from [fsg](https://github.com/AiTechEye/fsg).
* Added hopper mod support.

## Security Minded

This mod was based off of the `defualt:chest_locked` to provide simple security automatically with a little difficulty for some folks to understand how to add others.

### Adding another player to your generator

Get a `default:gold_ingot` and stick it into crafting table to create a [Skeleton Key](https://wiki.minetest.net/Skeleton_Key).

Use the key on the chest (right click) which should convert to a plain Key.

Then give that Key to whom you wish to grant access to **THAT** generator (This doesn't allow them access to every generator, only to just that one).

Repeat as needed for other players and other generators. (To revoke access either get the Key back from them or replace the generator, which will break all keys)

> I'm thinking of maybe adding protector (redo) support for it's chest which I think will be easier to manange security on. (You get a gui formspec to edit who can access the gen)

## Hopper mod

Hoppers can insert only. (Due to the natural security issue of having goods directly extracted from the generator)

> Due to complexity of security, I will not be adding pipeworks as then someone else could extract resouces from your generators.