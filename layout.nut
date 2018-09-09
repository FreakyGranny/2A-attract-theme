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
	//
	</ label="Card Artwork", help="The artwork to spin", options="flyer,wheel,card", order=1, per_display="true" />
	card_art="card";

	</ label="System ID", help="System ID for display", order=2, per_display="true" />
	system_id="1";

	</ label="Spin Time", help="The amount of time it takes to spin to the next selection (in milliseconds)", order=3 />
	spin_ms="120";
}

fe.load_module( "conveyor" );
fe.load_module( "fade" );
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
} catch ( e ) {}

// set system id
local system_id = 1;
try {
	system_id = my_config["system_id"].tointeger();
} catch ( e ) {}


function set_bright( bright_val, object )
{
	object.set_rgb( bright_val, bright_val, bright_val );
}

// bottom background
fe.add_image( "images/bg.png", 0, 0, fe.layout.width, fe.layout.height );

//
// Initialize the video frame
//

local snap = FadeDelayedVideo("snap", 480, -125, 800, 600);
snap.video_playing = false;
snap.video_flags = Vid.NoAutoStart;
snap.trigger = Transition.EndNavigation;
snap.start_delay = 2000;

// mask for snap
fe.add_image( "images/mask.png",	430, 0, 850, 500 );

//
// Initialize misc text
//
local l = fe.add_text( "[ListEntry]/[ListSize]", 1075, 870, 200, 20 );
l.set_rgb( 105, 105, 105 );
l.align = Align.Right;

//
// Initialize the card artworks with selection at the top
// of the draw order
//
local cards = [];
for ( local i=0; i < cards_count  / 2; i++ )
	cards.append( GameCard(my_config["card_art"]) );

for ( local i=0; i < ( cards_count + 1 ) / 2; i++ )
	cards.insert( cards_count / 2, GameCard(my_config["card_art"]) );

//
// Initialize a conveyor to control the artworks
//
local spinner = Conveyor();
spinner.transition_ms = spin_ms;
spinner.transition_swap_point = 1.0;
spinner.set_slots( cards );

//
// Game logo
//
local game_logo = FadeArt("wheel", 185, 0, 350, 263);
game_logo.preserve_aspect_ratio=true;
game_logo.video_flags = Vid.ImagesOnly;
game_logo.trigger = Transition.EndNavigation;

//
// Played/ time spend info
//
l = fe.add_text( "PLAYED", 170, 270, 410, 35 );
l.set_rgb( 255, 111, 0 );
l.align = Align.Left;
l.font="Roboto-Regular";
l = fe.add_text( "[PlayedCount] times", 172, 305, 400, 30 );
l.set_rgb( 105, 105, 105 );
l.align = Align.Left;
l.font="Roboto-Light";

l = fe.add_text( "TIME SPEND", 170, 375, 400, 35 );
l.set_rgb( 255, 111, 0 );
l.align = Align.Left;
l.font="Roboto-Regular";
l = fe.add_text( "[PlayedTime]", 172, 410, 400, 30 );
l.set_rgb( 105, 105, 105 );
l.align = Align.Left;
l.font="Roboto-Light";

// system switch fading cover
local switch_cover = fe.add_image( "images/switch_cover.png", 0, 0, fe.layout.width, fe.layout.height );
local switch_cover_obj = FadeOutObject(switch_cover)
switch_cover_obj.fade_trigger = Transition.ToNewList;
switch_cover_obj.fade_time = 1500;

// side bar always must be on top
fe.add_image( "images/bar.png", 0, 0);
fe.add_image( "images/black.png", 0, 910, fe.layout.width, 50 );

// system icons
fe.add_image( "icons/a_logo.png", 23, 23, 84, 84 );


const SYSTEM_ICON_SIZE = 72;
const SYSTEM_START_Y = 80;
const SYSTEM_PAD_Y = 90;

