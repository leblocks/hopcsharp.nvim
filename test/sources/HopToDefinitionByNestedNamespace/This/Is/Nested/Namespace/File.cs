
namespace This.Is.Nested.Namespace
{
    class Program
    {
        public static void Main(string[] args)
        {
            var test = new ClassDefinitionFromParentNamespace();
            var test2 = new ClassDefinitionFromGrandParentNamespace();
        }
    }
}
