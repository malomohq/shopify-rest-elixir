defmodule Shopify.REST.Helpers.Body do
  alias Shopify.REST.{ Config, Helpers, Operation }

  @spec new(Operation.t(), Config.t()) :: String.t()
  def new(%{ method: :get }, _config) do
    ""
  end

  def new(operation, config) do
    Helpers.JSON.encode(operation.params, config)
  end
end
