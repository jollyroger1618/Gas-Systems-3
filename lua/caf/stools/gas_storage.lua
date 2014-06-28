TOOL.Category = "Gas Systems 3"
TOOL.Name = "#Storage Devices"

TOOL.DeviceName = "Storage Device"
TOOL.DeviceNamePlural = "Storage Devices"
TOOL.ClassName = "gs3_receptacles"

TOOL.DevSelect = true
TOOL.CCVar_type = "gas_storen"
TOOL.CCVar_sub_type = "Large"
TOOL.CCVar_model = "models/syncaidius/gas_tank_huge.mdl"

TOOL.Limited = true
TOOL.LimitName = "ls3_receptacles"
TOOL.Limit = 20

if (CLIENT and GetConVarNumber("CAF_UseTab") == 1) then TOOL.Tab = "Custom Addon Framework" end

CAFToolSetup.SetLang("Gas Storages", "Spawns a storage for use with Gas Systems.", "Left-Click: Spawn a Device.  Reload: Repair Device.")

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

local function gas_storeit(ent, type, sub_type, devinfo, Extra_Data, ent_extras)
    local volume_mul = 1
    local base_volume = 4084
    local base_mass = 10
    local base_health = 100
    local phys = ent:GetPhysicsObject()
    if phys:IsValid() and phys.GetVolume then
        local vol = phys:GetVolume()
        vol = math.Round(vol)
        volume_mul = vol / base_volume
    end
    local res = ""
    if type == "gas_storen" then
        res = "Natural Gas"
    elseif type == "gas_storet" then
        res = "Tritium"
    elseif type == "gas_stored" then
        res = "Deuterium"
    elseif type == "gas_storep" then
        res = "Propane"
    elseif type == "gas_storem" then
        res = "Methane"
    end
    ent.caf.custom.resource = res;
    CAF.GetAddon("Resource Distribution").AddResource(ent, res, math.Round(4600 * volume_mul))
    ent.MAXRESOURCE = math.Round(4600 * volume_mul)
    local mass = math.Round(base_mass * volume_mul)
    ent.mass = mass
    local maxhealth = math.Round(base_health * volume_mul)
    return mass, maxhealth
end

local function gas_cache_func(ent, type, sub_type, devinfo, Extra_Data, ent_extras)
    local volume_mul = 1
    local base_volume = 4084
    local base_mass = 50
    local base_health = 250
    local phys = ent:GetPhysicsObject()
    if phys:IsValid() and phys.GetVolume then
        local vol = phys:GetVolume()
        vol = math.Round(vol)
        volume_mul = vol / base_volume
    end
    CAF.GetAddon("Resource Distribution").AddResource(ent, "Methane", math.Round(5000 * volume_mul))
    CAF.GetAddon("Resource Distribution").AddResource(ent, "Propane", math.Round(5000 * volume_mul))
    CAF.GetAddon("Resource Distribution").AddResource(ent, "Deuterium", math.Round(5500 * volume_mul))
    CAF.GetAddon("Resource Distribution").AddResource(ent, "Tritium", math.Round(5500 * volume_mul))
    local mass = math.Round(base_mass * volume_mul)
    ent.mass = mass
    local maxhealth = math.Round(base_health * volume_mul)
    return mass, maxhealth
end

--local gas_stor_models = {
		--{ "#Large Processed Gas Tank", "models/syncaidius/lprocstore.mdl", "gas_lproctank" },
    --{ "#Medium Processed Gas Tank", "models/syncaidius/mprocstore.mdl", "gas_mproctank" },
		--{ "#Small Processed Gas Tank", "models/syncaidius/sprocstore.mdl", "gas_sproctank" },
--}

