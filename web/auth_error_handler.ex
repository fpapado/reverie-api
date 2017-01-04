defmodule Reverie.AuthErrorHandler do
    use Reverie.Web, :controller

    def unauthenticated(conn, params) do
        conn
        |> put_status(401)
        |> render(Reverie.ErrorView, "401.json")
    end

    def unauthorized(conn, params) do
        conn
        |> put_status(403)
        |> render(Reverie.ErrorView, "403.json")
    end
end
