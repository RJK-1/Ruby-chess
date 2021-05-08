# frozen_string_literal: true

require 'yaml'

module SaveLoad
  def save_game
    puts "Saved"
    yaml = YAML::dump(self)
    file = File.open('Chess.yml', 'w') {|file| file.write  yaml.to_yaml}
    exit 
  end 

  def load_game
    data = File.open('Chess.yml', 'r') { |f| YAML.load(f) }
    game = YAML.load(data)
    puts 'Game loaded!'.green.bold
    game.play_game
  end
end