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

## Run the debugger

```lua
th -e "require('mobdebug').listen()"
```

## Let's debug!

In order to understand the different functionalities that *MobDebug* offers, we're going to debug, step by step, a simple *Lua* script.
(The script itself can be found at [`src/test.lua`](src/test.lua), and it has been borrowed from [*remdebug*](https://github.com/LuaDist/remdebug)'s [testing script](https://github.com/LuaDist/remdebug/blob/master/tests/test.lua).)

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

> Generally speaking, all we need to do is add
>
> ```lua
> require('mobdebug').start()
> ```
>
> at the beginning of the script we want to debug.

So, let's `cd` into [`src`](src) and `th` `test.lua`.

### `run`, `step`, `over` and `out`

`run`, `step`, `over` and `out` are the four commands that allow us to proceed with the execution of the code, tackling line after line. By typing `help` withing the debugger session, we can see what their functions are.

```lua
run    -- runs until next breakpoint
step   -- runs until next line, stepping into function calls
over   -- runs until next line, stepping over function calls
out    -- runs until line after returning from current function
```

---

We can start with `over`, `step`, `step`.

```lua
> over
Paused at file test.lua line 13
> step
Paused at file test.lua line 10
> step
Paused at file test.lua line 15
```

The first `over` gets the program to print `Start`.
The other two `step`s don't have any corresponding output.

Our debugger is waiting for us at the beginning of the `for` loop.
Let's skip to line `17` by setting a *breakpoint* and using `run`.

### Playing with *breakpoints*

To execute the code up to *a specific line* of *a specific file* we can use the breackpoint/run combination.
The instruction to set a breakpoint works as follow

```lua
setb <file> <line>   -- sets a breakpoint
```

To list all available breakpoints, we can write

```lua
listb   -- lists breakpoints
```
To remove a breakpoint or all breakpoints

```lua
delb <file> <line>   -- removes a breakpoint
delallb              -- removes all breakpoints
```

---

Now we are at line `15` and, say, we'd like to skip to line `17`.

```lua
> 15   for i = 1, 10 do
  16      print("Loop")
↳ 17      bar()
```

We are going to type `setb test.lua 17`, or, since we don't link to other scripts, we can type `steb - 17`.

```lua
> setb - 17
> run
Paused at file test.lua line 17
> listb
-: 17
```

`run` makes the script print `Loop` on screen.

### Evaluate and print variables

Let's check now the value of some variables (**even local ones**!).
We can do this with

```lua
eval <exp>   -- evaluates expression on the current context and returns its value
```

or combining `print()` with

```lua
exec <stmt>   -- executes statement on the current context
```

> `exec` is really very powerful; I'll explain you why.
>
> Basically, it allows you to change the code **live**.
> You are allowed to put your hands inside the warm heart of the script that is currently running with all its local variables.
> This allows you to implement new functions (in someone's else code) way more easily (*i.e.* you don't have to read all the source code your collegue developed), since you'll find yourself in the exact same situation your new function will find itself when everything will be done.

---

For example, let's check the *table* `tab`.

```lua
> eval tab
{bar = 2, foo = 1} --[[table: 0x06dfb9d0]]
```

If we would like to rely on *Torch*'s pretty output format (which is advisable if you'd like visualise *Tensor*s nicely), we type

```lua
> exec print(tab)
```

```lua
{
  foo : 1
  bar : 2
}
```

which is outputed on the terminal where the program is running (and not on the debugger interface).

Let's `run` again a couple of times and see what's changes!

```lua
> run
Paused at file test.lua line 17
> eval tab
{bar = 2, foo = 2} --[[table: 0x06dfb9d0]]
> run
Paused at file test.lua line 17
> eval tab
{bar = 2, foo = 4} --[[table: 0x06dfb9d0]]
```

where `run` gets the script to output `In bar 1`, `In bar 2` and `Loop` twice.
As we can see, line `18`

```lua
17      bar()
18      tab.foo = tab.foo * 2
19   end
```

doubles `tab.foo`, which goes from `1` to `2` to `4`.

Now we can kill our breakpoint with

```lua
> delb - 17
> listb
>
```

Let's now run our code untill `tab.foo` reaches the value `32` by setting a *watch expression*.
