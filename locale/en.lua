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
        password_title = "Enter the password",
    },

    -- notifications
    success = {
        package_opened_successfully = 'Successfully opened the package',
        password_set = "Password has been set",
    },
    info = {
        package_items_left = 'There are items left in the package',
        inventory_space_needed = 'Please clear up space in your inventory to receive all items'
    },
    progress = {
        lockpicking = "Lockpicking [slot: %s]",
    },
    errors = {
        cancelled = "Cancelled",
        try_better_password = "Try a better password",
        wrong_password = "Wrong password",
        process_already_started = 'Process already started',
        max_backpacks = 'You can not carry more than %s backpacks',
        multiple_backpacks = 'Action not allowd when carrying multiple backpacks!',
        backpack_self_insertion = 'Oh, honey! Looks like someone thought they could shove their backpack inside itself.',
        backpack_rule_breaker = "Oh snap! Looks like we have a backpack rule-breaker in the house. Newsflash, you can't just stash one backpack inside another.",
        backpack_crammed = "Listen up, buddy! I know you're excited about your fancy backpack, but let's get real. You really think it's a good idea to cram %s inside?"

    },
}
