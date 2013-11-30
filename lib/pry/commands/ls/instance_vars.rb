require 'pry/commands/ls/interrogateable'

class Pry
  class Command::Ls < Pry::ClassCommand
    class InstanceVars < Pry::Command::Ls::Formatter

      include Pry::Command::Ls::Interrogateable

      def initialize(interrogatee, has_any_opts, opts)
        @interrogatee = interrogatee
        @has_any_opts = has_any_opts
        @default_switch = opts[:ivars]
      end

      def correct_opts?
        super || !@has_any_opts
      end

      def output_self
        ivars = if Object === @interrogatee
                  Pry::Method.safe_send(@interrogatee, :instance_variables)
                else
                  [] #TODO: BasicObject support
                end
        kvars = Pry::Method.safe_send(interrogatee_mod, :class_variables)
        ivars_out = output_section('instance variables', format(:instance_var, ivars))
        kvars_out = output_section('class variables', format(:class_var, kvars))
        ivars_out + kvars_out
      end

      def format(type, vars)
        vars.sort_by { |var| var.to_s.downcase }.map { |var| color(type, var) }
      end

    end
  end
end
