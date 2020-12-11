class Pokemon < ActiveRecord::Base

  PER_PAGE = 15
  MAX_LINEUP = 6
  
  def image_url
    if persisted?
      "https://pokeres.bastionbot.org/images/pokemon/#{pokemon_id}.png"
    else
      data.sprites.front_default
    end
  end

  def data
    @data ||= PokeApi.get(pokemon: name)
  end

  def pokemon_id
    data.id
  end

  def types
    data.types
  end








end
