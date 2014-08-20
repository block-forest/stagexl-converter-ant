 part of dotlight;
	/**
	 * @author nilsdoehring
	 */
	 abstract class IColor 
	{
		/**
		 * 24bit Color (0xRRGGBB) を示します.
		 */
		 int get value;
		 void set value(int value_);
		
		/**
		 * 32bit Color (0xAARRGGBB) を示します.
		 */
		 int get value32;
		 void set value32(int value_);
		
		/**
		 * 色の 赤(Red) 値を示します.
		 */
		 int get r;
		 void set r(int value_);
		
		/**
		 * 色の 緑(Green) 値を示します.
		 */
		 int get g;
		 void set g(int value_);
		
		/**
		 * 色の 青(Blue) 値を示します.
		 */
		 int get b;
		 void set b(int value_);
		
		/**
		 * 色の 透明度(Alpha) 値を示します.
		 */
		 num get alpha;
		 void set alpha(num value_);
		
		/**
		 * 色の 透明度(Alpha) 値を 0～255 で示します.
		 */
		 int get alpha8;
		 void set alpha8(int value_);
		
	}

