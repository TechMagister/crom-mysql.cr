# crom-mysql

MySQL adapter for CRystal Object Mapper

WIP

Warning: It does not create the table, for such work use an other tool like [micrate](https://github.com/juanedi/micrate)

## Features
[x] Insert Basic Object
[x] Update Basic Object
[x] Delete Basic Object
[x] Fetch by Id
[x] Aggregation support

## Installation


Add this to your application's `shard.yml`:

```yaml
dependencies:
  crom-mysql:
    github: TechMagister/crom-mysql.cr
```


## Usage

Because it's a WIP, see spec for more details.

```crystal
require "crom-mysql"

class User
  CROM.mapping(:mysql, {
    id:   {type: Int64, nilable: true},
    name: String,
    age:  Int32,
  })
end

class Users < CROM::MySQL::Repository(User)
end

crom = CROM.container("mysql://root@localhost/crom_spec")

users = Users.new crom

user = User.new(name: "Toto", age: 15)
user = users.insert(user)
id = user.id # not nil

```


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
