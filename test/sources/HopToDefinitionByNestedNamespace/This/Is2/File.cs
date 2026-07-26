
namespace This.Is2
{
    class Program
    {
        public static void Main(string[] args)
        {
        }
    }

    // this ClassDefinitionFromGrandParentNamespace is a test
    // to make sure that we won't jump here from This.Is.Nested.Namespace
    public class ClassDefinitionFromGrandParentNamespace
    {
    }
}
