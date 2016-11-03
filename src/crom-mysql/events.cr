module CROM::MySQL
  module Events
    def after_delete(arg)
      @id = nil
    end
  end
end
