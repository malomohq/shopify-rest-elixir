defmodule Shopify.REST.MixProject do
  use Mix.Project

  def project do
    [
      app: :shopify_rest,
      version: "1.0.2",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: dialyzer(),
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      { :gen_stage, ">= 0.14.0 and < 2.0.0", optional: true },
      { :hackney, "~> 1.15", optional: true },
      { :jason, "~> 1.1", optional: true },

      #
      # dev
      #

      { :dialyxir, "~> 1.0-rc", only: :dev, runtime: false },
      { :ex_doc, ">= 0.0.0", only: :dev, runtime: false },

      #
      # test
      #

      { :bypass, "~> 1.0", only: :test }
    ]
  end

  defp dialyzer do
    [
      plt_add_apps: [:gen_stage, :hackney],
      plt_core_path: "./_build/#{Mix.env()}"
    ]
  end

  defp package do
    %{
      description: "Client for the Shopify REST admin API",
      maintainers: ["Anthony Smith"],
      licenses: ["MIT"],
      links: %{
        GitHub: "https://github.com/malomohq/shopify-rest-elixir",
        "Made by Malomo - Post-purchase experiences that customers love": "https://gomalomo.com"
      }
    }
  end
end
