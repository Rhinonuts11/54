local TimeoutDashboard = BehaviourDashboard:WaitForChild("TimeoutDashboard")
local Timeouts = SideButtons["List"].Timeout


local LogTimeoutPage = TimeoutDashboard["LogTimeoutPage"]
local TimeoutContainer = TimeoutDashboard["Container"]
local LogNewTimeout = TimeoutDashboard["LogNewTimeout"]
local TimeoutPage = TimeoutDashboard["TimeoutPage"]

System.Dropdowns.BehaviourDropdown.Timeouts.MouseButton1Click:Connect(function()
	BehaviourDashboardModule.DisableAllPages(Timeouts.Dashboard)
	TimeoutDashboard.Visible = true
	LogTimeoutPage.Visible = false
	BehaviourDashboardModule.LoadTimeout()
end)

Timeouts.Dashboard.MouseButton1Click:Connect(function()
	BehaviourDashboardModule.DisableAllPages(Timeouts.Dashboard)
	TimeoutDashboard.Visible = true
	LogTimeoutPage.Visible = false
	BehaviourDashboardModule.LoadTimeout()
end)

Timeouts.Reporting.MouseButton1Click:Connect(function()
	BehaviourDashboardModule.DisableAllPages(Timeouts.Reporting)
	TimeoutDashboard.Visible = true
	LogTimeoutPage.Visible = true
	BehaviourDashboardModule.LoadTimeout()
	LogTimeoutPage.NewWindow.DateOfIncident.Box.Default.Text = DateService:FormatLocalTime("D", "en-us").." "..DateService:FormatLocalTime("MMM", "en-us").." "..DateService:FormatLocalTime("YYYY", "en-us")
	LogTimeoutPage.NewWindow.TimeOfIncident.Box.Default.Text = ReplicatedStorage["Arbor"].ArborData.CurrentTime.Value
	LogTimeoutPage.NewWindow.Staff.Box.Default.Text = game.Players.LocalPlayer.Name
end)

LogNewTimeout.MouseButton1Click:Connect(function()
	BehaviourDashboardModule.DisableAllPages(Timeouts.Reporting)
	TimeoutDashboard.Visible = true
	LogTimeoutPage.Visible = true
	BehaviourDashboardModule.LoadTimeout()
	LogTimeoutPage.NewWindow.DateOfIncident.Box.Default.Text = DateService:FormatLocalTime("D", "en-us").." "..DateService:FormatLocalTime("MMM", "en-us").." "..DateService:FormatLocalTime("YYYY", "en-us")
	LogTimeoutPage.NewWindow.TimeOfIncident.Box.Default.Text = ReplicatedStorage["Arbor"].ArborData.CurrentTime.Value
	LogTimeoutPage.NewWindow.Staff.Box.Default.Text = game.Players.LocalPlayer.Name
end)

LogTimeoutPage.NewWindow.TimeOfIncident.Box.Icon.MouseButton1Click:Connect(function()
	LogTimeoutPage.NewWindow.TimeOfIncident.Box.Default.Text = ReplicatedStorage["Arbor"].ArborData.CurrentTime.Value
end)

LogTimeoutPage.LogIsolation.MouseButton1Click:Connect(function()
	local TimeoutStudent

	if game.Players.LocalPlayer:GetRankInGroup(Settings["GroupID"]) >= Settings["StaffID"] then
		for _, Player in pairs(game:GetService("Players"):GetPlayers()) do
			if LogTimeoutPage.NewWindow.Student.Box.StudentName.Text == Player.Name then
				TimeoutStudent = Player
			end
		end

		if TimeoutStudent then
			if TimeoutStudent:GetRankInGroup(Settings["GroupID"]) <= Settings["StudentID"] then
				local TimeoutData = {
					["Behaviour"] = LogTimeoutPage.NewWindow.Behaviour.Box.Default.Text,
					["DateOfIncident"] = LogTimeoutPage.NewWindow.DateOfIncident.Box.Default.Text,
					["IsolationReason"] = LogTimeoutPage.NewWindow.IsolationReason.Box.Default.Text,
					["Staff"] = LogTimeoutPage.NewWindow.Staff.Box.Default.Text,
					["Student"] = LogTimeoutPage.NewWindow.Student.Box.StudentName.Text,
					["TimeOfIncident"] = LogTimeoutPage.NewWindow.TimeOfIncident.Box.Default.Text
				}

				BehaviourDashboardModule.LogTimeout(TimeoutStudent, game.Players.LocalPlayer, TimeoutData)
			else
				ArborInitializeModule.DisplayError("This user is not a student")
			end
		else
			print(TimeoutStudent)
			ArborInitializeModule.DisplayError("Invalid student name provided")
		end
	else
		ArborInitializeModule.DisplayError("You do not have permission to do this")
	end

	LogTimeoutPage.Visible = false
	wait(1)
	BehaviourDashboardModule.LoadTimeout()
end)

