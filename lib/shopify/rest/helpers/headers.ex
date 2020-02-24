defmodule Shopify.REST.Helpers.Headers do
  @moduledoc false

  alias Shopify.REST.{ Config }

  @spec new(Config.t()) :: Shopify.REST.http_headers_t()
  def new(config) do
    []
    ++ [{ "content-type", "application/json" }]
    ++ [{ "x-shopify-access-token", config.access_token }]
    ++ config.headers
  end
end
