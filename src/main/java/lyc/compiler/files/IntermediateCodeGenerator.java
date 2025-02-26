package lyc.compiler.files;

import lyc.compiler.tree.*;

import java.io.FileWriter;
import java.io.IOException;

public class IntermediateCodeGenerator implements FileGenerator {

    @Override
    public void generate(FileWriter fileWriter) throws IOException {
        fileWriter.write("+------------------------------- ARBOL -------------------------------+\n");

        // Supongamos que tienes una clase ASTManager que almacena la raíz del AST.
        Node root = ASTManager.getRoot(); // Debes implementar ASTManager para guardar la raíz del AST.

        if (root != null) {
            printTree(root, fileWriter, 0);
        } else {
            fileWriter.write("Árbol vacío.\n");
        }
    }

    private void printTree(Node node, FileWriter writer, int indent) throws IOException {
        // Imprimir indentación
        for (int i = 0; i < indent; i++) {
            writer.write("  ");
        }
        writer.write(node.getValue() + "\n");

        // Recorrer recursivamente los hijos
        for (Node child : node.getChildren()) {
            printTree(child, writer, indent + 1);
        }
    }
}