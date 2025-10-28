///@desc CREATE STYLES AND UI

LIME_RESOLUTION.init();

// Create style theme
demo_style = new LuiStyle()
	.setMinSize(32, 32)
	.setPadding(16)
	.setGap(16)
	.setRenderRegionOffset([0,0,1,3])
	.setFonts(fDemo, fDemo, fDebug)
	.setSprites(sUI_panel, sUI_button, sUI_panel_border, sUI_button_border)
	.setSpriteCheckbox(sUI_button, sUI_checkbox_pin, sUI_button_border)
	.setSpriteToggleSwitch(sToggleSwitch, sToggleSwitchSlider, sToggleSwitchBorder, sToggleSwitchSliderBorder)
	.setSpriteComboBoxArrow(sUI_ComboBoxArrow)
	.setSpriteRing(sRing, sRing)
	.setSpriteTabs(sUI_tabs, sUI_tab, sUI_tabs_border, sUI_tab_border)
	.setColors(#393c4f, #393c4f, merge_color(#393c4f, c_black, 0.1), #3a7d44, merge_color(#393c4f, c_black, 0.5)) //_primary, _secondary, _back, _accent, _border
	.setColorAccent(#3a7d44)
	.setColorHover(c_gray)
	.setColorText(merge_color(c_white, #393c4f, 0.2), #77726e)
	.setSounds(sndBasicClick);

// Create the main ui container
my_ui = new LuiMain().setStyle(demo_style);

surf_satval = -1;
surf_hue = -1;
surf_alp = -1;

color_output = new LuiImageButton({ value: sHSV_0, color: c_red, maintain_aspect: false }).addEvent(LUI_EV_MOUSE_LEFT_PRESSED, function()
{
	if hue_input.prefix == "H: "
	{
		hue_input.prefix = "R: ";
		hue_input.bindVariable(color_picker, "r_string");
		sat_input.prefix = "G: ";
		sat_input.bindVariable(color_picker, "g_string");
		val_input.prefix = "B: ";
		val_input.bindVariable(color_picker, "b_string");
	}
	else
	{
		hue_input.prefix = "H: ";
		hue_input.bindVariable(color_picker, "hue_string");
		sat_input.prefix = "S: ";
		sat_input.bindVariable(color_picker, "sat_string");
		val_input.prefix = "V: ";
		val_input.bindVariable(color_picker, "val_string");
	}
});

color_picker = new LuiContainer();

enum SELECTED
{
	NOTHING,
	SATVAL,
	HUE,
	ALP
}

color_picker.selected = SELECTED.NOTHING;

color_picker.hue = 255;
color_picker.sat = 255;
color_picker.val = 255;

color_picker.red = 255;
color_picker.green = 0;
color_picker.blue = 0;

color_picker.r_string = "255";
color_picker.g_string = "0";
color_picker.b_string = "0";

color_picker.alp = 0;

color_picker.hue_string = "255";
color_picker.sat_string = "255";
color_picker.val_string = "255";
color_picker.alp_string = "255";

var _new_input = function(_value, _prefix, _placeholder, _var)
{
	return 	new LuiInput({
			value: _value,
			prefix: _prefix,
			placeholder: _placeholder,
			input_mode: LUI_INPUT_MODE.numbers
		})
		.bindVariable(color_picker, _var)
		.addEvent(LUI_EV_VALUE_UPDATE, function(_e) {			
			switch _e.binded_variable.variable
			{
				case "hue_string":
					color_picker.hue = _e.getReal() / 255;
					break;
				case "sat_string":
					color_picker.sat = _e.getReal() / 255;
					break;
				case "val_string":
					color_picker.val = _e.getReal() / 255;
					break;
				case "alp_string":
					color_picker.alp = 1 - (_e.getReal() / 255);
					break;
				case "r_string":
				case "g_string":
				case "b_string":
					var _c = make_colour_rgb(hue_input.getReal(), sat_input.getReal(), val_input.getReal());
					
					color_picker.hue = colour_get_hue(_c) / 255;
					color_picker.sat = colour_get_saturation(_c) / 255;
					color_picker.val = colour_get_value(_c) / 255;
					break;
			}
			
			color_output.color_blend = make_color_hsv(color_picker.hue * 255, color_picker.sat * 255, color_picker.val * 255);
			color_output.alpha = 1 - color_picker.alp;
			
			color_picker.updateMainUiSurface();
		});
}

hue_input = _new_input(255, "H: ", "0", "hue_string");
sat_input = _new_input(255, "S: ", "0", "sat_string");
val_input = _new_input(255, "V: ", "0", "val_string");
alp_input = _new_input(255, "A: ", "0", "alp_string");

color_picker
	.setWidth(500)
	.addContent([
		new LuiContainer()
			.setFlexJustifyContent(flexpanel_justify.space_between)
			.setFlexDirection(flexpanel_flex_direction.row)
			.addContent(
			[
				new LuiSurface({ name: "LuiSurface", width: 255 }),
				new LuiSurface({
					name: "HueSurface",
					width: 32,
					height: 255,
					maintain_aspect: false
				}),
				new LuiSurface({
					name: "AlpSurface",
					width: 32,
					height: 255,
					maintain_aspect: false
				})
			]),
		new LuiContainer()
			.setFlexJustifyContent(flexpanel_justify.space_between)
			.setFlexDirection(flexpanel_flex_direction.row)
			.addContent([
				hue_input,
				sat_input,
				val_input,
				alp_input,
				color_output
			])
		]
);

panel = new LuiPanel().setFlexDirection(flexpanel_flex_direction.row).addContent(color_picker);

my_ui.addContent(panel);