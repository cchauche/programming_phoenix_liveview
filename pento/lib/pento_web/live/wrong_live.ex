defmodule PentoWeb.WrongLive do
  use Phoenix.LiveView, layout: {PentoWeb.LayoutView, "live.html"}

  alias PentoWeb.Router.Helpers, as: Routes

  @number_range 1..10

  def mount(_params, _session, socket) do
    socket =
      socket
      |> reset_assigns()
      |> assign(score: 0)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Your score: <%= @score %></h1>
    <h2>
      <%= @message %>
    </h2>
    <h2>
      <%= for n <- number_range() do %>
        <a href="#" phx-click="guess" phx-value-guess={n}><%= n %></a>
      <% end %>
    </h2>

    <%= if @winner do %>
      <h2>
        <%= live_patch("Play Again", to: Routes.live_path(@socket, PentoWeb.WrongLive, reset: true)) %>
      </h2>
    <% end %>

    <h2>It's <%= @time %></h2>
    """
  end

  def handle_params(%{"reset" => "true"}, _uri, socket) do
    {:noreply, reset_assigns(socket)}
  end

  def handle_event("guess", %{"guess" => guess}, socket) do
    winner = String.to_integer(guess) == socket.assigns.number
    score = if winner, do: socket.assigns.score + 1, else: socket.assigns.score - 1
    message = "Your guess: #{guess}. #{if winner, do: "Correct!", else: "Wrong. Guess again."}"

    {:noreply, assign(socket, message: message, score: score, time: time(), winner: winner)}
  end

  defp time() do
    DateTime.utc_now() |> to_string()
  end

  defp number_range, do: @number_range

  defp generate_number do
    Enum.random(@number_range)
  end

  defp reset_assigns(socket) do
    assign(socket,
      message: "Make a guess:",
      time: time(),
      number: generate_number(),
      winner: false
    )
  end
end
