import raylib;
import std.string;
import std.process;
string exe(string input){
	auto config=Config.stderrPassThrough;
	return input.executeShell(null,config).output[0..$-1];
}
void main(){
	InitWindow(800, 600, "Hello, Raylib-D!");
	SetWindowPosition(2000,0);
	string hello;
	import settingv2; import std.stdio;
	mixin setup!"config";
	reload!"config";

	while (!WindowShouldClose()){with(KeyboardKey){
		BeginDrawing();
		SetTargetFPS(60);
		ClearBackground(RAYWHITE);
			if(IsKeyPressed(KEY_F1)){
				hello="zenity --entry".exe;
				save!"config";
			}
			DrawText(hello.toStringz, 100, 0, 28, BLACK);
			DrawFPS(10,10);
		EndDrawing();
	}}
	CloseWindow();
}