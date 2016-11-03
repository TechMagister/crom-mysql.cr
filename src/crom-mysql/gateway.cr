module CROM::MySQL
  class Gateway < CROM::Gateway
    def initialize(@uri : URI, **options)
    end

    def insert(**args)
      ret = with_db { exec args[:statement] }
      return ret.last_insert_id
    end

    def update(**args)
      ret = with_db { exec args[:statement] }
    end

    def delete(**args)
      ret = with_db { exec args[:statement] }
    end

    def query(statement)
      with_db { query statement }
    end

    def exec(statement)
      with_db { exec statement }
    end

    def count(dataset)
      with_db { scalar "SELECT COUNT(*) FROM #{dataset}" }
    end

    private def with_db(&block)
      with DB.open(@uri) yield
    end
  end
end

CROM.register_adapter("mysql", CROM::MySQL::Gateway)
