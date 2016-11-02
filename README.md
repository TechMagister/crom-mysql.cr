# crom-mysql

MySQL adapter for CRystal Object Mapper

## Installation


Add this to your application's `shard.yml`:

```yaml
dependencies:
  crom-mysql:
    github: TechMagister/crom-mysql.cr
```


## Usage


```crystal
require "crom-mysql"

class User
  CROM.mapping(:mysql, {
    id:   {type: Int64, nilable: true},
    name: String,
    age:  Int32,
  })
end

class Users < CROM::Repository(User)
end

crom = CROM.container("mysql://root@localhost/crom_spec")

users = Users.new crom

user = User.new(name: "Toto", age: 15)
user = users.insert(user)
user.id

```


TODO: Write usage instructions here

## Development

TODO: Write development instructions here

## Contributing

1. Fork it ( https://github.com/TechMagister/crom-mysql.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [TechMagister](https://github.com/TechMagister) Arnaud Fernandés - creator, maintainer
