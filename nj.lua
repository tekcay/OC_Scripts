local component = require("component")
local term = require("term")
local gpu = component.gpu

gpu.setResolution(160,50)
gpu.setBackground(0x777777)

  function dieselGenerators()
	dg = {}
    for i in (component.list('diesel'))
	  dgstatus = component.proxy(i).isActive()
      gpu.set(60,6+i, "Diesel generator "..i..dgstatus)  
	  print(i)
	  print(dgstatus)
    end
	
	

  end


  local salt_iter = component.list('salt')
  local r1, r2 = component.proxy(salt_iter()), component.proxy(salt_iter())

  local turbine_iter = component.list('turbine')
  local t1, t2 = component.proxy(turbine_iter()), component.proxy(turbine_iter())

  local diesel_iter = component.list('diesel')
  local dg1, dg2 = component.proxy(diesel_iter()), component.proxy(diesel_iter())

  local function display()

    gpu.set(4,3, "NULCLEAR")
    gpu.set(4,6, "LEU-235 reactor  "..r1status)
    gpu.set(4,7, "Heat stored   :"..string.format(" %3.f",khs1).." kJ")
    gpu.set(4,8, "Heat capacity :"..string.format(" %2.f",hp1).." %")
  
    gpu.set(4,11, "LEU-238 reactor  "..r2status)
    gpu.set(4,12, "Heat stored   :"..string.format(" %3.f",khs2).." kJ")
    gpu.set(4,13, "Heat capacity :"..string.format(" %2.f",hp2).." %")
  
    gpu.set(4,16, "High pressure turbine production :"..string.format(" %4.f",hp_prod).." RF/t")
    gpu.set(4,17, "Low pressure turbine production  :"..string.format(" %4.f",lp_prod).." RF/t")

    gpu.set(60,3, "DIESEL")
    gpu.set(60,6, "Diesel generator 1  "..dg1status)
    gpu.set(60,7, "Diesel generator 2  "..dg2status)
    gpu.set(90,6, " "..dg1tank.." %")
  end
  
  local function isRunning()
  
    if r1.isReactorOn() then
      r1status = "ON "
      else r1status = "OFF"
    end

    if r2.isReactorOn() then
      r2status = "ON "
      else r2status = "OFF"
    end

    if dg1.isActive() then
      dg1status = "ON"
      else dg1status = "OFF"
    end

   if dg2.isActive() then
     dg2status = "ON"
     else dg2status = "OFF"
   end

  end

  local function dieselTankInfo()

  dg1tank = 100 * dg1.getTankInfo()["amount"] / dg1.getTankInfo()["capacity"]
  end

  local function reactorstate()

    khs1 = r1.getHeatStored() / 1000
    hp1 = 100 * r1.getHeatStored() / r1.getHeatCapacity()
  
    khs2 = r2.getHeatStored() / 1000
    hp2 = 100 *  r2.getHeatStored() / r2.getHeatCapacity()
  end
  
  local function turbineProd()
   hp_prod = t1.getPower()
   lp_prod = t2.getPower()
  end
  
term.clear()

while true do

  isRunning()
  reactorstate()
  turbineProd()
  dieselTankInfo()
  display()
  os.sleep(1)
end