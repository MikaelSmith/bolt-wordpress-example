# Wordpress install with Bolt

Install dependencies
```
bundle install
bundle exec bolt puppetfile install
```

Generate password (will use password in data/common.yaml if skipped)
```
bundle exec eyaml createkeys
bundle exec eyaml encrypt -l 'wordpress_example::mysql_password' -s $(date | md5sum) -o block > data/secret.eyaml
```

Run
```
bundle exec bolt plan run wordpress_example --boltdir . --nodes <nodes>
```

