AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()
	self.BaseClass.Initialize(self)
	self.damaged = 0
	self.vent = false

    local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	
	if WireLib then
		self.WireDebugName = self.PrintName
		self.Outputs = WireLib.CreateOutputs(self, {"Storage", "Max Storage"}) 
	end
	
	self.caf.custom.masschangeoverride = true
    self.caf.custom.resource = "Natural Gas"
end

function ENT:OnRemove()
    self.BaseClass.OnRemove(self)
end

function ENT:Damage()
	if (self.damaged == 0) then
		self.damaged = 1
		self:EmitSound("PhysicsCannister.ThrusterLoop")
	end
end

function ENT:Repair()
	self.Entity:SetColor(255,255,255, 255)
	self:SetHealth(self:GetMaxHealth())
	self.damaged = 0
end

function ENT:Destruct()
	if CAF and CAF.GetAddon("Life Support") then
        CAF.GetAddon("Life Support").Destruct(self, true)
    end
end

function ENT:UpdateMass()
    local mul = 0.02
    if self.caf.custom.resource == "Natural Gas" then
        mul = 0.02
    elseif self.caf.custom.resource == "Tritium" then
        mul = 0.02
    elseif self.caf.custom.resource == "Methane" then
        mul = 0.02
    elseif self.caf.custom.resource == "Propane" then
        mul = 0.02
    elseif self.caf.custom.resource == "Deuterium" then
        mul = 0.02
    end
    local div = math.Round(self:GetNetworkCapacity(self.caf.custom.resource) / self.MAXRESOURCE)
    local mass = self.mass + ((self:GetResourceAmount(self.caf.custom.resource) * mul) / div) -- self.mass = default mass + need a good multiplier
    local phys = self:GetPhysicsObject()
    if (phys:IsValid()) then
        if phys:GetMass() ~= mass then
            phys:SetMass(mass)
            phys:Wake()
        end
    end
end

function ENT:UpdateWireOutput()
    local air = self:GetResourceAmount(self.caf.custom.resource)
    local maxair = self:GetNetworkCapacity(self.caf.custom.resource)
    Wire_TriggerOutput(self, "Storage", air)
    Wire_TriggerOutput(self, "Max Storage", maxair)
end

function ENT:Think()
    self.BaseClass.Think(self)
    if not (WireAddon == nil) then
        self:UpdateWireOutput()
    end
    self:UpdateMass()
    self:NextThink(CurTime() + 1)
    return true
end
