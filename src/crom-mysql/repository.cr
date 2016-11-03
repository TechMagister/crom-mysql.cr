require "query-builder"

module CROM::MySQL
  class Repository(T) < CROM::Repository(T)
    private def gateway
      container.gateway
    end

    private def builder
      b = Query::Builder.new
      b.table(T.dataset)
    end

    def do_insert(model : T)
      data = model.to_crom.to_h
      data.delete :id

      req = builder.insert(data)
      ret = gateway.insert( statement: req )

      if m = self[ret]
        model.from_crom m.to_crom
      end
    end

    def do_update(model : T)
      data = model.to_crom.to_h
      data.delete :id

      req = builder.where("id", model.id).update(data)
      ret = gateway.update( statement: req )

      if m = self[model.id]
        model.from_crom m.to_crom
      end
    end

    def do_delete(model : T)
      id = model.id
      req = builder.where("id", id).delete
      gateway.delete( statement: req)
    end

    def [](id)
      stmt = builder.where("id", "=", id).get
      ret = gateway.query(stmt)
      T.new_from_rs ret
    end

  end
end
