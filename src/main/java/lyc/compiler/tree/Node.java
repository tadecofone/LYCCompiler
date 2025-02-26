package lyc.compiler.tree;

// Clase para representar un nodo del árbol (AST)

import java.util.ArrayList;
import java.util.List;

public class Node {

    static int NODE_UNIQUE_ID = 0;

    String value;
    List<Node> children;
    private final int number = ++NODE_UNIQUE_ID;


    public Node(String value) {
        this.value = value;
        this.children = new ArrayList<>();
    }

    public Node(String value, Node left, Node right) {
        this.value = value;
        this.children = new ArrayList<>();
        if (left != null) this.children.add(left);
        if (right != null) this.children.add(right);
    }

    public void addChild(Node child) {
        this.children.add(child);
    }

    @Override
    public String toString() {
        return value + (children.isEmpty() ? "" : children.toString());
    }


    public String getValue() {
        return value;
    }

    public List<Node> getChildren() {
        return children;
    }

    public int getNumber() {
        return number;
    }

}