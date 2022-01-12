defmodule ZendeskAPI.User do
  @moduledoc """
  Module to [User](https://developer.zendesk.com/api-reference/ticketing/users/users/) resource operations
  """

  require Logger

  alias ZendeskAPI.HTTPClient

  @doc """
  List users.
  ## Examples
      iex> ZendeskAPI.User.list()
      {:ok,
      %{
        "count" => 4,
        "next_page" => nil,
        "previous_page" => nil,
        "users" => [...]
      }}

      iex> ZendeskAPI.User.list(page: 5)
      {:ok,
      %{
        "count" => 4,
        "next_page" => nil,
        "previous_page" => nil,
        "users" => [...]
      }}
  """
  @spec list :: [] | {:error, String.t()}
  def list(opts \\ []) when is_list(opts) do
    url =
      "https://#{get_env!(:subdomain)}.zendesk.com/api/v2/users.json?#{URI.encode_query(opts)}"

    headers = build_headers()

    result =
      :http_client
      |> get_env!()
      |> HTTPClient.request(:get, url, headers, "", [])
      |> handle_response()

    case result do
      {:ok, location} -> {:ok, location}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Show user specified by id.

  ## Examples
      iex> ZendeskAPI.User.show(1)
      {:ok,
      %{
        "user" => %{
          "user_fields" => %{},
          "id" => 1,
          "ticket_restriction" => "requested",
          "report_csv" => false,
          "moderator" => false,
          "role_type" => nil,
          "url" => "https://<your-subdomain>.zendesk.com/api/v2/users/1.json",
          "last_login_at" => nil,
          "signature" => nil,
          "updated_at" => "2022-01-11T20:09:26Z",
          "created_at" => "2022-01-11T20:09:26Z",
          "alias" => "",
          "shared_phone_number" => false,
          "default_group_id" => nil,
          "restricted_agent" => true,
          "time_zone" => "America/Mexico_City",
          "shared_agent" => false,
          "shared" => false,
          "tags" => [],
          "verified" => true,
          "phone" => "+525585234056",
          "details" => nil,
          "locale_id" => 1194,
          "suspended" => false,
          "two_factor_auth_enabled" => false,
          "only_private_comments" => false,
          "iana_time_zone" => "America/Mexico_City",
          "notes" => nil,
          "locale" => "es-419",
          "custom_role_id" => nil,
          "email" => "user2@example.com",
          "active" => true,
          "role" => "end-user",
          "organization_id" => nil,
          "name" => "Jose",
          "external_id" => "1",
          "photo" => nil
        }
      }}
  """
  @spec show(integer) :: User.t() | {:error, String.t()}
  def show(id) when is_integer(id) do
    url = "https://#{get_env!(:subdomain)}.zendesk.com/api/v2/users/#{id}.json"

    headers = build_headers()

    result =
      :http_client
      |> get_env!()
      |> HTTPClient.request(:get, url, headers, "", [])
      |> handle_response()

    case result do
      {:ok, location} -> {:ok, location}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Create user.
  ## Examples
      iex> ZendeskAPI.User.create(%{name: "xxx", email: "xxx@xxx"})
       {:ok,
     %{
       "user" => %{
         "user_fields" => %{},
         "id" => 1_903_008_556_644,
         "ticket_restriction" => "requested",
         "report_csv" => false,
         "moderator" => false,
         "role_type" => nil,
         "url" => "https://<your-subdomain>.zendesk.com/api/v2/users/1903008556644.json",
         "last_login_at" => nil,
         "signature" => nil,
         "updated_at" => "2022-01-12T00:06:01Z",
         "created_at" => "2022-01-12T00:06:01Z",
         "alias" => nil,
         "shared_phone_number" => nil,
         "default_group_id" => nil,
         "restricted_agent" => true,
         "time_zone" => "America/Mexico_City",
         "shared_agent" => false,
         "shared" => false,
         "tags" => [],
         "verified" => false,
         "phone" => nil,
         "details" => nil,
         "locale_id" => 1194,
         "suspended" => false,
         "two_factor_auth_enabled" => false,
         "only_private_comments" => false,
         "iana_time_zone" => "America/Mexico_City",
         "notes" => nil,
         "locale" => "es-419",
         "custom_role_id" => nil,
         "email" => "xxx@xxx",
         "active" => true,
         "role" => "end-user",
         "organization_id" => nil,
         "name" => "xxx",
         "external_id" => nil,
         "photo" => nil
       }
     }}
  """
  @spec create(map()) :: User.t() | {:error, String.t()} | nil
  def create(attrs) when is_map(attrs) do
    url = "https://#{get_env!(:subdomain)}.zendesk.com/api/v2/users.json"

    headers = build_headers()

    body = Jason.encode!(%{user: attrs})

    result =
      :http_client
      |> get_env!()
      |> HTTPClient.request(:post, url, headers, body, [])
      |> handle_response()

    case result do
      {:ok, location} -> {:ok, location}
      {:error, error} -> {:error, error}
    end
  end

  # Gets an env variable
  @spec get_env!(atom()) :: term()
  defp get_env!(key) do
    Application.fetch_env!(:zendesk_api, key) ||
      raise """
      environment variable <#{key}> is missing.
      """
  end

  # Build basic headers includig: content-type & authorization
  @spec build_headers() :: list()
  defp build_headers() do
    password = :base64.encode("#{get_env!(:user)}/token:#{get_env!(:api_token)}")

    [
      {"content-type", "application/json"},
      {"Authorization", "Basic #{password}"}
    ]
  end

  defp handle_response({:ok, %{status: status, body: body}}) when status in [200, 201] do
    case Jason.decode(body) do
      {:ok, attrs} -> {:ok, attrs}
      {:error, reason} -> {:error, reason}
    end
  end

  defp handle_response({:ok, response}) do
    {:error, Jason.decode!(response.body)}
  end

  defp handle_response({:error, exception}) do
    {:error, exception}
  end
end
