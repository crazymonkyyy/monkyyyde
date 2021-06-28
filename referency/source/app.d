import raylib;

void main(string[] s){
	InitWindow(1, 1, "referency");
	import std.string;
	auto s_=s[1].toStringz;
	auto image=LoadTexture(s_);
	SetWindowSize(image.width,image.height);
	import std.conv;
	SetWindowPosition(s[2].to!int-image.width/2,s[3].to!int-image.height/2);
		BeginDrawing();
		DrawTexture(image,0,0,WHITE);
		EndDrawing();
	SetTargetFPS(1);
	int timer=s[4].to!int;
	while (!WindowShouldClose()&&timer !=0){
		BeginDrawing();
		DrawTexture(image,0,0,WHITE);
		EndDrawing();
		if(timer>0){--timer;}
	}
	CloseWindow();
}