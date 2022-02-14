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
  @spec start(atom(), map(), map()) :: monotonic_time
  def start(name, meta, measurements \\ %{}) do
    start_time = System.monotonic_time()

    measures = Map.put(measurements, :system_time, start_time)

    :telemetry.execute([:zendesk_api, name, :start], measures, meta)

    start_time
  end

  @doc false
  @spec stop(atom(), monotonic_time, map(), map()) :: monotonic_time
  def stop(name, start_time, meta, measurements \\ %{}) do
    end_time = System.monotonic_time()
    measures = Map.merge(measurements, %{duration: end_time - start_time})

    :telemetry.execute([:zendesk_api, name, :stop], measures, meta)

    end_time
  end
end
