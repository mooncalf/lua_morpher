# lua_morpher
A simple table property animator in Lua.

Provide a table, duration, property of the table, optional easing function (several are provided), and start and target values for the property, and a timer will modify the table property as requested, morphing the property from the start to the target value over the given duration.

This was inspired by Defold's 'animator' functions.

What's could be added: direction of change ('forward', 'reverse', 'pingpong'), a delay on remove(), and a restart delay for 'pause'.

Example of use:

Animate the y coord of the table named 'critter', starting at the current value and moving to the current value-40, in one second,

```
morph.add({name='up and away',table=critter,prop='xy.y',start=critter.xy.y,target=critter.xy.y-40,ease='linear',dir='forward',duration=1})
```

