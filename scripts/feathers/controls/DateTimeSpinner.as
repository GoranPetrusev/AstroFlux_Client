package feathers.controls
{
   import feathers.controls.renderers.DefaultListItemRenderer;
   import feathers.core.FeathersControl;
   import feathers.data.ListCollection;
   import feathers.layout.HorizontalLayout;
   import feathers.skins.IStyleProvider;
   import feathers.utils.math.roundDownToNearest;
   import feathers.utils.math.roundUpToNearest;
   import flash.globalization.DateTimeFormatter;
   import starling.events.Event;
   
   public class DateTimeSpinner extends FeathersControl
   {
      
      public static const DEFAULT_CHILD_STYLE_NAME_LIST:String = "feathers-date-time-spinner-list";
      
      public static const EDITING_MODE_DATE_AND_TIME:String = "dateAndTime";
      
      public static const EDITING_MODE_TIME:String = "time";
      
      public static const EDITING_MODE_DATE:String = "date";
      
      private static const MS_PER_DAY:int = 86400000;
      
      private static const MIN_MONTH_VALUE:int = 0;
      
      private static const MAX_MONTH_VALUE:int = 11;
      
      private static const MIN_DATE_VALUE:int = 1;
      
      private static const MAX_DATE_VALUE:int = 31;
      
      private static const MIN_HOURS_VALUE:int = 0;
      
      private static const MAX_HOURS_VALUE_12HOURS:int = 11;
      
      private static const MAX_HOURS_VALUE_24HOURS:int = 23;
      
      private static const MIN_MINUTES_VALUE:int = 0;
      
      private static const MAX_MINUTES_VALUE:int = 59;
      
      private static const HELPER_DATE:Date = new Date();
      
      private static const DAYS_IN_MONTH:Vector.<int> = new Vector.<int>(0);
      
      protected static const INVALIDATION_FLAG_LOCALE:String = "locale";
      
      protected static const INVALIDATION_FLAG_EDITING_MODE:String = "editingMode";
      
      protected static const INVALIDATION_FLAG_PENDING_SCROLL:String = "pendingScroll";
      
      protected static const INVALIDATION_FLAG_SPINNER_LIST_FACTORY:String = "spinnerListFactory";
      
      public static var globalStyleProvider:IStyleProvider;
       
      
      protected var listStyleName:String = "feathers-date-time-spinner-list";
      
      protected var monthsList:SpinnerList;
      
      protected var datesList:SpinnerList;
      
      protected var yearsList:SpinnerList;
      
      protected var dateAndTimeDatesList:SpinnerList;
      
      protected var hoursList:SpinnerList;
      
      protected var minutesList:SpinnerList;
      
      protected var meridiemList:SpinnerList;
      
      protected var listGroup:LayoutGroup;
      
      protected var _locale:String = "i-default";
      
      protected var _value:Date;
      
      protected var _minimum:Date;
      
      protected var _maximum:Date;
      
      protected var _minuteStep:int = 1;
      
      protected var _editingMode:String = "dateAndTime";
      
      protected var _formatter:DateTimeFormatter;
      
      protected var _longestMonthNameIndex:int;
      
      protected var _localeMonthNames:Vector.<String>;
      
      protected var _localeWeekdayNames:Vector.<String>;
      
      protected var _ignoreListChanges:Boolean = false;
      
      protected var _monthFirst:Boolean = true;
      
      protected var _showMeridiem:Boolean = true;
      
      protected var _lastMeridiemValue:int = 0;
      
      protected var _listMinYear:int;
      
      protected var _listMaxYear:int;
      
      protected var _minYear:int;
      
      protected var _maxYear:int;
      
      protected var _minMonth:int;
      
      protected var _maxMonth:int;
      
      protected var _minDate:int;
      
      protected var _maxDate:int;
      
      protected var _minHours:int;
      
      protected var _maxHours:int;
      
      protected var _minMinute:int;
      
      protected var _maxMinute:int;
      
      protected var _scrollDuration:Number = 0.5;
      
      protected var _itemRendererFactory:Function;
      
      protected var _listFactory:Function;
      
      protected var _customListStyleName:String;
      
      protected var _lastValidate:Date;
      
      protected var _todayLabel:String = null;
      
      protected var _amString:String;
      
      protected var _pmString:String;
      
      protected var pendingScrollToDate:Date;
      
      protected var pendingScrollDuration:Number;
      
      public function DateTimeSpinner()
      {
         var _loc1_:int = 0;
         super();
         if(DAYS_IN_MONTH.length === 0)
         {
            HELPER_DATE.setFullYear(2015);
            _loc1_ = 0;
            while(_loc1_ <= 11)
            {
               HELPER_DATE.setMonth(_loc1_ + 1,-1);
               DAYS_IN_MONTH[_loc1_] = HELPER_DATE.date + 1;
               _loc1_++;
            }
            DAYS_IN_MONTH.fixed = true;
         }
      }
      
      protected static function defaultListFactory() : SpinnerList
      {
         return new SpinnerList();
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return DateTimeSpinner.globalStyleProvider;
      }
      
      public function get locale() : String
      {
         return this._locale;
      }
      
      public function set locale(param1:String) : void
      {
         if(this._locale == param1)
         {
            return;
         }
         this._locale = param1;
         this._formatter = null;
         this.invalidate("locale");
      }
      
      public function get value() : Date
      {
         return this._value;
      }
      
      public function set value(param1:Date) : void
      {
         var _loc2_:Number = param1.time;
         if(this._minimum && this._minimum.time > _loc2_)
         {
            _loc2_ = this._minimum.time;
         }
         if(this._maximum && this._maximum.time < _loc2_)
         {
            _loc2_ = this._maximum.time;
         }
         if(this._value && this._value.time === _loc2_)
         {
            return;
         }
         this._value = new Date(_loc2_);
         this.invalidate("data");
      }
      
      public function get minimum() : Date
      {
         return this._minimum;
      }
      
      public function set minimum(param1:Date) : void
      {
         if(this._minimum == param1)
         {
            return;
         }
         this._minimum = param1;
         this.invalidate("data");
      }
      
      public function get maximum() : Date
      {
         return this._maximum;
      }
      
      public function set maximum(param1:Date) : void
      {
         if(this._maximum == param1)
         {
            return;
         }
         this._maximum = param1;
         this.invalidate("data");
      }
      
      public function get minuteStep() : int
      {
         return this._minuteStep;
      }
      
      public function set minuteStep(param1:int) : void
      {
         if(60 % param1 !== 0)
         {
            throw new ArgumentError("minuteStep must evenly divide into 60.");
         }
         if(this._minuteStep == param1)
         {
            return;
         }
         this._minuteStep = param1;
         this.invalidate("data");
      }
      
      public function get editingMode() : String
      {
         return this._editingMode;
      }
      
      public function set editingMode(param1:String) : void
      {
         if(this._editingMode == param1)
         {
            return;
         }
         this._editingMode = param1;
         this.invalidate("editingMode");
      }
      
      public function get scrollDuration() : Number
      {
         return this._scrollDuration;
      }
      
      public function set scrollDuration(param1:Number) : void
      {
         this._scrollDuration = param1;
      }
      
      public function get itemRendererFactory() : Function
      {
         return this._itemRendererFactory;
      }
      
      public function set itemRendererFactory(param1:Function) : void
      {
         if(this._itemRendererFactory === param1)
         {
            return;
         }
         this._itemRendererFactory = param1;
         this.invalidate("spinnerListFactory");
      }
      
      public function get listFactory() : Function
      {
         return this._listFactory;
      }
      
      public function set listFactory(param1:Function) : void
      {
         if(this._listFactory == param1)
         {
            return;
         }
         this._listFactory = param1;
         this.invalidate("textRenderer");
      }
      
      public function get customListStyleName() : String
      {
         return this._customListStyleName;
      }
      
      public function set customListStyleName(param1:String) : void
      {
         if(this._customListStyleName == param1)
         {
            return;
         }
         this._customListStyleName = param1;
         this.invalidate("spinnerListFactory");
      }
      
      public function get todayLabel() : String
      {
         return this._todayLabel;
      }
      
      public function set todayLabel(param1:String) : void
      {
         if(this._todayLabel == param1)
         {
            return;
         }
         this._todayLabel = param1;
         this.invalidate("data");
      }
      
      public function scrollToDate(param1:Date, param2:Number = NaN) : void
      {
         if(this.pendingScrollToDate && this.pendingScrollToDate.time === param1.time && this.pendingScrollDuration === param2)
         {
            return;
         }
         this.pendingScrollToDate = param1;
         this.pendingScrollDuration = param2;
         this.invalidate("pendingScroll");
      }
      
      override protected function initialize() : void
      {
         var _loc1_:HorizontalLayout = null;
         if(!this.listGroup)
         {
            _loc1_ = new HorizontalLayout();
            _loc1_.horizontalAlign = "center";
            _loc1_.verticalAlign = "justify";
            this.listGroup = new LayoutGroup();
            this.listGroup.layout = _loc1_;
            this.addChild(this.listGroup);
         }
      }
      
      override protected function draw() : void
      {
         var _loc4_:Boolean = this.isInvalid("editingMode");
         var _loc3_:Boolean = this.isInvalid("locale");
         var _loc2_:Boolean = this.isInvalid("data");
         var _loc5_:Boolean = this.isInvalid("pendingScroll");
         var _loc1_:Boolean = this.isInvalid("spinnerListFactory");
         if(this._todayLabel)
         {
            this._lastValidate = new Date();
         }
         if(_loc3_ || _loc4_)
         {
            this.refreshLocale();
         }
         if(_loc3_ || _loc4_ || _loc1_)
         {
            this.refreshLists(_loc4_ || _loc1_,_loc3_);
         }
         if(_loc3_ || _loc4_ || _loc2_ || _loc1_)
         {
            this.useDefaultsIfNeeded();
            this.refreshValidRanges();
            this.refreshSelection();
         }
         this.autoSizeIfNeeded();
         this.layoutChildren();
         if(_loc5_)
         {
            this.handlePendingScroll();
         }
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         var _loc1_:* = this._explicitWidth !== this._explicitWidth;
         var _loc3_:* = this._explicitHeight !== this._explicitHeight;
         var _loc2_:* = this._explicitMinWidth !== this._explicitMinWidth;
         var _loc4_:* = this._explicitMinHeight !== this._explicitMinHeight;
         if(!_loc1_ && !_loc3_ && !_loc2_ && !_loc4_)
         {
            return false;
         }
         this.listGroup.width = this._explicitWidth;
         this.listGroup.height = this._explicitHeight;
         this.listGroup.minWidth = this._explicitMinWidth;
         this.listGroup.minHeight = this._explicitMinHeight;
         this.listGroup.validate();
         return this.saveMeasurements(this.listGroup.width,this.listGroup.height,this.listGroup.minWidth,this.listGroup.minHeight);
      }
      
      protected function refreshLists(param1:Boolean, param2:Boolean) : void
      {
         var _loc3_:ListCollection = null;
         var _loc4_:ListCollection = null;
         if(param1)
         {
            this.createYearList();
            this.createMonthList();
            this.createDateList();
            this.createHourList();
            this.createMinuteList();
            this.createMeridiemList();
            this.createDateAndTimeDateList();
         }
         else if(this._showMeridiem && !this.meridiemList || !this._showMeridiem && this.meridiemList)
         {
            this.createMeridiemList();
         }
         if(this._editingMode == "date")
         {
            if(this._monthFirst)
            {
               this.listGroup.setChildIndex(this.monthsList,0);
            }
            else
            {
               this.listGroup.setChildIndex(this.datesList,0);
            }
         }
         if(param2)
         {
            if(this.monthsList)
            {
               _loc3_ = this.monthsList.dataProvider;
               if(_loc3_)
               {
                  _loc3_.updateAll();
               }
            }
            if(this.dateAndTimeDatesList)
            {
               if(_loc4_ = this.dateAndTimeDatesList.dataProvider)
               {
                  _loc4_.updateAll();
               }
            }
         }
      }
      
      protected function createYearList() : void
      {
         if(this.yearsList)
         {
            this.listGroup.removeChild(this.yearsList,true);
            this.yearsList = null;
         }
         if(this._editingMode !== "date")
         {
            return;
         }
         var _loc1_:Function = this._listFactory !== null ? this._listFactory : defaultListFactory;
         this.yearsList = SpinnerList(_loc1_());
         var _loc2_:String = this._customListStyleName !== null ? this._customListStyleName : this.listStyleName;
         this.yearsList.styleNameList.add(_loc2_);
         this.yearsList.itemRendererFactory = this.yearsListItemRendererFactory;
         this.yearsList.addEventListener("change",yearsList_changeHandler);
         this.listGroup.addChild(this.yearsList);
      }
      
      protected function createMonthList() : void
      {
         if(this.monthsList)
         {
            this.listGroup.removeChild(this.monthsList,true);
            this.monthsList = null;
         }
         if(this._editingMode !== "date")
         {
            return;
         }
         var _loc2_:Function = this._listFactory !== null ? this._listFactory : defaultListFactory;
         this.monthsList = SpinnerList(_loc2_());
         var _loc4_:String = this._customListStyleName !== null ? this._customListStyleName : this.listStyleName;
         this.monthsList.styleNameList.add(_loc4_);
         var _loc1_:IntegerRange = new IntegerRange(0,11,1);
         var _loc3_:ListCollection = new ListCollection(_loc1_);
         _loc3_.dataDescriptor = new IntegerRangeDataDescriptor();
         this.monthsList.dataProvider = _loc3_;
         this.monthsList.typicalItem = this._longestMonthNameIndex;
         this.monthsList.itemRendererFactory = this.monthsListItemRendererFactory;
         this.monthsList.addEventListener("change",monthsList_changeHandler);
         this.listGroup.addChildAt(this.monthsList,0);
      }
      
      protected function createDateList() : void
      {
         if(this.datesList)
         {
            this.listGroup.removeChild(this.datesList,true);
            this.datesList = null;
         }
         if(this._editingMode !== "date")
         {
            return;
         }
         var _loc3_:Function = this._listFactory !== null ? this._listFactory : defaultListFactory;
         this.datesList = SpinnerList(_loc3_());
         var _loc4_:String = this._customListStyleName !== null ? this._customListStyleName : this.listStyleName;
         this.datesList.styleNameList.add(_loc4_);
         var _loc1_:IntegerRange = new IntegerRange(1,31,1);
         var _loc2_:ListCollection = new ListCollection(_loc1_);
         _loc2_.dataDescriptor = new IntegerRangeDataDescriptor();
         this.datesList.dataProvider = _loc2_;
         this.datesList.itemRendererFactory = this.datesListItemRendererFactory;
         this.datesList.addEventListener("change",datesList_changeHandler);
         this.listGroup.addChildAt(this.datesList,0);
      }
      
      protected function createHourList() : void
      {
         if(this.hoursList)
         {
            this.listGroup.removeChild(this.hoursList,true);
            this.hoursList = null;
         }
         if(this._editingMode === "date")
         {
            return;
         }
         var _loc1_:Function = this._listFactory !== null ? this._listFactory : defaultListFactory;
         this.hoursList = SpinnerList(_loc1_());
         var _loc2_:String = this._customListStyleName !== null ? this._customListStyleName : this.listStyleName;
         this.hoursList.styleNameList.add(_loc2_);
         this.hoursList.itemRendererFactory = this.hoursListItemRendererFactory;
         this.hoursList.addEventListener("change",hoursList_changeHandler);
         this.listGroup.addChild(this.hoursList);
      }
      
      protected function createMinuteList() : void
      {
         if(this.minutesList)
         {
            this.listGroup.removeChild(this.minutesList,true);
            this.minutesList = null;
         }
         if(this._editingMode === "date")
         {
            return;
         }
         var _loc1_:Function = this._listFactory !== null ? this._listFactory : defaultListFactory;
         this.minutesList = SpinnerList(_loc1_());
         var _loc4_:String = this._customListStyleName !== null ? this._customListStyleName : this.listStyleName;
         this.minutesList.styleNameList.add(_loc4_);
         var _loc3_:IntegerRange = new IntegerRange(0,59,this._minuteStep);
         var _loc2_:ListCollection = new ListCollection(_loc3_);
         _loc2_.dataDescriptor = new IntegerRangeDataDescriptor();
         this.minutesList.dataProvider = _loc2_;
         this.minutesList.itemRendererFactory = this.minutesListItemRendererFactory;
         this.minutesList.addEventListener("change",minutesList_changeHandler);
         this.listGroup.addChild(this.minutesList);
      }
      
      protected function createMeridiemList() : void
      {
         if(this.meridiemList)
         {
            this.listGroup.removeChild(this.meridiemList,true);
            this.meridiemList = null;
         }
         if(!this._showMeridiem)
         {
            return;
         }
         var _loc1_:Function = this._listFactory !== null ? this._listFactory : defaultListFactory;
         this.meridiemList = SpinnerList(_loc1_());
         var _loc2_:String = this._customListStyleName !== null ? this._customListStyleName : this.listStyleName;
         this.meridiemList.styleNameList.add(_loc2_);
         this.meridiemList.itemRendererFactory = this.meridiemListItemRendererFactory;
         this.meridiemList.addEventListener("change",meridiemList_changeHandler);
         this.listGroup.addChild(this.meridiemList);
      }
      
      protected function createDateAndTimeDateList() : void
      {
         if(this.dateAndTimeDatesList)
         {
            this.listGroup.removeChild(this.dateAndTimeDatesList,true);
            this.dateAndTimeDatesList = null;
         }
         if(this._editingMode !== "dateAndTime")
         {
            return;
         }
         var _loc1_:Function = this._listFactory !== null ? this._listFactory : defaultListFactory;
         this.dateAndTimeDatesList = SpinnerList(_loc1_());
         var _loc2_:String = this._customListStyleName !== null ? this._customListStyleName : this.listStyleName;
         this.dateAndTimeDatesList.styleNameList.add(_loc2_);
         this.dateAndTimeDatesList.itemRendererFactory = this.dateAndTimeDatesListItemRendererFactory;
         this.dateAndTimeDatesList.addEventListener("change",dateAndTimeDatesList_changeHandler);
         this.dateAndTimeDatesList.typicalItem = {};
         this.listGroup.addChildAt(this.dateAndTimeDatesList,0);
      }
      
      protected function refreshLocale() : void
      {
         var _loc5_:String = null;
         var _loc3_:int = 0;
         var _loc2_:int = 0;
         var _loc7_:* = null;
         var _loc6_:int = 0;
         var _loc4_:int = 0;
         var _loc1_:String = null;
         if(!this._formatter || this._formatter.requestedLocaleIDName != this._locale)
         {
            this._formatter = new DateTimeFormatter(this._locale,"short","short");
            _loc3_ = (_loc5_ = this._formatter.getDateTimePattern()).indexOf("M");
            _loc2_ = _loc5_.indexOf("d");
            this._monthFirst = _loc3_ < _loc2_;
            this._showMeridiem = this._editingMode !== "date" && _loc5_.indexOf("a") >= 0;
            if(this._showMeridiem)
            {
               this._formatter.setDateTimePattern("a");
               HELPER_DATE.setHours(1);
               this._amString = this._formatter.format(HELPER_DATE);
               HELPER_DATE.setHours(13);
               this._pmString = this._formatter.format(HELPER_DATE);
               this._formatter.setDateTimePattern(_loc5_);
            }
         }
         if(this._editingMode === "date")
         {
            this._localeMonthNames = this._formatter.getMonthNames("full");
            this._localeWeekdayNames = null;
         }
         else if(this._editingMode === "dateAndTime")
         {
            this._localeMonthNames = this._formatter.getMonthNames("shortAbbreviation");
            this._localeWeekdayNames = this._formatter.getWeekdayNames("longAbbreviation");
         }
         else
         {
            this._localeMonthNames = null;
            this._localeWeekdayNames = null;
         }
         if(this._localeMonthNames !== null)
         {
            this._longestMonthNameIndex = 0;
            _loc7_ = this._localeMonthNames[0];
            _loc6_ = int(this._localeMonthNames.length);
            _loc4_ = 1;
            while(_loc4_ < _loc6_)
            {
               _loc1_ = this._localeMonthNames[_loc4_];
               if(_loc1_.length > _loc7_.length)
               {
                  _loc7_ = _loc1_;
                  this._longestMonthNameIndex = _loc4_;
               }
               _loc4_++;
            }
         }
      }
      
      protected function refreshSelection() : void
      {
         var _loc11_:ListCollection = null;
         var _loc5_:IntegerRange = null;
         var _loc9_:IntegerRangeDataDescriptor = null;
         var _loc6_:Number = NaN;
         var _loc3_:int = 0;
         var _loc7_:ListCollection = null;
         var _loc1_:IntegerRange = null;
         var _loc10_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc2_:ListCollection = null;
         var _loc12_:IntegerRange = null;
         var _loc4_:Boolean = this._ignoreListChanges;
         this._ignoreListChanges = true;
         if(this._editingMode === "date")
         {
            if(_loc11_ = this.yearsList.dataProvider)
            {
               if((_loc5_ = IntegerRange(_loc11_.data)).minimum !== this._listMinYear || _loc5_.maximum !== this._listMaxYear)
               {
                  _loc5_.minimum = this._listMinYear;
                  _loc5_.maximum = this._listMaxYear;
                  _loc9_ = IntegerRangeDataDescriptor(_loc11_.dataDescriptor);
                  _loc11_.data = null;
                  _loc11_.data = _loc5_;
                  _loc11_.dataDescriptor = _loc9_;
               }
            }
            else
            {
               _loc5_ = new IntegerRange(this._listMinYear,this._listMaxYear,1);
               (_loc11_ = new ListCollection(_loc5_)).dataDescriptor = new IntegerRangeDataDescriptor();
               this.yearsList.dataProvider = _loc11_;
            }
         }
         else
         {
            _loc3_ = (_loc6_ = this._maximum.time - this._minimum.time) / 86400000;
            if(this._editingMode === "dateAndTime")
            {
               if(_loc7_ = this.dateAndTimeDatesList.dataProvider)
               {
                  _loc1_ = IntegerRange(_loc7_.data);
                  if(_loc1_.maximum !== _loc3_)
                  {
                     _loc1_.maximum = _loc3_;
                     _loc9_ = IntegerRangeDataDescriptor(_loc7_.dataDescriptor);
                     _loc7_.data = null;
                     _loc7_.data = _loc1_;
                     _loc7_.dataDescriptor = _loc9_;
                  }
               }
               else
               {
                  _loc1_ = new IntegerRange(0,_loc3_,1);
                  (_loc7_ = new ListCollection(_loc1_)).dataDescriptor = new IntegerRangeDataDescriptor();
                  this.dateAndTimeDatesList.dataProvider = _loc7_;
               }
            }
            _loc10_ = 0;
            _loc8_ = this._showMeridiem ? 11 : 23;
            _loc2_ = this.hoursList.dataProvider;
            if(_loc2_)
            {
               if((_loc12_ = IntegerRange(_loc2_.data)).minimum !== _loc10_ || _loc12_.maximum !== _loc8_)
               {
                  _loc12_.minimum = _loc10_;
                  _loc12_.maximum = _loc8_;
                  _loc9_ = IntegerRangeDataDescriptor(_loc2_.dataDescriptor);
                  _loc2_.data = null;
                  _loc2_.data = _loc12_;
                  _loc2_.dataDescriptor = _loc9_;
               }
            }
            else
            {
               _loc12_ = new IntegerRange(_loc10_,_loc8_,1);
               _loc2_ = new ListCollection(_loc12_);
               _loc2_.dataDescriptor = new IntegerRangeDataDescriptor();
               this.hoursList.dataProvider = _loc2_;
            }
            if(this._showMeridiem && !this.meridiemList.dataProvider)
            {
               this.meridiemList.dataProvider = new ListCollection(new <String>[this._amString,this._pmString]);
            }
         }
         if(this.monthsList && !this.monthsList.isScrolling)
         {
            this.monthsList.selectedItem = this._value.month;
         }
         if(this.datesList && !this.datesList.isScrolling)
         {
            this.datesList.selectedItem = this._value.date;
         }
         if(this.yearsList && !this.yearsList.isScrolling)
         {
            this.yearsList.selectedItem = this._value.fullYear;
         }
         if(this.dateAndTimeDatesList)
         {
            this.dateAndTimeDatesList.selectedIndex = (this._value.time - this._minimum.time) / 86400000;
         }
         if(this.hoursList)
         {
            if(this._showMeridiem)
            {
               this.hoursList.selectedIndex = this._value.hours % 12;
            }
            else
            {
               this.hoursList.selectedIndex = this._value.hours;
            }
         }
         if(this.minutesList)
         {
            this.minutesList.selectedItem = this._value.minutes;
         }
         if(this.meridiemList)
         {
            this.meridiemList.selectedIndex = this._value.hours <= 11 ? 0 : 1;
         }
         this._ignoreListChanges = _loc4_;
      }
      
      protected function refreshValidRanges() : void
      {
         var _loc17_:int = this._minYear;
         var _loc8_:int = this._maxYear;
         var _loc19_:int = this._minMonth;
         var _loc9_:int = this._maxMonth;
         var _loc20_:int = this._minDate;
         var _loc2_:int = this._maxDate;
         var _loc10_:int = this._minHours;
         var _loc15_:int = this._maxHours;
         var _loc3_:int = this._minMinute;
         var _loc18_:int = this._maxMinute;
         var _loc11_:int = this._value.fullYear;
         var _loc7_:int = this._value.month;
         var _loc6_:int = this._value.date;
         var _loc13_:int = this._value.hours;
         this._minYear = this._minimum.fullYear;
         this._maxYear = this._maximum.fullYear;
         if(_loc11_ === this._minYear)
         {
            this._minMonth = this._minimum.month;
         }
         else
         {
            this._minMonth = 0;
         }
         if(_loc11_ === this._maxYear)
         {
            this._maxMonth = this._maximum.month;
         }
         else
         {
            this._maxMonth = 11;
         }
         if(_loc11_ === this._minYear && _loc7_ === this._minimum.month)
         {
            this._minDate = this._minimum.date;
         }
         else
         {
            this._minDate = 1;
         }
         if(_loc11_ === this._maxYear && _loc7_ === this._maximum.month)
         {
            this._maxDate = this._maximum.date;
         }
         else if(_loc7_ === 1)
         {
            HELPER_DATE.setFullYear(_loc11_,_loc7_ + 1,-1);
            this._maxDate = HELPER_DATE.date + 1;
         }
         else
         {
            this._maxDate = DAYS_IN_MONTH[_loc7_];
         }
         if(this._editingMode === "dateAndTime")
         {
            if(_loc11_ === this._minYear && _loc7_ === this._minimum.month && _loc6_ === this._minimum.date)
            {
               this._minHours = this._minimum.hours;
            }
            else
            {
               this._minHours = 0;
            }
            if(_loc11_ === this._maxYear && _loc7_ === this._maximum.month && _loc6_ === this._maximum.date)
            {
               this._maxHours = this._maximum.hours;
            }
            else
            {
               this._maxHours = 23;
            }
            if(_loc11_ === this._minYear && _loc7_ === this._minimum.month && _loc6_ === this._minimum.date && _loc13_ === this._minimum.hours)
            {
               this._minMinute = this._minimum.minutes;
            }
            else
            {
               this._minMinute = 0;
            }
            if(_loc11_ === this._maxYear && _loc7_ === this._maximum.month && _loc6_ === this._maximum.date && _loc13_ === this._maximum.hours)
            {
               this._maxMinute = this._maximum.minutes;
            }
            else
            {
               this._maxMinute = 59;
            }
         }
         else
         {
            this._minHours = this._minimum.hours;
            this._maxHours = this._maximum.hours;
            if(_loc13_ === this._minHours)
            {
               this._minMinute = this._minimum.minutes;
            }
            else
            {
               this._minMinute = 0;
            }
            if(_loc13_ === this._maxHours)
            {
               this._maxMinute = this._maximum.minutes;
            }
            else
            {
               this._maxMinute = 59;
            }
         }
         var _loc12_:ListCollection;
         if((_loc12_ = !!this.yearsList ? this.yearsList.dataProvider : null) && (_loc17_ !== this._minYear || _loc8_ !== this._maxYear))
         {
            _loc12_.updateAll();
         }
         var _loc4_:ListCollection;
         if((_loc4_ = !!this.monthsList ? this.monthsList.dataProvider : null) && (_loc19_ !== this._minMonth || _loc9_ !== this._maxMonth))
         {
            _loc4_.updateAll();
         }
         var _loc14_:ListCollection;
         if((_loc14_ = !!this.datesList ? this.datesList.dataProvider : null) && (_loc20_ !== this._minDate || _loc2_ !== this._maxDate))
         {
            _loc14_.updateAll();
         }
         var _loc5_:ListCollection;
         if((_loc5_ = !!this.dateAndTimeDatesList ? this.dateAndTimeDatesList.dataProvider : null) && (_loc17_ !== this._minYear || _loc8_ !== this._maxYear || _loc19_ !== this._minMonth || _loc9_ !== this._maxMonth || _loc20_ !== this._minDate || _loc2_ !== this._maxDate))
         {
            _loc5_.updateAll();
         }
         var _loc1_:ListCollection = !!this.hoursList ? this.hoursList.dataProvider : null;
         if(_loc1_ && (_loc10_ !== this._minHours || _loc15_ !== this._maxHours || this._showMeridiem && this._lastMeridiemValue !== this.meridiemList.selectedIndex))
         {
            _loc1_.updateAll();
         }
         var _loc16_:ListCollection;
         if((_loc16_ = !!this.minutesList ? this.minutesList.dataProvider : null) && (_loc3_ !== this._minMinute || _loc18_ !== this._maxMinute))
         {
            _loc16_.updateAll();
         }
         if(this._showMeridiem)
         {
            this._lastMeridiemValue = this._value.hours <= 11 ? 0 : 1;
         }
      }
      
      protected function useDefaultsIfNeeded() : void
      {
         if(!this._value)
         {
            this._value = new Date();
            if(this._minimum && this._value.time < this._minimum.time)
            {
               this._value.time = this._minimum.time;
            }
            else if(this._maximum && this._value.time > this._maximum.time)
            {
               this._value.time = this._maximum.time;
            }
         }
         if(this._minimum)
         {
            if(this._editingMode === "dateAndTime")
            {
               this._listMinYear = this._minimum.fullYear - 1;
            }
            else
            {
               this._listMinYear = this._minimum.fullYear - 10;
            }
         }
         else if(this._editingMode === "dateAndTime")
         {
            HELPER_DATE.time = this._value.time;
            this._listMinYear = HELPER_DATE.fullYear - 1;
            this._minimum = new Date(this._listMinYear,0,1,0,0);
         }
         else
         {
            HELPER_DATE.time = this._value.time;
            this._listMinYear = roundDownToNearest(HELPER_DATE.fullYear - 100,50);
            this._minimum = new Date(this._listMinYear,0,1,0,0);
         }
         if(this._maximum)
         {
            if(this._editingMode === "dateAndTime")
            {
               this._listMaxYear = this._maximum.fullYear + 1;
            }
            else
            {
               this._listMaxYear = this._maximum.fullYear + 10;
            }
         }
         else if(this._editingMode === "dateAndTime")
         {
            HELPER_DATE.time = this._minimum.time;
            this._listMaxYear = HELPER_DATE.fullYear + 1;
            this._maximum = new Date(this._listMaxYear,11,DAYS_IN_MONTH[11],23,59);
         }
         else
         {
            HELPER_DATE.time = this._value.time;
            this._listMaxYear = roundUpToNearest(HELPER_DATE.fullYear + 100,50);
            this._maximum = new Date(this._listMaxYear,11,DAYS_IN_MONTH[11],23,59);
         }
      }
      
      protected function layoutChildren() : void
      {
         this.listGroup.width = this.actualWidth;
         this.listGroup.height = this.actualHeight;
         this.listGroup.validate();
      }
      
      protected function handlePendingScroll() : void
      {
         var _loc5_:int = 0;
         var _loc6_:IntegerRange = null;
         var _loc4_:int = 0;
         var _loc2_:int = 0;
         var _loc7_:int = 0;
         var _loc3_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(!this.pendingScrollToDate)
         {
            return;
         }
         var _loc1_:Number = this.pendingScrollDuration;
         if(_loc1_ !== _loc1_)
         {
            _loc1_ = this._scrollDuration;
         }
         if(this.yearsList)
         {
            _loc5_ = this.pendingScrollToDate.fullYear;
            if(this.yearsList.selectedItem !== _loc5_)
            {
               _loc6_ = IntegerRange(this.yearsList.dataProvider.data);
               this.yearsList.scrollToDisplayIndex(_loc5_ - _loc6_.minimum,_loc1_);
            }
         }
         if(this.monthsList)
         {
            _loc4_ = this.pendingScrollToDate.month;
            if(this.monthsList.selectedItem !== _loc4_)
            {
               this.monthsList.scrollToDisplayIndex(_loc4_,_loc1_);
            }
         }
         if(this.datesList)
         {
            _loc2_ = this.pendingScrollToDate.date;
            if(this.datesList.selectedItem !== _loc2_)
            {
               this.datesList.scrollToDisplayIndex(_loc2_ - 1,_loc1_);
            }
         }
         if(this.dateAndTimeDatesList)
         {
            _loc7_ = (this.pendingScrollToDate.time - this._minimum.time) / 86400000;
            if(this.dateAndTimeDatesList.selectedIndex !== _loc7_)
            {
               this.dateAndTimeDatesList.scrollToDisplayIndex(_loc7_,_loc1_);
            }
         }
         if(this.hoursList)
         {
            _loc3_ = this.pendingScrollToDate.hours;
            if(this._showMeridiem)
            {
               _loc3_ %= 12;
            }
            if(this.hoursList.selectedItem !== _loc3_)
            {
               this.hoursList.scrollToDisplayIndex(_loc3_,_loc1_);
            }
         }
         if(this.minutesList)
         {
            _loc8_ = this.pendingScrollToDate.minutes;
            if(this.minutesList.selectedItem !== _loc8_)
            {
               this.minutesList.scrollToDisplayIndex(_loc8_,_loc1_);
            }
         }
         if(this.meridiemList)
         {
            _loc9_ = this.pendingScrollToDate.hours < 11 ? 0 : 1;
            if(this.meridiemList.selectedIndex !== _loc9_)
            {
               this.meridiemList.scrollToDisplayIndex(_loc9_,_loc1_);
            }
         }
      }
      
      protected function meridiemListItemRendererFactory() : DefaultListItemRenderer
      {
         var _loc1_:DefaultListItemRenderer = null;
         if(this._itemRendererFactory !== null)
         {
            _loc1_ = DefaultListItemRenderer(this._itemRendererFactory());
         }
         else
         {
            _loc1_ = new DefaultListItemRenderer();
         }
         return _loc1_;
      }
      
      protected function minutesListItemRendererFactory() : DefaultListItemRenderer
      {
         var _loc1_:DefaultListItemRenderer = null;
         if(this._itemRendererFactory !== null)
         {
            _loc1_ = DefaultListItemRenderer(this._itemRendererFactory());
         }
         else
         {
            _loc1_ = new DefaultListItemRenderer();
         }
         _loc1_.labelFunction = formatMinutes;
         _loc1_.enabledFunction = isMinuteEnabled;
         _loc1_.itemHasEnabled = true;
         return _loc1_;
      }
      
      protected function hoursListItemRendererFactory() : DefaultListItemRenderer
      {
         var _loc1_:DefaultListItemRenderer = null;
         if(this._itemRendererFactory !== null)
         {
            _loc1_ = DefaultListItemRenderer(this._itemRendererFactory());
         }
         else
         {
            _loc1_ = new DefaultListItemRenderer();
         }
         _loc1_.labelFunction = formatHours;
         _loc1_.enabledFunction = isHourEnabled;
         _loc1_.itemHasEnabled = true;
         return _loc1_;
      }
      
      protected function dateAndTimeDatesListItemRendererFactory() : DefaultListItemRenderer
      {
         var _loc1_:DefaultListItemRenderer = null;
         if(this._itemRendererFactory !== null)
         {
            _loc1_ = DefaultListItemRenderer(this._itemRendererFactory());
         }
         else
         {
            _loc1_ = new DefaultListItemRenderer();
         }
         _loc1_.labelFunction = formatDateAndTimeDate;
         _loc1_.accessoryLabelFunction = formatDateAndTimeWeekday;
         return _loc1_;
      }
      
      protected function monthsListItemRendererFactory() : DefaultListItemRenderer
      {
         var _loc1_:DefaultListItemRenderer = null;
         if(this._itemRendererFactory !== null)
         {
            _loc1_ = DefaultListItemRenderer(this._itemRendererFactory());
         }
         else
         {
            _loc1_ = new DefaultListItemRenderer();
         }
         _loc1_.labelFunction = formatMonthName;
         _loc1_.enabledFunction = isMonthEnabled;
         _loc1_.itemHasEnabled = true;
         return _loc1_;
      }
      
      protected function datesListItemRendererFactory() : DefaultListItemRenderer
      {
         var _loc1_:DefaultListItemRenderer = null;
         if(this._itemRendererFactory !== null)
         {
            _loc1_ = DefaultListItemRenderer(this._itemRendererFactory());
         }
         else
         {
            _loc1_ = new DefaultListItemRenderer();
         }
         _loc1_.enabledFunction = isDateEnabled;
         _loc1_.itemHasEnabled = true;
         return _loc1_;
      }
      
      protected function yearsListItemRendererFactory() : DefaultListItemRenderer
      {
         var _loc1_:DefaultListItemRenderer = null;
         if(this._itemRendererFactory !== null)
         {
            _loc1_ = DefaultListItemRenderer(this._itemRendererFactory());
         }
         else
         {
            _loc1_ = new DefaultListItemRenderer();
         }
         _loc1_.enabledFunction = isYearEnabled;
         _loc1_.itemHasEnabled = true;
         return _loc1_;
      }
      
      protected function isMonthEnabled(param1:int) : Boolean
      {
         return param1 >= this._minMonth && param1 <= this._maxMonth;
      }
      
      protected function isYearEnabled(param1:int) : Boolean
      {
         return param1 >= this._minYear && param1 <= this._maxYear;
      }
      
      protected function isDateEnabled(param1:int) : Boolean
      {
         return param1 >= this._minDate && param1 <= this._maxDate;
      }
      
      protected function isHourEnabled(param1:int) : Boolean
      {
         if(this._showMeridiem && this.meridiemList.selectedIndex !== 0)
         {
            param1 += 12;
         }
         return param1 >= this._minHours && param1 <= this._maxHours;
      }
      
      protected function isMinuteEnabled(param1:int) : Boolean
      {
         return param1 >= this._minMinute && param1 <= this._maxMinute;
      }
      
      protected function formatHours(param1:int) : String
      {
         if(this._showMeridiem)
         {
            if(param1 === 0)
            {
               param1 = 12;
            }
            return param1.toString();
         }
         var _loc2_:String = param1.toString();
         if(_loc2_.length < 2)
         {
            _loc2_ = "0" + _loc2_;
         }
         return _loc2_;
      }
      
      protected function formatMinutes(param1:int) : String
      {
         var _loc2_:String = param1.toString();
         if(_loc2_.length < 2)
         {
            _loc2_ = "0" + _loc2_;
         }
         return _loc2_;
      }
      
      protected function formatDateAndTimeWeekday(param1:Object) : String
      {
         if(param1 is int)
         {
            HELPER_DATE.setTime(this._minimum.time);
            HELPER_DATE.setDate(HELPER_DATE.date + param1);
            if(this._todayLabel)
            {
               if(HELPER_DATE.fullYear === this._lastValidate.fullYear && HELPER_DATE.month === this._lastValidate.month && HELPER_DATE.date === this._lastValidate.date)
               {
                  return "";
               }
            }
            return this._localeWeekdayNames[HELPER_DATE.day] as String;
         }
         return "Wom";
      }
      
      protected function formatDateAndTimeDate(param1:Object) : String
      {
         var _loc2_:String = null;
         if(param1 is int)
         {
            HELPER_DATE.setTime(this._minimum.time);
            HELPER_DATE.setDate(HELPER_DATE.date + param1);
            if(this._todayLabel)
            {
               if(HELPER_DATE.fullYear === this._lastValidate.fullYear && HELPER_DATE.month === this._lastValidate.month && HELPER_DATE.date === this._lastValidate.date)
               {
                  return this._todayLabel;
               }
            }
            _loc2_ = this._localeMonthNames[HELPER_DATE.month] as String;
            if(this._monthFirst)
            {
               return _loc2_ + " " + HELPER_DATE.date;
            }
            return HELPER_DATE.date + " " + _loc2_;
         }
         return "Wom 30";
      }
      
      protected function formatMonthName(param1:int) : String
      {
         return this._localeMonthNames[param1] as String;
      }
      
      protected function validateNewValue() : void
      {
         var _loc1_:Number = this._value.time;
         var _loc2_:Number = this._minimum.time;
         var _loc3_:Number = this._maximum.time;
         var _loc4_:Boolean = false;
         if(_loc1_ < _loc2_)
         {
            _loc4_ = true;
            this._value.setTime(_loc2_);
         }
         else if(_loc1_ > _loc3_)
         {
            _loc4_ = true;
            this._value.setTime(_loc3_);
         }
         if(_loc4_)
         {
            this.scrollToDate(this._value);
         }
      }
      
      protected function updateHoursFromLists() : void
      {
         var _loc1_:int = this.hoursList.selectedItem as int;
         if(this.meridiemList && this.meridiemList.selectedIndex === 1)
         {
            _loc1_ += 12;
         }
         this._value.setHours(_loc1_);
      }
      
      protected function monthsList_changeHandler(param1:Event) : void
      {
         if(this._ignoreListChanges)
         {
            return;
         }
         var _loc2_:int = this.monthsList.selectedItem as int;
         this._value.setMonth(_loc2_);
         this.validateNewValue();
         this.refreshValidRanges();
         this.dispatchEventWith("change");
      }
      
      protected function datesList_changeHandler(param1:Event) : void
      {
         if(this._ignoreListChanges)
         {
            return;
         }
         var _loc2_:int = this.datesList.selectedItem as int;
         this._value.setDate(_loc2_);
         this.validateNewValue();
         this.refreshValidRanges();
         this.dispatchEventWith("change");
      }
      
      protected function yearsList_changeHandler(param1:Event) : void
      {
         if(this._ignoreListChanges)
         {
            return;
         }
         var _loc2_:int = this.yearsList.selectedItem as int;
         this._value.setFullYear(_loc2_);
         this.validateNewValue();
         this.refreshValidRanges();
         this.dispatchEventWith("change");
      }
      
      protected function dateAndTimeDatesList_changeHandler(param1:Event) : void
      {
         if(this._ignoreListChanges)
         {
            return;
         }
         this._value.setFullYear(this._minimum.fullYear,this._minimum.month,this._minimum.date + this.dateAndTimeDatesList.selectedIndex);
         this.validateNewValue();
         this.refreshValidRanges();
         this.dispatchEventWith("change");
      }
      
      protected function hoursList_changeHandler(param1:Event) : void
      {
         if(this._ignoreListChanges)
         {
            return;
         }
         this.updateHoursFromLists();
         this.validateNewValue();
         this.refreshValidRanges();
         this.dispatchEventWith("change");
      }
      
      protected function minutesList_changeHandler(param1:Event) : void
      {
         if(this._ignoreListChanges)
         {
            return;
         }
         var _loc2_:int = this.minutesList.selectedItem as int;
         this._value.setMinutes(_loc2_);
         this.validateNewValue();
         this.refreshValidRanges();
         this.dispatchEventWith("change");
      }
      
      protected function meridiemList_changeHandler(param1:Event) : void
      {
         if(this._ignoreListChanges)
         {
            return;
         }
         this.updateHoursFromLists();
         this.validateNewValue();
         this.refreshValidRanges();
         this.dispatchEventWith("change");
      }
   }
}

