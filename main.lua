function GameFunctions.moveToPos(rig, destination)
	local pathCompleted = false
	local humanoid = rig.Humanoid
	local rootPart = rig.HumanoidRootPart
	
	rootPart:SetNetworkOwner(nil)
	local path = PathfindingService:CreatePath({
		AgentRadius = 4,
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

	for waypoint = 2, #waypoints - 1 do
		if waypoints[waypoint].Action == Enum.PathWaypointAction.Jump then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
		humanoid:MoveTo(waypoints[waypoint].Position)
		humanoid.MoveToFinished:Wait()
	end
end
