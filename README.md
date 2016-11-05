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

To run spec, you should create a database named crom_spec and configure the URI in spec_helper.cr
```crystal
DB_URI = "mysql://root@localhost/crom_spec"
```

Create the following tables :
```sql
CREATE TABLE `user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
);
CREATE TABLE `book` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `author_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`)
);
CREATE TABLE `author` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
)
```

## Contributing

1. Fork it ( https://github.com/TechMagister/crom-mysql.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [TechMagister](https://github.com/TechMagister) Arnaud Fernandés - creator, maintainer
