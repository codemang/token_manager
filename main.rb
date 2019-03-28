#!/usr/bin/env ruby

require 'json'

module TokenManager
  extend self

  TOKEN_DIR = File.dirname(File.symlink?(__FILE__) ? File.readlink(__FILE__) : __FILE__)
  TOKEN_FILE = File.join(TOKEN_DIR, '.access_tokens')

  def execute(*args)
    if args[0].nil?
      print_help_message
    else
      begin
        send(args[0], *args[1..-1])
      rescue NoMethodError => e
        puts "Command line option '#{args[0]}' is not recognized"
        print_help_message
      rescue ArgumentError
        if args[0] == 'add'
          puts 'ERROR: You must supply the name of the token and the value of the token you want to add. For example...'
          puts '$ token_manager add token_name token_value'
        elsif args[0] == 'remove'
          puts 'ERROR: You must supply the name of the token you want to remove. For example...'
          puts '$ token_manager remove token_name'
        elsif args[0] == 'list'
        elsif args[0] == 'read'
          puts 'ERROR: You must supply the name of the token you want to read. For example...'
          puts '$ token_manager read token_name'
        end
      end
    end
  end

  private

  def source
    tokens.each { |token, value| `EXPORT #{token}=#{value}` }
  end

  def list
    puts "You have #{tokens.keys.count} local tokens"
    tokens.each do |name, value|
      puts "* #{name}"
    end
  end

  def read(name)
    unless tokens.keys.include?(name)
      puts "There is no token named '#{name}'"
      exit 1
    end
    # Use print instead of puts to avoid new lines
    print tokens[name]
  end

  def add(name, value)
    if tokens.keys.include?(name)
      puts "You already have an access token named '#{name}'"
      exit 1
    end
    save_tokens(tokens.merge(name => value))
  end


  def remove(name)
    unless tokens.keys.include?(name)
      puts "There is no token named '#{name}'"
      exit 1
    end
    tokens.delete(name)
    save_tokens(tokens)
  end

  private

  def save_tokens(tokens)
    prep_token_file
    File.open(TOKEN_FILE, 'w') do |f|
      f.write(tokens.to_json)
    end
    @tokens = tokens
  end

  def tokens
    @tokens ||= begin
      prep_token_file
      tokens = File.read(TOKEN_FILE)
      tokens.empty? ? {} : JSON.parse(tokens)
    end
  end

  def print_help_message
    puts 'You must supply one of the following command line options'
    puts '* add'
    puts '* remove'
    puts '* read'
    puts '* list'
  end

  def prep_token_file
    `touch #{TOKEN_FILE}`
  end
end

TokenManager.execute *ARGV
