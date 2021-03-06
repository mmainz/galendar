defmodule Galendar.Router do
  use Galendar.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Plugs.GithubAuth
  end

  pipeline :public do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Galendar do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/", Galendar do
    pipe_through :public

    get "/auth/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", Galendar do
  #   pipe_through :api
  # end
end
