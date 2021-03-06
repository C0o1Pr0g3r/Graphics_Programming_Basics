require "SvgWriter"
require "vmath"
require "Viewport"
require "SubImage"
require "GridAxis"
require "_utils"

local imageSize = vmath.vec2(400, 150);

local subImages = SubImage.SubImage(1, 2, imageSize.x, imageSize.y, 0, 50);

local coordSize = 6;
local coordWidth = coordSize * (imageSize.x / imageSize.y);

local vp = Viewport.Viewport(imageSize, {-5, 0}, {coordWidth, coordSize})
local trans2 = Viewport.Transform2D()
vp:SetTransform(trans2);

local styleLib = SvgWriter.StyleLibrary();

local lightSourceColor = "yellow";
local surfaceColor = "lightblue";
local rayColor = "darkblue";

styleLib:AddStyle(nil, "surface", SvgWriter.Style():stroke("none"):fill(surfaceColor));
styleLib:AddStyle(nil, "light", SvgWriter.Style():stroke("none"):fill(lightSourceColor));
styleLib:AddStyle(nil, "arrowhead",
	SvgWriter.Style():stroke(rayColor):fill(rayColor));
	
styleLib:AddStyle(nil, "ray",
	SvgWriter.Style():stroke(rayColor):stroke_width("1px"):stroke_dasharray({3, 3}):marker_end(SvgWriter.uriLocalElement("arrow")));
	
local axisData = GridAxis.GridAxis2D(vp, nil, styleLib, true, nil);

--Surface and light.
local surfaceDim =
{
	vmath.vec2(0, coordSize / 2), vmath.vec2(3, -coordSize / 2),
};

local lightSourcePos = 
{
	vmath.vec2(-11, 0),
	vmath.vec2(-2, 0);
}

local lightSourceRadius = 10;


--Diffuse Rays
local function CalcRays(lightPos, iNumRays, rayLen)
	rayLen = rayLen or 3;

	local rayLines = {};
	for i = 1, iNumRays do
		local startLoc = (-coordSize / 2) + ((coordSize / (iNumRays + 1)) * i);
		startLoc = vmath.vec2(0, startLoc);
		rayLines[#rayLines + 1] = startLoc;
		
		local dir = vmath.norm(lightPos - startLoc);
		rayLines[#rayLines + 1] = startLoc + (dir * rayLen);
	end
	
	return rayLines;
end

local rays =
{
	CalcRays(lightSourcePos[1], 7),
	CalcRays(lightSourcePos[2], 7, 1.5),
}

local iNumRays = 7;

surfaceDim = vp:Transform(surfaceDim);
lightSourcePos = vp:Transform(lightSourcePos);
rays[1] = subImages:Transform({1, 1}, vp:Transform(rays[1]));
rays[2] = subImages:Transform({1, 2}, vp:Transform(rays[2]));

local writer = SvgWriter.SvgWriter(ConstructSVGName(arg[0]), {subImages:Size().x .."px", subImages:Size().y .. "px"});
	writer:StyleLibrary(styleLib);
	writer:BeginDefinitions();
		WriteStandardArrowhead(writer, "arrow", {"arrowhead"});
		
		writer:BeginGroup(nil, "g_surface");
			--Draw surface and light.
			writer:Rect2Pt(surfaceDim[1], surfaceDim[2], nil, {"surface"});
		writer:EndGroup();

	writer:EndDefinitions();

--	axisData:AddDefinitions(writer, "g_axes");
--	writer:Use("g_axes", subImages:Offset(1, 1), subImages:SubSize());
--	writer:Use("g_axes", subImages:Offset(1, 2), subImages:SubSize());
	
	writer:Use("g_surface", subImages:Offset(1, 1), subImages:SubSize());

	lightSourcePos[1] = subImages:Transform({1, 1}, lightSourcePos[1]);
	lightSourcePos[2] = subImages:Transform({1, 2}, lightSourcePos[2]);
	writer:Circle(lightSourcePos[1], lightSourceRadius, {"light"});

	writer:Use("g_surface", subImages:Offset(1, 2), subImages:SubSize());
	writer:Circle(lightSourcePos[2], lightSourceRadius, {"light"});
	
	for i=1, #rays[1], 2 do
		writer:Line(rays[1][i], rays[1][i + 1], {"ray"});
	end
	for i=1, #rays[2], 2 do
		writer:Line(rays[2][i], rays[2][i + 1], {"ray"});
	end
	

writer:Close();
