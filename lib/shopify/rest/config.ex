defmodule Shopify.REST.Config do
  @type t ::
          %__MODULE__{
            access_token: String.t(),
            headers: list({ String.t(), any }),
            host: String.t(),
            http_client: module,
            http_client_opts: any,
            json_codec: module,
            limiter: atom | boolean,
            limiter_opts: Keyword.t(),
            path: String.t(),
            port: String.t(),
            protocol: String.t(),
            retry: boolean,
            retry_opts: Keyword.t(),
            shop: String.t(),
            version: String.t()
          }

  defstruct access_token: nil,
            headers: [],
            host: "myshopify.com",
            http_client: Shopify.REST.Client.Hackney,
            http_client_opts: [],
            json_codec: Jason,
            limiter: false,
            limiter_opts: [],
            path: "/admin/api",
            port: nil,
            protocol: "https",
            retry: false,
            retry_opts: [],
            shop: nil,
            version: nil

  @spec new(map) :: t
  def new(config \\ %{}) do
    struct(%__MODULE__{}, config)
  end
end
