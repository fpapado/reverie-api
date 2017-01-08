defmodule Reverie.UserController do
    use Reverie.Web, :controller
    use Inquisitor, with: Reverie.User, whitelist: ["email"]

    alias Reverie.User

    # Enforce user authentication
    plug Guardian.Plug.EnsureAuthenticated, handler: Reverie.AuthErrorHandler

    # NOTE: this uses build_query_params from Inquisitor to contruct
    # an Ecto where clause with key-value filters. The whitelist at
    # the top of this module sets allowable params. While the docs
    # state that the naked "params" is enough, our current setup
    # returns query params under "filter". it might be desirable to
    # set up a more elaborate pattern in the future.
    def index(conn, %{"filter" => params}) do
      users =
        build_user_query(params)
        |> Repo.all()
      render(conn, "index.json", data: users)
    end

    def index(conn, [%{"filter" => params}|_tail_params]) do
      users =
        build_user_query(params)
        |> Repo.all()
      render(conn, "index.json", data: users)
    end

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
