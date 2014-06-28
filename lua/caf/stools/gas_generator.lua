TOOL.Category = "Gas Systems 3"
TOOL.Name = "#Generators"

TOOL.DeviceName = "Generator"
TOOL.DeviceNamePlural = "Generators"
TOOL.ClassName = "gs3_generators"

TOOL.DevSelect = true
TOOL.CCVar_type = "gas_gent"
TOOL.CCVar_class = "gas_inverter"
TOOL.CCVar_sub_type = "Tritium Inverter"
TOOL.CCVar_model = "models/syncaidius/gas_inverter.mdl"

TOOL.Limited = true
TOOL.LimitName = "gs3_generators"
TOOL.Limit = 10

if (CLIENT and GetConVarNumber("CAF_UseTab") == 1) then TOOL.Tab = "Custom Addon Framework" end

CAFToolSetup.SetLang("Gas Generators", "Spawns a Generator for use with Gas Systems.", "Left-Click: Spawn a Device.  Reload: Repair Device.")

if not CAF or not CAF.GetAddon("Resource Distribution") then Error("Please Install Resource Distribution Addon.'" ) return end
if not CAF or not CAF.GetAddon("Life Support") then return end

function TOOL.EnableFunc()
    if not CAF then
        return false;
    end
    if not CAF.GetAddon("Resource Distribution") or not CAF.GetAddon("Resource Distribution").GetStatus() then
        return false;
    end
    return true;
end


TOOL.ExtraCCVars = {}

function TOOL.ExtraCCVarsCP(tool, panel)
end

function TOOL:GetExtraCCVars()
    local Extra_Data = {}
    return Extra_Data
end

local function gas_genit(ent, type, sub_type, devinfo, Extra_Data, ent_extras)
    local volume_mul = 1 --Change to be 0 by default later on
    local base_volume = 4084
    local base_mass = 200
    local base_health = 600
    local phys = ent:GetPhysicsObject()
    if phys:IsValid() and phys.GetVolume then
        local vol = phys:GetVolume()
        vol = math.Round(vol)
        MsgN("Ent Physics Object Volume: ", vol)
        volume_mul = vol / base_volume
    end
    
    local res = ""
    if (type == "gas_invt" || type == "gas_colt") then
        res = "Tritium"
    elseif (type == "gas_invd" || type == "gas_cold") then
        res = "Deuterium"
    elseif (type == "gas_invm" || type == "gas_colm")  then
        res = "Methane"
    elseif type == "gas_colp" then
        res = "Propane"
    elseif (type == "gas_ext" || type == "gas_proc") then
        res = "Natural Gas"
    elseif (type == "gas_reacp") then
		res = "Propane"
		ent:AddResource("energy", math.ceil(volume_mul * 10));
        ent:AddResource("Propane", math.ceil(volume_mul * 0.92 * 3))
    elseif (type == "gas_reacm") then 
		res = "Methane"
		ent:AddResource("energy", math.ceil(volume_mul * 10));
        ent:AddResource("Methane", math.ceil(volume_mul * 0.92 * 3))
    elseif (type == "gas_tokomak") then
		ent:AddResource("energy", math.ceil(volume_mul * 10));
        ent:AddResource("Tritium", math.ceil(volume_mul * 0.92 * 3))
        ent:AddResource("Deuterium", math.ceil(volume_mul * 0.92 * 3))
    end
    
    ent.caf.custom.resource = res;
    CAF.GetAddon("Resource Distribution").RegisterNonStorageDevice(ent)
    ent.caf.custom.mult = volume_mul
    local mass = math.Round(base_mass * volume_mul)
    ent.mass = mass
    local maxhealth = math.Round(base_health * volume_mul)
    return mass, maxhealth
end

local function gas_gennorm(ent, type, sub_type, devinfo, Extra_Data, ent_extras)
    local volume_mul = 1 --Change to be 0 by default later on
    local base_volume = 4084
    local base_mass = 200
    local base_health = 600
    local phys = ent:GetPhysicsObject()
    if phys:IsValid() and phys.GetVolume then
        local vol = phys:GetVolume()
        vol = math.Round(vol)
        MsgN("Ent Physics Object Volume: ", vol)
        volume_mul = vol / base_volume
    end
    
    CAF.GetAddon("Resource Distribution").RegisterNonStorageDevice(ent)
    ent:SetMultiplier(volume_mul)
    local mass = math.Round(base_mass * volume_mul)
    ent.mass = mass
    local maxhealth = math.Round(base_health * volume_mul)
    return mass, maxhealth
end




