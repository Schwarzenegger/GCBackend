# GC Backend

* Ruby 2.5.5

* Rails 5.2.3

* Postgres


## Installation on Mac

### Homebew

First install xcode and its dependencies

After that

```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Validate installation with

```
brew doctor
```

### RVM

To install RVM

```
curl -sSL https://get.rvm.io | bash
```

If you use fish

```
curl -L --create-dirs -o ~/.config/fish/functions/rvm.fish https://raw.github.com/lunks/fish-nuggets/master/functions/rvm.fish

echo "rvm default" >> ~/.config/fish/config.fish
```

### Ruby

To install ruby

```
rvm install ruby 2.5.5
```

### Postgres

To install postgres with homebrew just run

```
brew uninstall --force postgresql

rm -rf /usr/local/var/postgres

brew install postgres
```


## Running the project

Last but no least, lets run the project

```
cp config/database.yml.example config/database.yml
```

And edit the files to correspond to your configurations

```
rake db:create
rake db:migrate
```

and finally run the project with

```
rails s
```
