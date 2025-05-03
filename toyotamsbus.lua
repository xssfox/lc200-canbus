msbus_protocol_2c4 = Proto("MSBUS2c4",  "Toyota LandCruiser 200 MS-BUS Protocol 2c4 ECU")
msbus_protocol_610 = Proto("MSBUS610",  "Toyota LandCruiser 200 MS-BUS Protocol 610 ECU")
msbus_protocol_3b0 = Proto("MSBUS3b0",  "Toyota LandCruiser 200 MS-BUS Protocol 3b0 ECU")
msbus_protocol_3b4 = Proto("MSBUS3b4",  "Toyota LandCruiser 200 MS-BUS Protocol 3b4 ECU")
msbus_protocol_611 = Proto("MSBUS611",  "Toyota LandCruiser 200 MS-BUS Protocol 611 ECU")
msbus_protocol_638 = Proto("MSBUS638",  "Toyota LandCruiser 200 MS-BUS Protocol 638 ECU")
msbus_protocol_620 = Proto("MSBUS620",  "Toyota LandCruiser 200 MS-BUS Protocol 620 ECU")
msbus_protocol = Proto("MSBUS",  "Toyota LandCruiser 200 MS-BUS Generic")

local gear_types = {
    [0x2] = "Reverse",
    [0x1] = "Neutral",
    [0x4] = "Park",
    [0x0] = "Drive",
}

local ign_status_types = {
    [0x0] = "Off",
    [0x1] = "ACC",
    [0x2] = "Ign",
    [0x3] = "On",
}

local brake_status = {
    [1] = "On",
    [2] = "Off"
}

rpm = ProtoField.uint16("msbus.rpm", "rpm", base.DEC)
throttle = ProtoField.uint8("msbus.throttle", "throttle", base.DEC)
speed = ProtoField.uint16("msbus.speed", "speed", base.DEC)
gear = ProtoField.uint8("msbus.gear", "gear", base.HEX, gear_types,0xE0)
max_gear = ProtoField.uint8("msbus.max_gear", "max gear", base.DEC, nil,0x70)
brake = ProtoField.bool("msbus.brake", "brake", 8,nil,0x1)
ect_pwr = ProtoField.bool("msbus.ect_pwr", "ectpwr", 8,nil,0x8)
second_start = ProtoField.bool("msbus.second_start", "2nd_start", 8,nil,0x4)
odometer = ProtoField.uint32("msbus.odometer", "odometer",base.DEC)
drivers_door_locked = ProtoField.bool("msbus.door_unlock_drivers", "door_unlock_drivers", 8,nil,0x10)
ign_status = ProtoField.uint8("msbus.ign_status", "ign_status", base.HEX, ign_status_types,0x30)
raw_data = ProtoField.bytes("data.data", "data", base.NONE, "Raw data")
foot_brake = ProtoField.bool("msbus.footbrake", "footbrake", 8,brake_status,0x20)
hand_brake = ProtoField.bool("msbus.handbrake", "handbrake", 8,brake_status,0x10)
sports = ProtoField.bool("msbus.sports", "sports", 8,nil,0x2)
cruise_control = ProtoField.bool("msbus.cruise", "cruise", 8,brake_status,0x20)

outside_temp = ProtoField.uint8("msbus.outside_temp", "outside temp",base.DEC) // not certain about

driver_door = ProtoField.bool("msbus.driver_door", "driver door", 8,nil,0x20)
passenger_door = ProtoField.bool("msbus.passenger_door", "passenger door", 8,nil,0x10)
rear_driver_door = ProtoField.bool("msbus.rear_driver_door", "rear driver door", 8,nil,0x8)
rear_passenger_door = ProtoField.bool("msbus.rear_passenger_door", "rear passenger door", 8,nil,0x4)
boot_door = ProtoField.bool("msbus.boot_door", "boot door", 8,nil,0x2)

msbus_protocol_2c4.fields = { rpm, throttle }
msbus_protocol_3b0.fields = { outside_temp }
msbus_protocol_610.fields = { speed }
msbus_protocol_3b4.fields = { gear, brake, ect_pwr, second_start, max_gear, sports, cruise_control }
msbus_protocol_611.fields = { odometer }
msbus_protocol_638.fields = { drivers_door_locked }
msbus_protocol_620.fields = { ign_status, foot_brake, hand_brake, driver_door, passenger_door, rear_driver_door, rear_passenger_door, boot_door }
msbus_protocol.fields = { raw_data }





