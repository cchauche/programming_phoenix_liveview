defmodule Pento.Repo.Migrations.AddUserName do
  use Ecto.Migration

  def change do
    alter table("users") do
      add(:username, :citext,
        null: false,
        default: "username"
      )
    end

    create(unique_index("users", [:username]))
  end
end
