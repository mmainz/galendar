defmodule Galendar.PageController do
  use Galendar.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
