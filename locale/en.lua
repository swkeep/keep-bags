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
        try_better_password = "Please choose a stronger password",
        wrong_password = "Incorrect password entered",
        process_already_started = 'Process already in progress',
        max_backpacks = 'You cannot carry more than %s backpacks',
        multiple_backpacks = 'Action not permitted with multiple backpacks',
        backpack_self_insertion = 'You are not allowed to perform this action',
        backpack_rule_breaker = "Oops! You can't stash one backpack inside another",
        backpack_crammed = "Some items cannot be placed there. They will be returned to you"
    },
}
