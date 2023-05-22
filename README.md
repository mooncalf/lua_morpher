# lua_morpher
## A (very) simple table property animator in Lua.

Provide a table, duration, property of the table, optional easing function (several are provided), and start and target values for the property, and a timer will modify the table property as requested, morphing the property from the start to the target values over the given duration.

This was inspired by Defold's 'animator' functionality (https://defold.com/manuals/property-animation/).

### Additions planned
Direction of change ('forward', 'reverse', 'pingpong', 'forwardloop', 'reverseloop'), a delay on remove(), and a restart delay for 'pause'.

## **Example of use:**

Animate the 'y' field of the property named 'xy' in the table named 'critter', starting at the current value of 'xy.y', and morphing to the current value-40, in one second.

```
require("morph")

morph.add({name='up and away',table=critter,prop='xy.y',start=critter.xy.y,target=critter.xy.y-40,ease='linear',dir='forward',duration=1})
```
A demo is provided which uses the Love2d framework (https://love2d.com/) to render a circle with several morphing properties.

### Morphing a circle

Place the circle's properties into a table, then start a morph which uses an in-out-cubic easing formula to shrink the circle's radius:

```
mr_circle={
  radius=100,
  center=vec(160,0),
  color={r=1,g=.2,b=0,a=1}
}

morph.add({name='jerk_radius',table=mr_circle,prop='radius',start=mr_circle.radius,target=10,ease='in_out_cubic',dir='forward',duration=2})
```

![snerkly-export](https://github.com/mooncalf/lua_morpher/assets/3858160/0f12b27b-4b86-434a-946f-e66436d49411)


### More easing functions

There is a whole mess of easing functions in Lua which can easily be added to this code here: https://github.com/coronalabs/framework-easing


