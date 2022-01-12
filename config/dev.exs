use Mix.Config

config :zendesk_api,
  subdomain: System.get_env("ZENDESK_SUBDOMAIN"),
  user: System.get_env("ZENDESK_USER"),
  api_token: System.get_env("ZENDESK_API_TOKEN")
