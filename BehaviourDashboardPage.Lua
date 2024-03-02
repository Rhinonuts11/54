--[[
	jaDevelopment
	Core Arbor Interactive Module
	BehaviourDashboardPage.lua

	    _       _____                 _                                  _   
   (_)     |  __ \               | |                                | |  
    _  __ _| |  | | _____   _____| | ___  _ __  _ __ ___   ___ _ __ | |_ 
   | |/ _` | |  | |/ _ \ \ / / _ \ |/ _ \| '_ \| '_ ` _ \ / _ \ '_ \| __|
   | | (_| | |__| |  __/\ V /  __/ | (_) | |_) | | | | | |  __/ | | | |_ 
   | |\__,_|_____/ \___| \_/ \___|_|\___/| .__/|_| |_| |_|\___|_| |_|\__|
  _/ |                                   | |                             
 |__/                                    |_|                             

--]]

local BehaviourDashboardPage = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Arbor = ReplicatedStorage:WaitForChild("Arbor")
local ArborData = Arbor:WaitForChild("ArborData")

local DateTimeFormat = DateTime.now() 

local System = script.Parent.Parent.Parent.System
local BehaviourDashboard = System:WaitForChild("BehaviourDashboard")
local Player = game.Players.LocalPlayer

local IncidentSeverityThemes = {
	["Level 1 Negative"] = Color3.fromRGB(254, 252, 231),
	["Level 2 Negative"] = Color3.fromRGB(252, 211, 153),
	["Level 3 Negative"] = Color3.fromRGB(255, 180, 180)
}

BehaviourDashboardPage.LoadIncidents = function()
	local Container = BehaviourDashboard.IncidentDashboardPage["Container"]
	local List = Container["List"]
	local InnerList = List["ListInner"]

	for _, Incident in pairs(InnerList:GetChildren()) do
		if Incident:IsA("TextButton") then
			Incident:Destroy()
		end
	end

	for _, ActiveIncident in pairs(ArborData["SessionIncidents"]:GetChildren()) do
		coroutine.wrap(function()
			local ExampleIncident = List:WaitForChild("Example"):Clone()
			ExampleIncident.Parent = InnerList
			ExampleIncident.IncidentObject.Value = ActiveIncident
			ExampleIncident.Visible = true
			ExampleIncident.Name = ActiveIncident.Name
			ExampleIncident.Behaviour.Text = ActiveIncident.BehaviourType.Value
			ExampleIncident.Date.Text = "<u>"..ActiveIncident.DateOfIncident.Value.."</u>"
			ExampleIncident.Severity.Text = ActiveIncident.IncidentSeverity.Value
			
			if ArborData["PlayerData"]:FindFirstChild(ExampleIncident.Name) then
				ExampleIncident.Student.Text = ArborData["PlayerData"][ExampleIncident.Name].RoleplayName.Value
			else
				ExampleIncident.Student.Text = "N/A"
			end

			if IncidentSeverityThemes[ExampleIncident.Severity.Text] then
				ExampleIncident.Severity.Title.BackgroundColor3 = IncidentSeverityThemes[ExampleIncident.Severity.Text]
			else
				ExampleIncident.Severity.Text = ActiveIncident.IncidentSeverity.Value.." (?)"
				ExampleIncident.Severity.Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			end
		end)()
	end
end

