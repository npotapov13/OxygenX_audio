ui_print "- Запуск customize.sh скрипт"

ui_print "*******************************"
ui_print "*       OxygenX + HibyFC4     *"
ui_print "*           V1.0.6            *"
ui_print "*******************************"         

VERSION=$(grep 'version=' $MODPATH/module.prop | cut -d'=' -f2)
ui_print "- Установка $VERSION"

# Пример замены файлов, не используется
REPLACE_EXAMPLE="/system/app/Youtube /system/priv-app/SystemUI /system/priv-app/Settings /system/framework"

REPLACE="
"

POSTFSDATA=true

# Настройка прав доступа
ui_print "- начало выдачи разрешений"

set_permissions() {
    # Установить базовые права: директории 0755, файлы 0644
    set_perm_recursive $MODPATH 0 0 0755 0644
    
    # Установить права 0755 для скриптов модуля
    for script in post-fs-data.sh service.sh sepolisy.sh; do
        if [ -f "$MODPATH/$script" ]; then
            set_perm "$MODPATH/$script" 0 0 0755
        fi
    done
    
    # Установить права 0755 для файлов в system/bin и system/xbin
    for dir in bin xbin; do
        if [ -d "$MODPATH/system/$dir" ]; then
            set_perm_recursive "$MODPATH/system/$dir" 0 0 0755 0755
        fi
    done
}

set_permissions

ui_print "- Конец выдачи разрешений"