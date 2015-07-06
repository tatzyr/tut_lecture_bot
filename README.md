# TUT Lecture Bot

*Unofficial* Twitter Bot for Reminding TUT Lectures

## URL

* bachelor:
https://twitter.com/tut_lecture_b
* master and doctor:
https://twitter.com/tut_lecture_m

\* *We cannot guarantee the validity of the information found there.*


## Installation

### Download

```
$ git clone https://github.com/Tatzyr/tut_lecture_bot.git
```

### Initial Setup

```
$ cd tut_lecture_bot
$ mv settings.yml.sample settings.yml
$ vi settings.yml
$ bundle install
$ bundle exec ruby migration.rb
```

### Run

```
$ bundle exec ruby tut_lecture_bot.rb
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tatzyr/tut_lecture_bot.


## Licence

See [LICENSE](LICENSE).