BehaviourDashboardPage.LoadCurrentIncident = function(Incident)
	local BehaviouralIncidentPage = BehaviourDashboard["IncidentDashboardPage"].BehaviouralIncidentPage
	local IncidentDetails = BehaviouralIncidentPage["IncidentDetails"]
	local ExternalIncident = Incident.IncidentObject.Value
	BehaviouralIncidentPage.Incident.Value = Incident.IncidentObject.Value

	BehaviouralIncidentPage.Visible = true
	BehaviourDashboard.IncidentDashboardPage.Container.Visible = false
	BehaviourDashboard.IncidentDashboardPage.Separator.Visible = false
	BehaviourDashboard.IncidentDashboardPage.LogIncidentPage.Visible = false
	BehaviourDashboard.IncidentDashboardPage.LogNewIncident.Visible = false
	BehaviourDashboard.IncidentDashboardPage.Title.Visible = false

	IncidentDetails.Behaviour.Data.Text = Incident.Behaviour.Text
	IncidentDetails.DateOfIncident.Data.Text = Incident.IncidentObject.Value.DateOfIncident.Value..", "..Incident.IncidentObject.Value.TimeOfIncident.Value
	IncidentDetails.Event.Data.Text = Incident.IncidentObject.Value.Lesson.Value
	IncidentDetails.Location.Data.Text = Incident.IncidentObject.Value.Location.Value
	IncidentDetails.Severity.Data.Text = Incident.Severity.Text
	IncidentDetails.Summary.Data.Text = Incident.IncidentObject.Value.IncidentSummary.Value

	for _, item in pairs(BehaviouralIncidentPage.StaffStudents:GetChildren()) do
		if item:IsA("Frame") and item:FindFirstChild("Data") then
			item:Destroy()
		end
	end

	local ExampleClone = BehaviouralIncidentPage.Example:Clone()
	ExampleClone.Parent = BehaviouralIncidentPage.StaffStudents
	ExampleClone.Visible = true
	ExampleClone.Name = "Staff"
	ExampleClone.Title.Text = "Staff"
	ExampleClone.Data.Text = ExternalIncident.StaffInvolved.Value

	local StudentExampleClone = BehaviouralIncidentPage.Example:Clone()
	StudentExampleClone.Parent = BehaviouralIncidentPage.StaffStudents
	StudentExampleClone.Visible = true
	StudentExampleClone.Name = "Student"
	StudentExampleClone.Title.Text = "Student"
	StudentExampleClone.Data.Text = Incident.Student.Text

	local OtherStudents = (Incident.IncidentObject.Value.OtherStudents.Value):split(", ")

	for _, OtherStudent in pairs(OtherStudents) do
		local OtherStudentClone = BehaviouralIncidentPage.Example:Clone()
		OtherStudentClone.Name = OtherStudent
		OtherStudentClone.Parent = BehaviouralIncidentPage.StaffStudents
		OtherStudentClone.Title.Text = "Other Student"
		OtherStudentClone.Data.Text = OtherStudent
		OtherStudentClone.Visible = true
	end
end

BehaviourDashboardPage.ResolveDeleteIncident = function(incidentStatus, incident)
	Arbor["ArborEvents"].ResolveDeleteIncident:FireServer(incidentStatus, incident)
end

BehaviourDashboardPage.LogIncident = function(Student, Staff, IncidentData)
	Arbor["ArborEvents"]["LogIncident"]:FireServer(Student, IncidentData)
end

BehaviourDashboardPage.LogMerit = function(Student, Staff, MeritData)
	Arbor["ArborEvents"]["LogMerit"]:FireServer(Student, MeritData)
end

BehaviourDashboardPage.LogBehaviourPoint = function(Student, Staff, BehaviourPointData)
	Arbor["ArborEvents"]["LogBehaviourPoint"]:FireServer(Student, BehaviourPointData)
end

BehaviourDashboardPage.LoadMerits = function()
	local Container = BehaviourDashboard.MeritsDashboard["Container"]
	local List = Container["List"]
	local InnerList = List["ListInner"]

	for _, Incident in pairs(InnerList:GetChildren()) do
		if Incident:IsA("Frame") then
			Incident:Destroy()
		end
	end

	for _, ActiveMerit in pairs(ArborData["SessionMerits"]:GetChildren()) do
		local ExampleMerit = List:WaitForChild("Example"):Clone()
		ExampleMerit.Parent = InnerList
		ExampleMerit.MeritObject.Value = ActiveMerit
		ExampleMerit.Visible = true
		ExampleMerit.Name = ActiveMerit.Name
		ExampleMerit.Date.Text = "<u>"..ActiveMerit.GivenAt.Value.."</u>"
		ExampleMerit.GivenBy.Text = ActiveMerit.GivenBy.Value
		ExampleMerit.TotalAdded.Text = tostring(ActiveMerit.TotalAwarded.Value).." Merit(s)"
		
		if ArborData["PlayerData"]:FindFirstChild(ActiveMerit.Name) then
			ExampleMerit.Student.Text = ArborData["PlayerData"][ActiveMerit.Name].RoleplayName.Value
		else
			ExampleMerit.Student.Text = "N/A"
		end
	end
end

