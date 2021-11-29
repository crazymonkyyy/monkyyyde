void main(string[] s_){
	import std.stdio;
	import std.string;
	import std.algorithm;
	import std.range;
	import std.string;
	import std.conv;//sure would suck if the std didnt have conflicts -__-
	
	auto list1=File(s_[1]).byLineCopy;
	foreach(s;list1){
		import std.process;
		"rm tempword".executeShell;
		("echo "~s~" >tempword").executeShell;
		"festival --tts tempword".executeShell;
		s.write; " : ".write;
		readln.write;
}}