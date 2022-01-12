ExUnit.start()

Mox.defmock(ZendeskAPI.HTTPClient.Mock, for: ZendeskAPI.HTTPClient)

Application.put_env(:zendesk_api, :http_client, ZendeskAPI.HTTPClient.Mock)
