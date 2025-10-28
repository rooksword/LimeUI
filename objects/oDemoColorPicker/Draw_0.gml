/// @desc Draw to surface

var _mx = display_mouse_get_x();
var _my = display_mouse_get_y();

var _surface_element = my_ui.getElement("LuiSurface");
var _hue_element = my_ui.getElement("HueSurface");
var _alp_element = my_ui.getElement("AlpSurface");

if mouse_check_button_pressed(mb_left)
{
	if point_in_rectangle(_mx, _my, _surface_element.x, _surface_element.y, _surface_element.x + _surface_element.width, _surface_element.y + _surface_element.height)
	{
		color_picker.selected = SELECTED.SATVAL;
	}
	else if point_in_rectangle(_mx, _my, _hue_element.x, _hue_element.y, _hue_element.x + _hue_element.width, _hue_element.y + _hue_element.height)
	{
		color_picker.selected = SELECTED.HUE;	
	}
	else if point_in_rectangle(_mx, _my, _alp_element.x, _alp_element.y, _alp_element.x + _alp_element.width, _alp_element.y + _alp_element.height)
	{
		color_picker.selected = SELECTED.ALP;
	}
}

if mouse_check_button(mb_left)
{
	if color_picker.selected == SELECTED.SATVAL
	{
		color_picker.sat = clamp((_mx - _surface_element.x) / _surface_element.width, 0, 1);
		color_picker.val = clamp(1 - ((_my - _surface_element.y) / _surface_element.height), 0, 1);
			
		color_picker.sat_string = string(round(color_picker.sat * 255));
		color_picker.val_string = string(round(color_picker.val * 255));
		
		var _c = make_color_hsv(color_picker.hue * 255, color_picker.sat * 255, color_picker.val * 255);
		
		color_output.color_blend = _c;
		
		color_picker.r_string = string(colour_get_red(_c));
		color_picker.g_string = string(colour_get_green(_c));
		color_picker.b_string = string(colour_get_blue(_c));
	}
	else if color_picker.selected == SELECTED.HUE
	{
		color_picker.hue = clamp((_my - _hue_element.y) / _hue_element.height, 0, 1);
		color_picker.hue_string = string(round(color_picker.hue * 255));
		
		var _c = make_color_hsv(color_picker.hue * 255, color_picker.sat * 255, color_picker.val * 255);
		
		color_output.color_blend = _c;
		
		color_picker.r_string = string(colour_get_red(_c));
		color_picker.g_string = string(colour_get_green(_c));
		color_picker.b_string = string(colour_get_blue(_c));
	}
	else if color_picker.selected == SELECTED.ALP
	{
		color_picker.alp = clamp((_my - _alp_element.y) / _alp_element.height, 0, 1);
		color_picker.alp_string = string(255 - round(color_picker.alp * 255));
		
		color_output.alpha = 1 - color_picker.alp;
	}
		
	color_picker.updateMainUiSurface();
}

if mouse_check_button_released(mb_left)
{
	color_picker.selected = SELECTED.NOTHING;	
}

// Surfaces

if !surface_exists(surf_satval)
{
	surf_satval = surface_create(255, 255);
	_surface_element.set(surf_satval);
}
else
{	
	surface_set_target(surf_satval);

	draw_sprite_ext(sHSV_0, -1, 0, 0, 1, 1, 0, make_color_hsv(color_picker.hue * 255, 255, 255), 1);
	draw_sprite(sHSV_1, -1, 0, 0);
	draw_sprite(sHSV_2, -1, 0, 0);

	draw_set_colour(c_white);

	draw_circle(color_picker.sat * _surface_element.width, _surface_element.height - (color_picker.val * _surface_element.height), 4, true);

	surface_reset_target();

	_surface_element.updateSurface();
}

if !surface_exists(surf_hue)
{
	surf_hue = surface_create(32, 255);
	_hue_element.set(surf_hue);
}
else
{
	surface_set_target(surf_hue);

	draw_sprite_ext(sHSV_3, -1, 0, 0, _hue_element.width / sprite_get_width(sHSV_3), 1, 0, c_white, 1);

	draw_set_colour(c_white);

	var _y = ((_hue_element.height) * color_picker.hue);

	draw_line(0, _y, _hue_element.width, _y);
	
	surface_reset_target();

	_hue_element.updateSurface();
}

if !surface_exists(surf_alp)
{
	surf_alp = surface_create(32, 255);
	_alp_element.set(surf_alp);
}
else
{
	surface_set_target(surf_alp);

	draw_sprite_ext(sHSV_4, -1, 0, 0, _alp_element.width / sprite_get_width(sHSV_4), 1, 0, c_white, 1);

	draw_set_colour(c_white);

	var _y = ((_alp_element.height) * color_picker.alp);

	draw_line(0, _y, _alp_element.width, _y);
	
	surface_reset_target();

	_alp_element.updateSurface();
}