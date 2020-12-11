class PokemonsController < ApplicationController
  before_action :set_pokemon, only: [:show, :edit, :update, :destroy]

  def index
    @page = params[:page].to_i || 0

    if params[:type].present?
      @all_pokemons = PokeApi.get(type: params[:type]).pokemon
      _start = @page * Pokemon::PER_PAGE
      _end = (@page + 1) * Pokemon::PER_PAGE
      @pokemons = @all_pokemons[_start.._end - 1].collect {|x| x.pokemon.name}
    else
      @pokemons = PokeApi.get(pokemon: {limit: Pokemon::PER_PAGE, offset: Pokemon::PER_PAGE * @page}).results.collect{|x| x.name}
    end

    load_pokemon_types
  end

  def load_by_types
    @pokemons = PokeApi.get(type: params[:type]).pokemon[0..Pokemon::PER_PAGE - 1].collect {|x| x.pokemon.name}
  end

  def new
    @pokemon = Pokemon.new
  end

  def edit
  end

  def create
    if Pokemon.count < Pokemon::MAX_LINEUP
      @pokemon = Pokemon.find_or_create_by!(name: params[:name])
    end
  end

  def update
    @pokemon.update(pokemon_params)

  end

  def destroy
    @pokemon.destroy
    respond_to do |format|
      format.html { redirect_to pokemons_url, notice: 'Pokemon was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_pokemon
      @pokemon = Pokemon.find(params[:id])
    end

    def pokemon_params
      params.fetch(:pokemon, {}).permit(:nickname)
    end

    def load_pokemon_types
      @pokemon_types = PokeApi.get(:type).results.collect(&:name)
    end
end
