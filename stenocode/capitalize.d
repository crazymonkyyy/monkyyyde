void main(){
	import std.stdio;
	import std.string;
	import std.algorithm;
	import std.conv;//sure would suck if the std didnt have conflicts -__-
	foreach(s;File("input").byLine.map!(to!dstring)){
		if(s.length>3){
			auto i=s.indexOf("&");
			writeln(s[0..i+1],s[i+1].toUpper,s[i+2..$]);
		}
		else{writeln();}
	}
}
