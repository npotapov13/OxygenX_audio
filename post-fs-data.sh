#!/system/bin/sh
# Не предполагайте, где будет расположен ваш модуль.
# Всегда используйте $MODDIR, если нужно знать, где находится этот скрипт и модуль.
# Это обеспечит работоспособность модуля, если Magisk изменит точку монтирования в будущем.
MODDIR=${0%/*}

# Этот скрипт будет выполнен в режиме post-fs-data
# Разрешить камере HAL доступ к устаревшим путям /data

# Пример: убедиться, что директория существует и имеет правильный контекст SELinux
mkdir -p /data/vendor/camera
chown system:camera /data/vendor/camera
chmod 0770 /data/vendor/camera
chcon u:object_r:vendor_camera_data_file:s0 /data/vendor/camera

# Пример: разрешить домену hal_camera_default доступ к файлам и директориям
magiskpolicy --live "allow hal_camera_default vendor_camera_data_file dir { read write }"
magiskpolicy --live "allow hal_camera_default vendor_camera_data_file file { read write }"

# Примечание: вам нужно знать точные типы SELinux и домены для вашего устройства.
# Проверьте dmesg или logcat на наличие отказов avc, чтобы увидеть, что именно блокируется.
# Например, вы можете увидеть что-то вроде:
# avc: denied { read } for path="/data/vendor/camera" dev="sda" ino=12345 scontext=u:r:hal_camera_default:s0 tcontext=u:object_r:vendor_camera_data_file:s0 tclass=dir permissive=0

# На основе этого добавьте необходимые правила, например:
# magiskpolicy --live "allow hal_camera_default vendor_camera_data_file dir read"