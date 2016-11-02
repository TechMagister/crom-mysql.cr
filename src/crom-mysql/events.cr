module CROM::MySQL
  
  module Events
    def after_delete()
      @id = nil
    end

    def after_insert(id)
      @id = id
    end
  end

end