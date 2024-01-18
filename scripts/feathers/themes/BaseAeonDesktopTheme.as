package feathers.themes
{
   import feathers.controls.Alert;
   import feathers.controls.AutoComplete;
   import feathers.controls.Button;
   import feathers.controls.ButtonGroup;
   import feathers.controls.Callout;
   import feathers.controls.Check;
   import feathers.controls.Drawers;
   import feathers.controls.GroupedList;
   import feathers.controls.Header;
   import feathers.controls.IScrollBar;
   import feathers.controls.ImageLoader;
   import feathers.controls.Label;
   import feathers.controls.LayoutGroup;
   import feathers.controls.List;
   import feathers.controls.NumericStepper;
   import feathers.controls.PageIndicator;
   import feathers.controls.Panel;
   import feathers.controls.PanelScreen;
   import feathers.controls.PickerList;
   import feathers.controls.ProgressBar;
   import feathers.controls.Radio;
   import feathers.controls.ScrollBar;
   import feathers.controls.ScrollContainer;
   import feathers.controls.ScrollScreen;
   import feathers.controls.ScrollText;
   import feathers.controls.Scroller;
   import feathers.controls.SimpleScrollBar;
   import feathers.controls.Slider;
   import feathers.controls.SpinnerList;
   import feathers.controls.TabBar;
   import feathers.controls.TextArea;
   import feathers.controls.TextCallout;
   import feathers.controls.TextInput;
   import feathers.controls.ToggleButton;
   import feathers.controls.ToggleSwitch;
   import feathers.controls.popups.DropDownPopUpContentManager;
   import feathers.controls.renderers.BaseDefaultItemRenderer;
   import feathers.controls.renderers.DefaultGroupedListHeaderOrFooterRenderer;
   import feathers.controls.renderers.DefaultGroupedListItemRenderer;
   import feathers.controls.renderers.DefaultListItemRenderer;
   import feathers.controls.text.TextFieldTextEditor;
   import feathers.controls.text.TextFieldTextEditorViewPort;
   import feathers.controls.text.TextFieldTextRenderer;
   import feathers.core.FeathersControl;
   import feathers.core.FocusManager;
   import feathers.core.ITextEditor;
   import feathers.core.ITextRenderer;
   import feathers.core.PopUpManager;
   import feathers.core.ToolTipManager;
   import feathers.layout.HorizontalLayout;
   import feathers.layout.VerticalLayout;
   import feathers.media.FullScreenToggleButton;
   import feathers.media.MuteToggleButton;
   import feathers.media.PlayPauseToggleButton;
   import feathers.media.SeekSlider;
   import feathers.media.VolumeSlider;
   import feathers.skins.ImageSkin;
   import flash.geom.Rectangle;
   import flash.text.TextFormat;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.display.Quad;
   import starling.display.Stage;
   import starling.textures.Texture;
   import starling.textures.TextureAtlas;
   
   public class BaseAeonDesktopTheme extends StyleNameFunctionTheme
   {
      
      protected static const THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_INCREMENT_BUTTON:String = "aeon-horizontal-scroll-bar-increment-button";
      
      protected static const THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_DECREMENT_BUTTON:String = "aeon-horizontal-scroll-bar-decrement-button";
      
      protected static const THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_THUMB:String = "aeon-horizontal-scroll-bar-thumb";
      
      protected static const THEME_STYLE_NAME_HORIZONTAL_SCROLL_BAR_MINIMUM_TRACK:String = "aeon-horizontal-scroll-bar-minimum-track";
      
      protected static const THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_INCREMENT_BUTTON:String = "aeon-vertical-scroll-bar-increment-button";
      
      protected static const THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_DECREMENT_BUTTON:String = "aeon-vertical-scroll-bar-decrement-button";
      
      protected static const THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_THUMB:String = "aeon-vertical-scroll-bar-thumb";
      
      protected static const THEME_STYLE_NAME_VERTICAL_SCROLL_BAR_MINIMUM_TRACK:String = "aeon-vertical-scroll-bar-minimum-track";
      
      protected static const THEME_STYLE_NAME_HORIZONTAL_SIMPLE_SCROLL_BAR_THUMB:String = "aeon-horizontal-simple-scroll-bar-thumb";
      
      protected static const THEME_STYLE_NAME_VERTICAL_SIMPLE_SCROLL_BAR_THUMB:String = "aeon-vertical-simple-scroll-bar-thumb";
      
      protected static const THEME_STYLE_NAME_HORIZONTAL_SLIDER_THUMB:String = "aeon-horizontal-slider-thumb";
      
      protected static const THEME_STYLE_NAME_HORIZONTAL_SLIDER_MINIMUM_TRACK:String = "aeon-horizontal-slider-minimum-track";
      
      protected static const THEME_STYLE_NAME_VERTICAL_SLIDER_THUMB:String = "aeon-vertical-slider-thumb";
      
      protected static const THEME_STYLE_NAME_VERTICAL_SLIDER_MINIMUM_TRACK:String = "aeon-vertical-slider-minimum-track";
      
      protected static const THEME_STYLE_NAME_VERTICAL_VOLUME_SLIDER_MINIMUM_TRACK:String = "aeon-vertical-volume-slider-minimum-track";
      
      protected static const THEME_STYLE_NAME_VERTICAL_VOLUME_SLIDER_MAXIMUM_TRACK:String = "aeon-vertical-volume-slider-maximum-track";
      
      protected static const THEME_STYLE_NAME_HORIZONTAL_VOLUME_SLIDER_MINIMUM_TRACK:String = "aeon-horizontal-volume-slider-minimum-track";
      
      protected static const THEME_STYLE_NAME_HORIZONTAL_VOLUME_SLIDER_MAXIMUM_TRACK:String = "aeon-horizontal-volume-slider-maximum-track";
      
      protected static const THEME_STYLE_NAME_POP_UP_VOLUME_SLIDER_MINIMUM_TRACK:String = "aeon-pop-up-volume-slider-minimum-track";
      
      protected static const THEME_STYLE_NAME_POP_UP_VOLUME_SLIDER_MAXIMUM_TRACK:String = "aeon-pop-up-volume-slider-maximum-track";
      
      protected static const THEME_STYLE_NAME_DATE_TIME_SPINNER_LIST_ITEM_RENDERER:String = "aeon-date-time-spinner-list-item-renderer";
      
      protected static const THEME_STYLE_NAME_DANGER_TEXT_CALLOUT_TEXT_RENDERER:String = "aeon-danger-text-callout-text-renderer";
      
      protected static const THEME_STYLE_NAME_HEADING_LABEL_TEXT_RENDERER:String = "aeon-heading-label-text-renderer";
      
      protected static const THEME_STYLE_NAME_DETAIL_LABEL_TEXT_RENDERER:String = "aeon-detail-label-text-renderer";
      
      protected static const THEME_STYLE_NAME_TOOL_TIP_LABEL_TEXT_RENDERER:String = "aeon-tool-tip-label-text-renderer";
      
      public static const FONT_NAME:String = "_sans";
      
      protected static const FOCUS_INDICATOR_SCALE_9_GRID:Rectangle = new Rectangle(5,5,2,2);
      
      protected static const TOOL_TIP_SCALE_9_GRID:Rectangle = new Rectangle(5,5,1,1);
      
      protected static const CALLOUT_SCALE_9_GRID:Rectangle = new Rectangle(5,5,1,1);
      
      protected static const BUTTON_SCALE_9_GRID:Rectangle = new Rectangle(5,5,1,12);
      
      protected static const TAB_SCALE_9_GRID:Rectangle = new Rectangle(5,5,1,15);
      
      protected static const STEPPER_INCREMENT_BUTTON_SCALE_9_GRID:Rectangle = new Rectangle(1,9,15,1);
      
      protected static const STEPPER_DECREMENT_BUTTON_SCALE_9_GRID:Rectangle = new Rectangle(1,1,15,1);
      
      protected static const HORIZONTAL_SLIDER_TRACK_SCALE_9_GRID:Rectangle = new Rectangle(3,0,1,4);
      
      protected static const VERTICAL_SLIDER_TRACK_SCALE_9_GRID:Rectangle = new Rectangle(0,3,4,1);
      
      protected static const TEXT_INPUT_SCALE_9_GRID:Rectangle = new Rectangle(2,2,1,1);
      
      protected static const VERTICAL_SCROLL_BAR_THUMB_SCALE_9_GRID:Rectangle = new Rectangle(2,5,6,42);
      
      protected static const VERTICAL_SCROLL_BAR_TRACK_SCALE_9_GRID:Rectangle = new Rectangle(2,1,11,2);
      
      protected static const VERTICAL_SCROLL_BAR_STEP_BUTTON_SCALE_9_GRID:Rectangle = new Rectangle(2,2,11,10);
      
      protected static const HORIZONTAL_SCROLL_BAR_THUMB_SCALE_9_GRID:Rectangle = new Rectangle(5,2,42,6);
      
      protected static const HORIZONTAL_SCROLL_BAR_TRACK_SCALE_9_GRID:Rectangle = new Rectangle(1,2,2,11);
      
      protected static const HORIZONTAL_SCROLL_BAR_STEP_BUTTON_SCALE_9_GRID:Rectangle = new Rectangle(2,2,10,11);
      
      protected static const SIMPLE_BORDER_SCALE_9_GRID:Rectangle = new Rectangle(2,2,2,2);
      
      protected static const PANEL_BORDER_SCALE_9_GRID:Rectangle = new Rectangle(5,5,1,1);
      
      protected static const HEADER_SCALE_9_GRID:Rectangle = new Rectangle(1,1,2,28);
      
      protected static const SEEK_SLIDER_MINIMUM_TRACK_SCALE_9_GRID:Rectangle = new Rectangle(3,0,1,4);
      
      protected static const SEEK_SLIDER_MAXIMUM_TRACK_SCALE_9_GRID:Rectangle = new Rectangle(1,0,1,4);
      
      protected static const ITEM_RENDERER_SKIN_TEXTURE_REGION:Rectangle = new Rectangle(1,1,4,4);
      
      protected static const PROGRESS_BAR_FILL_TEXTURE_REGION:Rectangle = new Rectangle(1,1,4,4);
      
      protected static const BACKGROUND_COLOR:uint = 8821927;
      
      protected static const MODAL_OVERLAY_COLOR:uint = 14540253;
      
      protected static const MODAL_OVERLAY_ALPHA:Number = 0.5;
      
      protected static const PRIMARY_TEXT_COLOR:uint = 734012;
      
      protected static const DISABLED_TEXT_COLOR:uint = 5990256;
      
      protected static const INVERTED_TEXT_COLOR:uint = 16777215;
      
      protected static const VIDEO_OVERLAY_COLOR:uint = 13230318;
      
      protected static const VIDEO_OVERLAY_ALPHA:Number = 0.25;
       
      
      protected var smallFontSize:int;
      
      protected var regularFontSize:int;
      
      protected var largeFontSize:int;
      
      protected var gridSize:int;
      
      protected var gutterSize:int;
      
      protected var smallGutterSize:int;
      
      protected var extraSmallGutterSize:int;
      
      protected var buttonMinWidth:int;
      
      protected var wideControlSize:int;
      
      protected var controlSize:int;
      
      protected var smallControlSize:int;
      
      protected var borderSize:int;
      
      protected var calloutBackgroundMinSize:int;
      
      protected var calloutArrowOverlapGap:int;
      
      protected var progressBarFillMinSize:int;
      
      protected var popUpSize:int;
      
      protected var popUpVolumeSliderPaddingSize:int;
      
      protected var bottomDropShadowSize:int;
      
      protected var leftAndRightDropShadowSize:int;
      
      protected var atlas:TextureAtlas;
      
      protected var defaultTextFormat:TextFormat;
      
      protected var disabledTextFormat:TextFormat;
      
      protected var headingTextFormat:TextFormat;
      
      protected var headingDisabledTextFormat:TextFormat;
      
      protected var detailTextFormat:TextFormat;
      
      protected var detailDisabledTextFormat:TextFormat;
      
      protected var invertedTextFormat:TextFormat;
      
      protected var focusIndicatorSkinTexture:Texture;
      
      protected var toolTipBackgroundSkinTexture:Texture;
      
      protected var calloutBackgroundSkinTexture:Texture;
      
      protected var calloutTopArrowSkinTexture:Texture;
      
      protected var calloutRightArrowSkinTexture:Texture;
      
      protected var calloutBottomArrowSkinTexture:Texture;
      
      protected var calloutLeftArrowSkinTexture:Texture;
      
      protected var dangerCalloutBackgroundSkinTexture:Texture;
      
      protected var dangerCalloutTopArrowSkinTexture:Texture;
      
      protected var dangerCalloutRightArrowSkinTexture:Texture;
      
      protected var dangerCalloutBottomArrowSkinTexture:Texture;
      
      protected var dangerCalloutLeftArrowSkinTexture:Texture;
      
      protected var buttonUpSkinTexture:Texture;
      
      protected var buttonHoverSkinTexture:Texture;
      
      protected var buttonDownSkinTexture:Texture;
      
      protected var buttonDisabledSkinTexture:Texture;
      
      protected var toggleButtonSelectedUpSkinTexture:Texture;
      
      protected var toggleButtonSelectedHoverSkinTexture:Texture;
      
      protected var toggleButtonSelectedDownSkinTexture:Texture;
      
      protected var toggleButtonSelectedDisabledSkinTexture:Texture;
      
      protected var quietButtonHoverSkinTexture:Texture;
      
      protected var callToActionButtonUpSkinTexture:Texture;
      
      protected var callToActionButtonHoverSkinTexture:Texture;
      
      protected var dangerButtonUpSkinTexture:Texture;
      
      protected var dangerButtonHoverSkinTexture:Texture;
      
      protected var dangerButtonDownSkinTexture:Texture;
      
      protected var backButtonUpIconTexture:Texture;
      
      protected var backButtonDisabledIconTexture:Texture;
      
      protected var forwardButtonUpIconTexture:Texture;
      
      protected var forwardButtonDisabledIconTexture:Texture;
      
      protected var tabUpSkinTexture:Texture;
      
      protected var tabHoverSkinTexture:Texture;
      
      protected var tabDownSkinTexture:Texture;
      
      protected var tabDisabledSkinTexture:Texture;
      
      protected var tabSelectedUpSkinTexture:Texture;
      
      protected var tabSelectedDisabledSkinTexture:Texture;
      
      protected var stepperIncrementButtonUpSkinTexture:Texture;
      
      protected var stepperIncrementButtonHoverSkinTexture:Texture;
      
      protected var stepperIncrementButtonDownSkinTexture:Texture;
      
      protected var stepperIncrementButtonDisabledSkinTexture:Texture;
      
      protected var stepperDecrementButtonUpSkinTexture:Texture;
      
      protected var stepperDecrementButtonHoverSkinTexture:Texture;
      
      protected var stepperDecrementButtonDownSkinTexture:Texture;
      
      protected var stepperDecrementButtonDisabledSkinTexture:Texture;
      
      protected var hSliderThumbUpSkinTexture:Texture;
      
      protected var hSliderThumbHoverSkinTexture:Texture;
      
      protected var hSliderThumbDownSkinTexture:Texture;
      
      protected var hSliderThumbDisabledSkinTexture:Texture;
      
      protected var hSliderTrackEnabledSkinTexture:Texture;
      
      protected var vSliderThumbUpSkinTexture:Texture;
      
      protected var vSliderThumbHoverSkinTexture:Texture;
      
      protected var vSliderThumbDownSkinTexture:Texture;
      
      protected var vSliderThumbDisabledSkinTexture:Texture;
      
      protected var vSliderTrackEnabledSkinTexture:Texture;
      
      protected var itemRendererUpSkinTexture:Texture;
      
      protected var itemRendererHoverSkinTexture:Texture;
      
      protected var itemRendererSelectedUpSkinTexture:Texture;
      
      protected var headerBackgroundSkinTexture:Texture;
      
      protected var groupedListHeaderBackgroundSkinTexture:Texture;
      
      protected var checkUpIconTexture:Texture;
      
      protected var checkHoverIconTexture:Texture;
      
      protected var checkDownIconTexture:Texture;
      
      protected var checkDisabledIconTexture:Texture;
      
      protected var checkSelectedUpIconTexture:Texture;
      
      protected var checkSelectedHoverIconTexture:Texture;
      
      protected var checkSelectedDownIconTexture:Texture;
      
      protected var checkSelectedDisabledIconTexture:Texture;
      
      protected var radioUpIconTexture:Texture;
      
      protected var radioHoverIconTexture:Texture;
      
      protected var radioDownIconTexture:Texture;
      
      protected var radioDisabledIconTexture:Texture;
      
      protected var radioSelectedUpIconTexture:Texture;
      
      protected var radioSelectedHoverIconTexture:Texture;
      
      protected var radioSelectedDownIconTexture:Texture;
      
      protected var radioSelectedDisabledIconTexture:Texture;
      
      protected var pageIndicatorNormalSkinTexture:Texture;
      
      protected var pageIndicatorSelectedSkinTexture:Texture;
      
      protected var pickerListUpIconTexture:Texture;
      
      protected var pickerListHoverIconTexture:Texture;
      
      protected var pickerListDownIconTexture:Texture;
      
      protected var pickerListDisabledIconTexture:Texture;
      
      protected var textInputBackgroundEnabledSkinTexture:Texture;
      
      protected var textInputBackgroundDisabledSkinTexture:Texture;
      
      protected var textInputBackgroundErrorSkinTexture:Texture;
      
      protected var textInputSearchIconTexture:Texture;
      
      protected var textInputSearchIconDisabledTexture:Texture;
      
      protected var vScrollBarThumbUpSkinTexture:Texture;
      
      protected var vScrollBarThumbHoverSkinTexture:Texture;
      
      protected var vScrollBarThumbDownSkinTexture:Texture;
      
      protected var vScrollBarTrackSkinTexture:Texture;
      
      protected var vScrollBarThumbIconTexture:Texture;
      
      protected var vScrollBarStepButtonUpSkinTexture:Texture;
      
      protected var vScrollBarStepButtonHoverSkinTexture:Texture;
      
      protected var vScrollBarStepButtonDownSkinTexture:Texture;
      
      protected var vScrollBarStepButtonDisabledSkinTexture:Texture;
      
      protected var vScrollBarDecrementButtonIconTexture:Texture;
      
      protected var vScrollBarIncrementButtonIconTexture:Texture;
      
      protected var hScrollBarThumbUpSkinTexture:Texture;
      
      protected var hScrollBarThumbHoverSkinTexture:Texture;
      
      protected var hScrollBarThumbDownSkinTexture:Texture;
      
      protected var hScrollBarTrackSkinTexture:Texture;
      
      protected var hScrollBarThumbIconTexture:Texture;
      
      protected var hScrollBarStepButtonUpSkinTexture:Texture;
      
      protected var hScrollBarStepButtonHoverSkinTexture:Texture;
      
      protected var hScrollBarStepButtonDownSkinTexture:Texture;
      
      protected var hScrollBarStepButtonDisabledSkinTexture:Texture;
      
      protected var hScrollBarDecrementButtonIconTexture:Texture;
      
      protected var hScrollBarIncrementButtonIconTexture:Texture;
      
      protected var simpleBorderBackgroundSkinTexture:Texture;
      
      protected var insetBorderBackgroundSkinTexture:Texture;
      
      protected var panelBorderBackgroundSkinTexture:Texture;
      
      protected var alertBorderBackgroundSkinTexture:Texture;
      
      protected var progressBarFillSkinTexture:Texture;
      
      protected var listDrillDownAccessoryTexture:Texture;
      
      protected var playPauseButtonPlayUpIconTexture:Texture;
      
      protected var playPauseButtonPauseUpIconTexture:Texture;
      
      protected var overlayPlayPauseButtonPlayUpIconTexture:Texture;
      
      protected var fullScreenToggleButtonEnterUpIconTexture:Texture;
      
      protected var fullScreenToggleButtonExitUpIconTexture:Texture;
      
      protected var muteToggleButtonLoudUpIconTexture:Texture;
      
      protected var muteToggleButtonMutedUpIconTexture:Texture;
      
      protected var horizontalVolumeSliderMinimumTrackSkinTexture:Texture;
      
      protected var horizontalVolumeSliderMaximumTrackSkinTexture:Texture;
      
      protected var verticalVolumeSliderMinimumTrackSkinTexture:Texture;
      
      protected var verticalVolumeSliderMaximumTrackSkinTexture:Texture;
      
      protected var popUpVolumeSliderMinimumTrackSkinTexture:Texture;
      
      protected var popUpVolumeSliderMaximumTrackSkinTexture:Texture;
      
      protected var seekSliderMinimumTrackSkinTexture:Texture;
      
      protected var seekSliderMaximumTrackSkinTexture:Texture;
      
      protected var seekSliderProgressSkinTexture:Texture;
      
      public function BaseAeonDesktopTheme()
      {
         super();
      }
      
      protected static function textRendererFactory() : ITextRenderer
      {
         return new TextFieldTextRenderer();
      }
      
      protected static function textEditorFactory() : ITextEditor
      {
         return new TextFieldTextEditor();
      }
      
      protected static function scrollBarFactory() : IScrollBar
      {
         return new ScrollBar();
      }
      
      protected static function popUpOverlayFactory() : DisplayObject
      {
         var _loc1_:Quad = new Quad(100,100,14540253);
         _loc1_.alpha = 0.5;
         return _loc1_;
      }
      
      override public function dispose() : void
      {
         if(this.atlas)
         {
            this.atlas.texture.root.onRestore = null;
            this.atlas.dispose();
            this.atlas = null;
         }
         var _loc1_:Stage = Starling.current.stage;
         FocusManager.setEnabledForStage(_loc1_,false);
         ToolTipManager.setEnabledForStage(_loc1_,false);
         super.dispose();
      }
      
      protected function initialize() : void
      {
         this.initializeDimensions();
         this.initializeFonts();
         this.initializeTextures();
         this.initializeGlobals();
         this.initializeStage();
         this.initializeStyleProviders();
      }
      
      protected function initializeDimensions() : void
      {
         this.gridSize = 30;
         this.extraSmallGutterSize = 2;
         this.smallGutterSize = 6;
         this.gutterSize = 10;
         this.borderSize = 1;
         this.controlSize = 22;
         this.smallControlSize = 12;
         this.calloutBackgroundMinSize = 5;
         this.progressBarFillMinSize = 7;
         this.buttonMinWidth = 40;
         this.wideControlSize = 152;
         this.popUpSize = this.gridSize * 10 + this.smallGutterSize * 9;
         this.popUpVolumeSliderPaddingSize = 6;
         this.leftAndRightDropShadowSize = 1;
         this.bottomDropShadowSize = 3;
         this.calloutArrowOverlapGap = -1;
      }
      
      protected function initializeStage() : void
      {
         Starling.current.stage.color = 8821927;
         Starling.current.nativeStage.color = 8821927;
      }
      
      protected function initializeGlobals() : void
      {
         var _loc1_:Stage = Starling.current.stage;
         FocusManager.setEnabledForStage(_loc1_,true);
         ToolTipManager.setEnabledForStage(_loc1_,true);
         FeathersControl.defaultTextRendererFactory = textRendererFactory;
         FeathersControl.defaultTextEditorFactory = textEditorFactory;
         PopUpManager.overlayFactory = popUpOverlayFactory;
         Callout.stagePadding = this.smallGutterSize;
      }
      
      protected function initializeFonts() : void
      {
         this.smallFontSize = 10;
         this.regularFontSize = 11;
         this.largeFontSize = 13;
         this.defaultTextFormat = new TextFormat("_sans",this.regularFontSize,734012,false,false,false,null,null,"left",0,0,0,0);
         this.disabledTextFormat = new TextFormat("_sans",this.regularFontSize,5990256,false,false,false,null,null,"left",0,0,0,0);
         this.headingTextFormat = new TextFormat("_sans",this.largeFontSize,734012,false,false,false,null,null,"left",0,0,0,0);
         this.headingDisabledTextFormat = new TextFormat("_sans",this.largeFontSize,5990256,false,false,false,null,null,"left",0,0,0,0);
         this.detailTextFormat = new TextFormat("_sans",this.smallFontSize,734012,false,false,false,null,null,"left",0,0,0,0);
         this.detailDisabledTextFormat = new TextFormat("_sans",this.smallFontSize,5990256,false,false,false,null,null,"left",0,0,0,0);
         this.invertedTextFormat = new TextFormat("_sans",this.regularFontSize,16777215,false,false,false,null,null,"left",0,0,0,0);
      }
      
      protected function initializeTextures() : void
      {
         this.focusIndicatorSkinTexture = this.atlas.getTexture("focus-indicator-skin0000");
         this.toolTipBackgroundSkinTexture = this.atlas.getTexture("tool-tip-background-skin0000");
         this.calloutBackgroundSkinTexture = this.atlas.getTexture("callout-background-skin0000");
         this.calloutTopArrowSkinTexture = this.atlas.getTexture("callout-top-arrow-skin0000");
         this.calloutRightArrowSkinTexture = this.atlas.getTexture("callout-right-arrow-skin0000");
         this.calloutBottomArrowSkinTexture = this.atlas.getTexture("callout-bottom-arrow-skin0000");
         this.calloutLeftArrowSkinTexture = this.atlas.getTexture("callout-left-arrow-skin0000");
         this.dangerCalloutBackgroundSkinTexture = this.atlas.getTexture("danger-callout-background-skin0000");
         this.dangerCalloutTopArrowSkinTexture = this.atlas.getTexture("danger-callout-top-arrow-skin0000");
         this.dangerCalloutRightArrowSkinTexture = this.atlas.getTexture("danger-callout-right-arrow-skin0000");
         this.dangerCalloutBottomArrowSkinTexture = this.atlas.getTexture("danger-callout-bottom-arrow-skin0000");
         this.dangerCalloutLeftArrowSkinTexture = this.atlas.getTexture("danger-callout-left-arrow-skin0000");
         this.buttonUpSkinTexture = this.atlas.getTexture("button-up-skin0000");
         this.buttonHoverSkinTexture = this.atlas.getTexture("button-hover-skin0000");
         this.buttonDownSkinTexture = this.atlas.getTexture("button-down-skin0000");
         this.buttonDisabledSkinTexture = this.atlas.getTexture("button-disabled-skin0000");
         this.toggleButtonSelectedUpSkinTexture = this.atlas.getTexture("toggle-button-selected-up-skin0000");
         this.toggleButtonSelectedHoverSkinTexture = this.atlas.getTexture("toggle-button-selected-hover-skin0000");
         this.toggleButtonSelectedDownSkinTexture = this.atlas.getTexture("toggle-button-selected-down-skin0000");
         this.toggleButtonSelectedDisabledSkinTexture = this.atlas.getTexture("toggle-button-selected-disabled-skin0000");
         this.quietButtonHoverSkinTexture = this.atlas.getTexture("quiet-button-hover-skin0000");
         this.callToActionButtonUpSkinTexture = this.atlas.getTexture("call-to-action-button-up-skin0000");
         this.callToActionButtonHoverSkinTexture = this.atlas.getTexture("call-to-action-button-hover-skin0000");
         this.dangerButtonUpSkinTexture = this.atlas.getTexture("danger-button-up-skin0000");
         this.dangerButtonHoverSkinTexture = this.atlas.getTexture("danger-button-hover-skin0000");
         this.dangerButtonDownSkinTexture = this.atlas.getTexture("danger-button-down-skin0000");
         this.backButtonUpIconTexture = this.atlas.getTexture("back-button-up-icon0000");
         this.backButtonDisabledIconTexture = this.atlas.getTexture("back-button-disabled-icon0000");
         this.forwardButtonUpIconTexture = this.atlas.getTexture("forward-button-up-icon0000");
         this.forwardButtonDisabledIconTexture = this.atlas.getTexture("forward-button-disabled-icon0000");
         this.tabUpSkinTexture = this.atlas.getTexture("tab-up-skin0000");
         this.tabHoverSkinTexture = this.atlas.getTexture("tab-hover-skin0000");
         this.tabDownSkinTexture = this.atlas.getTexture("tab-down-skin0000");
         this.tabDisabledSkinTexture = this.atlas.getTexture("tab-disabled-skin0000");
         this.tabSelectedUpSkinTexture = this.atlas.getTexture("tab-selected-up-skin0000");
         this.tabSelectedDisabledSkinTexture = this.atlas.getTexture("tab-selected-disabled-skin0000");
         this.stepperIncrementButtonUpSkinTexture = this.atlas.getTexture("numeric-stepper-increment-button-up-skin0000");
         this.stepperIncrementButtonHoverSkinTexture = this.atlas.getTexture("numeric-stepper-increment-button-hover-skin0000");
         this.stepperIncrementButtonDownSkinTexture = this.atlas.getTexture("numeric-stepper-increment-button-down-skin0000");
         this.stepperIncrementButtonDisabledSkinTexture = this.atlas.getTexture("numeric-stepper-increment-button-disabled-skin0000");
         this.stepperDecrementButtonUpSkinTexture = this.atlas.getTexture("numeric-stepper-decrement-button-up-skin0000");
         this.stepperDecrementButtonHoverSkinTexture = this.atlas.getTexture("numeric-stepper-decrement-button-hover-skin0000");
         this.stepperDecrementButtonDownSkinTexture = this.atlas.getTexture("numeric-stepper-decrement-button-down-skin0000");
         this.stepperDecrementButtonDisabledSkinTexture = this.atlas.getTexture("numeric-stepper-decrement-button-disabled-skin0000");
         this.hSliderThumbUpSkinTexture = this.atlas.getTexture("horizontal-slider-thumb-up-skin0000");
         this.hSliderThumbHoverSkinTexture = this.atlas.getTexture("horizontal-slider-thumb-hover-skin0000");
         this.hSliderThumbDownSkinTexture = this.atlas.getTexture("horizontal-slider-thumb-down-skin0000");
         this.hSliderThumbDisabledSkinTexture = this.atlas.getTexture("horizontal-slider-thumb-disabled-skin0000");
         this.hSliderTrackEnabledSkinTexture = this.atlas.getTexture("horizontal-slider-track-enabled-skin0000");
         this.vSliderThumbUpSkinTexture = this.atlas.getTexture("vertical-slider-thumb-up-skin0000");
         this.vSliderThumbHoverSkinTexture = this.atlas.getTexture("vertical-slider-thumb-hover-skin0000");
         this.vSliderThumbDownSkinTexture = this.atlas.getTexture("vertical-slider-thumb-down-skin0000");
         this.vSliderThumbDisabledSkinTexture = this.atlas.getTexture("vertical-slider-thumb-disabled-skin0000");
         this.vSliderTrackEnabledSkinTexture = this.atlas.getTexture("vertical-slider-track-enabled-skin0000");
         this.itemRendererUpSkinTexture = Texture.fromTexture(this.atlas.getTexture("item-renderer-up-skin0000"),ITEM_RENDERER_SKIN_TEXTURE_REGION);
         this.itemRendererHoverSkinTexture = Texture.fromTexture(this.atlas.getTexture("item-renderer-hover-skin0000"),ITEM_RENDERER_SKIN_TEXTURE_REGION);
         this.itemRendererSelectedUpSkinTexture = Texture.fromTexture(this.atlas.getTexture("item-renderer-selected-up-skin0000"),ITEM_RENDERER_SKIN_TEXTURE_REGION);
         this.headerBackgroundSkinTexture = this.atlas.getTexture("header-background-skin0000");
         this.groupedListHeaderBackgroundSkinTexture = this.atlas.getTexture("grouped-list-header-background-skin0000");
         this.checkUpIconTexture = this.atlas.getTexture("check-up-icon0000");
         this.checkHoverIconTexture = this.atlas.getTexture("check-hover-icon0000");
         this.checkDownIconTexture = this.atlas.getTexture("check-down-icon0000");
         this.checkDisabledIconTexture = this.atlas.getTexture("check-disabled-icon0000");
         this.checkSelectedUpIconTexture = this.atlas.getTexture("check-selected-up-icon0000");
         this.checkSelectedHoverIconTexture = this.atlas.getTexture("check-selected-hover-icon0000");
         this.checkSelectedDownIconTexture = this.atlas.getTexture("check-selected-down-icon0000");
         this.checkSelectedDisabledIconTexture = this.atlas.getTexture("check-selected-disabled-icon0000");
         this.radioUpIconTexture = this.atlas.getTexture("radio-up-icon0000");
         this.radioHoverIconTexture = this.atlas.getTexture("radio-hover-icon0000");
         this.radioDownIconTexture = this.atlas.getTexture("radio-down-icon0000");
         this.radioDisabledIconTexture = this.atlas.getTexture("radio-disabled-icon0000");
         this.radioSelectedUpIconTexture = this.atlas.getTexture("radio-selected-up-icon0000");
         this.radioSelectedHoverIconTexture = this.atlas.getTexture("radio-selected-hover-icon0000");
         this.radioSelectedDownIconTexture = this.atlas.getTexture("radio-selected-down-icon0000");
         this.radioSelectedDisabledIconTexture = this.atlas.getTexture("radio-selected-disabled-icon0000");
         this.pageIndicatorNormalSkinTexture = this.atlas.getTexture("page-indicator-normal-symbol0000");
         this.pageIndicatorSelectedSkinTexture = this.atlas.getTexture("page-indicator-selected-symbol0000");
         this.pickerListUpIconTexture = this.atlas.getTexture("picker-list-up-icon0000");
         this.pickerListHoverIconTexture = this.atlas.getTexture("picker-list-hover-icon0000");
         this.pickerListDownIconTexture = this.atlas.getTexture("picker-list-down-icon0000");
         this.pickerListDisabledIconTexture = this.atlas.getTexture("picker-list-disabled-icon0000");
         this.textInputBackgroundEnabledSkinTexture = this.atlas.getTexture("text-input-background-enabled-skin0000");
         this.textInputBackgroundDisabledSkinTexture = this.atlas.getTexture("text-input-background-disabled-skin0000");
         this.textInputBackgroundErrorSkinTexture = this.atlas.getTexture("text-input-background-error-skin0000");
         this.textInputSearchIconTexture = this.atlas.getTexture("search-icon0000");
         this.textInputSearchIconDisabledTexture = this.atlas.getTexture("search-icon-disabled0000");
         this.vScrollBarThumbUpSkinTexture = this.atlas.getTexture("vertical-scroll-bar-thumb-up-skin0000");
         this.vScrollBarThumbHoverSkinTexture = this.atlas.getTexture("vertical-scroll-bar-thumb-hover-skin0000");
         this.vScrollBarThumbDownSkinTexture = this.atlas.getTexture("vertical-scroll-bar-thumb-down-skin0000");
         this.vScrollBarTrackSkinTexture = this.atlas.getTexture("vertical-scroll-bar-track-skin0000");
         this.vScrollBarThumbIconTexture = this.atlas.getTexture("vertical-scroll-bar-thumb-icon0000");
         this.vScrollBarStepButtonUpSkinTexture = this.atlas.getTexture("vertical-scroll-bar-step-button-up-skin0000");
         this.vScrollBarStepButtonHoverSkinTexture = this.atlas.getTexture("vertical-scroll-bar-step-button-hover-skin0000");
         this.vScrollBarStepButtonDownSkinTexture = this.atlas.getTexture("vertical-scroll-bar-step-button-down-skin0000");
         this.vScrollBarStepButtonDisabledSkinTexture = this.atlas.getTexture("vertical-scroll-bar-step-button-disabled-skin0000");
         this.vScrollBarDecrementButtonIconTexture = this.atlas.getTexture("vertical-scroll-bar-decrement-button-icon0000");
         this.vScrollBarIncrementButtonIconTexture = this.atlas.getTexture("vertical-scroll-bar-increment-button-icon0000");
         this.hScrollBarThumbUpSkinTexture = this.atlas.getTexture("horizontal-scroll-bar-thumb-up-skin0000");
         this.hScrollBarThumbHoverSkinTexture = this.atlas.getTexture("horizontal-scroll-bar-thumb-hover-skin0000");
         this.hScrollBarThumbDownSkinTexture = this.atlas.getTexture("horizontal-scroll-bar-thumb-down-skin0000");
         this.hScrollBarTrackSkinTexture = this.atlas.getTexture("horizontal-scroll-bar-track-skin0000");
         this.hScrollBarThumbIconTexture = this.atlas.getTexture("horizontal-scroll-bar-thumb-icon0000");
         this.hScrollBarStepButtonUpSkinTexture = this.atlas.getTexture("horizontal-scroll-bar-step-button-up-skin0000");
         this.hScrollBarStepButtonHoverSkinTexture = this.atlas.getTexture("horizontal-scroll-bar-step-button-hover-skin0000");
         this.hScrollBarStepButtonDownSkinTexture = this.atlas.getTexture("horizontal-scroll-bar-step-button-down-skin0000");
         this.hScrollBarStepButtonDisabledSkinTexture = this.atlas.getTexture("horizontal-scroll-bar-step-button-disabled-skin0000");
         this.hScrollBarDecrementButtonIconTexture = this.atlas.getTexture("horizontal-scroll-bar-decrement-button-icon0000");
         this.hScrollBarIncrementButtonIconTexture = this.atlas.getTexture("horizontal-scroll-bar-increment-button-icon0000");
         this.simpleBorderBackgroundSkinTexture = this.atlas.getTexture("simple-border-background-skin0000");
         this.insetBorderBackgroundSkinTexture = this.atlas.getTexture("inset-border-background-skin0000");
         this.panelBorderBackgroundSkinTexture = this.atlas.getTexture("panel-background-skin0000");
         this.alertBorderBackgroundSkinTexture = this.atlas.getTexture("alert-background-skin0000");
         this.progressBarFillSkinTexture = Texture.fromTexture(this.atlas.getTexture("progress-bar-fill-skin0000"),PROGRESS_BAR_FILL_TEXTURE_REGION);
         this.playPauseButtonPlayUpIconTexture = this.atlas.getTexture("play-pause-toggle-button-play-up-icon0000");
         this.playPauseButtonPauseUpIconTexture = this.atlas.getTexture("play-pause-toggle-button-pause-up-icon0000");
         this.overlayPlayPauseButtonPlayUpIconTexture = this.atlas.getTexture("overlay-play-pause-toggle-button-play-up-icon0000");
         this.fullScreenToggleButtonEnterUpIconTexture = this.atlas.getTexture("full-screen-toggle-button-enter-up-icon0000");
         this.fullScreenToggleButtonExitUpIconTexture = this.atlas.getTexture("full-screen-toggle-button-exit-up-icon0000");
         this.muteToggleButtonMutedUpIconTexture = this.atlas.getTexture("mute-toggle-button-muted-up-icon0000");
         this.muteToggleButtonLoudUpIconTexture = this.atlas.getTexture("mute-toggle-button-loud-up-icon0000");
         this.horizontalVolumeSliderMinimumTrackSkinTexture = this.atlas.getTexture("horizontal-volume-slider-minimum-track-skin0000");
         this.horizontalVolumeSliderMaximumTrackSkinTexture = this.atlas.getTexture("horizontal-volume-slider-maximum-track-skin0000");
         this.verticalVolumeSliderMinimumTrackSkinTexture = this.atlas.getTexture("vertical-volume-slider-minimum-track-skin0000");
         this.verticalVolumeSliderMaximumTrackSkinTexture = this.atlas.getTexture("vertical-volume-slider-maximum-track-skin0000");
         this.popUpVolumeSliderMinimumTrackSkinTexture = this.atlas.getTexture("pop-up-volume-slider-minimum-track-skin0000");
         this.popUpVolumeSliderMaximumTrackSkinTexture = this.atlas.getTexture("pop-up-volume-slider-maximum-track-skin0000");
         this.seekSliderMinimumTrackSkinTexture = this.atlas.getTexture("seek-slider-minimum-track-skin0000");
         this.seekSliderMaximumTrackSkinTexture = this.atlas.getTexture("seek-slider-maximum-track-skin0000");
         this.seekSliderProgressSkinTexture = this.atlas.getTexture("seek-slider-progress-skin0000");
         this.listDrillDownAccessoryTexture = this.atlas.getTexture("drill-down-icon0000");
      }
      
      protected function initializeStyleProviders() : void
      {
         this.getStyleProviderForClass(Alert).defaultStyleFunction = this.setAlertStyles;
         this.getStyleProviderForClass(Header).setFunctionForStyleName("feathers-alert-header",this.setPanelHeaderStyles);
         this.getStyleProviderForClass(ButtonGroup).setFunctionForStyleName("feathers-alert-button-group",this.setAlertButtonGroupStyles);
         this.getStyleProviderForClass(TextFieldTextRenderer).setFunctionForStyleName("feathers-alert-message",this.setAlertMessageTextRendererStyles);
         this.getStyleProviderForClass(AutoComplete).defaultStyleFunction = this.setTextInputStyles;
         this.getStyleProviderForClass(List).setFunctionForStyleName("feathers-auto-complete-list",this.setDropDownListStyles);
         this.getStyleProviderForClass(Button).defaultStyleFunction = this.setButtonStyles;
         this.getStyleProviderForClass(Button).setFunctionForStyleName("feathers-quiet-button",this.setQuietButtonStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName("feathers-call-to-action-button",this.setCallToActionButtonStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName("feathers-danger-button",this.setDangerButtonStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName("feathers-back-button",this.setBackButtonStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName("feathers-forward-button",this.setForwardButtonStyles);
         this.getStyleProviderForClass(TextFieldTextRenderer).setFunctionForStyleName("feathers-button-label",this.setButtonLabelStyles);
         this.getStyleProviderForClass(ButtonGroup).defaultStyleFunction = this.setButtonGroupStyles;
         this.getStyleProviderForClass(Callout).defaultStyleFunction = this.setCalloutStyles;
         this.getStyleProviderForClass(Check).defaultStyleFunction = this.setCheckStyles;
         this.getStyleProviderForClass(TextFieldTextRenderer).setFunctionForStyleName("feathers-check-label",this.setCheckLabelStyles);
         this.getStyleProviderForClass(SpinnerList).setFunctionForStyleName("feathers-date-time-spinner-list",this.setDateTimeSpinnerListStyles);
         this.getStyleProviderForClass(DefaultListItemRenderer).setFunctionForStyleName("aeon-date-time-spinner-list-item-renderer",this.setDateTimeSpinnerListItemRendererStyles);
         this.getStyleProviderForClass(Drawers).defaultStyleFunction = this.setDrawersStyles;
         this.getStyleProviderForClass(GroupedList).defaultStyleFunction = this.setGroupedListStyles;
         this.getStyleProviderForClass(GroupedList).setFunctionForStyleName("feathers-inset-grouped-list",this.setInsetGroupedListStyles);
         this.getStyleProviderForClass(Header).defaultStyleFunction = this.setHeaderStyles;
         this.getStyleProviderForClass(TextFieldTextRenderer).setFunctionForStyleName("feathers-header-title",this.setHeaderTitleStyles);
         this.getStyleProviderForClass(DefaultListItemRenderer).defaultStyleFunction = this.setItemRendererStyles;
         this.getStyleProviderForClass(DefaultListItemRenderer).setFunctionForStyleName("feathers-drill-down-item-renderer",this.setDrillDownItemRendererStyles);
         this.getStyleProviderForClass(DefaultListItemRenderer).setFunctionForStyleName("feathers-check-item-renderer",this.setCheckItemRendererStyles);
         this.getStyleProviderForClass(DefaultGroupedListItemRenderer).defaultStyleFunction = this.setItemRendererStyles;
         this.getStyleProviderForClass(DefaultGroupedListItemRenderer).setFunctionForStyleName("feathers-drill-down-item-renderer",this.setDrillDownItemRendererStyles);
         this.getStyleProviderForClass(DefaultGroupedListItemRenderer).setFunctionForStyleName("feathers-check-item-renderer",this.setCheckItemRendererStyles);
         this.getStyleProviderForClass(DefaultGroupedListItemRenderer).setFunctionForStyleName("feathers-grouped-list-inset-item-renderer",this.setInsetGroupedListItemRendererStyles);
         this.getStyleProviderForClass(TextFieldTextRenderer).setFunctionForStyleName("feathers-item-renderer-accessory-label",this.setItemRendererAccessoryLabelStyles);
         this.getStyleProviderForClass(TextFieldTextRenderer).setFunctionForStyleName("feathers-item-renderer-icon-label",this.setItemRendererIconLabelStyles);
         this.getStyleProviderForClass(TextFieldTextRenderer).setFunctionForStyleName("feathers-item-renderer-label",this.setItemRendererLabelStyles);
         this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).defaultStyleFunction = this.setGroupedListHeaderOrFooterRendererStyles;
         this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).setFunctionForStyleName("feathers-grouped-list-inset-header-renderer",this.setInsetGroupedListHeaderRendererStyles);
         this.getStyleProviderForClass(DefaultGroupedListHeaderOrFooterRenderer).setFunctionForStyleName("feathers-grouped-list-inset-footer-renderer",this.setInsetGroupedListFooterRendererStyles);
         this.getStyleProviderForClass(TextFieldTextRenderer).setFunctionForStyleName("feathers-header-footer-renderer-content-label",this.setGroupedListHeaderOrFooterRendererContentLabelStyles);
         this.getStyleProviderForClass(Label).setFunctionForStyleName("feathers-heading-label",this.setHeadingLabelStyles);
         this.getStyleProviderForClass(Label).setFunctionForStyleName("feathers-detail-label",this.setDetailLabelStyles);
         this.getStyleProviderForClass(Label).setFunctionForStyleName("feathers-tool-tip",this.setToolTipLabelStyles);
         this.getStyleProviderForClass(TextFieldTextRenderer).setFunctionForStyleName("feathers-label-text-renderer",this.setLabelTextRendererStyles);
         this.getStyleProviderForClass(TextFieldTextRenderer).setFunctionForStyleName("aeon-heading-label-text-renderer",this.setHeadingLabelTextRendererStyles);
         this.getStyleProviderForClass(TextFieldTextRenderer).setFunctionForStyleName("aeon-detail-label-text-renderer",this.setDetailLabelTextRendererStyles);
         this.getStyleProviderForClass(LayoutGroup).setFunctionForStyleName("feathers-toolbar-layout-group",this.setToolbarLayoutGroupStyles);
         this.getStyleProviderForClass(List).defaultStyleFunction = this.setListStyles;
         this.getStyleProviderForClass(NumericStepper).defaultStyleFunction = this.setNumericStepperStyles;
         this.getStyleProviderForClass(TextInput).setFunctionForStyleName("feathers-numeric-stepper-text-input",this.setNumericStepperTextInputStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName("feathers-numeric-stepper-increment-button",this.setNumericStepperIncrementButtonStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName("feathers-numeric-stepper-decrement-button",this.setNumericStepperDecrementButtonStyles);
         this.getStyleProviderForClass(Panel).defaultStyleFunction = this.setPanelStyles;
         this.getStyleProviderForClass(Header).setFunctionForStyleName("feathers-panel-header",this.setPanelHeaderStyles);
         this.getStyleProviderForClass(PanelScreen).defaultStyleFunction = this.setPanelScreenStyles;
         this.getStyleProviderForClass(PageIndicator).defaultStyleFunction = this.setPageIndicatorStyles;
         this.getStyleProviderForClass(PickerList).defaultStyleFunction = this.setPickerListStyles;
         this.getStyleProviderForClass(List).setFunctionForStyleName("feathers-picker-list-list",this.setDropDownListStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName("feathers-picker-list-button",this.setPickerListButtonStyles);
         this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName("feathers-picker-list-button",this.setPickerListButtonStyles);
         this.getStyleProviderForClass(ProgressBar).defaultStyleFunction = this.setProgressBarStyles;
         this.getStyleProviderForClass(Radio).defaultStyleFunction = this.setRadioStyles;
         this.getStyleProviderForClass(TextFieldTextRenderer).setFunctionForStyleName("feathers-radio-label",this.setRadioLabelStyles);
         this.getStyleProviderForClass(ScrollBar).setFunctionForStyleName("feathers-scroller-horizontal-scroll-bar",this.setHorizontalScrollBarStyles);
         this.getStyleProviderForClass(ScrollBar).setFunctionForStyleName("feathers-scroller-vertical-scroll-bar",this.setVerticalScrollBarStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName("aeon-horizontal-scroll-bar-increment-button",this.setHorizontalScrollBarIncrementButtonStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName("aeon-horizontal-scroll-bar-decrement-button",this.setHorizontalScrollBarDecrementButtonStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName("aeon-horizontal-scroll-bar-thumb",this.setHorizontalScrollBarThumbStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName("aeon-horizontal-scroll-bar-minimum-track",this.setHorizontalScrollBarMinimumTrackStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName("aeon-vertical-scroll-bar-increment-button",this.setVerticalScrollBarIncrementButtonStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName("aeon-vertical-scroll-bar-decrement-button",this.setVerticalScrollBarDecrementButtonStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName("aeon-vertical-scroll-bar-thumb",this.setVerticalScrollBarThumbStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName("aeon-vertical-scroll-bar-minimum-track",this.setVerticalScrollBarMinimumTrackStyles);
         this.getStyleProviderForClass(ScrollContainer).defaultStyleFunction = this.setScrollContainerStyles;
         this.getStyleProviderForClass(ScrollContainer).setFunctionForStyleName("feathers-toolbar-scroll-container",this.setToolbarScrollContainerStyles);
         this.getStyleProviderForClass(ScrollScreen).defaultStyleFunction = this.setScrollScreenStyles;
         this.getStyleProviderForClass(ScrollText).defaultStyleFunction = this.setScrollTextStyles;
         this.getStyleProviderForClass(SimpleScrollBar).setFunctionForStyleName("feathers-scroller-horizontal-scroll-bar",this.setHorizontalSimpleScrollBarStyles);
         this.getStyleProviderForClass(SimpleScrollBar).setFunctionForStyleName("feathers-scroller-vertical-scroll-bar",this.setVerticalSimpleScrollBarStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName("aeon-horizontal-simple-scroll-bar-thumb",this.setHorizontalSimpleScrollBarThumbStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName("aeon-vertical-simple-scroll-bar-thumb",this.setVerticalSimpleScrollBarThumbStyles);
         this.getStyleProviderForClass(Slider).defaultStyleFunction = this.setSliderStyles;
         this.getStyleProviderForClass(Button).setFunctionForStyleName("aeon-horizontal-slider-thumb",this.setHorizontalSliderThumbStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName("aeon-horizontal-slider-minimum-track",this.setHorizontalSliderMinimumTrackStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName("aeon-vertical-slider-thumb",this.setVerticalSliderThumbStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName("aeon-vertical-slider-minimum-track",this.setVerticalSliderMinimumTrackStyles);
         this.getStyleProviderForClass(SpinnerList).defaultStyleFunction = this.setSpinnerListStyles;
         this.getStyleProviderForClass(TabBar).defaultStyleFunction = this.setTabBarStyles;
         this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName("feathers-tab-bar-tab",this.setTabStyles);
         this.getStyleProviderForClass(TextArea).defaultStyleFunction = this.setTextAreaStyles;
         this.getStyleProviderForClass(TextFieldTextEditorViewPort).setFunctionForStyleName("feathers-text-area-text-editor",this.setTextAreaTextEditorStyles);
         this.getStyleProviderForClass(TextCallout).setFunctionForStyleName("feathers-text-input-error-callout",this.setTextAreaErrorCalloutStyles);
         this.getStyleProviderForClass(TextCallout).defaultStyleFunction = this.setTextCalloutStyles;
         this.getStyleProviderForClass(TextFieldTextRenderer).setFunctionForStyleName("feathers-text-callout-text-renderer",this.setTextCalloutTextRendererStyles);
         this.getStyleProviderForClass(TextFieldTextRenderer).setFunctionForStyleName("aeon-danger-text-callout-text-renderer",this.setDangerTextCalloutTextRendererStyles);
         this.getStyleProviderForClass(TextInput).defaultStyleFunction = this.setTextInputStyles;
         this.getStyleProviderForClass(TextInput).setFunctionForStyleName("feathers-search-text-input",this.setSearchTextInputStyles);
         this.getStyleProviderForClass(TextFieldTextEditor).setFunctionForStyleName("feathers-text-input-text-editor",this.setTextInputTextEditorStyles);
         this.getStyleProviderForClass(TextFieldTextRenderer).setFunctionForStyleName("feathers-text-input-prompt",this.setTextInputPromptStyles);
         this.getStyleProviderForClass(TextCallout).setFunctionForStyleName("feathers-text-input-error-callout",this.setTextInputErrorCalloutStyles);
         this.getStyleProviderForClass(ToggleButton).defaultStyleFunction = this.setButtonStyles;
         this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName("feathers-quiet-button",this.setQuietButtonStyles);
         this.getStyleProviderForClass(ToggleSwitch).defaultStyleFunction = this.setToggleSwitchStyles;
         this.getStyleProviderForClass(Button).setFunctionForStyleName("feathers-toggle-switch-on-track",this.setToggleSwitchOnTrackStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName("feathers-toggle-switch-thumb",this.setToggleSwitchThumbStyles);
         this.getStyleProviderForClass(ToggleButton).setFunctionForStyleName("feathers-toggle-switch-thumb",this.setToggleSwitchThumbStyles);
         this.getStyleProviderForClass(TextFieldTextRenderer).setFunctionForStyleName("feathers-toggle-switch-on-label",this.setToggleSwitchOnLabelStyles);
         this.getStyleProviderForClass(TextFieldTextRenderer).setFunctionForStyleName("feathers-toggle-switch-off-label",this.setToggleSwitchOffLabelStyles);
         this.getStyleProviderForClass(PlayPauseToggleButton).defaultStyleFunction = this.setPlayPauseToggleButtonStyles;
         this.getStyleProviderForClass(PlayPauseToggleButton).setFunctionForStyleName("feathers-overlay-play-pause-toggle-button",this.setOverlayPlayPauseToggleButtonStyles);
         this.getStyleProviderForClass(FullScreenToggleButton).defaultStyleFunction = this.setFullScreenToggleButtonStyles;
         this.getStyleProviderForClass(MuteToggleButton).defaultStyleFunction = this.setMuteToggleButtonStyles;
         this.getStyleProviderForClass(VolumeSlider).setFunctionForStyleName("feathers-volume-toggle-button-volume-slider",this.setPopUpVolumeSliderStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName("aeon-pop-up-volume-slider-minimum-track",this.setPopUpVolumeSliderMinimumTrackStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName("aeon-pop-up-volume-slider-maximum-track",this.setPopUpVolumeSliderMaximumTrackStyles);
         this.getStyleProviderForClass(SeekSlider).defaultStyleFunction = this.setSeekSliderStyles;
         this.getStyleProviderForClass(Button).setFunctionForStyleName("feathers-seek-slider-thumb",this.setHorizontalSliderThumbStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName("feathers-seek-slider-minimum-track",this.setSeekSliderMinimumTrackStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName("feathers-seek-slider-maximum-track",this.setSeekSliderMaximumTrackStyles);
         this.getStyleProviderForClass(VolumeSlider).defaultStyleFunction = this.setVolumeSliderStyles;
         this.getStyleProviderForClass(Button).setFunctionForStyleName("feathers-volume-slider-thumb",this.setVolumeSliderThumbStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName("aeon-horizontal-volume-slider-minimum-track",this.setHorizontalVolumeSliderMinimumTrackStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName("aeon-horizontal-volume-slider-maximum-track",this.setHorizontalVolumeSliderMaximumTrackStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName("aeon-vertical-volume-slider-minimum-track",this.setVerticalVolumeSliderMinimumTrackStyles);
         this.getStyleProviderForClass(Button).setFunctionForStyleName("aeon-vertical-volume-slider-maximum-track",this.setVerticalVolumeSliderMaximumTrackStyles);
      }
      
      protected function pageIndicatorNormalSymbolFactory() : Image
      {
         return new Image(this.pageIndicatorNormalSkinTexture);
      }
      
      protected function pageIndicatorSelectedSymbolFactory() : Image
      {
         return new Image(this.pageIndicatorSelectedSkinTexture);
      }
      
      protected function setScrollerStyles(param1:Scroller) : void
      {
         param1.clipContent = true;
         param1.horizontalScrollBarFactory = scrollBarFactory;
         param1.verticalScrollBarFactory = scrollBarFactory;
         param1.interactionMode = "mouse";
         param1.scrollBarDisplayMode = "fixed";
         var _loc2_:Image = new Image(this.focusIndicatorSkinTexture);
         _loc2_.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
         param1.focusIndicatorSkin = _loc2_;
         param1.focusPadding = 0;
      }
      
      protected function setDropDownListStyles(param1:List) : void
      {
         this.setListStyles(param1);
         param1.maxHeight = this.wideControlSize;
      }
      
      protected function setAlertStyles(param1:Alert) : void
      {
         this.setScrollerStyles(param1);
         var _loc2_:Image = new Image(this.alertBorderBackgroundSkinTexture);
         _loc2_.scale9Grid = PANEL_BORDER_SCALE_9_GRID;
         param1.backgroundSkin = _loc2_;
         param1.outerPadding = this.borderSize;
         param1.paddingTop = this.smallGutterSize;
         param1.paddingBottom = this.smallGutterSize;
         param1.paddingRight = this.gutterSize;
         param1.paddingLeft = this.gutterSize;
         param1.gap = this.gutterSize;
         param1.maxWidth = this.popUpSize;
         param1.maxHeight = this.popUpSize;
      }
      
      protected function setAlertButtonGroupStyles(param1:ButtonGroup) : void
      {
         param1.direction = "horizontal";
         param1.horizontalAlign = "center";
         param1.verticalAlign = "justify";
         param1.distributeButtonSizes = false;
         param1.gap = this.smallGutterSize;
         param1.padding = this.smallGutterSize;
      }
      
      protected function setAlertMessageTextRendererStyles(param1:TextFieldTextRenderer) : void
      {
         param1.textFormat = this.defaultTextFormat;
         param1.disabledTextFormat = this.disabledTextFormat;
         param1.wordWrap = true;
      }
      
      protected function setBaseButtonStyles(param1:Button) : void
      {
         var _loc2_:Image = new Image(this.focusIndicatorSkinTexture);
         _loc2_.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
         param1.focusIndicatorSkin = _loc2_;
         param1.focusPadding = -1;
         param1.paddingTop = this.extraSmallGutterSize;
         param1.paddingBottom = this.extraSmallGutterSize;
         param1.paddingLeft = this.smallGutterSize;
         param1.paddingRight = this.smallGutterSize;
         param1.gap = this.smallGutterSize;
         param1.minGap = this.smallGutterSize;
         param1.minWidth = this.smallControlSize;
         param1.minHeight = this.smallControlSize;
      }
      
      protected function setButtonStyles(param1:Button) : void
      {
         var _loc2_:ImageSkin = new ImageSkin(this.buttonUpSkinTexture);
         _loc2_.setTextureForState("hover",this.buttonHoverSkinTexture);
         _loc2_.setTextureForState("down",this.buttonDownSkinTexture);
         _loc2_.setTextureForState("disabled",this.buttonDisabledSkinTexture);
         if(param1 is ToggleButton)
         {
            _loc2_.selectedTexture = this.toggleButtonSelectedUpSkinTexture;
            _loc2_.setTextureForState("hoverAndSelected",this.toggleButtonSelectedHoverSkinTexture);
            _loc2_.setTextureForState("downAndSelected",this.toggleButtonSelectedDownSkinTexture);
            _loc2_.setTextureForState("disabledAndSelected",this.toggleButtonSelectedDisabledSkinTexture);
         }
         _loc2_.scale9Grid = BUTTON_SCALE_9_GRID;
         param1.defaultSkin = _loc2_;
         this.setBaseButtonStyles(param1);
         param1.minWidth = this.buttonMinWidth;
         param1.minHeight = this.controlSize;
      }
      
      protected function setQuietButtonStyles(param1:Button) : void
      {
         var _loc2_:Quad = new Quad(this.controlSize,this.controlSize,16711935);
         _loc2_.alpha = 0;
         param1.defaultSkin = _loc2_;
         var _loc3_:ImageSkin = new ImageSkin(null);
         _loc3_.setTextureForState("hover",this.quietButtonHoverSkinTexture);
         _loc3_.setTextureForState("down",this.buttonDownSkinTexture);
         param1.setSkinForState("hover",_loc3_);
         param1.setSkinForState("down",_loc3_);
         if(param1 is ToggleButton)
         {
            _loc3_.selectedTexture = this.toggleButtonSelectedUpSkinTexture;
            _loc3_.setTextureForState("hoverAndSelected",this.toggleButtonSelectedHoverSkinTexture);
            _loc3_.setTextureForState("downAndSelected",this.toggleButtonSelectedDownSkinTexture);
            _loc3_.setTextureForState("disabledAndSelected",this.toggleButtonSelectedDisabledSkinTexture);
            ToggleButton(param1).defaultSelectedSkin = _loc3_;
         }
         _loc3_.scale9Grid = BUTTON_SCALE_9_GRID;
         _loc3_.width = this.controlSize;
         _loc3_.height = this.controlSize;
         this.setBaseButtonStyles(param1);
         param1.minWidth = this.controlSize;
         param1.minHeight = this.controlSize;
      }
      
      protected function setCallToActionButtonStyles(param1:Button) : void
      {
         var _loc2_:ImageSkin = new ImageSkin(this.callToActionButtonUpSkinTexture);
         _loc2_.setTextureForState("hover",this.callToActionButtonHoverSkinTexture);
         _loc2_.setTextureForState("down",this.buttonDownSkinTexture);
         _loc2_.scale9Grid = BUTTON_SCALE_9_GRID;
         _loc2_.width = this.controlSize;
         _loc2_.height = this.controlSize;
         param1.defaultSkin = _loc2_;
         this.setBaseButtonStyles(param1);
         param1.minWidth = this.controlSize;
         param1.minHeight = this.controlSize;
      }
      
      protected function setDangerButtonStyles(param1:Button) : void
      {
         var _loc2_:ImageSkin = new ImageSkin(this.dangerButtonUpSkinTexture);
         _loc2_.setTextureForState("hover",this.dangerButtonHoverSkinTexture);
         _loc2_.setTextureForState("down",this.dangerButtonDownSkinTexture);
         _loc2_.scale9Grid = BUTTON_SCALE_9_GRID;
         _loc2_.width = this.controlSize;
         _loc2_.height = this.controlSize;
         param1.defaultSkin = _loc2_;
         this.setBaseButtonStyles(param1);
         param1.minWidth = this.controlSize;
         param1.minHeight = this.controlSize;
      }
      
      protected function setBackButtonStyles(param1:Button) : void
      {
         this.setButtonStyles(param1);
         var _loc2_:ImageSkin = new ImageSkin(this.backButtonUpIconTexture);
         _loc2_.disabledTexture = this.backButtonDisabledIconTexture;
         param1.defaultIcon = _loc2_;
         param1.iconPosition = "leftBaseline";
      }
      
      protected function setForwardButtonStyles(param1:Button) : void
      {
         this.setButtonStyles(param1);
         var _loc2_:ImageSkin = new ImageSkin(this.forwardButtonUpIconTexture);
         _loc2_.disabledTexture = this.forwardButtonDisabledIconTexture;
         param1.defaultIcon = _loc2_;
         param1.iconPosition = "rightBaseline";
      }
      
      protected function setButtonLabelStyles(param1:TextFieldTextRenderer) : void
      {
         param1.textFormat = this.defaultTextFormat;
         param1.disabledTextFormat = this.disabledTextFormat;
      }
      
      protected function setButtonGroupStyles(param1:ButtonGroup) : void
      {
         param1.gap = this.smallGutterSize;
      }
      
      protected function setCalloutStyles(param1:Callout) : void
      {
         var _loc5_:Image;
         (_loc5_ = new Image(this.calloutBackgroundSkinTexture)).scale9Grid = CALLOUT_SCALE_9_GRID;
         param1.backgroundSkin = _loc5_;
         var _loc3_:Image = new Image(this.calloutTopArrowSkinTexture);
         param1.topArrowSkin = _loc3_;
         param1.topArrowGap = this.calloutArrowOverlapGap;
         var _loc6_:Image = new Image(this.calloutRightArrowSkinTexture);
         param1.rightArrowSkin = _loc6_;
         param1.rightArrowGap = this.calloutArrowOverlapGap - this.leftAndRightDropShadowSize;
         var _loc4_:Image = new Image(this.calloutBottomArrowSkinTexture);
         param1.bottomArrowSkin = _loc4_;
         param1.bottomArrowGap = this.calloutArrowOverlapGap - this.bottomDropShadowSize;
         var _loc2_:Image = new Image(this.calloutLeftArrowSkinTexture);
         param1.leftArrowSkin = _loc2_;
         param1.leftArrowGap = this.calloutArrowOverlapGap - this.leftAndRightDropShadowSize;
         param1.paddingTop = this.smallGutterSize;
         param1.paddingBottom = this.smallGutterSize + this.bottomDropShadowSize;
         param1.paddingRight = this.gutterSize + this.leftAndRightDropShadowSize;
         param1.paddingLeft = this.gutterSize + this.leftAndRightDropShadowSize;
      }
      
      protected function setDangerCalloutStyles(param1:Callout) : void
      {
         var _loc5_:Image;
         (_loc5_ = new Image(this.dangerCalloutBackgroundSkinTexture)).scale9Grid = CALLOUT_SCALE_9_GRID;
         param1.backgroundSkin = _loc5_;
         var _loc3_:Image = new Image(this.dangerCalloutTopArrowSkinTexture);
         param1.topArrowSkin = _loc3_;
         param1.topArrowGap = this.calloutArrowOverlapGap;
         var _loc6_:Image = new Image(this.dangerCalloutRightArrowSkinTexture);
         param1.rightArrowSkin = _loc6_;
         param1.rightArrowGap = this.calloutArrowOverlapGap - this.leftAndRightDropShadowSize;
         var _loc4_:Image = new Image(this.dangerCalloutBottomArrowSkinTexture);
         param1.bottomArrowSkin = _loc4_;
         param1.bottomArrowGap = this.calloutArrowOverlapGap - this.bottomDropShadowSize;
         var _loc2_:Image = new Image(this.dangerCalloutLeftArrowSkinTexture);
         param1.leftArrowSkin = _loc2_;
         param1.leftArrowGap = this.calloutArrowOverlapGap - this.leftAndRightDropShadowSize;
         param1.paddingTop = this.smallGutterSize;
         param1.paddingBottom = this.smallGutterSize + this.bottomDropShadowSize;
         param1.paddingRight = this.gutterSize + this.leftAndRightDropShadowSize;
         param1.paddingLeft = this.gutterSize + this.leftAndRightDropShadowSize;
      }
      
      protected function setCheckStyles(param1:Check) : void
      {
         var _loc3_:ImageSkin = new ImageSkin(this.checkUpIconTexture);
         _loc3_.selectedTexture = this.checkSelectedUpIconTexture;
         _loc3_.setTextureForState("hover",this.checkHoverIconTexture);
         _loc3_.setTextureForState("down",this.checkDownIconTexture);
         _loc3_.setTextureForState("disabled",this.checkDisabledIconTexture);
         _loc3_.setTextureForState("hoverAndSelected",this.checkSelectedHoverIconTexture);
         _loc3_.setTextureForState("downAndSelected",this.checkSelectedDownIconTexture);
         _loc3_.setTextureForState("disabledAndSelected",this.checkSelectedDisabledIconTexture);
         param1.defaultIcon = _loc3_;
         var _loc2_:Image = new Image(this.focusIndicatorSkinTexture);
         _loc2_.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
         param1.focusIndicatorSkin = _loc2_;
         param1.focusPadding = -2;
         param1.horizontalAlign = "left";
         param1.verticalAlign = "middle";
         param1.gap = this.smallGutterSize;
         param1.minWidth = this.controlSize;
         param1.minHeight = this.controlSize;
      }
      
      protected function setCheckLabelStyles(param1:TextFieldTextRenderer) : void
      {
         param1.textFormat = this.defaultTextFormat;
         param1.disabledTextFormat = this.disabledTextFormat;
      }
      
      protected function setDateTimeSpinnerListStyles(param1:SpinnerList) : void
      {
         this.setSpinnerListStyles(param1);
         param1.customItemRendererStyleName = "aeon-date-time-spinner-list-item-renderer";
      }
      
      protected function setDateTimeSpinnerListItemRendererStyles(param1:DefaultListItemRenderer) : void
      {
         this.setItemRendererStyles(param1);
         param1.accessoryPosition = "left";
         param1.accessoryGap = this.smallGutterSize;
      }
      
      protected function setDrawersStyles(param1:Drawers) : void
      {
         var _loc2_:Quad = new Quad(10,10,14540253);
         _loc2_.alpha = 0.5;
         param1.overlaySkin = _loc2_;
      }
      
      protected function setGroupedListStyles(param1:GroupedList) : void
      {
         this.setScrollerStyles(param1);
         param1.verticalScrollPolicy = "auto";
         var _loc2_:Image = new Image(this.simpleBorderBackgroundSkinTexture);
         _loc2_.scale9Grid = SIMPLE_BORDER_SCALE_9_GRID;
         param1.backgroundSkin = _loc2_;
         param1.padding = this.borderSize;
      }
      
      protected function setGroupedListHeaderOrFooterRendererStyles(param1:DefaultGroupedListHeaderOrFooterRenderer) : void
      {
         var _loc2_:Image = new Image(this.groupedListHeaderBackgroundSkinTexture);
         _loc2_.scale9Grid = HEADER_SCALE_9_GRID;
         _loc2_.height = this.controlSize;
         param1.backgroundSkin = _loc2_;
         param1.paddingTop = this.extraSmallGutterSize;
         param1.paddingBottom = this.extraSmallGutterSize;
         param1.paddingRight = this.smallGutterSize;
         param1.paddingLeft = this.smallGutterSize;
         param1.minWidth = this.controlSize;
         param1.minHeight = this.controlSize;
      }
      
      protected function setGroupedListHeaderOrFooterRendererContentLabelStyles(param1:TextFieldTextRenderer) : void
      {
         param1.textFormat = this.defaultTextFormat;
         param1.disabledTextFormat = this.disabledTextFormat;
      }
      
      protected function setInsetGroupedListStyles(param1:GroupedList) : void
      {
         this.setScrollerStyles(param1);
         param1.verticalScrollPolicy = "auto";
         var _loc3_:Image = new Image(this.insetBorderBackgroundSkinTexture);
         _loc3_.scale9Grid = SIMPLE_BORDER_SCALE_9_GRID;
         param1.backgroundSkin = _loc3_;
         param1.padding = this.borderSize;
         param1.customItemRendererStyleName = "feathers-grouped-list-inset-item-renderer";
         param1.customHeaderRendererStyleName = "feathers-grouped-list-inset-header-renderer";
         param1.customFooterRendererStyleName = "feathers-grouped-list-inset-footer-renderer";
         var _loc2_:VerticalLayout = new VerticalLayout();
         _loc2_.useVirtualLayout = true;
         _loc2_.paddingTop = this.gutterSize;
         _loc2_.paddingBottom = this.gutterSize;
         _loc2_.gap = 0;
         _loc2_.horizontalAlign = "justify";
         _loc2_.verticalAlign = "top";
         param1.layout = _loc2_;
      }
      
      protected function setInsetGroupedListItemRendererStyles(param1:BaseDefaultItemRenderer) : void
      {
         var _loc2_:ImageSkin = new ImageSkin(this.itemRendererUpSkinTexture);
         _loc2_.selectedTexture = this.itemRendererSelectedUpSkinTexture;
         _loc2_.setTextureForState("hover",this.itemRendererHoverSkinTexture);
         _loc2_.setTextureForState("down",this.itemRendererSelectedUpSkinTexture);
         param1.defaultSkin = _loc2_;
         param1.horizontalAlign = "left";
         param1.iconPosition = "left";
         param1.accessoryPosition = "right";
         param1.paddingTop = this.extraSmallGutterSize;
         param1.paddingBottom = this.extraSmallGutterSize;
         param1.paddingRight = this.gutterSize;
         param1.paddingLeft = this.gutterSize;
         param1.gap = this.extraSmallGutterSize;
         param1.minGap = this.extraSmallGutterSize;
         param1.accessoryGap = Infinity;
         param1.minAccessoryGap = this.smallGutterSize;
         param1.minWidth = this.controlSize;
         param1.minHeight = this.controlSize;
         param1.useStateDelayTimer = false;
      }
      
      protected function setInsetGroupedListHeaderRendererStyles(param1:DefaultGroupedListHeaderOrFooterRenderer) : void
      {
         param1.paddingTop = this.gutterSize;
         param1.paddingBottom = this.smallGutterSize;
         param1.paddingRight = this.gutterSize;
         param1.paddingLeft = this.gutterSize;
         param1.minWidth = this.controlSize;
         param1.minHeight = this.controlSize;
      }
      
      protected function setInsetGroupedListFooterRendererStyles(param1:DefaultGroupedListHeaderOrFooterRenderer) : void
      {
         param1.paddingTop = this.smallGutterSize;
         param1.paddingBottom = this.smallGutterSize;
         param1.paddingRight = this.gutterSize;
         param1.paddingLeft = this.gutterSize;
         param1.minWidth = this.controlSize;
         param1.minHeight = this.controlSize;
      }
      
      protected function setHeaderStyles(param1:Header) : void
      {
         var _loc2_:Image = new Image(this.headerBackgroundSkinTexture);
         _loc2_.scale9Grid = HEADER_SCALE_9_GRID;
         param1.backgroundSkin = _loc2_;
         param1.minWidth = this.gridSize;
         param1.minHeight = this.gridSize;
         param1.paddingTop = this.extraSmallGutterSize;
         param1.paddingBottom = this.extraSmallGutterSize + this.borderSize;
         param1.paddingLeft = this.smallGutterSize;
         param1.paddingRight = this.smallGutterSize;
         param1.gap = this.extraSmallGutterSize;
         param1.titleGap = this.gutterSize;
      }
      
      protected function setHeaderTitleStyles(param1:TextFieldTextRenderer) : void
      {
         param1.textFormat = this.defaultTextFormat;
         param1.disabledTextFormat = this.disabledTextFormat;
      }
      
      protected function setLabelTextRendererStyles(param1:TextFieldTextRenderer) : void
      {
         param1.textFormat = this.defaultTextFormat;
         param1.disabledTextFormat = this.disabledTextFormat;
      }
      
      protected function setHeadingLabelStyles(param1:Label) : void
      {
         param1.customTextRendererStyleName = "aeon-heading-label-text-renderer";
      }
      
      protected function setHeadingLabelTextRendererStyles(param1:TextFieldTextRenderer) : void
      {
         param1.textFormat = this.headingTextFormat;
         param1.disabledTextFormat = this.headingDisabledTextFormat;
      }
      
      protected function setDetailLabelStyles(param1:Label) : void
      {
         param1.customTextRendererStyleName = "aeon-detail-label-text-renderer";
      }
      
      protected function setDetailLabelTextRendererStyles(param1:TextFieldTextRenderer) : void
      {
         param1.textFormat = this.detailTextFormat;
         param1.disabledTextFormat = this.detailDisabledTextFormat;
      }
      
      protected function setToolTipLabelStyles(param1:Label) : void
      {
         var _loc2_:Image = new Image(this.toolTipBackgroundSkinTexture);
         _loc2_.scale9Grid = TOOL_TIP_SCALE_9_GRID;
         param1.backgroundSkin = _loc2_;
         param1.customTextRendererStyleName = "aeon-tool-tip-label-text-renderer";
         param1.paddingTop = this.extraSmallGutterSize;
         param1.paddingRight = this.smallGutterSize + this.leftAndRightDropShadowSize;
         param1.paddingBottom = this.extraSmallGutterSize + this.bottomDropShadowSize;
         param1.paddingLeft = this.smallGutterSize + this.leftAndRightDropShadowSize;
      }
      
      protected function setToolTipLabelTextRendererStyles(param1:TextFieldTextRenderer) : void
      {
         param1.textFormat = this.defaultTextFormat;
         param1.disabledTextFormat = this.disabledTextFormat;
      }
      
      protected function setToolbarLayoutGroupStyles(param1:LayoutGroup) : void
      {
         var _loc2_:HorizontalLayout = null;
         if(!param1.layout)
         {
            _loc2_ = new HorizontalLayout();
            _loc2_.paddingTop = this.extraSmallGutterSize;
            _loc2_.paddingBottom = this.extraSmallGutterSize;
            _loc2_.paddingRight = this.smallGutterSize;
            _loc2_.paddingLeft = this.smallGutterSize;
            _loc2_.gap = this.smallGutterSize;
            _loc2_.verticalAlign = "middle";
            param1.layout = _loc2_;
         }
         param1.minHeight = this.gridSize;
         var _loc3_:Image = new Image(this.headerBackgroundSkinTexture);
         _loc3_.scale9Grid = HEADER_SCALE_9_GRID;
         param1.backgroundSkin = _loc3_;
      }
      
      protected function setListStyles(param1:List) : void
      {
         this.setScrollerStyles(param1);
         param1.verticalScrollPolicy = "auto";
         var _loc2_:Image = new Image(this.simpleBorderBackgroundSkinTexture);
         _loc2_.scale9Grid = SIMPLE_BORDER_SCALE_9_GRID;
         param1.backgroundSkin = _loc2_;
         param1.padding = this.borderSize;
      }
      
      protected function setItemRendererStyles(param1:BaseDefaultItemRenderer) : void
      {
         var _loc2_:ImageSkin = new ImageSkin(this.itemRendererUpSkinTexture);
         _loc2_.selectedTexture = this.itemRendererSelectedUpSkinTexture;
         _loc2_.setTextureForState("hover",this.itemRendererHoverSkinTexture);
         _loc2_.setTextureForState("down",this.itemRendererSelectedUpSkinTexture);
         param1.defaultSkin = _loc2_;
         param1.horizontalAlign = "left";
         param1.iconPosition = "left";
         param1.accessoryPosition = "right";
         param1.paddingTop = this.extraSmallGutterSize;
         param1.paddingBottom = this.extraSmallGutterSize;
         param1.paddingRight = this.smallGutterSize;
         param1.paddingLeft = this.smallGutterSize;
         param1.gap = this.extraSmallGutterSize;
         param1.minGap = this.extraSmallGutterSize;
         param1.accessoryGap = Infinity;
         param1.minAccessoryGap = this.smallGutterSize;
         param1.minWidth = this.controlSize;
         param1.minHeight = this.controlSize;
         param1.useStateDelayTimer = false;
      }
      
      protected function setDrillDownItemRendererStyles(param1:BaseDefaultItemRenderer) : void
      {
         this.setItemRendererStyles(param1);
         param1.itemHasAccessory = false;
         var _loc2_:ImageLoader = new ImageLoader();
         _loc2_.source = this.listDrillDownAccessoryTexture;
         param1.defaultAccessory = _loc2_;
      }
      
      protected function setCheckItemRendererStyles(param1:BaseDefaultItemRenderer) : void
      {
         param1.defaultSkin = new Image(this.itemRendererUpSkinTexture);
         param1.itemHasIcon = false;
         var _loc2_:ImageSkin = new ImageSkin(this.checkUpIconTexture);
         _loc2_.selectedTexture = this.checkSelectedUpIconTexture;
         _loc2_.setTextureForState("hover",this.checkHoverIconTexture);
         _loc2_.setTextureForState("down",this.checkDownIconTexture);
         _loc2_.setTextureForState("disabled",this.checkDisabledIconTexture);
         _loc2_.setTextureForState("hoverAndSelected",this.checkSelectedHoverIconTexture);
         _loc2_.setTextureForState("downAndSelected",this.checkSelectedDownIconTexture);
         _loc2_.setTextureForState("disabledAndSelected",this.checkSelectedDisabledIconTexture);
         param1.defaultIcon = _loc2_;
         param1.horizontalAlign = "left";
         param1.iconPosition = "left";
         param1.accessoryPosition = "right";
         param1.paddingTop = this.extraSmallGutterSize;
         param1.paddingBottom = this.extraSmallGutterSize;
         param1.paddingRight = this.smallGutterSize;
         param1.paddingLeft = this.smallGutterSize;
         param1.gap = this.smallGutterSize;
         param1.minGap = this.smallGutterSize;
         param1.accessoryGap = Infinity;
         param1.minAccessoryGap = this.smallGutterSize;
         param1.minWidth = this.controlSize;
         param1.minHeight = this.controlSize;
         param1.useStateDelayTimer = false;
      }
      
      protected function setItemRendererLabelStyles(param1:TextFieldTextRenderer) : void
      {
         param1.textFormat = this.defaultTextFormat;
         param1.disabledTextFormat = this.disabledTextFormat;
      }
      
      protected function setItemRendererAccessoryLabelStyles(param1:TextFieldTextRenderer) : void
      {
         param1.textFormat = this.defaultTextFormat;
         param1.disabledTextFormat = this.disabledTextFormat;
      }
      
      protected function setItemRendererIconLabelStyles(param1:TextFieldTextRenderer) : void
      {
         param1.textFormat = this.defaultTextFormat;
         param1.disabledTextFormat = this.disabledTextFormat;
      }
      
      protected function setNumericStepperStyles(param1:NumericStepper) : void
      {
         param1.buttonLayoutMode = "rightSideVertical";
         var _loc2_:Image = new Image(this.focusIndicatorSkinTexture);
         _loc2_.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
         param1.focusIndicatorSkin = _loc2_;
         param1.focusPadding = -1;
      }
      
      protected function setNumericStepperIncrementButtonStyles(param1:Button) : void
      {
         var _loc2_:ImageSkin = new ImageSkin(this.stepperIncrementButtonUpSkinTexture);
         _loc2_.setTextureForState("hover",this.stepperIncrementButtonHoverSkinTexture);
         _loc2_.setTextureForState("down",this.stepperIncrementButtonDownSkinTexture);
         _loc2_.setTextureForState("disabled",this.stepperIncrementButtonDisabledSkinTexture);
         _loc2_.scale9Grid = STEPPER_INCREMENT_BUTTON_SCALE_9_GRID;
         param1.defaultSkin = _loc2_;
         param1.keepDownStateOnRollOut = true;
         param1.hasLabelTextRenderer = false;
      }
      
      protected function setNumericStepperDecrementButtonStyles(param1:Button) : void
      {
         var _loc2_:ImageSkin = new ImageSkin(this.stepperDecrementButtonUpSkinTexture);
         _loc2_.setTextureForState("hover",this.stepperDecrementButtonHoverSkinTexture);
         _loc2_.setTextureForState("down",this.stepperDecrementButtonDownSkinTexture);
         _loc2_.setTextureForState("disabled",this.stepperDecrementButtonDisabledSkinTexture);
         _loc2_.scale9Grid = STEPPER_DECREMENT_BUTTON_SCALE_9_GRID;
         param1.defaultSkin = _loc2_;
         param1.keepDownStateOnRollOut = true;
         param1.hasLabelTextRenderer = false;
      }
      
      protected function setNumericStepperTextInputStyles(param1:TextInput) : void
      {
         param1.minWidth = this.controlSize;
         param1.minHeight = this.controlSize;
         param1.gap = this.extraSmallGutterSize;
         param1.paddingTop = this.extraSmallGutterSize;
         param1.paddingBottom = this.extraSmallGutterSize;
         param1.paddingRight = this.smallGutterSize;
         param1.paddingLeft = this.smallGutterSize;
         var _loc2_:ImageSkin = new ImageSkin(this.textInputBackgroundEnabledSkinTexture);
         _loc2_.disabledTexture = this.textInputBackgroundDisabledSkinTexture;
         _loc2_.scale9Grid = TEXT_INPUT_SCALE_9_GRID;
         _loc2_.width = this.controlSize;
         _loc2_.height = this.controlSize;
         param1.backgroundSkin = _loc2_;
      }
      
      protected function setPanelScreenStyles(param1:PanelScreen) : void
      {
         this.setScrollerStyles(param1);
      }
      
      protected function setPageIndicatorStyles(param1:PageIndicator) : void
      {
         param1.interactionMode = "precise";
         param1.normalSymbolFactory = this.pageIndicatorNormalSymbolFactory;
         param1.selectedSymbolFactory = this.pageIndicatorSelectedSymbolFactory;
         param1.gap = this.gutterSize;
         param1.padding = this.smallGutterSize;
         param1.minWidth = this.controlSize;
         param1.minHeight = this.controlSize;
      }
      
      protected function setPanelStyles(param1:Panel) : void
      {
         this.setScrollerStyles(param1);
         var _loc2_:Image = new Image(this.panelBorderBackgroundSkinTexture);
         _loc2_.scale9Grid = PANEL_BORDER_SCALE_9_GRID;
         param1.backgroundSkin = _loc2_;
         param1.paddingTop = 0;
         param1.paddingRight = this.gutterSize;
         param1.paddingBottom = this.gutterSize;
         param1.paddingLeft = this.gutterSize;
      }
      
      protected function setPanelHeaderStyles(param1:Header) : void
      {
         param1.minHeight = this.gridSize;
         param1.paddingTop = this.extraSmallGutterSize;
         param1.paddingBottom = this.extraSmallGutterSize;
         param1.paddingLeft = this.gutterSize;
         param1.paddingRight = this.gutterSize;
         param1.gap = this.extraSmallGutterSize;
         param1.titleGap = this.smallGutterSize;
      }
      
      protected function setPickerListStyles(param1:PickerList) : void
      {
         param1.popUpContentManager = new DropDownPopUpContentManager();
      }
      
      protected function setPickerListButtonStyles(param1:Button) : void
      {
         this.setButtonStyles(param1);
         var _loc2_:ImageSkin = new ImageSkin(this.pickerListUpIconTexture);
         _loc2_.setTextureForState("hover",this.pickerListHoverIconTexture);
         _loc2_.setTextureForState("down",this.pickerListDownIconTexture);
         _loc2_.setTextureForState("disabled",this.pickerListDisabledIconTexture);
         param1.defaultIcon = _loc2_;
         param1.gap = Infinity;
         param1.minGap = this.smallGutterSize;
         param1.horizontalAlign = "left";
         param1.iconPosition = "right";
         param1.paddingRight = this.smallGutterSize;
      }
      
      protected function setProgressBarStyles(param1:ProgressBar) : void
      {
         var _loc3_:Image = new Image(this.simpleBorderBackgroundSkinTexture);
         _loc3_.scale9Grid = SIMPLE_BORDER_SCALE_9_GRID;
         if(param1.direction == "vertical")
         {
            _loc3_.height = this.wideControlSize;
         }
         else
         {
            _loc3_.width = this.wideControlSize;
         }
         param1.backgroundSkin = _loc3_;
         var _loc2_:Image = new Image(this.progressBarFillSkinTexture);
         if(param1.direction == "vertical")
         {
            _loc2_.height = 0;
         }
         else
         {
            _loc2_.width = 0;
         }
         param1.fillSkin = _loc2_;
         param1.padding = this.borderSize;
      }
      
      protected function setRadioStyles(param1:Radio) : void
      {
         var _loc3_:ImageSkin = new ImageSkin(this.radioUpIconTexture);
         _loc3_.selectedTexture = this.radioSelectedUpIconTexture;
         _loc3_.setTextureForState("hover",this.radioHoverIconTexture);
         _loc3_.setTextureForState("down",this.radioDownIconTexture);
         _loc3_.setTextureForState("disabled",this.radioDisabledIconTexture);
         _loc3_.setTextureForState("hoverAndSelected",this.radioSelectedHoverIconTexture);
         _loc3_.setTextureForState("downAndSelected",this.radioSelectedDownIconTexture);
         _loc3_.setTextureForState("disabledAndSelected",this.radioSelectedDisabledIconTexture);
         param1.defaultIcon = _loc3_;
         var _loc2_:Image = new Image(this.focusIndicatorSkinTexture);
         _loc2_.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
         param1.focusIndicatorSkin = _loc2_;
         param1.focusPadding = -2;
         param1.horizontalAlign = "left";
         param1.verticalAlign = "middle";
         param1.gap = this.smallGutterSize;
         param1.minWidth = this.controlSize;
         param1.minHeight = this.controlSize;
      }
      
      protected function setRadioLabelStyles(param1:TextFieldTextRenderer) : void
      {
         param1.textFormat = this.defaultTextFormat;
         param1.disabledTextFormat = this.disabledTextFormat;
      }
      
      protected function setHorizontalScrollBarStyles(param1:ScrollBar) : void
      {
         param1.trackLayoutMode = "single";
         param1.customIncrementButtonStyleName = "aeon-horizontal-scroll-bar-increment-button";
         param1.customDecrementButtonStyleName = "aeon-horizontal-scroll-bar-decrement-button";
         param1.customThumbStyleName = "aeon-horizontal-scroll-bar-thumb";
         param1.customMinimumTrackStyleName = "aeon-horizontal-scroll-bar-minimum-track";
      }
      
      protected function setVerticalScrollBarStyles(param1:ScrollBar) : void
      {
         param1.trackLayoutMode = "single";
         param1.customIncrementButtonStyleName = "aeon-vertical-scroll-bar-increment-button";
         param1.customDecrementButtonStyleName = "aeon-vertical-scroll-bar-decrement-button";
         param1.customThumbStyleName = "aeon-vertical-scroll-bar-thumb";
         param1.customMinimumTrackStyleName = "aeon-vertical-scroll-bar-minimum-track";
      }
      
      protected function setHorizontalScrollBarIncrementButtonStyles(param1:Button) : void
      {
         var _loc2_:ImageSkin = new ImageSkin(this.hScrollBarStepButtonUpSkinTexture);
         _loc2_.setTextureForState("hover",this.hScrollBarStepButtonHoverSkinTexture);
         _loc2_.setTextureForState("down",this.hScrollBarStepButtonDownSkinTexture);
         _loc2_.setTextureForState("disabled",this.hScrollBarStepButtonDisabledSkinTexture);
         _loc2_.scale9Grid = HORIZONTAL_SCROLL_BAR_STEP_BUTTON_SCALE_9_GRID;
         param1.defaultSkin = _loc2_;
         param1.defaultIcon = new Image(this.hScrollBarIncrementButtonIconTexture);
         var _loc3_:Quad = new Quad(1,1,16711935);
         _loc3_.alpha = 0;
         param1.disabledIcon = _loc3_;
         param1.hasLabelTextRenderer = false;
      }
      
      protected function setHorizontalScrollBarDecrementButtonStyles(param1:Button) : void
      {
         var _loc2_:ImageSkin = new ImageSkin(hScrollBarStepButtonUpSkinTexture);
         _loc2_.setTextureForState("hover",this.hScrollBarStepButtonHoverSkinTexture);
         _loc2_.setTextureForState("down",this.hScrollBarStepButtonDownSkinTexture);
         _loc2_.setTextureForState("disabled",this.hScrollBarStepButtonDisabledSkinTexture);
         _loc2_.scale9Grid = HORIZONTAL_SCROLL_BAR_STEP_BUTTON_SCALE_9_GRID;
         param1.defaultSkin = _loc2_;
         param1.defaultIcon = new Image(this.hScrollBarDecrementButtonIconTexture);
         var _loc3_:Quad = new Quad(1,1,16711935);
         _loc3_.alpha = 0;
         param1.disabledIcon = _loc3_;
         param1.hasLabelTextRenderer = false;
      }
      
      protected function setHorizontalScrollBarThumbStyles(param1:Button) : void
      {
         var _loc2_:ImageSkin = new ImageSkin(this.hScrollBarThumbUpSkinTexture);
         _loc2_.setTextureForState("hover",this.hScrollBarThumbHoverSkinTexture);
         _loc2_.setTextureForState("down",this.hScrollBarThumbDownSkinTexture);
         _loc2_.scale9Grid = HORIZONTAL_SCROLL_BAR_THUMB_SCALE_9_GRID;
         param1.defaultSkin = _loc2_;
         param1.defaultIcon = new Image(this.hScrollBarThumbIconTexture);
         param1.verticalAlign = "middle";
         param1.paddingBottom = this.extraSmallGutterSize;
         param1.hasLabelTextRenderer = false;
      }
      
      protected function setHorizontalScrollBarMinimumTrackStyles(param1:Button) : void
      {
         var _loc2_:Image = new Image(this.hScrollBarTrackSkinTexture);
         _loc2_.scale9Grid = HORIZONTAL_SCROLL_BAR_TRACK_SCALE_9_GRID;
         param1.defaultSkin = _loc2_;
         param1.hasLabelTextRenderer = false;
      }
      
      protected function setVerticalScrollBarIncrementButtonStyles(param1:Button) : void
      {
         var _loc2_:ImageSkin = new ImageSkin(this.vScrollBarStepButtonUpSkinTexture);
         _loc2_.setTextureForState("hover",this.vScrollBarStepButtonHoverSkinTexture);
         _loc2_.setTextureForState("down",this.vScrollBarStepButtonDownSkinTexture);
         _loc2_.setTextureForState("disabled",this.vScrollBarStepButtonDisabledSkinTexture);
         _loc2_.scale9Grid = VERTICAL_SCROLL_BAR_STEP_BUTTON_SCALE_9_GRID;
         param1.defaultSkin = _loc2_;
         param1.defaultIcon = new Image(this.vScrollBarIncrementButtonIconTexture);
         var _loc3_:Quad = new Quad(1,1,16711935);
         _loc3_.alpha = 0;
         param1.disabledIcon = _loc3_;
         param1.hasLabelTextRenderer = false;
      }
      
      protected function setVerticalScrollBarDecrementButtonStyles(param1:Button) : void
      {
         var _loc2_:ImageSkin = new ImageSkin(this.vScrollBarStepButtonUpSkinTexture);
         _loc2_.setTextureForState("hover",this.vScrollBarStepButtonHoverSkinTexture);
         _loc2_.setTextureForState("down",this.vScrollBarStepButtonDownSkinTexture);
         _loc2_.setTextureForState("disabled",this.vScrollBarStepButtonDisabledSkinTexture);
         _loc2_.scale9Grid = VERTICAL_SCROLL_BAR_STEP_BUTTON_SCALE_9_GRID;
         param1.defaultSkin = _loc2_;
         param1.defaultIcon = new Image(this.vScrollBarDecrementButtonIconTexture);
         var _loc3_:Quad = new Quad(1,1,16711935);
         _loc3_.alpha = 0;
         param1.disabledIcon = _loc3_;
         param1.hasLabelTextRenderer = false;
      }
      
      protected function setVerticalScrollBarThumbStyles(param1:Button) : void
      {
         var _loc2_:ImageSkin = new ImageSkin(this.vScrollBarThumbUpSkinTexture);
         _loc2_.setTextureForState("hover",this.vScrollBarThumbHoverSkinTexture);
         _loc2_.setTextureForState("down",this.vScrollBarThumbDownSkinTexture);
         _loc2_.scale9Grid = VERTICAL_SCROLL_BAR_THUMB_SCALE_9_GRID;
         param1.defaultSkin = _loc2_;
         param1.defaultIcon = new Image(this.vScrollBarThumbIconTexture);
         param1.horizontalAlign = "center";
         param1.paddingRight = this.extraSmallGutterSize;
         param1.hasLabelTextRenderer = false;
      }
      
      protected function setVerticalScrollBarMinimumTrackStyles(param1:Button) : void
      {
         var _loc2_:Image = new Image(this.vScrollBarTrackSkinTexture);
         _loc2_.scale9Grid = VERTICAL_SCROLL_BAR_TRACK_SCALE_9_GRID;
         param1.defaultSkin = _loc2_;
         param1.hasLabelTextRenderer = false;
      }
      
      protected function setScrollContainerStyles(param1:ScrollContainer) : void
      {
         this.setScrollerStyles(param1);
      }
      
      protected function setToolbarScrollContainerStyles(param1:ScrollContainer) : void
      {
         var _loc2_:HorizontalLayout = null;
         this.setScrollerStyles(param1);
         if(!param1.layout)
         {
            _loc2_ = new HorizontalLayout();
            _loc2_.paddingTop = this.extraSmallGutterSize;
            _loc2_.paddingBottom = this.extraSmallGutterSize;
            _loc2_.paddingRight = this.smallGutterSize;
            _loc2_.paddingLeft = this.smallGutterSize;
            _loc2_.gap = this.extraSmallGutterSize;
            _loc2_.verticalAlign = "middle";
            param1.layout = _loc2_;
         }
         var _loc3_:Image = new Image(this.headerBackgroundSkinTexture);
         _loc3_.scale9Grid = HEADER_SCALE_9_GRID;
         param1.backgroundSkin = _loc3_;
         param1.minHeight = this.gridSize;
      }
      
      protected function setScrollScreenStyles(param1:ScrollScreen) : void
      {
         this.setScrollerStyles(param1);
      }
      
      protected function setScrollTextStyles(param1:ScrollText) : void
      {
         this.setScrollerStyles(param1);
         param1.textFormat = this.defaultTextFormat;
         param1.disabledTextFormat = this.disabledTextFormat;
         param1.padding = this.gutterSize;
      }
      
      protected function setHorizontalSimpleScrollBarStyles(param1:SimpleScrollBar) : void
      {
         param1.customThumbStyleName = "aeon-horizontal-simple-scroll-bar-thumb";
      }
      
      protected function setVerticalSimpleScrollBarStyles(param1:SimpleScrollBar) : void
      {
         param1.customThumbStyleName = "aeon-vertical-simple-scroll-bar-thumb";
      }
      
      protected function setHorizontalSimpleScrollBarThumbStyles(param1:Button) : void
      {
         var _loc2_:ImageSkin = new ImageSkin(this.hScrollBarThumbUpSkinTexture);
         _loc2_.setTextureForState("hover",this.hScrollBarThumbHoverSkinTexture);
         _loc2_.setTextureForState("down",this.hScrollBarThumbDownSkinTexture);
         _loc2_.scale9Grid = HORIZONTAL_SCROLL_BAR_THUMB_SCALE_9_GRID;
         param1.defaultSkin = _loc2_;
         param1.defaultIcon = new Image(this.hScrollBarThumbIconTexture);
         param1.verticalAlign = "top";
         param1.paddingTop = this.smallGutterSize;
         param1.hasLabelTextRenderer = false;
      }
      
      protected function setVerticalSimpleScrollBarThumbStyles(param1:Button) : void
      {
         var _loc2_:ImageSkin = new ImageSkin(this.vScrollBarThumbUpSkinTexture);
         _loc2_.setTextureForState("hover",this.vScrollBarThumbHoverSkinTexture);
         _loc2_.setTextureForState("down",this.vScrollBarThumbDownSkinTexture);
         _loc2_.scale9Grid = VERTICAL_SCROLL_BAR_THUMB_SCALE_9_GRID;
         param1.defaultSkin = _loc2_;
         param1.defaultIcon = new Image(this.vScrollBarThumbIconTexture);
         param1.horizontalAlign = "left";
         param1.paddingLeft = this.smallGutterSize;
         param1.hasLabelTextRenderer = false;
      }
      
      protected function setSliderStyles(param1:Slider) : void
      {
         param1.trackLayoutMode = "single";
         param1.minimumPadding = param1.maximumPadding = -vSliderThumbUpSkinTexture.height / 2;
         if(param1.direction == "vertical")
         {
            param1.customThumbStyleName = "aeon-vertical-slider-thumb";
            param1.customMinimumTrackStyleName = "aeon-vertical-slider-minimum-track";
            param1.focusPaddingLeft = param1.focusPaddingRight = -2;
            param1.focusPaddingTop = param1.focusPaddingBottom = -2 + param1.minimumPadding;
         }
         else
         {
            param1.customThumbStyleName = "aeon-horizontal-slider-thumb";
            param1.customMinimumTrackStyleName = "aeon-horizontal-slider-minimum-track";
            param1.focusPaddingTop = param1.focusPaddingBottom = -2;
            param1.focusPaddingLeft = param1.focusPaddingRight = -2 + param1.minimumPadding;
         }
         var _loc2_:Image = new Image(this.focusIndicatorSkinTexture);
         _loc2_.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
         param1.focusIndicatorSkin = _loc2_;
      }
      
      protected function setHorizontalSliderThumbStyles(param1:Button) : void
      {
         var _loc2_:ImageSkin = new ImageSkin(this.hSliderThumbUpSkinTexture);
         _loc2_.setTextureForState("hover",this.hSliderThumbHoverSkinTexture);
         _loc2_.setTextureForState("down",this.hSliderThumbDownSkinTexture);
         _loc2_.setTextureForState("disabled",this.hSliderThumbDisabledSkinTexture);
         param1.defaultSkin = _loc2_;
         param1.hasLabelTextRenderer = false;
      }
      
      protected function setHorizontalSliderMinimumTrackStyles(param1:Button) : void
      {
         var _loc2_:Image = new Image(this.hSliderTrackEnabledSkinTexture);
         _loc2_.scale9Grid = HORIZONTAL_SLIDER_TRACK_SCALE_9_GRID;
         _loc2_.width = this.wideControlSize;
         param1.defaultSkin = _loc2_;
         param1.minTouchHeight = this.controlSize;
         param1.hasLabelTextRenderer = false;
      }
      
      protected function setVerticalSliderThumbStyles(param1:Button) : void
      {
         var _loc2_:ImageSkin = new ImageSkin(this.vSliderThumbUpSkinTexture);
         _loc2_.setTextureForState("hover",this.vSliderThumbHoverSkinTexture);
         _loc2_.setTextureForState("down",this.vSliderThumbDownSkinTexture);
         _loc2_.setTextureForState("disabled",this.vSliderThumbDisabledSkinTexture);
         param1.defaultSkin = _loc2_;
         param1.hasLabelTextRenderer = false;
      }
      
      protected function setVerticalSliderMinimumTrackStyles(param1:Button) : void
      {
         var _loc2_:Image = new Image(this.vSliderTrackEnabledSkinTexture);
         _loc2_.scale9Grid = VERTICAL_SLIDER_TRACK_SCALE_9_GRID;
         _loc2_.height = this.wideControlSize;
         param1.defaultSkin = _loc2_;
         param1.minTouchWidth = this.controlSize;
         param1.hasLabelTextRenderer = false;
      }
      
      protected function setSpinnerListStyles(param1:SpinnerList) : void
      {
         this.setListStyles(param1);
      }
      
      protected function setTabBarStyles(param1:TabBar) : void
      {
         param1.distributeTabSizes = false;
         param1.horizontalAlign = "left";
         param1.verticalAlign = "justify";
      }
      
      protected function setTabStyles(param1:ToggleButton) : void
      {
         var _loc3_:ImageSkin = new ImageSkin(this.tabUpSkinTexture);
         _loc3_.selectedTexture = this.tabSelectedUpSkinTexture;
         _loc3_.setTextureForState("hover",this.tabHoverSkinTexture);
         _loc3_.setTextureForState("down",this.tabDownSkinTexture);
         _loc3_.setTextureForState("disabled",this.tabDisabledSkinTexture);
         _loc3_.setTextureForState("disabledAndSelected",this.tabSelectedDisabledSkinTexture);
         _loc3_.scale9Grid = TAB_SCALE_9_GRID;
         param1.defaultSkin = _loc3_;
         var _loc2_:Image = new Image(this.focusIndicatorSkinTexture);
         _loc2_.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
         param1.focusIndicatorSkin = _loc2_;
         param1.paddingTop = this.extraSmallGutterSize;
         param1.paddingBottom = this.extraSmallGutterSize;
         param1.paddingLeft = this.smallGutterSize;
         param1.paddingRight = this.smallGutterSize;
         param1.gap = this.extraSmallGutterSize;
         param1.minWidth = this.buttonMinWidth;
         param1.minHeight = this.controlSize;
      }
      
      protected function setTextAreaStyles(param1:TextArea) : void
      {
         this.setScrollerStyles(param1);
         param1.focusPadding = -2;
         param1.padding = this.borderSize;
         var _loc2_:ImageSkin = new ImageSkin(this.textInputBackgroundEnabledSkinTexture);
         _loc2_.disabledTexture = this.textInputBackgroundDisabledSkinTexture;
         _loc2_.setTextureForState("error",this.textInputBackgroundErrorSkinTexture);
         _loc2_.scale9Grid = TEXT_INPUT_SCALE_9_GRID;
         _loc2_.width = this.wideControlSize * 2;
         _loc2_.height = this.wideControlSize;
         param1.backgroundSkin = _loc2_;
      }
      
      protected function setTextAreaTextEditorStyles(param1:TextFieldTextEditorViewPort) : void
      {
         param1.textFormat = this.defaultTextFormat;
         param1.disabledTextFormat = this.disabledTextFormat;
         param1.paddingTop = this.extraSmallGutterSize;
         param1.paddingRight = this.smallGutterSize;
         param1.paddingBottom = this.extraSmallGutterSize;
         param1.paddingLeft = this.smallGutterSize;
      }
      
      protected function setTextAreaErrorCalloutStyles(param1:TextCallout) : void
      {
         this.setDangerTextCalloutStyles(param1);
         param1.verticalAlign = "top";
         param1.horizontalAlign = "left";
         param1.supportedPositions = new <String>["right","top","bottom","left"];
      }
      
      protected function setTextCalloutStyles(param1:TextCallout) : void
      {
         this.setCalloutStyles(param1);
      }
      
      protected function setTextCalloutTextRendererStyles(param1:TextFieldTextRenderer) : void
      {
         param1.textFormat = this.defaultTextFormat;
      }
      
      protected function setDangerTextCalloutStyles(param1:TextCallout) : void
      {
         this.setDangerCalloutStyles(param1);
         param1.customTextRendererStyleName = "aeon-danger-text-callout-text-renderer";
      }
      
      protected function setDangerTextCalloutTextRendererStyles(param1:TextFieldTextRenderer) : void
      {
         param1.textFormat = this.invertedTextFormat;
      }
      
      protected function setBaseTextInputStyles(param1:TextInput) : void
      {
         var _loc3_:ImageSkin = new ImageSkin(this.textInputBackgroundEnabledSkinTexture);
         _loc3_.disabledTexture = this.textInputBackgroundDisabledSkinTexture;
         _loc3_.setTextureForState("error",this.textInputBackgroundErrorSkinTexture);
         _loc3_.scale9Grid = TEXT_INPUT_SCALE_9_GRID;
         _loc3_.width = this.wideControlSize;
         _loc3_.height = this.controlSize;
         param1.backgroundSkin = _loc3_;
         var _loc2_:Image = new Image(this.focusIndicatorSkinTexture);
         _loc2_.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
         param1.focusIndicatorSkin = _loc2_;
         param1.focusPadding = -2;
         param1.minWidth = this.controlSize;
         param1.minHeight = this.controlSize;
         param1.gap = this.extraSmallGutterSize;
         param1.paddingTop = this.extraSmallGutterSize;
         param1.paddingBottom = this.extraSmallGutterSize;
         param1.paddingRight = this.smallGutterSize;
         param1.paddingLeft = this.smallGutterSize;
      }
      
      protected function setTextInputStyles(param1:TextInput) : void
      {
         this.setBaseTextInputStyles(param1);
      }
      
      protected function setSearchTextInputStyles(param1:TextInput) : void
      {
         this.setBaseTextInputStyles(param1);
         var _loc2_:ImageSkin = new ImageSkin(this.textInputSearchIconTexture);
         _loc2_.disabledTexture = this.textInputSearchIconDisabledTexture;
         param1.defaultIcon = _loc2_;
      }
      
      protected function setTextInputTextEditorStyles(param1:TextFieldTextEditor) : void
      {
         param1.textFormat = this.defaultTextFormat;
         param1.disabledTextFormat = this.disabledTextFormat;
      }
      
      protected function setTextInputPromptStyles(param1:TextFieldTextRenderer) : void
      {
         param1.textFormat = this.defaultTextFormat;
         param1.disabledTextFormat = this.disabledTextFormat;
      }
      
      protected function setTextInputErrorCalloutStyles(param1:TextCallout) : void
      {
         this.setDangerTextCalloutStyles(param1);
         param1.verticalAlign = "top";
         param1.horizontalAlign = "left";
         param1.supportedPositions = new <String>["right","top","bottom","left"];
      }
      
      protected function setToggleSwitchStyles(param1:ToggleSwitch) : void
      {
         param1.trackLayoutMode = "single";
         var _loc2_:Image = new Image(this.focusIndicatorSkinTexture);
         _loc2_.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
         param1.focusIndicatorSkin = _loc2_;
         param1.focusPadding = -1;
      }
      
      protected function setToggleSwitchOnLabelStyles(param1:TextFieldTextRenderer) : void
      {
         param1.textFormat = this.defaultTextFormat;
         param1.disabledTextFormat = this.disabledTextFormat;
      }
      
      protected function setToggleSwitchOffLabelStyles(param1:TextFieldTextRenderer) : void
      {
         param1.textFormat = this.defaultTextFormat;
         param1.disabledTextFormat = this.disabledTextFormat;
      }
      
      protected function setToggleSwitchOnTrackStyles(param1:Button) : void
      {
         var _loc2_:Image = new Image(this.toggleButtonSelectedUpSkinTexture);
         _loc2_.scale9Grid = BUTTON_SCALE_9_GRID;
         _loc2_.width = 2 * this.controlSize + this.smallControlSize;
         param1.defaultSkin = _loc2_;
         param1.hasLabelTextRenderer = false;
      }
      
      protected function setToggleSwitchThumbStyles(param1:Button) : void
      {
         this.setButtonStyles(param1);
         param1.width = this.controlSize;
         param1.height = this.controlSize;
         param1.hasLabelTextRenderer = false;
      }
      
      protected function setPlayPauseToggleButtonStyles(param1:PlayPauseToggleButton) : void
      {
         var _loc4_:Quad;
         (_loc4_ = new Quad(this.controlSize,this.controlSize,16711935)).alpha = 0;
         param1.defaultSkin = _loc4_;
         var _loc5_:ImageSkin;
         (_loc5_ = new ImageSkin(null)).setTextureForState("hover",this.quietButtonHoverSkinTexture);
         _loc5_.setTextureForState("down",this.buttonDownSkinTexture);
         _loc5_.setTextureForState("hoverAndSelected",this.toggleButtonSelectedHoverSkinTexture);
         _loc5_.setTextureForState("downAndSelected",this.toggleButtonSelectedDownSkinTexture);
         _loc5_.setTextureForState("disabledAndSelected",this.toggleButtonSelectedDisabledSkinTexture);
         _loc5_.width = this.controlSize;
         _loc5_.height = this.controlSize;
         param1.setSkinForState("hover",_loc5_);
         param1.setSkinForState("down",_loc5_);
         param1.setSkinForState("hoverAndSelected",_loc5_);
         param1.setSkinForState("downAndSelected",_loc5_);
         param1.setSkinForState("disabledAndSelected",_loc5_);
         var _loc2_:Image = new Image(this.focusIndicatorSkinTexture);
         _loc2_.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
         param1.focusIndicatorSkin = _loc2_;
         param1.focusPadding = -1;
         var _loc3_:ImageSkin = new ImageSkin(this.playPauseButtonPlayUpIconTexture);
         _loc3_.selectedTexture = this.playPauseButtonPauseUpIconTexture;
         param1.defaultIcon = _loc3_;
         param1.hasLabelTextRenderer = false;
         param1.paddingTop = this.extraSmallGutterSize;
         param1.paddingRight = this.smallGutterSize;
         param1.paddingBottom = this.extraSmallGutterSize;
         param1.paddingLeft = this.smallGutterSize;
         param1.gap = this.smallGutterSize;
         param1.minWidth = this.controlSize;
         param1.minHeight = this.controlSize;
      }
      
      protected function setOverlayPlayPauseToggleButtonStyles(param1:PlayPauseToggleButton) : void
      {
         var _loc2_:ImageSkin = new ImageSkin(null);
         _loc2_.setTextureForState("up",this.overlayPlayPauseButtonPlayUpIconTexture);
         _loc2_.setTextureForState("hover",this.overlayPlayPauseButtonPlayUpIconTexture);
         _loc2_.setTextureForState("down",this.overlayPlayPauseButtonPlayUpIconTexture);
         param1.defaultIcon = _loc2_;
         param1.isFocusEnabled = false;
         param1.hasLabelTextRenderer = false;
         var _loc3_:Quad = new Quad(1,1,13230318);
         _loc3_.alpha = 0.25;
         param1.upSkin = _loc3_;
         param1.hoverSkin = _loc3_;
      }
      
      protected function setFullScreenToggleButtonStyles(param1:FullScreenToggleButton) : void
      {
         var _loc4_:Quad;
         (_loc4_ = new Quad(this.controlSize,this.controlSize,16711935)).alpha = 0;
         param1.defaultSkin = _loc4_;
         var _loc5_:ImageSkin;
         (_loc5_ = new ImageSkin(null)).setTextureForState("hover",this.quietButtonHoverSkinTexture);
         _loc5_.setTextureForState("down",this.buttonDownSkinTexture);
         _loc5_.setTextureForState("hoverAndSelected",this.toggleButtonSelectedHoverSkinTexture);
         _loc5_.setTextureForState("downAndSelected",this.toggleButtonSelectedDownSkinTexture);
         _loc5_.setTextureForState("disabledAndSelected",this.toggleButtonSelectedDisabledSkinTexture);
         _loc5_.width = this.controlSize;
         _loc5_.height = this.controlSize;
         param1.setSkinForState("hover",_loc5_);
         param1.setSkinForState("down",_loc5_);
         param1.setSkinForState("hoverAndSelected",_loc5_);
         param1.setSkinForState("downAndSelected",_loc5_);
         param1.setSkinForState("disabledAndSelected",_loc5_);
         var _loc2_:Image = new Image(this.focusIndicatorSkinTexture);
         _loc2_.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
         param1.focusIndicatorSkin = _loc2_;
         param1.focusPadding = -1;
         var _loc3_:ImageSkin = new ImageSkin(this.fullScreenToggleButtonEnterUpIconTexture);
         _loc3_.selectedTexture = this.fullScreenToggleButtonExitUpIconTexture;
         param1.defaultIcon = _loc3_;
         param1.hasLabelTextRenderer = false;
         param1.paddingTop = this.extraSmallGutterSize;
         param1.paddingRight = this.smallGutterSize;
         param1.paddingBottom = this.extraSmallGutterSize;
         param1.paddingLeft = this.smallGutterSize;
         param1.gap = this.smallGutterSize;
         param1.minWidth = this.controlSize;
         param1.minHeight = this.controlSize;
      }
      
      protected function setVolumeSliderStyles(param1:VolumeSlider) : void
      {
         param1.trackLayoutMode = "split";
         var _loc2_:Image = new Image(this.focusIndicatorSkinTexture);
         _loc2_.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
         param1.focusIndicatorSkin = _loc2_;
         param1.focusPadding = -1;
         param1.showThumb = false;
         if(param1.direction == "vertical")
         {
            param1.customMinimumTrackStyleName = "aeon-vertical-volume-slider-minimum-track";
            param1.customMaximumTrackStyleName = "aeon-vertical-volume-slider-maximum-track";
            param1.width = this.verticalVolumeSliderMinimumTrackSkinTexture.width;
            param1.height = this.verticalVolumeSliderMinimumTrackSkinTexture.height;
         }
         else
         {
            param1.customMinimumTrackStyleName = "aeon-horizontal-volume-slider-minimum-track";
            param1.customMaximumTrackStyleName = "aeon-horizontal-volume-slider-maximum-track";
            param1.width = this.horizontalVolumeSliderMinimumTrackSkinTexture.width;
            param1.height = this.horizontalVolumeSliderMinimumTrackSkinTexture.height;
         }
      }
      
      protected function setVolumeSliderThumbStyles(param1:Button) : void
      {
         var _loc2_:Number = 6;
         param1.defaultSkin = new Quad(_loc2_,_loc2_);
         param1.defaultSkin.width = 0;
         param1.defaultSkin.height = 0;
         param1.hasLabelTextRenderer = false;
      }
      
      protected function setHorizontalVolumeSliderMinimumTrackStyles(param1:Button) : void
      {
         var _loc2_:ImageLoader = new ImageLoader();
         _loc2_.scaleContent = false;
         _loc2_.source = this.horizontalVolumeSliderMinimumTrackSkinTexture;
         param1.defaultSkin = _loc2_;
         param1.hasLabelTextRenderer = false;
      }
      
      protected function setHorizontalVolumeSliderMaximumTrackStyles(param1:Button) : void
      {
         var _loc2_:ImageLoader = new ImageLoader();
         _loc2_.scaleContent = false;
         _loc2_.horizontalAlign = "right";
         _loc2_.source = this.horizontalVolumeSliderMaximumTrackSkinTexture;
         param1.defaultSkin = _loc2_;
         param1.hasLabelTextRenderer = false;
      }
      
      protected function setVerticalVolumeSliderMinimumTrackStyles(param1:Button) : void
      {
         var _loc2_:ImageLoader = new ImageLoader();
         _loc2_.scaleContent = false;
         _loc2_.verticalAlign = "bottom";
         _loc2_.source = this.verticalVolumeSliderMinimumTrackSkinTexture;
         param1.defaultSkin = _loc2_;
         param1.hasLabelTextRenderer = false;
      }
      
      protected function setVerticalVolumeSliderMaximumTrackStyles(param1:Button) : void
      {
         var _loc2_:ImageLoader = new ImageLoader();
         _loc2_.scaleContent = false;
         _loc2_.source = this.verticalVolumeSliderMaximumTrackSkinTexture;
         param1.defaultSkin = _loc2_;
         param1.hasLabelTextRenderer = false;
      }
      
      protected function setMuteToggleButtonStyles(param1:MuteToggleButton) : void
      {
         var _loc4_:Quad;
         (_loc4_ = new Quad(this.controlSize,this.controlSize,16711935)).alpha = 0;
         param1.defaultSkin = _loc4_;
         var _loc5_:ImageSkin;
         (_loc5_ = new ImageSkin(null)).setTextureForState("hover",this.quietButtonHoverSkinTexture);
         _loc5_.setTextureForState("down",this.buttonDownSkinTexture);
         _loc5_.setTextureForState("hoverAndSelected",this.toggleButtonSelectedHoverSkinTexture);
         _loc5_.setTextureForState("downAndSelected",this.toggleButtonSelectedDownSkinTexture);
         _loc5_.setTextureForState("disabledAndSelected",this.toggleButtonSelectedDisabledSkinTexture);
         _loc5_.width = this.controlSize;
         _loc5_.height = this.controlSize;
         param1.setSkinForState("hover",_loc5_);
         param1.setSkinForState("down",_loc5_);
         param1.setSkinForState("hoverAndSelected",_loc5_);
         param1.setSkinForState("downAndSelected",_loc5_);
         param1.setSkinForState("disabledAndSelected",_loc5_);
         var _loc2_:Image = new Image(this.focusIndicatorSkinTexture);
         _loc2_.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
         param1.focusIndicatorSkin = _loc2_;
         param1.focusPadding = -1;
         var _loc3_:ImageSkin = new ImageSkin(this.muteToggleButtonLoudUpIconTexture);
         _loc3_.selectedTexture = this.muteToggleButtonMutedUpIconTexture;
         param1.defaultIcon = _loc3_;
         param1.showVolumeSliderOnHover = true;
         param1.hasLabelTextRenderer = false;
         param1.paddingTop = this.extraSmallGutterSize;
         param1.paddingRight = this.smallGutterSize;
         param1.paddingBottom = this.extraSmallGutterSize;
         param1.paddingLeft = this.smallGutterSize;
         param1.gap = this.smallGutterSize;
         param1.minWidth = this.controlSize;
         param1.minHeight = this.controlSize;
      }
      
      protected function setPopUpVolumeSliderStyles(param1:VolumeSlider) : void
      {
         param1.direction = "vertical";
         param1.trackLayoutMode = "split";
         param1.showThumb = false;
         var _loc2_:Image = new Image(this.focusIndicatorSkinTexture);
         _loc2_.scale9Grid = FOCUS_INDICATOR_SCALE_9_GRID;
         param1.focusIndicatorSkin = _loc2_;
         param1.focusPadding = 4;
         param1.width = this.popUpVolumeSliderMinimumTrackSkinTexture.width;
         param1.height = this.popUpVolumeSliderMinimumTrackSkinTexture.height;
         param1.minimumPadding = this.popUpVolumeSliderPaddingSize;
         param1.maximumPadding = this.popUpVolumeSliderPaddingSize;
         param1.customMinimumTrackStyleName = "aeon-pop-up-volume-slider-minimum-track";
         param1.customMaximumTrackStyleName = "aeon-pop-up-volume-slider-maximum-track";
      }
      
      protected function setPopUpVolumeSliderMinimumTrackStyles(param1:Button) : void
      {
         var _loc2_:ImageLoader = new ImageLoader();
         _loc2_.scaleContent = false;
         _loc2_.verticalAlign = "bottom";
         _loc2_.source = this.popUpVolumeSliderMinimumTrackSkinTexture;
         param1.defaultSkin = _loc2_;
         param1.hasLabelTextRenderer = false;
      }
      
      protected function setPopUpVolumeSliderMaximumTrackStyles(param1:Button) : void
      {
         var _loc2_:ImageLoader = new ImageLoader();
         _loc2_.scaleContent = false;
         _loc2_.source = this.popUpVolumeSliderMaximumTrackSkinTexture;
         param1.defaultSkin = _loc2_;
         param1.hasLabelTextRenderer = false;
      }
      
      protected function setSeekSliderStyles(param1:SeekSlider) : void
      {
         param1.direction = "horizontal";
         param1.trackLayoutMode = "split";
         param1.minimumPadding = param1.maximumPadding = -this.vSliderThumbUpSkinTexture.height / 2;
         param1.focusPaddingTop = param1.focusPaddingBottom = -2;
         param1.focusPaddingLeft = param1.focusPaddingRight = -2 + param1.minimumPadding;
         param1.minWidth = this.wideControlSize;
         param1.minHeight = this.smallControlSize;
         var _loc2_:Image = new Image(this.seekSliderProgressSkinTexture);
         _loc2_.scale9Grid = SEEK_SLIDER_MAXIMUM_TRACK_SCALE_9_GRID;
         _loc2_.width = this.smallControlSize;
         param1.progressSkin = _loc2_;
      }
      
      protected function setSeekSliderMinimumTrackStyles(param1:Button) : void
      {
         var _loc2_:Image = new Image(this.seekSliderMinimumTrackSkinTexture);
         _loc2_.scale9Grid = SEEK_SLIDER_MINIMUM_TRACK_SCALE_9_GRID;
         _loc2_.width = this.wideControlSize;
         param1.defaultSkin = _loc2_;
         param1.minTouchHeight = this.controlSize;
         param1.hasLabelTextRenderer = false;
      }
      
      protected function setSeekSliderMaximumTrackStyles(param1:Button) : void
      {
         var _loc2_:Image = new Image(this.seekSliderMaximumTrackSkinTexture);
         _loc2_.scale9Grid = SEEK_SLIDER_MAXIMUM_TRACK_SCALE_9_GRID;
         _loc2_.width = this.wideControlSize;
         param1.defaultSkin = _loc2_;
         param1.minTouchHeight = this.controlSize;
         param1.hasLabelTextRenderer = false;
      }
   }
}
