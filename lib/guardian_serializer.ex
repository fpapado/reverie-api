defmodule Reverie.GuardianSerialiser do
    @behaviour Guardian.Serializer

    alias Reverie.Repo
    alias Reverie.User

    def for_token(user = %User{}) do
        { :ok, "User:#{user.id}" }
    end
    def for_token(_) do
        { :error, "Unknown resource type" }
    end

    def from_token("User" <> id) do
        { :ok, Repo.get(User, id) }
    end
    def from_token(_) do
        { :error, "Unknown resource type" }
    end
end
