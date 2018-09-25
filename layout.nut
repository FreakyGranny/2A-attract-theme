///////////////////////////////////////////////////
//
// Attract-Mode Frontend - 2A layout
//
///////////////////////////////////////////////////
//
// NOTES:
//
//
///////////////////////////////////////////////////

class UserConfig {
    // Note the per_display="true" below means that this parameter has to be configured by the user for each
    // display where this layout gets used.  If this isn't set then the layout parameter is the same across
    // all displays that use this layout

    </ label="Card Artwork", help="The artwork to spin", options="flyer,wheel,card", order=1, per_display="true" />
    card_art="card";

    </ label="System ID", help="System ID for display", order=2, per_display="true" />
    system_id="1";

    </ label="Spin Time", help="The amount of time it takes to spin to the next selection (in milliseconds)", order=3 />
    spin_ms="120";
}

function set_bright(bright_val, object) {
    object.set_rgb(bright_val, bright_val, bright_val);
}

// format functions

function set_accent_text_style(object) {
    object.set_rgb(255, 111, 0);
    object.align = Align.Left;
    object.font = "Roboto-Regular";
}

function set_normal_text_style(object) {
    object.set_rgb(105, 105, 105);
    object.align = Align.Left;
    object.font = "Roboto-Light";
}

function set_help_text_style(object) {
    object.set_rgb(105, 105, 105);
    object.align = Align.Left;
    object.font = "Roboto-Condensed";
}

function set_icon_style(object) {
    object.set_rgb(105, 105, 105);
    object.align = Align.Left;
    object.font = "Iconic PSx";
}

function set_icon_text_style(object) {
    object.set_rgb(0, 0, 0);
    object.align = Align.Left;
    object.font = "Roboto-Condensed";
}

function set_clock_style(object) {
    object.set_rgb(105, 105, 105);
    object.align = Align.Right;
    object.font = "digital-7.monoitalic";
}

function set_clock_style(object) {
    object.set_rgb(105, 105, 105);
    object.align = Align.Right;
    object.font = "digital-7.monoitalic";
}

function set_system_menu_style(object) {
    object.set_rgb(250, 250, 250);
    object.align = Align.Centre;
	object.font = "Roboto-Regular";
}

function set_counter_style(object) {
    object.set_rgb(31, 31, 31);
    object.align = Align.Right;
    object.font = "Roboto-Light";
}

function set_social_style(object) {
    object.set_rgb(105, 105, 105);
    object.align = Align.Left;
    object.font = "Social Circles v1.1";
}


fe.load_module("conveyor");
fe.load_module("fade");
fe.load_module("pan-and-scan");
fe.do_nut("fade.nut");
fe.do_nut("card.nut");

local my_config = fe.get_config();

fe.layout.width = 1280
fe.layout.height = 960

local cards_count = 7;

// set spin time
local spin_ms = 120;

try {
    spin_ms = my_config["spin_ms"].tointeger();
} catch (e) {}

// set system id
local system_id = 1;
try {
    system_id = my_config["system_id"].tointeger();
} catch ( e ) {}


// Initialize the video frame

local snap = FadeDelayedVideo("snap", 480, -85, 800, 600);
snap.video_playing = false;
snap.video_flags = Vid.NoAutoStart;
snap.trigger = Transition.EndNavigation;
snap.start_delay = 2000;

// bottom background

fe.add_image("images/bg.png", 0, 0, fe.layout.width, fe.layout.height);

// Initialize misc text

local l = fe.add_text("[ListEntry]/[ListSize]", 1075, 870, 200, 20);
set_counter_style(l);

//
// Initialize the card artworks with selection at the top
// of the draw order
//
local cards = [];
for (local i=0; i < cards_count  / 2; i++)
    cards.append(GameCard(my_config["card_art"]));

for (local i=0; i < (cards_count + 1) / 2; i++)
    cards.insert(cards_count / 2, GameCard(my_config["card_art"]));

// Initialize a conveyor to control the artworks

local spinner = Conveyor();
spinner.transition_ms = spin_ms;
spinner.transition_swap_point = 1.0;
spinner.set_slots(cards);

// Game logo

local game_logo = FadeArt("wheel", 185, 0, 350, 263);
game_logo.preserve_aspect_ratio = true;
game_logo.video_flags = Vid.ImagesOnly;
game_logo.trigger = Transition.EndNavigation;

// Played/ time spend info

l = fe.add_text("PLAYED", 170, 270, 410, 35);
set_accent_text_style(l);
l = fe.add_text("[PlayedCount] times", 172, 305, 400, 30);
set_normal_text_style(l);

l = fe.add_text("TIME SPEND", 170, 375, 400, 35);
set_accent_text_style(l);
l = fe.add_text("[PlayedTime]", 172, 410, 400, 30);
set_normal_text_style(l);

// system switch fading cover
l = fe.add_image("images/switch_cover.png", 0, 0, fe.layout.width, fe.layout.height);
local switch_cover_obj = FadeOutObject(l);
switch_cover_obj.fade_trigger = Transition.ToNewList;
switch_cover_obj.fade_time = 1500;

