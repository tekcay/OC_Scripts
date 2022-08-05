local component = require("component")
local term = require("term")
local gpu = component.gpu

    gpu.setResolution(160,50)
  --  gpu.setBackground(0x777777)

function diesel()
  gpu.setBackground(0x000000)
  gpu.setForeground(0xffffff)
  gpu.set(60,3, "DIESEL")
    
    local y = 0
  local i = " "
  local x = 0
  -- compteur
    for i in component.list('diesel') do

      if component.proxy(i).isActive() then
        dg_status = "ON"
        else dg_status = "OFF"
      end
      
      if i ~= nil then
        y = y + 1
        x = 5 + y
        gpu.set(60,x, "Diesel generator "..y.."   "..dg_status)  
     end

    end
	
  gpu.setBackground(0xffffff)
  gpu.setForeground(0x000000)
  
end

function nuclear()

  gpu.set(8,3, "NUCLEAR")
  
  reactors()
  turbines()
 
end
function reactors() 

  gpu.set(4,6, "Reactors")
  local y = 0
  local i = " "
  -- compteur
  local x = 8
  -- position
    for i in component.list('salt') do

      if component.proxy(i).isReactorOn() then
        r_status = "ON"
        else r_status = "OFF"
      end
      
    khs = component.proxy(i).getHeatStored() / 1000
    hp = 100 * component.proxy(i).getHeatStored() / component.proxy(i).getHeatCapacity()
    
      if i ~= nil then
        y = y + 1
        gpu.set(4,x, "Salt fisson reactor "..y.."   "..r_status) 
      gpu.set(4,x + 1, "Heat stored   :"..string.format(" %3.f",khs).." kJ")
        gpu.set(4,x + 2, "Heat capacity :"..string.format(" %2.f",hp).." %")
        x = x + 4   
     end

    end  
  indent = x
  -- pour la position des turbines
end  

function turbines()
  gpu.set(4,indent, "Turbines")
  local y = 0
  local i = " "
  -- compteur
  local x = indent + 2
  -- position
    for i in component.list('turbine') do
   
      t_prod = component.proxy(i).getPower() / 1000
    
      if i ~= nil then
        y = y + 1
            gpu.set(4,x, "Turbine "..y.." : "..string.format(" %4.f",t_prod).." kRF/t")
    x = x + 1
    end

    end  
end

  term.clear()

function rectangle(a,b,l,h)
  gpu.setBackground(0xffffff)
  gpu.fill(a,b,l,h," ")
end

  while true do
  
  diesel() 
  nuclear()
  os.sleep(1) 

  end