--local gas_gen_models = {
	--{'Natural Gas Extractor', 'models/syncaidius/gas_extractor.mdl', 'gas_extractor'},
	--{"Natural Gas Processor", "models/syncaidius/gas_processor.mdl", "gas_processor"},
	--{"Large Tokomak Reactor", "models/syncaidius/tokomak.mdl", "gas_tokomak"},
	--{"Large Methane Reactor", "models/syncaidius/gas_lreactor.mdl", "gas_lmethreactor"},
	--{"Large Propane Reactor", "models/syncaidius/gas_lreactor.mdl", "gas_lpropreactor"},
	--{"Small Methane Reactor", "models/syncaidius/gas_sreactor.mdl", "gas_smethreactor"},
	--{"Small Propane Reactor", "models/syncaidius/gas_sreactor.mdl", "gas_spropreactor"},
	--{"Small Tokomak Reactor", "models/syncaidius/stokomak.mdl", "gas_stokomak"},
	--{"Methane Collector", "models/syncaidius/gas_collector.mdl", "gas_collector_meth"},
	--{"Propane Collector", "models/syncaidius/gas_collector.mdl", "gas_collector_prop"},
	--{"Deuterium Collector", "models/syncaidius/gas_collector.mdl", "gas_collector_deut"},
	--{"Tritium Collector", "models/syncaidius/gas_collector.mdl", "gas_collector_trit"},
	--{"Tritium Inverter", "models/syncaidius/gas_inverter.mdl", "gas_tritinverter"},
	--{"Deuterium Inverter", "models/syncaidius/gas_inverter.mdl", "gas_deutinverter"},
	--{"Methane Rehydrator", "models/syncaidius/gas_inverter.mdl", "gas_rehydrator"}
--}

TOOL.Devices = {
    gas_invt = {
        Name = "Tritium Inverter",
        type = "gas_invt",
        class = "gas_inverter",
        func = gas_genit,
        devices = {
			default = {
                Name = "Default",
                model = "models/syncaidius/gas_inverter.mdl",
                legacy = false,
                skin = 0,
            },
		}
    },
    
    gas_invd = {
        Name = "Deuterium Inverter",
        type = "gas_invd",
        class = "gas_inverter",
        func = gas_genit,
        devices = {
			deafult = {
                Name = "Default",
                model = "models/syncaidius/gas_inverter.mdl",
                legacy = false,
                skin = 1,
            },
        }
    },
    
    gas_invm = {
        Name = "Methane Rehydrator",
        type = "gas_invm",
        class = "gas_inverter",
        func = gas_genit,
        devices = {
			deafult = {
                Name = "Default",
                model = "models/syncaidius/gas_inverter.mdl",
                legacy = false,
                skin = 2,
            },
        }
    },
    
    gas_colt = {
        Name = "Tritium Collector",
        type = "gas_colt",
        class = "gas_collector",
        func = gas_genit,
        devices = {
			deafult = {
                Name = "Default",
                model = "models/syncaidius/gas_collector.mdl",
                legacy = false,
                skin = 3,
            },
        }
    },
    
    gas_cold = {
        Name = "Deuterium Collector",
        type = "gas_cold",
        class = "gas_collector",
        func = gas_genit,
        devices = {
			deafult = {
                Name = "Default",
                model = "models/syncaidius/gas_collector.mdl",
                legacy = false,
                skin = 2,
            },
        }
    },
    
    gas_colm = {
        Name = "Methane Collector",
        type = "gas_colm",
        class = "gas_collector",
        func = gas_genit,
        devices = {
			deafult = {
                Name = "Default",
                model = "models/syncaidius/gas_collector.mdl",
                legacy = false,
                skin = 0,
            },
        }
    },
    
    gas_colp = {
        Name = "Propane Collector",
        type = "gas_colp",
        class = "gas_collector",
        func = gas_genit,
        devices = {
			deafult = {
                Name = "Default",
                model = "models/syncaidius/gas_collector.mdl",
                legacy = false,
                skin = 1,
            },
        }
    },
    
    gas_reacp = {
        Name = "Propane Reactor",
        type = "gas_reacp",
        class = "gas_reactor",
        func = gas_genit,
        devices = {
			small = {
                Name = "Small",
                model = "models/syncaidius/gas_sreactor.mdl",
                legacy = false,
                skin = 1,
            },
            large = {
                Name = "Large",
                model = "models/syncaidius/gas_lreactor.mdl",
                legacy = false,
                skin = 1,
            },
        }
    },
    
    gas_reacm = {
        Name = "Methane Reactor",
        type = "gas_reacm",
        class = "gas_reactor",
        func = gas_genit,
        devices = {
			small = {
                Name = "Small",
                model = "models/syncaidius/gas_sreactor.mdl",
                legacy = false,
                skin = 0,
            },
            medium = {
				Name = "Large",
				model = "models/syncaidius/gas_lreactor.mdl",
				legacy = false,
				skin = 0,
			},
        }
    },
    
    gas_extractor = {
        Name = "Natural Gas Extractor",
        type = "gas_extractor",
        func = gas_gennorm,
        devices = {
			default = {
                Name = "Default",
                model = "models/syncaidius/gas_extractor.mdl",
                legacy = false,
            },
        }
    },
    
    gas_processor = {
        Name = "Natural Gas Processor",
        type = "gas_processor",
        func = gas_gennorm,
        devices = {
			default = {
                Name = "Default",
                model = "models/syncaidius/gas_processor.mdl",
                legacy = false,
            },
        }
    },
    
    gas_tokomak = {
        Name = "Tokomak Reactor",
        type = "gas_tokomak",
        func = gas_gennorm,
        devices = {
			small = {
                Name = "Small",
                model = "models/syncaidius/stokomak.mdl",
                legacy = false,
            },
            large = {
                Name = "Large",
                model = "models/syncaidius/tokomak.mdl",
                legacy = false,
            },
        }
    },
}
