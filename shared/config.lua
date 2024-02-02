Config = {}
Config.Locale = 'en'
Config.WaterHeight = 200.0  -- if above this height,it will activate the shark before a warning..Activated = function(sender, index)
Config.TimeUntilAttack = 10 -- seconds
Config.RefreshTime = 5000   -- how often the script checks if the player is in DEEP water
Translation = {
    ['en'] = {
        ["sharkspawned"] = "lookout a shark is onto you..",
        ["sharkdespawned"] = "the shark has lost your scent",
        ["sharkname"] = "shark",
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
}
