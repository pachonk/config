#! /usr/bin/env ruby
class Dotfile
  attr_reader :filename
  IGNORED_DOTFILES =  %w( . .. .git .travis.yml).freeze
  
  def initialize(filename)
    @filename = filename
  end

  def self.link_path!(path)
    Dir.glob(File.join(path, '.*'))
       .map{ |filename| Dotfile.new(File.basename(filename)) }
       .each { |dotfile| dotfile.link! }
  end

  def ignored?
    IGNORED_DOTFILES.include?(filename)
  end

  def link!
    if ignored?
      return false
    end

    if File.exists? link_path
      puts "File or symlink located at #{link_path} already exists. Please delete it and re-run to re-link."
      return false
    end

    File.symlink(full_path, link_path)
  end

  def full_path
    "#{ENV['HOME']}/.dotfiles/#{filename}"
  end

  def link_path
     "#{ENV['HOME']}/#{filename}"
  end
end

Dotfile.link_path!("#{ENV['HOME']}/.dotfiles/")

