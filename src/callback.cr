module Callback
  VERSION = "0.1.0"

  macro register_event(event_name, *args)
    macro before_{{ event_name.id }}(method_name)
      def call_before_{{ event_name.id }}
        \{% if @type.methods.map(&.name).includes?({{ event_name }}.id) %}
          previous_def
        \{% end %}

        \{{ method_name.id }}
      end
    end

    macro after_{{ event_name.id }}(method_name)
      def call_after_{{ event_name.id }}(
        {% for param in args %}
          {{ param.id }},
        {% end %}
      )
        \{% if @type.methods.map(&.name).includes?({{ event_name }}.id) %}
          previous_def
        \{% end %}

        \{{ method_name.id }}(
          {% for param in args %}
            {{ param.id }},
          {% end %}
        )
      end

      def call_after_{{ event_name.id }}(*args)
        \{% if @type.methods.map(&.name).includes?({{ event_name }}.id) %}
          previous_def
        \{% end %}

        \{{ method_name.id }}
      end
    end

    macro around_{{ event_name.id }}(method_name)
      def call_around_{{ event_name.id }}(&block)
        temp = ->{ \{{ method_name.id }}(&block) }
        \{% if @type.methods.map(&.name).includes?({{event_name }}.id) %}
          previous_def &temp
        \{% else %}
          temp.call
        \{% end %}
      end
    end

    def call_before_{{ event_name.id }}
        # empty method so that the children do not have to register every callback
    end

    def call_after_{{ event_name.id }}(
        {% for param in args %}
          {{ param.id }},
        {% end %}
      )
        # empty method so that the children do not have to register every callback
    end

    def call_around_{{ event_name.id }}
      yield
    end
  end

  macro run_event(event_name, &block)
    call_before_{{ event_name.id }}
    result = call_around_{{ event_name.id }} {{ block }}
    call_after_{{ event_name.id }}(result)
  end
end
