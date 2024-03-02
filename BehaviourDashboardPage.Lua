BehaviourDashboardPage.LoadTimeout = function()
	local Container = BehaviourDashboard.TimeoutDashboard:FindFirstChild("Container")
	local List = Container["List"]
	local InnerList = List:WaitForChild("ListInner")

	for _, Timeout in pairs(InnerList:GetChildren()) do
		if Timeout:IsA("TextButton") then
			Timeout:Destroy()
		end
	end

	for _, ActiveTimeout in pairs(ArborData["SessionTimeout"]:GetChildren()) do
		local ExampleTimeout = List:WaitForChild("Example"):Clone()
		ExampleTimeout.Parent = InnerList
		ExampleTimeout.TimeoutObject.Value = ActiveTimeout
		ExampleTimeout.Visible = true
		ExampleTimeout.Name = ActiveTimeout.Name
		ExampleTimeout.Date.Text = "<u>"..ActiveTimeout.DateOfIncident.Value.."</u>"
		ExampleTimeout.StaffName.Text = ActiveTimeout.Staff.Value
		ExampleTimeout.Behaviour.Text = ActiveTimeout.Behaviour.Value

		if ArborData["PlayerData"]:FindFirstChild(ExampleTimeout.Name) then
			ExampleTimeout.Student.Text = ArborData["PlayerData"][ExampleTimeout.Name].RoleplayName.Value
		else
			ExampleTimeout.Student.Text = "N/A"
		end
	end
end

BehaviourDashboardPage.LogTimeout = function(Student, Staff, TimeoutData)
	Arbor["ArborEvents"]["LogTimeout"]:FireServer(Student, TimeoutData)
end

BehaviourDashboardPage.DeleteTimeout = function(Staff, Student)
	Arbor["ArborEvents"]["DeleteTimeout"]:FireServer(Staff, Student)
end