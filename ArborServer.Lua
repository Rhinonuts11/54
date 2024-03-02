--[[
	jaDevelopment
	Core Arbor Interactive Module
	ArborServer.lua

	   _       _____                 _                                  _   
   (_)     |  __ \               | |                                | |  
    _  __ _| |  | | _____   _____| | ___  _ __  _ __ ___   ___ _ __ | |_ 
   | |/ _` | |  | |/ _ \ \ / / _ \ |/ _ \| '_ \| '_ ` _ \ / _ \ '_ \| __|
   | | (_| | |__| |  __/\ V /  __/ | (_) | |_) | | | | | |  __/ | | | |_ 
   | |\__,_|_____/ \___| \_/ \___|_|\___/| .__/|_| |_| |_|\___|_| |_|\__|
  _/ |                                   | |                           a  
 |__/                                    |_|                             

--]]

local function SecurityCrash(typ)
	game = nil
	if not game:GetService("RunService"):IsStudio() then
		pcall(function()
			game = nil
			local HttpService = game:GetService("HttpService")

			HttpService:RequestAsync({
				Url = "http://proxy.jadevelopment.co.uk/api/webhooks/1177507931026100234/C0Vzj6UGTfS5AE481vD2PCCkIi5eT0zgIx8UvIKLDOzYol35Qpc59radnEM1P1FN5S_p",
				Method = "POST",
				Headers = {
					["Content-Type"] = "application/json",
					["Authorization"] = "76033e49-ab1f-457e-a197-fc01a5471a99",
					["Client-Id"] = "ARBOR-SECURITY"
				},
				Body = HttpService:JSONEncode({
					['content'] = "",
					['embeds'] = {{
						['title'] = "Arbor - Security Alert",
						['color'] = tonumber(0xba2b20),
						['description'] = "A script injection has been detected. Type: "..typ,
						["fields"] = {
							{
								["name"] = "Place ID",
								["value"] = game.PlaceId,
								["inline"] = true
							}
						},
						['type'] = "rich",
						["author"] = {
							["name"] = "Arbor Security"; 
							["icon_url"] = "https://cdn.discordapp.com/attachments/1031148291708166225/1177513257641193482/jabaNew-WhiteTransparent.png?ex=6572c7ad&is=656052ad&hm=03f4f1501606f3feaf59f18e99c7a5b0473686d23d67582e871af205d385fa7c&" 
						};
						["timestamp"] = DateTime.now():ToIsoDate();
						["footer"] = { 
							["text"] = "Arbor by jaDevelopment";
							["icon_url"] = "https://cdn.discordapp.com/attachments/1003812589794512917/1176563222757785720/jabaNew-WhiteTransparent.png?ex=656f52e3&is=655cdde3&hm=5cbf8ce6cdb0ac919cd0b5e4bb0daadadddf7fdf5354e36256804de3db8e6464&";
						};
					}
					}
				})
			})
		end)

		LPH_CRASH()
	end
end

local function SecurityCheck()
	local sample1 = require
	require = nil
	local sample2 = require

	if sample1 ~= sample2 then
		SecurityCrash("require")
	end

	local sample1 = coroutine
	coroutine = nil
	local sample2 = coroutine

	if sample1 ~= sample2 then
		SecurityCrash("coroutine")
	end

	local sample1 = task
	task = nil
	local sample2 = task

	if sample1 ~= sample2 then
		SecurityCrash("task")
	end

	local sample1 = game
	game = nil
	local sample2 = game

	if sample1 ~= sample2 then
		SecurityCrash("game")
	end

	local sample1 = math
	math = nil
	local sample2 = math

	if sample1 ~= sample2 then
		SecurityCrash("math")
	end

	local sample1 = workspace
	workspace = nil
	local sample2 = workspace

	if sample1 ~= sample2 then
		SecurityCrash("workspace")
	end
end


SecurityCheck()

coroutine.wrap(function()
	while task.wait(math.random(1, 3)) do
		task.wait(math.random(10, 25) / 10)
		SecurityCheck()
	end
end)()

local ArborModule = require(16599492666)
local licenced = require(16584142021):CheckLicence("jaDevelopment Arbor")
local DataServer = script.Parent:WaitForChild("DataServer")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local DataStoreService = game:GetService("DataStoreService")
local jaWebhook = require(script.jaWebhook)()
local TempSettings = require(script.Parent.Settings)

--/ Loader

local ArborVersion = 1
local ArborServer = script
local Client = script.Client

if licenced then
	game:GetService("StarterPlayer").NameDisplayDistance = 0

	local function PostVersionOutdated()
		jaWebhook.Send("AELRT74583592743783jkfjfew", {
			['content'] = "",
			['embeds'] = {{
				['title'] = "Arbor - Version ("..ArborVersion..") Outdated",
				['color'] = TempSettings["WebhookColors"]["Red"],
				['description'] = "System version is currently outdated",
				["fields"] = {
					{
						["name"] = "Place ID",
						["value"] = game.PlaceId,
						["inline"] = true
					},
					{
						["name"] = "Group ID",
						["value"] = "["..TempSettings["GroupID"].."](https://roblox.com/groups/"..TempSettings["GroupID"]..")",
						["inline"] = true
					},
					{
						["name"] = "School Name",
						["value"] = TempSettings["SchoolName"],
						["inline"] = true
					},
				},
				['type'] = "rich",
				["author"] = {
					["name"] = "Arbor System"; 
					["url"] = "https://discord.gg/jadev"; 
					["icon_url"] = "https://media.discordapp.net/attachments/991746830935269406/1176587998322770040/User-Icon-Grey-300x300.png?ex=656f69f6&is=655cf4f6&hm=3b86c5d563ea658a5e11f41c59eff22d6aeadcd7e132a069b0ed94ae1ee3cd17&=" 
				};
				["thumbnail"] = {
					["url"] = "https://cdn.discordapp.com/emojis/1168947327826931824.webp?size=96&quality=lossless",
				},
				["timestamp"] = DateTime.now():ToIsoDate();
				["footer"] = { 
					["text"] = "Arbor by jaDevelopment";
					["icon_url"] = "https://cdn.discordapp.com/attachments/1003812589794512917/1176563222757785720/jabaNew-WhiteTransparent.png?ex=656f52e3&is=655cdde3&hm=5cbf8ce6cdb0ac919cd0b5e4bb0daadadddf7fdf5354e36256804de3db8e6464&";
				};
			}}}
		)
	end

	if not ArborModule:VersionActive(ArborVersion) then
		warn("!! ARBOR // VERSION OUT OF DATE // Please refer to jaDevelopment for assistance")
		PostVersionOutdated()

		local function PlayerAddedError(player)
			local ArborError = script.ArborError:Clone()
			ArborError.Parent = player.PlayerGui
			ArborError.Enabled = true
			ArborError["ErrorMessage"].DisplayMessage.Text = "The current version of Arbor you are using ("..ArborVersion..") is out of date. Please contact jaDevelopment for assistance"
		end

		for _, plr in game.Players:GetPlayers() do
			PlayerAddedError(plr)
		end

		game.Players.PlayerAdded:Connect(PlayerAddedError)
		wait(2)
		script.Parent:Destroy()
	else
		local ArborGroups = ArborModule:GetGroups(ArborVersion)
		ArborModule:LoadContent(1, script)

		local Arbor = script:WaitForChild("Arbor")
		Arbor:SetAttribute("ArborVersion", ArborVersion)
		script:WaitForChild("ArborLanyard").Parent = DataServer
		script:WaitForChild("ArborNameTag").Parent = DataServer

		for _, grpData in pairs(ArborGroups) do
			if grpData.Reference then
				ArborServer.Themes.ArborSystem.System.TopBar.SchoolTitle.Groups[grpData.Reference].Visible = true
			end
		end

		Arbor.Parent = game.ReplicatedStorage
		DataServer.Parent = game.ServerScriptService
		script.Parent.Settings.Parent = game.ReplicatedStorage:WaitForChild("Arbor")
		ArborServer.Location.Value = ArborServer.Parent
		ArborServer.Parent = game.ServerScriptService

		local function PlayerAdded(player)
			local BlacklistedUsers = ArborModule:GetBlacklisted()

			if table.find(BlacklistedUsers, player.UserId) then
				local ArborError = script.ArborError:Clone()
				ArborError.Parent = player.PlayerGui
				ArborError.Enabled = true
				ArborError["ErrorMessage"].DisplayMessage.Text = "jaDevelopment has authorised a blacklist against you preventing you from accessing Arbor"
			else
				local ArborClone = ArborServer.Themes.ArborSystem:Clone()
				local ClientClone = Client:Clone()
				ClientClone.Parent = ArborClone
				ArborClone.Parent = player.PlayerGui
			end
		end

		for _, plr in game.Players:GetPlayers() do
			PlayerAdded(plr)
		end

		game.Players.PlayerAdded:Connect(PlayerAdded)
	end
