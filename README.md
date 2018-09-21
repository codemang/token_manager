Token Manager
=============

This is a ruby plugin which  manages tokens on a machine.

## Reason For Building

I've built a number of utility scripts for interacting with 3rd party services,
such as Github, Slack, or CircleCI. These utilities require the use of API
tokens. Originally I'd store these tokens in a dotfile, so that they can be
shared amongst scripts. However, reading tokens from a file became cumbersome.
Now I can easily shell out and read the tokens via the Token Manager

#### Ruby Example

```ruby
  def slack_api_call
    slack_token = `token_manager read slack_token`
    ...
  end
```

## Installation

1. Copy the `main.rb` file to a location on your machine
2. Symlink the script to `/usr/local/bin`

```
$ ln -s /path/to/main.rb /usr/local/bin/token_manager
```

Now you can call `token_manager` from the command line

## How To Use

#### Add a token

```
$ token_manager add token_name token_value
```

#### Remove a token

```
$ token_manager remove token_name
```

#### Read a token

```
$ token_manager read token_name
```

#### List all tokens

```
$ token_manager list
```

## Token Storage

* Tokens are stored in a dotfile in the same directory as the plugin script.

* tokens are not encrypted when stored.
