#!/usr/bin/env ruby

require 'json'

module TokenManager
  extend self

  TOKEN_DIR = File.dirname(File.symlink?(__FILE__) ? File.readlink(__FILE__) : __FILE__)
  TOKEN_FILE = File.join(TOKEN_DIR, '.access_tokens')

  def execute(*args)
    send(args[0], *args[1..-1])
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

  def prep_token_file
    `touch #{TOKEN_FILE}`
  end
end

TokenManager.execute *ARGV
