defmodule Shopify.REST.Operation do
  @type t ::
          %__MODULE__{
            method: Shopify.REST.http_method_t(),
            params: nil | map,
            path: String.t()
          }

  defstruct [:method, :params, :path]
end
