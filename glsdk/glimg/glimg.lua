
project("glimg")
	kind "StaticLib"
	language "c++"
	includedirs {"include", "source", "../glload/include"}
	targetdir "lib"
	objdir "obj"

	files {
		"include/glimg/*.h",
		"source/*.h",
		"source/*.cpp",
		"source/*.c",
		"source/*.inc",
	};

	configuration "windows"
		defines {"WIN32"}
	
	configuration "linux"
	    defines {"LOAD_X11"}

	configuration "Debug"
		flags "Unicode";
		defines {"DEBUG", "_DEBUG", "MEMORY_DEBUGGING"};
		flags "Symbols";
		targetname "glimgD";

	configuration "Release"
		defines {"NDEBUG", "RELEASE"};
		flags "Unicode";
		flags {"OptimizeSpeed", "NoFramePointer", "ExtraWarnings", "NoEditAndContinue"};
		targetname "glimg"
