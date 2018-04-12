module DocxSynthesizer
  class Variable::Array < Variable
    def initialize(value, spacer: ' '.freeze)
      value = [value] unless ::Array === value
      super(value)
      @spacer = spacer
    end

    def stash(filters = [])
      value.map do |variable|
        variable.stash(filters)
      end
    end

    def process(node_template, env, filters = [], opts = {})
      spacer = opts.fetch(:spacer) { @spacer }

      nodes = value.map { |v| [v.process(node_template, env, filters, opts)] }

      if spacer
        spacer_variable = Variable::Text.new(spacer)
        nodes.zip(
          ::Array.new(nodes.size - 1) {
            spacer_variable.process(node_template, env)
          }
        )
      else
        nodes
      end
    end
  end
end