TOOL.Devices = {
	gas_storeall = {
		Name = "Processed Gas Tank",
        type = "gas_storeall",
        class = "gas_proctank",
        func = gas_cache_func,
        devices = {
			small = {
                Name = "Small",
                model = "models/syncaidius/sprocstore.mdl",
                legacy = false,
            },
            medium = {
                Name = "Medium",
                model = "models/syncaidius/mprocstore.mdl",
                legacy = false,
            },
            large = {
                Name = "Large",
                model = "models/syncaidius/lprocstore.mdl",
                legacy = false,
            },
        }
    },
		
    gas_storen = {
        Name = "Natural Gas Tank",
        type = "gas_storen",
        class = "gas_store",
        func = gas_storeit,
        devices = {
			small = {
                Name = "Small",
                model = "models/syncaidius/gas_tank_small.mdl",
                legacy = false,
                skin = 4,
            },
            medium = {
                Name = "Medium",
                model = "models/syncaidius/gas_tank_large.mdl",
                legacy = false,
                skin = 4,
            },
            large = {
                Name = "Large",
                model = "models/syncaidius/gas_tank_huge.mdl",
                legacy = false,
                skin = 4,
            },
        }
    },
    
    gas_storet = {
        Name = "Tritium Gas Tank",
        type = "gas_storet",
        class = "gas_store",
        func = gas_storeit,
        devices = {
			small = {
                Name = "Small",
                model = "models/syncaidius/gas_tank_small.mdl",
                legacy = false,
                skin = 3,
            },
            medium = {
                Name = "Medium",
                model = "models/syncaidius/gas_tank_large.mdl",
                legacy = false,
                skin = 3,
            },
            large = {
                Name = "Large",
                model = "models/syncaidius/gas_tank_huge.mdl",
                legacy = false,
                skin = 3,
            },
        }
    },
    
    gas_stored = {
        Name = "Deuterium Gas Tank",
        type = "gas_stored",
        class = "gas_store",
        func = gas_storeit,
        devices = {
			small = {
                Name = "Small",
                model = "models/syncaidius/gas_tank_small.mdl",
                legacy = false,
                skin = 2,
            },
            medium = {
                Name = "Medium",
                model = "models/syncaidius/gas_tank_large.mdl",
                legacy = false,
                skin = 2,
            },
            large = {
                Name = "Large",
                model = "models/syncaidius/gas_tank_huge.mdl",
                legacy = false,
                skin = 2,
            },
        }
    },
    
    gas_stored = {
        Name = "Deuterium Gas Tank",
        type = "gas_stored",
        class = "gas_store",
        func = gas_storeit,
        devices = {
			small = {
                Name = "Small",
                model = "models/syncaidius/gas_tank_small.mdl",
                legacy = false,
                skin = 2,
            },
            medium = {
                Name = "Medium",
                model = "models/syncaidius/gas_tank_large.mdl",
                legacy = false,
                skin = 2,
            },
            large = {
                Name = "Large",
                model = "models/syncaidius/gas_tank_huge.mdl",
                legacy = false,
                skin = 2,
            },
        }
    },
    
    gas_storep = {
        Name = "Propane Gas Tank",
        type = "gas_storep",
        class = "gas_store",
        func = gas_storeit,
        devices = {
			small = {
                Name = "Small",
                model = "models/syncaidius/gas_tank_small.mdl",
                legacy = false,
                skin = 1,
            },
            medium = {
                Name = "Medium",
                model = "models/syncaidius/gas_tank_large.mdl",
                legacy = false,
                skin = 1,
            },
            large = {
                Name = "Large",
                model = "models/syncaidius/gas_tank_huge.mdl",
                legacy = false,
                skin = 1,
            },
        }
    },
    
    gas_storem = {
        Name = "Methane Gas Tank",
        type = "gas_storem",
        class = "gas_store",
        func = gas_storeit,
        devices = {
			small = {
                Name = "Small",
                model = "models/syncaidius/gas_tank_small.mdl",
                legacy = false,
                skin = 0,
            },
            medium = {
                Name = "Medium",
                model = "models/syncaidius/gas_tank_large.mdl",
                legacy = false,
                skin = 0,
            },
            large = {
                Name = "Large",
                model = "models/syncaidius/gas_tank_huge.mdl",
                legacy = false,
                skin = 0,
            },
        }
    },
}
