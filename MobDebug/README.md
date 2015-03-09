# MobDebug

Alright, if you got to this point it is likely that something doesn't quite work as expected in your script, or you're simply curious and want to learn new stuff.
Either ways, let's get ahead, and see what's this about.

## What and why?

On *Wikipedia* there is a whole [*category* about debugging](http://en.wikipedia.org/wiki/Debugging), so perhaps it's worth using some tools developed for aiding with this process rather then using `print()` and `io.read()` statements scattered all around the code.

## Installation

First thing first. We need to install our debugger, otherwise you won't be able to experiment alongside.
All you need to do is type

```bash
luarocks install mobdebug
```

## Let's debug!

In order to understand the different functionalities that *MobDebug* offers, we're going to debug, step by step, a simple *Lua* script.
(The script itself can be found at [`src/test.lua`](src/test.lua), and it has been borrowed from [*remdebug*](https://github.com/LuaDist/remdebug) [test script](https://github.com/LuaDist/remdebug/blob/master/tests/test.lua).)

```lua
 1   require('mobdebug').start()
 2
 3   local tab = {
 4      foo = 1,
 5      bar = 2
 6   }
 7
 8   print("Start")
 9
10   function bar()
11      print("In bar 1")
12      print("In bar 2")
13   end
14
15   for i = 1, 10 do
16      print("Loop")
17      bar()
18      tab.foo = tab.foo * 2
19   end
20
21   print("End")
```
