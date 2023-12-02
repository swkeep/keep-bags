if IsHarmonyStarted() then return end

-- created it by using ChatGPT
local de = {
    menu = {
        close = "Schließen",
        lockpick_header = "Lockpick",
        lockpick_item_header = "%s [Slot: %s]",
    },
    input = {
        enter_password = "Passwort eingeben",
        set_password = "Passwort setzen",
        password_title = "Passwort eingeben",
    },
    -- Benachrichtigungen
    success = {
        package_opened_successfully = 'Das Paket wurde erfolgreich geöffnet',
        password_set = "Das Passwort wurde festgelegt",
    },
    info = {
        package_items_left = 'Es sind noch Gegenstände im Paket',
        inventory_space_needed = 'Bitte schaffen Sie Platz in Ihrem Inventar, um alle Gegenstände zu erhalten'
    },
    progress = {
        lockpicking = "Lockpicking [Slot: %s]",
    },
    errors = {
        cancelled = "Abgebrochen",
        try_better_password = "Versuchen Sie ein besseres Passwort",
        wrong_password = "Falsches Passwort",
        process_already_started = 'Prozess bereits gestartet',
        max_backpacks = 'Sie können nicht mehr als %s Rucksäcke tragen',
        multiple_backpacks = 'Aktion nicht zulässig, wenn mehrere Rucksäcke getragen werden!',
        backpack_self_insertion = 'Oh, Schatz! Es sieht so aus, als ob jemand seinen Rucksack in sich selbst stecken könnte.',
        backpack_rule_breaker = "Oh Snap! Es sieht so aus, als hätten wir einen Rucksackregelbrecher im Haus. Nachrichtenflash: Sie können keinen Rucksack einfach in einem anderen verstecken.",
        backpack_crammed =
        "Pass auf, Kumpel! Ich weiß, du bist aufgeregt über deinen schicken Rucksack, aber lass uns realistisch bleiben. Glaubst du wirklich, es ist eine gute Idee, %s hineinzupressen?"
    },
}

Locale.extend('de', de)
