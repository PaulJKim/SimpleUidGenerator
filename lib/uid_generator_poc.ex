defmodule UidGeneratorPoc do
  # Automatically defines child_spec/1
  use Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [
      %{
        id: UidGenerator,
        start: {UidGenerator, :start_link, [0]}
      },
      {UidUser, 1},
      {UidUser, 2},
      {UidUser, 3}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
