defmodule Shopify.REST.Helpers.URLTest do
  use ExUnit.Case, async: true

  alias Shopify.REST.{ Config, Helpers, Operation }

  describe "to_string/1" do
    test "with :shop" do
      config = Config.new(%{ shop: "a-shop" })

      operation = %Operation{ method: :post, path: "/a-path" }

      assert Helpers.URL.to_string(operation, config) == "#{config.protocol}://a-shop.#{config.host}#{config.path}#{operation.path}"
    end

    test "with :version" do
      config = Config.new(%{ version: "2020-01" })

      operation = %Operation{ method: :post, path: "/a-path" }

      assert Helpers.URL.to_string(operation, config) == "#{config.protocol}://#{config.host}#{config.path}/#{config.version}#{operation.path}"
    end

    test "without" do
      config = Config.new()

      operation = %Operation{ method: :post, path: "/a-path" }

      assert Helpers.URL.to_string(operation, config) == "#{config.protocol}://#{config.host}#{config.path}#{operation.path}"
    end
  end

  describe "to_uri/1" do
    test "with :shop" do
      shop = "a-shop"

      config = Config.new(%{ shop: shop })

      operation = %Operation{ method: :post, path: "/a-path" }

      host = "#{shop}.#{config.host}"
      path = "#{config.path}#{operation.path}"
      scheme = config.protocol

      assert %URI{ host: ^host, path: ^path, scheme: ^scheme } = Helpers.URL.to_uri(operation, config)
    end

    test "with :version" do
      version = "2020-01"

      config = Config.new(%{ version: version })

      operation = %Operation{ method: :post, path: "/a-path" }

      host = config.host
      path = "#{config.path}/#{version}#{operation.path}"
      scheme = config.protocol

      assert %URI{ host: ^host, path: ^path, scheme: ^scheme } = Helpers.URL.to_uri(operation, config)
    end

    test "without" do
      config = Config.new()

      operation = %Operation{ method: :post, path: "/a-path" }

      host = "#{config.host}"
      path = "#{config.path}#{operation.path}"
      scheme = config.protocol

      assert %URI{ host: ^host, path: ^path, scheme: ^scheme } = Helpers.URL.to_uri(operation, config)
    end
  end
end
