defmodule ZendeskAPI.UserTest do
  use ExUnit.Case, async: true

  import Mox

  # Make sure mocks are verified when the test exits
  setup :verify_on_exit!

  @valid_params %ZendeskAPI.User{
    name: "Zendesk user",
    email: "test@test.com"
  }

  @invalid_params %ZendeskAPI.User{name: "xxx", email: "xxx@xxx"}

  describe "create/1" do
    test "when data is valid" do
      ZendeskAPI.HTTPClient.Mock
      |> expect(:request, fn :post, _url, _headers, body, _opts ->
        assert body == ~s|{"user":{"user_fields":null,"shared_phone_number":null,"created_at":null,"only_private_comments":null,"external_id":null,"notes":null,"restricted_agent":null,"id":null,"shared_agent":null,"phone":null,"shared":null,"alias":null,"two_factor_auth_enabled":null,"role":null,"name":"Zendesk user","signature":null,"role_type":null,"verified":null,"locale_id":null,"details":null,"report_csv":null,"iana_time_zone":null,"organization_id":null,"tags":null,"last_login_at":null,"ticket_restriction":null,"suspended":null,"url":null,"active":null,"email":"test@test.com","updated_at":null,"locale":null,"default_group_id":null,"custom_role_id":null,"moderator":null,"time_zone":null,"photo":null}}|

        {:ok,
         %{
           status: 201,
           body:
             ~s|{"user":{"id":1903029829444,"url":"https://subdomain.zendesk.com/api/v2/users/1903029829444.json","name":"xxx","email":"test@test.com","created_at":"2022-01-12T18:23:18Z","updated_at":"2022-01-12T18:23:18Z","time_zone":"America/Mexico_City","iana_time_zone":"America/Mexico_City","phone":null,"shared_phone_number":null,"photo":null,"locale_id":1194,"locale":"es-419","organization_id":null,"role":"end-user","verified":false,"external_id":null,"tags":[],"alias":null,"active":true,"shared":false,"shared_agent":false,"last_login_at":null,"two_factor_auth_enabled":false,"signature":null,"details":null,"notes":null,"role_type":null,"custom_role_id":null,"moderator":false,"ticket_restriction":"requested","only_private_comments":false,"restricted_agent":true,"suspended":false,"default_group_id":null,"report_csv":false,"user_fields":{}}}|
         }}
      end)

      assert ZendeskAPI.User.create(@valid_params) ==
               {:ok,
                %ZendeskAPI.User{
                  active: true,
                  alias: nil,
                  created_at: "2022-01-12T18:23:18Z",
                  custom_role_id: nil,
                  default_group_id: nil,
                  details: nil,
                  email: "test@test.com",
                  external_id: nil,
                  iana_time_zone: "America/Mexico_City",
                  id: 1_903_029_829_444,
                  last_login_at: nil,
                  locale: "es-419",
                  locale_id: 1194,
                  moderator: false,
                  name: "xxx",
                  notes: nil,
                  only_private_comments: false,
                  organization_id: nil,
                  phone: nil,
                  photo: nil,
                  report_csv: false,
                  restricted_agent: true,
                  role: "end-user",
                  role_type: nil,
                  shared: false,
                  shared_agent: false,
                  shared_phone_number: nil,
                  signature: nil,
                  suspended: false,
                  tags: [],
                  ticket_restriction: "requested",
                  time_zone: "America/Mexico_City",
                  two_factor_auth_enabled: false,
                  updated_at: "2022-01-12T18:23:18Z",
                  url: "https://subdomain.zendesk.com/api/v2/users/1903029829444.json",
                  user_fields: %{},
                  verified: false
                }}
    end

    test "when user exists" do
      ZendeskAPI.HTTPClient.Mock
      |> expect(:request, fn :post, url, _headers, body, _opts ->
        assert url == "https://subdomain.zendesk.com/api/v2/users.json"
        assert body == ~s|{"user":{"user_fields":null,"shared_phone_number":null,"created_at":null,"only_private_comments":null,"external_id":null,"notes":null,"restricted_agent":null,"id":null,"shared_agent":null,"phone":null,"shared":null,"alias":null,"two_factor_auth_enabled":null,"role":null,"name":"Zendesk user","signature":null,"role_type":null,"verified":null,"locale_id":null,"details":null,"report_csv":null,"iana_time_zone":null,"organization_id":null,"tags":null,"last_login_at":null,"ticket_restriction":null,"suspended":null,"url":null,"active":null,"email":"test@test.com","updated_at":null,"locale":null,"default_group_id":null,"custom_role_id":null,"moderator":null,"time_zone":null,"photo":null}}|

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
        assert body == ~s|{"user":{"user_fields":null,"shared_phone_number":null,"created_at":null,"only_private_comments":null,"external_id":null,"notes":null,"restricted_agent":null,"id":null,"shared_agent":null,"phone":null,"shared":null,"alias":null,"two_factor_auth_enabled":null,"role":null,"name":"xxx","signature":null,"role_type":null,"verified":null,"locale_id":null,"details":null,"report_csv":null,"iana_time_zone":null,"organization_id":null,"tags":null,"last_login_at":null,"ticket_restriction":null,"suspended":null,"url":null,"active":null,"email":"xxx@xxx","updated_at":null,"locale":null,"default_group_id":null,"custom_role_id":null,"moderator":null,"time_zone":null,"photo":null}}|

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
        assert url == "https://subdomain.zendesk.com/api/v2/users.json?"

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
                  count: 9,
                  next_page: nil,
                  previous_page: nil,
                  users: [
                    %ZendeskAPI.User{
                      user_fields: %{},
                      shared_phone_number: nil,
                      created_at: "2022-01-12T18:21:02Z",
                      only_private_comments: false,
                      external_id: nil,
                      notes: nil,
                      restricted_agent: true,
                      id: 1_267_816_258_110,
                      shared_agent: false,
                      phone: nil,
                      shared: false,
                      alias: nil,
                      two_factor_auth_enabled: false,
                      signature: nil,
                      tags: [],
                      name: "xxx",
                      role_type: nil,
                      verified: false,
                      url: "https://subdomain.zendesk.com/api/v2/users/1267816258110.json",
                      locale_id: 1194,
                      report_csv: false,
                      iana_time_zone: "America/Mexico_City",
                      details: nil,
                      organization_id: nil,
                      last_login_at: nil,
                      role: "end-user",
                      ticket_restriction: "requested",
                      suspended: false,
                      active: true,
                      email: "email@email.com",
                      updated_at: "2022-01-12T18: 21: 03Z",
                      locale: "es-419",
                      default_group_id: nil,
                      custom_role_id: nil,
                      moderator: false,
                      time_zone: "America/Mexico_City",
                      photo: nil
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
                %ZendeskAPI.User{
                  active: true,
                  alias: nil,
                  created_at: "2022-01-12T18:21:02Z",
                  custom_role_id: nil,
                  default_group_id: nil,
                  details: nil,
                  email: "email@email.com",
                  external_id: nil,
                  iana_time_zone: "America/Mexico_City",
                  id: 1_267_816_258_110,
                  last_login_at: nil,
                  locale: "es-419",
                  locale_id: 1194,
                  moderator: false,
                  name: "xxx",
                  notes: nil,
                  only_private_comments: false,
                  organization_id: nil,
                  phone: nil,
                  photo: nil,
                  report_csv: false,
                  restricted_agent: true,
                  role: "end-user",
                  role_type: nil,
                  shared: false,
                  shared_agent: false,
                  shared_phone_number: nil,
                  signature: nil,
                  suspended: false,
                  tags: [],
                  ticket_restriction: "requested",
                  time_zone: "America/Mexico_City",
                  two_factor_auth_enabled: false,
                  updated_at: "2022-01-12T18:21:03Z",
                  url: "https://homie3979.zendesk.com/api/v2/users/1267816258110.json",
                  user_fields: %{},
                  verified: false
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
