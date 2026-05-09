package("rlimgui")
    set_homepage("https://github.com/raylib-extras/rlImGui")
    set_description("A Raylib integration with DearImGui")
    set_license("zlib")

    add_urls("https://github.com/raylib-extras/rlImGui.git")
    add_versions("raylib6", "3bc5731c4216bb8caa67fbea24aa85ce80d57ccb")

    if is_plat("windows") then
        add_configs("shared", { description = "Build shared library.", default = false, type = "boolean", readonly = true })
    end

    add_deps("raylib 6.0")
    add_deps("imgui v1.92.7-docking", { configs = { wchar32 = true } })

    on_install("!cross and !bsd and !iphoneos", function (package)
        io.writefile("xmake.lua", [[
            add_rules("mode.debug", "mode.release")
            set_languages("c99", "c++17")

            add_requires("raylib 6.0")
            add_requires("imgui v1.92.7-docking", {configs = {wchar32 = true}})

            if is_plat("linux") then
                add_defines("_GLFW_X11", "_GNU_SOURCE")
            end

            target("rlImGui")
                set_kind("$(kind)")
                add_files("*.cpp")
                add_headerfiles("*.h", "(extras/**.h)")
                add_includedirs(".", {public = true})
                add_packages("raylib", "imgui")
                add_defines("IMGUI_DISABLE_OBSOLETE_FUNCTIONS", "IMGUI_DISABLE_OBSOLETE_KEYIO")
        ]])
        import("package.tools.xmake").install(package)
    end)

    on_test( function (package)
        assert(package:check_cxxsnippets({ test = [[
            void test() {
                rlImGuiBegin();
            }
        ]] }, { includes = { "rlImGui.h" }, configs = { languages = "c++17" } }))
    end)
