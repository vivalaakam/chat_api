defmodule ChatApiWeb.Router do
  use ChatApiWeb, :router

  require Ueberauth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
  end

  pipeline :auth do
    plug :accepts, ["json", "json-api"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
    plug JaSerializer.Deserializer  end

  pipeline :csrf do
    plug :put_secure_browser_headers
    plug :protect_from_forgery
  end

  pipeline :api do
    plug :accepts, ["json", "json-api"]
  end

  scope "/", ChatApiWeb do
    pipe_through [:browser, :api] # Use the default browser stack

    get "/", PageController, :index
    get "/terms", PageController, :terms
    post "/auth_fb", AuthController, :auth_fb
    delete "/logout", AuthController, :logout

    pipe_through [:csrf]

    get "/auth/:provider", AuthController, :request
    post "/auth/identity/callback", AuthController, :identity_callback
    get "/auth/:provider/callback", AuthController, :callback

    pipe_through [:auth]
    get "/me", AuthController, :me


  end

  scope "/api", ChatApiWeb do
    pipe_through [:browser, :api, :auth]
    resources "/users", UserController, except: [:new, :edit]
    post "/chats/:id/message", ChatController, :message
    get "/chats/:id/messages", ChatController, :messages
    resources "/chats", ChatController, except: [:new, :edit]
    resources "/subscription", UserSubscriptionController, except: [:new, :edit]
  end

  # Other scopes may use custom stacks.
  # scope "/api", ChatApiWeb do
  #   pipe_through :api
  # end
end
