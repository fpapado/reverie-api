defmodule Reverie.ChangesetView do
    use Reverie.Web, :view

    @doc """
      Traverses and translates changeset errors.
      See `Ecto.Changeset.traverse_errors/2` and
      `Reverie.ErrorHelpers.translate_error/1` for more details.
      """
      def translate_errors(changeset) do
        Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
      end

      def render("error.json", %{changeset: changeset}) do
        # When encoded, the changeset returns its errors
        # as a JSON object, so we just pass it forward.
        JaSerializer.EctoErrorSerializer.format(changeset)
    end
end
