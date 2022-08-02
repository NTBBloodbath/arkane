// ┌                                                          ┐
// │  Copyright (c) 2022 NTBBloodbath. All rights reserved.   │
// │  Use of this source code is governed by a GPLv3 license  │
// │          that can be found in the LICENSE file.          │
// └                                                          ┘
const std = @import("std");

// TODO: Implement character classes (Class and ClassStats)
//       Some notes on this:
//         1. Available character classes will be the following:
//              - Warrior     : Close attack, high defenses
//              - Assasin     : Close attack, low defenses
//              - Archer      : Range attack, ...
//              - Necromancer : Range attack, magician
//
//         2. Each class should have different base statistics.
//              a. Warrior
//                 - attack: 16
//                 - defense: 14
//                 - magic: 0
//              b. Assasin
//                 - attack: 13
//                 - defense: 12
//                 - magic: 0
//              c. Archer
//                 - attack: 12
//                 - defense: 11
//                 - magic: 5
//              d. Necromancer
//                 - attack: 11
//                 - defense: 10
//                 - magic: 10
pub const Class = enum {};
pub const ClassStats = struct {};

// TODO: Implement character statistics (Stats)
//       Some notes on this:
//         1. Character statistics will be the following:
//              - health      : i32
//              - attack*     : i32
//              - defense*    : i32
//              - magic*      : i32
//              - level*^     : Level
//              - souls^      : std.StringHashMap(i32)
//            *: Base statistic value comes from a Class field.
//            ^: Has an additional explanation in another TODO.
//
// TODO: Implement character souls (Stats)
//       Some notes on this:
//         1. Souls makes the character stronger by increasing
//            his statistics, unlike regular level up points in
//            any other RPG, souls aren't consumable.
//
//         2. Souls have different kinds and each kind improves
//            a different character statistic:
//            ┌──────────┬────────────────────┐
//            │ Kind     │ Improved statistic │
//            ├──────────┼────────────────────┤
//            │ Light    │ Health             │
//            │ Darkness │ Defense            │
//            │ Fire     │ Attack             │
//            │ Air      │ Magic              │
//            └──────────┴────────────────────┘
//
//         3. Souls can be obtained through the following ways:
//              - Leveling up
//              - Killing bosses
//              - Completing certain missions
pub const Stats = struct {};

// TODO: Implement character experience (Experience)
//       Some notes on this:
//         1. Experience struct will have the following fields:
//              - current     : i32
//              - next_level  : i32
//
//         2. Experience struct will have the following functions:
//              - getField    : Get a specific Experience field
//              - setField    : Set a specific Experience field
pub const Experience = struct {};

// TODO: Implement character level (Level)
//       Some notes on this:
//         1. Level struct will inherit the following structs:
//              - Experience  : Experience (current and next level)
//
//         2. Level struct will have the following fields:
//              - current     : i32
//              - experience  : Experience
//
//         3. Level struct will have the following functions:
//              - getField    : Get a specific Level field
//              - setField    : Set a specific Level field
pub const Level = struct {};

// TODO: Implement all character information (Character)
//       Some notes on this:
//         1. Character struct will inherit the following structs:
//              - Class       : Character class (e.g. necromancer)
//              - Stats       : Character statistics
//              - Level*      : Character level and experience
//              - Experience* : Experience (current and next level)
//            *: Indirect inheritance made by other inherited struct.
//
//         2. Character struct will have the following fields:
//              - name        : []const u8
//              - class       : Class
//              - stats       : Stats
//              - inventory*  : Inventory
//            *: Fields that has no high priority right now due to
//               their implementation complexity.
//
//         3. Character struct will have the following functions:
//              - init        : Initialize a new character instance
//              - deinit      : Free character instance memory
//              - new         : Create a new character
//              - getClass    : Get character class
//              - getStat*    : Get a character statistic
//              - setStat*    : Set a character statistic
//              - getLevel*   : Get character current level
//              - setLevel*   : Set character current level
//              - getExp*     : Get character experience
//              - setExp*     : Set character experience
//            *: Functions that are wrappers around inherited structs
//               functions, e.g. Character.setExp becomes:
//               Stats.Level.Experience.setField(current, amount)
pub const Character = struct {};
