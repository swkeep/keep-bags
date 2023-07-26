if IsHarmonyStarted() then return end

-- Please take this example with a grain of salt, as I created it using ChatGPT.
local ar = {
    menu = {
        close = "اغلاق",
        lockpick_header = "فتاحة الأقفال",
        lockpick_item_header = "%s [المكان: %s]",
    },
    input = {
        enter_password = "ادخل كلمة المرور",
        set_password = "ضع كلمة السر",
        password_title = "أدخل كلمة السر",
    },
    -- إشعارات
    success = {
        package_opened_successfully = 'تم فتح الصندوق بنجاح',
        password_set = "تم تعيين كلمة السر",
    },
    info = {
        package_items_left = 'هناك عناصر متبقية في الصندوق',
        inventory_space_needed = 'يرجى تحرير مساحة في مخزنك لاستقبال جميع العناصر'
    },
    progress = {
        lockpicking = "فتح الأقفال [المكان: %s]",
    },
    errors = {
        cancelled = "أُلغيت",
        try_better_password = "جرّب كلمة سر أفضل",
        wrong_password = "كلمة مرور خاطئة",
        process_already_started = 'العملية بدأت بالفعل',
        max_backpacks = 'لا يمكنك حمل أكثر من %s حقيبة ظهر',
        multiple_backpacks = 'الإجراء غير مسموح به عند حمل عدة حقائب ظهر!',
        backpack_self_insertion = 'أوه، عزيزي! يبدو أن شخصاً ما فكر في أنه يمكنه دفع حقيبته الظهر داخل نفسها.',
        backpack_rule_breaker = "أوه، نحن نشهد اختراق قواعد الحقائب الظهرية. لا يمكنك فقط إخفاء حقيبة ظهر داخل أخرى.",
        backpack_crammed = "استمع، صديقي! أعلم أنك متحمس لحقيبتك الظهرية الفاخرة، ولكن دعونا نكون واقعيين. هل تعتقد حقًا أنه من الجيد ان تضغ جميع %s فيها؟"
    },
}

Locale.extend('ar', ar, true)