// side bar always must be on top
fe.add_image("images/bar.png", 0, 0);
fe.add_image("images/black.png", 0, 910, fe.layout.width, 50);

// system icons
fe.add_image("icons/a_logo.png", 23, 23, 84, 84);


const SYSTEM_ICON_SIZE = 72;
const SYSTEM_START_Y = 80;
const SYSTEM_PAD_Y = 90;

l = fe.add_image("icons/arcade.png", 30, SYSTEM_START_Y + 1 * SYSTEM_PAD_Y, SYSTEM_ICON_SIZE, SYSTEM_ICON_SIZE);
set_bright(105, l)
l = fe.add_image("icons/nes.png", 30, SYSTEM_START_Y + 2 * SYSTEM_PAD_Y, SYSTEM_ICON_SIZE, SYSTEM_ICON_SIZE);
set_bright(105, l)
l = fe.add_image("icons/sega_md2.png", 30, SYSTEM_START_Y + 3 * SYSTEM_PAD_Y, SYSTEM_ICON_SIZE, SYSTEM_ICON_SIZE);
set_bright(105, l)
l = fe.add_image("icons/snes.png", 30, SYSTEM_START_Y + 4 * SYSTEM_PAD_Y, SYSTEM_ICON_SIZE, SYSTEM_ICON_SIZE);
set_bright(105, l)

local system_icon_path = "icons/default.png";

switch (system_id) {
    case 1:
        system_icon_path = "icons/arcade.png";
        break;
    case 2:
        system_icon_path = "icons/nes.png";
        break;
    case 3:
        system_icon_path = "icons/sega_md2.png";
        break;
    case 4:
        system_icon_path = "icons/snes.png";
        break;
}

l = fe.add_image(system_icon_path, 30, SYSTEM_START_Y + system_id * SYSTEM_PAD_Y, SYSTEM_ICON_SIZE, SYSTEM_ICON_SIZE);
local selected_system = FadeInObject(l);
selected_system.fade_trigger = Transition.ToNewList;

l = fe.add_text("[DisplayName]", 0, 57 + SYSTEM_START_Y + system_id * SYSTEM_PAD_Y, 133, 20);
set_system_menu_style(l);
local selected_system_text = FadeInObject(l);
selected_system_text.fade_trigger = Transition.ToNewList;

// help bar
l = fe.add_text("F", 200, 912, 50, 40);
set_icon_style(l);
l = fe.add_text("G", 395, 912, 50, 40);
set_icon_style(l);
l = fe.add_text("E", 590, 912, 50, 40);
set_icon_style(l);
l = fe.add_text("I", 590, 912, 50, 40);
set_icon_style(l);
l = fe.add_text("c", 780, 912, 50, 40);
set_icon_style(l);
l = fe.add_text("c", 950, 912, 50, 40);
set_icon_style(l);

l = fe.add_text("NEXT SYSTEM", 250, 925, 1200, 20);
set_help_text_style(l);
l = fe.add_text("PREV SYSTEM", 445, 925, 1200, 20);
set_help_text_style(l);
l = fe.add_text("SELECT GAME", 640, 925, 1200, 20);
set_help_text_style(l);
l = fe.add_text("EXIT GAME", 830, 925, 1200, 20);
set_help_text_style(l);
l = fe.add_text("PLAY GAME", 1000, 925, 1200, 20);
set_help_text_style(l);

l = fe.add_text("EXIT",	797, 928, 50, 15);
set_icon_text_style(l);
l = fe.add_text("START", 966, 929, 50, 13);
set_icon_text_style(l);

// clock
local clock = fe.add_text("", 1065, 915, 200, 25);
set_clock_style(clock);
fe.add_ticks_callback(this, "update_clock");

function update_clock(ttime) {
    local now = date();
    clock.msg = format("%02d", now.hour ) + ":" + format("%02d", now.min);
}

// credits

local credits_bg = fe.add_image("images/black.png", 0, 910, fe.layout.width - 150, 50);
credits_bg.alpha = 0;

fe.add_signal_handler("on_signal")

function on_signal(signal) {
    if ( signal == "custom2" ) {
        credits_bg.alpha = 255;
        l = fe.add_text(".", 185, 904, 40, 55);
        set_social_style(l);
        l = fe.add_text("*", 340, 904, 40, 55);
        set_social_style(l);
//      l = fe.add_text(".", 765, 904, 40, 55);
//      set_social_style(l);
//      l = fe.add_text("*", 935, 904, 40, 55);
//      set_social_style(l);

        l = fe.add_text("p.fomin", 250, 925, 200, 20);
        set_help_text_style(l);
        l = fe.add_text("FreakyGranny", 405, 925, 200, 20);
        set_help_text_style(l);
//      l = fe.add_text("contributor #2", 830, 925, 200, 20);
//      set_help_text_style(l);
//      l = fe.add_text("contributor #2", 1000, 925, 200, 20);
//      set_help_text_style(l);

        return true;
    }
    return false;
}

// top fading cover
l = fe.add_image("images/black.png", 0, 0, fe.layout.width, fe.layout.height);
local cover_obj = FadeOutObject(l)
cover_obj.fade_trigger = Transition.FromGame;
cover_obj.fade_time = 2000;