local system_one = fe.add_image( "icons/arcade.png", 30, SYSTEM_START_Y + 1 * SYSTEM_PAD_Y, SYSTEM_ICON_SIZE, SYSTEM_ICON_SIZE );
set_bright(105, system_one)
local system_two = fe.add_image( "icons/nes.png", 30, SYSTEM_START_Y + 2 * SYSTEM_PAD_Y, SYSTEM_ICON_SIZE, SYSTEM_ICON_SIZE );
set_bright(105, system_two)
local system_three = fe.add_image( "icons/sega_md2.png", 30, SYSTEM_START_Y + 3 * SYSTEM_PAD_Y, SYSTEM_ICON_SIZE, SYSTEM_ICON_SIZE );
set_bright(105, system_three)
local system_four = fe.add_image( "icons/snes.png", 30, SYSTEM_START_Y + 4 * SYSTEM_PAD_Y, SYSTEM_ICON_SIZE, SYSTEM_ICON_SIZE );
set_bright(105, system_four)

local system_icon_path = "icons/default.png";

switch ( system_id )
	{
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
local selected_system = fe.add_image( system_icon_path, 30, SYSTEM_START_Y + system_id * SYSTEM_PAD_Y, SYSTEM_ICON_SIZE, SYSTEM_ICON_SIZE );
local selected_system_obj = FadeInObject(selected_system)
selected_system_obj.fade_trigger = Transition.ToNewList;
local selected_system_text = fe.add_text( "[DisplayName]", 0, 57 + SYSTEM_START_Y + system_id * SYSTEM_PAD_Y, 133, 20 );
selected_system_text.font="Roboto-Regular";

local selected_system_text_obj = FadeInObject(selected_system_text)
selected_system_text_obj.fade_trigger = Transition.ToNewList;

// help bar
l = fe.add_text( "F", 200, 912, 50, 40 );
l.set_rgb( 105, 105, 105 );
l.align = Align.Left;
l.font="Iconic PSx";
l = fe.add_text( "G", 395, 912, 50, 40 );
l.set_rgb( 105, 105, 105 );
l.align = Align.Left;
l.font="Iconic PSx";
l = fe.add_text( "E", 590, 912, 50, 40 );
l.set_rgb( 105, 105, 105 );
l.align = Align.Left;
l.font="Iconic PSx";
l = fe.add_text( "I", 590, 912, 50, 40 );
l.set_rgb( 105, 105, 105 );
l.align = Align.Left;
l.font="Iconic PSx";
l = fe.add_text( "c", 780, 912, 50, 40 );
l.set_rgb( 105, 105, 105 );
l.align = Align.Left;
l.font="Iconic PSx";
l = fe.add_text( "c", 950, 912, 50, 40 );
l.set_rgb( 105, 105, 105 );
l.align = Align.Left;
l.font="Iconic PSx";

l = fe.add_text("NEXT SYSTEM", 250,	925, 1200, 20);
l.set_rgb( 105, 105, 105 );
l.align = Align.Left;
l.font="Roboto-Condensed";
l = fe.add_text("PREV SYSTEM", 445,	925, 1200, 20);
l.set_rgb( 105, 105, 105 );
l.align = Align.Left;
l.font="Roboto-Condensed";
l = fe.add_text("SELECT GAME", 640,	925, 1200, 20);
l.set_rgb( 105, 105, 105 );
l.align = Align.Left;
l.font="Roboto-Condensed";
l = fe.add_text("EXIT GAME", 830, 925, 1200, 20);
l.set_rgb( 105, 105, 105 );
l.align = Align.Left;
l.font="Roboto-Condensed";
l = fe.add_text("PLAY GAME", 1000, 925, 1200, 20);
l.set_rgb( 105, 105, 105 );
l.align = Align.Left;
l.font="Roboto-Condensed";

l = fe.add_text("EXIT",	797, 929, 30, 14);
l.set_rgb( 0, 0, 0 );
l.align = Align.Left;
l.font="Roboto-Condensed";
l = fe.add_text("START", 965, 929, 500, 13);
l.set_rgb( 0, 0, 0 );
l.align = Align.Left;
l.font="Roboto-Condensed";

// clock
local dt = fe.add_text( "", 1065, 915, 200, 25 );
dt.set_rgb( 105, 105, 105 );
dt.align = Align.Right;
dt.font="digital-7.monoitalic";

fe.add_ticks_callback( this, "update_clock" );

function update_clock( ttime )
{
	local now = date();
	dt.msg = format("%02d", now.hour ) + ":" + format("%02d", now.min );
}

// top fading cover
local cover = fe.add_image( "images/black.png", 0, 0, fe.layout.width, fe.layout.height );
local cover_obj = FadeOutObject(cover)
cover_obj.fade_trigger = Transition.FromGame;
cover_obj.fade_time = 2000;
