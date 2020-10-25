
project("glmesh")
	kind "StaticLib"
	language "c++"
	includedirs {"include", "source",
		"../glload/include", "../glutil/include", "../glm"}
	targetdir "lib"
	objdir "obj"

	files {
		"include/glmesh/*.h",
		"source/*.cpp",
		"source/*.h",
	};
	
	configuration "windows"
		defines {"WIN32"}
	
	configuration "linux"
	    defines {"LOAD_X11"}

	configuration "Debug"
		flags "Unicode";
		defines {"DEBUG", "_DEBUG", "MEMORY_DEBUGGING"};
		flags "Symbols";
		targetname "glmeshD";

	configuration "Release"
		defines {"NDEBUG", "RELEASE"};
		flags "Unicode";
		flags {"OptimizeSpeed", "NoFramePointer", "ExtraWarnings", "NoEditAndContinue"};
		targetname "glmesh"
