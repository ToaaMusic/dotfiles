local serialize_mod = require("write")

return function()
	local test_table = {
		name = "John",
		age = 30,
		address = {
			street = "123 Main St",
			city = "Anytown",
			zip = "12345"
		},
		hobbies = { "reading", "swimming", "coding" },
		is_student = false,
		score = 95.5,
		empty_table = {}
	}

	print("=== lua ===")
	print(serialize_mod.serialize_lua(test_table))

	print("=== flat ===")
	print("=== default ===")
	print(serialize_mod.serialize_flat(test_table))

	print("\n=== kv_sep = ' = ' ===")
	print(serialize_mod.serialize_flat(test_table, { kv_sep = " = " }))

	print("\n=== terminator = ';' ===")
	print(serialize_mod.serialize_flat(test_table, { terminator = ";" }))

	print("\n=== prefix = '@define-color ' ===")
	print(serialize_mod.serialize_flat(test_table, { prefix = "@define-color " }))

	print("\n=== indent = 1 ===")
	print(serialize_mod.serialize_flat(test_table, { indent = 1 }))

	print("\n=== indent_width = '\\t', indent = 1 ===")
	print(serialize_mod.serialize_flat(test_table, { indent_width = "\t", indent = 1 }))

	print("\n=== value_quote = '\"' ===")
	print(serialize_mod.serialize_flat(test_table, { v_quote = "\"" }))

	print("\n=== all combined ===")
	print(serialize_mod.serialize_flat(test_table, {
		kv_sep = ": ",
		terminator = ";",
		prefix = "pre ",
		indent = 1,
		indent_width = "\t",
		v_quote = "\"",
	}))

	print("=== gtk css ===")
	print(serialize_mod.serialize_gtk_css(test_table))
end
