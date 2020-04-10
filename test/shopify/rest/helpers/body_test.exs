defmodule Shopify.REST.Helpers.BodyTest do
  use ExUnit.Case, async: true

  alias Shopify.REST.{ Config, Helpers, Operation }

  setup do
    %{ config: Config.new() }
  end

  test "new/2 when operation method is :get", %{ config: config } do
    operation = %Operation{ method: :get, params: %{ var: "a" }, path: "/fake" }

    body = Helpers.Body.new(operation, config)

    assert "" == body
  end

  test "new/2 when operation method is not :get", %{ config: config } do
    operation = %Operation{ method: :post, params: %{ var: "a" }, path: "/fake" }

    body = Helpers.Body.new(operation, config)

    assert "{\"var\":\"a\"}" == body
  end
end