class IntegerRange
{
    
   
   public var minimum:int;
   
   public var maximum:int;
   
   public var step:int;
   
   public function IntegerRange(param1:int, param2:int, param3:int = 1)
   {
      super();
      this.minimum = param1;
      this.maximum = param2;
      this.step = param3;
   }
}

import feathers.data.IListCollectionDataDescriptor;

class IntegerRangeDataDescriptor implements IListCollectionDataDescriptor
{
    
   
   public function IntegerRangeDataDescriptor()
   {
      super();
   }
   
   public function getLength(param1:Object) : int
   {
      var _loc2_:IntegerRange = IntegerRange(param1);
      return 1 + int((_loc2_.maximum - _loc2_.minimum) / _loc2_.step);
   }
   
   public function getItemAt(param1:Object, param2:int) : Object
   {
      var _loc4_:IntegerRange;
      var _loc5_:int = (_loc4_ = IntegerRange(param1)).maximum;
      var _loc3_:* = _loc4_.minimum + param2 * _loc4_.step;
      if(_loc3_ > _loc5_)
      {
         _loc3_ = _loc5_;
      }
      return _loc3_;
   }
   
   public function setItemAt(param1:Object, param2:Object, param3:int) : void
   {
      throw "Not implemented";
   }
   
   public function addItemAt(param1:Object, param2:Object, param3:int) : void
   {
      throw "Not implemented";
   }
   
   public function removeItemAt(param1:Object, param2:int) : Object
   {
      throw "Not implemented";
   }
   
   public function getItemIndex(param1:Object, param2:Object) : int
   {
      if(!(param2 is int))
      {
         return -1;
      }
      var _loc4_:int = param2 as int;
      var _loc3_:IntegerRange = IntegerRange(param1);
      return Math.ceil((_loc4_ - _loc3_.minimum) / _loc3_.step);
   }
   
   public function removeAll(param1:Object) : void
   {
      throw "Not implemented";
   }
}
