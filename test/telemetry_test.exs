defmodule ZendeskAPI.TelemetryTest do
  use ExUnit.Case

  import Mox

  test "telemetry events" do
    {test_name, _arity} = __ENV__.function
    parent = self()

    :telemetry.attach_many(
      to_string(test_name),
      [
        [:zendesk_api, :user, :start],
        [:zendesk_api, :user, :stop]
      ],
      &__MODULE__.handle/4,
      parent
    )

    ZendeskAPI.HTTPClient.Mock
    |> expect(:request, fn :post, _url, _headers, _body, _opts ->
      {:ok,
       %{
         status: 422,
         body:
           ~s|{"error":"RecordInvalid","description":"Record validation errors","details":{"email":[{"description":"Correo electrónico: xxx@xxx no tiene el formato adecuado"}]}}|
       }}
    end)

    ZendeskAPI.User.create(%ZendeskAPI.User{name: "xxx", email: "xxx@xxx"})

    assert_receive {^parent, :start}
    assert_receive {^parent, :stop}
  end

  def handle([:zendesk_api, _name, event], _measure, _meta, pid) do
    send(pid, {pid, event})
  end
end
