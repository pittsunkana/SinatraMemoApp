module HamlLint
  # Responsible for transforming {Haml::Parser::ParseNode} objects into
  # corresponding {HamlLint::Tree::Node} objects.
  #
  # The parse tree generated by HAML has a number of strange cases where certain
  # types of nodes are created that don't necessarily correspond to what one
  # would expect. This class is intended to isolate and handle these cases so
  # that linters don't have to deal with them.
  class NodeTransformer
    # Creates a node transformer for the given Haml document.
    #
    # @param document [HamlLint::Document]
    def initialize(document)
      @document = document
    end

    # Converts the given HAML parse node into its corresponding HAML-Lint parse
    # node.
    #
    # @param haml_node [Haml::Parser::ParseNode]
    # @return [HamlLint::Tree::Node]
    def transform(haml_node)
      node_class = "#{HamlLint::Utils.camel_case(haml_node.type.to_s)}Node"

      HamlLint::Tree.const_get(node_class).new(@document, haml_node)
    end
  end
end