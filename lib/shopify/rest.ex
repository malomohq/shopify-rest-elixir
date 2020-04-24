defmodule Shopify.REST do
  alias Shopify.REST.{ Config, Operation, Request, Response }

  @type http_headers_t :: [{ String.t(), String.t() }]

  @type http_method_t :: :delete | :get | :post | :put

  @type response_t :: { :ok, Response.t() } | { :error, Response.t() | any }

  @doc """
  Send a request to Shopify.
  """
  @spec request(Operation.t(), map) :: response_t
  def request(operation, config) do
    Request.send(operation, Config.new(config))
  end

  @doc false
  @deprecated "Use verify_hmac_for_oauth/2 instead."
  @spec verify_hmac(String.t(), String.t()) ::
          { :ok, String.t() } | { :error, String.t() }
  def verify_hmac(query, shared_secret) do
    verify_hmac_for_oauth(query, shared_secret)
  end

  @doc false
  @deprecated "Use verify_hmac_for_oauth/3 instead."
  @spec verify_hmac(String.t(), String.t(), String.t()) ::
          { :ok, String.t() } | { :error, String.t() }
  def verify_hmac(hmac, message, shared_secret) do
    verify_hmac_for_oauth(hmac, message, shared_secret)
  end

  @doc """
  Ensures an HTTP query string passes HMAC verification.

  See `verify_hmac_for_oauth/3` for more details.

  ## Example

      query = "code=0907a61c0c8d55e99db179b68161bc00&hmac=700e2dadb827fcc8609e9d5ce208b2e9cdaab9df07390d2cbca10d7c328fc4bf&shop=some-shop.myshopify.com&state=0.6784241404160823&timestamp=1337178173"
      shared_secret = "hush"

      {:ok, hmac} = Shopify.REST.verify_hmac_for_oauth(query, shared_secret)
  """
  @spec verify_hmac_for_oauth(String.t(), String.t()) ::
          { :ok, String.t() } | { :error, String.t() }
  def verify_hmac_for_oauth(query, shared_secret) do
    decoded_query = URI.decode_query(query)

    { hmac, decoded_message } = Map.pop(decoded_query, "hmac")

    message = URI.encode_query(decoded_message)

    verify_hmac_for_oauth(hmac, message, shared_secret)
  end

  @doc """
  Verifies the Shopify HMAC signature.

  This function will compute an SHA256 HMAC digest based on the provided
  `message` and `shared_secret`. The digest is then compared to the `hmac`
  signature. If they match, verification has passed. Otherwise verification
  has failed.

  ## Example

      hmac = "700e2dadb827fcc8609e9d5ce208b2e9cdaab9df07390d2cbca10d7c328fc4bf"
      message = "code=0907a61c0c8d55e99db179b68161bc00&shop=some-shop.myshopify.com&timestamp=1337178173"
      shared_secret = "hush"

      {:ok, hmac} = Shopify.REST.verify_hmac_for_oauth(hmac, message, shared_secret)
  """
  @spec verify_hmac_for_oauth(String.t(), String.t(), String.t()) ::
          { :ok, String.t() } | { :error, String.t() }
  def verify_hmac_for_oauth(hmac, message, shared_secret) do
    ensure_hmac(hmac, message, shared_secret, 16)
  end

  @doc """
  Same as `verify_hmac_for_oauth/3` but intended to be used for verifying the
  signature of a webhook payload.

  ## Example

      hmac = "ruonad9ilcg3rhfv89nkzi4x7kkh7jibyhxkbewugvi="
      body = "<webhook request body>"
      shared_secret = "hush"

      {:ok, hmac} = Shopify.REST.verify_hmac_for_webhook(hmac, message, shared_secret)
  """
  @spec verify_hmac_for_webhook(String.t(), String.t(), String.t()) ::
          { :ok, String.t() } | { :error, String.t() }
  def verify_hmac_for_webhook(hmac, body, shared_secret) do
    ensure_hmac(hmac, body, shared_secret, 64)
  end

  defp ensure_hmac(hmac, message, shared_secret, encoding) do
    digest =
      :crypto.hmac(:sha256, shared_secret, message)
      |> encode_hmac(encoding)
      |> String.downcase()

    case digest do
      ^hmac ->
        { :ok, digest }
      _otherwise ->
        { :error, digest }
    end
  end

  defp encode_hmac(hmac, 16) do
    Base.encode16(hmac)
  end

  defp encode_hmac(hmac, 64) do
    Base.encode64(hmac)
  end
end
