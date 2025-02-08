local hyper = { "cmd", "alt", "ctrl", "shift" }

hs.hotkey.bind(hyper, "f", function()
	hs.application.launchOrFocus("Finder")
end)

hs.hotkey.bind(hyper, "b", function()
	hs.application.launchOrFocus("Firefox")
end)

hs.hotkey.bind(hyper, "t", function()
	hs.application.launchOrFocus("alacritty")
end)
