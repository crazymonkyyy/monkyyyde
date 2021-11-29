void main(string[] s){
	import std.stdio;
	import std.string;
	import std.algorithm;
	import std.range;
	import std.string;
	import std.conv;//sure would suck if the std didnt have conflicts -__-
	
	auto list1=File(s[1]).byLineCopy.array;
	auto list2=File(s[2]).byLineCopy.array;
	int ii;
	string[][string] store;
	foreach(json;list2){//if(json.length>3){
		string copy=json;
		//copy.writeln;
		auto a=copy.find('"');
		auto b=a.drop(1).until('"');
		//b.writeln;
		auto c=copy.find('"').drop(1).find('"').drop(1).find('"').drop(1);
		auto d=c.until('"');
		//d.writeln;
		//ii++;
		//if(ii==115716){
		//	writeln(a,b,c,d);}
		foreach(word;list1){
			if(d.to!string==word){
				//writeln(d,":",b);
				store[word]~=[b.to!string];
		}}
	}
	foreach(i; 0..list1.length){
	foreach(j; 0..list1.length){
		auto key=list1[i];
		auto keyoff=list1[(i+j)%$];
		auto value=store[key];
		//writeln(key,",",keyoff,",",value,",",j);
		foreach(v;value){
			string cycle="/^".repeat(j).joiner.array.to!string;
			writeln('"',v~cycle,'"',": ",'"',keyoff,'"',",");
		}
}}}