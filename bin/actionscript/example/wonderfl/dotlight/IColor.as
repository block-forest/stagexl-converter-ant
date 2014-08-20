package example.wonderfl.dotlight {
	/**
	 * @author nilsdoehring
	 */
	public interface IColor 
	{
		/**
		 * 24bit Color (0xRRGGBB) を示します.
		 */
		function get value():uint;
		function set value( value_:uint ):void;
		
		/**
		 * 32bit Color (0xAARRGGBB) を示します.
		 */
		function get value32():uint;
		function set value32( value_:uint ):void;
		
		/**
		 * 色の 赤(Red) 値を示します.
		 */
		function get r():uint;
		function set r( value_:uint ):void;
		
		/**
		 * 色の 緑(Green) 値を示します.
		 */
		function get g():uint;
		function set g( value_:uint ):void;
		
		/**
		 * 色の 青(Blue) 値を示します.
		 */
		function get b():uint;
		function set b( value_:uint ):void;
		
		/**
		 * 色の 透明度(Alpha) 値を示します.
		 */
		function get alpha():Number;
		function set alpha( value_:Number ):void;
		
		/**
		 * 色の 透明度(Alpha) 値を 0～255 で示します.
		 */
		function get alpha8():uint;
		function set alpha8( value_:uint ):void;
		
	}
}
