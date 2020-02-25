# Shopify.REST

## Installation

`Shopify.REST` is published on [Hex](https://hex.pm/packages/shopify_REST).
Add it to your list of dependencies in `mix.exs`;

```elixir
defp deps do
  { :shopify_rest, "~> 1.0" }
end
```

`Shopify.REST` requires you to provide an HTTP client and a JSON codec.
`hackney` and `jason` are used by default. If you wish to use these defaults you
will need to specify `hackney` and `jason` as dependencies as well.

## Usage

You can send a request to the Shopify admin API by building a
`Shopify.REST.Operation` struct and passing it as the first argument to
`Shopify.REST.request/2`.

```elixir
operation = %Shopify.REST.Operation{ method: :get, params: %{ fields: ["name"] }, path: "/shop.json" }

{ :ok, response } = Shopify.REST.request(operation, %{access_token: "f85632530bf277ec9ac6f649fc327f17", shop: "some-shop"})
```

`Shopify.REST.Operation` is a struct that contains fields `:method`, `:params`
and `:path`.

* `:method` - an HTTP method and can be one of `:delete`, `:get`, `:post` or
  `:put`.
* `:params` - a map containing the request body or query string depending on
   whether `:method` is `:get` (query string), `:post` or `:put` (request body).
* `:path` - the path to send the requst to. Must begin with a forward slash.

### Verifying HMAC Signatures

`Shopify.REST` provides `verify_hmac/2` and `verify_hmac/3` functions for
verifying HMAC signatures returned by the Shopify API.

Please see the Shopify [Authentication with REST](https://shopify.dev/tutorials/authenticate-with-REST#verification)
documentation for the technical details regarding HMAC verification.

**`verify_hmac/2`**

```elixir
query = "code=0907a61c0c8d55e99db179b68161bc00&hmac=700e2dadb827fcc8609e9d5ce208b2e9cdaab9df07390d2cbca10d7c328fc4bf&shop=some-shop.myshopify.com&state=0.6784241404160823&timestamp=1337178173"
shared_secret = "hush"

{:ok, hmac} = Shopify.REST.verify_hmac(query, shared_secret)
```

**`verify_hmac/3`**

```elixir
hmac = "700e2dadb827fcc8609e9d5ce208b2e9cdaab9df07390d2cbca10d7c328fc4bf"
message = "code=0907a61c0c8d55e99db179b68161bc00&shop=some-shop.myshopify.com&timestamp=1337178173"
shared_secret = "hush"

{:ok, hmac} = Shopify.HMAC.verify(hmac, message, shared_secret)
```

## Configuration

Configuration is passed as a map to the second argument of
`Shopify.REST.request/2`.

* `:access_token` - Shopify access token for making authenticated requests
* `:headers` - a list of additional headers to send when making a request.
               Defaults to `[]`.
* `:host` - HTTP host to make requests to. Defaults to `myshopify.com`.
* `:http_client` - the HTTP client used for making requests. Defaults to
  `Shopify.REST.Client.Hackney`.
* `:http_client_opts` - additional options passed to `:http_client`. Defaults to
  `[]`.
* `:json_codec` - codec for encoding and decoding JSON payloads. Defaults to
  `Jason`.
* `:path` - path to prefix on each request. Defaults to `/admin`.
* `:port` - the HTTP port used when making a request
* `:protocol` - the HTTP protocol used when making a request. Defaults to
  `https`.
* `:retry` - whether to automatically retry failed API calls. May be `true` or
  `false`. Defaults to `false`.
* `:retry_opts` - options used when performing retries. Defaults to `[]`.
  * `:max_attempts` - the maximum number of retry attempts. Defaults to `3`.
* `:shop` - subdomain of the shop that a request is to be made to
* `:version` - version of the API to use. Defaults to `nil`. According to
  Shopify, when not specifying a version Shopify will use the oldest stable
  version of its API.
