-- curl.exe -LO https://sourceforge.net/projects/giflib/files/giflib-5.1.4.tar.gz
-- tar.exe -xvf giflib-5.1.4.tar.gz

workspace "gif"

-- toolset

filter { 'action:vs2017' } do
    toolset 'v141'
end filter {}


-- characterset

filter { "system:windows" } do
    characterset "Unicode"
end filter {}


-- platforms

filter { "system:windows" } do
    platforms { "Win32", "x64" }
end filter {}

filter { "system:macosx" } do
    platforms { "x86_64" }
end filter {}


-- configurations

configurations { "Release", "Debug" }


-- defines

filter { 'system:windows' } do
    defines { '_WINDOWS', 'WIN32' }
end filter {}

filter { 'system:windows', 'configurations:Debug' } do
    defines { '_DEBUG', }
end filter {}

filter { 'system:macosx', 'configurations:Debug' } do
    defines { 'DEBUG' }
end filter {}

filter { 'configurations:Release' } do
    defines { 'NDEBUG' }
end filter {}

-- optimaizations

filter { 'configurations:Debug' } do
  optimize 'Off'
end filter {}

filter { 'system:macosx', 'configurations:Release' } do
  optimize 'Size'
end filter {}

filter { 'system:windows', 'configurations:Release' } do
  optimize 'Full'
end filter {}


-- symbols

filter { 'system:windows' } do
    symbols "On"
end filter {}

filter { 'system:macosx', 'configurations:Debug' } do
    symbols "On"
end filter {}


-- flags

flags { 'MultiProcessorCompile' }


-- xcodebuildsettings

filter { "system:macosx" } do
    xcodebuildsettings {
        CLANG_CXX_LANGUAGE_STANDARD = 'c++14',
        CLANG_CXX_LIBRARY = 'libc++',
        GCC_C_LANGUAGE_STANDARD = 'c11',
        MACOSX_DEPLOYMENT_TARGET = '10.9',
        VALID_ARCHS = 'x86_64',
    }
end filter {}


if os.target() == "windows" then
    os.writefile_ifnotequal("", "unistd.h")
end
  
project "gif" do

    kind "SharedLib"

    files {
        "giflib-5.1.4/lib/**.h",
        "giflib-5.1.4/lib/**.c",
    }

    vpaths {
        ["Sources/**"] = {
            "giflib-5.1.4/lib/**.h",
            "giflib-5.1.4/lib/**.c",
        },
    }

    filter { "system:windows" } do
        includedirs { "." }
        removefiles { "unistd.h" }
    end filter {}

end project "*"


-- MSBuild gif.sln /m /t:gif /p:Platform=x64;Configuration=Release
-- MSBuild gif.sln /m /t:gif /p:Platform=x64;Configuration=Debug
-- MSBuild gif.sln /m /t:gif /p:Platform=Win32;Configuration=Release
-- MSBuild gif.sln /m /t:gif /p:Platform=Win32;Configuration=Debug
