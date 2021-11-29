void main(){
	import std.stdio;
	import std.string;
	import std.algorithm;
	import std.conv;//sure would suck if the std didnt have conflicts -__-
	import std.range;
	foreach(s;File("input").byLine.map!(to!dstring).stride(2)){
		if(s.any!("a=='*'")) break;
		if(s.length>3){
			dchar f(dchar c){
				if(c=='@')return '"';
				return c;
			}
			s.map!f.writeln;
		}
		else{writeln();}
	}
}
