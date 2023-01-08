--IMPORTANT: Make sure this is the only custom killmove lua file for your addon since having multiple can cause conflicts and issues

--This makes sure the functions in this if statement are only ran on the server since they aren't needed on the client
if SERVER then

	--This adds to a list of entities that can be killmovable (highlighted blue) when taking damage
	--ValveBipeds by default are on this list so use this only for entities with different bone structures such as headcrabs
	--Make sure the entity you're checking for in the killmove function below is added to this list, you can add as many as you want
	--you don't need to bother with this
	timer.Simple(0, function()
		if killMovableEnts then
			
			--These are commented out because we won't be using them in this example, feel free to uncomment them if you want to add more non ValveBiped npcs to be killmovable
			
			--[[if !table.HasValue(killMovableEnts, "npc_strider") then
				table.insert( killMovableEnts, "npc_strider" )
			end
			if !table.HasValue(killMovableEnts, "npc_headcrab") then
				table.insert( killMovableEnts, "npc_headcrab" )
			end]]
		end
	end)

	--This is the hook for custom killmoves
	--IMPORTANT: Make sure to change the UniqueName to something else to avoid conflicts with other custom killmove addons
	--you don't need to change anything in this line
	hook.Add("CustomKillMoves", "spubbily_killmoves", function(ply, target, angleAround)
		
		--Setup some values for custom killmove data
		--leave this how it is
		local plyKMModel = "models/weapons/c_limbs_handbreak.mdl"
		local targetKMModel = "models/bsmodimations_handbreak.mdl"
		local animName = nil
		local plyKMPosition = target:GetPos()
		local plyKMAngle = (target:GetForward()):Angle()
	
		
		local kmData = {1, 2, 3, 4, 5} --We'll use this at the end of the hook
		
		--plyKMModel = "models/weapons/models/c_limbs_template.mdl" --We set the Players killmove model to the custom one that has the animations
		
		--this generates a random number between 1 and whatever the second number is
		local whichKillToUse = 0

		--Use these checks for angle specific killmoves, make sure to keep the brackets when using them
		if (angleAround <= 45 or angleAround > 315) then
			--put front killmoves here
			--the second number is how many front killmoves there are
			whichKillToUse = math.random(1, 2)
			--copy this and increase the whichKillToUse == x by 1 to add a new killmove
			if (whichKillToUse == 1) then
				animName = "handbreak_player"
			end
			if (whichKillToUse == 2) then
				animName = "boink"
			end
			--example:
			-- if (whichKillToUse == 2) then
			-- 	animName = "name_of_the_animation"
			-- end
			-- if (whichKillToUse == 3) then
			-- 	animName = "name_of_the_other_animation"
			-- end
			--etc.
			ply:PrintMessage(HUD_PRINTTALK, "front")
		elseif (angleAround > 45 and angleAround <= 135) then
			--put left killmoves here

			--this is the same as the one above, but the second number only applies to left killmoves
			whichKillToUse = math.random(1, 1)
			if (whichKillToUse == 1) then
				--animName = "left_kill"
			end
		elseif (angleAround > 135 and angleAround <= 225) then
			--put back killmoves here

			--this is the same as the one above, but the second number only applies to back killmoves
			whichKillToUse = math.random(1, 1)
			if (whichKillToUse == 1) then
				--animName = "back_kill"
			end
		elseif (angleAround > 225 and angleAround <= 315) then
			--put right killmoves here

			--this is the same as the one above, but the second number only applies to right killmoves
			whichKillToUse = math.random(1, 1)
			if (whichKillToUse == 1) then
				--animName = "left_kill"
			end
		end
		
		--No need to add if checks for tons of npcs when you can put target:LookupBone("bonename") in them, an example of this being used is below
		
		--This checks if the target is a Zombie, the Player is on the ground and that the Target model is a valvebiped one
		--It also has a chance to not happen as shown by the math.random, that way other killmoves can have a chance of happening
		--you probably won't need this; if you do, ask me and I'll explain it
		if target:GetClass() == "npc_zombie" and ply:OnGround() and target:LookupBone("ValveBiped.Bip01_Spine") and (angleAround <= 45 or angleAround > 315) and math.random(1, 3) >= 3 then
		
			targetKMModel = "models/bsmodimations_zombie_template.mdl" --Set the Targets killmove model

			animName = "handbreak_player"
		end
		
		--Positioning the Player for different killmove animations
		--you don't need this as moving the model inside blender already does this
		if animName == "handbreak_player" then
			plyKMPosition = target:GetPos() --Position the player in front of the Target and x distance away
		end
		if animName == "boink" then
			plyKMPosition = target:GetPos() --Position the player in front of the Target and x distance away
		end

		--IMPORTANT: Make sure not to duplicate the rest of the code below, it isn't nessecary and can cause issues, just keep them at the bottom of this function
		--don't change this
		kmData[1] = plyKMModel
		kmData[2] = targetKMModel
		kmData[3] = animName
		kmData[4] = plyKMPosition
		kmData[5] = plyKMAngle
		
		--don't change this
		if animName ~= nil then return kmData end --Send the killmove data to the main addons killmove check function
	end)
	--leave this as it is
	hook.Add("CustomKMEffects", "spubbily_killmoves", function(ply, animName, targetModel)
		--copy this if statement to and change the animName == "handbreak_player" to animName == "whatever_the_name_of_your_animation_is"
		--then, make sure all the timer.Simple things are inside the if statement
		if animName == "handbreak_player" then
			timer.Simple(0.37, function()
				if !IsValid(targetModel) then return end
				ply:EmitSound("player/fists/fists_hit0" .. math.random(1, 3) .. ".wav", 100, 100, 0.5, CHAN_AUTO )
			end)
			timer.Simple(1.16, function()
				if !IsValid(targetModel) then return end
				ply:EmitSound("player/killmove/km_bonebreak" .. math.random(1, 3) .. ".wav", 100, 100, 0.5, CHAN_AUTO )
			end)
		end
		if animName == "boink" then
			timer.Simple(0.73, function()
				if !IsValid(targetModel) then return end
				ply:EmitSound("player/fists/fists_hit0" .. math.random(1, 3) .. ".wav", 100, 100, 0.5, CHAN_AUTO )
			end)
			timer.Simple(0.73, function()
				if !IsValid(targetModel) then return end
				ply:EmitSound("player/killmove/km_bonebreak" .. math.random(1, 3) .. ".wav", 100, 100, 0.5, CHAN_AUTO )
			end)
		end
		--example:

		-- if animName == "name_of_the_animation" then
		-- 	--first sound at 0 seconds (0 frames)
		-- 	timer.Simple(0, function()
		-- 		--make sure we have a model
		-- 		if !IsValid(targetModel) then return end
		-- 		ply:EmitSound("wherever/the/sound/is.wav", 100, 100, 0.5, CHAN_AUTO )
		-- 	end)
		-- 	--second sound at .33 secondws (10 frames)
		-- 	timer.Simple(0.33, function()
		-- 		if !IsValid(targetModel) then return end
		-- 		ply:EmitSound("different/sound.wav", 100, 100, 0.5, CHAN_AUTO )
		-- 	end)
		-- end
	end)
