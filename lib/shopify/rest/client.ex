defmodule Shopify.REST.Client do
  @moduledoc """
  Behaviour for implementing an HTTP client.
  """

  @type response_t ::
          %{
            body: binary,
            headers: Shopify.REST.http_headers_t(),
            status_code: pos_integer
          }

  @callback request(
              method :: Shopify.REST.http_method_t(),
              url :: String.t(),
              headers :: Shopify.REST.http_headers_t(),
              body :: binary,
              opts :: any
            ) :: { :ok, response_t() } | { :error, any }
end
