# ZendeskAPI

Elixir client to communicate with the Zendesk API

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `zendesk_api` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    # Hackney is the default HTTP library
    {:hackney, "~> 1.17"},
    {:zendesk_api, git: "git@github.com:HeyHomie/zendesk_api.git"}
  ]
end
```

## Configuration
 ### Base

 ```elixir
  config :zendesk_api,
    subdomain: "<SUBDOMAIN>"
    user: "<USER>"
    api_token: "<API-TOKEN>"
    http_client: ZendeskAPI.HTTPClient.Hackney
```

## Usage

### Create user

```elixir

  # Get an admin access token
  iex> iex> ZendeskAPI.User.create(%ZendeskAPI.User{name: "User Name", email: "user_email@email.com"})
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
         "email" => "user_email@email.com",
         "active" => true,
         "role" => "end-user",
         "organization_id" => nil,
         "name" => "User Name",
         "external_id" => nil,
         "photo" => nil
       }
     }}
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/zendesk_api](https://hexdocs.pm/zendesk_api).
****
