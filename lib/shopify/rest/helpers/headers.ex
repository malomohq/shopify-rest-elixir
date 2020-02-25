defmodule Shopify.REST.Helpers.Headers do
  @moduledoc false

  alias Shopify.REST.{ Config }

  @default_headers [{ "content-type", "application/json" }]

  @spec new(Config.t()) :: Shopify.REST.http_headers_t()
  def new(%Config{ access_token: access_token } = config) when not is_nil(access_token) do
    []
    ++ @default_headers
    ++ [{ "x-shopify-access-token", access_token }]
    ++ config.headers
  end

  def new(config) do
    @default_headers ++ config.headers
  end
end
