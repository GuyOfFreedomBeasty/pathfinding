function GameFunctions.moveToPos(rig, destination)
	local pathCompleted = false
	local humanoid = rig.Humanoid
	local rootPart = rig.HumanoidRootPart
	
	local path = PathfindingService:CreatePath({
		AgentRadius = 2,
		AgentCanJump = true,
	})
	
	local success, errorMessage = pcall(function()
		path:ComputeAsync(rootPart.Position, destination)
	end)
	
	path.Blocked:Connect(function()
		return
	end)
	
	if not success or path.Status ~= Enum.PathStatus.Success then return end
	
	local waypoints = path:GetWaypoints()
	
	local wayPointToMoveTo = 2
	humanoid.MoveToFinished:Connect(function(reached)
		if not reached or wayPointToMoveTo >= #waypoints then return end
	
		if waypoints[wayPointToMoveTo].Action == Enum.PathWaypointAction.Jump then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
		
		humanoid:MoveTo(waypoints[wayPointToMoveTo].Position)
		wayPointToMoveTo += 1
	end)
	
	humanoid:MoveTo(waypoints[wayPointToMoveTo].Position)
	
	repeat task.wait() until wayPointToMoveTo >= #waypoints
end