function msbus_protocol_2c4.dissector(buffer, pinfo, tree)
  length = buffer:len()
  if length == 0 then return end

  pinfo.cols.protocol = msbus_protocol_2c4.name

  local subtree = tree:add(msbus_protocol_2c4, buffer(), "Toyota MS-BUS data")
  subtree:add(rpm, buffer(0,2))
  subtree:add(throttle, buffer(7,1))

  subtree:add(raw_data, buffer())
end

local can_id = DissectorTable.get("can.id")
can_id:add(0x2C4, msbus_protocol_2c4)

function msbus_protocol_3b0.dissector(buffer, pinfo, tree)
    length = buffer:len()
    if length == 0 then return end
  
    pinfo.cols.protocol = msbus_protocol_3b0.name
  
    local subtree = tree:add(msbus_protocol_3b0, buffer(), "Toyota MS-BUS data")
    local temp = (buffer(3,1):uint() - 32) * (5/9) // some where offset / multipler. not sure where it comes from???
    subtree:add(outside_temp, temp)
  
    subtree:add(raw_data, buffer())
  end
  
  local can_id = DissectorTable.get("can.id")
  can_id:add(0x3b0, msbus_protocol_3b0)

function msbus_protocol_610.dissector(buffer, pinfo, tree)
    length = buffer:len()
    if length == 0 then return end
  
    pinfo.cols.protocol = msbus_protocol_610.name
  
    local subtree = tree:add(msbus_protocol_610, buffer(), "Toyota MS-BUS data")
    subtree:add(speed, buffer(1,2))

    subtree:add(raw_data, buffer())
end

local can_id = DissectorTable.get("can.id")
can_id:add(0x610, msbus_protocol_610)

function msbus_protocol_3b4.dissector(buffer, pinfo, tree)
    length = buffer:len()
    if length == 0 then return end

    pinfo.cols.protocol = msbus_protocol_3b4.name

    local subtree = tree:add(msbus_protocol_3b4, buffer(), "Toyota MS-BUS data")
    subtree:add(gear, buffer(4,1)) 
    subtree:add(ect_pwr, buffer(4,1))
    subtree:add(brake, buffer(4,1))
    subtree:add(second_start, buffer(4,1))
    subtree:add(max_gear, buffer(6,1))
    subtree:add(sports, buffer(6,1))
    subtree:add(cruise_control, buffer(0,1))
    subtree:add(raw_data, buffer())

end

local can_id = DissectorTable.get("can.id")
can_id:add(0x3b4, msbus_protocol_3b4)



function msbus_protocol_611.dissector(buffer, pinfo, tree)
    length = buffer:len()
    if length == 0 then return end

    pinfo.cols.protocol = msbus_protocol_611.name

    local subtree = tree:add(msbus_protocol_611, buffer(), "Toyota MS-BUS data")
    subtree:add(odometer, buffer(4,4))

    subtree:add(raw_data, buffer())

end

local can_id = DissectorTable.get("can.id")
can_id:add(0x611, msbus_protocol_611)


function msbus_protocol_638.dissector(buffer, pinfo, tree)
    length = buffer:len()
    if length == 0 then return end

    pinfo.cols.protocol = msbus_protocol_638.name

    local subtree = tree:add(msbus_protocol_638, buffer(), "Toyota MS-BUS data")
    subtree:add(drivers_door_locked, buffer(2,1))

    subtree:add(raw_data, buffer())

end

local can_id = DissectorTable.get("can.id")
can_id:add(0x638, msbus_protocol_638)



function msbus_protocol_620.dissector(buffer, pinfo, tree)
    length = buffer:len()
    if length == 0 then return end

    pinfo.cols.protocol = msbus_protocol_620.name

    local subtree = tree:add(msbus_protocol_620, buffer(), "Toyota MS-BUS data")
    subtree:add(ign_status, buffer(4,1))
    subtree:add(foot_brake, buffer(7,1))
    subtree:add(hand_brake, buffer(7,1))

    subtree:add(driver_door, buffer(5,1))
    subtree:add(passenger_door, buffer(5,1))
    subtree:add(rear_driver_door, buffer(5,1))
    subtree:add(rear_passenger_door, buffer(5,1))
    subtree:add(boot_door, buffer(5,1))

    subtree:add(raw_data, buffer())

end

local can_id = DissectorTable.get("can.id")
can_id:add(0x620, msbus_protocol_620)