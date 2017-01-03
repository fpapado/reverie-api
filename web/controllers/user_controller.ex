defmodule Reverie.UserController do
    use Reverie.Web, :controller

    alias Reverie.User

    # Enforce user authentication
    plug Guardian.Plug.EnsureAuthenticated, handler: Reverie.AuthErrorHandler

    def current(conn, _) do
        # Get user, whom Guardian has extracted from token in api_auth
        user = conn
        |> Guardian.Plug.current_resource

        conn
        |> render(Reverie.UserView, "show.json", user: user)
    end
end
