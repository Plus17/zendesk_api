defmodule ZendeskAPI.Telemetry do
  @moduledoc """
  ZendeskAPI [Telemetry](https://github.com/beam-telemetry/telemetry) integration.
  All time measurements are emitted in `:native` units by
  default.

  ZendeskAPI emits the following Telemetry events:
  * `[:zendesk_api, :user, :start]` before user action
    - Measurements: `:system_time`
    - Metadata: `:action`
  * `[:zendesk_api, :user, :stop]` after user action
    - Measurements: `:system_time`, `:duration`
    - Metadata: `:action`, `:error`
  """

  @typep monotonic_time :: integer

  @doc false
  @spec start(atom, map) :: monotonic_time
  def start(name, meta \\ %{}) do
    start_time = System.monotonic_time()

    :telemetry.execute(
      [:zendesk_api, name, :start],
      %{system_time: System.system_time()},
      meta
    )

    start_time
  end

  @doc false
  @spec stop(atom, monotonic_time, map) :: monotonic_time
  def stop(name, start_time, meta \\ %{}) do
    stop_time = System.monotonic_time()
    duration = stop_time - start_time

    :telemetry.execute(
      [:zendesk_api, name, :stop],
      %{system_time: System.system_time(), duration: duration},
      meta
    )

    stop_time
  end
end
