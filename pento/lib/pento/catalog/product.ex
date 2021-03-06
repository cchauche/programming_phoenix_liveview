defmodule Pento.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :description, :string
    field :name, :string
    field :sku, :integer
    field :unit_price, :float

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :unit_price, :sku])
    |> validate_required([:name, :description, :unit_price, :sku])
    |> validate_number(:unit_price, greater_than: 0.0)
    |> unique_constraint(:sku)
  end

  @doc """
  Use this changeset when you want to reduce the price of a product.
  """
  def reduce_price_changeset(%__MODULE__{unit_price: current_price} = product, attrs) do
    product
    |> cast(attrs, [:unit_price])
    |> validate_number(:unit_price, less_than: current_price)
    |> validate_number(:unit_price, greater_than: 0.0)
  end
end
