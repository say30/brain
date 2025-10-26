--[[
  Extracted from: ServerScriptService.Cmdr.BuiltInTypes.MathOperator
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

return function(registry)
	registry:RegisterType("mathOperator", registry.Cmdr.Util.MakeEnumType("Math Operator", {
		{
			Name = "+";
			Perform = function(a, b)
				return a + b
			end
		};
		{
			Name = "-";
			Perform = function(a, b)
				return a - b
			end
		};
		{
			Name = "*";
			Perform = function(a, b)
				return a * b
			end
		};
		{
			Name = "/";
			Perform = function(a, b)
				return a / b
			end
		};
		{
			Name = "**";
			Perform = function(a, b)
				return a ^ b
			end
		};
		{
			Name = "%";
			Perform = function(a, b)
				return a % b
			end
		}
	}))
end
