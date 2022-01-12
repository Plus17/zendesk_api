defmodule ZendeskAPI.HTTPClient do
  @moduledoc """
  Specification for a ZendeskAPI HTTP client.
  """

  @type method() :: atom()

  @type url() :: binary()

  @type status() :: non_neg_integer()

  @type header() :: {binary(), binary()}

  @type body() :: binary()

  @doc """
  Callback to make an HTTP request.
  """
  @callback request(method(), url(), [header()], body(), opts :: keyword()) ::
              {:ok, %{status: status, headers: [header()], body: body()}}
              | {:error, Exception.t()}

  @doc false
  def request(module, method, url, headers, body, opts) do
    module.request(method, url, headers, body, opts)
  end
end
