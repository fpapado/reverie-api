defmodule Reverie.StickerController do
  use Reverie.Web, :controller
  import Ecto.Query

  alias Reverie.Sticker

  # List of Stickers by owner (receiver), based on token
  # NOTE: Preloads :sender by default, since we typically want
  # the sender's username alongside the sticker / message.
  # Might want to change this in the future, to use the ?include option
  def index(conn, %{"user_id" => user_id}) do
    current_user = Guardian.Plug.current_resource(conn)

    case to_string(user_id) == to_string(current_user.id) do
      true ->
        stickers = Sticker
        |> where(receiver_id: ^current_user.id)
        |> preload(:sender)
        |> Repo.all()
        render(conn, "index.json", data: stickers, opts: [include: "sender"])

      false ->
        conn
        |> put_status(404)
        |> render(Reverie.ErrorView, "404.json")
    end
  end

  # NOTE: Only include when admin roles are implemented (if even)
  # def index(conn, _params) do
    # stickers = Repo.all(Sticker)
    # render(conn, "index.json", data: stickers)
  # end

  def create(conn, %{"data" => %{"type" => "stickers", "attributes" => sticker_params, "relationships" => relationships}}) do
    # Get the current user from the token, add it to changeset
    # Thus, the user doesn't provide an ID; it is inferred from the request
    current_user = Guardian.Plug.current_resource(conn)

    receiver = relationships
    |> build_receiver_relationship

    # Pass both sender and receiver IDs, use changeset for validation
    changeset = Sticker.changeset(%Sticker{sender_id: current_user.id, receiver_id: receiver.id}, sticker_params)

    case Repo.insert(changeset) do
      {:ok, sticker} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", sticker_path(conn, :show, sticker))
        |> render("show.json", data: sticker)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Reverie.ChangesetView, "error.json", changeset: changeset)
    end
  end

  # Works with id, and redundant sender relationship
  defp build_receiver_relationship(%{"receiver" => %{"data" => %{"type" => users, "id" => id}}, "sender" => _}) do
    receiving_user = Reverie.User
    |> where(id: ^id)
    |> Repo.one!

    receiving_user
  end

  # Show a certain sticker if it belongs to the user
  def show(conn, %{"id" => id}) do
    current_user = Guardian.Plug.current_resource(conn)

    sticker = Sticker
    |> where(receiver_id: ^current_user.id, id: ^id)
    |> Repo.one!

    render(conn, "show.json", data: sticker)
  end

  def update(conn, %{"id" => id, "data" => %{"id" => _, "type" => "sticker", "attributes" => sticker_params}}) do
    # NOTE: function not loaded in router; unsure whether someone
    # should edit a sticker.
    # Also, who would do it, the sender or receiver?
    current_user = Guardian.Plug.current_resource(conn)

    # Authorization backed by the database
    # if the query doesn't return a result (i.e. owner is not the current)
    # then a 404 is raised
    sticker = Sticker
    |> where(sender_id: ^current_user.id, id: ^id)
    |> Repo.one!

    changeset = Sticker.changeset(sticker, sticker_params)

    case Repo.update(changeset) do
      {:ok, sticker} ->
        render(conn, "show.json", data: sticker)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Reverie.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    # NOTE: currently only the receiver can delete a sticker
    # When we add authorization schemes, should admins do it too?
    current_user = Guardian.Plug.current_resource(conn)

    # Authorization backed by the database
    # if the query doesn't return a result (i.e. receiver is not the current)
    # then a 404 is raised
    sticker = Sticker
    |> where(receiver_id: ^current_user.id, id: ^id)
    |> Repo.one!

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(sticker)

    send_resp(conn, :no_content, "")
  end
end
