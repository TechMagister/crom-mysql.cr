module CROM::MySQL
  class Adapter < CROM::Adapter
    def initialize(@uri : URI, **options)
    end

    def insert(model, namedtuple)
      args = [] of DB::Any
      namedtuple.each { |key, val| args << val unless key == :id }

      sql_fields = namedtuple.keys.map { |key| key.to_s unless key == :id }.to_a.compact.join(",")
      sql_placeholders = (["?"] * (namedtuple.size - 1)).join(",")

      statement = String.build do |stmt|
        stmt << "INSERT INTO #{model.dataset} ("
        stmt << sql_fields
        stmt << ") VALUES ("
        stmt << sql_placeholders
        stmt << ");"
      end
      ret = with_db { exec statement, args }
      return fetch(model, ret.last_insert_id)
    end

    def update(model, namedtuple)
    end

    def delete(model, namedtuple)
      statement = String.build do |stmt|
        stmt << "DELETE FROM #{model.dataset} "
        stmt << "WHERE id=?"
      end
      with_db { exec statement, namedtuple[:id] }
    end

    def fetch(model, criteria)
      if criteria.is_a? Number
        statement = String.build do |stmt|
          stmt << "SELECT "
          stmt << "#{model.dataset}.*"
          stmt << " FROM #{model.dataset}"
          stmt << " WHERE id=? LIMIT 1"
        end
        ret = with_db { query statement, criteria }
        return model.new_from_rs ret
      end
    end

    private def with_db(&block)
      with DB.open(@uri) yield
    end

    private def sql_type_for(v)
      case v
      when String.class                ; "VARCHAR(255)"
      when Int32.class                 ; "INT"
      when Int64.class                 ; "BIGINT"
      when Float32.class, Float64.class; "DOUBLE"
      when Time.class                  ; "DATETIME"
      else
        raise "not implemented for #{v}"
      end
    end
  end
end

CROM.register_adapter("mysql", CROM::MySQL::Adapter)
