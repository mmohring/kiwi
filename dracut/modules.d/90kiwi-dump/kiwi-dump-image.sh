#!/bin/bash
type getarg >/dev/null 2>&1 || . /lib/dracut-lib.sh
type setup_debug >/dev/null 2>&1 || . /lib/kiwi-lib.sh
type run_dialog >/dev/null 2>&1 || . /lib/kiwi-dialog-lib.sh

#======================================
# Functions
#--------------------------------------
function get_disk_list {
    local disk_size
    local disk_device
    local disk_device_by_id
    local disk_meta
    local item_status=on
    local list_items
    for disk_meta in $(
        lsblk -n -r -o NAME,SIZE,TYPE | grep disk | tr ' ' ":"
    );do
        disk_device="/dev/$(echo "${disk_meta}" | cut -f1 -d:)"
        disk_size=$(echo "${disk_meta}" | cut -f2 -d:)
        disk_device_by_id=$(
            get_persistent_device_from_unix_node "${disk_device}" "by-id"
        )
        if [ ! -z "${disk_device_by_id}" ];then
            disk_device=${disk_device_by_id}
        fi
        list_items="${list_items} ${disk_device} ${disk_size} ${item_status}"
        item_status=off
    done
    echo "${list_items}"
}

function get_selected_disk {
    local disk_list
    disk_list=$(get_disk_list)
    if [ ! -z "${disk_list}" ];then
        run_dialog \
            --radiolist "\"Select Installation Disk\"" 20 75 15 \
            "$(get_disk_list)"
        get_dialog_result
    fi
}

#======================================
# Perform image dump/install operations
#--------------------------------------
# TODO

setup_debug

udev_pending

stop_plymouth

get_selected_disk

emergency_shell

exit 0
