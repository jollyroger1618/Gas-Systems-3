ENT.Type 		= "anim"
ENT.Base 		= "base_rd3_entity"

function ENT:Initialize()
	self.BaseClass.Initialize(self)
	if (self:GetSkin() == 0) then
		self.PrintName = "Methane Reactor"
		list.Set( "LSEntOverlayText" , "gas_reactor", {HasOOO = true, num = 2, resnames = { "Propane" }, genresnames = { "energy" } } )
	elseif (self:GetSkin() == 1) then
		self.PrintName = "Propane Reactor"
		list.Set( "LSEntOverlayText" , "gas_reactor", {HasOOO = true,num = 2, resnames = { "Propane" }, genresnames = { "energy" } } )
	end
end
