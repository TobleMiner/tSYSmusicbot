Exec = {}
Exec.__index = Exec

setmetatable(Exec, {
  __call = function (class, ...)
    return class.new(...)
  end,
})

function Exec.new()
	local self = setmetatable({}, Exec)
	return self
end

function Exec:hack(cmd)
	os.execute(cmd.." > exec.tmp")
	local fhndl = io.open("exec.tmp", r)
	local data = fhndl:read("*all")
	fhndl:close()
	return data
end