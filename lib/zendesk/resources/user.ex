defmodule ZendeskAPI.User do
  @moduledoc """
  Module to [User](https://developer.zendesk.com/api-reference/ticketing/users/users/) resource operations
  """

  require Logger

  alias ZendeskAPI.HTTPClient

  alias ZendeskAPI.Telemetry

  @derive Jason.Encoder
  @enforce_keys [:name, :email]
  defstruct [
    :user_fields,
    :id,
    :ticket_restriction,
    :report_csv,
    :moderator,
    :role_type,
    :url,
    :last_login_at,
    :signature,
    :updated_at,
    :created_at,
    :alias,
    :shared_phone_number,
    :default_group_id,
    :restricted_agent,
    :time_zone,
    :shared_agent,
    :shared,
    :tags,
    :verified,
    :phone,
    :details,
    :locale_id,
    :suspended,
    :two_factor_auth_enabled,
    :only_private_comments,
    :iana_time_zone,
    :notes,
    :locale,
    :custom_role_id,
    :email,
    :active,
    :role,
    :organization_id,
    :name,
    :external_id,
    :photo
  ]

  @on_load :load_atoms

  @list_keys [
    :count,
    :next_page,
    :previous_page,
    :users
  ]

  @doc """
  List users.
  ## Examples
      iex> ZendeskAPI.User.list()
      {:ok,
      %{
        count: 4,
        next_page: 2,
        previous_page: nil,
        users: [%ZendeskAPI.User{}, ...]
      }}

      iex> ZendeskAPI.User.list(page: 2)
      {:ok,
      %{
        count: 4,
        next_page: nil,
        previous_page: 1,
        users: [%ZendeskAPI.User{}, ...]
      }}
  """
  @spec list :: [] | {:error, String.t()}
  def list(opts \\ []) when is_list(opts) do
    start = Telemetry.start(:user, %{action: :list})

    url =
      "https://#{get_env!(:subdomain)}.zendesk.com/api/v2/users.json?#{URI.encode_query(opts)}"

    headers = build_headers()

    result =
      :http_client
      |> get_env!()
      |> HTTPClient.request(:get, url, headers, "", [])
      |> handle_response()

    case result do
      {:ok, location} ->
        Telemetry.stop(:user, start, %{action: :list})
        {:ok, location}
      {:error, error} ->
        Telemetry.stop(:user, start, %{action: :list, error: error})
        {:error, error}
    end
  end

  @doc """
  Show user specified by id.

  ## Examples
      iex> ZendeskAPI.User.show(1)
      {:ok, %ZendeskAPI.User{
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
    start = Telemetry.start(:user, %{action: :show})

    url = "https://#{get_env!(:subdomain)}.zendesk.com/api/v2/users/#{id}.json"

    headers = build_headers()

    result =
      :http_client
      |> get_env!()
      |> HTTPClient.request(:get, url, headers, "", [])
      |> handle_response()

      case result do
        {:ok, location} ->
          Telemetry.stop(:user, start, %{action: :show})
          {:ok, location}
        {:error, error} ->
          Telemetry.stop(:user, start, %{action: :show, error: error})
          {:error, error}
      end
  end

  @doc """
  Create user.
  ## Examples
      iex> ZendeskAPI.User.create(%ZendeskAPI.User{name: "xxx", email: "xxx@xxx"})
       {:ok, %ZendeskAPI.User{
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
  @spec create(User.t()) :: User.t() | {:error, String.t()} | nil
  def create(%__MODULE__{} = attrs) do
    start = Telemetry.start(:user, %{action: :create})

    url = "https://#{get_env!(:subdomain)}.zendesk.com/api/v2/users.json"

    headers = build_headers()

    body = Jason.encode!(%{user: attrs})

    result =
      :http_client
      |> get_env!()
      |> HTTPClient.request(:post, url, headers, body, [])
      |> handle_response()

      case result do
        {:ok, location} ->
          Telemetry.stop(:user, start, %{action: :create})
          {:ok, location}
        {:error, error} ->
          Telemetry.stop(:user, start, %{action: :create, error: error})
          {:error, error}
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
    case Jason.decode(body, keys: :atoms!) do
      {:ok, attrs} -> {:ok, build_struct!(attrs)}
      {:error, reason} -> {:error, reason}
    end
  end

  defp handle_response({:ok, response}) do
    {:error, Jason.decode!(response.body)}
  end

  defp handle_response({:error, exception}) do
    {:error, exception}
  end

  # Buils user struct
  @spec build_struct!(map()) :: User.t()
  defp build_struct!(%{user: user_map}) when is_map(user_map) do
    struct!(__MODULE__, user_map)
  end

  defp build_struct!(%{users: user_list} = response) when is_list(user_list) do
    user_structs = Enum.map(user_list, &struct!(__MODULE__, &1))

    Map.put(response, :users, user_structs)
  end

  def load_atoms() do
    Enum.each(@list_keys, &Code.ensure_loaded?/1)
    :ok
  end
end
