function get_ms()
	local ms = tostring(io.popen("date +%s%3N"):read("a")):sub(-4, 9999)
	return tonumber(ms) / 1000
end

function draw(cr)
	local center_x = 150
	local center_y = 150
	local radius = 130

	local date_table = os.date("*t")

	local hours = date_table["hour"]
	local minutes = date_table["min"]
	local seconds = date_table["sec"]
	local ms = get_ms()

	local label_seconds = seconds
	seconds = seconds + ms

	local hours_str = tostring(hours)
	if string.len(hours_str) == 1 then
		hours_str = "0" .. hours_str
	end

	local minutes_str = tostring(minutes)
	if string.len(minutes_str) == 1 then
		minutes_str = "0" .. minutes_str
	end

	local seconds_str = tostring(label_seconds)
	if string.len(seconds_str) == 1 then
		seconds_str = "0" .. seconds_str
	end

	local font_size = radius / 5.5

	cr:set_source_rgb(1.0, 1.0, 1.0)

	cr:move_to(center_x - font_size * 2.5 + 10, center_y + font_size / 2.5)
	cr:set_font_size(font_size)
	cr:show_text(hours_str .. ":" .. minutes_str .. ":" .. seconds_str)
	cr:stroke()

	if hours > 12 then
		hours = hours - 12
	end

	local line_width = radius / 8
	local start_angle = -math.pi / 2

	local end_angle = start_angle + ((hours + minutes / 60 + seconds / 3600) / 12) * 2 * math.pi
	cr:set_line_width(line_width)
	cr:arc(center_x, center_y, radius, start_angle, end_angle)
	cr:stroke()

	end_angle = start_angle + ((minutes + seconds / 60) / 60) * 2 * math.pi
	cr:set_line_width(line_width)
	cr:arc(center_x, center_y, radius * 0.8, start_angle, end_angle)
	cr:stroke()

	if seconds == 0 then
		seconds = 60
	end

	end_angle = start_angle + (seconds / 60) * 2 * math.pi
	cr:set_line_width(line_width)
	cr:arc(center_x, center_y, radius * 0.6, start_angle, end_angle)
	cr:stroke()

	return 0
end
