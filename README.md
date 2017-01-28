# Knife bento

![Alt text](images/tampopo.gif?raw=true)

Knife bento is an opinionated knife plugin for managing Hashicorp vault secrets the "chef" way! This is the tool for you if you want to migrate from using chef encrypted databags to Hashicorp vault.

Vault was set to be deterministic and to follow CRUD semantics. This means that we cannot append text to a value, we need to read first, modify and then write.

Also chef databags json and vault json are not managed the same way. With chef you can add/modify a databag item with json and the field "id" will be the item name, with vault the first item of you json file will be key and the rest of your json will populate the value field.

* it allows you to manage vault secret the same way as chef databags (see Usage)
* it uses vault-ruby library
* it is 100% vault compliant
* it is 100% chef compliant

## Installation
### Build and install gem
```
clone the repository
gem build knife-bento.gemspec
gem install knife-bento --local
```
### Add to knife.rb
```
# required
knife[:vault_address] = 'http://0.0.0.0:8200'
knife[:vault_token] = 'myroot'

# optional
knife[:vault_ssl_pem_file] = '/tmp/test'
knife[:vault_ssl_verify] = 'true'
knife[:vault_timeout] = '30'
knife[:vault_ssl_timeout] = '5'
knife[:vault_open_timeout] = '5'
knife[:vault_read_timeout] = '30'
```


## Usage
### Show
knife bento show DATABAG [ITEM]
knife bento show db_users
knife bento show db_users username

### Edit
knife bento edit DATABAG ITEM
knife bento show db_users username

### Edit from file
knife bento from file DATABAG FILE
knife bento from file db_users ./user_test.json

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D
