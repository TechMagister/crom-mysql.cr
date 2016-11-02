require "mysql"

require "./crom-mysql/*"

module CROM
  macro mysql_adapter(properties, strict = true)

    def after_delete()
      @id = nil
    end

    def self.new_from_rs(%rs : ::MySql::ResultSet)
      return nil unless %rs.move_next
      instance = self.allocate
      instance.initialize(%rs)
      instance
    end

    # @see crystal-db : /src/db/mapping.cr
    def self.from_rs(%rs : ::DB::ResultSet)
      %objs = Array(self).new
      %rs.each do
        %objs << self.new(%rs)
      end
      %objs
    end

    def initialize(%rs : ::MySql::ResultSet)
      {% for key, value in properties %}
        %var{key.id} = nil
        %found{key.id} = false
      {% end %}

      %rs.each_column do |col_name|
        case col_name
          {% for key, value in properties %}
            when {{value[:key] || key.id.stringify}}
              %found{key.id} = true
              %var{key.id} =
                {% if value[:converter] %}
                  {{value[:converter]}}.from_rs(%rs)
                {% elsif value[:nilable] || value[:default] != nil %}
                  %rs.read(Union({{value[:type]}} | Nil))
                {% else %}
                  %rs.read({{value[:type]}})
                {% end %}

          {% end %}
          else
            {% if strict %}
              raise ::DB::MappingException.new("unknown result set attribute: #{col_name}")
            {% else %}
              %rs.read
            {% end %}
        end
      end

      {% for key, value in properties %}
        {% unless value[:nilable] || value[:default] != nil %}
          if %var{key.id}.is_a?(Nil) && !%found{key.id}
            raise ::DB::MappingException.new("missing result set attribute: {{(value[:key] || key).id}}")
          end
        {% end %}
      {% end %}

      {% for key, value in properties %}
        {% if value[:nilable] %}
          {% if value[:default] != nil %}
            @{{key.id}} = %found{key.id} ? %var{key.id} : {{value[:default]}}
          {% else %}
            @{{key.id}} = %var{key.id}
          {% end %}
        {% elsif value[:default] != nil %}
          @{{key.id}} = %var{key.id}.is_a?(Nil) ? {{value[:default]}} : %var{key.id}
        {% else %}
          @{{key.id}} = %var{key.id}.not_nil!
        {% end %}
      {% end %}
    end
  end
end
