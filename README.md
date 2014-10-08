# AlipayAOP

Alipay AOP is an unofficial API wrapper for Alipay Open Platform.

## Installation

Add this line to your application's Gemfile:

    gem 'alipay_aop'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install alipay_aop

## Usage

### 1. create a client
```ruby
include AlipayAOP

server_key = ServerKey.create_from_file('xxx_public.pem')
client_key = ServerKey.create_from_file('xxx_private.pem')

client = Client.new(:server_key => server_key,
                    :client_key => client_key,
					:app_id     => '2014070100171523')
```

### 2. register gateway

TODO

### 3. invoke Alipay OpenAPI(s)

TODO


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
