# TUT Lecture Bot

*Unofficial* Twitter Bot for Reminding TUT Lectures

## Twitter URL

* bachelor:
https://twitter.com/tut_lecture_b
* master and doctor:
https://twitter.com/tut_lecture_m

\* *We cannot guarantee the validity of the information found there.*

## Setup

```zsh
### install dependencies
$ bundle install

### create database file
$ bundle exec ruby create_database.rb

### edit settings
$ cp settings.rb.sample settings.rb
$ vi settings.rb
```

### Run

```zsh
$ bundle exec ruby -r ./settings.rb tut_lecture_bot.rb
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tatzyr/tut_lecture_bot.


## Licence

See [LICENSE](LICENSE).
