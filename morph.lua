-- morph the properties of a table over time

-- example of use:
-- animate the y coord of the table 'critter', starting at the current value 
-- and moving to the current value-40, in one second
-- morph.add({name='up and away',table=critter,prop='xy.y',start=critter.xy.y,target=critter.xy.y-40,ease='linear',dir='forward',duration=1})

easing={
  -- the easing functions
  funcs={
    linear=function(t,tMax,start,delta)
    	return delta*t/tMax+start
    end,

    in_quad=function(t,tMax,start,delta)
      t=t/tMax
      return delta*math.pow(t,2)+start
    end,

    in_out_cubic=function(t,tMax,start,delta)
      t=t/tMax*2

      if t<1 then
        return delta/2*t*t*t+start
      end

      t=t-2

      return delta/2*(t*t*t+2)+start
    end
  }
}

-- interface function for calling the easing functions (see table above)
-- ease=string tag for easing function, p=the morph table
function easing.morph(easer,p)
  local delta=p.target-p.start
  local t=p.time
  local tMax=p.duration
  local start=p.start

  return easing.funcs[easer](t,tMax,start,delta)
end

-- the morph 'class', a property animator  ***

morph={
  live={},
  dead={}
}

-- given a mob and "xy.y", will return m.xy and 'y'
-- useage: local t,v=morph.str_ref({table=z,str='props.speed.x'})
-- t==speed vector, t[v]==value of x, t[v]=a sets the value of speed.x
function morph.str_ref(p)
  local m=p.table
  local s=p.str
  local s_ref={}
  local v=nil

  s_ref=s:split(".")
  
  if #s_ref<2 then return m,s_ref[1] end
  
  v=m[s_ref[1]]
  
  for i=2,#s_ref-1 do
    v=v[s_ref[i]]
  end

  return v,s_ref[#s_ref]
end

function morph.add(p)
  local m=p.table
  local prop=p.prop

  prop=p.prop:split(".")
  p.current_value=m[prop[1]]

  if #prop>1 then 
    for i=2,#prop do
      p.current_value=p.current_value[prop[i]]
    end
  end

  p.time=0.0

  morph.live[p.name]=p
end

function morph.remove(p)
  morph.live[p.name]=nil
end

-- [0.0,1.0], current time through the morph (.5==50% complete)
function morph.cursor(p)
  return morph.live[p.name].time/morph.live[p.name].duration
end

function morph.update(p)
  local dt=p.dt
  
  for n,b in pairs(morph.live) do
    b.dt=dt

    morph.update_morph(b)
  end

  for i,n in ipairs(morph.dead) do morph.remove({name=n}) end
  
  morph.dead={}
end

function morph.update_morph(b)
  local m=b.table
  local dt=b.dt

  b.time=b.time+dt

  local t,v=morph.str_ref({table=m,str=b.prop})

  if b.time>b.duration or b.delete then
    t[v]=b.target
    if b.endon then b.endon(b) end
    table.insert(morph.dead,b.name)
  elseif not b.paused then
    -- retrieve ease value from function
    b.current_value=easing.morph(b.ease,{start=b.start,target=b.target,time=b.time,value=b.current_value,dt=dt,duration=b.duration})

    -- assign current value to prop
    t[v]=b.current_value
  end
end

-- pause indefinitely (TODO optional delay to restart)
function morph.pause(p,b)
  morph.live[p.name].paused=not b
end

-- kill morph (TODO optional delay)
function morph.abort(p)
  morph.live[p.name].delete=true
end
