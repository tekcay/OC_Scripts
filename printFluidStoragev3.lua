local component = require("component")
local math = require("math")
local event = require("event")
local term = require("term")
local gpu = component.gpu

local isRunning = true
local numberFluids = 0
fluidGridTest = nil

function clearScreen()
  gpu.fill(1,1,160,50," ")
end

function compareTable(table1,table2)
  comparison = true
  k = 0
	if (table1 ~= nil and table2 ~= nil) then
		if (#table1 == #table2) then -- checks the number of fluids in storage. If this number does not change :
			while (k < #table2) and comparison do
			k = k +1
				if (table1[k].name == table2[k].name and table1[k].amount == table2[k].amount) then -- it will compare each iteration of fluid with their label and amount.
					comparison = true -- if no difference, no need to re-print the values
				else
					comparison = false --if a difference is spotted, returns false meaning a change has been made and the values must be re-printed.
				end
			end
		else
			comparison = false
		end
	end
  return comparison
end

local function printFluid(i,table)
  local fluidLabel = table[i].label
  local fluidAmount = table[i].amount
  gpu.set(1,5+i,""..string.format(fluidLabel))
  gpu.set(30,5+i,""..fluidAmount.." mB")
end 

function checkFluids(table)
	numberFluids = 0
    for i, j in ipairs(table) do
      numberFluids = numberFluids + 1
    end
	for i = 1, numberFluids do
		printFluid(i,table)
	end
end

function getStorageCapacityUsage(table)
  capacity = 0
  usage = 0
  usagePCT = 0
	for k,v in pairs(table) do
		if (k == 'total') then
			for i,j in pairs(v) do
				if (i == 'fluid') then
					for x,y in pairs(j) do
						if (x == 'capacity') then
							capacity = capacity + y
						end
						if (x == 'usage') then
							usage = usage + y
						end
						end
				end
			end
		end
	end
usagePCT = 100 * usage / capacity
gpu.set(10,2,"Usage : "..string.format("%2.1f",usagePCT).." %")
--gpu.set(10,3,"Usage : "..usage)
--gpu.set(10,4,"Capacity : "..capacity)
end
 
term.clear()
gpu.set(10,1,"Fluid storage")
checkFluids(component.block_refinedstorage_grid_3.getFluids())
getStorageCapacityUsage(component.block_refinedstorage_grid_3.getStorages())
os.sleep(1)

while true do
  fluidGrid = component.block_refinedstorage_grid_3.getFluids()
    -- the function to get the fluid storage. 
  -- works also with other blocks of RefinedStorage
  if not compareTable(fluidGrid,fluidGridTest) then -- to check change in the storage
    clearScreen() -- clear the screen to print the storage with new values
    gpu.set(10,1,"Fluid storage") -- headline
    local fluidGrid = component.block_refinedstorage_grid_3.getFluids() 
    checkFluids(fluidGrid)
  end
  fluidGridTest = fluidGrid
  FluidStorageTable = component.block_refinedstorage_grid_3.getStorages()
  getStorageCapacityUsage(FluidStorageTable)
  os.sleep(1)
end