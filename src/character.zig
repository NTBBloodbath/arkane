// ┌                                                          ┐
// │  Copyright (c) 2023 NTBBloodbath. All rights reserved.   │
// │  Use of this source code is governed by a GPLv3 license  │
// │          that can be found in the LICENSE file.          │
// └                                                          ┘
const std = @import("std");

// DONE: Implement character classes (Class and ClassStats)
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
const Class = enum { Warrior, Assasin, Archer, Necromancer };

/// Character class statistics
const ClassStats = struct {
    /// Base attack
    attack: i32,
    /// Base defense
    defense: i32,
    /// Base magic
    magic: i32,
};
/// Warrior class base statistics
const WarriorStats = ClassStats{ .attack = 16, .defense = 14, .magic = 0 };
/// Assasin class base statistics
const AssasinStats = ClassStats{ .attack = 13, .defense = 12, .magic = 0 };
/// Archer class base statistics
const ArcherStats = ClassStats{ .attack = 12, .defense = 11, .magic = 5 };
/// Necromancer class base statistics
const NecromancerStats = ClassStats{ .attack = 11, .defense = 10, .magic = 10 };

// DONE: Implement character experience (Experience)
//       Some notes on this:
//         1. Experience struct will have the following fields:
//              - current     : i32
//              - next_level  : i32
//
//         2. Experience struct will have the following functions:
//              - increase    : Increase a Experience field value
const Experience = struct {
    /// Current character experience
    current: i32 = 0,
    /// Required experience to level up
    next_level: i32,

    /// Increase a Experience `field` value in `amount`
    pub fn increase(self: *Experience, comptime field: []const u8, amount: i32) void {
        @field(self, field) += amount;
    }

    test "Experience: get current experience and increase it" {
        var experience = Experience{ .next_level = 10 };

        // Woops, player has 0 experience right now
        try std.testing.expectEqual(experience.current, 0);
        // It seems like player did slash a goblin, let's award him!
        experience.increase("current", 6);
        try std.testing.expectEqual(experience.current, 6);
    }

    test "Experience: reach next_level value and increase it (leveling up)" {
        var experience = Experience{ .next_level = 10 };

        // Woops, player has 0 experience right now
        try std.testing.expectEqual(experience.current, 0);
        // It seems like player did slash a goblin, let's award him!
        experience.increase("current", 6);
        try std.testing.expectEqual(experience.current, 6);
        // Player did kill a slime now and it seems like he did level up.
        // Let's increase next_level value now!
        experience.increase("current", 4);
        if (experience.current == experience.next_level)
            experience.increase("next_level", 15);
        try std.testing.expectEqual(experience.next_level, 25);
    }
};

// DONE: Implement character level (Level)
//       Some notes on this:
//         1. Level struct will inherit the following structs:
//              - Experience  : Experience (current and next level)
//
//         2. Level struct will have the following fields:
//              - current     : i32
//              - experience  : Experience
//
//         3. Level struct will have the following functions:
//              - increase    : Set current character level
const Level = struct {
    /// Current character level. Default is `1`
    current: i32 = 1,
    /// Character experience
    experience: Experience,

    /// Increase current character level by `1`
    pub fn increase(self: *Level) void {
        @field(self, "current") += 1;
    }

    test "Level: get current level and increase it" {
        var experience = Experience{ .next_level = 10 };
        var level = Level{ .current = 1, .experience = experience };

        // Is initial level equal to 1?
        try std.testing.expectEqual(level.current, 1);
        // Increase current level then compare it again
        level.increase(1);
        try std.testing.expectEqual(level.current, 2);
    }
};

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
//            │   Kind   │ Improved statistic │
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
const Stats = struct {
    /// Character health. Default is `100`
    health: i32 = 100,
    /// Character attack
    attack: i32,
    /// Character defense
    defense: i32,
    /// Character magic
    magic: i32,
    /// Character gold. Default is `0`
    gold: i32 = 0,
    /// Character level
    level: Level,
    /// Character souls
    souls: std.StringHashMap(i32),
};

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
//               Stats.Level.Experience.increase(current, amount)
pub const Character = struct {};

test {
    _ = Experience;
    _ = Level;
}
