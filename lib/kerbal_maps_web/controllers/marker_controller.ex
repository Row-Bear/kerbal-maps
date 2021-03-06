defmodule KerbalMapsWeb.MarkerController do
  @moduledoc """
  The Marker controller.
  """

  use KerbalMapsWeb, :controller

  alias KerbalMaps.Symbols
  alias KerbalMaps.Symbols.Marker

  def index(conn, _params) do
    markers = Symbols.list_markers_for_user(conn.assigns[:current_user])
    render(conn, "index.html", markers: markers)
  end

  def new(conn, _params) do
    changeset = Symbols.change_marker(%Marker{})
    render(conn, "new.html", changeset: changeset, icon_options: icon_options())
  end

  def create(conn, %{"marker" => marker_params}) do
    case Symbols.create_marker(marker_params) do
      {:ok, _marker} ->
        conn
        |> put_flash(:info, "Marker created successfully.")
        |> redirect(to: Routes.marker_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    marker = Symbols.get_marker!(id)
    changeset = Symbols.change_marker(marker)
    render(conn, "edit.html", marker: marker, changeset: changeset, icon_options: icon_options())
  end

  def update(conn, %{"id" => id, "marker" => marker_params}) do
    marker = Symbols.get_marker!(id)

    case Symbols.update_marker(marker, marker_params) do
      {:ok, _marker} ->
        conn
        |> put_flash(:info, "Marker updated successfully.")
        |> redirect(to: Routes.marker_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", marker: marker, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    marker = Symbols.get_marker!(id)
    {:ok, _marker} = Symbols.delete_marker(marker)

    conn
    |> put_flash(:info, "Marker deleted successfully.")
    |> redirect(to: Routes.marker_path(conn, :index))
  end

  defp icon_options do
    [
      "Point of interest": ~S({"prefix":"fa","name":"fa-info"})
    ]
  end
end
