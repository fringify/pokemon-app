class AddFieldsToPokemon < ActiveRecord::Migration
  def change
    add_column :pokemons, :nickname, :string
  end
end
