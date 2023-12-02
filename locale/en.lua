if IsHarmonyStarted() then return end

-- do not change anything in this file if you don't know what are you doing
local Shared = exports['keep-harmony']:Shared()

Locale = Shared.Locale.new {
    menu = {
        close = "Close",
        lockpick_header = "Lockpick",
        lockpick_item_header = "%s [slot: %s]",
    },
    input = {
        enter_password = "Enter Password",
        set_password = "Set Password",
        password_title = "Enter Password",
    },
    success = {
        package_opened = 'Successfully opened the package',
        password_set = "Password set successfully",
    },
    info = {
        items_left = 'Items remaining in the package',
        inventory_space_needed = 'Clear inventory space to receive all items'
    },
    progress = {
        lockpicking = "Lockpicking [slot: %s]",
    },
    errors = {
        cancelled = "Cancelled",
        try_better_password = "Try a stronger password",
        wrong_password = "Incorrect password",
        process_already_started = 'Process already initiated',
        max_backpacks = 'Cannot carry more than %s backpacks',
        multiple_backpacks = 'Action not allowed with multiple backpacks!',
        backpack_self_insertion = 'You can not do this',
        backpack_rule_breaker = "Oops! You can't stash one backpack inside another one",
        backpack_crammed = "Hold on! %s was in your backpack! you can not do that"
    },
}
