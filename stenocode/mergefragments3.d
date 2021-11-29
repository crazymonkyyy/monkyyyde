void main(){
	import std.stdio;
	import std.string;
	import std.algorithm;
	import std.range;
	import std.string;
	import std.conv;//sure would suck if the std didnt have conflicts -__-
	import std.array;
	
	auto list1=File("list1").byLineCopy.map!(a=>a.repeat(3)).joiner.array;//.front.split(" ");
	auto list2=File("list2").byLineCopy.front.repeat(1000);
	//auto list3=File("list3").byLineCopy;
	
	//auto list3=zip(File("list3").byLineCopy,["-L","-T","-LT"].cycle);
	//
	//foreach(a,b;zip(list1,list2)){
	//foreach(c,d;list3){
	foreach(a,b,c,d;zip(list1,list2,File("list3").byLineCopy,["-L","-T","-LT"].cycle)){
		string a_="^"~a~d;
		string b_="{>}{&"~b~c~"}";
		enum ap=true;
		enum bp=true;
		if(ap){a_=cast(string)['"']~a_~'"';}
		if(bp){b_=cast(string)['"']~b_~'"';}
		writeln(a_~":"~b_~",");
	}
}