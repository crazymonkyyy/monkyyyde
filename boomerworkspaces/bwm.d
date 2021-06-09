import std.file;
import std.conv;
import std.process;
import std.stdio: writeln;// curse the std writers and thier children for thier namespace conflict
struct state_{
	enum a='a';
	enum b='b';
	char[10] depths=[b,b,b,b,b, b,b,b,b,b];
	char[10] last1=[a,a,a,a,a, a,a,a,a,a];
	char[10] last2=[b,b,b,b,b, b,b,b,b,b];
	
	int c_n1=1;
	int c_n2=1;
	char c_d1=a;
	char c_d2=b;
}
void poke(ref char d, ref int n, ref char[10] mine, ref char[10] notmine,ref char[10] depths){
	if(d==depths[n]) d=char('a'-1);
	d++;
	if(d==notmine[n]){ 
		if(d==depths[n]) d=char('a'-1);
		d++;
	}
	mine[n]=d;
}
void main(string[] input){
	import setting;
	string monitor1;
	string monitor2;
	mixin setup!(".config/bwm");
	reload!".config/bwm";
	state_ s;
	with(s){
		void poke1(){poke(c_d1,c_n1,last1,last2,depths);}
		void poke2(){poke(c_d2,c_n2,last2,last1,depths);}
	
	//void say1(){ ("moving to "~c_n1.to!string~c_d1.to!string).writeln;}
	//void say2(){ ("moving to "~c_n2.to!string~c_d2.to!string).writeln;}
	//void make1(){}
	//void make2(){}
	//void send(int n,char d){writeln("sending to ",n,d);}
	
	void say1(){
		alias monitor=monitor1;
		string desktop=c_n1.to!string~c_d1.to!string;
		string cmd="bspc desktop "~desktop~" -m "~monitor;
		string cmd2="bspc desktop -f "~desktop;
		string cmd3=cmd~" ; "~cmd2;
		spawnShell(cmd3);
	}
	void say2(){
		alias monitor=monitor2;
		string desktop=c_n2.to!string~c_d2.to!string;
		string cmd="bspc desktop "~desktop~" -m "~monitor;
		string cmd2="bspc desktop -f "~desktop;
		string cmd3=cmd~" ; "~cmd2;
		spawnShell(cmd3);
	}
	void make1(){
		alias monitor=monitor1;
		string desktop=c_n1.to!string~c_d1.to!string;
		string cmd="bspc monitor "~monitor~" -a "~desktop;
		spawnShell(cmd);
	}
	void make2(){
		alias monitor=monitor2;
		string desktop=c_n2.to!string~c_d2.to!string;
		string cmd="bspc monitor "~monitor~" -a "~desktop;
		spawnShell(cmd);
	}
	void send(int n,char d){
		string desktop=n.to!string~d.to!string;
		string cmd="bspc node -d "~desktop;
		spawnShell(cmd);
	}
	
	if(input[1]!="setup"){
		spawnShell("bspc monitor "~monitor1~" -d 1a 2a 3a 4a 5a 6a 7a 8a 9a 0a");
		spawnShell("bspc monitor "~monitor2~" -d 1b 2b 3b 4b 5b 6b 7b 8b 9b 0b");
		s= ( cast(state_[]) read("temp") )[0];}
	if(input[1]=="poke"){
		if(input[2]=="main"){poke1;say1;}
		else{poke2;say2;}
	}
	if(input[1]=="switch"){
		if(input[2]=="main"){
			c_n1=input[3].to!int%10;
			c_d1=last1[c_n1];
			say1;
		}else{
			c_n2=input[3].to!int%10;
			c_d2=last2[c_n2];
			say2;
		}
	}
	if(input[1]=="add"){
		if(input[2]=="main"){
			depths[c_n1]++;
			c_d1=depths[c_n1];
			last1[c_n1]=c_d1;
			make1;
			say1;
		}else{
			depths[c_n2]++;
			c_d2=depths[c_n2];
			last2[c_n2]=c_d2;
			make2;
			say2;
		}
	}
	if(input[1]=="hide"){
		if(input[2]=="main"){
			if(c_d1==depths[c_n1]){
				c_d1='a'; say1;}
			depths[c_n1]--;
		}else{
			if(c_d2==depths[c_n2]){
				c_d2='a'; say2;}
			depths[c_n2]--;
		}
	}
	if(input[1]=="move"){
		if(input[2]=="main"){
			int n=input[3].to!int%10;
			send(n,last1[n]);
		}else{
			int n=input[3].to!int%10;
			send(n,last2[n]);
		}
	}
	
	s.writeln("montors:",monitor1,",",monitor2);
	write("temp",[s]);
}}