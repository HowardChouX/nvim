---@diagnostic disable: undefined-global
return {
	"nvim-java/nvim-java",
	ft = "java",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"mfussenegger/nvim-dap",
	},
	config = function()
		require("java").setup({
			checks = {
				nvim_jdtls_conflict = true,
			},
			jdtls = {
				root_markers = {
					"mvnw",
					"gradlew",
					".git",
					"pom.xml",
					"build.gradle",
					"build.gradle.kts",
					"build.xml",
					"settings.gradle",
				},
				jvm_args = {
					"-XX:+UseParallelGC",
					"-XX:MinHeapFreeRatio=5",
					"-XX:MaxHeapFreeRatio=10",
					"-XX:GCTimeRatio=4",
					"-XX:AdaptiveSizePolicyWeight=90",
					"-Dsun.zip.disableMemoryMapping=true",
					"-Dlog.protocol=true",
					"-Dfile.encoding=utf-8",
					"-Djava.import.generatesMetadataFilesAtProjectRoot=false",
					"-Xms256m",
					"-Xmx1G",
				},
				settings = {
					java = {
						eclipse = { downloadSources = true },
						symbols = { includeSourceMethodDeclarations = true },
						selectionRange = { enabled = true },
						format = {
							enabled = true,
							comments = { enabled = false },
							onType = { enabled = true },
						},
						maxConcurrentBuilds = 5,
						saveActions = { organizeImports = false },
						referencesCodeLens = { enabled = true },
						implementationCodeLens = "all",
						signatureHelp = {
							enabled = true,
							description = { enabled = true },
						},
						inlayHints = {
							parameterNames = { enabled = "all" },
						},
						contentProvider = { preferred = "fernflower" },
						maven = {
							downloadSources = true,
						},
						completion = {
							maxResults = 50,
							filteredTypes = {
								"com.sun.*",
								"io.micrometer.shaded.*",
								"java.awt.*",
								"jdk.*",
								"sun.*",
							},
							overwrite = false,
							guessMethodArguments = true,
							favoriteStaticMembers = {
								"org.hamcrest.MatcherAssert.assertThat",
								"org.hamcrest.Matchers.*",
								"org.hamcrest.CoreMatchers.*",
								"org.junit.jupiter.api.Assertions.*",
								"java.util.Objects.requireNonNull",
								"java.util.Objects.requireNonNullElse",
								"org.mockito.Mockito.*",
							},
						},
						import = {
							gradle = { enabled = true },
							maven = { enabled = true },
							exclusions = {
								"**/node_modules/**",
								"**/.metadata/**",
								"**/archetype-resources/**",
								"**/META-INF/maven/**",
							},
						},
						project = {
							resourceFilters = {
								"build",
								"node_modules",
								"\\.git",
								"\\.idea",
								"\\.cache",
								"\\.vscode",
								"\\.settings",
							},
							referencedLibraries = {
								"/home/chou/code/cs61b-sp24/lib/**/*.jar",
								"/home/chou/.global-lib/lib/**/*.jar",
							},
						},
						sources = {
							organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 },
						},
						codeGeneration = {
							generateComments = true,
							useBlocks = true,
							toString = {
								template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
							},
						},
						configuration = {
							updateBuildConfiguration = "automatic",
						},
					},
				},
			},
			lombok = { enable = false },
			java_test = { enable = true },
			java_debug_adapter = { enable = true },
			spring_boot_tools = { enable = false },
			jdk = {
				auto_install = false,
				version = "21",
			},
			maven = {
				downloadSources = true,
				downloadJavadoc = false,
			},
			log = {
				level = "warn",
			},
		})
		vim.lsp.enable("jdtls")
	end,
}
