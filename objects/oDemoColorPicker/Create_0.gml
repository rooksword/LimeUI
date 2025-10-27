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

color_picker_a = new LuiColorPicker();
with color_picker_a
{
	self.satval_width = 400;
	self.satval_height = 200;
	self.width = self.satval_width;
	self.height = self.satval_height + self.hue_bar_height + self.result_size + (16 * 2) + 1;	
}

color_picker_b = new LuiColorPicker();
with color_picker_b
{
	self.satval_width = 200;
	self.satval_height = 400;
	self.width = self.satval_width;
	self.height = self.satval_height + self.hue_bar_height + self.result_size + (16 * 2) + 1;	
}

panel = new LuiPanel().setFlexDirection(flexpanel_flex_direction.row).addContent([color_picker_a, color_picker_b]);

my_ui.addContent(panel);