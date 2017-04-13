defmodule Reverie.UserView do
    use Reverie.Web, :view
    use JaSerializer.PhoenixView

    attributes [:email, :username]
    has_many :stickers, link: :stickers_link

    def stickers_link(user, conn) do
      user_stickers_url(conn, :index, user.id)
    end

    def render("index.json", %{data: users}) do
        %{data: render_many(users, Reverie.UserView, "user.json")}
    end

    def render("show.json", %{data: user}) do
        %{data: render_one(user, Reverie.UserView, "user.json")}
    end

    # Render single user in JSONAPI format
    # Not actually used since the DSL at line 5 overrides it :)
    def render("user.json", %{data: user}) do
        %{
            "type": "user",
            "id": user.id,
            "attributes": %{
                "email": user.email,
                "username": user.username
            }
        }
    end
end
