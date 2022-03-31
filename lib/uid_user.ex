defmodule UidUser do
  use GenServer

  def child_spec(i) do
    %{
      id: :"uid_user_#{i}",
      start: {__MODULE__, :start_link, [[index: i]]}
    }
  end

  def start_using_uids(pid) do
    IO.inspect(GenServer.whereis(pid))

    for _i <- 1..10000 do
      Task.async(fn ->
        IO.puts(
          "Took #{Benchmark.measure(fn -> IO.puts("Got Uid: #{GenServer.call(pid, :send_message)}") end)}"
        )

        GenServer.call(pid, :send_message)
      end)

      :timer.sleep(1000)
    end
  end

  def start_link(opts) do
    GenServer.start_link(
      __MODULE__,
      index: opts[:index]
    )
  end

  @impl true
  def init(opts) do
    {:ok,
     %{
       uid_generator: opts[:uid_generator],
       index: opts[:index],
       internal_counter: 0,
       timestamp: div(System.system_time(:millisecond), 500)
     }}
  end

  @impl true
  def handle_call(:send_message, _from, state) do
    uid = get_uid(state.timestamp, state.index, state.internal_counter)

    if state.internal_counter >= 15 do
      {:reply, uid,
       %{state | timestamp: div(System.system_time(:millisecond), 500), internal_counter: 0}}
    else
      {:reply, uid, %{state | internal_counter: state.internal_counter + 1}}
    end
  end

  defp get_uid(timestamp, updater_index, internal_counter) do
    IO.puts("Inputs: #{timestamp} #{updater_index} #{internal_counter}")

    <<uid::unsigned-integer-31>> =
      <<timestamp::unsigned-integer-22, updater_index::unsigned-integer-5,
        internal_counter::unsigned-integer-4>>

    uid
  end
end

defmodule Benchmark do
  def measure(function) do
    function
    |> :timer.tc()
    |> elem(0)
    |> Kernel./(1_000_000)
  end
end