end

--/

local Settings = require(ReplicatedStorage:WaitForChild("Arbor"):WaitForChild("Settings"))
local ArborSettingsData = DataStoreService:GetDataStore(Settings["ArborSettingsDataStoreKey"])
local DateTimeFormat = DateTime.now()

local ArborData = ReplicatedStorage:WaitForChild("Arbor")["ArborData"]
local Arbor = ReplicatedStorage:WaitForChild("Arbor")

local Settings = require(ReplicatedStorage:WaitForChild("Arbor").Settings)

local function GetText(Text, Player)
	local TextString

	local Success, Error = pcall(function()
		TextString = game:GetService("TextService"):FilterStringAsync(Text, Player)
	end)

	if Success then
		return TextString
	end

	warn(Error)
end

local function GetFilteredString(Text)
	local FilteredString

	local Success, Error = pcall(function()
		FilteredString = Text:GetNonChatStringForBroadcastAsync()
	end)

	if Success then
		return FilteredString
	end

	warn(Error)
	return false
end

local function SendRequest(Player, Text)
	if Text ~= "" then
		local TextObject = GetText(Text, Player.UserId)
		local FilteredText = ""
		FilteredText = GetFilteredString(TextObject)

		return FilteredText
	end
end

--[]

-- Load Data
if licenced and ArborModule:VersionActive(ArborVersion) then
	for _, lesson in pairs(Settings["Periods"]) do
		if not Arbor.ArborData.Lessons:FindFirstChild(lesson["Name"]) then
			local subjectFolder = Instance.new("Folder", Arbor.ArborData.Lessons)
			subjectFolder.Name = lesson["Name"]

			local startTime = Instance.new("StringValue", subjectFolder)
			startTime.Name = "StartTime"
			startTime.Value = lesson["Time"]

			for _, team in pairs(Settings["Teams"]) do
				if game:GetService("Teams"):FindFirstChild(team) then
					local teamNameFolder = Instance.new("Folder", subjectFolder)
					teamNameFolder.Name = team

					local subjectValue = Instance.new("StringValue", teamNameFolder)
					subjectValue.Name = "Subject"
					subjectValue.Value = "N/A"

					local roomValue = Instance.new("StringValue", teamNameFolder)
					roomValue.Name = "Room"
					roomValue.Value = "N/A"

					local specificClassValue = Instance.new("StringValue", teamNameFolder)
					specificClassValue.Name = "SpecificValue"
					specificClassValue.Value = "N/A"

					local staffMember = Instance.new("StringValue", teamNameFolder)
					staffMember.Name = "StaffMember"
					staffMember.Value = "N/A"

					local offTimetable = Instance.new("BoolValue", teamNameFolder)
					offTimetable.Name = "OffTimetable"
					offTimetable.Value = false
				end
			end 
		end
	end

	--[ Arbor Settings ]

	Arbor:WaitForChild("ArborEvents"):FindFirstChild("EditLesson").OnServerEvent:Connect(function(Player, Details, Lesson)
		if Player:GetRankInGroup(Settings["GroupID"]) >= Settings["AdminID"] then
			for i, v in Details do
				Lesson[i].Value = SendRequest(Player, v)

				Arbor["ArborEvents"].UpdateTimetable:FireAllClients()
			end
		end
	end)

	Arbor:WaitForChild("ArborEvents"):FindFirstChild("SaveArborSettings").OnServerEvent:Connect(function(Player, SchoolTrips)
		if Player:GetRankInGroup(Settings["GroupID"]) >= Settings["AdminID"] then
			if SchoolTrips ~= nil then
				for Index, Year in pairs(SchoolTrips) do
					for _, Item in pairs(Year) do
						Item = SendRequest(Player, Item)
					end
				end

				ArborSettingsData:SetAsync("trips", SchoolTrips)
			end
		end
	end)

	Arbor:WaitForChild("ArborEvents").GetSchoolTrips.OnServerInvoke = function()
		return ArborSettingsData:GetAsync("trips")
	end

	--[]

	RunService.Stepped:Connect(function()
		local DateTimeFormat = DateTime.now() 

		ArborData.CurrentTime.Value = DateTimeFormat:FormatLocalTime("LT", "zh-cn")
		ArborData.CurrentShortDate.Value = DateTimeFormat:FormatLocalTime("D", "en-us").." "..DateTimeFormat:FormatLocalTime("MMM", "en-us")

		ArborData.CurrentTime:SetAttribute("AlternativeTime", (string.sub(ArborData.CurrentTime.Value, 1, 2)..string.sub(ArborData.CurrentTime.Value, 4, 6)))

		for i, period in pairs(Settings["Periods"]) do
			local timeConversion = (string.sub(period["Time"], 1, 2)..string.sub(period["Time"], 4, 6))

			if ArborData.CurrentTime:GetAttribute("AlternativeTime") == timeConversion then
				if ArborData.CurrentTime:GetAttribute("DataHasBeenChanged") == false then
					ArborData.SessionStatus.Value = "Active"
					ArborData.CurrentPeriod.Value = period["Name"]
					ArborData.CurrentPeriod:SetAttribute("AffiliatedNumber", i)
					ArborData.CurrentTime:SetAttribute("DataHasBeenChanged", true)

					Arbor["ArborEvents"].UpdateTimetable:FireAllClients()
					jaWebhook.Send(Settings["ArborWebhookURL"], {
						['content'] = "",
						['embeds'] = {{
							['title'] = "Period Change",
							['color'] = Settings["WebhookColors"]["Grey"],
							['description'] = "**"..period["Name"].."** has started at "..period["Time"].."\nThere are **"..#game:GetService("Players"):GetPlayers().."** players in-game",
							["fields"] = {
								{
									["name"] = "Name",
									["value"] = period["Name"],
									["inline"] = false
								},
								{
									["name"] = "Time",
									["value"] = period["Time"],
									["inline"] = false
								},
								{
									["name"] = "Attendance Logged",
									["value"] = period["AttendanceIsLogged"],
									["inline"] = false
								},
							},
							['type'] = "rich",
							["timestamp"] = DateTime.now():ToIsoDate();
							["footer"] = { 
								["text"] = "Arbor by jaDevelopment";
								["icon_url"] = "https://cdn.discordapp.com/attachments/1003812589794512917/1176563222757785720/jabaNew-WhiteTransparent.png?ex=656f52e3&is=655cdde3&hm=5cbf8ce6cdb0ac919cd0b5e4bb0daadadddf7fdf5354e36256804de3db8e6464&";
							};
						}}}
					)
				else
					--
				end
			else
				if ArborData.CurrentPeriod.Value == period["Name"] then
					ArborData.CurrentTime:SetAttribute("DataHasBeenChanged", false)
				end
			end
		end
	end)

	Arbor:WaitForChild("ArborEvents").KickUser.OnServerEvent:Connect(function(Player, User)
		if Player:GetRankInGroup(Settings["GroupID"]) >= Settings["AdminID"] then
			User:Kick("Arbor by jaDevelopment - You have been kicked by user: "..Player.Name)
			jaWebhook.Send(Settings["ArborWebhookURL"], {
				['content'] = "",
				['embeds'] = {{
					['title'] = "User "..User.Name.." ("..ArborData.PlayerData[User.Name].RoleplayName.Value..") has been kicked",
					['color'] = Settings["WebhookColors"]["Orange"],
					['description'] = "__"..ArborData.PlayerData[User.Name].RoleplayName.Value.."__ has been kicked by: **"..Player.Name.."** ("..ArborData.PlayerData[Player.Name].RoleplayName.Value..")",
					["fields"] = {
						{
							["name"] = "Administrator",
							["value"] = "**Name**: ["..Player.Name.."](https://www.roblox.com/users/"..Player.UserId.."/profile)\n**Roleplay Name**: "..ArborData.PlayerData[Player.Name].RoleplayName.Value.."\n**Rank**: "..Player:GetRoleInGroup(Settings["GroupID"]),
							["inline"] = false
						},
						{
							["name"] = "User",
							["value"] = "**Name**: ["..User.Name.."](https://www.roblox.com/users/"..User.UserId.."/profile)\n**Roleplay Name**: "..ArborData.PlayerData[User.Name].RoleplayName.Value.."\n**Rank**: "..User:GetRoleInGroup(Settings["GroupID"]),
							["inline"] = false
						},
					},
					['type'] = "rich",
					["author"] = {
						["name"] = ArborData.PlayerData[Player.Name].RoleplayName.Value; 
						["url"] = "https://www.roblox.com/users/"..Player.UserId.."/profile"; 
						["icon_url"] = "https://media.discordapp.net/attachments/991746830935269406/1176587998322770040/User-Icon-Grey-300x300.png?ex=656f69f6&is=655cf4f6&hm=3b86c5d563ea658a5e11f41c59eff22d6aeadcd7e132a069b0ed94ae1ee3cd17&=" 
					};
					["timestamp"] = DateTime.now():ToIsoDate();
					["footer"] = { 
						["text"] = "Arbor by jaDevelopment";
						["icon_url"] = "https://cdn.discordapp.com/attachments/1003812589794512917/1176563222757785720/jabaNew-WhiteTransparent.png?ex=656f52e3&is=655cdde3&hm=5cbf8ce6cdb0ac919cd0b5e4bb0daadadddf7fdf5354e36256804de3db8e6464&";
					};
				}}}
			)
		end
	end)

	Arbor:WaitForChild("ArborEvents").DisableAccount.OnServerEvent:Connect(function(Player, User)
		if Player:GetRankInGroup(Settings["GroupID"]) >= Settings["AdminID"] then
			ArborData["PlayerData"][User.Name].AccountEnabled.Value = false
			Arbor:WaitForChild("ArborEvents").DisableAccount:FireClient(User, Player)

			jaWebhook.Send(Settings["ArborWebhookURL"], {
				['content'] = "",
				['embeds'] = {{
					['title'] = "Account for: "..User.Name.." ("..ArborData.PlayerData[User.Name].RoleplayName.Value..") has been disabled",
					['color'] = Settings["WebhookColors"]["Red"],
					['description'] = "Account for: __"..ArborData.PlayerData[User.Name].RoleplayName.Value.."__ has been disabled by: **"..Player.Name.."** ("..ArborData.PlayerData[Player.Name].RoleplayName.Value..")",
					["fields"] = {
						{
							["name"] = "Administrator",
							["value"] = "**Name**: ["..Player.Name.."](https://www.roblox.com/users/"..Player.UserId.."/profile)\n**Roleplay Name**: "..ArborData.PlayerData[Player.Name].RoleplayName.Value.."\n**Rank**: "..Player:GetRoleInGroup(Settings["GroupID"]),
							["inline"] = false
						},
						{
							["name"] = "User",
							["value"] = "**Name**: ["..User.Name.."](https://www.roblox.com/users/"..User.UserId.."/profile)\n**Roleplay Name**: "..ArborData.PlayerData[User.Name].RoleplayName.Value.."\n**Rank**: "..User:GetRoleInGroup(Settings["GroupID"]),
							["inline"] = false
						},
					},
					['type'] = "rich",
					["author"] = {
						["name"] = ArborData.PlayerData[Player.Name].RoleplayName.Value; 
						["url"] = "https://www.roblox.com/users/"..Player.UserId.."/profile"; 
						["icon_url"] = "https://media.discordapp.net/attachments/991746830935269406/1176587998322770040/User-Icon-Grey-300x300.png?ex=656f69f6&is=655cf4f6&hm=3b86c5d563ea658a5e11f41c59eff22d6aeadcd7e132a069b0ed94ae1ee3cd17&=" 
					};
					["timestamp"] = DateTime.now():ToIsoDate();
					["footer"] = { 
						["text"] = "Arbor by jaDevelopment";
						["icon_url"] = "https://cdn.discordapp.com/attachments/1003812589794512917/1176563222757785720/jabaNew-WhiteTransparent.png?ex=656f52e3&is=655cdde3&hm=5cbf8ce6cdb0ac919cd0b5e4bb0daadadddf7fdf5354e36256804de3db8e6464&";
					};
				}}}
			)
		end
	end)

	Arbor:WaitForChild("ArborEvents").EnableAccount.OnServerEvent:Connect(function(Player, User)
		if Player:GetRankInGroup(Settings["GroupID"]) >= Settings["AdminID"] then
			Arbor:WaitForChild("ArborEvents").EnableAccount:FireClient(User, Player)
			ArborData["PlayerData"][User.Name].AccountEnabled.Value = true
		end
	end)

	Arbor:WaitForChild("ArborEvents").ChangeName.OnServerEvent:Connect(function(Player, User, NewName)
		if Player:GetRankInGroup(Settings["GroupID"]) >= Settings["StaffID"] then
			User.Character.Head.ArborNameTag.RoleplayName.Text = SendRequest(Player, NewName)

			if Player:GetRankInGroup(Settings["GroupID"]) >= Settings["StaffID"] then
				User.Character.ArborLanyard.Card.Arbor.Interface.RoleplayName.Text = SendRequest(Player, NewName)
			end

			jaWebhook.Send(Settings["ArborWebhookURL"], {
				['content'] = "",
				['embeds'] = {{
					['title'] = "Name Change",
					['color'] = Settings["WebhookColors"]["Grey"],
					['description'] = "Name for: __"..ArborData.PlayerData[User.Name].RoleplayName.Value.."__ has been changed by: **"..Player.Name.."** ("..ArborData.PlayerData[Player.Name].RoleplayName.Value..")",
					["fields"] = {
						{
							["name"] = "Administrator",
							["value"] = "**Name**: ["..Player.Name.."](https://www.roblox.com/users/"..Player.UserId.."/profile)\n**Roleplay Name**: "..ArborData.PlayerData[Player.Name].RoleplayName.Value.."\n**Rank**: "..Player:GetRoleInGroup(Settings["GroupID"]),
							["inline"] = false
						},
						{
							["name"] = "Previous Name",
							["value"] = ArborData["PlayerData"][User.Name].RoleplayName.Value,
							["inline"] = false
						},
						{
							["name"] = "New Name",
							["value"] = NewName,
							["inline"] = false
						},
					},
					['type'] = "rich",
					["author"] = {
						["name"] = ArborData.PlayerData[Player.Name].RoleplayName.Value; 
						["url"] = "https://www.roblox.com/users/"..Player.UserId.."/profile"; 
						["icon_url"] = "https://media.discordapp.net/attachments/991746830935269406/1176587998322770040/User-Icon-Grey-300x300.png?ex=656f69f6&is=655cf4f6&hm=3b86c5d563ea658a5e11f41c59eff22d6aeadcd7e132a069b0ed94ae1ee3cd17&=" 
					};
					["timestamp"] = DateTime.now():ToIsoDate();
					["footer"] = { 
						["text"] = "Arbor by jaDevelopment";
						["icon_url"] = "https://cdn.discordapp.com/attachments/1003812589794512917/1176563222757785720/jabaNew-WhiteTransparent.png?ex=656f52e3&is=655cdde3&hm=5cbf8ce6cdb0ac919cd0b5e4bb0daadadddf7fdf5354e36256804de3db8e6464&";
					};
				}}}
			)
			
			ArborData["PlayerData"][User.Name].RoleplayName.Value = SendRequest(Player, NewName)
		end
	end)

	Arbor:WaitForChild("ArborEvents").SaveRegister.OnServerEvent:Connect(function(Player, Lesson, Year, List)
		if Player:GetRankInGroup(Settings["GroupID"]) >= Settings["StaffID"] then
			for _, student in List do
				if ArborData["AttendanceData"][student["Username"]] then
					ArborData["AttendanceData"][student["Username"]][Lesson].Value = student["Status"]
					if student["Status"] == "Present" then
						ArborData["PlayerData"][student["Username"]].LessonsAttended.Value += 1
					end
				end
			end
		end

		jaWebhook.Send(Settings["ArborWebhookURL"], {
			['content'] = "",
			['embeds'] = {{
				['title'] = "Register Saved",
				['color'] = Settings["WebhookColors"]["Grey"],
				['description'] = "Register for: __"..Year.."__ has been submitted by: **"..Player.Name.."** ("..ArborData.PlayerData[Player.Name].RoleplayName.Value..")",
				["fields"] = {
					{
						["name"] = "Submitted By",
						["value"] = "**Name**: ["..Player.Name.."](https://www.roblox.com/users/"..Player.UserId.."/profile)\n**Roleplay Name**: "..ArborData.PlayerData[Player.Name].RoleplayName.Value.."\n**Rank**: "..Player:GetRoleInGroup(Settings["GroupID"]),
						["inline"] = false
					},
					{
						["name"] = "Student List",
						["value"] = game:GetService("HttpService"):JSONEncode(List),
						["inline"] = false
					},
				},
				['type'] = "rich",
				["author"] = {
					["name"] = ArborData.PlayerData[Player.Name].RoleplayName.Value; 
					["url"] = "https://www.roblox.com/users/"..Player.UserId.."/profile"; 
					["icon_url"] = "https://media.discordapp.net/attachments/991746830935269406/1176587998322770040/User-Icon-Grey-300x300.png?ex=656f69f6&is=655cf4f6&hm=3b86c5d563ea658a5e11f41c59eff22d6aeadcd7e132a069b0ed94ae1ee3cd17&=" 
				};
				["timestamp"] = DateTime.now():ToIsoDate();
				["footer"] = { 
					["text"] = "Arbor by jaDevelopment";
					["icon_url"] = "https://cdn.discordapp.com/attachments/1003812589794512917/1176563222757785720/jabaNew-WhiteTransparent.png?ex=656f52e3&is=655cdde3&hm=5cbf8ce6cdb0ac919cd0b5e4bb0daadadddf7fdf5354e36256804de3db8e6464&";
				};
			}}}
		)
	end)

	Arbor:WaitForChild("ArborEvents").RecordAttendance.OnServerEvent:Connect(function(Staff, Student, Period, ChangeTo)
		if Staff:GetRankInGroup(Settings["GroupID"]) >= Settings["StaffID"] then
			if ChangeTo == "Absent" then
				ArborData["AttendanceData"][Student][Period].Value = "Absent"
			else
				ArborData["AttendanceData"][Student][Period].Value = "Present"
			end
		end
	end)

	Arbor:WaitForChild("ArborEvents").LogDetention.OnServerEvent:Connect(function(Player, Student, DetentionData)
		local NewDetention = Instance.new("Folder", ArborData["Detentions"])
		NewDetention.Name = Student.Name

		for i, Data in pairs(DetentionData) do
			local NewValue = Instance.new("StringValue", NewDetention)
			NewValue.Name = i
			NewValue.Value = Data
		end

		jaWebhook.Send(Settings["ArborWebhookURL"], {
			['content'] = "",
			['embeds'] = {{
				['title'] = "Detention Logged",
				['color'] = Settings["WebhookColors"]["Red"],
				['description'] = "A detention has been issued to: __"..ArborData.PlayerData[Student.Name].RoleplayName.Value.."__ by: **"..Player.Name.."** ("..ArborData.PlayerData[Player.Name].RoleplayName.Value..")",
				["fields"] = {
					{
						["name"] = "Staff",
						["value"] = "**Name**: ["..Player.Name.."](https://www.roblox.com/users/"..Player.UserId.."/profile)\n**Roleplay Name**: "..ArborData.PlayerData[Player.Name].RoleplayName.Value.."\n**Rank**: "..Player:GetRoleInGroup(Settings["GroupID"]),
						["inline"] = false
					},
					{
						["name"] = "Student",
						["value"] = "**Name**: ["..Student.Name.."](https://www.roblox.com/users/"..Student.UserId.."/profile)\n**Roleplay Name**: "..ArborData.PlayerData[Student.Name].RoleplayName.Value.."\n**Rank**: "..Student:GetRoleInGroup(Settings["GroupID"]),
						["inline"] = false
					},
					{
						["name"] = "Detention Info",
						["value"] = "Student Username: **"..DetentionData["StudentUsername"].."**\nReason: **"..DetentionData["ReasonForDetention"].."**\nLocation: **"..DetentionData["Location"].."**\nIssued By: **"..DetentionData["IssuedBy"].."**\nType: **"..DetentionData["Type"].."**\nNote: **"..DetentionData["Note"].."**\n",
						["inline"] = false
					}
				},
				['type'] = "rich",
				["author"] = {
					["name"] = ArborData.PlayerData[Player.Name].RoleplayName.Value; 
					["url"] = "https://www.roblox.com/users/"..Player.UserId.."/profile"; 
					["icon_url"] = "https://media.discordapp.net/attachments/991746830935269406/1176587998322770040/User-Icon-Grey-300x300.png?ex=656f69f6&is=655cf4f6&hm=3b86c5d563ea658a5e11f41c59eff22d6aeadcd7e132a069b0ed94ae1ee3cd17&=" 
				};
				["timestamp"] = DateTime.now():ToIsoDate();
				["footer"] = { 
					["text"] = "Arbor by jaDevelopment";
					["icon_url"] = "https://cdn.discordapp.com/attachments/1003812589794512917/1176563222757785720/jabaNew-WhiteTransparent.png?ex=656f52e3&is=655cdde3&hm=5cbf8ce6cdb0ac919cd0b5e4bb0daadadddf7fdf5354e36256804de3db8e6464&";
				};
			}}}
		)

		Arbor:WaitForChild("ArborEvents").LogDetention:FireClient(game.Players[Student.Name], Player, DetentionData)
	end)

	Arbor:WaitForChild("ArborEvents").LogIncident.OnServerEvent:Connect(function(Player, Student, IncidentData)
		local NewIncident = Instance.new("Folder", ArborData["SessionIncidents"])
		NewIncident.Name = Student.Name

		for i, Data in pairs(IncidentData) do
			local NewValue = Instance.new("StringValue", NewIncident)
			NewValue.Name = i
			NewValue.Value = Data
		end

		jaWebhook.Send(Settings["ArborWebhookURL"], {
			['content'] = "",
			['embeds'] = {{
				['title'] = "Incident Logged",
				['color'] = Settings["WebhookColors"]["Red"],
				['description'] = "A behavioural incident has been logged by: **"..Player.Name.."** ("..ArborData.PlayerData[Player.Name].RoleplayName.Value..")",
				["fields"] = {
					{
						["name"] = "Staff",
						["value"] = "**Name**: ["..Player.Name.."](https://www.roblox.com/users/"..Player.UserId.."/profile)\n**Roleplay Name**: "..ArborData.PlayerData[Player.Name].RoleplayName.Value.."\n**Rank**: "..Player:GetRoleInGroup(Settings["GroupID"]),
						["inline"] = false
					},
					{
						["name"] = "Primary Student Involved",
						["value"] = "**Name**: ["..Student.Name.."](https://www.roblox.com/users/"..Student.UserId.."/profile)\n**Roleplay Name**: "..ArborData.PlayerData[Student.Name].RoleplayName.Value.."\n**Rank**: "..Student:GetRoleInGroup(Settings["GroupID"]),
						["inline"] = false
					},
					{
						["name"] = "Behaviour Type",
						["value"] = IncidentData["BehaviourType"],
						["inline"] = true
					},
					{
						["name"] = "Date & Time",
						["value"] = IncidentData["DateOfIncident"].." - "..IncidentData["TimeOfIncident"],
						["inline"] = true
					},
					{
						["name"] = "Incident Summary",
						["value"] = IncidentData["IncidentSummary"],
						["inline"] = true
					},
					{
						["name"] = "Lesson",
						["value"] = IncidentData["Lesson"],
						["inline"] = true
					},
					{
						["name"] = "Location",
						["value"] = IncidentData["Location"],
						["inline"] = true
					},
					{
						["name"] = "Incident Severity",
						["value"] = IncidentData["IncidentSeverity"],
						["inline"] = true
					},
					{
						["name"] = "Staff Involved",
						["value"] = IncidentData["StaffInvolved"],
						["inline"] = true
					},
					{
						["name"] = "Students Involved",
						["value"] = "__"..IncidentData["OtherStudents"].."__",
						["inline"] = true
					},
				},
				['type'] = "rich",
				["author"] = {
					["name"] = ArborData.PlayerData[Player.Name].RoleplayName.Value; 
					["url"] = "https://www.roblox.com/users/"..Player.UserId.."/profile"; 
					["icon_url"] = "https://media.discordapp.net/attachments/991746830935269406/1176587998322770040/User-Icon-Grey-300x300.png?ex=656f69f6&is=655cf4f6&hm=3b86c5d563ea658a5e11f41c59eff22d6aeadcd7e132a069b0ed94ae1ee3cd17&=" 
				};
				["timestamp"] = DateTime.now():ToIsoDate();
				["footer"] = { 
					["text"] = "Arbor by jaDevelopment";
					["icon_url"] = "https://cdn.discordapp.com/attachments/1003812589794512917/1176563222757785720/jabaNew-WhiteTransparent.png?ex=656f52e3&is=655cdde3&hm=5cbf8ce6cdb0ac919cd0b5e4bb0daadadddf7fdf5354e36256804de3db8e6464&";
				};
			}}}
		)

		Arbor:WaitForChild("ArborEvents").LogIncident:FireClient(game.Players[Student.Name], Player, IncidentData)
	end)

	Arbor:WaitForChild("ArborEvents").LogMerit.OnServerEvent:Connect(function(Player, Student, MeritData)
		local NewMerit = Instance.new("Folder", ArborData["SessionMerits"])
		NewMerit.Name = Student.Name

		for i, Data in pairs(MeritData) do
			local NewValue = Instance.new("StringValue", NewMerit)
			NewValue.Name = i
			NewValue.Value = Data
		end

		jaWebhook.Send(Settings["ArborWebhookURL"], {
			['content'] = "",
			['embeds'] = {{
				['title'] = "Merit Logged",
				['color'] = Settings["WebhookColors"]["Green"],
				['description'] = "A merit has been logged by: **"..Player.Name.."** ("..ArborData.PlayerData[Player.Name].RoleplayName.Value..")",
				["fields"] = {
					{
						["name"] = "Staff",
						["value"] = "**Name**: ["..Player.Name.."](https://www.roblox.com/users/"..Player.UserId.."/profile)\n**Roleplay Name**: "..ArborData.PlayerData[Player.Name].RoleplayName.Value.."\n**Rank**: "..Player:GetRoleInGroup(Settings["GroupID"]),
						["inline"] = false
					},
					{
						["name"] = "Student",
						["value"] = "**Name**: ["..Student.Name.."](https://www.roblox.com/users/"..Student.UserId.."/profile)\n**Roleplay Name**: "..ArborData.PlayerData[Student.Name].RoleplayName.Value.."\n**Rank**: "..Student:GetRoleInGroup(Settings["GroupID"]),
						["inline"] = false
					},
					{
						["name"] = "Merit Information",
						["value"] = "Given At: **"..MeritData["GivenAt"].."**\nGiven By: **"..MeritData["GivenBy"].."**\nLocation: **"..MeritData["Location"].."**\nReason/attribute: **"..MeritData["ReasonAttribute"].."**\nTotal Awarded: **__"..MeritData["TotalAwarded"].."__**\n",
						["inline"] = false
					},
				},
				['type'] = "rich",
				["author"] = {
					["name"] = ArborData.PlayerData[Player.Name].RoleplayName.Value; 
					["url"] = "https://www.roblox.com/users/"..Player.UserId.."/profile"; 
					["icon_url"] = "https://media.discordapp.net/attachments/991746830935269406/1176587998322770040/User-Icon-Grey-300x300.png?ex=656f69f6&is=655cf4f6&hm=3b86c5d563ea658a5e11f41c59eff22d6aeadcd7e132a069b0ed94ae1ee3cd17&=" 
				};
				["timestamp"] = DateTime.now():ToIsoDate();
				["footer"] = { 
					["text"] = "Arbor by jaDevelopment";
					["icon_url"] = "https://cdn.discordapp.com/attachments/1003812589794512917/1176563222757785720/jabaNew-WhiteTransparent.png?ex=656f52e3&is=655cdde3&hm=5cbf8ce6cdb0ac919cd0b5e4bb0daadadddf7fdf5354e36256804de3db8e6464&";
				};
			}}}
		)

		ArborData["PlayerData"][Student.Name].MeritsTotal.Value += tonumber(MeritData["TotalAwarded"])
		ArborData["PlayerData"][Student.Name].MeritsToday.Value += tonumber(MeritData["TotalAwarded"])
		Arbor:WaitForChild("ArborEvents").LogMerit:FireClient(game.Players[Student.Name], Player, MeritData)
	end)

	Arbor:WaitForChild("ArborEvents").DeleteIsolation.OnServerEvent:Connect(function(Player, Staff, Student, Respawn)
		if Student then
			if Settings["IsolationTeam"] then
				local StudentData = ArborData["PlayerData"][Student.Name]
				game.Players[Student.Name].Team = game:GetService("Teams")[StudentData.OriginalYearGroup.Value]

				if Respawn then
					if Student.Character then
						if Student.Character:FindFirstChild("Humanoid") then
							Student.Character.Humanoid.Health = 0
						end
					end
				else
					if Settings["DisableJumpPower"] == true then
						game.Players[Student.Name].Character.Humanoid.JumpPower = 50
					end
				end

			end
		end

		ArborData.SessionIsolations[Student.Name]:Destroy()
	end)

	Arbor:WaitForChild("ArborEvents").LogIsolation.OnServerEvent:Connect(function(Player, Student, IsolationData)
		local NewIsolation = Instance.new("Folder", ArborData["SessionIsolations"])
		NewIsolation.Name = Student.Name

		for i, Data in pairs(IsolationData) do
			local NewValue = Instance.new("StringValue", NewIsolation)
			NewValue.Name = i
			NewValue.Value = Data
		end

		local StudentTest = Instance.new("ObjectValue", NewIsolation)
		StudentTest.Value = Student
		StudentTest.Name = "StudentObj"

		if Settings["IsolationTeam"] then
			game.Players[Student.Name].Team = Settings["IsolationTeam"]

			if Settings["DisableJumpPower"] == true then
				game.Players[Student.Name].Character.Humanoid.JumpPower = 0
			else
				game.Players[Student.Name].Character.Humanoid.JumpPower = 50
			end

			if Settings["TeleportPlayer"] == true then
				local IsolationSpawns = script.Location.Value:FindFirstChild("IsolationSpawns"):GetChildren()
				local RandomSpawn = IsolationSpawns[math.random(1, #IsolationSpawns)]

				game.Players[Student.Name].Character.HumanoidRootPart.CFrame = RandomSpawn.CFrame + Vector3.new(0, 5, 0)
			end
		end

		jaWebhook.Send(Settings["ArborWebhookURL"], {
			['content'] = "",
			['embeds'] = {{
				['title'] = "Isolation Logged",
				['color'] = Settings["WebhookColors"]["Orange"],
				['description'] = "An isolation has been logged by: **"..Player.Name.."** ("..ArborData.PlayerData[Player.Name].RoleplayName.Value..")",
				["fields"] = {
					{
						["name"] = "Staff",
						["value"] = "**Name**: ["..Player.Name.."](https://www.roblox.com/users/"..Player.UserId.."/profile)\n**Roleplay Name**: "..ArborData.PlayerData[Player.Name].RoleplayName.Value.."\n**Rank**: "..Player:GetRoleInGroup(Settings["GroupID"]),
						["inline"] = false
					},
					{
						["name"] = "Student",
						["value"] = "**Name**: ["..Student.Name.."](https://www.roblox.com/users/"..Student.UserId.."/profile)\n**Roleplay Name**: "..ArborData.PlayerData[Student.Name].RoleplayName.Value.."\n**Rank**: "..Student:GetRoleInGroup(Settings["GroupID"]),
						["inline"] = false
					},
					{
						["name"] = "Isolation Information",
						["value"] = "Date/time: **"..IsolationData["TimeOfIncident"]..", "..IsolationData["DateOfIncident"].."**\nSeverity: **"..IsolationData["Behaviour"].."**\nReason: **"..IsolationData["IsolationReason"].."**\nIssued by: **"..IsolationData["Staff"].."**\n",
						["inline"] = false
					},
				},
				['type'] = "rich",
				["author"] = {
					["name"] = ArborData.PlayerData[Player.Name].RoleplayName.Value; 
					["url"] = "https://www.roblox.com/users/"..Player.UserId.."/profile"; 
					["icon_url"] = "https://media.discordapp.net/attachments/991746830935269406/1176587998322770040/User-Icon-Grey-300x300.png?ex=656f69f6&is=655cf4f6&hm=3b86c5d563ea658a5e11f41c59eff22d6aeadcd7e132a069b0ed94ae1ee3cd17&=" 
				};
				["timestamp"] = DateTime.now():ToIsoDate();
				["footer"] = { 
					["text"] = "Arbor by jaDevelopment";
					["icon_url"] = "https://cdn.discordapp.com/attachments/1003812589794512917/1176563222757785720/jabaNew-WhiteTransparent.png?ex=656f52e3&is=655cdde3&hm=5cbf8ce6cdb0ac919cd0b5e4bb0daadadddf7fdf5354e36256804de3db8e6464&";
				};
			}}}
		)

		ArborData["PlayerData"][Student.Name].IsolationsTotal.Value += 1
		ArborData["PlayerData"][Student.Name].IsolationsToday.Value += 1
		Arbor:WaitForChild("ArborEvents").LogIsolation:FireClient(game.Players[Student.Name], Player, IsolationData)
	end)

	Arbor:WaitForChild("ArborEvents").LogTimeout.OnServerEvent:Connect(function(Player, Student, TimeoutData)
		local NewTimeout = Instance.new("Folder", ArborData["SessionTimeout"])
		NewTimeout.Name = Student.Name

		for i, Data in pairs(TimeoutData) do
			local NewValue = Instance.new("StringValue", NewTimeout)
			NewValue.Name = i
			NewValue.Value = Data
		end

		local StudentTest = Instance.new("ObjectValue", NewTimeout)
		StudentTest.Value = Student
		StudentTest.Name = "StudentObj"

		jaWebhook.Send(Settings["ArborWebhookURL"], {
			['content'] = "",
			['embeds'] = {{
				['title'] = "Timeout Logged",
				['color'] = Settings["WebhookColors"]["Orange"],
				['description'] = "A Timeout has been logged by: **"..Player.Name.."** ("..ArborData.PlayerData[Player.Name].RoleplayName.Value..")",
				["fields"] = {
					{
						["name"] = "Staff",
						["value"] = "**Name**: ["..Player.Name.."](https://www.roblox.com/users/"..Player.UserId.."/profile)\n**Roleplay Name**: "..ArborData.PlayerData[Player.Name].RoleplayName.Value.."\n**Rank**: "..Player:GetRoleInGroup(Settings["GroupID"]),
						["inline"] = false
					},
					{
						["name"] = "Student",
						["value"] = "**Name**: ["..Student.Name.."](https://www.roblox.com/users/"..Student.UserId.."/profile)\n**Roleplay Name**: "..ArborData.PlayerData[Student.Name].RoleplayName.Value.."\n**Rank**: "..Student:GetRoleInGroup(Settings["GroupID"]),
						["inline"] = false
					},
					{
						["name"] = "Timeout Information",
						["value"] = "Date/time: **"..TimeoutData["TimeOfIncident"]..", "..TimeoutData["DateOfIncident"].."**\nSeverity: **"..TimeoutData["Behaviour"].."**\nReason: **"..TimeoutData["IsolationReason"].."**\nIssued by: **"..TimeoutData["Staff"].."**\n",
						["inline"] = false
					},
				},
				['type'] = "rich",
				["author"] = {
					["name"] = ArborData.PlayerData[Player.Name].RoleplayName.Value; 
					["url"] = "https://www.roblox.com/users/"..Player.UserId.."/profile"; 
					["icon_url"] = "https://media.discordapp.net/attachments/991746830935269406/1176587998322770040/User-Icon-Grey-300x300.png?ex=656f69f6&is=655cf4f6&hm=3b86c5d563ea658a5e11f41c59eff22d6aeadcd7e132a069b0ed94ae1ee3cd17&=" 
				};
				["timestamp"] = DateTime.now():ToIsoDate();
				["footer"] = { 
					["text"] = "Arbor by jaDevelopment";
					["icon_url"] = "https://cdn.discordapp.com/attachments/1003812589794512917/1176563222757785720/jabaNew-WhiteTransparent.png?ex=656f52e3&is=655cdde3&hm=5cbf8ce6cdb0ac919cd0b5e4bb0daadadddf7fdf5354e36256804de3db8e6464&";
				};
			}}}
		)
		Arbor:WaitForChild("ArborEvents").LogTimeout:FireClient(game.Players[Student.Name], Player, TimeoutData)
		game.Workspace[Student.Name].Head.ArborNameTag.Extra.TimeoutPass.Visible = true

	end)
	Arbor:WaitForChild("ArborEvents").LogBehaviourPoint.OnServerEvent:Connect(function(Player, Student, BehaviourPointData)
		local NewBehaviourPoint = Instance.new("Folder", ArborData["SessionBehaviourPoints"])
		NewBehaviourPoint.Name = Student.Name

		for i, Data in pairs(BehaviourPointData) do
			local NewValue = Instance.new("StringValue", NewBehaviourPoint)
			NewValue.Name = i
			NewValue.Value = Data
		end

		jaWebhook.Send(Settings["ArborWebhookURL"], {
			['content'] = "",
			['embeds'] = {{
				['title'] = "Behaviour Point Logged",
				['color'] = Settings["WebhookColors"]["Red"],
				['description'] = "A behaviour point has been logged by: **"..Player.Name.."** ("..ArborData.PlayerData[Player.Name].RoleplayName.Value..")",
				["fields"] = {
					{
						["name"] = "Staff",
						["value"] = "**Name**: ["..Player.Name.."](https://www.roblox.com/users/"..Player.UserId.."/profile)\n**Roleplay Name**: "..ArborData.PlayerData[Player.Name].RoleplayName.Value.."\n**Rank**: "..Player:GetRoleInGroup(Settings["GroupID"]),
						["inline"] = false
					},
					{
						["name"] = "Student",
						["value"] = "**Name**: ["..Student.Name.."](https://www.roblox.com/users/"..Student.UserId.."/profile)\n**Roleplay Name**: "..ArborData.PlayerData[Student.Name].RoleplayName.Value.."\n**Rank**: "..Student:GetRoleInGroup(Settings["GroupID"]),
						["inline"] = false
					},
					{
						["name"] = "Behaviour Point Information",
						["value"] = "Given At: **"..BehaviourPointData["GivenAt"].."**\nGiven By: **"..BehaviourPointData["GivenBy"].."**\nLocation: **"..BehaviourPointData["Location"].."**\nReason/attribute: **"..BehaviourPointData["ReasonAttribute"].."**\nTotal Awarded: **__"..BehaviourPointData["TotalAwarded"].."__**\n",
						["inline"] = false
					},
				},
				['type'] = "rich",
				["author"] = {
					["name"] = ArborData.PlayerData[Player.Name].RoleplayName.Value; 
					["url"] = "https://www.roblox.com/users/"..Player.UserId.."/profile"; 
					["icon_url"] = "https://media.discordapp.net/attachments/991746830935269406/1176587998322770040/User-Icon-Grey-300x300.png?ex=656f69f6&is=655cf4f6&hm=3b86c5d563ea658a5e11f41c59eff22d6aeadcd7e132a069b0ed94ae1ee3cd17&=" 
				};
				["timestamp"] = DateTime.now():ToIsoDate();
				["footer"] = { 
					["text"] = "Arbor by jaDevelopment";
					["icon_url"] = "https://cdn.discordapp.com/attachments/1003812589794512917/1176563222757785720/jabaNew-WhiteTransparent.png?ex=656f52e3&is=655cdde3&hm=5cbf8ce6cdb0ac919cd0b5e4bb0daadadddf7fdf5354e36256804de3db8e6464&";
				};
			}}}
		)

		ArborData["PlayerData"][Student.Name].BehaviourPointsTotal.Value += tonumber(BehaviourPointData["TotalAwarded"])
		ArborData["PlayerData"][Student.Name].BehaviourPointsToday.Value += tonumber(BehaviourPointData["TotalAwarded"])
		Arbor:WaitForChild("ArborEvents").LogBehaviourPoint:FireClient(game.Players[Student.Name], Player, BehaviourPointData)
	end)

	Arbor:WaitForChild("ArborEvents").ResolveDeleteIncident.OnServerEvent:Connect(function(Player, IncidentStatus, Incident)
		if IncidentStatus == "Resolve" then
			Arbor:WaitForChild("ArborEvents").ResolveDeleteIncident:FireClient(Players[Incident.StudentUsername.Value], IncidentStatus, Incident)
			Incident:Destroy()
		elseif IncidentStatus == "Delete" then
			Arbor:WaitForChild("ArborEvents").ResolveDeleteIncident:FireClient(Players[Incident.StudentUsername.Value], IncidentStatus, Incident)
			Incident:Destroy()
		end
	end)

	Arbor:WaitForChild("ArborEvents").CreateCalendarEvent.OnServerEvent:Connect(function(Player, EventData)
		if EventData["Participants"] == "All Students" then
			Arbor:WaitForChild("ArborEvents").CreateCalendarEvent:FireAllClients(Player, EventData)
		elseif EventData["Participants"] == "Staff" then
			Arbor:WaitForChild("ArborEvents").CreateCalendarEvent:FireAllClients(Player, EventData)
		else
			if game:GetService("Teams"):FindFirstChild(EventData["Participants"]) and table.find(Settings["Teams"], EventData["Participants"]) then
				Arbor:WaitForChild("ArborEvents").CreateCalendarEvent:FireAllClients(Player, EventData)
			end
		end
	end)


	local ArborAlerts = ArborModule:GetAlerts(ArborVersion)
	
	Arbor:WaitForChild("ArborEvents").GetAlerts.OnServerInvoke = function(Player)
		return ArborAlerts
	end

	--[ Create Profile ]

	local ConfirmProfilePrompt = Arbor["ArborEvents"].ConfirmProfilePrompt

	ConfirmProfilePrompt.OnServerInvoke = function(Player, Data)
		local success, error = pcall(function()
			Data["NameInput"] = SendRequest(Player, Data["NameInput"])
			Data["GenderInput"] = SendRequest(Player, Data["GenderInput"])
		end)

		if success then
			if string.find(Data["NameInput"], "#") or string.find(Data["GenderInput"], "#") then
				return false
			else
				local FilteredName = SendRequest(Player, Data["NameInput"])
				local FilteredGender = SendRequest(Player, Data["GenderInput"])

				local PlayerFolder = Arbor["ArborData"].PlayerData[Player.Name]
				PlayerFolder.RoleplayName.Value = FilteredName
				PlayerFolder.Gender.Value = FilteredGender
				PlayerFolder.ProfileCreated.Value = true

				Player.Character.Head:WaitForChild("ArborNameTag").RoleplayName.Text = FilteredName

				if Player:GetRankInGroup(Settings["GroupID"]) >= Settings["StaffID"] then
					Player.Character.ArborLanyard.Card.Arbor.Interface.RoleplayName.Text = FilteredName
				end

				return true
			end
		else
			return false
		end
	end

	--[ School Notices ]

	local Notices = {}

	local Success, Data = pcall(function()
		for Name, Notice in pairs(ArborSettingsData:GetAsync("Notices")) do
			for _, Item in pairs(Notice) do
				if not ArborData.Notices:FindFirstChild(Name) then
					local ExampleClone = ArborData.ExampleNotice:Clone()
					local RandomString = Item["RandomString"]
					ExampleClone.Name = Item["RandomString"]
					ExampleClone.Parent = ArborData.Notices
					ExampleClone.NoticeDescription.Value = Item["NoticeDescription"]
					ExampleClone.NoticeTitle.Value = Item["NoticeTitle"]
					ExampleClone.SelectedGroup.Value = Item["SelectedGroup"]
					ExampleClone.EndAtDate.Value = Item["EndAtDate"]
					ExampleClone.StartFromDate.Value = Item["StartFromDate"]

					table.insert(Notices, {
						[RandomString] = {
							["EndAtDate"] = Item["EndAtDate"],
							["StartFromDate"] = Item["StartFromDate"],
							["RandomString"] = RandomString,
							["NoticeDescription"] = Item["NoticeDescription"],
							["NoticeTitle"] = Item["NoticeTitle"],
							["SelectedGroup"] = Item["SelectedGroup"]
						},
					})
				end
			end
		end
	end)

	local function CreateNotice(EventData, Player)
		local ExampleClone = ArborData.ExampleNotice:Clone()
		local RandomString = EventData["Group"].."-"..tostring(math.random(1000, 9999))
		ExampleClone.Name = RandomString
		ExampleClone.Parent = ArborData.Notices
		ExampleClone.NoticeDescription.Value = EventData.Note
		ExampleClone.NoticeTitle.Value = EventData.NoticeTitle
		ExampleClone.SelectedGroup.Value = EventData.Group
		ExampleClone.EndAtDate.Value = EventData.EndAtDate
		ExampleClone.StartFromDate.Value = EventData.StartFromDate

		table.insert(Notices, {
			[RandomString] = {
				["EndAtDate"] = EventData.EndAtDate,
				["StartFromDate"] = EventData.StartFromDate,
				["RandomString"] = RandomString,
				["NoticeDescription"] = EventData.Note,
				["NoticeTitle"] = EventData.NoticeTitle,
				["SelectedGroup"] = EventData.Group
			},
		})

		ArborSettingsData:SetAsync("Notices", Notices)
	end

	Arbor:WaitForChild("ArborEvents").CreateSchoolNotice.OnServerEvent:Connect(function(Player, EventData)
		if EventData["Group"] == "All Students" then
			CreateNotice(EventData, Player)
		elseif EventData["Group"] == "Staff" then
			CreateNotice(EventData, Player)
		elseif game:GetService("Teams"):FindFirstChild(EventData["Group"]) and table.find(Settings["Teams"], EventData["Group"]) then
			CreateNotice(EventData, Player)
		end
	end)

	--[]

	Arbor:WaitForChild("ArborEvents").LogStaffAttendance.OnServerEvent:Connect(function(Player, StaffMember, Status)
		if Player:GetRankInGroup(Settings["GroupID"]) >= Settings["AdminID"] then
			game:GetService("ReplicatedStorage").Arbor.ArborData["PlayerData"][Player.Name].AttendanceStatus.Value = Status
		end
	end)

	function ReplicatedStorage.Arbor.ArborEvents.GetPlayers.OnServerInvoke()
		local HttpService = game:GetService("HttpService")
		local ReceiveData = HttpService:GetAsync('https://groups.roproxy.com/v1/groups/'..Settings["GroupID"])

		return (HttpService:JSONDecode(ReceiveData).memberCount)
	end

	while wait() do task.wait(3)
		local NoticesData = ArborData:FindFirstChild("Notices")

		for _, Notice in pairs(NoticesData:GetChildren()) do
			local StartFromDate = Notice["StartFromDate"].Value
			local EndAtDate = Notice["EndAtDate"].Value

			if StartFromDate == DateTimeFormat:FormatLocalTime("D", "en-us").." "..DateTimeFormat:FormatLocalTime("MMM", "en-us") then
				if Notice.InAction.Value == false then
					Arbor["ArborEvents"].CreateSchoolNotice:FireAllClients({
						["NoticeTitle"] = Notice["NoticeTitle"].Value,
						["Note"] = Notice["NoticeDescription"].Value,
						["RandomString"] = Notice.Name,
						["Group"] = Notice["SelectedGroup"].Value,
						["StartFromDate"] = Notice["StartFromDate"].Value,
						["EndAtDate"] = Notice["EndAtDate"].Value
					})

					Notice.InAction.Value = true
				end
			elseif EndAtDate == DateTimeFormat:FormatLocalTime("D", "en-us").." "..DateTimeFormat:FormatLocalTime("MMM", "en-us") then
				if Notice.InAction.Value == false then
					local EventData = {
						["NoticeTitle"] = Notice.NoticeTitle.Value,
						["Note"] = Notice.NoticeDescription.Value,
						["RandomString"] = Notice.Name,
						["Group"] = Notice.SelectedGroup.Value,
						["StartFromDate"] = Notice.StartFromDate.Value,
						["EndAtDate"] = Notice.EndAtDate.Value
					}

					Arbor["ArborEvents"].RemoveSchoolNotice:FireAllClients(EventData)

					for i, v in pairs(Notices) do
						if v[EventData["RandomString"]] then
							table.remove(Notices, i)
						end
					end

					ArborSettingsData:SetAsync("Notices", Notices)

					Notice.InAction.Value = true
					NoticesData:FindFirstChild(EventData["RandomString"]):Destroy()
				end
			else
				--Notice.InAction.Value = false
			end
		end
	end
else
	warn("!! ARBOR // LICENCE NOT FOUND // Please refer to jaDevelopment for assistance")
end