ReplicatedStorage:WaitForChild("Arbor").ArborEvents.LogTimeout.OnClientEvent:Connect(function(Staff, TimeoutData)
	local Receiver = game.Players.LocalPlayer
	local TimeoutAlert = ArborSystem["TimeoutAlert"]
	local TimeoutInfo = TimeoutAlert["TimeoutInfo"]

	TimeoutAlert.ByUser.Text = "by "..Staff.Name.." ("..ReplicatedStorage["Arbor"].ArborData.PlayerData[Staff.Name].RoleplayName.Value..")"

	for Name, Item in pairs(TimeoutData) do
		if TimeoutInfo[Name] then
			TimeoutInfo[Name].Data.Text = Item
		end
	end

	TimeoutAlert.Visible = true
end)

ArborSystem["TimeoutAlert"].Close.MouseButton1Click:Connect(function()
	ArborSystem["TimeoutAlert"].Visible = false
end)

LogTimeoutPage.Cancel.MouseButton1Click:Connect(function()
	BehaviourDashboardModule.DisableAllPages(Timeouts.Dashboard)
	TimeoutDashboard.Visible = true
	LogTimeoutPage.Visible = false
	BehaviourDashboardModule.LoadTimeout()
end)

TimeoutContainer.TopBar.SearchTable.Input:GetPropertyChangedSignal("Text"):Connect(function()
	for _, incident in pairs(TimeoutContainer.List.ListInner:GetChildren()) do
		if incident:IsA("TextButton") then
			incident.Visible = string.find(string.lower(incident.Name), string.lower(IsolationContainer.TopBar.SearchTable.Input.Text)) and true or false
			incident.Visible = string.find(string.lower(incident.Student.Text), string.lower(IsolationContainer.TopBar.SearchTable.Input.Text)) and true or false
		end
	end
end)

TimeoutContainer.List.ListInner.ChildAdded:Connect(function(timeout)
	if timeout:IsA("TextButton") then
		timeout.MouseButton1Click:Connect(function()
			if not LogTimeoutPage.Visible then
				local obj = timeout.TimeoutObject.Value

				TimeoutPage.Timeout.Value = obj.StudentObj.Value
				TimeoutPage.Container.TimeoutInfo.Time.Data.Text = obj.TimeOfIncident.Value
				TimeoutPage.Container.TimeoutInfo.Date.Data.Text = obj.DateOfIncident.Value
				TimeoutPage.Container.TimeoutInfo.Username.Data.Text = obj.Student.Value
				TimeoutPage.Container.TimeoutInfo.Reason.Data.Text = obj.IsolationReason.Value
				TimeoutPage.Container.TimeoutInfo.Behaviour.Data.Text = obj.Behaviour.Value
				TimeoutPage.Container.TimeoutInfo.Staff.Data.Text = obj.Staff.Value

				TimeoutPage.Visible = true
			end
		end)
	end
end)

TimeoutPage.Container.Back.MouseButton1Click:Connect(function()
	TimeoutPage.Visible = false
	TimeoutPage.Timeout.Value = nil
end)

TimeoutPage.Container.RespawnUser.MouseButton1Click:Connect(function()
	TimeoutPage.Container.RespawnUser.Ticked.Visible = not TimeoutPage.Container.RespawnUser.Ticked.Visible
end)

TimeoutPage.Container.Delete.MouseButton1Click:Connect(function()
	BehaviourDashboardModule.DeleteTimeout(Players.LocalPlayer, TimeoutPage.Timeout.Value, TimeoutPage.Container.RespawnUser.Ticked.Visible)
	TimeoutPage.Visible = false
	TimeoutPage.Timeout.Value = nil

	wait(0.5)
	BehaviourDashboardModule.LoadTimeout()
end)