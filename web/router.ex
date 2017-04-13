defmodule Reverie.Router do
  use Reverie.Web, :router

  # Unauthenticated requests
  pipeline :api do
    plug :accepts, ["json", "json-api"]
  end

  # Authenticate requests
  # We first ensure that the token is signed by this server
  # We also extract the user from the JWT
  pipeline :api_auth do
    plug :accepts, ["json", "json-api"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  # Admin-only plug
  pipeline :admin_required do
    plug :accepts, ["json", "json-api"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
    plug Reverie.CheckAdmin
  end

  # Unauthenticated scope
  scope "/api", Reverie do
    pipe_through :api

    # Registration
    post "/register", RegistrationController, :create
    # Login; JWT token provision
    post "/token", SessionController, :create, as: :login
  end

  # Authenticated scope
  scope "/api", Reverie do
    pipe_through :api_auth

    # Users
    get "/users/current", UserController, :current, as: :current_user
    resources "/users", UserController, only: [:show, :index] do
      get "/stickers", StickerController, :index, as: :stickers
    end

    # New and Edit are not used in APIs;
    # Update is excluded for now (see note in sticker_controller.ex)
    resources "/stickers", StickerController, except: [:new, :edit, :update]

    # Categories
    # Only :show, :index are included; might consider :update, :delete
    resources "/categories", CategoryController, only: [:show, :index]
  end
end
