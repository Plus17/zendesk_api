defmodule ZendeskAPI.UserTest do
  use ExUnit.Case, async: true

  import Mox

  # Make sure mocks are verified when the test exits
  setup :verify_on_exit!

  @valid_params %{
    "name" => "Zendesk user",
    "email" => "test@test.com"
  }

  @invalid_params %{name: "xxx", email: "xxx@xxx"}

  describe "create/1" do
    test "when data is valid" do
      ZendeskAPI.HTTPClient.Mock
      |> expect(:request, fn :post, _url, _headers, body, _opts ->
        assert body == ~s|{"user":{"email":"test@test.com","name":"Zendesk user"}}|

        {:ok,
         %{
           status: 201,
           body:
             ~s|{"user":{"id":1903029829444,"url":"https://subdomain.zendesk.com/api/v2/users/1903029829444.json","name":"xxx","email":"test@test.com","created_at":"2022-01-12T18:23:18Z","updated_at":"2022-01-12T18:23:18Z","time_zone":"America/Mexico_City","iana_time_zone":"America/Mexico_City","phone":null,"shared_phone_number":null,"photo":null,"locale_id":1194,"locale":"es-419","organization_id":null,"role":"end-user","verified":false,"external_id":null,"tags":[],"alias":null,"active":true,"shared":false,"shared_agent":false,"last_login_at":null,"two_factor_auth_enabled":false,"signature":null,"details":null,"notes":null,"role_type":null,"custom_role_id":null,"moderator":false,"ticket_restriction":"requested","only_private_comments":false,"restricted_agent":true,"suspended":false,"default_group_id":null,"report_csv":false,"user_fields":{}}}|
         }}
      end)

      assert ZendeskAPI.User.create(@valid_params) ==
               {:ok,
                %{
                  "user" => %{
                    "user_fields" => %{},
                    "id" => 1_903_029_829_444,
                    "ticket_restriction" => "requested",
                    "report_csv" => false,
                    "moderator" => false,
                    "role_type" => nil,
                    "url" => "https://subdomain.zendesk.com/api/v2/users/1903029829444.json",
                    "last_login_at" => nil,
                    "signature" => nil,
                    "updated_at" => "2022-01-12T18:23:18Z",
                    "created_at" => "2022-01-12T18:23:18Z",
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
                    "email" => "test@test.com",
                    "active" => true,
                    "role" => "end-user",
                    "organization_id" => nil,
                    "name" => "xxx",
                    "external_id" => nil,
                    "photo" => nil
                  }
                }}
    end

    test "when user exists" do
      ZendeskAPI.HTTPClient.Mock
      |> expect(:request, fn :post, url, _headers, body, _opts ->
        assert url == "https://subdomain.zendesk.com/api/v2/users.json"
        assert body == ~s|{"user":{"email":"test@test.com","name":"Zendesk user"}}|

        {:ok,
         %{
           status: 422,
           body:
             ~s|{"error":"RecordInvalid","description":"Record validation errors","details":{"email":[{"description":"Correo electrónico: test@test.com ya está siendo usado por otro usuario","error":"DuplicateValue"}]}}|
         }}
      end)

      assert ZendeskAPI.User.create(@valid_params) ==
               {:error,
                %{
                  "description" => "Record validation errors",
                  "details" => %{
                    "email" => [
                      %{
                        "description" =>
                          "Correo electrónico: test@test.com ya está siendo usado por otro usuario",
                        "error" => "DuplicateValue"
                      }
                    ]
                  },
                  "error" => "RecordInvalid"
                }}
    end

    test "when data is invalid" do
      ZendeskAPI.HTTPClient.Mock
      |> expect(:request, fn :post, url, _headers, body, _opts ->
        assert url == "https://subdomain.zendesk.com/api/v2/users.json"
        assert body == ~s|{"user":{"email":"xxx@xxx","name":"xxx"}}|

        {:ok,
         %{
           status: 422,
           body:
             ~s|{"error":"RecordInvalid","description":"Record validation errors","details":{"email":[{"description":"Correo electrónico: xxx@xxx no tiene el formato adecuado"}]}}|
         }}
      end)

      assert ZendeskAPI.User.create(@invalid_params) ==
               {:error,
                %{
                  "description" => "Record validation errors",
                  "details" => %{
                    "email" => [
                      %{
                        "description" =>
                          "Correo electrónico: xxx@xxx no tiene el formato adecuado"
                      }
                    ]
                  },
                  "error" => "RecordInvalid"
                }}
    end
  end

  describe "list" do
    test "when exists users" do
      ZendeskAPI.HTTPClient.Mock
      |> expect(:request, fn :get, url, _headers, _body, _opts ->
        assert url =~ "https://subdomain.zendesk.com/api/v2/users.json"

        {:ok,
         %{
           status: 200,
           body:
             ~s|{"users":[{"id":1267816258110,"url":"https://subdomain.zendesk.com/api/v2/users/1267816258110.json","name":"xxx","email":"email@email.com","created_at":"2022-01-12T18:21:02Z","updated_at":"2022-01-12T18: 21: 03Z","time_zone":"America/Mexico_City","iana_time_zone":"America/Mexico_City","phone":null,"shared_phone_number":null,"photo":null,"locale_id":1194,"locale":"es-419","organization_id":null,"role":"end-user","verified":false,"external_id":null,"tags":[],"alias":null,"active":true,"shared":false,"shared_agent":false,"last_login_at":null,"two_factor_auth_enabled":false,"signature":null,"details":null,"notes":null,"role_type":null,"custom_role_id":null,"moderator":false,"ticket_restriction":"requested","only_private_comments":false,"restricted_agent":true,"suspended":false,"default_group_id":null,"report_csv":false,"user_fields":{}}],"next_page":null,"previous_page":null,"count":9}|
         }}
      end)

      assert ZendeskAPI.User.list() ==
               {:ok,
                %{
                  "count" => 9,
                  "next_page" => nil,
                  "previous_page" => nil,
                  "users" => [
                    %{
                      "user_fields" => %{},
                      "id" => 1_267_816_258_110,
                      "ticket_restriction" => "requested",
                      "report_csv" => false,
                      "moderator" => false,
                      "role_type" => nil,
                      "url" => "https://subdomain.zendesk.com/api/v2/users/1267816258110.json",
                      "last_login_at" => nil,
                      "signature" => nil,
                      "updated_at" => "2022-01-12T18: 21: 03Z",
                      "created_at" => "2022-01-12T18:21:02Z",
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
                      "email" => "email@email.com",
                      "active" => true,
                      "role" => "end-user",
                      "organization_id" => nil,
                      "name" => "xxx",
                      "external_id" => nil,
                      "photo" => nil
                    }
                  ]
                }}
    end
  end

  describe "show/1" do
    test "when user exits" do
      ZendeskAPI.HTTPClient.Mock
      |> expect(:request, fn :get, url, _headers, _body, _opts ->
        assert url == "https://subdomain.zendesk.com/api/v2/users/1267816258110.json"

        {:ok,
         %{
           status: 200,
           body:
             ~s|{"user":{"id":1267816258110,"url":"https://homie3979.zendesk.com/api/v2/users/1267816258110.json","name":"xxx","email":"email@email.com","created_at":"2022-01-12T18:21:02Z","updated_at":"2022-01-12T18:21:03Z","time_zone":"America/Mexico_City","iana_time_zone":"America/Mexico_City","phone":null,"shared_phone_number":null,"photo":null,"locale_id":1194,"locale":"es-419","organization_id":null,"role":"end-user","verified":false,"external_id":null,"tags":[],"alias":null,"active":true,"shared":false,"shared_agent":false,"last_login_at":null,"two_factor_auth_enabled":false,"signature":null,"details":null,"notes":null,"role_type":null,"custom_role_id":null,"moderator":false,"ticket_restriction":"requested","only_private_comments":false,"restricted_agent":true,"suspended":false,"default_group_id":null,"report_csv":false,"user_fields":{}}}|
         }}
      end)

      assert ZendeskAPI.User.show(1_267_816_258_110) ==
               {:ok,
                %{
                  "user" => %{
                    "user_fields" => %{},
                    "id" => 1_267_816_258_110,
                    "ticket_restriction" => "requested",
                    "report_csv" => false,
                    "moderator" => false,
                    "role_type" => nil,
                    "url" => "https://homie3979.zendesk.com/api/v2/users/1267816258110.json",
                    "last_login_at" => nil,
                    "signature" => nil,
                    "updated_at" => "2022-01-12T18:21:03Z",
                    "created_at" => "2022-01-12T18:21:02Z",
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
                    "email" => "email@email.com",
                    "active" => true,
                    "role" => "end-user",
                    "organization_id" => nil,
                    "name" => "xxx",
                    "external_id" => nil,
                    "photo" => nil
                  }
                }}
    end

    test "when user does not exist" do
      ZendeskAPI.HTTPClient.Mock
      |> expect(:request, fn :get, url, _headers, _body, _opts ->
        assert url == "https://subdomain.zendesk.com/api/v2/users/0.json"

        {:ok,
         %{
           status: 404,
           body: ~s|{"error":"RecordNotFound","description":"Not found"}|
         }}
      end)

      assert ZendeskAPI.User.show(0) ==
               {:error, %{"description" => "Not found", "error" => "RecordNotFound"}}
    end
  end
end
