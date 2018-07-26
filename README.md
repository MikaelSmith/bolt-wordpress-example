# Wordpress install with Bolt

Install dependencies
```
bundle install
bundle exec bolt puppetfile install
```

Run
```
bundle exec bolt plan run wordpress_example --boltdir . --nodes <nodes>
```

