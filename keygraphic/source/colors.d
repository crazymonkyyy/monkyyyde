import raylib;

struct hex{
	ubyte i;alias i this;
	static auto chararray(){
		struct char_iter{
			char start;
			char end;
			auto front(){return start;}
			auto popFront(){start++;}
			auto empty(){return start>end;}
		}
		import std.range; import std.array;
		return chain(char_iter('0','9'),char_iter('A','F')).array;
	}
	enum lookup=chararray();
	string to(T:string)(){
		return [lookup[i/16],lookup[i%16]];
	}
	this(string s){
		if(s.length==2){
			import std.algorithm; import std.ascii;
			i =cast(ubyte)(lookup.countUntil(s[0].toUpper)*16);
			i+=cast(ubyte)(lookup.countUntil(s[1].toUpper));
	}}
	this(ubyte j){i=j;}
	this(int j){i=cast(ubyte)j;}
	this(float f){
		if(f>1.0){
			this = hex(cast(int)(f));}
		else{
			this = hex(cast(int)(f*ubyte.max));}
	}
}
unittest{
	foreach(i;0..255){
		assert(i==hex(hex(i).to!string));
}}
struct color{
	hex r;
	hex g;
	hex b;
	string to(T:string)(){
		import std.conv;
		return r.to!string~g.to!string~b.to!string;
	}
	this(T)(T[3] t){
		r=hex(t[0]);
		g=hex(t[1]);
		b=hex(t[2]);
	}
	this(T:string)(T s){//see strangepaths.d
		if(s=="red"   ){s="f92672";}//https://github.com/callerc1/base16-hardcore-scheme/blob/master/hardcore.yaml
		if(s=="orange"){s="fd971f";}
		if(s=="yellow"){s="e6db74";}
		if(s=="green" ){s="a6e22e";}
		if(s=="cyan"  ){s="708387";}
		if(s=="blue"  ){s="66d9ef";}
		if(s=="purple"){s="9e6ffe";}
		if(s=="brown" ){s="e8b882";}
		if(s.length==6){
			r=hex([s[0],s[1]]);
			g=hex([s[2],s[3]]);
			b=hex([s[4],s[5]]);
		}
	}
	auto toraylib(){
		return Color(r,g,b,255);
	}
}
enum hexcodes=[
"212121",
"303030",
"353535",
"4A4A4A",
"707070",
"cdcdcd",
"e5e5e5",
"ffffff",
"f92672",
"fd971f",
"e6db74",
"a6e22e",
"708387",
"66d9ef",
"9e6ffe",
"e8b882"]; 
auto gencolors(){
	Color[] o;
	foreach(e;hexcodes){
		o~=color(e).toraylib;
	}
	return o;
}
enum mycolors=gencolors;