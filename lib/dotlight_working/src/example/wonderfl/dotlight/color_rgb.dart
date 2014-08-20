 part of dotlight;
	/**
	 * @author nilsdoehring
	 */
	 class ColorRGB implements IColor{
		
		 int _r;
		 int _g;
		 int _b;
		 num _alpha;
		
		/**
		 * 新しい ColorRGB クラスのインスタンスを生成します.
		 * 
		 * @param	r_	Red [0,255]
		 * @param	g_	Green [0,255]
		 * @param	b_	Blue [0,255]
		 * @param	a	Alpha [0.0,1.0]
		 */
	 ColorRGB([int r_=0, int g_=0, int b_=0, num a=1.0 ])
		{
			rgb( r_, g_, b_ );
			_alpha = a;
		}
			
		//---------------------------------------------------------------------------------------------------ICOLOR INTERFACE
		
		/**
		 * 24bit Color (0xRRGGBB) を示します.
		 */
		  int get value { return _r << 16 | _g << 8 | _b; }
		  void set value(int value_)
		{
			_r = value_ >> 16;
			_g = ( value_ & 0x00ff00 ) >> 8;
			_b = value_ & 0x0000ff;
		}
		
		/**
		 * 32bit Color (0xAARRGGBB) を示します.
		 */
		  int get value32 { return ( ( _alpha*0xff ).toInt()&0xff ).round() << 24 | _r << 16 | _g << 8 | _b ; }
		  void set value32(int value_)
		{
			_r = ( value_ & 0x00ff0000 ) >>/*>*/ 16;
			_g = ( value_ & 0x0000ff00 ) >>/*>*/ 8;
			_b = value_ & 0x000000ff;
			_alpha = ( value_ >>/*>*/ 24 ) / 0xff;
		}
		
		/**
		 * 色の 透明度(Alpha) 値を示します.<br/>
		 * 有効な値は 0.0　～　1.0　です.デフォルト値は　1.0　です.
		 */
		  num get alpha { return _alpha; }
		  void set alpha(num value_)
		{
			_alpha = value_;
		}
		
		/**
		 * 色の 透明度(Alpha) 値を 0～255 で示します.<br/>
		 * 有効な値は 0～255 です.
		 */
		  int get alpha8 { return((_alpha*0xff).toInt()); }
		  void set alpha8(int value_)
		{
			_alpha = 1.0*value_/0xff;
		}
		
		/**
		 * 色の 赤(Red) 値を示します.<br/>
		 * 有効な値は 0 ～ 255 です.デフォルト値は 0 です.
		 */
		  int get r { return _r; }
		  void set r(int value_)
		{
			_r = value_ & 0xff;
		}
		
		/**
		 * 色の 緑(Green) 値を示します.<br/>
		 * 有効な値は 0 ～ 255 です.デフォルト値は 0 です.
		 */
		  int get g { return _g; }
		  void set g(int value_)
		{
			_g = value_ & 0xff;
		}
		
		/**
		 * 色の 青(Blue) 値を示します.<br/>
		 * 有効な値は 0 ～ 255 です.デフォルト値は 0 です.
		 */
		  int get b { return _b; }
		  void set b(int value_)
		{
			_b = value_ & 0xff;
		}
		
		//---------------------------------------------------------------------------------------------------SET
		
		/**
		 * RGB値で色を指定します.
		 * @param	r_	Red [0,255]
		 * @param	g_	Green [0,255]
		 * @param	b_	Blue [0,255]
		 */
		  void rgb(int r_,int g_,int b_)
		{
			_r = r_ & 0xff;
			_g = g_ & 0xff;
			_b = b_ & 0xff;
		}
		
		/**
		 * グレイ値で色を指定します.
		 * @param	gray_	Gray [0,255]
		 */
		  void gray(int gray_)
		{
			_r = _g = _b = gray_ & 0xff;
		}
		
		//--------------------------------------------------------------------------------------------------- CONVERT
		
		/**
		 * RGB 値を HSV 値に変換して ColorHSV クラスのインスタンスを生成します.
		 */
		  ColorHSV toHSV()
		{
			return ColorHSV.fromRGB( _r, _g, _b, _alpha );
		}
		
		//--------------------------------------------------------------------------------------------------- STRING, VALUE
		
		  String toString() 
		{
			return "[RGB($_r,$_g,$_b)A("+ _alpha.toStringAsFixed(2)+")]";
		}
		
		/**
		 * @return 0xRRBBGG
		 */
		  int valueOf() 
		{
			return value;
		}
		
		/**
		 * ColorRGB インスタンスのクローンを生成します.
		 */
		  ColorRGB clone()
		{
			return new ColorRGB( _r, _g, _b, _alpha );
		}
	}

