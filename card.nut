
class GameCard extends ConveyorSlot
{
	static y_pos = 690;
	static x_offset = -250;
	static MWIDTH = 320;
	static MHEIGHT = 395;
	static x_lookup = [ 0, 155, 310, 465, 620, 775, 953, 1131, 1286, 1441, 1596, 1751, 1906 ];
	static s_lookup = [ 0.85, 0.85, 0.85, 0.85, 0.85, 0.85, 1, 0.85, 0.85, 0.85, 0.85, 0.85, 0.85 ];
    static progress_correction = 0.07;

	constructor(card_art)
	{
		local card_image = fe.add_artwork( card_art );

		card_image.preserve_aspect_ratio=true;
		card_image.video_flags = Vid.ImagesOnly;

		base.constructor( card_image );

	}

	//
	// Place, scale and set the colour of the artwork based
	// on the value of "progress" which ranges from 0.0-1.0
	//
	function on_progress( progress, var )
	{
		local scale;
		local new_x;
		progress += progress_correction;

		if ( progress >= 1.0 )
		{
			scale = s_lookup[ 12 ];
			new_x = x_lookup[ 12 ];
		}
		else if ( progress < 0 )
		{
			scale = 1;
			new_x = 0;
		}
		else
		{
			local slice = ( progress * 12.0 ).tointeger();
			local factor = ( progress - ( slice / 12.0 ) ) * 12.0;

			scale = s_lookup[ slice ]
				+ (s_lookup[slice+1] - s_lookup[slice]) * factor;

			new_x = x_lookup[ slice ]
				+ (x_lookup[slice+1] - x_lookup[slice]) * factor;
		}

		m_obj.width = MWIDTH * scale;
		m_obj.height = MHEIGHT * scale;
		m_obj.x = x_offset + new_x - m_obj.width / 2;
		m_obj.y = y_pos - m_obj.height / 2;

		set_bright( ( scale > 0.9 ) ? 255 : 140, m_obj );
	}
}
