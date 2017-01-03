defmodule Reverie.SessionController do
    use Reverie.Web, :controller

    import Ecto.Query, only: [where: 2]
    import Comeonin.Bcrypt
    import Logger

    alias Reverie.User

    def create(conn, %{"grant_type" => "password",
            "username" => username,
            "password" => password}) do

        try do
            # Try will throw if user not unique / other failure
            user = User
            |> where(email: ^username)
            |> Repo.one!
            cond do

                checkpw(password, user.password_hash) ->
                    # Success
                    Logger.info "User " <> username <> " has logged in"
                    # Encode a JWT; assign by destructuring
                    { :ok, jwt, _} = Guardian.encode_and_sign(user, :token)
                    # Return token to client
                    conn
                    |> json(%{access_token: jwt})

                true ->
                    # Fallthrough if login unsuccessful
                    Logger.warn "User " <> username <> " has failed to log in"
                    conn
                    |> put_status(401)
                    |> render(Reverie.ErrorView, "401.json")
            end
        rescue
            e ->
                IO.inspect e # Print error to console for debugging
                Logger.error "Unexpected error while attempting to log in user " <> username
                conn
                |> put_status(401)
                |> render(Reverie.ErrorView, "401.json")
        end
    end

    def create(conn, %{"grant_type" => _}) do
        # Handle unknown grant type
        throw "Unsupported grant_type"
    end
end
