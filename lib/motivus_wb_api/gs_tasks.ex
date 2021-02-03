defmodule MotivusWbApi.QueueTasks do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  def push(pid, element) do
    GenServer.cast(pid, {:push, element})
  end

  def pop(pid) do
    GenServer.call(pid, :pop)
  end

  def list(pid) do
    GenServer.call(pid, :list)
  end

  # Callbacks

  @impl true
  def init(stack) do
    {:ok, stack}
  end

  @impl true
  def handle_call(:pop, _from, elements) do
    try do
      [head | tail] = elements
      IO.inspect("INICIA POP A LA TASK")
      {:reply, head, tail}
    rescue
      MatchError -> {:reply, :error, []}
    end
  end

  @impl true
  def handle_call(:list, _from, elements) do
    {:reply, elements, elements}
  end

  @impl true
  def handle_cast({:push, element}, state) do
    {:noreply, [element | state]}
  end
end