BehaviourDashboardPage.LoadBehaviourPoints = function()
	local Container = BehaviourDashboard.BehaviourPointsDashboard["Container"]
	local List = Container["List"]
	local InnerList = List["ListInner"]

	for _, Incident in pairs(InnerList:GetChildren()) do
		if Incident:IsA("Frame") then
			Incident:Destroy()
		end
	end

	for _, ActiveBehaviourPoint in pairs(ArborData["SessionBehaviourPoints"]:GetChildren()) do
		local ExampleBehaviourPoint = List:WaitForChild("Example"):Clone()
		ExampleBehaviourPoint.Parent = InnerList
		ExampleBehaviourPoint.MeritObject.Value = ActiveBehaviourPoint
		ExampleBehaviourPoint.Visible = true
		ExampleBehaviourPoint.Name = ActiveBehaviourPoint.Name
		ExampleBehaviourPoint.Date.Text = "<u>"..ActiveBehaviourPoint.GivenAt.Value.."</u>"
		ExampleBehaviourPoint.GivenBy.Text = ActiveBehaviourPoint.GivenBy.Value
		ExampleBehaviourPoint.TotalAdded.Text = tostring(ActiveBehaviourPoint.TotalAwarded.Value).." Merit(s)"
		
		if ArborData["PlayerData"]:FindFirstChild(ExampleBehaviourPoint.Name) then
			ExampleBehaviourPoint.Student.Text = ArborData["PlayerData"][ExampleBehaviourPoint.Name].RoleplayName.Value
		else
			ExampleBehaviourPoint.Student.Text = "N/A"
		end
	end
end

BehaviourDashboardPage.LoadIsolations = function()
	local Container = BehaviourDashboard.IsolationsDashboard:FindFirstChild("Container")
	local List = Container["List"]
	local InnerList = List:WaitForChild("ListInner")

	for _, Isolation in pairs(InnerList:GetChildren()) do
		if Isolation:IsA("TextButton") then
			Isolation:Destroy()
		end
	end

	for _, ActiveIsolation in pairs(ArborData["SessionIsolations"]:GetChildren()) do
		local ExampleIsolation = List:WaitForChild("Example"):Clone()
		ExampleIsolation.Parent = InnerList
		ExampleIsolation.IsolationObject.Value = ActiveIsolation
		ExampleIsolation.Visible = true
		ExampleIsolation.Name = ActiveIsolation.Name
		ExampleIsolation.Date.Text = "<u>"..ActiveIsolation.DateOfIncident.Value.."</u>"
		ExampleIsolation.StaffName.Text = ActiveIsolation.Staff.Value
		ExampleIsolation.Behaviour.Text = ActiveIsolation.Behaviour.Value
		
		if ArborData["PlayerData"]:FindFirstChild(ExampleIsolation.Name) then
			ExampleIsolation.Student.Text = ArborData["PlayerData"][ExampleIsolation.Name].RoleplayName.Value
		else
			ExampleIsolation.Student.Text = "N/A"
		end
	end
end

BehaviourDashboardPage.LogIsolation = function(Student, Staff, IsolationData)
	Arbor["ArborEvents"]["LogIsolation"]:FireServer(Student, IsolationData)
end

BehaviourDashboardPage.DeleteIsolation = function(Staff, Student)
	Arbor["ArborEvents"]["DeleteIsolation"]:FireServer(Staff, Student)
end

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

BehaviourDashboardPage.DisableAllPages = function(button)
	local SideButtons = BehaviourDashboard["SideButtons"].List
	for _, SideButtonOption in pairs(SideButtons:GetChildren()) do
		if SideButtonOption:IsA("Frame") then
			SideButtonOption.Frame.Visible = false
			SideButtonOption.Frame.UIStroke.Enabled = false

			for _, Button in pairs(SideButtonOption:GetChildren()) do
				if Button:IsA("TextButton") then
					Button.BackgroundTransparency = 1
					local FontFace = Button.Title.FontFace
					FontFace.Weight = Enum.FontWeight.Regular
					Button.Title.FontFace = FontFace
				end
			end
		end
	end

	if button then
		button.BackgroundTransparency = 0
		local FontFace = button.Title.FontFace
		FontFace.Weight = Enum.FontWeight.Medium
		button.Title.FontFace = FontFace
		button.Parent.Frame.Visible = true
		button.Parent.Frame.UIStroke.Enabled = true
	end

	for _, Page in pairs(BehaviourDashboard:GetChildren()) do
		if Page:FindFirstChild("Container") then
			Page.Visible = false
			for _, InnerPage in pairs(Page:GetChildren()) do
				if InnerPage:IsA("Frame") and InnerPage:FindFirstChild("NewWindow") then
					InnerPage.Visible = false
				end
			end
		end
	end
end

return BehaviourDashboardPage