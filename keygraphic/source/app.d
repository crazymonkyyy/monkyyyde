import raylib;
import std.string;
import std.process;
import colors;
int textoffsetx;
int textoffsety;
int textsize;
int textcolor;
Font thefont;
enum int[] chars_=['★','☆','ɑ','𝟙','𝟚','𝟛','𝟜','”'];
//button and these varables should be in main honestly, but compile bugs related to frame issues mean its in golbal scope
struct button{
	int x;int y;
	int w; int h;
	int strange;
	string s;
	int color;
	void draw(){
		if(strange>0){
			switch(strange){
				case 1:
					DrawRectangleLines(x,y,w,h,mycolors[color%64]);
					break;
				case 2:
					auto rec=Rectangle(x,y,w,h);
					auto ori=Vector2(w/2,h/2);
					DrawRectanglePro(rec,ori,135,mycolors[color%64]);
					auto textvec=MeasureTextEx(thefont,s.toStringz,textsize,1);
					Vector2 offset=Vector2(textoffsetx,textoffsety);
					offset.x=0-textvec.x/2;
					offset.y=0-textvec.y/2;
					DrawTextEx(thefont,s.toStringz,Vector2(x,y)+offset,textsize,1,mycolors[textcolor]);
					break;
				default:
				break;
			}
		}else{
			if(color>64){
				int maincolor=color%64;
				int sndarycolor=(color/64)%64;
				enum squ=64*64;
				int mode=(color/squ)%squ;
				auto v1=Vector2(x+0,y+0);
				auto v2=Vector2(x+w,y+0);
				auto v3=Vector2(x+0,y+h);
				auto v4=Vector2(x+w,y+h);
				if(mode==0){
					DrawTriangle(v1,v3,v2,mycolors[maincolor]);
					DrawTriangle(v4,v2,v3,mycolors[sndarycolor]);
				}else{
					DrawTriangle(v1,v3,v4,mycolors[maincolor]);
					DrawTriangle(v4,v2,v1,mycolors[sndarycolor]);
				}
			}else{
				DrawRectangle(x,y,w,h,mycolors[color]);
			}
			//DrawText(s.toStringz,x+textoffsetx,y+textoffsety,textsize,mycolors[textcolor]);
			auto textvec=MeasureTextEx(thefont,s.toStringz,textsize,1);
			Vector2 offset=Vector2(textoffsetx,textoffsety);
			if(textvec.x<w){
				offset.x=(w/2)-(textvec.x/2);
			}
			if(textvec.y/2<h){
				offset.y=(h/2)-(textvec.y/2);
			}
			DrawTextEx(thefont,s.toStringz,Vector2(x,y)+offset,textsize,1,mycolors[textcolor]);
	}}
	bool click(){
		return
			GetMouseX>x  &&
			GetMouseY>y  &&
			GetMouseX<x+w&&
			GetMouseY<y+h;
	}
}
string exe(string input){//"make the annoying gtk warnings in zenity go away, mmmk?" the function
	auto config=Config.stderrPassThrough;
	return input.executeShell(null,config).output[0..$-1];
}
void main(string[] commandlineinput){
	import settingv2; import std.stdio;
	button[] buttons;
	int windowx; int windowy; int backgroundcolor;
	mixin setup!"data";
	reload!"data"(commandlineinput[1]);
	void savedata(){
		save!"data"(commandlineinput[1]);
	}
	
	InitWindow(windowx, windowy, "Hello, Raylib-D!");
	SetWindowPosition(2000,0);
	import std.conv;
	int[] count(int i,int j){
		int[] o;
		foreach(a;i..j){o~=a;}
		return o;
	}

	enum int[] chars= count(32,126)~chars_;
	mixin setup!"config";
	reload!"config";
	
	button grid;//it has a w and h already defined
	button tool;
	mixin setup!"tool";
	reload!"tool";
	tool.s="!";
	int oldx;int oldy;
	button*[] activebuttons;
	string mode="A";
	enum string[] modes=["A","P","M","R","C","S"];
	
	SetTargetFPS(60);
	thefont=LoadFontEx("SymbolaRegular.ttf".toStringz,textsize,&chars[0],chars.length.to!int);
	while (!WindowShouldClose()){with(KeyboardKey){
		BeginDrawing();
		ClearBackground(mycolors[backgroundcolor]);
			//tool
			if(IsKeyPressed(KEY_SPACE)){
				reload!"tool";
			}
			button temp=tool;
			temp.x=(GetMouseX/grid.w)*grid.w+grid.x;
			temp.y=(GetMouseY/grid.h)*grid.h+grid.y;
			temp.draw;
			if(IsKeyPressed(KEY_F5)){ savedata;}
			//modes
			static foreach(c;modes){
				if(IsKeyPressed(mixin("KEY_"~c))){
					mode=c;}}
			switch (mode){
				case "A":if(IsMouseButtonPressed(0)){buttons~=temp;} break;
				case "P":
					foreach(ref e;buttons){
						if(e.click&&IsMouseButtonPressed(0)){
							e.color=tool.color;e.strange=tool.strange;
						}}
					break;
				case "S":
					foreach(ref e;buttons){
						if(e.click&&IsMouseButtonPressed(0)){e.s="zenity --entry".exe;}}
					break;
				case "M":
					if(IsMouseButtonPressed(0)){
						if(IsKeyDown(KEY_LEFT_CONTROL)){activebuttons=[];}
						if(IsKeyDown(KEY_LEFT_ALT)||IsKeyDown(KEY_RIGHT_ALT)){
							foreach(ref e;buttons){
								if(e.click){activebuttons~=&e;}
						}}else{
							oldx=GetMouseX;
							oldy=GetMouseY;
					}}
					if(IsMouseButtonReleased(0)&& ! (IsKeyDown(KEY_LEFT_ALT)||IsKeyDown(KEY_RIGHT_ALT))){
						foreach(e;activebuttons){
							(*e).x=(((*e).x+(GetMouseX-oldx))/grid.w)*grid.w+grid.x;
							(*e).y=(((*e).y+(GetMouseY-oldy))/grid.h)*grid.h+grid.y;
					}}
					break;
				case "C":
					if(IsMouseButtonPressed(0)){
						if(IsKeyDown(KEY_LEFT_CONTROL)){activebuttons=[];}
						if(IsKeyDown(KEY_LEFT_ALT)||IsKeyDown(KEY_RIGHT_ALT)){
							foreach(ref e;buttons){
								if(e.click){activebuttons~=&e;}
					}}}
					if(IsMouseButtonReleased(0)&& ! (IsKeyDown(KEY_LEFT_ALT)||IsKeyDown(KEY_RIGHT_ALT))){
						oldx=int.max; oldy=int.max;
						foreach(ref e;activebuttons){
							import std.algorithm; 
							oldx=min(oldx,e.x);
							oldy=min(oldy,e.y);
						}
						foreach(ref e; activebuttons){
							button temp_=*e;
							temp_.x=(((*e).x+(GetMouseX-oldx))/grid.w)*grid.w+grid.x;
							temp_.y=(((*e).y+(GetMouseY-oldy))/grid.h)*grid.h+grid.y;
							buttons~=temp_;
						}
					}
					break;
				case "R":
					if(IsMouseButtonPressed(0)){
						foreach(ref e;buttons){
							if(e.click){
								e=buttons[$-1];
								buttons.length-=1;
					}}}
					break;
				default: assert(0);
			}
			//draw
			foreach(e;buttons){e.draw;}
			//DrawFPS(10,10);
			//DrawTextEx(thefont,"hi★",Vector2(textoffsetx,textoffsety),64,1,mycolors[textcolor]);
		EndDrawing();
	}}
	CloseWindow();
}
