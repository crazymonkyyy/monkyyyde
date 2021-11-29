import dson;
import std.traits;
auto myto(T:string,S)(S input){
	import std.stdio;static assert(! is(S==std.stdio.File));
	return cerial!S(input).write;
}
template readline_(string mix){
	import dson;
	void readline(string mix_:mix)(string s){
		static assert(mix!="s","you cant use varibles named s -me");
		assert(s[0..mix.length+1]==mix~"=");
		string leftover=s[mix.length+1..$-1].dup;//why does this dup seem nessrery?
		
		mixin(mix)=cerial!(typeof(mixin(mix)))().read(leftover).payload;//.fixstring;
	}
}
string dropequals(string s){
	import std.string;
	auto i=s.indexOfAny("=");
	return s[0..i];
}
unittest{assert("bar=1;".dropequals=="bar");}
void donothing(){};
template setup(string s,alias errorfunction=donothing){
	auto mixfile(string s_:s)(){
		enum mix=s~".mix";
		return import(mix);
	}
	void copydefaults(string s_:s)(){
		import std.file;
		try{copy(s~".conf",s~".badformating");}
		catch(Throwable){}
		try{remove(s~".conf");}
		catch(Throwable){}
		try{write(s~".conf",mixfile!s);}
		catch(Throwable){}
	}
	import std.string;
	import std.algorithm;
	static foreach(t;mixfile!s.lineSplitter.map!dropequals){
		mixin readline_!t;
	}
	void reload(string s_:s)(string s__=""){
		try{
			if(s__==""){s__=s~".conf";}
			auto file=File(s__).byLine;
			static foreach(t;mixfile!s.lineSplitter.map!dropequals){
				readline!t(cast(string)file.front);
				file.popFront;
			}
		}
		catch(Throwable){
			errorfunction();
			copydefaults!s();
			reload!s();
		}
	}
	void save(string s_:s)(string where=""){
		if(where==""){where=s~".conf";}
		import std.stdio;
		{
			import std.file;
			try{remove(where);}catch(Throwable){}
			try{write(where,null);}catch(Throwable){}
		}
		auto file___=File(where,"w");//there are few things I hate more in this world then single letter names coming back to haunt me
		static foreach(t;mixfile!s.lineSplitter.map!dropequals){//copied from above blindly
			file___.write(t);
			file___.write("=");
			file___.write(mixin(t).myto!string);
			//import std; mixin(t).writeln;
			file___.writeln(";");
	}}
}