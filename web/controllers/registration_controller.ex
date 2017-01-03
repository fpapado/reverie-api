defmodule Reverie.RegistrationController do
    use Reverie.Web, :controller

    alias Reverie.User

    # Note that we're validating the API payload via pattern-matching
    # This allows Phoenix to automatically return a 422 otherwise
    # Might want to use a consistent serializer later on
    def create(conn, %{"data" => %{"type" => "user",
        "attributes" => %{"email" => email,
            "password" => password,
            "password_confirmation" => password_confirmation}}}) do

        changeset = User.changeset %User{}, %{email: email,
            password_confirmation: password_confirmation,
            password: password}

        case Repo.insert changeset do
            {:ok, user} ->
                conn
                |> put_status(:created)
                |> render(Reverie.UserView, "show.json", user: user)

            {:error, changeset} ->
                conn
                |> put_status(:unprocessable_entity)
                |> render(Reverie.ChangesetView, "error.json", changeset: changeset)
        end
    end
end
