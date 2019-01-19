# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :chat_api,
       ecto_repos: [ChatApi.Repo]

# Configures the endpoint
config :chat_api,
       ChatApiWeb.Endpoint,
       url: [
         host: "localhost"
       ],
       secret_key_base: "9BYia9NfhX/LdvJH/IS7eH5Lrxs/RUyYNeRlwRSypOi7gPQruYf4RIAuxiBWQ1VL",
       render_errors: [
         view: ChatApiWeb.ErrorView,
         accepts: ~w(html json)
       ],
       pubsub: [
         name: ChatApi.PubSub,
         adapter: Phoenix.PubSub.PG2
       ]

# Configures Elixir's Logger
config :logger,
       :console,
       format: "$time $metadata[$level] $message\n",
       metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :guardian,
       Guardian,
       allowed_algos: ["HS512"],
         # optional
       verify_module: Guardian.JWT,
         # optional
       issuer: "chat_api",
       ttl: {30, :days},
       allowed_drift: 2000,
       verify_issuer: true,
         # optional
       secret_key: "ednkXywWll1d2svDEpbA39R5kfkc9l96j0+u7A8MgKM+pbwbeDsuYB8MP2WUW1hf",
         # Insert previously generated secret key!
       serializer: ChatApi.Auth.GuardianSerializer


config :ueberauth,
       Ueberauth,
       providers: [
         facebook: {Ueberauth.Strategy.Facebook, []},
         google: {Ueberauth.Strategy.Google, []}
       ]

config :ueberauth,
       Ueberauth.Strategy.Facebook.OAuth,
       client_id: System.get_env("FACEBOOK_CLIENT_ID"),
       client_secret: System.get_env("FACEBOOK_CLIENT_SECRET")

config :ueberauth,
       Ueberauth.Strategy.Google.OAuth,
       client_id: System.get_env("GOOGLE_CLIENT_ID"),
       client_secret: System.get_env("GOOGLE_CLIENT_SECRET")

config :web_push_encryption,
       :vapid_details,
       subject: "viva.la.akam@gmail.com",
       public_key: System.get_env("VAPID_PUBLIC_KEY"),
       private_key: System.get_env("VAPID_PRIVATE_KEY")
