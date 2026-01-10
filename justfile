set shell := ["powershell", "-c"]
set working-directory := '../zmk/app'
alias b := build
alias bl := build_left
alias br := build_right
alias bd := build_dongle
alias fd := flash_dongle
alias fl := flash_left
alias fr := flash_right
alias r := reset

pristine := 'n'
studio := 'n'
p_opt := if pristine == 'y' { "-p" } else { "" }
p_snippet := if studio == 'y' { " -S studio-rpc-usb-uart " } else { " -S zmk-usb-logging" }
build_dongle:
    pwd
    ../.venv\Scripts\Activate.ps1; \
    # west
    west build {{p_opt}} -d  build/donglenn -b seeeduino_xiao_ble {{p_snippet}} -- -DSHIELD="lily58_dongle dongle_display" -DZMK_CONFIG="C:/Users/theor/zmk-config/config" -DZMK_EXTRA_MODULES="C:/Users/theor/zmk-config;C:/Users/theor/zmk-config/zmk-tri-state;C:/Users/theor/zmk-config/zmk-dongle-display;C:/Users/theor/zmk-config/zmk-helpers"  -DCONFIG_ZMK_STUDIO={{studio}}    
    cp build/donglenn/zephyr/zmk.uf2 build/lily58_dongle.uf2

build_half side:
    pwd
    ../.venv\Scripts\Activate.ps1; \
    # west
    west build {{p_opt}} -d  build/lily{{side}} -b nice_nano_v2  {{p_snippet}} -- -DSHIELD="lily58_{{side}}" -DZMK_CONFIG="C:/Users/theor/zmk-config/config" -DZMK_EXTRA_MODULES="C:/Users/theor/zmk-config/zmk-tri-state;C:/Users/theor/zmk-config/zmk-helpers"  -DCONFIG_ZMK_STUDIO={{studio}} -DCONFIG_ZMK_SPLIT_ROLE_CENTRAL=n
    cp build/lily{{side}}/zephyr/zmk.uf2 build/lily58_{{side}}.uf2

build_left: (build_half "left")
build_right: (build_half "right")

build: build_left build_right (build_dongle)

flash side:
    cp build/lily58_{{side}}.uf2 F:\
flash_dongle: (flash "dongle")
flash_left: (flash "left")
flash_right: (flash "right")

reset:
    cp build/reset.uf2 F:\
