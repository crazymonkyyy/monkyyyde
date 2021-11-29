void main(){
	import std.stdio;
	import std.string;
	import std.algorithm;
	import std.range;
	import std.string;
	import std.conv;//sure would suck if the std didnt have conflicts -__-
	
	auto list1=File("list1").byLineCopy.front.split(" ");
	auto list2=File("list2").byLineCopy;
	
	foreach(a,b;zip(list1,list2)){
		string a_=a;
		string b_="{>}{#"~b~"}";
		enum ap=true;
		enum bp=true;
		if(ap){a_=cast(string)['"']~a_~'"';}
		if(bp){b_=cast(string)['"']~b_~'"';}
		writeln(a_~":"~b_~",");
	}
}