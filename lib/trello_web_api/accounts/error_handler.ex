defmodule TrelloWebApi.Accounts.ErrorHandler do
  import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {_type, _reason}, _opts) do
    send_resp(conn, 403, Phoenix.Controller.status_message_from_template("403"))
  end
end
