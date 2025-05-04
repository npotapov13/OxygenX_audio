#!/system/bin/sh
# Скрипт для настройки политик SELinux в модуле Magisk
# Используется для разрешения доступа, например, для камеры HAL или других компонентов

# Определение MODDIR для переносимости модуля
MODDIR=${0%/*}

# Вывод сообщения о начале выполнения
echo "Applying SELinux policies for OxygenX module"

# Разрешить system_server запись в файлы типа system_file
# ВНИМАНИЕ: Это правило слишком широкое, уточните, если возможно
magiskpolicy --live "allow system_server system_file file write"

# Пример: Разрешить доступ камеры HAL к vendor_camera_data_file
# Проверьте логи SELinux (dmesg | grep avc) для точных доменов и типов
magiskpolicy --live "allow hal_camera_default vendor_camera_data_file dir { read write }"
magiskpolicy --live "allow hal_camera_default vendor_camera_data_file file { read write }"

# Пример: Разрешить init изменение меток для указанных типов
magiskpolicy --live "allow init system_file dir relabelfrom"
magiskpolicy --live "allow init system_file file relabelfrom"
magiskpolicy --live "allow init vendor_file dir relabelfrom"
magiskpolicy --live "allow init vendor_file file relabelfrom"
magiskpolicy --live "allow init vendor_configs_file dir relabelfrom"
magiskpolicy --live "allow init vendor_configs_file file relabelfrom"

# Проверка успешности применения правил
if [ $? -eq 0 ]; then
    echo "SELinux policies applied successfully"
else
    echo "Failed to apply SELinux policies, check logs"
fi

# Инструкция для отладки:
# 1. Проверьте отказы SELinux с помощью: dmesg | grep avc
# 2. Найдите строки, например:
#    avc: denied { write } for path="/data/vendor/camera" scontext=u:r:hal_camera_default:s0 tcontext=u:object_r:vendor_camera_data_file:s0
# 3. Добавьте соответствующее правило, например:
#    magiskpolicy --live "allow hal_camera_default vendor_camera_data_file file write"