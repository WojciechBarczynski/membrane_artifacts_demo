defmodule Membrane.Template.Mixfile do
  use Mix.Project

  @version "0.1.0"
  @github_url "https://github.com/membraneframework/membrane_template_plugin"

  def project do
    [
      app: :membrane_template_plugin,
      version: @version,
      elixir: "~> 1.13",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: dialyzer(),

      # hex
      description: "Template Plugin for Membrane Multimedia Framework",
      package: package(),

      # docs
      name: "Membrane Template plugin",
      source_url: @github_url,
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: []
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_env), do: ["lib"]

  defp deps do
    [
      {:membrane_core, "~> 0.12.9"},
      # RTP
      {:membrane_rtp_plugin, "~> 0.23.1"},
      {:membrane_rtp_h264_plugin, "~> 0.18.0"},
      {:membrane_h264_plugin, "~> 0.7.3"},
      {:membrane_h264_ffmpeg_plugin, "~> 0.29.0"},
      {:membrane_udp_plugin, "~> 0.10.0"},
      # Membrane utils
      {:membrane_file_plugin, "~> 0.15.0"},
      {:membrane_realtimer_plugin, "~> 0.7.0"},
      {:membrane_sdl_plugin, "~> 0.16.0"},
      {:membrane_hackney_plugin, "~> 0.10.1"},
      {:membrane_mp4_plugin, "~> 0.30.1"},
      # Dev
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:dialyxir, ">= 0.0.0", only: :dev, runtime: false},
      {:credo, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp dialyzer() do
    opts = [
      flags: [:error_handling]
    ]

    if System.get_env("CI") == "true" do
      # Store PLTs in cacheable directory for CI
      [plt_local_path: "priv/plts", plt_core_path: "priv/plts"] ++ opts
    else
      opts
    end
  end

  defp package do
    [
      maintainers: ["Membrane Team"],
      licenses: ["Apache-2.0"],
      links: %{
        "GitHub" => @github_url,
        "Membrane Framework Homepage" => "https://membraneframework.org"
      }
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md", "LICENSE"],
      formatters: ["html"],
      source_ref: "v#{@version}",
      nest_modules_by_prefix: [Membrane.Template]
    ]
  end
end
