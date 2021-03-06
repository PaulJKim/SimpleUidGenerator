defmodule UidUser do
  use GenServer

  def child_spec(i) do
    %{
      id: :"uid_user_#{i}",
      start: {__MODULE__, :start_link, []}
    }
  end

  def start_using_uids(pid) do
    IO.inspect(GenServer.whereis(pid))

    for _i <- 1..10000 do
      IO.puts(
        "Took #{Benchmark.measure(fn -> IO.puts("Got Uid: #{GenServer.call(pid, :send_message)}") end)}"
      )

      # :timer.sleep(1000)
    end
  end

  @spec start_link :: :ignore | {:error, any} | {:ok, pid}
  def start_link() do
    uid_generator = UidGenerator

    GenServer.start_link(
      __MODULE__,
      uid_generator: uid_generator
    )
  end

  @impl true
  @spec init(nil | maybe_improper_list | map) :: {:ok, %{uid_generator: any}}
  def init(opts) do
    {:ok, %{uid_generator: opts[:uid_generator]}}
  end

  @impl true
  def handle_call(:send_message, _from, state) do
    {:reply, UidGenerator.get_uid(state.uid_generator), state}
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
