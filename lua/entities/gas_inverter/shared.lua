ENT.Type = "anim"
ENT.Base = "base_rd3_entity"
ENT.PrintName = "Gas Inverter"

function ENT:Initialize()
	self.BaseClass.Initialize(self)
	local RD = CAF.GetAddon("Resource Distribution")
	if (self:GetSkin() == 0) then
		self.PrintName = "Tritium Inverter"
		list.Set( "LSEntOverlayText" , "gas_inverter", {HasOOO = true, num = 2, resnames = { "energy" , "Tritium" }, genresnames = { "oxygen" } } )
	elseif (self:GetSkin() == 1) then
		self.PrintName = "Deuterium Inverter"
		list.Set( "LSEntOverlayText" , "gas_inverter", {HasOOO = true, num = 2, resnames = { "energy" , "Deuterium" }, genresnames = { "nitrogen" } } )
	elseif (self:GetSkin() == 2) then
		self.PrintName = "Methane Rehydrator"
		list.Set( "LSEntOverlayText" , "gas_inverter", {HasOOO = true, num = 2, resnames = { "energy" , "Methane" }, genresnames = { "water" } } )
	end
end
