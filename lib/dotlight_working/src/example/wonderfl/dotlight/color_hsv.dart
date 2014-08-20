 part of dotlight;
	/**
	 * @author nilsdoehring
	 */
	/**
	 * 色相（Hue） 彩度(Saturation) 明度(Value・Brightness) で色を定義するクラスです.
	 * 
	 * @author nutsu
	 * @version 0.1
	 * 
	 * @see frocessing.color.ColorRGB
	 * @see frocessing.color.FColor
	 */
	 class ColorHSV implements IColor {
		
		 num _h;	//Hue
		 num _s;	//Saturation
		 num _v;	//Value | Brightness
		 int _r;
		 int _g;
		 int _b;
		 num _alpha;
		 bool update_flg;
		
		/**
		 * 新しい ColorHSV クラスのインスタンスを生成します.
		 * 
		 * @param	h_	Hue (degree 360)
		 * @param	s_	Saturation [0.0,1.0]
		 * @param	v_	Brightness [0.0,1.0]
		 * @param	a	Alpha [0.0,1.0]
		 */
	 ColorHSV([num h_=0.0, num s_=1.0, num v_=1.0, num a=1.0  ]) 
		{
			hsv( h_, s_, v_ );
			_alpha = a;
		}
		
		//---------------------------------------------------------------------------------------------------ICOLOR INTERFACE
		
		/**
		 * 24bit Color (0xRRGGBB) を示します.
		 */
		  int get value
		{
			if ( update_flg )
				update();
			return _r << 16 | _g << 8 | _b;
		}
		  void set value(int value_)
		{
			_r = value_ >> 16;
			_g = ( value_ & 0x00ff00 ) >> 8;
			_b = value_ & 0x0000ff;
			update_hsv();
		}
		
		/**
		 * 32bit Color (0xAARRGGBB) を示します.
		 */
		  int get value32
		{
			if ( update_flg )
				update();
			return ( ( _alpha*0xff ).toInt() & 0xff ).round()<<24 | _r << 16 | _g << 8 | _b ;
		}
		  void set value32(int value_)
		{
			_r = ( value_ & 0x00ff0000 ) >>/*>*/ 16;
			_g = ( value_ & 0x0000ff00 ) >>/*>*/ 8;
			_b = value_ & 0x000000ff;
			_alpha = ( value_ >>/*>*/ 24 ) / 0xff;
			update_hsv();
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
		 * 有効な値は 0～255　です.
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
		  int get r
		{
			if ( update_flg )
				update();
			return _r;
		}
		  void set r(int value_)
		{
			_r = value_ & 0xff;
			update_hsv();
		}
		
		/**
		 * 色の 緑(Green) 値を示します.<br/>
		 * 有効な値は 0 ～ 255 です.デフォルト値は 0 です.
		 */
		  int get g
		{
			if ( update_flg )
				update();
			return _g;
		}
		  void set g(int value_)
		{
			_g = value_ & 0xff;
			update_hsv();
		}
		
		/**
		 * 色の 青(Blue) 値を示します.<br/>
		 * 有効な値は 0 ～ 255 です.デフォルト値は 0 です.
		 */
		  int get b
		{
			if ( update_flg )
				update();
			return _b;
		}
		  void set b(int value_)
		{
			_b = value_ & 0xff;
			update_hsv();
		}
		
		//---------------------------------------------------------------------------------------------------H,S,V
		
		/**
		 * 色の 色相(Hue) 値を、色相環上のディグリーの角度( 0～360 )で示します.<br/>
		 * 0 度が赤、120 度が緑、240 度が青になります. 
		 */
		  num get h { return _h; }
		  void set h(num value_)
		{
			_h = value_;
			update_flg = true;
		}
		/**
		 * 色の 色相(Hue) 値を、色相環上のラジアン( 0～2PI )で示します.<br/>
		 * 0 が赤、2PI/3 が緑、4PI/3 が青になります. 
		 */
		  num get hr { return PI*_h / 180; }
		  void set hr(num value_)
		{
			_h = 180*value_/PI;
			update_flg = true;
		}
		
		/**
		 * 色の 彩度(Saturation) 値を示します.<br/>
		 * 有効な値は 0.0 ～ 1.0 です.デフォルト値は 1 です.
		 */
		  num get s { return _s; }
		  void set s(num value_)
		{
			_s = /*Math.*/max( 0.0, /*Math.*/min( 1.0, value_ ) );
			update_flg = true;
		}
		
		/**
		 * 色の 明度(Value・Brightness) 値を示します.<br/>
		 * 有効な値は 0.0 ～ 1.0 です.デフォルト値は 1 です.
		 */
		  num get v { return _v; }
		  void set v(num value_)
		{
			_v = /*Math.*/max( 0.0, /*Math.*/min( 1.0, value_ ) );
			update_flg = true;
		}
		
		//---------------------------------------------------------------------------------------------------SET
		
		/**
		 * HSV値で色を指定します.
		 * @param	h_	Hue (degree 360)
		 * @param	s_	Saturation [0.0,1.0]
		 * @param	v_	Brightness [0.0,1.0]
		 */
		  void hsv(num h_,[num s_=1.0, num v_=1.0 ])
		{
			_h = h_;
			_s = /*Math.*/max( 0.0, /*Math.*/min( 1.0, s_ ) );
			_v = /*Math.*/max( 0.0, /*Math.*/min( 1.0, v_ ) );
			update_flg = true;
		}
		
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
			update_hsv();
		}
		
		/**
		 * グレイ値で色を指定します.
		 * @param	gray_	Gray [0,255]
		 */
		  void gray(int gray_)
		{
			_h = 0.0;
			_s = 0.0;
			_v = _r = _g = _b = gray_ ~/ 0xff;
		}
		
		//---------------------------------------------------------------------------------------------------CONVERT
		
		/**
		 * HSV 値を RGB 値に変換して ColorRGB クラスのインスタンスを生成します.
		 */
		  ColorRGB toRGB()
		{
			if ( update_flg )
				update();
			return new ColorRGB( _r, _g, _b, _alpha );
		}
		
		/**
		 * RGB値から ColorHSV クラスのインスタンスを生成します.
		 * @param	r_	Red [0,255]
		 * @param	g_	Green [0,255]
		 * @param	b_	Blue [0,255]
		 * @param	a	Alpha [0.0,1.0]
		 */
		 static  ColorHSV fromRGB(int r_,int g_,int b_,[num a=1.0 ])
		{
			ColorHSV c = new ColorHSV( 0, 1, 1, a );
			c.rgb( r_, g_, b_ );
			return c;
		}
		
		//---------------------------------------------------------------------------------------------------UPDATE RGB
		
		/**
		 * HSV値をRGB値に変換します
		 * @
		 */
		  void update()
		{
			update_flg = false;
			if ( _s == 0 )
			{
				_r = _g = _b = ( _v * 0xff ).round();
			}
			else
			{
				num ht = _h;
				ht = (((ht %= 360) < 0) ? ht + 360 : ht )/60;
				num vt = /*Math.*/max( 0, /*Math.*/min( 0xff, _v*0xff ) );
				int hi = ( ht ).floor();
				
				switch( hi )
				{
					case 0:
						_r = vt;
						_g = ( vt * ( 1 - (1 - ht + hi) * _s ) ).round();
						_b = ( vt * ( 1 - _s ) ).round();
						break;
					case 1:
						_r = ( vt * ( 1 - _s * ht + _s * hi ) ).round();
						_g = vt;
						_b = ( vt * ( 1 - _s ) ).round();
						break;
					case 2:
						_r = ( vt * ( 1 - _s ) ).round();
						_g = vt;
						_b = ( vt * ( 1 - (1 - ht + hi) * _s ) ).round();
						break;
					case 3:
						_r = ( vt * ( 1 - _s ) ).round();
						_g = ( vt * ( 1 - _s * ht + _s * hi ) ).round();
						_b = vt;
						break;
					case 4:
						_r = ( vt * ( 1 - (1 - ht + hi) * _s ) ).round();
						_g = ( vt * ( 1 - _s ) ).round();
						_b = vt;
						break;
					case 5:
						_r = vt;
						_g = ( vt * ( 1 - _s ) ).round();
						_b = ( vt * ( 1 - _s * ht + _s * hi ) ).round();
						break;
				}
			}
		}
		
		/**
		 * RGB値をHSV値に変換します
		 * @
		 */
		  void update_hsv()
		{
			num maxi = /*Math.*/max( _r , /*Math.*/max( _g, _b ) );
			num mini = /*Math.*/min( _r , /*Math.*/min( _g, _b ) );
			num mm  = maxi - mini;
			
			if ( mm == 0 )
			{
				_h = 0;
				_s = 0;
				_v = maxi / 0xff;
			}
			else
			{
				_s = mm / maxi;
				_v = maxi / 0xff;
				if ( _r == maxi )
					_h = 60 * ( _g - _b ) / mm;
				else if ( _g == maxi )
					_h = 60 * ( _b - _r ) / mm + 120;
				else
					_h = 60 * ( _r - _g ) / mm + 240;
			}
		}
		
		//---------------------------------------------------------------------------------------------------STRING, VALUE
		
		  String toString() 
		{
			return "[HSV(" + _h.toStringAsFixed(2) + "," + _s.toStringAsFixed(2) + "," + _v.toStringAsFixed(2) + ")A("+ _alpha.toStringAsFixed(2)+")]";
		}
		
		/**
		 * @return 0xRRBBGG
		 */
		  int valueOf() 
		{
			return value;
		}
		
		/**
		 * ColorHSV　インスタンスのクローンを生成します.
		 */
		  ColorHSV clone()
		{
			return new ColorHSV( _h, _s, _v, _alpha );
		}
	}

