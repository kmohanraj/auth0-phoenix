defmodule AppWeb.Router do
  use AppWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :protected do
    plug(
      Guardian.Plug.Pipeline,
      otp_app: :app,
      module: App.Guardian,
      error_handler: App.AuthErrorHandler
    )

    plug(Guardian.Plug.VerifyHeader, realm: "Bearer")
    plug(Guardian.Plug.EnsureAuthenticated)
    plug(Guardian.Plug.LoadResource)
  end

  scope "/v1", AppWeb do
    pipe_through(:api)

    post("/auth/sign_in", UserController, :sign_in)
    post("/auth/sign_up", UserController, :sign_up)
  end

  scope "/v1", AppWeb do
    pipe_through([:api, :protected])

    resources("/users", UserController)
  end
end
