--[[
	   _       _____                 _                                  _   
   (_)     |  __ \               | |                                | |  
    _  __ _| |  | | _____   _____| | ___  _ __  _ __ ___   ___ _ __ | |_ 
   | |/ _` | |  | |/ _ \ \ / / _ \ |/ _ \| '_ \| '_ ` _ \ / _ \ '_ \| __|
   | | (_| | |__| |  __/\ V /  __/ | (_) | |_) | | | | | |  __/ | | | |_ 
   | |\__,_|_____/ \___| \_/ \___|_|\___/| .__/|_| |_| |_|\___|_| |_|\__|
  _/ |                                   | |                               2023  
 |__/    
 
	jaDevelopment, 2023
	ArborEdu System
	Client.lua
	
	Designed, established and assembled by a !!#9724 under jaDevelopment
	
	Not to be redistributed under this new version from all parties other than jaDevelopment
--]]


--[ Services ]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local DateService = DateTime.now()
local GuiService = game:GetService("GuiService")

--[ Variables ]

local ArborSystem = script.Parent
local SessionDetails = ArborSystem:WaitForChild("SessionDetails")
local System = ArborSystem:WaitForChild("System")

--[ Modules ]

local ArborInitializeModule = require(script.Modules.ArborInitialize)
local HomePageModule = require(script.Modules.HomePage)
local DropdownModule = require(script.Modules.Dropdowns)
local LoginPageModule = require(script.Modules.LoginPage)
local LoadDataModule = require(script.Modules.LoadData)
local DetentionsPageModule = require(script.Modules.DetentionsPage)
local BehaviourDashboardModule = require(script.Modules["BehaviourDashboardPage"])
local SchoolDetailsPage = require(script.Modules.SchoolDetailsPage)
local YearGroupModule = require(script.Modules.YearGroupPage)
local StaffAttendanceModule = require(script.Modules.StaffAttendancePage)
local LessonDisplayPageModule = require(script.Modules.LessonDisplayPage)
local BrowseUserPage = require(script.Modules.BrowseUserPage)
local TimetablePage = require(script.Modules.TimetablePage)
local Settings = require(ReplicatedStorage:WaitForChild("Arbor")["Settings"])
local HttpService = game:GetService("HttpService")
local PlayerData = ReplicatedStorage:WaitForChild("Arbor"):WaitForChild("ArborData").PlayerData

--[ Arbor Initialize ]

System.TopBar.SchoolLogo.Image = string.format("rbxthumb://type=Asset&id=%s&w=420&h=420", Settings["IconID"])
System.LicenceAgreement.Visible = true
System.TopBar.UserDetails.Text = Players.LocalPlayer.Name..', <u><font color="rgb(255, 146, 32)">Sign out</font></u>'

local ArborButton = ArborSystem:WaitForChild("ArborButton")
local LaunchButton = ArborButton.LowerFrame:WaitForChild("Launch")

if PlayerData:WaitForChild(Players.LocalPlayer.Name):WaitForChild("AccountEnabled", 3).Value == false then
	ArborButton.Visible = false
else
	ArborButton.Visible = true
end

ArborButton.MouseButton1Click:Connect(function()
	if ReplicatedStorage["Arbor"]["ArborData"].PlayerData[Players.LocalPlayer.Name].AccountEnabled.Value == true then
		if System.Visible == false then
			LaunchButton.Title.Text = "Launch"
		end

		ArborInitializeModule.ArborInteraction_Misc(ArborButton) 
		ArborInitializeModule.ArborInteraction_Rotation(ArborButton) 
		ArborInitializeModule.ArborInteraction_LowerFrame(ArborButton)
	end
end)

LaunchButton.MouseButton1Click:Connect(function()
	if LaunchButton.Title.Text == "Launch" then
		System:SetAttribute("LaunchPage", "HomePage")
		ArborInitializeModule.ArborLaunch(System)
		LaunchButton.Title.Text = "Close"
	else
		System.HomePage.Visible = false
		System.Visible = false
		LaunchButton.Title.Text = "Launch"
		DisableAllPages()

		ArborInitializeModule.ArborInteraction_Misc(ArborButton) 
		ArborInitializeModule.ArborInteraction_Rotation(ArborButton) 
		ArborInitializeModule.ArborInteraction_LowerFrame(ArborButton)
	end
end)

System.LicenceAgreement.Agree.MouseButton1Click:Connect(function()
	System.LicenceAgreement.Visible = false
end)

System.LicenceAgreement.SignOut.MouseButton1Click:Connect(function()
	DisableAllPages()
	System.HomePage.Visible = false
	System.Visible = false
	LaunchButton.Title.Text = "Launch"
end)

--[ Create Profile Page ]

local CreateProfilePage = ArborSystem:WaitForChild("CreateProfile")
local ConfirmProfilePrompt = ReplicatedStorage:WaitForChild("Arbor")["ArborEvents"].ConfirmProfilePrompt
local CreateProfilePrompt = ReplicatedStorage:WaitForChild("Arbor")["ArborEvents"].CreateProfilePrompt

CreateProfilePage.Notice.Text = "You are registering an Arbor account under the group: <u><b>"..Settings["SchoolName"].."</b></u>. Do you understand?"

CreateProfilePage.CheckBox.MouseButton1Click:Connect(function()
	CreateProfilePage.CheckBox.Ticked.Visible = not CreateProfilePage.CheckBox.Ticked.Visible
	CreateProfilePage.CheckBox.UIStroke.Color = Color3.fromRGB(131, 131, 131)
	CreateProfilePage.CheckBox.UIStroke.Thickness = 1
end)

local Gender = CreateProfilePage.Gender
local Dropdown = Gender.Select:FindFirstChild("Dropdown")

CreateProfilePage.Gender.Select.MouseButton1Click:Connect(function()
	Dropdown.Visible = not Dropdown.Visible
end)

for _, dropdownItem in pairs(Dropdown:GetChildren()) do
	if dropdownItem:IsA("TextButton") then
		dropdownItem.MouseButton1Click:Connect(function()
			Gender.Select.Input.Text = dropdownItem.Title.Text
			Dropdown.Visible = false
		end)
	elseif dropdownItem:IsA("TextLabel") then
		dropdownItem["BoxInput"].FocusLost:Connect(function()
			Gender.Select.Input.Text = dropdownItem.BoxInput.Text
			Dropdown.Visible = false
		end)
	end
end

CreateProfilePage.Confirm.MouseButton1Click:Connect(function()
	local NameInput = CreateProfilePage.EnterName:WaitForChild("BoxInput")

	if CreateProfilePage.CheckBox.Ticked.Visible then
		if string.len(NameInput.Text) >= 4 and string.len(NameInput.Text) <= 32 then
			if string.len(Gender.Select.Input.Text) <= 10 then
				local Data = {
					NameInput = NameInput.Text,
					GenderInput = Gender.Select.Input.Text
				}

				task.spawn(function()
					CreateProfilePage.Content.LoadFrame.Visible = true
					TweenService:Create(CreateProfilePage.Content.LoadFrame.Icon, TweenInfo.new(1.5, Enum.EasingStyle.Quart), {Rotation = 360}):Play()
					task.wait(1)
					CreateProfilePage.Content.LoadFrame.Visible = false
					TweenService:Create(CreateProfilePage.Content.LoadFrame.Icon, TweenInfo.new(.1, Enum.EasingStyle.Quart), {Rotation = 0}):Play()
				end)

				if ConfirmProfilePrompt:InvokeServer(Data) == false then
					ArborInitializeModule.DisplayError("Inappropriate input for name or gender, try again")
				else
					task.wait(1)

					CreateProfilePage.Visible = false
					ArborButton.Visible = true
				end
			else
				ArborInitializeModule.DisplayError("Gender input exceeds appropriate limit")
			end
		else
			ArborInitializeModule.DisplayError("Name is either too short or too long")
		end
	else
		ArborInitializeModule.DisplayError("You must agree in the checkbox highlighted to continue")
		CreateProfilePage.CheckBox.UIStroke.Color = Color3.fromRGB(255, 0, 0)
		CreateProfilePage.CheckBox.UIStroke.Thickness = 5
	end
end)

CreateProfilePrompt.OnClientEvent:Connect(function()
	CreateProfilePage.Visible = true
	ArborButton.Visible = false

	if Players.LocalPlayer:GetRankInGroup(Settings["GroupID"]) <= Settings["StudentID"] then
		for _, contentDescription in pairs(CreateProfilePage.Content.Descriptions.Student:GetChildren()) do
			contentDescription.Visible = true
		end
	elseif Players.LocalPlayer:GetRankInGroup(Settings["GroupID"]) >= Settings["StaffID"] then
		for _, contentDescription in pairs(CreateProfilePage.Content.Descriptions.Staff:GetChildren()) do
			contentDescription.Visible = true
		end
	end
end)

--[ Home Page ]

local HomePage = System:WaitForChild("HomePage")
local QuickActions = HomePage:WaitForChild("QuickActions")
local TopBar = System:WaitForChild("TopBar")

for _, button in pairs(QuickActions.Buttons:GetChildren()) do
	button.MouseButton1Click:Connect(function() HomePageModule.QuickActions_Select(button) HomePage.Visible = false end)
end

HomePage.DataOptions.List.ChildAdded:Connect(function()
	for _, dataOption in pairs(HomePage.DataOptions.List:GetChildren()) do
		if dataOption:IsA("TextButton") then
			dataOption.MouseButton1Click:Connect(function()
				HomePage.DataOptions:SetAttribute("CurrentSelection", dataOption.Name)
				for _, dataOption in pairs(HomePage.DataOptions.List:GetChildren()) do
					if dataOption:IsA("TextButton") then
						dataOption.BackgroundColor3 = Color3.new(0.92549, 0.92549, 0.92549)
					end
				end
				HomePage.DataOptions.WholeSchool.BackgroundColor3 = Color3.new(0.92549, 0.92549, 0.92549)
				dataOption.BackgroundColor3 = Color3.new(0.992157, 0.992157, 0.988235)
				
				LoadDataModule.LoadHomePageData()
			end)
		end
	end
end)

HomePage.DataOptions.WholeSchool.MouseButton1Click:Connect(function()
	HomePage.DataOptions:SetAttribute("CurrentSelection", "Whole School")
	for _, dataOption in pairs(HomePage.DataOptions.List:GetChildren()) do
		if dataOption:IsA("TextButton") then
			dataOption.BackgroundColor3 = Color3.new(0.92549, 0.92549, 0.92549)
		end
	end
	HomePage.DataOptions.WholeSchool.BackgroundColor3 = Color3.new(0.992157, 0.992157, 0.988235)
	LoadDataModule.LoadHomePageData()
end)

--[ Login Page ]

local LoginPage = System:WaitForChild("LoginPage")

LoginPage.RememberMe.MouseButton1Click:Connect(function()
	LoginPageModule.RememberMe_Init(LoginPage.RememberMe)
end)

LoginPage.ForgotUsername.MouseButton1Click:Connect(function()
	LoginPageModule.ForgotUsername(LoginPage.ForgotUsername)
end)

LoginPage.Login.MouseButton1Click:Connect(function()
	if System.LicenceAgreement.Visible == false then
		LoginPageModule.ConfirmLogin(LoginPage.Login)
		LoadDataModule.LoadHomePageData()
		LoadDataModule.LoadMemberCount()
	else
		ArborInitializeModule.DisplayError("You must abide to the agreement before continuing")
	end
end)

--[ School Timetable Page ]
TimetablePage.CreateTimetable(System:WaitForChild("TimetablePage"))

System.Dropdowns.SchoolDropdown.Timetable.MouseButton1Click:Connect(function()
	System:WaitForChild("TimetablePage").EditLesson.SelectedLesson.Value = nil
	System:WaitForChild("TimetablePage").EditLesson.Visible = false

	TimetablePage.LoadTimetable(System:WaitForChild("TimetablePage"))
	System:WaitForChild("TimetablePage").Visible = true

	for _, year in System:WaitForChild("TimetablePage").Timetable.TimetableContainer.CoreFrame:GetChildren() do
		if year.Name ~= "Times" and year.Name ~= "ColumnTemplate" and year:IsA("Frame") then
			for _, lesson in year:GetChildren() do
				if lesson:IsA("TextButton") then
					if lesson.Name ~= "Teams" and lesson.Details.Visible then
						if lesson:FindFirstChild("Popup") then
							lesson.Popup:Destroy()
						end
					end
				end
			end
		end
	end
end)

ReplicatedStorage:WaitForChild("Arbor")["ArborEvents"].UpdateTimetable.OnClientEvent:Connect(function()
	TimetablePage.LoadTimetable(System:WaitForChild("TimetablePage"))
	
	if Players.LocalPlayer:GetRankInGroup(Settings["GroupID"]) <= Settings["StudentID"] then
		System.TopBar.LowerBar.List.School.Visible = false
		System.TopBar.LowerBar.List.Students.Visible = false
		System.TopBar.LowerBar.List.System.Visible = false

		for i, Period in pairs(Settings["Periods"]) do
			if table.find(Settings["Teams"], game.Players.LocalPlayer.Team.Name) then
				local EventData = {
					["EventName"] = Period["Name"],
					["Note"] = "Lesson scheduled for: "..ReplicatedStorage["Arbor"]["ArborData"].PlayerData[Players.LocalPlayer.Name].OriginalYearGroup.Value.."/"..Period["Name"].." at "..Period["Time"],
					["Location"] = ReplicatedStorage["Arbor"]["ArborData"]["Lessons"][Period["Name"]][ReplicatedStorage["Arbor"]["ArborData"].PlayerData[Players.LocalPlayer.Name].OriginalYearGroup.Value].Room.Value,
					["Participants"] = ReplicatedStorage["Arbor"]["ArborData"].PlayerData[Players.LocalPlayer.Name].OriginalYearGroup.Value,
					["StartTime"] = Period["Time"],
					["EndTime"] = nil
				}

				if i == #Settings["Periods"] then
					EventData["EndTime"] = Settings["ClosureTime"]
				else
					EventData["EndTime"] = Settings["Periods"][i+1]["Time"]
				end

				if System.StudentView["MyCalendar"].List:FindFirstChild(EventData["EventName"]) then
					local EventClone = System.StudentView["MyCalendar"].List:FindFirstChild(EventData["EventName"])
					EventClone.LeftSide.Details.Text = EventData["StartTime"].." - "..EventData["EndTime"]
					EventClone.RightSide.Title.Text = EventData["EventName"]
					EventClone.NoteBox.NoteDesc.Text = "Location: "..EventData["Location"].." - "..EventData["Note"]
					EventClone:SetAttribute("StartTime", EventData["StartTime"])
					EventClone:SetAttribute("EndTime", EventData["EndTime"])
					EventClone:SetAttribute("StartTimeShort", (string.sub(EventData["StartTime"], 1, 2)..string.sub(EventData["StartTime"], 4, 6)))

					EventClone.RightSide.Title.Text = EventData["EventName"].." - "..EventData["Location"]
				else
					CreateStudentCalendarEvent(EventData, "StudentView")
				end
			end
		end
	end
end)

System:WaitForChild("TimetablePage").Timetable.TimetableContainer.Edit.MouseButton1Click:Connect(function()
	if Players.LocalPlayer:GetRankInGroup(Settings["GroupID"]) >= Settings["AdminID"] then
		if System:WaitForChild("TimetablePage").Timetable.TimetableContainer.Edit.Title.Text == "Edit" then
			System:WaitForChild("TimetablePage").Timetable.TimetableContainer.Edit.Title.Text = "Done"
		else
			System:WaitForChild("TimetablePage").Timetable.TimetableContainer.Edit.Title.Text = "Edit"
		end
	else
		ArborInitializeModule.DisplayError("You do not have permission to access this")
	end
end)

System:WaitForChild("TimetablePage").EditLesson.SaveLesson.MouseButton1Click:Connect(function()
	if Players.LocalPlayer:GetRankInGroup(Settings["GroupID"]) >= Settings["AdminID"] then
		local Details = {
			["SpecificValue"] = "LessonAbb",
			["Room"] = "Room",
			["Subject"] = "Subject",
			["StaffMember"] = "StaffName"
		}
		local UpdatedInfo = {}

		for i, v in Details do
			UpdatedInfo[i] = System:WaitForChild("TimetablePage").EditLesson.LessonInfo[v].Data.Text
		end

		ReplicatedStorage:WaitForChild("Arbor").ArborEvents.EditLesson:FireServer(UpdatedInfo, System:WaitForChild("TimetablePage").EditLesson.SelectedLesson.Value)

		System:WaitForChild("TimetablePage").EditLesson.SelectedLesson.Value = nil
		System:WaitForChild("TimetablePage").EditLesson.Visible = false
	else
		ArborInitializeModule.DisplayError("You do not have permission to access this")
	end
end)


System:WaitForChild("TimetablePage").EditLesson.Back.MouseButton1Click:Connect(function()
	System:WaitForChild("TimetablePage").EditLesson.SelectedLesson.Value = nil
	System:WaitForChild("TimetablePage").EditLesson.Visible = false
end)


