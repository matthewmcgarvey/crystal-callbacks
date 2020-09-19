module Callback
  VERSION = "0.1.0"

  macro register_callback(event_name, *args)
    macro {{ event_name.id }}(method_name)
      def call_{{ event_name.id }}(
        {% for param in args %}
          {{ param.id }},
        {% end %}
      )
        \{% if @type.methods.map(&.name).includes?({{ event_name }}.id) %}
          previous_def
        \{% end %}

        \{{ method_name.id }}(
          {% for param in args %}
            {% if param.is_a?(TypeDeclaration) %}
              {{ param.var.id }},
            {% else %}
              {{ param.id }},
            {% end %}
          {% end %}
        )
      end
    end

    def call_{{ event_name.id }}(
        {% for param in args %}
          {{ param.id }},
        {% end %}
      )
        # empty method so that the children do not have to register every callback
      end
  end
end
