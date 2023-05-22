local vec=require("vector")
require("morph")

function string:split(sep)
 local sep,fields=sep or ":",{}
 local pattern=string.format("([^%s]+)",sep)

 self:gsub(pattern,function(c) fields[#fields+1]=c end)

 return fields
end

display={}

game={
	interval=.005,
	animtimer=30,
	animflag=false,
}

mr_circle={
  radius=100,
  center=vec(160,0),
  color={r=1,g=.2,b=0,a=1}
}

--== LOAD =======================
function love.load(params)
  display={
    res=vec(320,200),
    scale=3,
    fullscreen=false,
    fullscreen_scale=4.5,
    window_scale=3,
    background_color={ 0,0,0,1.0 },
    hide_mouse=false,
    crt_shader=false,
    window_position=vec(0,0)
  }

  game.timer=0.0
	draw=true

  love.graphics.clear()
  love.graphics.setDefaultFilter("nearest","nearest")
  love.window.setMode(display.res.x*display.scale,display.res.y*display.scale,{borderless=false,resizable=false})

  morph.add({name='jerk_position',table=mr_circle,prop='center.y',start=mr_circle.center.y,target=100,ease='in_out_cubic',dir='forward',duration=1})
  morph.add({name='jerk_color',table=mr_circle,prop='color.b',start=0,target=1,ease='linear',dir='forward',duration=2})
  morph.add({name='jerk_color2',table=mr_circle,prop='color.r',start=1,target=0,ease='linear',dir='forward',duration=2})
  morph.add({name='jerk_radius',table=mr_circle,prop='radius',start=mr_circle.radius,target=10,ease='in_out_cubic',dir='forward',duration=2})
end

--== UPDATE =====================
function love.update(dt)
	game.timer=game.timer+dt

	if game.timer>game.interval then
		game.timer=0.0
		update_delayed(dt)
		draw=true
	end
end

function update_delayed(dt)
	if game.animtimer<=0 then
		game.animflag=true
		game.animtimer=30
	end

  gameloop(dt)
end

function gameloop(dt)
  morph.update({dt=dt})
end

--== DRAW =======================
function love.draw()
  love.graphics.scale(display.scale)
  love.graphics.setColor(mr_circle.color.r,mr_circle.color.g,mr_circle.color.b,mr_circle.color.a)
  love.graphics.circle('line',mr_circle.center.x,mr_circle.center.y,mr_circle.radius)
end

--== KEYRELEASED ================
function love.keyreleased(key)
	
end

function love.keypressed(key)
	
end

