-- Please take this example with a grain of salt, as I used chatgpt to create it.
local de = {
    menu = {
        close = "Schließen",
        back = "Zurück",
        packing_device = "Verpackungsmaschine",
        open_container = "Behälter öffnen",
        package_type = "Art der Verpackung",
        finish_packaging = "Verpackung abschließen",
        select_package_type = 'Wählen Sie die Art der Verpackung',
    },
    packager = {
        subheader = "Verpackungsmaschinen werden verwendet, um einzelne Pakete und Behälter mit Flüssigkeiten, Pulvern, Sprays und ähnlichen Inhalten zu versiegeln.",
        finish_disabled = "Wählen Sie eine Art der Verpackung",
    },
    -- notifications
    success = {
        package_opened_successfully = 'Package erfolgreich geöffnet'
    },
    info = {
        package_items_left = 'Es verbleiben noch Gegenstände im Paket',
        inventory_space_needed = 'Bitte schaffen Sie Platz in Ihrem Inventar, um alle Gegenstände zu erhalten'
    },
    errors = {
        process_already_started = 'Prozess bereits gestartet'
    },
    -- Webhook
    mystery_box_opened_title = "Geöffneter Mystery Box Gegenstand",
    mystery_box_contents = "🎁 Mystery Box Inhalt 🎁",
    received_items = "🛍️ Erhaltene Gegenstände 🛍️",
    no_received_items = "😕 Der Spieler hat keine Gegenstände erhalten 😕",
    remaining_items = "👀 Verbleibende Gegenstände 👀",
    received_money = "💰 Erhaltenes Geld 💰",
    no_received_money = "💸 Geld wurde bereits erhalten 💸",
    opening_message = 'Öffnen...'
}

Locale.extend('de', de)
