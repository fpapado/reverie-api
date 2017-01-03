defmodule Reverie.UserView do
    use Reverie.Web, :view

    def render("index.json", %{users: users}) do
        %{data: render_many(users, Reverie.UserView, "user.json")}
    end

    def render("show.json", %{user: user}) do
        %{data: render_one(user, Reverie.UserView, "user.json")}
    end

    # Render single user in JSONAPI format
    def render("user.json", %{user: user}) do
        %{
            "type": "user",
            "id": user.id,
            "attributes": %{
                "email": user.email
            }
        }
    end
end