for _, year in System:WaitForChild("TimetablePage").Timetable.TimetableContainer.CoreFrame:GetChildren() do
	if year.Name ~= "Times" and year.Name ~= "ColumnTemplate" and year:IsA("Frame") then
		for _, lesson in year:GetChildren() do
			if lesson:IsA("TextButton") then
				if lesson.Name ~= "Teams" and lesson.Details.Visible then
					lesson.Details.MouseEnter:Connect(function()
						if not System:WaitForChild("TimetablePage").EditLesson.Visible then
							local Popup

							if (lesson.LayoutOrder * (1 / (#year:GetChildren() - 2))) + 0.4 + (1 / (#year:GetChildren() - 2)) / 2 > 1 then
								Popup = System:WaitForChild("TimetablePage").Timetable.PopupD:Clone() 
							else
								Popup = System:WaitForChild("TimetablePage").Timetable.PopupU:Clone() 
							end
							
							Popup.Parent = lesson
							Popup.Visible = true

							Popup.DateData.Text = DateService:FormatLocalTime("dddd", "en-us")..", "..DateService:FormatLocalTime("D", "en-us").." "..DateService:FormatLocalTime("MMM", "en-us").." "..DateService:FormatLocalTime("YYYY", "en-us")
							Popup.LessonData.Text = ReplicatedStorage["Arbor"]["ArborData"]["Lessons"][lesson:GetAttribute("Lesson")][lesson:GetAttribute("Year")].SpecificValue.Value
							Popup.Title.Text = ReplicatedStorage["Arbor"]["ArborData"]["Lessons"][lesson:GetAttribute("Lesson")][lesson:GetAttribute("Year")].SpecificValue.Value
							Popup.StaffData.Text = ReplicatedStorage["Arbor"]["ArborData"]["Lessons"][lesson:GetAttribute("Lesson")][lesson:GetAttribute("Year")].StaffMember.Value
						end
					end)

					lesson.Details.MouseLeave:Connect(function()
						local find = lesson:FindFirstChild("PopupU") or lesson:FindFirstChild("PopupD")

						if find then
							find:Destroy()
							System.ClipsDescendants = true
						end
					end)

					lesson.Details.MouseButton1Click:Connect(function()
						if not System:WaitForChild("TimetablePage").EditLesson.Visible then
							if System:WaitForChild("TimetablePage").Timetable.TimetableContainer.Edit.Title.Text == "Edit" then
								DisableAllPages()
								System.LessonDisplayPage.Visible = true
								System.LessonDisplayPage.Page.Visible = true
								System.LessonDisplayPage.TakeRegisterPage.Visible = false
								
								LessonDisplayPageModule.ClearRegister()
								LessonDisplayPageModule.LoadCurrentLesson(lesson:GetAttribute("Lesson"), lesson:GetAttribute("Year"))
								LessonDisplayPageModule.InsertStudents(System.LessonDisplayPage.Page.LessonDetails:GetAttribute("Lesson"), System.LessonDisplayPage.Page.LessonDetails:GetAttribute("Year"))
							else
								local EditLessonPage = System:WaitForChild("TimetablePage").EditLesson
								local LessonObj = ReplicatedStorage["Arbor"]["ArborData"]["Lessons"][lesson:GetAttribute("Lesson")][lesson:GetAttribute("Year")]

								local Details = {
									["SpecificValue"] = "LessonAbb",
									["Room"] = "Room",
									["Subject"] = "Subject",
									["StaffMember"] = "StaffName"
								}

								EditLessonPage.SelectedLesson.Value = LessonObj

								for i, v in Details do
									EditLessonPage.LessonInfo[v].Data.Text = LessonObj[i].Value
								end

								EditLessonPage.Visible = true
							end
						end
					end)
				end
			end
		end
	end
end

--[ Lesson Display Page ]

local LessonDisplayPage = System:WaitForChild("LessonDisplayPage")
local TakeRegisterPage = LessonDisplayPage:WaitForChild("TakeRegisterPage")

TakeRegisterPage.SaveRegister.MouseButton1Click:Connect(function()
	if Players.LocalPlayer:GetRankInGroup(Settings["GroupID"]) >= Settings["StaffID"] then
		LessonDisplayPageModule.SaveRegister()
	end
end)

LessonDisplayPage.DashboardButton.MouseButton1Click:Connect(function()
	TakeRegisterPage.Visible = false
	LessonDisplayPage.Page.Visible = true
end)

LessonDisplayPage.SideBar.Back.MouseButton1Click:Connect(function()
	TakeRegisterPage.Visible = false
	LessonDisplayPage.Page.Visible = true
	LessonDisplayPage.Visible = false
	DisableAllPages()
	System.TimetablePage.Visible = true
	TimetablePage.LoadTimetable(System:WaitForChild("TimetablePage"))
end)

LessonDisplayPage.Behaviour.MouseButton1Click:Connect(function()
	TakeRegisterPage.Visible = false
	LessonDisplayPage.Page.Visible = true
	LessonDisplayPage.Visible = false
	DisableAllPages()
	System.BehaviourDashboard.Visible = true
end)

LessonDisplayPage.Page.Behaviour.Add.MouseButton1Click:Connect(function()
	TakeRegisterPage.Visible = false
	LessonDisplayPage.Page.Visible = true
	LessonDisplayPage.Visible = false
	DisableAllPages()
	System.BehaviourDashboard.Visible = true
end)

LessonDisplayPage.Page.TakeRegister.MouseButton1Click:Connect(function()
	TakeRegisterPage.Visible = true
	LessonDisplayPage.Page.Visible = false

	LessonDisplayPageModule.ClearRegister()
	LessonDisplayPageModule.StartRegister(LessonDisplayPage.Page.LessonDetails:GetAttribute("Lesson"), LessonDisplayPage.Page.LessonDetails:GetAttribute("Year"))
end)

LessonDisplayPage.CopyRegister.MouseButton1Click:Connect(function()
	local RegisterTable = LessonDisplayPageModule.CopyRegister()
	
	LessonDisplayPage.CopyPage.Details.InfoBox.Title.Text = ""
	LessonDisplayPage.CopyPage.Details.InfoBox.Title.Text = game:GetService("HttpService"):JSONEncode(RegisterTable)
	LessonDisplayPage.BlackFrame.Visible = true
	LessonDisplayPage.CopyPage.Visible = true
	LessonDisplayPage.CopyPage.Title.Text = "Copy Register"
	LessonDisplayPage.CopyPage.Details.TitleFrame.Title.Text = "Register for: "..LessonDisplayPage.Page.LessonDetails:GetAttribute("Year").." - "..LessonDisplayPage.Page.LessonDetails:GetAttribute("Lesson")
end)

LessonDisplayPage.CopyPage.Close.MouseButton1Click:Connect(function()
	LessonDisplayPage.CopyPage.Visible = false
	LessonDisplayPage.BlackFrame.Visible = false
end)

LessonDisplayPage.CopyStudentList.MouseButton1Click:Connect(function()
	LessonDisplayPage.CopyPage.Details.InfoBox.Title.Text = ""
	local RegisterTable = LessonDisplayPageModule.CopyRegister()
	local NewTable = {}

	for _, username in pairs(RegisterTable) do
		table.insert(NewTable, username["Username"])
	end

	LessonDisplayPage.CopyPage.Details.InfoBox.Title.Text = game:GetService("HttpService"):JSONEncode(NewTable)
	LessonDisplayPage.BlackFrame.Visible = true
	LessonDisplayPage.CopyPage.Visible = true
	LessonDisplayPage.CopyPage.Title.Text = "Copy Student List"
	LessonDisplayPage.CopyPage.Details.TitleFrame.Title.Text = "Students displayed for: "..LessonDisplayPage.Page.LessonDetails:GetAttribute("Year").." - "..LessonDisplayPage.Page.LessonDetails:GetAttribute("Lesson")
end)

--[ Behaviour Dashboard Page ]

local BehaviourDashboard = System:WaitForChild("BehaviourDashboard")
local BehaviourPointsDashboard = BehaviourDashboard:WaitForChild("BehaviourPointsDashboard")
local IncidentDashboadPage = BehaviourDashboard:WaitForChild("IncidentDashboardPage")
local MeritsDashboard = BehaviourDashboard:WaitForChild("MeritsDashboard")
local IsolationsDashboard = BehaviourDashboard:WaitForChild("IsolationsDashboard")
local TimeoutDashboard = BehaviourDashboard:WaitForChild("TimeoutDashboard")

local SideButtons = BehaviourDashboard:WaitForChild("SideButtons")

local BehaviourPoints = SideButtons["List"].BehaviourPoints
local Incidents = SideButtons["List"].Incidents
local Merits = SideButtons["List"].Merits
local Isolations = SideButtons["List"].Isolations
local Timeouts = SideButtons["List"].Timeout

--/ Incidents

local LogNewIncident = IncidentDashboadPage["LogNewIncident"]
local LogIncidentPage = IncidentDashboadPage["LogIncidentPage"]
local IncidentContainer = IncidentDashboadPage["Container"]
local BehaviouralIncidentPage = IncidentDashboadPage["BehaviouralIncidentPage"]

System.Dropdowns.BehaviourDropdown.BehaviouralIncidents.MouseButton1Click:Connect(function()
	BehaviourDashboardModule.DisableAllPages(Incidents.Dashboard)
	IncidentDashboadPage.Visible = true
	BehaviourDashboardModule.LoadIncidents()
end)

Incidents.Dashboard.MouseButton1Click:Connect(function()
	BehaviourDashboardModule.DisableAllPages(Incidents.Dashboard)
	IncidentDashboadPage.Visible = true
	IncidentDashboadPage.BehaviouralIncidentPage.Visible = false
	HideBehaviouralIncidentPage()
end)

Incidents.Reporting.MouseButton1Click:Connect(function()
	BehaviourDashboardModule.DisableAllPages(Incidents.Reporting)
	IncidentDashboadPage.Visible = true
	IncidentDashboadPage.BehaviouralIncidentPage.Visible = false
	IncidentDashboadPage.LogIncidentPage.Visible = true
	BehaviourDashboardModule.LoadIncidents()
	LogIncidentPage.NewWindow.TimeOfIncident.Box.Default.Text = ReplicatedStorage["Arbor"].ArborData.CurrentTime.Value
end)

LogNewIncident.MouseButton1Click:Connect(function()
	BehaviourDashboardModule.DisableAllPages(Incidents.Reporting)
	IncidentDashboadPage.Visible = true
	IncidentDashboadPage.BehaviouralIncidentPage.Visible = false
	IncidentDashboadPage.LogIncidentPage.Visible = true
	LogIncidentPage.NewWindow.TimeOfIncident.Box.Default.Text = ReplicatedStorage["Arbor"].ArborData.CurrentTime.Value
end)

IncidentContainer.TopBar.SearchTable.Input:GetPropertyChangedSignal("Text"):Connect(function()
	for _, incident in pairs(IncidentContainer.List.ListInner:GetChildren()) do
		if incident:IsA("TextButton") then
			incident.Visible = string.find(string.lower(incident.Name), string.lower(IncidentContainer.TopBar.SearchTable.Input.Text)) and true or false
			incident.Visible = string.find(string.lower(incident.Student.Text), string.lower(IncidentContainer.TopBar.SearchTable.Input.Text)) and true or false
		end
	end
end)

LogIncidentPage.NewWindow.DateOfIncident.Box.Default.Text = DateService:FormatLocalTime("ddd", "en-us")..", "..DateService:FormatLocalTime("D", "en-us").." "..DateService:FormatLocalTime("MMM", "en-us").." "..DateService:FormatLocalTime("YYYY", "en-us")
LogIncidentPage.NewWindow.StaffInvolved.Box.Default.Text = Players.LocalPlayer.Name

LogIncidentPage.NewWindow.TimeOfIncident.Box.Icon.MouseButton1Click:Connect(function()
	LogIncidentPage.NewWindow.TimeOfIncident.Box.Default.Text = ReplicatedStorage["Arbor"].ArborData.CurrentTime.Value
end)

LogIncidentPage.LogIncident.MouseButton1Click:Connect(function()
	local IncidentStudent

	if game.Players.LocalPlayer:GetRankInGroup(Settings["GroupID"]) >= Settings["StaffID"] then
		for _, Player in pairs(Players:GetPlayers()) do
			if Player.Name == LogIncidentPage.NewWindow.StudentsInvolved.Box.StudentName.Text then
				IncidentStudent = Player
			end
		end

		if IncidentStudent then
			if IncidentStudent:GetRankInGroup(Settings["GroupID"]) <= Settings["StudentID"] then
				local IncidentData = {
					["BehaviourType"] = LogIncidentPage.NewWindow.Behaviour.Box.Default.Text,
					["DateOfIncident"] = LogIncidentPage.NewWindow.DateOfIncident.Box.Default.Text,
					["IncidentSummary"] = LogIncidentPage.NewWindow.IncidentSummary.Box.Default.Text,
					["Lesson"] = LogIncidentPage.NewWindow.Lesson.Box.Default.Text,
					["Location"] = LogIncidentPage.NewWindow.Location.Box.Default.Text,
					["IncidentSeverity"] = LogIncidentPage.NewWindow.IncidentSeverity.Box.Default.Text,
					["StaffInvolved"] = LogIncidentPage.NewWindow.StaffInvolved.Box.Default.Text,
					["StudentUsername"] = LogIncidentPage.NewWindow.StudentsInvolved.Box.StudentName.Text,
					["OtherStudents"] = LogIncidentPage.NewWindow.StudentsInvolved.Box.OtherStudents.Text,
					["TimeOfIncident"] = LogIncidentPage.NewWindow.TimeOfIncident.Box.Default.Text
				}

				BehaviourDashboardModule.LogIncident(IncidentStudent, game.Players.LocalPlayer, IncidentData)
				ArborInitializeModule.DisplayError("Incident has been successfully logged")
			else
				ArborInitializeModule.DisplayError("This user is not a student")
			end
		else
			ArborInitializeModule.DisplayError("Invalid student name provided")
		end
	else
		ArborInitializeModule.DisplayError("You do not have permission to do this")
	end

	LogIncidentPage.Visible = false
	wait(1)
	BehaviourDashboardModule.LoadIncidents()
end)

ReplicatedStorage:WaitForChild("Arbor").ArborEvents.LogIncident.OnClientEvent:Connect(function(Staff, IncidentData)
	local Receiver = game.Players.LocalPlayer
	local IncidentAlert = ArborSystem:WaitForChild("IncidentAlert")
	local IncidentInfo = IncidentAlert:WaitForChild("IncidentInfo")

	IncidentAlert.ByUser.Text = "by "..IncidentData["StaffInvolved"].." ("..ReplicatedStorage["Arbor"].ArborData.PlayerData[Staff.Name].RoleplayName.Value..")"
	IncidentInfo.Location.Data.Text = IncidentData["Location"]
	IncidentInfo.Severity.Data.Text = IncidentData["IncidentSeverity"]
	IncidentInfo.StaffInvolved.Data.Text = IncidentData["StaffInvolved"]
	IncidentInfo.OtherStudents.Data.Text = IncidentData["OtherStudents"]
	IncidentInfo.StudentUsername.Data.Text = IncidentData["StudentUsername"]
	IncidentInfo.DateTime.Data.Text = IncidentData["DateOfIncident"]..", "..IncidentData["TimeOfIncident"]
	IncidentInfo.Lesson.Data.Text = IncidentData["Lesson"]

	ArborSystem["IncidentAlert"].Visible = true
end)

ArborSystem["IncidentAlert"]["Close"].MouseButton1Click:Connect(function()
	ArborSystem["IncidentAlert"].Visible = false
end)

LogIncidentPage.Cancel.MouseButton1Click:Connect(function()
	BehaviourDashboardModule.DisableAllPages(Incidents.Dashboard)
	IncidentDashboadPage.Visible = true
	IncidentDashboadPage.LogIncidentPage.Visible = false
	IncidentDashboadPage.BehaviouralIncidentPage.Visible = false
	BehaviourDashboardModule.LoadIncidents()
end)

local Mouse = game:GetService("Players").LocalPlayer:GetMouse()
local MouseObject = nil

IncidentContainer.List.ListInner.ChildAdded:Connect(function(object)
	if object:IsA("TextButton") then
		if object:FindFirstChild("IncidentObject") then
			object.MouseButton1Click:Connect(function()
				LogIncidentPage.Visible = false
				BehaviouralIncidentPage.Visible = true
				BehaviourDashboardModule.LoadCurrentIncident(object)

				if MouseObject then
					MouseObject:Disconnect()
					IncidentContainer.List.Popup.Visible = false
				end
			end)
		end
	end
end)

function HideBehaviouralIncidentPage()
	if MouseObject then
		MouseObject:Disconnect()
		IncidentContainer.List.Popup.Visible = false
	end

	BehaviouralIncidentPage.Visible = false
	IncidentContainer.Visible = true
	IncidentDashboadPage.Separator.Visible = true
	LogIncidentPage.Visible = false
	IncidentDashboadPage.LogNewIncident.Visible = true
	IncidentDashboadPage.Title.Visible = true

	wait(1)
	BehaviourDashboardModule.LoadIncidents()
end

BehaviouralIncidentPage.Back.MouseButton1Click:Connect(function()
	HideBehaviouralIncidentPage()
end)

BehaviouralIncidentPage.ResolveIncident.MouseButton1Click:Connect(function()
	if Players.LocalPlayer:GetRankInGroup(Settings["GroupID"]) >= Settings["StaffID"] then
		BehaviourDashboardModule.ResolveDeleteIncident("Resolve", BehaviouralIncidentPage.Incident.Value)
		ArborInitializeModule.DisplayError("Incident has been resolved")
		HideBehaviouralIncidentPage()
	end
end)

BehaviouralIncidentPage.DeleteIncident.MouseButton1Click:Connect(function()
	if Players.LocalPlayer:GetRankInGroup(Settings["GroupID"]) >= Settings["StaffID"] then
		BehaviourDashboardModule.ResolveDeleteIncident("Delete", BehaviouralIncidentPage.Incident.Value)
		ArborInitializeModule.DisplayError("Incident has been deleted")
		HideBehaviouralIncidentPage()
	end
end)

ReplicatedStorage["Arbor"]:WaitForChild("ArborEvents").ResolveDeleteIncident.OnClientEvent:Connect(function(IncidentStatus, Incident)
	if IncidentStatus == "Resolve" then
		ArborInitializeModule.DisplayError("The incident you have been involved in has been resolved")
	elseif IncidentStatus == "Delete" then
		ArborInitializeModule.DisplayError("The incident you have been involved in has been deleted")
	end
end)

--/ Isolations

local LogIsolationPage = IsolationsDashboard["LogIsolationPage"]
local IsolationContainer = IsolationsDashboard["Container"]
local LogNewIsolation = IsolationsDashboard["LogNewIsolation"]
local IsolationPage = IsolationsDashboard["IsolationPage"]

System.Dropdowns.BehaviourDropdown.Isolations.MouseButton1Click:Connect(function()
	BehaviourDashboardModule.DisableAllPages(Isolations.Dashboard)
	IsolationsDashboard.Visible = true
	LogIsolationPage.Visible = false
	BehaviourDashboardModule.LoadIsolations()
end)

Isolations.Dashboard.MouseButton1Click:Connect(function()
	BehaviourDashboardModule.DisableAllPages(Isolations.Dashboard)
	IsolationsDashboard.Visible = true
	LogIsolationPage.Visible = false
	BehaviourDashboardModule.LoadIsolations()
end)

Isolations.Reporting.MouseButton1Click:Connect(function()
	BehaviourDashboardModule.DisableAllPages(Isolations.Reporting)
	IsolationsDashboard.Visible = true
	LogIsolationPage.Visible = true
	BehaviourDashboardModule.LoadIsolations()
	LogIsolationPage.NewWindow.DateOfIncident.Box.Default.Text = DateService:FormatLocalTime("D", "en-us").." "..DateService:FormatLocalTime("MMM", "en-us").." "..DateService:FormatLocalTime("YYYY", "en-us")
	LogIsolationPage.NewWindow.TimeOfIncident.Box.Default.Text = ReplicatedStorage["Arbor"].ArborData.CurrentTime.Value
	LogIsolationPage.NewWindow.Staff.Box.Default.Text = game.Players.LocalPlayer.Name
end)

LogNewIsolation.MouseButton1Click:Connect(function()
	BehaviourDashboardModule.DisableAllPages(Isolations.Reporting)
	IsolationsDashboard.Visible = true
	LogIsolationPage.Visible = true
	BehaviourDashboardModule.LoadIsolations()
	LogIsolationPage.NewWindow.DateOfIncident.Box.Default.Text = DateService:FormatLocalTime("D", "en-us").." "..DateService:FormatLocalTime("MMM", "en-us").." "..DateService:FormatLocalTime("YYYY", "en-us")
	LogIsolationPage.NewWindow.TimeOfIncident.Box.Default.Text = ReplicatedStorage["Arbor"].ArborData.CurrentTime.Value
	LogIsolationPage.NewWindow.Staff.Box.Default.Text = game.Players.LocalPlayer.Name
end)

LogIsolationPage.NewWindow.TimeOfIncident.Box.Icon.MouseButton1Click:Connect(function()
	LogIsolationPage.NewWindow.TimeOfIncident.Box.Default.Text = ReplicatedStorage["Arbor"].ArborData.CurrentTime.Value
end)

LogIsolationPage.LogIsolation.MouseButton1Click:Connect(function()
	local IsolationStudent

	if game.Players.LocalPlayer:GetRankInGroup(Settings["GroupID"]) >= Settings["StaffID"] then
		for _, Player in pairs(game:GetService("Players"):GetPlayers()) do
			if LogIsolationPage.NewWindow.Student.Box.StudentName.Text == Player.Name then
				IsolationStudent = Player
			end
		end

		if IsolationStudent then
			if IsolationStudent:GetRankInGroup(Settings["GroupID"]) <= Settings["StudentID"] then
				local IsolationData = {
					["Behaviour"] = LogIsolationPage.NewWindow.Behaviour.Box.Default.Text,
					["DateOfIncident"] = LogIsolationPage.NewWindow.DateOfIncident.Box.Default.Text,
					["IsolationReason"] = LogIsolationPage.NewWindow.IsolationReason.Box.Default.Text,
					["Staff"] = LogIsolationPage.NewWindow.Staff.Box.Default.Text,
					["Student"] = LogIsolationPage.NewWindow.Student.Box.StudentName.Text,
					["TimeOfIncident"] = LogIsolationPage.NewWindow.TimeOfIncident.Box.Default.Text
				}

				BehaviourDashboardModule.LogIsolation(IsolationStudent, game.Players.LocalPlayer, IsolationData)
			else
				ArborInitializeModule.DisplayError("This user is not a student")
			end
		else
			print(IsolationStudent)
			ArborInitializeModule.DisplayError("Invalid student name provided")
		end
	else
		ArborInitializeModule.DisplayError("You do not have permission to do this")
	end

	LogIsolationPage.Visible = false
	wait(1)
	BehaviourDashboardModule.LoadIsolations()
end)

ReplicatedStorage:WaitForChild("Arbor").ArborEvents.LogTimeout.OnClientEvent:Connect(function(Staff, IsolationData)
	local Receiver = game.Players.LocalPlayer
	local IsolationAlert = ArborSystem["IsolationAlert"]
	local IsolationInfo = IsolationAlert["IsolationInfo"]

	IsolationAlert.ByUser.Text = "by "..Staff.Name.." ("..ReplicatedStorage["Arbor"].ArborData.PlayerData[Staff.Name].RoleplayName.Value..")"

	for Name, Item in pairs(IsolationData) do
		if IsolationInfo[Name] then
			IsolationInfo[Name].Data.Text = Item
		end
	end

	IsolationAlert.Visible = true
end)

ArborSystem["IsolationAlert"].Close.MouseButton1Click:Connect(function()
	ArborSystem["IsolationAlert"].Visible = false
end)

LogIsolationPage.Cancel.MouseButton1Click:Connect(function()
	BehaviourDashboardModule.DisableAllPages(Isolations.Dashboard)
	IsolationsDashboard.Visible = true
	LogIsolationPage.Visible = false
	BehaviourDashboardModule.LoadIsolations()
end)

IsolationContainer.TopBar.SearchTable.Input:GetPropertyChangedSignal("Text"):Connect(function()
	for _, incident in pairs(IsolationContainer.List.ListInner:GetChildren()) do
		if incident:IsA("TextButton") then
			incident.Visible = string.find(string.lower(incident.Name), string.lower(IsolationContainer.TopBar.SearchTable.Input.Text)) and true or false
			incident.Visible = string.find(string.lower(incident.Student.Text), string.lower(IsolationContainer.TopBar.SearchTable.Input.Text)) and true or false
		end
	end
end)

IsolationContainer.List.ListInner.ChildAdded:Connect(function(isolation)
	if isolation:IsA("TextButton") then
		isolation.MouseButton1Click:Connect(function()
			if not LogIsolationPage.Visible then
				local obj = isolation.IsolationObject.Value

				IsolationPage.Isolation.Value = obj.StudentObj.Value
				IsolationPage.Container.IsolationInfo.Time.Data.Text = obj.TimeOfIncident.Value
				IsolationPage.Container.IsolationInfo.Date.Data.Text = obj.DateOfIncident.Value
				IsolationPage.Container.IsolationInfo.Username.Data.Text = obj.Student.Value
				IsolationPage.Container.IsolationInfo.Reason.Data.Text = obj.IsolationReason.Value
				IsolationPage.Container.IsolationInfo.Behaviour.Data.Text = obj.Behaviour.Value
				IsolationPage.Container.IsolationInfo.Staff.Data.Text = obj.Staff.Value

				IsolationPage.Visible = true
			end
		end)
	end
end)

IsolationPage.Container.Back.MouseButton1Click:Connect(function()
	IsolationPage.Visible = false
	IsolationPage.Isolation.Value = nil
end)

IsolationPage.Container.RespawnUser.MouseButton1Click:Connect(function()
	IsolationPage.Container.RespawnUser.Ticked.Visible = not IsolationPage.Container.RespawnUser.Ticked.Visible
end)

IsolationPage.Container.Delete.MouseButton1Click:Connect(function()
	BehaviourDashboardModule.DeleteIsolation(Players.LocalPlayer, IsolationPage.Isolation.Value, IsolationPage.Container.RespawnUser.Ticked.Visible)
	IsolationPage.Visible = false
	IsolationPage.Isolation.Value = nil

	wait(0.5)
	BehaviourDashboardModule.LoadIsolations()
end)

--/ Timeout

local LogTimeoutPage = TimeoutDashboard["LogTimeoutPage"]
local TimeoutContainer = TimeoutDashboard["Container"]
local LogNewTimeout = TimeoutDashboard["LogNewTimeout"]
local TimeoutPage = TimeoutDashboard["TimeoutPage"]

System.Dropdowns.BehaviourDropdown.Timeout.MouseButton1Click:Connect(function()
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

	LogIsolationPage.Visible = false
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
			incident.Visible = string.find(string.lower(incident.Name), string.lower(TimeoutContainer.TopBar.SearchTable.Input.Text)) and true or false
			incident.Visible = string.find(string.lower(incident.Student.Text), string.lower(TimeoutContainer.TopBar.SearchTable.Input.Text)) and true or false
		end
	end
end)

TimeoutContainer.List.ListInner.ChildAdded:Connect(function(Timeout)
	if Timeout:IsA("TextButton") then
		Timeout.MouseButton1Click:Connect(function()
			if not LogTimeoutPage.Visible then
				local obj = Timeout.TimeoutObject.Value

				TimeoutPage.Timeout.Value = obj.StudentObj.Value
				TimeoutPage.Container.IsolationInfo.Time.Data.Text = obj.TimeOfIncident.Value
				TimeoutPage.Container.IsolationInfo.Date.Data.Text = obj.DateOfIncident.Value
				TimeoutPage.Container.IsolationInfo.Username.Data.Text = obj.Student.Value
				TimeoutPage.Container.IsolationInfo.Reason.Data.Text = obj.IsolationReason.Value
				TimeoutPage.Container.IsolationInfo.Behaviour.Data.Text = obj.Behaviour.Value
				TimeoutPage.Container.IsolationInfo.Staff.Data.Text = obj.Staff.Value

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

--/ Merits

local MeritsContainer = MeritsDashboard:WaitForChild("Container")
local LogMeritPage = MeritsDashboard:WaitForChild("LogMeritPage")
local Award = MeritsDashboard:WaitForChild("Award")

System.Dropdowns.BehaviourDropdown.Merits.MouseButton1Click:Connect(function()
	BehaviourDashboardModule.DisableAllPages(Merits.Dashboard)
	MeritsDashboard.Visible = true
	MeritsDashboard.LogMeritPage.Visible = false
	BehaviourDashboardModule.LoadMerits()
end)

Merits.Dashboard.MouseButton1Click:Connect(function()
	BehaviourDashboardModule.DisableAllPages(Merits.Dashboard)
	MeritsDashboard.Visible = true
	MeritsDashboard.LogMeritPage.Visible = false
	BehaviourDashboardModule.LoadMerits()
end)

Merits.Reporting.MouseButton1Click:Connect(function()
	BehaviourDashboardModule.DisableAllPages(Merits.Reporting)
	MeritsDashboard.Visible = true
	MeritsDashboard.LogMeritPage.Visible = true
	BehaviourDashboardModule.LoadMerits()
	LogMeritPage.NewWindow.GivenAt.Box.Default.Text = ReplicatedStorage["Arbor"].ArborData.CurrentTime.Value..", "..DateService:FormatLocalTime("D", "en-us").." "..DateService:FormatLocalTime("MMM", "en-us").." "..DateService:FormatLocalTime("YYYY", "en-us")
	LogMeritPage.NewWindow.GivenBy.Box.Default.Text = game.Players.LocalPlayer.Name
end)

Award.MouseButton1Click:Connect(function()
	BehaviourDashboardModule.DisableAllPages(Merits.Reporting)
	MeritsDashboard.Visible = true
	MeritsDashboard.LogMeritPage.Visible = true
	BehaviourDashboardModule.LoadMerits()
	LogMeritPage.NewWindow.GivenAt.Box.Default.Text = ReplicatedStorage["Arbor"].ArborData.CurrentTime.Value..", "..DateService:FormatLocalTime("ddd", "en-us").." "..DateService:FormatLocalTime("D", "en-us").." "..DateService:FormatLocalTime("MMM", "en-us").." "..DateService:FormatLocalTime("YYYY", "en-us")
	LogMeritPage.NewWindow.GivenBy.Box.Default.Text = game.Players.LocalPlayer.Name
end)

LogMeritPage.NewWindow.GivenAt.Box.Icon.MouseButton1Click:Connect(function()
	LogMeritPage.NewWindow.GivenAt.Box.Default.Text = ReplicatedStorage["Arbor"].ArborData.CurrentTime.Value..", "..DateService:FormatLocalTime("ddd", "en-us").." "..DateService:FormatLocalTime("D", "en-us").." "..DateService:FormatLocalTime("MMM", "en-us").." "..DateService:FormatLocalTime("YYYY", "en-us")
end)

LogMeritPage.LogMerit.MouseButton1Click:Connect(function()
	local MeritStudent

	if game.Players.LocalPlayer:GetRankInGroup(Settings["GroupID"]) >= Settings["StaffID"] then
		for _, Player in pairs(game:GetService("Players"):GetPlayers()) do
			if Player.Name == LogMeritPage.NewWindow.Student.Box.Default.Text then
				MeritStudent = Player
			end
		end

		if MeritStudent then
			if MeritStudent:GetRankInGroup(Settings["GroupID"]) <= Settings["StudentID"] then
				local MeritData = {
					["GivenAt"] = LogMeritPage.NewWindow.GivenAt.Box.Default.Text,
					["GivenBy"] = LogMeritPage.NewWindow.GivenBy.Box.Default.Text,
					["Location"] = LogMeritPage.NewWindow.Location.Box.Default.Text,
					["ReasonAttribute"] = LogMeritPage.NewWindow.ReasonAttribute.Box.Default.Text,
					["Student"] = LogMeritPage.NewWindow.Student.Box.Default.Text,
					["TotalAwarded"] = LogMeritPage.NewWindow.TotalAwarded.Box.Default.Text
				}

				if typeof(tonumber(MeritData["TotalAwarded"])) == "number" then
					if tonumber(MeritData["TotalAwarded"]) >= 1 then
						if tonumber(MeritData["TotalAwarded"]) <= 10 then
							BehaviourDashboardModule.LogMerit(MeritStudent, game.Players.LocalPlayer, MeritData)
							ArborInitializeModule.DisplayError("Merit has been successfully logged")
						else
							ArborInitializeModule.DisplayError("Total awarded data exceeds appropriate limit")
						end
					else
						ArborInitializeModule.DisplayError("Total awarded must be above 0")
					end
				else
					ArborInitializeModule.DisplayError("Invalid data type provided")
				end
			else
				ArborInitializeModule.DisplayError("This user is not a student")
			end
		else
			ArborInitializeModule.DisplayError("Invalid student name provided")
		end
	else
		ArborInitializeModule.DisplayError("You do not have permission to do this")
	end

	LogMeritPage.Visible = false
	wait(1)
	BehaviourDashboardModule.LoadMerits()
end)

ReplicatedStorage:WaitForChild("Arbor").ArborEvents.LogMerit.OnClientEvent:Connect(function(Staff, MeritData)
	local Receiver = game.Players.LocalPlayer
	local MeritAlert = ArborSystem:WaitForChild("MeritAlert")
	local MeritInfo = MeritAlert["MeritInfo"]

	MeritAlert.ByUser.Text = "by "..Staff.Name.." ("..ReplicatedStorage["Arbor"].ArborData.PlayerData[Staff.Name].RoleplayName.Value..")"

	for Name, Item in pairs(MeritData) do
		if MeritInfo[Name] then
			MeritInfo[Name].Data.Text = Item
		end
	end

	ArborSystem["MeritAlert"].Visible = true
end)

ArborSystem["MeritAlert"].Close.MouseButton1Click:Connect(function()
	ArborSystem["MeritAlert"].Visible = false
end)

LogMeritPage.Cancel.MouseButton1Click:Connect(function()
	BehaviourDashboardModule.DisableAllPages(Merits.Dashboard)
	MeritsDashboard.Visible = true
	MeritsDashboard.LogMeritPage.Visible = false
	BehaviourDashboardModule.LoadMerits()
end)

--/ Behaviour Points

local BehaviourPointsContainer = BehaviourPointsDashboard:WaitForChild("Container")
local LogBehaviourPointPage = BehaviourPointsDashboard:WaitForChild("LogBehaviourPointPage")
local AwardBehaviourPoint = BehaviourPointsDashboard:WaitForChild("Award")

System.Dropdowns.BehaviourDropdown.BehaviourPoints.MouseButton1Click:Connect(function()
	BehaviourDashboardModule.DisableAllPages(BehaviourPoints.Dashboard)
	BehaviourPointsDashboard.Visible = true
	BehaviourPointsDashboard.LogBehaviourPointPage.Visible = false
	BehaviourDashboardModule.LoadBehaviourPoints()
end)

BehaviourPoints.Dashboard.MouseButton1Click:Connect(function()
	BehaviourDashboardModule.DisableAllPages(BehaviourPoints.Dashboard)
	BehaviourPointsDashboard.Visible = true
	BehaviourPointsDashboard.LogBehaviourPointPage.Visible = false
	BehaviourDashboardModule.LoadBehaviourPoints()
end)

BehaviourPoints.Reporting.MouseButton1Click:Connect(function()
	BehaviourDashboardModule.DisableAllPages(BehaviourPoints.Reporting)
	BehaviourPointsDashboard.Visible = true
	BehaviourPointsDashboard.LogBehaviourPointPage.Visible = true
	BehaviourDashboardModule.LoadBehaviourPoints()
	LogBehaviourPointPage.NewWindow.GivenAt.Box.Default.Text = ReplicatedStorage["Arbor"].ArborData.CurrentTime.Value..", "..DateService:FormatLocalTime("D", "en-us").." "..DateService:FormatLocalTime("MMM", "en-us").." "..DateService:FormatLocalTime("YYYY", "en-us")
	LogBehaviourPointPage.NewWindow.GivenBy.Box.Default.Text = game.Players.LocalPlayer.Name
end)

AwardBehaviourPoint.MouseButton1Click:Connect(function()
	BehaviourDashboardModule.DisableAllPages(BehaviourPoints.Reporting)
	BehaviourPointsDashboard.Visible = true
	BehaviourPointsDashboard.LogBehaviourPointPage.Visible = true
	BehaviourDashboardModule.LoadBehaviourPoints()
	LogBehaviourPointPage.NewWindow.GivenAt.Box.Default.Text = ReplicatedStorage["Arbor"].ArborData.CurrentTime.Value..", "..DateService:FormatLocalTime("ddd", "en-us").." "..DateService:FormatLocalTime("D", "en-us").." "..DateService:FormatLocalTime("MMM", "en-us").." "..DateService:FormatLocalTime("YYYY", "en-us")
	LogBehaviourPointPage.NewWindow.GivenBy.Box.Default.Text = game.Players.LocalPlayer.Name
end)

LogBehaviourPointPage.NewWindow.GivenAt.Box.Icon.MouseButton1Click:Connect(function()
	LogBehaviourPointPage.NewWindow.GivenAt.Box.Default.Text = ReplicatedStorage["Arbor"].ArborData.CurrentTime.Value..", "..DateService:FormatLocalTime("ddd", "en-us").." "..DateService:FormatLocalTime("D", "en-us").." "..DateService:FormatLocalTime("MMM", "en-us").." "..DateService:FormatLocalTime("YYYY", "en-us")
end)

LogBehaviourPointPage.LogBehaviourPoint.MouseButton1Click:Connect(function()
	local BehaviourPointStudent

	if game.Players.LocalPlayer:GetRankInGroup(Settings["GroupID"]) >= Settings["StaffID"] then
		for _, Player in pairs(game:GetService("Players"):GetPlayers()) do
			if Player.Name == LogBehaviourPointPage.NewWindow.Student.Box.Default.Text then
				BehaviourPointStudent = Player
			end
		end

		if BehaviourPointStudent then
			if BehaviourPointStudent:GetRankInGroup(Settings["GroupID"]) <= Settings["StudentID"] then
				local BehaviourPointData = {
					["GivenAt"] = LogBehaviourPointPage.NewWindow.GivenAt.Box.Default.Text,
					["GivenBy"] = LogBehaviourPointPage.NewWindow.GivenBy.Box.Default.Text,
					["Location"] = LogBehaviourPointPage.NewWindow.Location.Box.Default.Text,
					["ReasonAttribute"] = LogBehaviourPointPage.NewWindow.ReasonAttribute.Box.Default.Text,
					["Student"] = LogBehaviourPointPage.NewWindow.Student.Box.Default.Text,
					["TotalAwarded"] = LogBehaviourPointPage.NewWindow.TotalAwarded.Box.Default.Text
				}

				if typeof(tonumber(BehaviourPointData["TotalAwarded"])) == "number" then
					if tonumber(BehaviourPointData["TotalAwarded"]) >= 1 then
						if tonumber(BehaviourPointData["TotalAwarded"]) <= 10 then
							BehaviourDashboardModule.LogBehaviourPoint(BehaviourPointStudent, game.Players.LocalPlayer, BehaviourPointData)
							ArborInitializeModule.DisplayError("Behaviour point has been successfully logged")
						else
							ArborInitializeModule.DisplayError("Total awarded data exceeds appropriate limit")
						end
					else
						ArborInitializeModule.DisplayError("Total awarded must be above 0")
					end
				else
					ArborInitializeModule.DisplayError("Invalid data type provided")
				end
			else
				ArborInitializeModule.DisplayError("This user is not a student")
			end
		else
			ArborInitializeModule.DisplayError("Invalid student name provided")
		end
	else
		ArborInitializeModule.DisplayError("You do not have permission to do this")
	end

	LogBehaviourPointPage.Visible = false
	wait(1)
	BehaviourDashboardModule.LoadBehaviourPoints()
end)

ReplicatedStorage:WaitForChild("Arbor").ArborEvents.LogBehaviourPoint.OnClientEvent:Connect(function(Staff, BehaviourPointData)
	local Receiver = game.Players.LocalPlayer
	local BehaviourPointAlert = ArborSystem:WaitForChild("BehaviourPointAlert")
	local BehaviourPointInfo = BehaviourPointAlert["BehaviourPointInfo"]

	BehaviourPointAlert.ByUser.Text = "by "..Staff.Name.." ("..ReplicatedStorage["Arbor"].ArborData.PlayerData[Staff.Name].RoleplayName.Value..")"

	for Name, Item in pairs(BehaviourPointData) do
		if BehaviourPointInfo[Name] then
			BehaviourPointInfo[Name].Data.Text = Item
		end
	end

	ArborSystem["BehaviourPointAlert"].Visible = true
end)

ArborSystem["BehaviourPointAlert"].Close.MouseButton1Click:Connect(function()
	ArborSystem["BehaviourPointAlert"].Visible = false
end)


LogBehaviourPointPage.Cancel.MouseButton1Click:Connect(function()
	BehaviourDashboardModule.DisableAllPages(BehaviourPoints.Dashboard)
	BehaviourPointsDashboard.Visible = true
	BehaviourPointsDashboard.LogBehaviourPointPage.Visible = false
	BehaviourDashboardModule.LoadBehaviourPoints()
end)

--[ Staff Attendance Page ]

local StaffAttendancePage = System:WaitForChild("StaffAttendancePage")

System.Dropdowns.StaffDropdown.StaffAttendance.MouseButton1Click:Connect(function()
	StaffAttendanceModule.InsertAllStaff()
	System:WaitForChild("StaffAttendancePage").Visible = true
	System.StaffAttendancePage.BlackFrame.Visible = false
end)

StaffAttendancePage.OuterList.List.ChildAdded:Connect(function()
	for i, staff in pairs(StaffAttendancePage.OuterList.List:GetChildren()) do
		if staff:IsA("Frame") then
			staff.Log.MouseButton1Click:Connect(function()
				if Players.LocalPlayer:GetRankInGroup(Settings["GroupID"]) >= Settings["AdminID"] then
					if StaffAttendancePage.OuterList.FocusedOn.Value == nil then
						if staff["LogPage"].Visible == false then
							staff["LogPage"].Visible = true

							StaffAttendancePage.OuterList.FocusedOn.Value = staff
							StaffAttendanceModule.ApplyVisualFX(staff)
							StaffAttendancePage.OuterList.ClipsDescendants = false
						else

							StaffAttendancePage.OuterList.FocusedOn.Value = nil
							StaffAttendanceModule.RemoveVisualFX(staff)
							StaffAttendancePage.OuterList.ClipsDescendants = true
							staff["LogPage"].Visible = false
						end
					end
				else
					ArborInitializeModule.DisplayError("You do not have permission to do this")
				end
			end)

			staff:WaitForChild("LogPage").Late.MouseButton1Click:Connect(function()
				staff["LogPage"].Visible = false
				StaffAttendanceModule.RemoveVisualFX(staff)
				StaffAttendancePage.BlackFrame.Visible = false
				StaffAttendancePage.OuterList.FocusedOn.Value = nil
				ReplicatedStorage:WaitForChild("Arbor")["ArborEvents"].LogStaffAttendance:FireServer(staff.User.Value, "Late")
				StaffAttendanceModule.UpdateStaffData(staff, staff.User.Value, "Late")
				StaffAttendanceModule.ActiveLoading(staff)
			end)

			staff:WaitForChild("LogPage").Late.MouseEnter:Connect(function()
				StaffAttendanceModule.ApplyVisualFX_Button(staff, staff["LogPage"]["Late"])
			end)

			staff:WaitForChild("LogPage").Late.MouseLeave:Connect(function()
				StaffAttendanceModule.RemoveVisualFX_Button(staff, staff["LogPage"]["Late"])
			end)

			staff:WaitForChild("LogPage").Present.MouseEnter:Connect(function()
				StaffAttendanceModule.ApplyVisualFX_Button(staff, staff["LogPage"]["Present"])
			end)

			staff:WaitForChild("LogPage").Present.MouseLeave:Connect(function()
				StaffAttendanceModule.RemoveVisualFX_Button(staff, staff["LogPage"]["Present"])
			end)

			staff:WaitForChild("LogPage").Absent.MouseEnter:Connect(function()
				StaffAttendanceModule.ApplyVisualFX_Button(staff, staff["LogPage"]["Absent"])
			end)

			staff:WaitForChild("LogPage").Absent.MouseLeave:Connect(function()
				StaffAttendanceModule.RemoveVisualFX_Button(staff, staff["LogPage"]["Absent"])
			end)

			staff:WaitForChild("LogPage").Present.MouseButton1Click:Connect(function()
				staff["LogPage"].Visible = false
				StaffAttendanceModule.RemoveVisualFX(staff)
				StaffAttendancePage.BlackFrame.Visible = false
				StaffAttendancePage.OuterList.FocusedOn.Value = nil
				ReplicatedStorage:WaitForChild("Arbor")["ArborEvents"].LogStaffAttendance:FireServer(staff.User.Value, "Present")
				StaffAttendanceModule.UpdateStaffData(staff, staff.User.Value, "Present")
				StaffAttendanceModule.ActiveLoading(staff)
			end)

			staff:WaitForChild("LogPage").Close.MouseButton1Click:Connect(function()
				staff["LogPage"].Visible = false
				StaffAttendanceModule.RemoveVisualFX(staff)
				StaffAttendancePage.BlackFrame.Visible = false
				StaffAttendancePage.OuterList.FocusedOn.Value = nil
			end)


			staff:WaitForChild("LogPage").Absent.MouseButton1Click:Connect(function()
				staff["LogPage"].Visible = false
				StaffAttendanceModule.RemoveVisualFX(staff)
				StaffAttendancePage.BlackFrame.Visible = false
				StaffAttendancePage.OuterList.FocusedOn.Value = nil
				ReplicatedStorage:WaitForChild("Arbor")["ArborEvents"].LogStaffAttendance:FireServer(staff.User.Value, "Absent")
				StaffAttendanceModule.UpdateStaffData(staff, staff.User.Value, "Absent")
				StaffAttendanceModule.ActiveLoading(staff)
			end)
		end
	end
end)

StaffAttendancePage.MarkAllAsPresent.MouseButton1Click:Connect(function()
	if Players.LocalPlayer:GetRankInGroup(Settings["GroupID"]) >= Settings["AdminID"] then
		StaffAttendancePage.MarkAllAsPresent.Popup.Visible = not StaffAttendancePage.MarkAllAsPresent.Popup.Visible
	else
		ArborInitializeModule.DisplayError("You do not have permission to do this")
	end
end)

StaffAttendancePage.MarkAllAsPresent.Popup.Yes.MouseButton1Click:Connect(function()
	StaffAttendancePage.MarkAllAsPresent.Popup.Visible = false
	StaffAttendanceModule.MarkAllPresent()
end)

StaffAttendancePage.MarkAllAsPresent.Popup.No.MouseButton1Click:Connect(function()
	StaffAttendancePage.MarkAllAsPresent.Popup.Visible = false
end)


StaffAttendancePage.MarkAllAsAbsent.MouseButton1Click:Connect(function()
	if Players.LocalPlayer:GetRankInGroup(Settings["GroupID"]) >= Settings["AdminID"] then
		StaffAttendancePage.MarkAllAsAbsent.Popup.Visible = not StaffAttendancePage.MarkAllAsAbsent.Popup.Visible
	else
		ArborInitializeModule.DisplayError("You do not have permission to do this")
	end
end)

StaffAttendancePage.MarkAllAsAbsent.Popup.Yes.MouseButton1Click:Connect(function()
	StaffAttendancePage.MarkAllAsAbsent.Popup.Visible = false
	StaffAttendanceModule.MarkAllAbsent()
end)

StaffAttendancePage.MarkAllAsAbsent.Popup.No.MouseButton1Click:Connect(function()
	StaffAttendancePage.MarkAllAsAbsent.Popup.Visible = false
end)

--[ Detentions Page ]

local DetentionsPage = System:WaitForChild("DetentionsPage")
local IssueDetentionPage = DetentionsPage:WaitForChild("IssueDetentionPage")
local DetentionWindow = IssueDetentionPage:WaitForChild("Window")
local DetentionButtons = {}

table.insert(DetentionButtons, System["Dropdowns"]["BehaviourDropdown"]["Detentions"])
table.insert(DetentionButtons, System["HomePage"]["QuickActions"]["Buttons"]["IssueDetention"])
table.insert(DetentionButtons, System["YearGroupPage"]["Pages"]["Behaviour"]["BehaviourOptions"]["Buttons"]["Detentions"])

for _, detentionButton in pairs(DetentionButtons) do
	detentionButton.MouseButton1Click:Connect(function()
		DetentionsPageModule.LoadDetentions()
		DetentionsPageModule.LoadCurrentDate()
	end)
end

DetentionsPage.IssueDetentionButton.MouseButton1Click:Connect(function()
	IssueDetentionPage.Visible = true
end)

IssueDetentionPage.Cancel.MouseButton1Click:Connect(function()
	IssueDetentionPage.Visible = false
end)

DetentionWindow.Type.Box.Default.MouseButton1Click:Connect(function()
	DetentionWindow.Type.Dropdown.Visible = not DetentionWindow.Type.Dropdown.Visible
end)

local Student

for _, item in pairs(DetentionWindow.Type.Dropdown:GetChildren()) do
	if item:IsA("TextButton") then
		item.MouseButton1Click:Connect(function()
			DetentionWindow.Type.Box.Default.Text = item.Title.Text
			DetentionWindow.Type.Dropdown.Visible = not DetentionWindow.Type.Dropdown.Visible
		end)
	end
end

DetentionWindow.StudentUsername.Box.Input.FocusLost:Connect(function()
	for _, Player in pairs(game:GetService("Players"):GetPlayers()) do
		if Player.Name == DetentionWindow.StudentUsername.Box.Input.Text then
			DetentionsPageModule.LoadStudentDetails(Player)
			Student = Player
		end
	end
end)

DetentionWindow["IssuedBy"].Box.Default.Text = ReplicatedStorage["Arbor"]["ArborData"].PlayerData[game.Players.LocalPlayer.Name].RoleplayName.Value

IssueDetentionPage.IssueDetentionConfirm.MouseButton1Click:Connect(function()
	if game.Players.LocalPlayer:GetRankInGroup(Settings["GroupID"]) >= Settings["StaffID"] then
		if Student:GetRankInGroup(Settings["GroupID"]) <= Settings["StudentID"] then
			local DetentionData = {
				["StudentUsername"] = DetentionWindow["StudentUsername"].Box.Input.Text,
				["ReasonForDetention"] = DetentionWindow["ReasonForDetention"].Box.Input.Text,
				["Note"] = DetentionWindow["Notes"].Box.Input.Text,
				["Location"] = DetentionWindow["Location"].Box.Input.Text,
				["IssuedBy"] = DetentionWindow["IssuedBy"].Box.Default.Text,
				["Type"] = DetentionWindow["Type"].Box.Default.Text
			}

			DetentionsPageModule.LogDetention(Student, game.Players.LocalPlayer, DetentionData)
			ArborInitializeModule.DisplayError("Detention has been successfully logged")

			local InnerList = DetentionsPage["List"]["List"]
			for _, Detention in pairs(InnerList:GetChildren()) do
				if Detention:IsA("Frame") then
					Detention:Destroy()
				end
			end

			local ExampleDetention = DetentionsPage:WaitForChild("ExampleDetention"):Clone()
			ExampleDetention.Parent = InnerList
			ExampleDetention.Visible = true
			ExampleDetention.Name = Student.Name
			ExampleDetention.Frame.Reason.Text = DetentionData["ReasonForDetention"]
			ExampleDetention.Frame.StudentName.Text = ReplicatedStorage["Arbor"]["ArborData"]["PlayerData"][Student.Name].RoleplayName.Value
			ExampleDetention.Frame.Type.Text = DetentionData["Type"].." in "..DetentionData["Location"]
			ExampleDetention.Frame.Username.Text = Student.Name
			ExampleDetention.Frame.YearGroup.Text = ReplicatedStorage["Arbor"]["ArborData"].PlayerData[Student.Name].OriginalYearGroup.Value

		else
			ArborInitializeModule.DisplayError("This user is not a student - try again")
		end
	else
		ArborInitializeModule.DisplayError("You do not have permission to do this")
	end

	IssueDetentionPage.Visible = false
	wait(1)
	DetentionsPageModule.LoadDetentions()
end)

ReplicatedStorage:WaitForChild("Arbor")["ArborEvents"].LogDetention.OnClientEvent:Connect(function(Staff, DetentionData)
	local Receiver = game.Players.LocalPlayer
	local DetentionPopup = ArborSystem:WaitForChild("DetentionPopup")
	local DetentionInfo = DetentionPopup:WaitForChild("DetentionInfo")

	DetentionPopup.ByUser.Text = "by "..DetentionData["IssuedBy"].." ("..Staff.Name..")"
	DetentionInfo["Location"]["Data"].Text = DetentionData["Location"]
	DetentionInfo["IssuedBy"]["Data"].Text = DetentionData["IssuedBy"]
	DetentionInfo["Type"]["Data"].Text = DetentionData["Type"]
	DetentionInfo["StudentUsername"]["Data"].Text = Receiver.Name
	DetentionInfo["StudentName"]["Data"].Text = ReplicatedStorage["Arbor"]["ArborData"].PlayerData[Receiver.Name].RoleplayName.Value
	DetentionInfo["Reason"]["Data"].Text = DetentionData["ReasonForDetention"]
	DetentionInfo["Note"]["Data"].Text = DetentionData["Note"]

	ArborSystem["DetentionPopup"].Visible = true
end)

ArborSystem["DetentionPopup"]["Close"].MouseButton1Click:Connect(function()
	ArborSystem["DetentionPopup"].Visible = false
end)

--[ Browse Staff Page ]

local function CheckLoadingPageStatus()
	if Settings["LoadingPage"] == true then
		return true
	else
		return false
	end
end

System.Dropdowns.StaffDropdown.BrowseStaff.MouseButton1Click:Connect(function()
	if CheckLoadingPageStatus() then
		LoadDataModule.ContentLoading("Content Loading")
		DisableAllPages()
		System:WaitForChild("BrowseStaffPage").Visible = true
		BrowseUserPage.InsertAllStaff()
		LoadDataModule.ContentLoading("Content Loading")
	else
		DisableAllPages()
		System:WaitForChild("BrowseStaffPage").Visible = true
		BrowseUserPage.InsertAllStaff()
	end
end)

--[ Create Event Page ]

local EventPage = System:WaitForChild("EventPage")
local SchoolNoticePage = EventPage["SchoolNoticePage"]

if Players.LocalPlayer:GetRankInGroup(Settings["GroupID"]) >= Settings["AdminID"] then
	EventPage.SchoolNoticePage.Visible = true
else
	EventPage.SchoolNoticePage.Visible = false
end

System.Dropdowns.StaffDropdown.Event.MouseButton1Click:Connect(function()
	DisableAllPages()
	System.HomePage.Visible = true
	System:WaitForChild("EventPage").Visible = true
end)

EventPage.CalendarEventPage.Cancel.MouseButton1Click:Connect(function()
	System.EventPage.Visible = false
	DisableAllPages()
	HomePage.Visible = true
end)

EventPage.CalendarEventPage.CreateEvent.MouseButton1Click:Connect(function()
	local EventData = {
		["EventName"] = EventPage.CalendarEventPage.EventName.Box.Default.Text,
		["Note"] = EventPage.CalendarEventPage.Note.Box.Default.Text,
		["Location"] = EventPage.CalendarEventPage.Location.Box.Default.Text,
		["Participants"] = EventPage.CalendarEventPage.Participants.Box.Default.Text,
		["StartTime"] = EventPage.CalendarEventPage.StartTime.Box.Time.Text,
		["EndTime"] = EventPage.CalendarEventPage.EndTime.Box.Time.Text
	}

	if string.len(EventData.StartTime) == 5 and string.find(EventData.StartTime, ":") and string.len(EventData.EndTime) == 5 and string.find(EventData.EndTime, ":") and (tonumber(string.sub(EventData["StartTime"], 1, 2))..tonumber(string.sub(EventData["StartTime"], 4, 6))) <=(tonumber(string.sub(EventData["EndTime"], 1, 2))..tonumber(string.sub(EventData["EndTime"], 4, 6)))  then
		ReplicatedStorage["Arbor"]["ArborEvents"]["CreateCalendarEvent"]:FireServer(EventData)
	else
		ArborInitializeModule.DisplayError("Invalid data provided with your request")
	end	
end)

function CreateStudentCalendarEvent(EventData, Option)
	if not System.StudentView["MyCalendar"].List:FindFirstChild(EventData["EventName"]) then
		local EventClone = System.StudentView["MyCalendar"].Event:Clone()
		EventClone.Name = EventData["EventName"]
		EventClone.Parent = System.StudentView["MyCalendar"].List
		EventClone.Visible = true
		EventClone.LeftSide.Details.Text = EventData["StartTime"].." - "..EventData["EndTime"]
		EventClone.RightSide.Title.Text = EventData["EventName"]
		EventClone.NoteBox.NoteDesc.Text = "Location: "..EventData["Location"].." - "..EventData["Note"]
		EventClone:SetAttribute("StartTime", EventData["StartTime"])
		EventClone:SetAttribute("EndTime", EventData["EndTime"])
		EventClone:SetAttribute("StartTimeShort", (string.sub(EventData["StartTime"], 1, 2)..string.sub(EventData["StartTime"], 4, 6)))

		if Option == "StudentView" then
			EventClone.RightSide.Title.Text = EventData["EventName"].." - "..EventData["Location"]
		end
	end
end

if Players.LocalPlayer:GetRankInGroup(Settings["GroupID"]) <= Settings["StudentID"] then
	System.TopBar.LowerBar.List.School.Visible = false
	System.TopBar.LowerBar.List.Students.Visible = false
	System.TopBar.LowerBar.List.System.Visible = false

	for i, Period in pairs(Settings["Periods"]) do
		if table.find(Settings["Teams"], game.Players.LocalPlayer.Team.Name) then
			local EventData = {
				["EventName"] = Period["Name"],
				["Note"] = "Lesson scheduled for: "..ReplicatedStorage["Arbor"]["ArborData"].PlayerData[Players.LocalPlayer.Name].OriginalYearGroup.Value.."/"..Period["Name"].." at "..Period["Time"],
				["Location"] = ReplicatedStorage["Arbor"]["ArborData"]["Lessons"][Period["Name"]][ReplicatedStorage["Arbor"]["ArborData"].PlayerData[Players.LocalPlayer.Name].OriginalYearGroup.Value].Room.Value,
				["Participants"] = ReplicatedStorage["Arbor"]["ArborData"].PlayerData[Players.LocalPlayer.Name].OriginalYearGroup.Value,
				["StartTime"] = Period["Time"],
				["EndTime"] = nil
			}

			if i == #Settings["Periods"] then
				EventData["EndTime"] = Settings["ClosureTime"]
			else
				EventData["EndTime"] = Settings["Periods"][i+1]["Time"]
			end

			CreateStudentCalendarEvent(EventData, "StudentView")
		end
	end
end

ReplicatedStorage["Arbor"]["ArborEvents"]["CreateCalendarEvent"].OnClientEvent:Connect(function(Player, EventData)
	if EventData["Participants"] == "Staff" then
		if game.Players.LocalPlayer:GetRankInGroup(Settings["GroupID"]) >= Settings["StaffID"] then
			local EventClone = HomePage["MyCalendar"].Event:Clone()
			EventClone.Parent = HomePage["MyCalendar"].List
			EventClone.Visible = true
			EventClone.LeftSide.Details.Text = EventData["StartTime"].." - "..EventData["EndTime"]
			EventClone.RightSide.Title.Text = EventData["EventName"]
			EventClone.NoteBox.NoteDesc.Text = "Location: "..EventData["Location"].." - "..EventData["Note"]
			EventClone:SetAttribute("StartTime", EventData["StartTime"])
			EventClone:SetAttribute("EndTime", EventData["EndTime"])
			EventClone:SetAttribute("StartTimeShort", (string.sub(EventData["StartTime"], 1, 2)..string.sub(EventData["StartTime"], 4, 6)))
		end
	elseif EventData["Participants"] == "All Students" then
		if game.Players.LocalPlayer:GetRankInGroup(Settings["GroupID"]) <= Settings["StudentID"] then
			CreateStudentCalendarEvent(EventData)
		end
	elseif game:GetService("Teams"):FindFirstChild(EventData["Participants"]) and table.find(Settings["Teams"], EventData["Participants"]) then
		local SelectedTeam = EventData["Participants"]

		if ReplicatedStorage.Arbor.ArborData.PlayerData[game.Players.LocalPlayer.Name].OriginalYearGroup.Value == SelectedTeam then
			CreateStudentCalendarEvent(EventData)
		end
	end
end)

local function updateIndex_1(item)
	item.NoteBox.Visible = true
	item.ZIndex = 5
	item.LeftSide.ZIndex = 6
	item.LeftSide.ColorFrame.ZIndex = 6
	item.LeftSide.Details.ZIndex = 7
	item.NoteBox.ZIndex = 6
	item.NoteBox.NoteDesc.ZIndex = 6
	item.RightSide.ZIndex = 5
	item.RightSide.Title.ZIndex = 6
end

local function updateIndex_2(item)
	item.NoteBox.Visible = false
	item.ZIndex = 3
	item.LeftSide.ZIndex = 4
	item.LeftSide.ColorFrame.ZIndex = 4
	item.LeftSide.Details.ZIndex = 5
	item.NoteBox.ZIndex = 4
	item.NoteBox.NoteDesc.ZIndex = 4
	item.RightSide.ZIndex = 3
	item.RightSide.Title.ZIndex = 4
end

HomePage["MyCalendar"].List.ChildAdded:Connect(function(item)
	if item:IsA("Frame") then
		item.RightSide.MouseEnter:Connect(function()
			updateIndex_1(item)
		end)

		item.RightSide.MouseLeave:Connect(function()
			updateIndex_2(item)
		end)
	end
end)

System.StudentView["MyCalendar"].List.ChildAdded:Connect(function(item)
	if item:IsA("Frame") then
		item.RightSide.MouseEnter:Connect(function()
			updateIndex_1(item)
		end)

		item.RightSide.MouseLeave:Connect(function()
			updateIndex_2(item)
		end)
	end
end)


for _, taskItem in pairs(EventPage["ToDoList"]["List"]:GetChildren()) do
	if taskItem:IsA("Frame") then
		taskItem.Clear.MouseButton1Click:Connect(function()
			taskItem.TaskDesc.Text = ""
			taskItem.TaskName.Text = ""
		end)
	end
end

for _, toDoItem in pairs(HomePage.ToDo.Container.List:GetChildren()) do
	if toDoItem:IsA("TextButton") then
		toDoItem.MouseEnter:Connect(function()
			TweenService:Create(toDoItem.Done, TweenInfo.new(.5), {Position = UDim2.new(0.856, 0, -0.02, 0)}):Play()
		end)

		toDoItem.MouseLeave:Connect(function()
			TweenService:Create(toDoItem.Done, TweenInfo.new(.25), {Position = UDim2.new(1, 0, -0.02, 0)}):Play()
		end)

		toDoItem.Done.MouseButton1Click:Connect(function()
			toDoItem.Visible = false
			toDoItem.Title.Text = ""
			toDoItem.Description.Text = ""

			if HomePage.ToDo.Container.List["1"].Visible == false and HomePage.ToDo.Container.List["2"].Visible == false and HomePage.ToDo.Container.List["3"].Visible == false then
				HomePage.ToDo.Container.ToDoCompleted.Visible = true
			end
		end)
	end
end

EventPage.ToDoList.SetTasks.MouseButton1Click:Connect(function()
	if HomePage.ToDo.Container.List["1"].Visible == false and HomePage.ToDo.Container.List["2"].Visible == false and HomePage.ToDo.Container.List["3"].Visible == false then
		HomePage.ToDo.Container.ToDoCompleted.Visible = true
	end


	for _, chooseTask in pairs(EventPage.ToDoList.List:GetChildren()) do
		if chooseTask:IsA("Frame") then
			if chooseTask.TaskName.Text == "" or chooseTask.TaskDesc.Text == "" then
				local newListItem = HomePage.ToDo.Container.List[chooseTask.Name]
				newListItem.Visible = false
				newListItem.Title.Text = ""
				newListItem.Description.Text = ""
				HomePage.ToDo.Container.ToDoCompleted.Visible = false
			else
				local newListItem = HomePage.ToDo.Container.List[chooseTask.Name]
				newListItem.Visible = true
				newListItem.Title.Text = chooseTask.TaskName.Text
				newListItem.Description.Text = chooseTask.TaskDesc.Text

				if HomePage.ToDo.Container.List["1"].Visible == false and HomePage.ToDo.Container.List["2"].Visible == false and HomePage.ToDo.Container.List["3"].Visible == false then
					HomePage.ToDo.Container.ToDoCompleted.Visible = true
				end
			end
		end
	end

end)

--[ Alerts ]

local ArborAlerts = HomePage:WaitForChild("ArborAlerts")
local AlertsContainer = ArborAlerts["Container"]
local AlertDescBox = ArborAlerts["DescBox"]

local StudentArborAlerts = System["StudentView"]:WaitForChild("ArborAlerts")
local StudentAlertsContainer = StudentArborAlerts["Container"]
local StudentAlertDescBox = StudentArborAlerts["DescBox"]

local function CreateAlert(ContainerType, Alert, i)
	local ExampleAlert = ContainerType["Example"]:Clone()
	ExampleAlert.Parent = ContainerType["List"]
	ExampleAlert.Visible = true
	ExampleAlert.Name = i
	ExampleAlert.Title.Text = Alert["Title"]
	ExampleAlert.Desc.Text = string.sub(Alert["Description"], 1, 30)..".."
	ExampleAlert:SetAttribute("Description", Alert["Description"])
end

local Alerts = ReplicatedStorage["Arbor"].ArborEvents["GetAlerts"]:InvokeServer()

for i, alert in pairs(Alerts) do
	if alert["VisibleTo"] == "All" then
		CreateAlert(AlertsContainer, alert, i)
		CreateAlert(StudentAlertsContainer, alert, i)
	elseif alert["VisibleTo"] == "Staff" then
		CreateAlert(AlertsContainer, alert, i)
	elseif alert["VisibleTo"] == "Students" then
		CreateAlert(StudentAlertsContainer, alert, i)
	end
end

if Alerts == {} then
	AlertsContainer["AlertsCompleted"].Visible = true
	StudentAlertsContainer["AlertsCompleted"].Visible = true
end

for i, alert in pairs(AlertsContainer["List"]:GetChildren()) do
	if alert:IsA("TextButton") then
		ArborAlerts["Title"].Text = "<b>Alerts</b> ("..tostring(i-1)..")"
		AlertsContainer["AlertsCompleted"].Visible = false

		alert.MouseButton1Click:Connect(function()
			AlertDescBox.Visible = true
			AlertsContainer.Visible = false
			AlertDescBox.Title.Text = alert.Title.Text
			AlertDescBox.Desc.Text = alert:GetAttribute("Description")
		end)
	end
end

for i, alert in pairs(StudentAlertsContainer["List"]:GetChildren()) do
	if alert:IsA("TextButton") then
		StudentArborAlerts["Title"].Text = "<b>Alerts</b> ("..tostring(i-1)..")"
		StudentAlertsContainer["AlertsCompleted"].Visible = false

		alert.MouseButton1Click:Connect(function()
			StudentAlertDescBox.Visible = true
			StudentAlertsContainer.Visible = false
			StudentAlertDescBox.Title.Text = alert.Title.Text
			StudentAlertDescBox.Desc.Text = alert:GetAttribute("Description")
		end)
	end
end

AlertDescBox.Close.MouseButton1Click:Connect(function()
	AlertDescBox.Visible = false
	AlertsContainer.Visible = true
end)

StudentAlertDescBox.Close.MouseButton1Click:Connect(function()
	StudentAlertDescBox.Visible = false
	StudentAlertsContainer.Visible = true
end)

--[ School Notices ]

local StudentSchoolNotices = System.StudentView.SchoolNotices
local HomePageNotices = System.HomePage.SchoolNotices

StudentSchoolNotices.Container.List.ChildAdded:Connect(function(Object)
	if Object:IsA("TextButton") then
		Object.MouseButton1Click:Connect(function()
			StudentSchoolNotices.DescBox.Visible = true
			StudentSchoolNotices.Container.Visible = false
			StudentSchoolNotices.DescBox.Title.Text = Object.Title.Text
			StudentSchoolNotices.DescBox.Date.Text = "Ends at: "..Object.EndsAt.Value
			StudentSchoolNotices.DescBox.Desc.Text = Object.Description.Value
		end)
	end
end)

StudentSchoolNotices.DescBox.Close.MouseButton1Click:Connect(function()
	StudentSchoolNotices.DescBox.Visible = false
	StudentSchoolNotices.Container.Visible = true
end)

HomePageNotices.Container.List.ChildAdded:Connect(function(Object)
	if Object:IsA("TextButton") then
		Object.MouseButton1Click:Connect(function()
			HomePageNotices.DescBox.Visible = true
			HomePageNotices.Container.Visible = false
			HomePageNotices.DescBox.Title.Text = Object.Title.Text
			HomePageNotices.DescBox.Date.Text = "Ends at: "..Object.EndsAt.Value
			HomePageNotices.DescBox.Desc.Text = Object.Description.Value
		end)
	end
end)

HomePageNotices.DescBox.Close.MouseButton1Click:Connect(function()
	HomePageNotices.DescBox.Visible = false
	HomePageNotices.Container.Visible = true
end)

local CreateNoticeDebounce = false

SchoolNoticePage.CreateNotice.MouseButton1Click:Connect(function()
	local EventData = {
		["NoticeTitle"] = SchoolNoticePage.Title.Box.Default.Text,
		["Note"] = SchoolNoticePage.Note.Box.Default.Text,
		["Group"] = SchoolNoticePage.GroupSelection.Box.Default.Text,
		["StartFromDate"] = SchoolNoticePage.Start.Box.Date.Text,
		["EndAtDate"] = SchoolNoticePage.End.Box.Date.Text
	}

	local SplitStartDate = EventData["StartFromDate"]:split(" ")
	local SplitEndDate = EventData["EndAtDate"]:split(" ")

	if not CreateNoticeDebounce then
		if SplitStartDate[1] == DateService:FormatLocalTime("D", "en-us") then
			if SplitStartDate[2] == DateService:FormatLocalTime("MMM", "en-us") then
				if SplitEndDate[1] > DateService:FormatLocalTime("D", "en-us") then
					if SplitEndDate[2] == DateService:FormatLocalTime("MMM", "en-us") then
						CreateNoticeDebounce = true
						ReplicatedStorage["Arbor"]["ArborEvents"]["CreateSchoolNotice"]:FireServer(EventData)
						task.wait(3)
						CreateNoticeDebounce = false
					else
						ArborInitializeModule.DisplayError("End month must be the same as current month")
					end
				else
					ArborInitializeModule.DisplayError("End day must be after the current day")
				end
			else
				ArborInitializeModule.DisplayError("Start month must be the same as current month")
			end
		else
			ArborInitializeModule.DisplayError("Start day must be the same as the current day")
		end
	else
		ArborInitializeModule.DisplayError("You are creating notices too fast")
	end
end)

local function CreateNotice(EventData, NoticesPage, Interface)
	local ExampleNotice = Interface.Container.Example:Clone()
	ExampleNotice.Parent = Interface.Container.List
	ExampleNotice.Visible = true
	ExampleNotice.Name = EventData["RandomString"]
	ExampleNotice.EndsAt.Value = EventData["EndAtDate"]
	ExampleNotice.Description.Value = EventData["Note"]
	ExampleNotice.Date.Text = "Published on: "..EventData["StartFromDate"]
	ExampleNotice.Title.Text = EventData["NoticeTitle"]

	if #Interface.Container.List:GetChildren() == 1 then
		Interface.Container.Desc.Visible = true
		Interface.Container.Title.Visible = true
	else
		Interface.Container.Desc.Visible = false
		Interface.Container.Title.Visible = false

		for _, item in pairs(Interface.Container.List:GetChildren()) do
			if item:IsA("TextButton") then
				item.Visible = true
			end
		end
	end

	Interface.Title.Text = "<b>School Notices</b> ("..tostring(#Interface.Container.List:GetChildren() - 1)..")"
end

local function RemoveNotice(EventData, NoticesPage, Interface)
	local ExampleNotice = Interface.Container.List:FindFirstChild(EventData["RandomString"])
	ExampleNotice:Destroy()

	if #Interface.Container.List:GetChildren() == 1 then
		Interface.Container.Desc.Visible = true
		Interface.Container.Title.Visible = true
	else
		Interface.Container.Desc.Visible = false
		Interface.Container.Title.Visible = false
	end

	Interface.Title.Text = "<b>School Notices</b> ("..tostring(#Interface.Container.List:GetChildren() - 1)..")"
end

ReplicatedStorage["Arbor"].ArborEvents.CreateSchoolNotice.OnClientEvent:Connect(function(EventData)
	if Players.LocalPlayer:IsInGroup(Settings["GroupID"]) then
		if EventData["Group"] == "Staff" then
			if Players.LocalPlayer:GetRankInGroup(Settings["GroupID"]) >= Settings["StaffID"] then
				CreateNotice(EventData, HomePageNotices, System.HomePage.SchoolNotices)
			end
		elseif EventData["Group"] == "All Students" then
			if Players.LocalPlayer:GetRankInGroup(Settings["GroupID"]) <= Settings["StudentID"] then
				CreateNotice(EventData, StudentSchoolNotices, System.StudentView.SchoolNotices)
			end
		elseif game:GetService("Teams"):FindFirstChild(EventData["Group"]) and table.find(Settings["Teams"], EventData["Group"]) then
			if ReplicatedStorage["Arbor"]["ArborData"].PlayerData[Players.LocalPlayer.Name].OriginalYearGroup.Value == EventData["Group"] then
				CreateNotice(EventData, StudentSchoolNotices, System.StudentView.SchoolNotices)
			end
		end
	end
end)

ReplicatedStorage["Arbor"].ArborEvents.RemoveSchoolNotice.OnClientEvent:Connect(function(EventData)
	if Players.LocalPlayer:IsInGroup(Settings["GroupID"]) then
		if EventData["Group"] == "Staff" then
			if Players.LocalPlayer:GetRankInGroup(Settings["GroupID"]) >= Settings["StaffID"] then
				RemoveNotice(EventData, HomePageNotices, System.HomePage.SchoolNotices)
			end
		elseif EventData["Group"] == "All Students" then
			if Players.LocalPlayer:GetRankInGroup(Settings["GroupID"]) <= Settings["StudentID"] then
				RemoveNotice(EventData, StudentSchoolNotices, System.StudentView.SchoolNotices)
			end
		elseif game:GetService("Teams"):FindFirstChild(EventData["Group"]) and table.find(Settings["Teams"], EventData["Group"]) then
			if ReplicatedStorage["Arbor"]["ArborData"].PlayerData[Players.LocalPlayer.Name].OriginalYearGroup.Value == EventData["Group"] then
				RemoveNotice(EventData, StudentSchoolNotices, System.StudentView.SchoolNotices)
			end
		end
	end
end)

for i, Team in pairs(Settings["Teams"]) do
	if game:GetService("Teams"):FindFirstChild(Team) then
		local Group = EventPage["SchoolNoticePage"].Group:Clone()
		Group.Name = Team
		Group.Parent = EventPage["SchoolNoticePage"].GroupSelection.Dropdown
		Group.Title.Text = Team
		Group.Visible = true
		Group.LayoutOrder = i + 2

		if i == #Settings["Teams"] then
			local UICorner = Instance.new("UICorner", Group)
			UICorner.CornerRadius = UDim.new(0, 5)
		end
	end
end

for _, DropdownItem in pairs(EventPage["SchoolNoticePage"].GroupSelection.Dropdown:GetChildren()) do
	if DropdownItem:IsA("TextButton") then
		DropdownItem.MouseButton1Click:Connect(function()
			EventPage["SchoolNoticePage"].GroupSelection.Dropdown.Visible = false
			EventPage["SchoolNoticePage"].GroupSelection.Box.Default.Text = DropdownItem.Title.Text
		end)
	end
end

EventPage["SchoolNoticePage"].GroupSelection.Box.MouseButton1Click:Connect(function()
	EventPage["SchoolNoticePage"].GroupSelection.Dropdown.Visible = not EventPage["SchoolNoticePage"].GroupSelection.Dropdown.Visible
end)

EventPage["SchoolNoticePage"].Start.Box.Icon.MouseButton1Click:Connect(function()
	EventPage["SchoolNoticePage"].Start.Box.Date.Text = DateService:FormatLocalTime("D", "en-us").." "..DateService:FormatLocalTime("MMM", "en-us")
end)

EventPage["SchoolNoticePage"].End.Box.Icon.MouseButton1Click:Connect(function()
	EventPage["SchoolNoticePage"].End.Box.Date.Text = DateService:FormatLocalTime("D", "en-us").." "..DateService:FormatLocalTime("MMM", "en-us")
end)

--[]

for i, team in pairs(Settings["Teams"]) do
	if game:GetService("Teams"):FindFirstChild(team) then
		local Participant = EventPage["CalendarEventPage"].Particpant:Clone()
		Participant.Name = team
		Participant.Parent = EventPage["CalendarEventPage"].Participants.Dropdown
		Participant.Title.Text = team
		Participant.Visible = true
		Participant.LayoutOrder = i + 2

		if i == #Settings["Teams"] then
			local UICorner = Instance.new("UICorner", Participant)
			UICorner.CornerRadius = UDim.new(0, 5)
		end
	end
end

for _, dropdownItem in pairs(EventPage["CalendarEventPage"].Participants.Dropdown:GetChildren()) do
	if dropdownItem:IsA("TextButton") then
		dropdownItem.MouseButton1Click:Connect(function()
			EventPage["CalendarEventPage"].Participants.Dropdown.Visible = false
			EventPage["CalendarEventPage"].Participants.Box.Default.Text = dropdownItem.Title.Text
		end)
	end
end

EventPage["CalendarEventPage"].Participants.Box.MouseButton1Click:Connect(function()
	EventPage["CalendarEventPage"].Participants.Dropdown.Visible = not EventPage["CalendarEventPage"].Participants.Dropdown.Visible
end)

EventPage["CalendarEventPage"].StartTime.Box.Icon.MouseButton1Click:Connect(function()
	EventPage["CalendarEventPage"].StartTime.Box.Time.Text = ReplicatedStorage.Arbor.ArborData.CurrentTime.Value
end)

EventPage["CalendarEventPage"].EndTime.Box.Icon.MouseButton1Click:Connect(function()
	EventPage["CalendarEventPage"].EndTime.Box.Time.Text = ReplicatedStorage.Arbor.ArborData.CurrentTime.Value
end)

--[ Browse Students Page ]

System.Dropdowns.StudentsDropdown.BrowseStudents.MouseButton1Click:Connect(function()
	if CheckLoadingPageStatus() then
		LoadDataModule.ContentLoading("Content Loading")
		DisableAllPages()
		System.HomePage.Visible = false
		System:WaitForChild("BrowseStudentsPage").Visible = true
		BrowseUserPage.InsertAllStudents()
		LoadDataModule.ContentLoading("Content Loading")
	else
		DisableAllPages()
		System.HomePage.Visible = false
		System:WaitForChild("BrowseStudentsPage").Visible = true
		BrowseUserPage.InsertAllStudents()
	end
end)

System.HomePage.QuickActions.Buttons.BrowseStudents.MouseButton1Click:Connect(function()
	if CheckLoadingPageStatus() then
		LoadDataModule.ContentLoading("Content Loading")
		DisableAllPages()
		System.HomePage.Visible = false
		System:WaitForChild("BrowseStudentsPage").Visible = true
		BrowseUserPage.InsertAllStudents()
		LoadDataModule.ContentLoading("Content Loading")
	else
		DisableAllPages()
		System.HomePage.Visible = false
		System:WaitForChild("BrowseStudentsPage").Visible = true
		BrowseUserPage.InsertAllStudents()
	end
end)

System.BrowseStudentsPage.SearchTable.Input:GetPropertyChangedSignal("Text"):Connect(function()
	for _, item in pairs(System.BrowseStudentsPage.OuterList.List:GetChildren()) do
		if item:IsA("Frame") then
			item.Visible = string.find(string.lower(item.Name), string.lower(System.BrowseStudentsPage.SearchTable.Input.Text)) and true or false
		end
	end
end)


--[ Users & Security Page ]

System.Dropdowns.SchoolDropdown.UsersAndSecurity.MouseButton1Click:Connect(function()
	if CheckLoadingPageStatus() then
		LoadDataModule.ContentLoading("Loading Users")
		System:WaitForChild("UsersAndSecurityPage").Visible = true
		BrowseUserPage.InsertAllUsers()
		System.UsersAndSecurityPage.UserDetailsPage.BlackFrame.Visible = false
		LoadDataModule.ContentLoading("Loading Users")
	else
		System:WaitForChild("UsersAndSecurityPage").Visible = true
		BrowseUserPage.InsertAllUsers()
		System.UsersAndSecurityPage.UserDetailsPage.BlackFrame.Visible = false
	end
end)

System:WaitForChild("UsersAndSecurityPage").List.List.ChildAdded:Connect(function()
	for _, user in pairs(System:WaitForChild("UsersAndSecurityPage").List.List:GetChildren()) do
		if user:IsA("Frame") then
			user.Expand.MouseButton1Click:Connect(function()
				System:FindFirstChild("UsersAndSecurityPage")["UserDetailsPage"].Visible = true
				BrowseUserPage.LoadUserDetails(System.UsersAndSecurityPage.UserDetailsPage.Container.UserInformation, user.User.Value)
				System.UsersAndSecurityPage.UserDetailsPage.User.Value = user.User.Value

				if ReplicatedStorage["Arbor"]["ArborData"]["PlayerData"][System.UsersAndSecurityPage.UserDetailsPage.User.Value.Name].AccountEnabled.Value == false then
					System.UsersAndSecurityPage.UserDetailsPage.Container.EnableAccount.Visible = true
					System.UsersAndSecurityPage.UserDetailsPage.Container.DisableAccount.Visible = false
				else
					System.UsersAndSecurityPage.UserDetailsPage.Container.EnableAccount.Visible = false
					System.UsersAndSecurityPage.UserDetailsPage.Container.DisableAccount.Visible = true
				end
			end)
		end
	end
end)

System.UsersAndSecurityPage.UserDetailsPage.Container.KickUser.MouseButton1Click:Connect(function()
	if Players.LocalPlayer:GetRankInGroup(Settings["GroupID"]) >= Settings["AdminID"] then
		ArborInitializeModule.DisplayError(System.UsersAndSecurityPage.UserDetailsPage.User.Value.Name.." has been kicked")
		System.UsersAndSecurityPage.UserDetailsPage.Visible = false
		System.UsersAndSecurityPage.List.List[System.UsersAndSecurityPage.UserDetailsPage.User.Value.Name]:Destroy()

		ReplicatedStorage:WaitForChild("Arbor")["ArborEvents"].KickUser:FireServer(Players[System.UsersAndSecurityPage.UserDetailsPage.User.Value.Name])
	else
		ArborInitializeModule.DisplayError("You do not have permission to do this")
	end
end)

System.UsersAndSecurityPage.UserDetailsPage.Container.Back.MouseButton1Click:Connect(function()
	System.UsersAndSecurityPage.UserDetailsPage.Visible = false
	System.UsersAndSecurityPage.UserDetailsPage.BlackFrame.Visible = false
end)

System.UsersAndSecurityPage.UserDetailsPage.Container.DisableAccount.MouseButton1Click:Connect(function()
	if Players.LocalPlayer:GetRankInGroup(Settings["GroupID"]) >= Settings["AdminID"] then
		System.UsersAndSecurityPage.UserDetailsPage.BlackFrame.Visible = true
		System.UsersAndSecurityPage.UserDetailsPage.DisableAccountPrompt.Visible = true
		System.UsersAndSecurityPage.UserDetailsPage.DisableAccountPrompt.UserDetails.Text = System.UsersAndSecurityPage.UserDetailsPage.User.Value.Name.." ("..ReplicatedStorage:WaitForChild("Arbor")["ArborData"]["PlayerData"][System.UsersAndSecurityPage.UserDetailsPage.User.Value.Name].RoleplayName.Value..")"
	else
		ArborInitializeModule.DisplayError("You do not have permission to do this")
	end
end)

ReplicatedStorage["Arbor"].ArborEvents.DisableAccount.OnClientEvent:Connect(function(Admin)
	if Admin:GetRankInGroup(Settings["GroupID"]) >= Settings["AdminID"] then
		ArborButton.Visible = false
		System.Visible = false
		DisableAllPages()
	end
end)

ReplicatedStorage["Arbor"].ArborEvents.EnableAccount.OnClientEvent:Connect(function(Admin)
	if Admin:GetRankInGroup(Settings["GroupID"]) >= Settings["AdminID"] then
		ArborButton.Visible = true
		DisableAllPages()
	end
end)

System.UsersAndSecurityPage.UserDetailsPage.DisableAccountPrompt.Cancel.MouseButton1Click:Connect(function()
	System.UsersAndSecurityPage.UserDetailsPage.BlackFrame.Visible = false
	System.UsersAndSecurityPage.UserDetailsPage.DisableAccountPrompt.Visible = false
end)

System.UsersAndSecurityPage.UserDetailsPage.DisableAccountPrompt.DisableAccount.MouseButton1Click:Connect(function()
	if Players.LocalPlayer:GetRankInGroup(Settings["GroupID"]) >= Settings["AdminID"] then
		ArborInitializeModule.DisplayError(System.UsersAndSecurityPage.UserDetailsPage.User.Value.Name.." has been restricted")

		System.UsersAndSecurityPage.UserDetailsPage.DisableAccountPrompt.Visible = false
		System.UsersAndSecurityPage.UserDetailsPage.Visible = false

		ReplicatedStorage:WaitForChild("Arbor")["ArborEvents"].DisableAccount:FireServer(Players[System.UsersAndSecurityPage.UserDetailsPage.User.Value.Name])
	else
		ArborInitializeModule.DisplayError("You do not have permission to do this")
	end
end)

System.UsersAndSecurityPage.UserDetailsPage.Container.EnableAccount.MouseButton1Click:Connect(function()
	if Players.LocalPlayer:GetRankInGroup(Settings["GroupID"]) >= Settings["AdminID"] then
		ArborInitializeModule.DisplayError("Account for: "..System.UsersAndSecurityPage.UserDetailsPage.User.Value.Name.." has been enabled")
		BrowseUserPage.InsertAllUsers()

		System.UsersAndSecurityPage.UserDetailsPage.Visible = false

		ReplicatedStorage:WaitForChild("Arbor")["ArborEvents"].EnableAccount:FireServer(System.UsersAndSecurityPage.UserDetailsPage.User.Value)
	else
		ArborInitializeModule.DisplayError("You do not have permission to do this")
	end
end)

--

System.UsersAndSecurityPage.UserDetailsPage.Container.ChangeName.MouseButton1Click:Connect(function()
	if Players.LocalPlayer:GetRankInGroup(Settings["GroupID"]) >= Settings["StaffID"] then
		System.UsersAndSecurityPage.UserDetailsPage.BlackFrame.Visible = true
		System.UsersAndSecurityPage.UserDetailsPage.ChangeNamePrompt.Visible = true
	else
		ArborInitializeModule.DisplayError("You do not have permission to do this")
	end
end)

System.UsersAndSecurityPage.UserDetailsPage.ChangeNamePrompt.Cancel.MouseButton1Click:Connect(function()
	System.UsersAndSecurityPage.UserDetailsPage.ChangeNamePrompt.Visible = false
	System.UsersAndSecurityPage.UserDetailsPage.BlackFrame.Visible = false
end)

System.UsersAndSecurityPage.UserDetailsPage.ChangeNamePrompt.Submit.MouseButton1Click:Connect(function()
	if Players.LocalPlayer:GetRankInGroup(Settings["GroupID"]) >= Settings["StaffID"] then
		ArborInitializeModule.DisplayError(System.UsersAndSecurityPage.UserDetailsPage.User.Value.Name.."'s name' has been changed")

		System.UsersAndSecurityPage.UserDetailsPage.ChangeNamePrompt.Visible = false
		System.UsersAndSecurityPage.UserDetailsPage.BlackFrame.Visible = false
		System.UsersAndSecurityPage.UserDetailsPage.Visible = false

		ReplicatedStorage:WaitForChild("Arbor")["ArborEvents"].ChangeName:FireServer(System.UsersAndSecurityPage.UserDetailsPage.User.Value, System.UsersAndSecurityPage.UserDetailsPage.ChangeNamePrompt.Details.InfoBox.Title.Text)
	else
		ArborInitializeModule.DisplayError("You do not have permission to do this")
	end
end)

local SearchTable = System.UsersAndSecurityPage.SearchTable.Input

SearchTable:GetPropertyChangedSignal("Text"):Connect(function()
	for _, item in pairs(System.UsersAndSecurityPage.List.List:GetChildren()) do
		if item:IsA("Frame") then
			item.Visible = string.find(string.lower(item.Name), string.lower(SearchTable.Text)) and true or false
			item.Visible = string.find(string.lower(item.RoleplayName.Text), string.lower(SearchTable.Text)) and true or false
		end
	end
end)

--[ School Details Page ]

System.Dropdowns.SchoolDropdown.SchoolDetails.MouseButton1Click:Connect(function()
	SchoolDetailsPage.LoadSchoolDetails()
	System:WaitForChild("SchoolDetailsPage").Visible = true
end)


local ArborSettingsPage = System:WaitForChild("ArborSettingsPage")
local SettingsList = ArborSettingsPage:WaitForChild("SettingsContainer").List

ArborSettingsPage.UserInfo.RoleplayName.Text = ReplicatedStorage["Arbor"].ArborData.PlayerData[Players.LocalPlayer.Name].RoleplayName.Value
ArborSettingsPage.UserInfo.Rank.Text = Players.LocalPlayer:GetRoleInGroup(Settings["GroupID"])
ArborSettingsPage.UserInfo.Icon.Image = ReplicatedStorage["Arbor"].ArborData.PlayerData[Players.LocalPlayer.Name]:GetAttribute("Icon") or ""

for _, option in pairs(SettingsList:GetChildren()) do
	--[ Arbor Settings Page ]
	if option:IsA("TextButton") and ArborSettingsPage[option.Name.."Page"] then
		option.MouseButton1Click:Connect(function()
			for _, page in pairs(ArborSettingsPage:GetChildren()) do
				if string.find(page.Name, "Page") then
					page.Visible = false
				end
			end

			ArborSettingsPage[option.Name.."Page"].Visible = true

			for _, otherOptions in pairs(SettingsList:GetChildren()) do
				if otherOptions:IsA("TextButton") then
					otherOptions.BackgroundTransparency = 1
					otherOptions.Title.FontFace.Weight = Enum.FontWeight.Medium
				end
			end

			option.BackgroundTransparency = 0
			option.Title.FontFace.Weight = Enum.FontWeight.SemiBold
		end)
	end
end

System.SchoolDetailsPage["ChangeSettings"].MouseButton1Click:Connect(function()
	DisableAllPages()
	ArborSettingsPage.Visible = true
end)

--

local SessionDataPage = ArborSettingsPage["SessionDataPage"]
local ArborData = ReplicatedStorage["Arbor"]:WaitForChild("ArborData")

SessionDataPage.StatusData.Text = ArborData.SessionStatus.Value
SessionDataPage.PeriodData.Text = ArborData.CurrentPeriod.Value
SessionDataPage.TimeData.Text = ArborData.CurrentTime.Value
SessionDataPage.DateData.Text = ArborData.CurrentShortDate.Value

ArborData.SessionStatus:GetPropertyChangedSignal("Value"):Connect(function()
	SessionDataPage.StatusData.Text = ArborData.SessionStatus.Value
end)

ArborData.CurrentPeriod:GetPropertyChangedSignal("Value"):Connect(function()
	SessionDataPage.PeriodData.Text = ArborData.CurrentPeriod.Value
end)

ArborData.CurrentTime:GetPropertyChangedSignal("Value"):Connect(function()
	SessionDataPage.TimeData.Text = ArborData.CurrentTime.Value
end)

ArborData.CurrentShortDate:GetPropertyChangedSignal("Value"):Connect(function()
	SessionDataPage.DateData.Text = ArborData.CurrentShortDate.Value
end)

--

local SchoolActivitiesPage = ArborSettingsPage["SchoolActivitiesPage"]
local TripsContainer = SchoolActivitiesPage["Container"]

SettingsList.SchoolActivities.MouseButton1Click:Connect(function()
	for i, year in pairs(Settings["Teams"]) do
		if not TripsContainer:FindFirstChild(year) then
			local YearClone = SchoolActivitiesPage["Example"]:Clone()
			YearClone.Name =  year
			YearClone.Parent = TripsContainer
			YearClone.Visible = true
			YearClone.YearGroup.Text = year	
		end
	end
end)

--

local GeneralSettingsPage = ArborSettingsPage["GeneralSettingsPage"]
local Nametags = GeneralSettingsPage:WaitForChild("Nametags")
local CurrentState = true

local function ToggleNametags()
	if CurrentState == true then
		CurrentState = false
		if CheckLoadingPageStatus() then
			LoadDataModule.ContentLoading("Updating Nametags")
			for _, User in pairs(Players:GetPlayers()) do
				if User.Character then
					if User.Character.Head:FindFirstChild("ArborNameTag") then
						User.Character.Head:FindFirstChild("ArborNameTag").Enabled = true
					end
				end
			end
			LoadDataModule.ContentLoading("Updating Nametags")
		else
			for _, User in pairs(Players:GetPlayers()) do
				if User.Character then
					if User.Character.Head:FindFirstChild("ArborNameTag") then
						User.Character.Head:FindFirstChild("ArborNameTag").Enabled = true
					end
				end
			end
		end
	else
		CurrentState = true
		if CheckLoadingPageStatus() then
			LoadDataModule.ContentLoading("Updating Nametags")
			for _, User in pairs(Players:GetPlayers()) do
				if User.Character then
					if User.Character.Head:FindFirstChild("ArborNameTag") then
						User.Character.Head:FindFirstChild("ArborNameTag").Enabled = false
					end
				end
			end
			LoadDataModule.ContentLoading("Updating Nametags")
		else
			for _, User in pairs(Players:GetPlayers()) do
				if User.Character then
					if User.Character.Head:FindFirstChild("ArborNameTag") then
						User.Character.Head:FindFirstChild("ArborNameTag").Enabled = false
					end
				end
			end
		end
	end
end

Nametags.Enable.MouseButton1Click:Connect(function()
	CurrentState = true
	Nametags.Enable.ImageColor3 = Color3.fromRGB(31, 165, 31)
	Nametags.Disable.ImageColor3 = Color3.fromRGB(80, 80, 80)
	ToggleNametags()
end)

Nametags.Disable.MouseButton1Click:Connect(function()
	CurrentState = false
	Nametags.Enable.ImageColor3 = Color3.fromRGB(80, 80, 80)
	Nametags.Disable.ImageColor3 = Color3.fromRGB(165, 30, 30)
	ToggleNametags()
end)

--

ArborSettingsPage.SaveSettings.MouseButton1Click:Connect(function()
	if Players.LocalPlayer:GetRankInGroup(Settings["GroupID"]) >= Settings["AdminID"] then
		local SchoolTrips = {}

		for _, Year in pairs(TripsContainer:GetChildren()) do
			if Year:IsA("Frame") then
				local YearTable = {
					["Year"] = Year.Name,
					["DateTime"] = Year.DateTime.Input.Text,
					["TripName"] = Year.TripName.Input.Text
				}

				table.insert(SchoolTrips, YearTable)
			end
		end

		ReplicatedStorage:WaitForChild("Arbor")["ArborEvents"].SaveArborSettings:FireServer(SchoolTrips)
	else
		ArborInitializeModule.DisplayError("You do not have permission to do this")
	end
end)

--[ Dropdowns & Top Bar ]

local TopBarMin, TopBarMax = math.huge, 0

function ResetTopBarArea()
	for _, button in pairs(TopBar.LowerBar.List:GetChildren()) do
		if button:IsA("TextButton") then
			if button:GetAttribute("IsDropdown") then
				if button.AbsolutePosition.X < TopBarMin then
					TopBarMin = button.AbsolutePosition.X
				else
					TopBarMax = button.AbsolutePosition.X+button.AbsoluteSize.X
				end
			end
		end
	end
end

local GuiInset = GuiService:GetGuiInset()
local SubDropdownButtonPoints = {}

function ResetButtonPoints()
	for MenuName,MenuPage in pairs(DropdownModule["TopBarPages"]) do
		if MenuName ~= "Home" then
			for _,MenuButton in pairs(MenuPage:GetChildren()) do
				if MenuButton:IsA("TextButton") and MenuButton:GetAttribute("Sub") then
					table.insert(SubDropdownButtonPoints,{MinY=MenuButton.AbsolutePosition.Y,MaxY=MenuButton.AbsolutePosition.Y+MenuButton.AbsoluteSize.Y,EndX=MenuButton.AbsolutePosition.X+MenuButton.AbsoluteSize.X})
				end
			end
		end
	end
end

ResetTopBarArea()
ResetButtonPoints()

TopBar:GetPropertyChangedSignal("AbsoluteSize"):Connect(ResetTopBarArea)
TopBar:GetPropertyChangedSignal("AbsoluteSize"):Connect(ResetButtonPoints) -- Reset the minimum and maximum sizes on screen size update.

for _, button in pairs(TopBar.LowerBar.List:GetChildren()) do
	if button:IsA("TextButton") then
		if button:GetAttribute("IsDropdown") then
			button.MouseEnter:Connect(function()
				if System.LoginPage.Visible == false then
					if System.ContentLoading.Visible == false then
						DropdownModule.TopBarButton_Select(button, "View")
					end
				end
			end)

			button.MouseLeave:Connect(function(mouseX,mouseY)
				mouseY -= GuiInset.Y
				if (mouseY < button.AbsolutePosition.Y) or not (mouseX < TopBarMax and mouseX > TopBarMin) then
					DropdownModule.Dropdown_MouseLeave(button)
				end
			end)

			DropdownModule["TopBarPages"][button.Name].MouseLeave:Connect(function(mouseX,mouseY)
				mouseY -= GuiInset.Y

				local InLimits = false

				for _, ButtonPoints in pairs(SubDropdownButtonPoints) do
					if InLimits then
						continue
					end

					if ((mouseY > ButtonPoints.MinY and mouseY < ButtonPoints.MaxY) and (mouseX > ButtonPoints.EndX)) then
						InLimits = true
					end
				end

				if not InLimits then
					DropdownModule.Dropdown_MouseLeave(button)
				end
			end)
		else
			button.MouseButton1Click:Connect(function() DropdownModule.TopBarButton_Select(button, "Click") end)
		end
	end
end

System.Dropdowns.SchoolDropdown.Staff.MouseEnter:Connect(function()
	DropdownModule.EnableSubDropdown(System.Dropdowns.SchoolDropdown.Staff)
end)

System.Dropdowns.StaffDropdown.MouseLeave:Connect(function()
	DropdownModule.DisableSubDropdown(System.Dropdowns.SchoolDropdown.Staff)
end)

System.Dropdowns.SchoolDropdown.Behaviour.MouseEnter:Connect(function()
	DropdownModule.EnableSubDropdown(System.Dropdowns.SchoolDropdown.Behaviour)
end)

System.Dropdowns.BehaviourDropdown.MouseLeave:Connect(function()
	DropdownModule.DisableSubDropdown(System.Dropdowns.SchoolDropdown.Behaviour)
end)

function DisableAllPages()
	for _, item in pairs(DropdownModule.BehaviourDropdownPages) do
		for _, subItem in pairs(item) do
			subItem.Visible = false
		end
	end
	for _, item in pairs(DropdownModule.SchoolDropdownPages) do
		for _, subItem in pairs(item) do
			subItem.Visible = false
		end
	end
	for _, item in pairs(DropdownModule.SystemDropdownPages) do
		for _, subItem in pairs(item) do
			subItem.Visible = false
		end
	end
	for _, item in pairs(DropdownModule.StaffDropdownPages) do
		for _, subItem in pairs(item) do
			subItem.Visible = false
		end
	end
	for _, item in pairs(DropdownModule.OtherPages) do
		for _, subItem in pairs(item) do
			subItem.Visible = false
		end
	end

	System.StudentProfile.Visible = false
end

System.TopBar.LowerBar.List.Home.MouseButton1Click:Connect(function()
	DisableAllPages()
end)

System.TopBar.UserDetails.MouseButton1Click:Connect(function()
	DisableAllPages()
	System.HomePage.Visible = false
	System.Visible = false
	LaunchButton.Title.Text = "Launch"
end)

System.TopBar.SchoolTitle.Text = Settings.SchoolName

for _, popup in pairs(System.TopBar.SchoolTitle.Groups:GetChildren()) do
	if popup:IsA("ImageButton") then
		popup.MouseEnter:Connect(function()
			popup[popup.Name.."Popup"].Visible = true
		end)

		popup.MouseLeave:Connect(function()
			popup[popup.Name.."Popup"].Visible = false
		end)
	end
end


--[ Specific Dropdown Frames ]

for _, dropdownFrame in pairs(System.Dropdowns:GetChildren()) do
	if dropdownFrame:GetAttribute("HasFrames") == true then
		for _, dropdownButton in pairs(dropdownFrame:GetChildren()) do
			if dropdownButton:GetAttribute("HasFrame") == true then
				dropdownButton.MouseButton1Click:Connect(function()
					DisableAllPages()
					DropdownModule.EnableDropdownFrame(dropdownButton)

					System.HomePage.Visible = false
				end)
			end
		end
	end
end

--[ Arbor Interface - Arrow Icons ]

for _, uiObject in pairs(System:GetDescendants()) do
	if uiObject:IsA("ImageLabel") or uiObject:IsA("ImageButton") then
		if uiObject.Image == "rbxassetid://3926307971" then
			if uiObject.ImageRectSize == Vector2.new(36, 36) and uiObject.ImageRectOffset == Vector2.new(324, 524) then
				uiObject.MouseEnter:Connect(function()
					TweenService:Create(uiObject, TweenInfo.new(.2), {ImageTransparency = 0.4}):Play()
				end)

				uiObject.MouseLeave:Connect(function()
					TweenService:Create(uiObject, TweenInfo.new(.2), {ImageTransparency = 0}):Play()
				end)

				if uiObject:IsA("ImageButton") then
					uiObject.MouseButton1Down:Connect(function()
						TweenService:Create(uiObject, TweenInfo.new(.2), {ImageTransparency = 0.6}):Play()
					end)

					uiObject.MouseButton1Up:Connect(function()
						TweenService:Create(uiObject, TweenInfo.new(.2), {ImageTransparency = 0}):Play()
					end)
				end
			end
		end
	end
end

--[ Year Group Page ]

local YearGroupPage = System["YearGroupPage"]
local YearGroupPages = YearGroupPage["Pages"]
local YearGroupSideBox = YearGroupPage["Box"]

local AttendancePage = YearGroupPages["Attendance"]
local BehaviourPage = YearGroupPages["Behaviour"]
local OverviewPage = YearGroupPages["Overview"]
local YearTimetablePage = YearGroupPages["Timetable"]

local YearGroupButtons = {
	["Attendance"] = YearGroupPage.Attendance,
	["Behaviour"] = YearGroupPage.Behaviour,
	["Overview"] = YearGroupPage.Overview,
	["Timetable"] = YearGroupPage.Timetable
}

for _, Button in pairs(YearGroupButtons) do	
	Button.MouseEnter:Connect(function()
		Button.Title.FontFace.Weight = Enum.FontWeight.Medium
	end)

	Button.MouseLeave:Connect(function()
		Button.Title.FontFace.Weight = Enum.FontWeight.Regular
	end)

	Button.MouseButton1Click:Connect(function()
		YearGroupModule.EnableButtonFocus(Button)
		YearGroupModule.DisableAndEnablePages(Button)
	end)
end

System.HomePage.QuickActions.Buttons.ViewStudentAnalysis.MouseButton1Click:Connect(function()
	ArborInitializeModule.DisplayError("To view student analysis, head on over to the 'Students' tab at the top")
end)

--/ Attendance

YearGroupButtons["Attendance"].MouseButton1Click:Connect(function()
	YearGroupModule.LoadAttendanceData(YearGroupPage:GetAttribute("YearSelection"))
	warn("// Arbor Report - Load attendance data - Client")
end)

--/ Overview

YearGroupButtons["Overview"].MouseButton1Click:Connect(function()
	YearGroupModule.LoadOverviewPage(YearGroupPage:GetAttribute("YearSelection"))
	warn("// Arbor Report - Load overview data - Client")
end)

--/ Student Profile

local BrowseStudentsPage = System:WaitForChild("BrowseStudentsPage")
local StudentProfilePage = System["StudentProfile"]
local StudentProfilePages = StudentProfilePage["Pages"]
local StudentProfileContainer = StudentProfilePage["Container"]
local StudentProfilePanel = StudentProfilePage["RightPanel"]
local StudentProfileButtons = StudentProfilePage["SideButtons"]

local StudentProfileBtns = {
	["Activities"] = StudentProfileButtons.List.Activities,
	["Attendance"] = StudentProfileButtons.List.Attendance,
	["Behaviour"] = StudentProfileButtons.List.Behaviour,
	["Timetable"] = StudentProfileButtons.List.Timetable,
	["StudentProfile"] = StudentProfileButtons.List.StudentProfile
}

for _, Button in pairs(StudentProfileBtns) do	
	Button.MouseEnter:Connect(function()
		Button.BackgroundColor3 = Color3.fromRGB(216, 216, 216)
		Button.Title.FontFace.Weight = Enum.FontWeight.Medium
	end)

	Button.MouseLeave:Connect(function()
		Button.BackgroundColor3 = Color3.fromRGB(248, 248, 248)
		Button.Title.FontFace.Weight = Enum.FontWeight.Regular
	end)

	Button.MouseButton1Click:Connect(function()
		if string.find(Button.Name, "Profile") then
			YearGroupModule.DisablePages()
			YearGroupModule.LoadStudentProfile(StudentProfilePage:FindFirstChild("StudentObject").Value)
			StudentProfilePage.Visible = true
			StudentProfileContainer.Visible = true
			StudentProfilePanel.Visible = true
			StudentProfileButtons.Visible = true
		else
			YearGroupModule.DisablePages()
			StudentProfilePage.Visible = true
			StudentProfileButtons.Visible = true
			StudentProfilePages[Button.Name].Visible = true
		end

		Button.BackgroundColor3 = Color3.fromRGB(208, 231, 187)
		Button.Title.FontFace.Weight = Enum.FontWeight.Medium
	end)
end

BrowseStudentsPage.OuterList.List.ChildAdded:Connect(function()
	for _, Student in pairs(BrowseStudentsPage["OuterList"]["List"]:GetChildren()) do
		if Student:IsA("TextButton") then
			Student.View.MouseButton1Click:Connect(function()
				if table.find(Settings["Teams"], ArborData.PlayerData[Student.Name].OriginalYearGroup.Value) then
					YearGroupModule.DisableAndEnablePages()
					YearGroupModule.DisablePages()

					StudentProfilePage:FindFirstChild("StudentObject").Value = Players[Student.Name]
					YearGroupModule.LoadStudentProfile(StudentProfilePage:FindFirstChild("StudentObject").Value)

					BrowseStudentsPage.Visible = false
					StudentProfilePage.Visible = true
					StudentProfileContainer.Visible = true
					StudentProfilePanel.Visible = true
					StudentProfileButtons.Visible = true
				else
					ArborInitializeModule.DisplayError("This student is not part of registered team")
				end
			end)

			Student.MouseEnter:Connect(function()
				TweenService:Create(Student.View, TweenInfo.new(.45, Enum.EasingStyle.Quart), {Position = UDim2.new(0.001, 0, 0, 0 )}):Play()
			end)

			Student.MouseLeave:Connect(function()
				TweenService:Create(Student.View, TweenInfo.new(.45, Enum.EasingStyle.Quart), {Position = UDim2.new(0.001, 0, 1, 0 )}):Play()
			end)
		end
	end
end)

StudentProfileButtons.ReturnToOverview.MouseButton1Click:Connect(function()
	YearGroupModule.EnableButtonFocus(YearGroupButtons["Overview"])
	YearGroupModule.DisableAndEnablePages(YearGroupButtons["Overview"])
	YearGroupModule.DisablePages()
	DisableAllPages()
	StudentProfilePage.Visible = false
	BrowseStudentsPage.Visible = true
	BrowseUserPage.InsertAllStudents()
end)

StudentProfileContainer.Behaviour.Page.ViewDash.MouseButton1Click:Connect(function()
	YearGroupModule.DisablePages()
	DisableAllPages()
	BehaviourDashboard.Visible = true
	OverviewPage.Visible = true
end)

StudentProfilePanel.CopyStudentData.MouseButton1Click:Connect(function()
	StudentProfilePage.CopyPage.Details.TitleFrame.Title.Text = "Student data for: "..StudentProfilePage.StudentObject.Value.Name
	StudentProfilePage.CopyPage.Details.InfoBox.Title.Text = game:GetService("HttpService"):JSONEncode(YearGroupModule.CopyStudentData(StudentProfilePage.StudentObject.Value)	)
	StudentProfilePage.CopyPage.Visible = not StudentProfilePage.CopyPage.Visible
	StudentProfilePage.BlackFrame.Visible = not StudentProfilePage.BlackFrame.Visible
end)

StudentProfilePage.CopyPage.Close.MouseButton1Click:Connect(function()
	StudentProfilePage.CopyPage.Visible = false
	StudentProfilePage.BlackFrame.Visible = false
end)

local RecordAttendancePage = StudentProfilePanel["RecordAttendancePage"]

StudentProfilePanel.RecordAttendance.MouseButton1Click:Connect(function()
	for _, PeriodInList in pairs(RecordAttendancePage["List"]:GetChildren()) do
		if PeriodInList:IsA("Frame") then
			PeriodInList:Destroy()
		end
	end

	for i, Period in pairs(Settings["Periods"]) do
		if Period["AttendanceIsLogged"] == true then
			local Example = RecordAttendancePage["Example"]:Clone()
			Example.Parent = RecordAttendancePage["List"]
			Example.Name = Period["Name"]
			Example.Visible = true

			if i == #Settings["Periods"] then
				Example.Data.Text = "<b>"..Period["Time"].." - N/A</b>: "..Period["Name"]
			else
				Example.Data.Text = "<b>"..Period["Time"].." - "..Settings["Periods"][i+1]["Time"].."</b>: "..Period["Name"]
			end

			if ArborData["AttendanceData"][StudentProfilePage.StudentObject.Value.Name][Period["Name"]].Value == "Present" then
				Example.Example.ImageColor3 = Color3.fromRGB(83, 132, 32)
				Example.Example.ImageRectOffset = Vector2.new(644, 204) 
				Example.Example.ImageRectSize = Vector2.new(36, 36)
			elseif ArborData["AttendanceData"][StudentProfilePage.StudentObject.Value.Name][Period["Name"]].Value == "Absent" then
				Example.Example.ImageColor3 = Color3.fromRGB(132, 32, 32)
				Example.Example.ImageRectOffset = Vector2.new(284, 4) 
				Example.Example.ImageRectSize = Vector2.new(24, 24)
			end
		end
	end

	RecordAttendancePage.Visible = not RecordAttendancePage.Visible
	StudentProfilePage.BlackFrame.Visible = not StudentProfilePage.BlackFrame.Visible
end)

StudentProfilePanel.RecordAttendancePage.Close.MouseButton1Click:Connect(function()
	RecordAttendancePage.Visible = false
	StudentProfilePage.BlackFrame.Visible = false
end)


RecordAttendancePage["List"].ChildAdded:Connect(function(PeriodInList)
	if PeriodInList:IsA("Frame") then
		PeriodInList.RecordAttendance.MouseButton1Click:Connect(function()
			if ArborData["AttendanceData"][StudentProfilePage.StudentObject.Value.Name][PeriodInList.Name].Value == "Present" then
				PeriodInList.Example.ImageColor3 = Color3.fromRGB(132, 32, 32)
				PeriodInList.Example.ImageRectOffset = Vector2.new(284, 4) 
				PeriodInList.Example.ImageRectSize = Vector2.new(24, 24)
				ReplicatedStorage["Arbor"].ArborEvents.RecordAttendance:FireServer(StudentProfilePage.StudentObject.Value.Name, PeriodInList.Name, "Absent")
			elseif ArborData["AttendanceData"][StudentProfilePage.StudentObject.Value.Name][PeriodInList.Name].Value == "Absent" then
				PeriodInList.Example.ImageColor3 = Color3.fromRGB(83, 132, 32)
				PeriodInList.Example.ImageRectOffset = Vector2.new(644, 204) 
				PeriodInList.Example.ImageRectSize = Vector2.new(36, 36)
				ReplicatedStorage["Arbor"].ArborEvents.RecordAttendance:FireServer(StudentProfilePage.StudentObject.Value.Name, PeriodInList.Name, "Present")
			end
		end)
	end
end)


StudentProfilePanel.NextStudent.MouseButton1Click:Connect(function()
	YearGroupModule.EnableButtonFocus(YearGroupButtons["Overview"])
	YearGroupModule.DisableAndEnablePages(YearGroupButtons["Overview"])
	YearGroupModule.DisablePages()
	DisableAllPages()
	StudentProfilePage.Visible = false
	BrowseStudentsPage.Visible = true
end)

StudentProfilePanel.PreviousStudent.MouseButton1Click:Connect(function()
	YearGroupModule.EnableButtonFocus(YearGroupButtons["Overview"])
	YearGroupModule.DisableAndEnablePages(YearGroupButtons["Overview"])
	YearGroupModule.DisablePages()
	DisableAllPages()
	StudentProfilePage.Visible = false
	BrowseStudentsPage.Visible = true
end)

--[ Attendance - Student Profile ]

StudentProfileBtns["Attendance"].MouseButton1Click:Connect(function()
	YearGroupModule.LoadStudentProfileAttendance(StudentProfilePage:FindFirstChild("StudentObject").Value)
end)

--[ Timetable - Student Profile ]
TimetablePage.CreateTimetable(StudentProfilePages)

StudentProfileBtns["Timetable"].MouseButton1Click:Connect(function()
	YearGroupModule.LoadStudentProfileTimetable()
end)

for _, year in StudentProfilePages.Timetable.TimetableContainer.CoreFrame:GetChildren() do
	if year.Name ~= "Times" and year.Name ~= "ColumnTemplate" and year:IsA("Frame") then
		for _, lesson in year:GetChildren() do
			if lesson:IsA("TextButton") then
				if lesson.Name ~= "Teams" and lesson.Details.Visible then
					lesson.Details.MouseEnter:Connect(function()
						local Popup
						
						if (lesson.LayoutOrder * (1 / (#year:GetChildren() - 2))) + 0.4 + (1 / (#year:GetChildren() - 2)) / 2 > 1 then
							Popup = StudentProfilePages.Timetable.PopupD:Clone() 
						else
							Popup = StudentProfilePages.Timetable.PopupU:Clone() 
						end
						
						Popup.Parent = lesson
						Popup.Visible = true

						Popup.DateData.Text = DateService:FormatLocalTime("dddd", "en-us")..", "..DateService:FormatLocalTime("D", "en-us").." "..DateService:FormatLocalTime("MMM", "en-us").." "..DateService:FormatLocalTime("YYYY", "en-us")
						Popup.LessonData.Text = ReplicatedStorage["Arbor"]["ArborData"]["Lessons"][lesson:GetAttribute("Lesson")][lesson:GetAttribute("Year")].SpecificValue.Value
						Popup.Title.Text = ReplicatedStorage["Arbor"]["ArborData"]["Lessons"][lesson:GetAttribute("Lesson")][lesson:GetAttribute("Year")].SpecificValue.Value
						Popup.StaffData.Text = ReplicatedStorage["Arbor"]["ArborData"]["Lessons"][lesson:GetAttribute("Lesson")][lesson:GetAttribute("Year")].StaffMember.Value
					end)

					lesson.Details.MouseLeave:Connect(function()
						local find = lesson:FindFirstChild("PopupU") or lesson:FindFirstChild("PopupD")
						
						if find then
							find:Destroy()
							System.ClipsDescendants = true
						end
					end)

					lesson.Details.MouseButton1Click:Connect(function()
						DisableAllPages()
						System.LessonDisplayPage.Visible = true
						System.LessonDisplayPage.Page.Visible = true
						System.LessonDisplayPage.TakeRegisterPage.Visible = false

						LessonDisplayPageModule.ClearRegister()
						LessonDisplayPageModule.LoadCurrentLesson(lesson:GetAttribute("Lesson"), lesson:GetAttribute("Year"))
						LessonDisplayPageModule.InsertStudents(System.LessonDisplayPage.Page.LessonDetails:GetAttribute("Lesson"), LessonDisplayPage.Page.LessonDetails:GetAttribute("Year"))
					end)
				end
			end
		end
	end
end


--[ Behaviour - Student Profile ]

StudentProfileBtns["Behaviour"].MouseButton1Click:Connect(function()
	YearGroupModule.LoadStudentProfileBehaviour(StudentProfilePage:FindFirstChild("StudentObject").Value)
end)

StudentProfilePages["Behaviour"]["Behaviour"].Page.Merits.Add.MouseButton1Click:Connect(function()
	local MeritData = {
		["GivenAt"] = ReplicatedStorage["Arbor"].ArborData.CurrentTime.Value..", "..DateService:FormatLocalTime("ddd", "en-us").." "..DateService:FormatLocalTime("D", "en-us").." "..DateService:FormatLocalTime("MMM", "en-us").." "..DateService:FormatLocalTime("YYYY", "en-us"),
		["GivenBy"] = game.Players.LocalPlayer.Name,
		["Location"] = "N/A",
		["ReasonAttribute"] = "Manual Addition",
		["Student"] = StudentProfilePage:FindFirstChild("StudentObject").Value.Name,
		["TotalAwarded"] = "1"
	}

	BehaviourDashboardModule.LogMerit(StudentProfilePage:FindFirstChild("StudentObject").Value, game.Players.LocalPlayer, MeritData)
	ArborInitializeModule.DisplayError("Merit has been successfully logged")

	wait(1)
	YearGroupModule.LoadStudentProfileBehaviour(StudentProfilePage:FindFirstChild("StudentObject").Value)
	StudentProfilePages["Behaviour"]["Behaviour"].Page.Merits.Data.Text = ArborData["PlayerData"][StudentProfilePage:FindFirstChild("StudentObject").Value.Name].MeritsTotal.Value
end)

StudentProfilePages["Behaviour"]["Behaviour"].Page.BehaviourPoints.Add.MouseButton1Click:Connect(function()
	local BehaviourPointsData = {
		["GivenAt"] = ReplicatedStorage["Arbor"].ArborData.CurrentTime.Value..", "..DateService:FormatLocalTime("ddd", "en-us").." "..DateService:FormatLocalTime("D", "en-us").." "..DateService:FormatLocalTime("MMM", "en-us").." "..DateService:FormatLocalTime("YYYY", "en-us"),
		["GivenBy"] = game.Players.LocalPlayer.Name,
		["Location"] = "N/A",
		["ReasonAttribute"] = "Manual Addition",
		["Student"] = StudentProfilePage:FindFirstChild("StudentObject").Value.Name,
		["TotalAwarded"] = "1"
	}

	BehaviourDashboardModule.LogBehaviourPoint(StudentProfilePage:FindFirstChild("StudentObject").Value, game.Players.LocalPlayer, BehaviourPointsData)
	ArborInitializeModule.DisplayError("Behaviour point has been successfully logged")

	wait(1)
	YearGroupModule.LoadStudentProfileBehaviour(StudentProfilePage:FindFirstChild("StudentObject").Value)
	StudentProfilePages["Behaviour"]["Behaviour"].Page.BehaviourPoints.Data.Text = ArborData["PlayerData"][StudentProfilePage:FindFirstChild("StudentObject").Value.Name].BehaviourPointsTotal.Value
end)

--[ Activites - Student Profile ]

StudentProfileBtns["Activities"].MouseButton1Click:Connect(function()
	YearGroupModule.LoadStudentProfileActivities(StudentProfilePage:FindFirstChild("StudentObject").Value)
end)


--/ Behaviour

local BehaviourButtons = BehaviourPage.BehaviourOptions["Buttons"]

YearGroupButtons["Behaviour"].MouseButton1Click:Connect(function()
	YearGroupModule.LoadBehaviourData(YearGroupPage:GetAttribute("YearSelection"))
end)

BehaviourButtons.BehaviourPoints.MouseButton1Click:Connect(function()
	DisableAllPages()
	BehaviourDashboard.Visible = true
	BehaviourDashboardModule.DisableAllPages(BehaviourPoints.Dashboard)
	BehaviourPointsDashboard.Visible = true
	BehaviourPointsDashboard.LogBehaviourPointPage.Visible = false
	BehaviourDashboardModule.LoadBehaviourPoints()
end)

BehaviourButtons.BehaviouralIncidents.MouseButton1Click:Connect(function()
	DisableAllPages()
	BehaviourDashboard.Visible = true
	BehaviourDashboardModule.DisableAllPages(Incidents.Dashboard)
	IncidentDashboadPage.Visible = true
	IncidentDashboadPage.BehaviouralIncidentPage.Visible = false
	HideBehaviouralIncidentPage()
end)

BehaviourButtons.Detentions.MouseButton1Click:Connect(function()
	DisableAllPages()
	DetentionsPageModule.LoadDetentions()
	DetentionsPageModule.LoadCurrentDate()
	DetentionsPage.Visible = true
end)

BehaviourButtons.Isolations.MouseButton1Click:Connect(function()
	DisableAllPages()
	BehaviourDashboard.Visible = true
	BehaviourDashboardModule.DisableAllPages(Isolations.Dashboard)
	IsolationsDashboard.Visible = true
	LogIsolationPage.Visible = false
	BehaviourDashboardModule.LoadIsolations()
end)

--/ Timetable

TimetablePage.CreateTimetable(YearTimetablePage.Parent)

YearGroupButtons["Timetable"].MouseButton1Click:Connect(function()
	YearGroupModule.LoadTimetable(YearGroupPage:GetAttribute("YearSelection"))
end)

for _, year in YearTimetablePage.TimetableContainer.CoreFrame:GetChildren() do
	if year.Name ~= "Times" and year.Name ~= "ColumnTemplate" and year:IsA("Frame") then
		for _, lesson in year:GetChildren() do
			if lesson:IsA("TextButton") then
				if lesson.Name ~= "Teams" and lesson.Details.Visible then
					lesson.Details.MouseEnter:Connect(function()
						local Popup

						if (lesson.LayoutOrder * (1 / (#year:GetChildren() - 2))) + 0.4 + (1 / (#year:GetChildren() - 2)) / 2 > 1 then
							Popup = YearTimetablePage.PopupD:Clone() 
						else
							Popup = YearTimetablePage.PopupU:Clone() 
						end

						Popup.Parent = lesson
						Popup.Visible = true

						Popup.DateData.Text = DateService:FormatLocalTime("dddd", "en-us")..", "..DateService:FormatLocalTime("D", "en-us").." "..DateService:FormatLocalTime("MMM", "en-us").." "..DateService:FormatLocalTime("YYYY", "en-us")
						Popup.LessonData.Text = ReplicatedStorage["Arbor"]["ArborData"]["Lessons"][lesson:GetAttribute("Lesson")][lesson:GetAttribute("Year")].SpecificValue.Value
						Popup.Title.Text = ReplicatedStorage["Arbor"]["ArborData"]["Lessons"][lesson:GetAttribute("Lesson")][lesson:GetAttribute("Year")].SpecificValue.Value
						Popup.StaffData.Text = ReplicatedStorage["Arbor"]["ArborData"]["Lessons"][lesson:GetAttribute("Lesson")][lesson:GetAttribute("Year")].StaffMember.Value
					end)

					lesson.Details.MouseLeave:Connect(function()
						local find = lesson:FindFirstChild("PopupU") or lesson:FindFirstChild("PopupD")
						
						if find then
							find:Destroy()
							System.ClipsDescendants = true
						end
					end)

					lesson.Details.MouseButton1Click:Connect(function()
						DisableAllPages()
						System.LessonDisplayPage.Visible = true
						System.LessonDisplayPage.Page.Visible = true
						System.LessonDisplayPage.TakeRegisterPage.Visible = false

						LessonDisplayPageModule.ClearRegister()
						LessonDisplayPageModule.LoadCurrentLesson(lesson:GetAttribute("Lesson"), lesson:GetAttribute("Year"))
						LessonDisplayPageModule.InsertStudents(System.LessonDisplayPage.Page.LessonDetails:GetAttribute("Lesson"), LessonDisplayPage.Page.LessonDetails:GetAttribute("Year"))
					end)
				end
			end
		end
	end
end

--/ Dropdown

local StudentDropdown = System["Dropdowns"].StudentsDropdown

for i, Team in pairs(Settings["Teams"]) do
	if game:GetService("Teams")[Team] then
		local TeamExample = script["TeamExample"]:Clone()
		TeamExample.Parent = StudentDropdown
		TeamExample.Visible = true
		TeamExample.Name = Team
		TeamExample.LayoutOrder = i
		TeamExample.Title.Text = Team
	end
end

for _, TeamDropdown in pairs(StudentDropdown:GetChildren()) do
	if TeamDropdown:IsA("TextButton") and TeamDropdown:GetAttribute("IsATeam") then
		if TeamDropdown:GetAttribute("IsATeam") == true then
			TeamDropdown.MouseButton1Click:Connect(function()
				DisableAllPages()
				HomePage.Visible = false
				StudentDropdown.Visible = false
				YearGroupPage.Visible = true
				YearGroupModule.DisablePages()
				YearGroupPage:SetAttribute("YearSelection", TeamDropdown.Name)
				YearGroupSideBox.Title.Text = TeamDropdown.Name
				YearGroupModule.EnableButtonFocus(nil)
			end)
		end
	end
end

--[ Arbor Global Timing ]

RunService.RenderStepped:Connect(function() 
	local DateTimeFormat = DateTime.now() SessionDetails.Time.Text = DateTimeFormat:FormatLocalTime("LT", "zh-cn") 
	local CurrentPeriod = ReplicatedStorage:WaitForChild("Arbor")["ArborData"].CurrentPeriod

	SessionDetails.LessonAndDate.Text = CurrentPeriod.Value..", "..DateTimeFormat:FormatLocalTime("D", "en-us").." "..DateTimeFormat:FormatLocalTime("MMM", "en-us")

	--[ Calendar Events ]

	for _, calendarEvent in pairs(HomePage.MyCalendar.List:GetChildren()) do
		if calendarEvent:IsA("Frame") then
			if calendarEvent:GetAttribute("EndTime") == tostring(DateTimeFormat:FormatLocalTime("LT", "zh-cn")) then
				calendarEvent:Destroy()
			end

			if tonumber(calendarEvent:GetAttribute("StartTimeShort")) - tonumber(ReplicatedStorage:WaitForChild("Arbor")["ArborData"].CurrentTime:GetAttribute("AlternativeTime")) == 3 then
				calendarEvent.LeftSide.ColorFrame.BackgroundColor3 = Color3.fromRGB(255, 146, 32)
				calendarEvent.LeftSide.BackgroundColor3 = Color3.fromRGB(255, 146, 32)
			end

			if calendarEvent:GetAttribute("StartTime") == tostring(DateTimeFormat:FormatLocalTime("LT", "zh-cn")) then
				calendarEvent.LeftSide.ColorFrame.BackgroundColor3 = Color3.fromRGB(0, 157, 0)
				calendarEvent.LeftSide.BackgroundColor3 = Color3.fromRGB(0, 157, 0)
			end
		end
	end

	for _, calendarEvent in pairs(System.StudentView.MyCalendar.List:GetChildren()) do
		if calendarEvent:IsA("Frame") then
			if calendarEvent:GetAttribute("EndTime") == tostring(DateTimeFormat:FormatLocalTime("LT", "zh-cn")) then
				calendarEvent:Destroy()
			end

			if tonumber(calendarEvent:GetAttribute("StartTimeShort")) - tonumber(ReplicatedStorage:WaitForChild("Arbor")["ArborData"].CurrentTime:GetAttribute("AlternativeTime")) == 3 then
				calendarEvent.LeftSide.ColorFrame.BackgroundColor3 = Color3.fromRGB(255, 146, 32)
				calendarEvent.LeftSide.BackgroundColor3 = Color3.fromRGB(255, 146, 32)
			end

			if calendarEvent:GetAttribute("StartTime") == tostring(DateTimeFormat:FormatLocalTime("LT", "zh-cn")) then
				calendarEvent.LeftSide.ColorFrame.BackgroundColor3 = Color3.fromRGB(0, 157, 0)
				calendarEvent.LeftSide.BackgroundColor3 = Color3.fromRGB(0, 157, 0)
			end
		end
	end
end)
