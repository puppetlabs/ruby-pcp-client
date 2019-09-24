# pcp-client (unmaintained)

This library provides a client library for the [Puppet Communications Protocol](https://github.com/puppetlabs/pcp-specifications) wire protocol version 1.

The library is not expected to receive any future updates beyond those necessary for its role in testing other components. Notably it does not support PCP v2.

## Basic Usage

```sh
gem install pcp-client
```

To connect to a broker and send and receive messages:

```ruby
require 'pcp/client'

# Start the eventmachine reactor in its own thread
Thread.new { EM.run }
Thread.pass until EM.reactor_running?

client = PCP::Client.new({:server => 'wss://localhost:8142/pcp',
                          :ssl_key => 'test-resources/ssl/private_keys/client01.example.com.pem',
                          :ssl_cert => 'test-resources/ssl/certs/client01.example.com.pem',
                          :ssl_ca_cert => 'test-resources/ssl/ca/ca_crt.pem'})

client.on_message = proc do |message|
  puts "Get message: #{message.inspect}"
end

client.connect

message = PCP::Message.new({:message_type => 'example/ping',
                            :targets => ['pcp://*/example-agent']})

message.expires(3)
client.send(message)

# Hang around and see what responses we get back
sleep(10)
```


A matching agent that would respond to this may look like this:

```ruby
require 'pcp/client'

# Start the eventmachine reactor in its own thread
Thread.new { EM.run }
Thread.pass until EM.reactor_running?

client = PCP::Client.new({:server => 'wss://localhost:8142/pcp',
                          :ssl_key => 'test-resources/ssl/private_keys/client02.example.com.pem',
                          :ssl_cert => 'test-resources/ssl/certs/client02.example.com.pem',
                          :ssl_ca_cert => 'test-resources/ssl/ca/ca_crt.pem',
                          :type => 'example-agent'})

# Set up on_message handler
client.on_message = proc do |message|
  puts "Got message #{message.inspect}"
  if message[:message_type] == 'example/ping'
    response = PCP::Message.new({:message_type => 'example/pong',
                                 :targets => [message[:sender]]})
                                 
    response.expires(3)
    client.send(response)
  end
end

# connect
client.connect

# wait forever for work
loop do end
```

There's a more extended example of this which makes more use of
PCP/PXP features in bin/pcp-ping.

## Options

`PCP::Client` takes several additional options:

* `logger` - specify a logging target extending the Logger class
* `loglevel` - specify one of the levels supported by the Logger class
* `on_message` - specify an `on_message` handler during construction
* `max_message_size` - change the limit on maximum incoming message size (defaults to 64MiB)

## Testing

```sh
bundle install
bundle exec rspec spec
```


## Maintenance

Contributing: Please refer to [this](CONTRIBUTING.md) document.

Tickets: File bug tickets at https://tickets.puppet.com/browse/PCP and add the
`ruby-pcp-client` component to the ticket.
