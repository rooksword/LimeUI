///@desc This element displays a color picker.
/// Available parameters:
/// width
/// height
///@arg {Struct} [_params] Struct with parameters
function LuiColorPicker(_params = {}) : LuiBase(_params) constructor {
	self.satval_width = 255;
	self.satval_height = 255;
	
	self.hue_bar_height = 16;
	self.result_size = 32;
	
	self.width = self.satval_width;
	self.height = self.satval_height      // Height of satval palette
					+ self.hue_bar_height // Height of hue palette
					+ self.result_size    // Height of result colour output
					+ (16 * 2)            // x2 of padding height
					+ 1;                  // +1 for error
	
	self.sat = 255;
	self.hue = 0;
	self.val = 255;
	
	self.selected = SELECTED.NOTHING;
	
	self.update = function()
	{
		var _mouse_x = display_mouse_get_x();
		var _mouse_y = display_mouse_get_y();
		
		if mouse_check_button_pressed(mb_left)
		{
			if point_in_rectangle(_mouse_x, _mouse_y, self.x, self.y, self.x + self.satval_width, self.y + self.satval_height)
			{
				selected = SELECTED.SATVAL;	
			}
			else if point_in_rectangle(_mouse_x, _mouse_y, self.x, self.y + self.satval_height + self.style.padding, self.x + self.satval_width, self.y + self.satval_height + self.style.padding + self.hue_bar_height)
			{
				selected = SELECTED.HUE;
			}
		}
		
		if selected != SELECTED.NOTHING
		{
			if selected == SELECTED.SATVAL // Sat / val bar
			{
				self.sat = clamp(255 * ((_mouse_x - self.x) / self.satval_width)         , 0, 255);
				self.val = clamp(255 - (255 * ((_mouse_y - self.y) / self.satval_height)), 0, 255);
			}
			else if selected == SELECTED.HUE // Hue bar
			{
				self.hue = clamp(255 * ((_mouse_x - self.x) / self.satval_width), 0, 255);
			}
			
			self.updateMainUiSurface();
			
			if mouse_check_button_released(mb_left)
			{
				selected = SELECTED.NOTHING;
			}
		}
	}
	
	self.draw = function()
	{
		// Draw satval palette
		
		var _w = self.satval_width / sprite_get_width(sHSV_0);
		var _h = self.satval_height / sprite_get_height(sHSV_0);
		
		draw_sprite_ext(sHSV_0, 0, self.x, self.y, _w,  _h, 0, make_colour_hsv(self.hue, 255, 255), 1);
		draw_sprite_ext(sHSV_1, 0, self.x, self.y, _w, _h, 0, c_white, 1);
		draw_sprite_ext(sHSV_2, 0, self.x, self.y, _w, _h, 0, c_white, 1);
		
		// Draw hue palette
		
		var _y = self.y + self.satval_height + self.style.padding;
		
		draw_sprite_ext(sHSV_3, 0, self.x, _y, _w, self.hue_bar_height, 0, c_white, 1);
		
		// Draw satval picker
		
		draw_set_colour(c_white);
		draw_circle(self.x + (self.sat * (self.satval_width / 255)), self.y + self.satval_height - (self.val * (self.satval_height / 255)), 4, true);
		
		// Draw hue picker
		
		var _x = self.x + self.satval_width * (self.hue / 255);
		draw_line(_x, _y, _x, _y + self.hue_bar_height);
		
		// Draw colour output
		
		_y += self.hue_bar_height + self.style.padding;
		
		var _col = make_colour_hsv(self.hue, self.sat, self.val);
		
		draw_set_colour(_col);
		draw_rectangle(self.x, _y, self.x + self.result_size, _y + self.result_size, false);
	}
}