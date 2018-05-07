defmodule ChatApiWeb.AuthView do
  use ChatApiWeb, :view
  alias ChatApiWeb.AuthView

  def render("user.json", %{user: user, token: token}) do
    %{
      id: user.id,
      name: user.name,
      token: token
    }
  end

  def render("me.json", %{user: user}) do
    %{
      id: user.id,
      name: user.name
    }
  end

  def render("logout.json", _params) do
    %{
    }
  end
end