end

--This is the hook for modifying the ragdoll after being killmoved
--it's also outside of the server check because it's needed for serverside and clientside ragdolls

hook.Add( "KMRagdoll", "UniqueName", function(entity, ragdoll, animName)
	
	--Define the position and angles of a bone, we'll talk about this further down
	local spinePos, spineAng = nil
	
	if ragdoll:LookupBone("ValveBiped.Bip01_Spine") then 
		spinePos, spineAng = ragdoll:GetBonePosition(ragdoll:LookupBone("ValveBiped.Bip01_Spine"))
	end
	
	--Loop through all of the ragdoll's bones that have a physics mesh attached, this will basically move the entire ragdoll
	for i = 0, ragdoll:GetPhysicsObjectCount() - 1 do
		local bone = ragdoll:GetPhysicsObjectNum(i)
		
		if bone and bone:IsValid() then
			
			--We won't be needing this but if you do then feel free to uncomment it
			--local bonepos, boneang = ragdoll:GetBonePosition(ragdoll:TranslatePhysBoneToBone(i))
			
			if animName == "killmove_zombie_kick1" then
				if spineAng ~= nil then
					--Set the ragdoll's velocity to move to the east direction of the spine bone (it's -spineAng:Up because source engine bones are weird)
					--if you dont get the right direction then mess around with it by using spineAng:Up, spineAng:Forward or spineAng:Right. use a minus symbol(-) before it for the opposite direction
					bone:SetVelocity(-spineAng:Up() * 75)
				end
			elseif animName == "killmove_zombie_punch1" then
				--Put code here and delete this comment lol, make sure to change the animation name
			end
		end
	end
	
	--You can also rotate the ragdoll by changing it's angular velocity, here's an example below
	
	--bone:SetAngleVelocity(bone:WorldToLocalVector(-spineAng:Forward() * 2500))
	
	--This basically makes the ragdoll spin like a torpedo, it's -spineAng:Forward() because again source engine bones are weird but it basically means the up direction of it
end)