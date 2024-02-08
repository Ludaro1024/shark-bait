Config = {}
Config.Locale = 'en'
Config.WaterHeight = 150.0                                          -- if above this height,it will activate the shark before a warning and be aware that it doesnt go over 300m (300m is max)
Config.TimeUntilAttack = 10                                         -- how many seconds until the shark goes and attacks you!
Config.RefreshTime = 5                                              -- how often the script checks if the player is in DEEP water (seconds)
Config.Debug = false                                                -- if you set this to true it will show you how deep you are (if you are in danger aswell)
Config.Zones = {  } -- if you want to add more zones, just add more coords, and the radius of the zone as a table example: { vector3(-1602.0, -1192.0, 0.0), 20 },
Translation = {
    ['en'] = {
        ["sharkspawned"] = "lookout a shark is onto you..",
        ["sharkdespawned"] = "the shark has lost your scent",
        ["sharkname"] = "shark",
    },
    ["da"] = {
        ["sharkspawned"] = "Vær opmærksom, haj haj..",
        ["sharkdespawned"] = "du slap fri denne gang",
        ["sharkname"] = "Sød lille haj efter dig",
    },
    ["de"] = {
        ["sharkspawned"] = "Achtung, ein Hai ist auf dich aufmerksam geworden..",
        ["sharkdespawned"] = "Der Hai hat deine Spur verloren",
        ["sharkname"] = "Hai",
    },
    ["fr"] = {
        ["sharkspawned"] = "Attention, un requin est sur vous..",
        ["sharkdespawned"] = "Le requin a perdu votre odeur",
        ["sharkname"] = "requin",
    },
    ["es"] = {
        ["sharkspawned"] = "cuidado, un tiburón está sobre ti..",
        ["sharkdespawned"] = "el tiburón ha perdido tu olor",
        ["sharkname"] = "tiburón",
    },
    ["it"] = {
        ["sharkspawned"] = "attenzione, uno squalo è su di te..",
        ["sharkdespawned"] = "lo squalo ha perso il tuo odore",
        ["sharkname"] = "squalo",
    },
    ["pt"] = {
        ["sharkspawned"] = "cuidado, um tubarão está em cima de você..",
        ["sharkdespawned"] = "o tubarão perdeu seu cheiro",
        ["sharkname"] = "tubarão",
    },
    ["ru"] = {
        ["sharkspawned"] = "осторожно, акула на тебя..",
        ["sharkdespawned"] = "акула потеряла твой запах",
        ["sharkname"] = "акула",
    },
    ["pl"] = {
        ["sharkspawned"] = "uwaga, rekin jest na ciebie..",
        ["sharkdespawned"] = "rekin zgubił twój zapach",
        ["sharkname"] = "rekin",
    },
    ["tr"] = {
        ["sharkspawned"] = "dikkat, bir köpekbalığı üzerinizde..",
        ["sharkdespawned"] = "köpekbalığı kokunu kaybetti",
        ["sharkname"] = "köpekbalığı",
    },
    ["nl"] = {
        ["sharkspawned"] = "Pas op, een haai heeft je in de gaten…",
        ["sharkdespawned"] = "De haai is je kwijt",
        ["haainaam"] = "haai",
    },
}
