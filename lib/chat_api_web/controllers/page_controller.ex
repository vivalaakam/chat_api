defmodule ChatApiWeb.PageController do
  use ChatApiWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def terms(conn, _params) do
    render conn, "terms.html"
  end
end
