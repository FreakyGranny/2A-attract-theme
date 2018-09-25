
class FadeInObject
{
    fade_time=500;
    fade_trigger=null;

    _object=null;
    _last_switch=0;
    _in_fade=false;
    _trigger_load=false;

    constructor(object) {
        _object = object;
        _object.alpha=0;
        fe.add_transition_callback(this, "on_transition");
        fe.add_ticks_callback(this, "on_tick");
    }

    function on_transition(ttype, var, ttime)
    {
        if (ttype == fade_trigger)
        {
            if (_in_fade) {
                _in_fade=false;
            }
            _trigger_load=true;
        }
        return false;
    }

    function on_tick(ttime) {
        if (_trigger_load) {
            _in_fade=true;

            _last_switch=ttime;
            _object.alpha=0;
            _trigger_load=false;
        }

        if (_in_fade) {
            local new_alpha = 255 * (ttime-_last_switch) / fade_time;

            if (new_alpha > 255) {
                _in_fade=false;
            } else {
                _object.alpha = new_alpha;
            }
        }
    }
}


class FadeOutObject {
    fade_time = 500;
    fade_trigger = null;

    _object = null;
    _last_switch = 0;
    _do_fade = false;
    _trigger_load = false;

    constructor(object) {
        _object = object;
        _object.alpha = 0;
        fe.add_transition_callback(this, "on_transition");
        fe.add_ticks_callback(this, "on_tick");
    }

    function on_transition(ttype, var, ttime) {
        if (ttype == fade_trigger)
        {
            if (_do_fade) {
                _do_fade = false;
            }
            _trigger_load = true;
        }

        return false;
    }

    function on_tick(ttime) {
        if (_trigger_load) {
            _do_fade = true;
            _last_switch = ttime;
            _object.alpha = 255;
            _trigger_load = false;
        }

        if (_do_fade) {
            local new_alpha = 255 * (ttime - _last_switch) / fade_time;
            if (new_alpha > 255) {
                _do_fade = false;
                new_alpha = 255;
            }

            _object.alpha = 255 - new_alpha;
        }
    }
}


class FadeDelayedVideo extends FadeArt {
    start_delay = 1000;

    function on_tick(ttime) {
        base.on_tick(ttime);
        if ((ttime - _last_switch) > start_delay) {
            _back.video_playing = true;
            _front.video_playing = false;
        }
    }
}
