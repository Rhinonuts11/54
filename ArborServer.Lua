Arbor:WaitForChild("ArborEvents").DeleteTimeout.OnServerEvent:Connect(function(Player, Staff, Student, Respawn)
	if Student then
		if Settings["Timeout"] == true then
			local StudentData = ArborData["PlayerData"][Student.Name]

			if Respawn then
				if Student.Character then
					if Student.Character:FindFirstChild("Humanoid") then
						Student.Character.Humanoid.Health = 0
					end
				end
			end

		end
	end
	game.Workspace[Student.Name].Head.ArborNameTag.Extra.TimeoutPass.Visible = false
	ArborData.SessionTimeout[Student.Name]:Destroy()
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