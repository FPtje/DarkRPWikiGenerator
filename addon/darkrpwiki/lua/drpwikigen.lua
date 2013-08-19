print("Wiki generator :D")

local hooks = DarkRP.getHooks()
local functions = DarkRP.getStubs()

file.CreateDir("darkrpwiki")
file.CreateDir("darkrpwiki/functions")
file.CreateDir("darkrpwiki/functions/darkrp/server")
file.CreateDir("darkrpwiki/functions/darkrp/client")
file.CreateDir("darkrpwiki/functions/darkrp/shared")
file.CreateDir("darkrpwiki/functions/player/server")
file.CreateDir("darkrpwiki/functions/player/client")
file.CreateDir("darkrpwiki/functions/player/shared")
file.CreateDir("darkrpwiki/functions/entity/server")
file.CreateDir("darkrpwiki/functions/entity/client")
file.CreateDir("darkrpwiki/functions/entity/shared")
file.CreateDir("darkrpwiki/functions/vector/server")
file.CreateDir("darkrpwiki/functions/vector/client")
file.CreateDir("darkrpwiki/functions/vector/shared")
file.CreateDir("darkrpwiki/hooks/server")
file.CreateDir("darkrpwiki/hooks/client")
file.CreateDir("darkrpwiki/hooks/shared")

local realmSide = {
	["Server"] = "Serverside",
	["Client"] = "Clientside",
	["Shared"] = "Shared"
}

local argumentsTemplate =
[[
{{ArgumentSyntax
%s
}}
]]

local singleArgumentLayout = 
[[

| Arg%sName = %s
| Arg%sType = %s
| Arg%sReq  = %s
| Arg%sDesc = %s
]]

local parameterListTemplate = 
[[
{{ParameterListSyntax
%s
}}
]]

local singleParameterLayout =
[[

| Arg%sName = %s
| Arg%sType = %s
| Arg%sDesc = %s
]]

local inlineParamLayout = "{{Type|%s}} %s"

local function getFileName(stub)
	local kind = stub.metatable and "functions" or "hooks"
	local realm = string.lower(stub.realm)

	return string.format("darkrpwiki/%s/%s/%s.txt", 
		kind, 
		(stub.metatable and stub.metatable.MetaName .. "/" or "") .. stub.realm,
		stub.name
	):lower()
end

/*---------------------------------------------------------------------------
Inline parameter list that just shows the types and names
---------------------------------------------------------------------------*/
local function getInlineParams(tbl)
	local params = {}
	for k,v in pairs(tbl) do
		table.insert(params, string.format(inlineParamLayout, v.type, v.name))
	end

	return table.concat(params, ', ')
end

/*---------------------------------------------------------------------------
Extended description of parameters
---------------------------------------------------------------------------*/
local function getParameters(tbl)
	if #tbl == 0 then return nil end

	local params = {}
	for k,v in pairs(tbl) do
		table.insert(params, 
			string.format(singleParameterLayout,
				k, v.name,
				k, v.type,
				k, v.description
			)
		)
	end

	return string.format(parameterListTemplate, table.concat(params))
end

-- hookname, realm-side, hookname, hookname, inlineArgs, description, realm-side, inlineReturns, parameters, return values
local hookWikiLayout = 
"[[Category:Hooks|%s]]\n" ..
"[[Category:%s|%s]]\n" ..
[[
{{Lua_hook |
	hook_name	= %s |
	arguments	= %s |
	description	= %s |
	lua_state	= {{%s}} |
	returns = %s |
}}

== Parameters ==
%s
== Return values ==
%s
]]

local function getHookWikiPage(stub)
	local parameters = getParameters(stub.parameters)
	local returns = getParameters(stub.returns)

	local inlineReturns = getInlineParams(stub.returns)
	inlineReturns = inlineReturns ~= "" and inlineReturns or "{{Type|nil}}"

	return string.format(hookWikiLayout,
		stub.name,
		realmSide[stub.realm],
		stub.name,
		stub.name,
		getInlineParams(stub.parameters),
		stub.description,
		realmSide[stub.realm],
		inlineReturns,
		parameters or "This hook isn't called with any parameters",
		returns or 
			"This hook does not accept return values."..
			" You can still return a value to override the default implementation of this hook."
	)
end

-- name, metatable, name, realm-side, name, metatable, function name, inlineArgs, description, metatable, 
-- realm-side, arguments, return values
local functionWikiLayout = 

"[[Category:Functions|%s]]\n" ..
"[[Category:%s|%s]]\n" ..
"[[Category:%s|%s]]\n" ..
[[{{Lua_function |
	function_name	= %s.%s |
	arguments	= %s |
	description	= %s |
	returns 	= %s |
	library		= {{Type|%s}} |
	lua_state	= {{%s}} |
}}

== Function parameters ==
%s

== Function return values ==
%s
]]

local function getFunctionArguments(stub)
	if #stub.parameters == 0 then return nil end
	
	local params = {}
	for k,v in pairs(stub.parameters) do
		table.insert(params, 
			string.format(singleArgumentLayout,
				k, v.name,
				k, v.type,
				k, not v.optional,
				k, v.description
			)
		)
	end

	return string.format(argumentsTemplate, table.concat(params))
end

local function getFunctionWikiPage(stub)
	local inlineReturns = getInlineParams(stub.returns)
	inlineReturns = inlineReturns ~= "" and inlineReturns or "{{Type|nil}}"

	return string.format(functionWikiLayout,
		stub.name,
		stub.metatable.MetaName,
		stub.name,
		realmSide[stub.realm],
		stub.name,
		stub.metatable.MetaName,
		stub.name,
		getInlineParams(stub.parameters),
		stub.description,
		inlineReturns,
		stub.metatable.MetaName,
		realmSide[stub.realm],
		getFunctionArguments(stub) or "This function does not take any arguments.",
		getParameters(stub.returns) or "This function does not return any value."
	)
end

for k,v in pairs(hooks) do 
	if CLIENT and v.realm == "Shared" then continue end
	print(getFileName(v)) 
	file.Write(getFileName(v), getHookWikiPage(v))
end

for k,v in pairs(functions) do 
	if CLIENT and v.realm == "Shared" then continue end
	print(getFileName(v))

	file.Write(getFileName(v), getFunctionWikiPage(v))
end
