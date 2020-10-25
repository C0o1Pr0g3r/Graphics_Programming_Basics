
project("glutil")
	kind "StaticLib"
	language "c++"
	includedirs {"include", "source",
		"../glload/include", "../glm"}
	targetdir "lib"
	objdir "obj"

	files {
		"include/glutil/*.h",
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
		targetname "glutilD";

	configuration "Release"
		defines {"NDEBUG", "RELEASE"};
		flags "Unicode";
		flags {"OptimizeSpeed", "NoFramePointer", "ExtraWarnings", "NoEditAndContinue"};
		targetname "glutil"
