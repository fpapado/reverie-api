defmodule Reverie.UserController do
    use Reverie.Web, :controller

    alias Reverie.User

    # Enforce user authentication
    plug Guardian.Plug.EnsureAuthenticated, handler: Reverie.AuthErrorHandler

    def index(conn, _params) do
      users = Repo.all(User)
      render(conn, "index.json", data: users)
    end

    def show(conn, %{"id" => id}) do
      user = Repo.get!(User, id)
      render(conn, "show.json", data: user)
    end

    def current(conn, _) do
        # Get user, whom Guardian has extracted from token in api_auth
        user = conn
        |> Guardian.Plug.current_resource

        conn
        |> render(Reverie.UserView, "show.json", data: user)
    end
end
