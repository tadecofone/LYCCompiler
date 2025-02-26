package lyc.compiler.tree;

public class ASTManager {

    public static NodeIndex programIdx = new NodeIndex();
    public static NodeIndex blockIdx = new NodeIndex();
    public static NodeIndex sentenceIdx = new NodeIndex();
    public static NodeIndex var_declarationIdx = new NodeIndex();
    public static NodeIndex var_sencente_decIdx = new NodeIndex();
    public static NodeIndex data_typeIdx = new NodeIndex();
    public static NodeIndex id_listIdx = new NodeIndex();
    public static NodeIndex decitionIdx = new NodeIndex();
    public static NodeIndex conditionIdx = new NodeIndex();
    public static NodeIndex comparisonIdx = new NodeIndex();
    public static NodeIndex comparatorIdx = new NodeIndex();
    public static NodeIndex iteratorIdx = new NodeIndex();
    public static NodeIndex assignmentIdx  = new NodeIndex();
    public static NodeIndex s_writeIdx = new NodeIndex();
    public static NodeIndex s_readIdx = new NodeIndex();
    public static NodeIndex write_paramIdx = new NodeIndex();
    public static NodeIndex read_paramIdx = new NodeIndex();
    public static NodeIndex expressionIdx = new NodeIndex();
    public static NodeIndex termIdx = new NodeIndex();
    public static NodeIndex factorIdx = new NodeIndex();
    public static NodeIndex negative_calculationsIdx = new NodeIndex();
    public static NodeIndex sum_first_primesIdx = new NodeIndex();
    public static NodeIndex c_listIdx = new NodeIndex();
    public static NodeIndex listIdx = new NodeIndex();

    // Variable estática para almacenar la raíz del AST
    private static Node root;

    // Establece la raíz del AST
    public static void setRoot(Node newRoot) {
        root = newRoot;
    }

    // Devuelve la raíz del AST
    public static Node getRoot() {
        return root;
    }

    // Método opcional para limpiar el AST
    public static void clear() {
        root = null;
    }
}