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

color_output = new LuiImage({ value: sHSV_0, color: c_red });

color_picker = new LuiPanel();

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
color_picker.alp = 0;

color_picker.hue_string = "255";
color_picker.sat_string = "255";
color_picker.val_string = "255";
color_picker.alp_string = "255";

color_picker
	.setWidth(500)
	.addContent([
		new LuiPanel()
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
		new LuiPanel()
			.setFlexDirection(flexpanel_flex_direction.row)
			.addContent([
				new LuiInput({ value: 255, prefix: "H: ", placeholder: "0", input_mode: LUI_INPUT_MODE.numbers }).bindVariable(color_picker, "hue_string"),
				new LuiInput({ value: 255, prefix: "S: ", placeholder: "0", input_mode: LUI_INPUT_MODE.numbers }).bindVariable(color_picker, "sat_string"),
				new LuiInput({ value: 255, prefix: "V: ", placeholder: "0", input_mode: LUI_INPUT_MODE.numbers }).bindVariable(color_picker, "val_string"),
				new LuiInput({ value: 255, prefix: "A: ", placeholder: "0", input_mode: LUI_INPUT_MODE.numbers }).bindVariable(color_picker, "alp_string").addEvent(LUI_EV_VALUE_UPDATE, function(_e) { color_picker.alp = 1 - (_e.getReal() / 255); color_output.alpha = 1 - color_picker.alp; color_picker.updateMainUiSurface(); }),
				color_output
			])
		]
);

panel = new LuiPanel().setFlexDirection(flexpanel_flex_direction.row).addContent(color_picker);

my_ui.addContent(panel);