module DocxSynthesizer
  class Variable::Text < Variable
    def process(node_template, env, filters = [], opts = {})
      super.tap { |node| node["xml:space"] = 'preserve'.freeze }
    end
  end
end
