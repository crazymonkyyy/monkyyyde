quick and dirty program to pop up references/cheat sheets imgs

probs use it with sxhkd or another hotkey system that has some complex commands

the important lines in my sxhkd config currently are 
```
mod3 + f; mod3 +{1-9,0} ; mod3 + {q,a,z}
  monkyyyde/referency/referency monkyyyde/steno/{1-9,0}.png 2000 500 {5,1,-1}

mod3 + f; {1-9,0} 
  	monkyyyde/referency/referency monkyyyde/steno/{1-9,0}.png 2200 500 3
```

syntax is 
```
  image(maybe stick with pngs) x y time-til-disapears(-1 for indefinate)
```