# Knife bento

Knife bento is an opinionated knife plugin for managing Hashicorp vault secrets the "chef" way.

* it allow DevOps to manage vault secret the same way as chef databags
* it uses vault-ruby library
* it is 100% vault compliant
* it is 100% chef compliant

## Installation

TODO: Describe the installation process

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

## History

TODO: Write history

## Credits

TODO: Write credits

## License

TODO: Write license
