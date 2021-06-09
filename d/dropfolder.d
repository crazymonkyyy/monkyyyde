void main(string[] s){
  import std.stdio;
  ulong j=0;
  foreach(i,c;s[1]){
    if(c=='/'){j=i;}
  }
  writeln(s[1][j+1..$]);
}