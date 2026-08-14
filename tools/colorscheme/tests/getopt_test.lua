local getopt = require("getopt")

return function()
	local opts, idx, err = getopt(arg, "ab:c::", nil, {
		alternative = false,
		posixly_correct = true
	})

	if err then
		print("Error:", err)
		os.exit(1)
	end

	print("short:")
	for k, v in pairs(opts.short) do
		print(string.format("  -%s = %s", k, tostring(v)))
	end

	print("\nlong:")
	for k, v in pairs(opts.long) do
		print(string.format("  --%s = %s", k, tostring(v)))
	end

	print("\narguments:")
	for i = idx, #arg do
		print("  " .. arg[i])
	end
end
