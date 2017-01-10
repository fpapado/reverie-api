defmodule Reverie.UserController do
    use Reverie.Web, :controller
    use Inquisitor, with: Reverie.User, whitelist: ["email"]

    alias Reverie.User

    # Enforce user authentication
    plug Guardian.Plug.EnsureAuthenticated, handler: Reverie.AuthErrorHandler

    # NOTE: this uses build_query_params from Inquisitor to contruct
    # an Ecto where clause with key-value filters. The whitelist at
    # the top of this module sets allowable params.
    def index(conn, params) do
      users = params
        |> build_user_query()
        |> Repo.all()
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
