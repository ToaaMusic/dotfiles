return {
	read_all_text = function(path)
		local f, err = io.open(path, "r")
		if not f then
			return nil, err
		end
		local content = f:read("*all")
		f:close()
		return content
	end
}
