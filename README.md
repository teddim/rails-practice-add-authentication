# Setup

* Clone this repo into workspace
* cd into this repo
* `bundle`
* `rake db:create db:migrate db:seed`
* `rails s -p 3012`
* Open http://localhost:3012

## Add authentication

Create a file named `app/models/user.rb` with the following contents:

```ruby
class User < ActiveRecord::Base

  validates :email, presence: true, uniqueness: true
  has_secure_password

end
```

Uncomment the `gem 'bcrypt'` line in `Gemfile` then
run `bundle` (and restart your rails server if it's running).

In Terminal, run
* `rails g migration create_users email:string password_digest:string`
* `rake db:migrate`

---

Add the following to `config/routes.rb`:

```ruby
get '/sign-up' => 'registrations#new', as: :signup
post '/sign-up' => 'registrations#create'
get '/sign-in' => 'authentication#new', as: :signin
post '/sign-in' => 'authentication#create'
get '/sign-out' => 'authentication#destroy', as: :signout
```

Run `rake routes` and make sure the output looks OK (not an error).

---

Add the following to `app/controllers/application_controller.rb`

```ruby
def current_user
  User.find_by(id: session[:user_id])
end

helper_method :current_user
```

Add the following to `app/views/layouts/application.html.erb` above the `yield` line:

```
<div>
  <% if current_user %>
    <%= link_to "Sign Out", signout_path %>
  <% else %>
    <%= link_to "Sign Up", signup_path %>
    |
    <%= link_to "Sign In", signin_path %>
  <% end %>
</div>
```

You should now see two links appear in your browser.

---

Click on "Sign up".

Create a controller named `app/controllers/registrations_controller.rb` with the following contents:

```ruby
class RegistrationsController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(params.require(:user).permit(:email, :password, :password_confirmation))
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path
    else
      render :new
    end
  end

end
```

Add a view named `app/views/registrations/new.html.erb` with the following contents:

```
<h1>Sign Up</h1>

<%= form_for @user, url: signup_path do |f| %>

  <% if @user.errors.present? %>
    <ul>
      <% @user.errors.full_messages.each do |message| %>
        <li><%= message %></li>
      <% end %>
    </ul>
  <% end %>

  <div>
    <%= f.label :email %>
  </div>
  <div>
    <%= f.email_field :email %>
  </div>

  <div>
    <%= f.label :password %>
  </div>
  <div>
    <%= f.password_field :password %>
  </div>

  <div>
    <%= f.label :password_confirmation %>
  </div>
  <div>
    <%= f.password_field :password_confirmation %>
  </div>

  <div>
    <%= f.submit "Sign up" %>
  </div>

<% end %>
```

You should be able to sign up now in your browser.

---

Click on the "Sign out" link.

Create a controller named `app/controllers/authentication_controller.rb` with the following contents:

```ruby
class AuthenticationController < ApplicationController

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path
    else
      @sign_in_error = "Username / password combination is invalid"
      render :new
    end
  end

  def destroy
    session.clear
    redirect_to root_path
  end

end
```

---

Click the "Sign in" link.

Create a view named `app/views/authentication/new.html.erb` with the following contents:

```
<h1>Sign In</h1>

<%= form_tag signin_path do |f| %>

  <% if @sign_in_error %>
    <p>
      <%= @sign_in_error %>
    </p>
  <% end %>

  <div>
    <%= label_tag :email %>
  </div>
  <div>
    <%= email_field_tag :email %>
  </div>

  <div>
    <%= label_tag :password %>
  </div>
  <div>
    <%= password_field_tag :password %>
  </div>

  <div>
    <%= submit_tag "Sign in" %>
  </div>

<% end %>
```
