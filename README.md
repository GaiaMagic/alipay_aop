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

On rails, it is recommended to create file `config/alipay_aop.yml`
with content like:

    app_id: 2014042900005397
    private_key_file: config/alipay_aop_private_key.pem
    public_key_file:  config/alipay_aop_public_key.pem

**Notice:** `public_key_file` should be the public key of alipay. And `private_key_file` should be the private key of your server. *You don't need to specify your public key file*.

Then set up your controller like below:

```ruby
    # app/controllers/my_controller.rb

    class MyController < ApplicationController
      alipay_aop_responder
	  handle_verfiygw_event   # automatically handle verifygw event

      # ping
	  on :text, with: 'ping', respond: 'pong'

      # pattern matching
	  on :text, with: /^[0-9]+$/, respond: 'i got an awesome number'

      # echo
	  on :text do |request|
	    request.reply.text(request.text)
	  end

	  # download images the user sent
	  on :image do |request|
	    media = request.media
	    File.open('/tmp/t66y.#{media.type}', 'w') do |f|
		  f.write(media.content)
		end
	  end

	  # handle event (usually menu event)
	  on :event, :where_am_i_from do |request|
	    request.reply.text("you are from #{request.from_user.location.city}")
	  end

      # handle all events
	  on :event do |request|
	    request.reply.text('you triggered an event, ' +
		                   'but I am tired dealing with it')
	  end

      # fall back mode
	  on :fallback do |request|
		request.reply.text('你發過來噶係乜鬼嘢啊！')
	  end
	end
```

Possible handler types: `%i[image text event fallback]`.
Handling the same action for multiple times will disable the later ones.


Methods of `request`:

  - `service :: String` e.g. `alipay.mobile.public.message.notify`
  - `from_user :: User`
  - `create_time :: Time`
  - `user_info :: Hash`
  - `text :: String` only for text message
  - `image :: Media` only for image message
  - `biz_content_raw :: String`
  - `msg_type :: String`
  - `event_type :: String` only for event
  - `app_id :: String`
  - `msg_id :: String`
  - ...

See https://fuwu.alipay.com/platform/doc.htm#c03 for more information.


Additionally, there are other bunch of things you can play with, for example:

```ruby
    # lib/tasks/alipay_aop_tasks.rb

	namespace 'alipay_aop'
	  task 'menu_create' do
	    AlipayAOP.api.create_menu(YAML.load('config/alipay_aop_menu.yml'))
	  end

	  task 'menu_update' do
	    AlipayAOP.api.update_menu(YAML.load('config/alipay_aop_menu.yml'))
	  end

	  task 'menu_get' do
	    File.open('config/alipay_aop_menu.yaml', 'w') do |f|
		  f.puts(YAML.dump(AlipayAOP.api.menu))
		end
	  end
    end
```

Have fun :)


## Acknowledgement

* [skinnyworm/wechat-rails](https://github.com/skinnyworm/wechat-rails)
the design of this library largely referred to wechat-rails.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
