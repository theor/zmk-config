
#include <zephyr/logging/log.h>
#include <zmk/behavior.h>
#include <zmk/keys.h>
#include <zmk/event_manager.h>
#include <zmk/events/keycode_state_changed.h>
#include <zmk/events/layer_state_changed.h>

LOG_MODULE_DECLARE(zmk, CONFIG_ZMK_LOG_LEVEL);

static int layer_listener(const zmk_event_t *eh);

ZMK_LISTENER(layercb, layer_listener);
ZMK_SUBSCRIPTION(layercb, zmk_layer_state_changed);


#define L_DEF 0
#define L_LOW 1
#define L_RAISE 2
#define L_NAV 3
#define L_MOUSE 4

static int layer_listener(const zmk_event_t *eh)
{
    const struct zmk_layer_state_changed *ev = as_zmk_layer_state_changed(eh);
    if (ev && (ev->layer > L_DEF) && ev->state == 0)
    {
        // LOG_DBG("!!!!!!!!!!!!!!!!!! Layer state changed: layer_state=0x%08x %08x", ev->layer, ev->state);
        raise_zmk_keycode_state_changed_from_encoded(LEFT_CONTROL, false, ev->timestamp);
        raise_zmk_keycode_state_changed_from_encoded(LEFT_SHIFT, false, ev->timestamp);
        raise_zmk_keycode_state_changed_from_encoded(LEFT_ALT, false, ev->timestamp);
        raise_zmk_keycode_state_changed_from_encoded(LEFT_GUI, false, ev->timestamp);
    }
    return 0;
}
