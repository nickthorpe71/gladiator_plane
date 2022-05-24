# GladiatorPlane

## Ecto Commands

### General
**mix ecto.drop** - wipe database
**mix ecto.create** - create new instance of database from scratch using /config/config.exs
**mix ecto.migrate** - run all migrations in /priv/repo/migrations to create tables etc.


### Read

**Repo.get({Schema}, id)**
- requires aliasing the repo and the schema
    - ex:
        - alias GladiatorPlane.Repo
        - alias GladiatorPlane.Warrior

**Repo.all(query)**
- to get an entire table you can alias the schema and use the query below
    - alias GladiatorPlane.Warrior
    - query = from(Warrior)
- this would get every record from the warrior table using the Warrior schema
