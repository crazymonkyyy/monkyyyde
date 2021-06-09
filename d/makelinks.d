void main(){
  import std.process;
  import std.stdio;
  enum command=
    "zenity --file-selection --filename=$PWD/ --multiple";
  string files=executeShell(command).output[0..$-1];//endline char bad
  struct inter{
    string full;
    string local;
    this(string a){
      full=a;
      ulong j=0;
      foreach(i,c;a){
        if(c=='/'){j=i;}
      }
      local=a[j+1..$];
    }
  }
  auto f(string a){return inter(a);}
  import std.algorithm; 
  auto processed=files.splitter('|').map!f;
  //processed.writeln;
  enum command2=
    "zenity --file-selection --filename=$PWD --directory";//moved up one dir by droping /
  string where=executeShell(command2).output[0..$-1];
  //where.writeln;
  auto g(inter a){
    //writeln("ln "~a.full~" "~where~"/"~a.local);
    spawnShell("ln "~a.full~" "~where~"/"~a.local);
  }
  processed.each!g;
}