/**
Title:			Perlin noise
Version:		1.2
Author:			Ron Valstar
Author URI:		http://www.sjeiti.com/
Original code port from http://mrl.nyu.edu/~perlin/noise/
and some help from http://freespace.virgin.net/hugo.elias/models/m_perlin.htm
AS3 optimizations by Mario Klingemann http://www.quasimondo.com
*/
 part of dotlight;
	
	class OptimizedPerlin {
		
		 static final List p = [	
					151,160,137,91,90,15,131,13,201,95,
					96,53,194,233,7,225,140,36,103,30,69,
					142,8,99,37,240,21,10,23,190,6,148,
					247,120,234,75,0,26,197,62,94,252,
					219,203,117,35,11,32,57,177,33,88,
					237,149,56,87,174,20,125,136,171,
					168,68,175,74,165,71,134,139,48,27,
					166,77,146,158,231,83,111,229,122,
					60,211,133,230,220,105,92,41,55,46,
					245,40,244,102,143,54,65,25,63,161,
					1,216,80,73,209,76,132,187,208,89,
					18,169,200,196,135,130,116,188,159,
					86,164,100,109,198,173,186,3,64,52,
					217,226,250,124,123,5,202,38,147,118,
					126,255,82,85,212,207,206,59,227,47,
					16,58,17,182,189,28,42,223,183,170,
					213,119,248,152,2,44,154,163,70,221,
					153,101,155,167,43,172,9,129,22,39,
					253,19,98,108,110,79,113,224,232,
					178,185,112,104,218,246,97,228,251,
					34,242,193,238,210,144,12,191,179,
					162,241,81,51,145,235,249,14,239,
					107,49,192,214,31,181,199,106,157,
					184,84,204,176,115,121,50,45,127,4,
					150,254,138,236,205,93,222,114,67,29,
					24,72,243,141,128,195,78,66,215,61,
					156,180,151,160,137,91,90,15,131,13,
					201,95,96,53,194,233,7,225,140,36,
					103,30,69,142,8,99,37,240,21,10,23,
					190,6,148,247,120,234,75,0,26,197,
					62,94,252,219,203,117,35,11,32,57,
					177,33,88,237,149,56,87,174,20,125,
					136,171,168,68,175,74,165,71,134,139,
					48,27,166,77,146,158,231,83,111,229,
					122,60,211,133,230,220,105,92,41,55,
					46,245,40,244,102,143,54,65,25,63,
					161,1,216,80,73,209,76,132,187,208,
					89,18,169,200,196,135,130,116,188,
					159,86,164,100,109,198,173,186,3,64,
					52,217,226,250,124,123,5,202,38,147,
					118,126,255,82,85,212,207,206,59,
					227,47,16,58,17,182,189,28,42,223,
					183,170,213,119,248,152,2,44,154,
					163,70,221,153,101,155,167,43,172,9,
					129,22,39,253,19,98,108,110,79,113,
					224,232,178,185,112,104,218,246,97,
					228,251,34,242,193,238,210,144,12,
					191,179,162,241,81,51,145,235,249,
					14,239,107,49,192,214,31,181,199,
					106,157,184,84,204,176,115,121,50,
					45,127,4,150,254,138,236,205,93,
					222,114,67,29,24,72,243,141,128,
					195,78,66,215,61,156,180];
					
		 static int iOctaves = 4;
		 static num fPersistence = .5;
		//
		 static List aOctFreq = []; // frequency per octave
		 static List aOctPers = []; // persistence per octave
		 static num fPersMax = 0;// 1 / max persistence
		//
		 static int iSeed = 123;
		
		 static num iXoffset = 0;
		 static num iYoffset = 0;
		 static num iZoffset = 0;
		
		 static final num baseFactor = 1 / 64;
			
		 static bool initialized = false;
		
		//
		// PUBLIC
		 static num noise(num xa, [num ya = 1, num za = 1]) 
		{
			if ( !initialized ) init();
			
			num s = 0;
			num fFreq=0, fPers=0, x=0, y=0, z=0;
			num xf=0, yf=0, zf=0, u=0, v=0, w=0;
			num x1=0, y1=0, z1=0;
			int X=0, Y=0, Z=0, A=0, B=0, AA=0, AB=0, BA=0, BB=0, hash=0;
			num g1=0, g2=0, g3=0, g4=0, g5=0, g6=0, g7=0, g8=0;
			
			xa += iXoffset;
			ya += iYoffset;
			za += iZoffset;
			
			for (int i = 0;i<iOctaves;i++) 
			{
				fFreq = (aOctFreq[i]);
				fPers = (aOctPers[i]);
				
				x = xa * fFreq;
				y = ya * fFreq;
				z = za * fFreq;
				
				xf = (x).floor();
				yf = (y).floor();
			 	zf = (z).floor();
			
				X = xf.toInt() & 255;
			 	Y = yf.toInt() & 255;
			 	Z = zf.toInt() & 255;
			
				x -= xf;
				y -= yf;
				z -= zf;
			
			 	u = x * x * x * (x * (x*6 - 15) + 10);
			 	v = y * y * y * (y * (y*6 - 15) + 10);
			 	w = z * z * z * (z * (z*6 - 15) + 10);
			
			 	A  =((p[X]).toInt()) + Y; 
			 	AA =((p[A]).toInt()) + Z;
			 	AB =(p[(A+1).toInt()]) + Z;
			 	B  =(p[(X+1).toInt()]) + Y;
			 	BA =(p[B]).toInt() + Z;
			 	BB =(p[(B+1).toInt()]) + Z;
			
			 	x1 = x-1;
			 	y1 = y-1;
			 	z1 = z-1;
			
			 	hash =(p[(BB+1).toInt()]) & 15;
				g1 = ((hash&1) == 0 ? (hash<8 ? x1 : y1) : (hash<8 ? -x1 : -y1)) + ((hash&2) == 0 ? hash<4 ? y1 : ( hash==12 ? x1 : z1 ) : hash<4 ? -y1 : ( hash==14 ? -x1 : -z1 ));
			
				hash =(p[(AB+1).toInt()]) & 15;
				g2 = ((hash&1) == 0 ? (hash<8 ? x  : y1) : (hash<8 ? -x  : -y1)) + ((hash&2) == 0 ? hash<4 ? y1 : ( hash==12 ? x  : z1 ) : hash<4 ? -y1 : ( hash==14 ? -x : -z1 ));
			
				hash =(p[(BA+1).toInt()]) & 15;
				g3 = ((hash&1) == 0 ? (hash<8 ? x1 : y ) : (hash<8 ? -x1 : -y )) + ((hash&2) == 0 ? hash<4 ? y  : ( hash==12 ? x1 : z1 ) : hash<4 ? -y  : ( hash==14 ? -x1 : -z1 ));
			
				hash =(p[(AA+1).toInt()]) & 15;
				g4 = ((hash&1) == 0 ? (hash<8 ? x  : y ) : (hash<8 ? -x  : -y )) + ((hash&2) == 0 ? hash<4 ? y  : ( hash==12 ? x  : z1 ) : hash<4 ? -y  : ( hash==14 ? -x  : -z1 ));
			
				hash =((p[BB]).toInt()) & 15;
				g5 = ((hash&1) == 0 ? (hash<8 ? x1 : y1) : (hash<8 ? -x1 : -y1)) + ((hash&2) == 0 ? hash<4 ? y1 : ( hash==12 ? x1 : z  ) : hash<4 ? -y1 : ( hash==14 ? -x1 : -z  ));
			
				hash =((p[AB]).toInt()) & 15;
				g6 = ((hash&1) == 0 ? (hash<8 ? x  : y1) : (hash<8 ? -x  : -y1)) + ((hash&2) == 0 ? hash<4 ? y1 : ( hash==12 ? x  : z  ) : hash<4 ? -y1 : ( hash==14 ? -x  : -z  ));
			
				hash =((p[BA]).toInt()) & 15;
				g7 = ((hash&1) == 0 ? (hash<8 ? x1 : y ) : (hash<8 ? -x1 : -y )) + ((hash&2) == 0 ? hash<4 ? y  : ( hash==12 ? x1 : z  ) : hash<4 ? -y  : ( hash==14 ? -x1 : -z  ));
			
				hash =((p[AA]).toInt()) & 15;
				g8 = ((hash&1) == 0 ? (hash<8 ? x  : y ) : (hash<8 ? -x  : -y )) + ((hash&2) == 0 ? hash<4 ? y  : ( hash==12 ? x  : z  ) : hash<4 ? -y  : ( hash==14 ? -x  : -z  ));
				
				g2 += u * (g1 - g2);
				g4 += u * (g3 - g4);
				g6 += u * (g5 - g6);
				g8 += u * (g7 - g8);
				
				g4 += v * (g2 - g4);
				g8 += v * (g6 - g8);
			
				s += ( g8 + w * (g4 - g8)) * fPers;
			}
			
			return ( s * fPersMax + 1 ) * .5;
		}
		
		 static  void fill(BitmapData bitmap,[num xa = 0, num ya = 0, num za = 0]) 
    {
		   List list = fillList(new Point(bitmap.width, bitmap.height), xa, ya, za);
		   list.forEach((List l) => l.forEach((int l2) => bitmap.setPixel32(list.indexOf(l), l.indexOf(l2), l2)));
    }
		
		 static  List fillList(Point point,[num xa = 0, num ya = 0, num za = 0]) 
		{
			if ( !initialized ) init();
			
			num s = 0;
			num fFreq=0, fPers=0, x=0, y=0, z = 0;
			num xf=0, yf=0, zf=0, u=0, v=0, w = 0;
			num x1=0, y1=0, z1=0, baseX=0, px=0, py = 0;
			int i=0, X=0, Y=0, Z=0, A=0, B=0, AA=0, AB=0, BA=0, BB=0, hash = 0;
			num g1=0, g2=0, g3=0, g4=0, g5=0, g6=0, g7=0, g8 = 0;
			int color = 0;
			
			baseX = xa * baseFactor + iXoffset;
			ya = ya * baseFactor + iYoffset;
			za = za * baseFactor + iZoffset;
			
			int width = point.x;
			int height = point.y;
			
			List list = [];
			List list2 = [];
			
			for ( py = 0; py < height; py++ )
			{
				xa = baseX;
				list2 = [];
				
				for ( px = 0; px < width; px++ )
				{
					s = 0;
					
					for ( i = 0 ; i < iOctaves;i++) 
					{
						fFreq = (aOctFreq[i]);
						fPers = (aOctPers[i]);
						
						x = xa * fFreq;
						y = ya * fFreq;
						z = za * fFreq;
						
						xf = (x).floor();
						yf = (y).floor();
					 	zf = (z).floor();
					
						X = xf.toInt() & 255;
					 	Y = yf.toInt() & 255;
					 	Z = zf.toInt() & 255;
					
						x -= xf;
						y -= yf;
						z -= zf;
					
					 	u = x * x * x * (x * (x*6 - 15) + 10);
					 	v = y * y * y * (y * (y*6 - 15) + 10);
					 	w = z * z * z * (z * (z*6 - 15) + 10);
					
					 	A  =((p[X]).toInt()) + Y; 
					 	AA =((p[A]).toInt()) + Z;
					 	AB =(p[(A+1).toInt()]) + Z;
					 	B  =(p[(X+1).toInt()]) + Y;
					 	BA =(p[B]).toInt() + Z;
					 	BB =(p[(B+1).toInt()]) + Z;
					
					 	x1 = x-1;
					 	y1 = y-1;
					 	z1 = z-1;
					
						hash =(p[(BB+1).toInt()]) & 15;
						g1 = ((hash&1) == 0 ? (hash<8 ? x1 : y1) : (hash<8 ? -x1 : -y1)) + ((hash&2) == 0 ? hash<4 ? y1 : ( hash==12 ? x1 : z1 ) : hash<4 ? -y1 : ( hash==14 ? -x1 : -z1 ));
					
						hash =(p[(AB+1).toInt()]) & 15;
						g2 = ((hash&1) == 0 ? (hash<8 ? x  : y1) : (hash<8 ? -x  : -y1)) + ((hash&2) == 0 ? hash<4 ? y1 : ( hash==12 ? x  : z1 ) : hash<4 ? -y1 : ( hash==14 ? -x : -z1 ));
					
						hash =(p[(BA+1).toInt()]) & 15;
						g3 = ((hash&1) == 0 ? (hash<8 ? x1 : y ) : (hash<8 ? -x1 : -y )) + ((hash&2) == 0 ? hash<4 ? y  : ( hash==12 ? x1 : z1 ) : hash<4 ? -y  : ( hash==14 ? -x1 : -z1 ));
					
						hash =(p[(AA+1).toInt()]) & 15;
						g4 = ((hash&1) == 0 ? (hash<8 ? x  : y ) : (hash<8 ? -x  : -y )) + ((hash&2) == 0 ? hash<4 ? y  : ( hash==12 ? x  : z1 ) : hash<4 ? -y  : ( hash==14 ? -x  : -z1 ));
					
						hash =((p[BB]).toInt()) & 15;
						g5 = ((hash&1) == 0 ? (hash<8 ? x1 : y1) : (hash<8 ? -x1 : -y1)) + ((hash&2) == 0 ? hash<4 ? y1 : ( hash==12 ? x1 : z  ) : hash<4 ? -y1 : ( hash==14 ? -x1 : -z  ));
					
						hash =((p[AB]).toInt()) & 15;
						g6 = ((hash&1) == 0 ? (hash<8 ? x  : y1) : (hash<8 ? -x  : -y1)) + ((hash&2) == 0 ? hash<4 ? y1 : ( hash==12 ? x  : z  ) : hash<4 ? -y1 : ( hash==14 ? -x  : -z  ));
					
						hash =((p[BA]).toInt()) & 15;
						g7 = ((hash&1) == 0 ? (hash<8 ? x1 : y ) : (hash<8 ? -x1 : -y )) + ((hash&2) == 0 ? hash<4 ? y  : ( hash==12 ? x1 : z  ) : hash<4 ? -y  : ( hash==14 ? -x1 : -z  ));
					
						hash =((p[AA]).toInt()) & 15;
						g8 = ((hash&1) == 0 ? (hash<8 ? x  : y ) : (hash<8 ? -x  : -y )) + ((hash&2) == 0 ? hash<4 ? y  : ( hash==12 ? x  : z  ) : hash<4 ? -y  : ( hash==14 ? -x  : -z  ));
				
						g2 += u * (g1 - g2);
						g4 += u * (g3 - g4);
						g6 += u * (g5 - g6);
						g8 += u * (g7 - g8);
						
						g4 += v * (g2 - g4);
						g8 += v * (g6 - g8);
					
						s += ( g8 + w * (g4 - g8)) * fPers;
					}
					
					color =(( ( s * fPersMax + 1 )) * 128 ).toInt();
					//bitmap.setPixel32( px, py, 0xff000000 | color << 16 | color << 8 | color );
					list2.add(0xff000000 | color << 16 | color << 8 | color);
					xa += baseFactor;
				}
				list.add(list2);
                
				ya += baseFactor;
			}
			
			return list;
		}
		
		
		// GETTER / SETTER
		//
		// get octaves
		 static  int get octaves 
		{
			return iOctaves;
		}
		// set octaves
		 static  void set octaves(int _iOctaves) 
		{
			iOctaves = _iOctaves;
			octFreqPers();
		}
		//
		// get falloff
		 static  num get falloff 
		{
			return fPersistence;
		}
		// set falloff
		 static  void set falloff(num _fPersistence) 
		{
			fPersistence = _fPersistence;
			octFreqPers();
		}
		//
		// get seed
		 static  num get seed 
		{
			return iSeed;
		}
		// set seed
		 static  void set seed(num _iSeed) 
		{
			iSeed = _iSeed;
			seedOffset();
		}
		
		//
		// PRIVATE
		 static  void init() 
		{
			seedOffset();
			octFreqPers();
			initialized = true;
		}
		
		
		 static  void octFreqPers() 
		{
			num fFreq, fPers;
			
			aOctFreq = [];
			aOctPers = [];
			fPersMax = 0;
			
			for (int jj=0;jj<iOctaves;jj++) {
				fFreq = pow(2,jj);
				fPers = pow(fPersistence,jj);
				fPersMax += fPers;
				aOctFreq.add( fFreq );
				aOctPers.add( fPers );
			}
			
			fPersMax = 1 / fPersMax;
		}
		
		 static  void seedOffset() 
		{
			iXoffset = iSeed = (iSeed * 16807) % 2147483647;
			iYoffset = iSeed = (iSeed * 16807) % 2147483647;
			iZoffset = iSeed = (iSeed * 16807) % 2147483647;
		}
	}

