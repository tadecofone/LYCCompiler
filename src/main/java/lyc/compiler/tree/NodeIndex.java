package lyc.compiler.tree;

public class NodeIndex {

    private Node node;

    public void setNode(Node n) {
        node = n;
    }

    public int getNodeNumber() {
        return node.getNumber();
    }

    public Node getNode() {
        return node;
    }


}