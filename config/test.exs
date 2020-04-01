# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
import Config

config :logger, level: :info

config :tesla, Afterbuy.Tesla.Client,
  adapter: Tesla.Mock,
  base_url:
    fn env, _ ->
      env.body.global.call_name
    end
