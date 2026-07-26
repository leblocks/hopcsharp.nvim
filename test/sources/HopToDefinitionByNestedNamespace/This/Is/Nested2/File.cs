
namespace This.Is.Nested2
{
    class Program
    {
        public static void Main(string[] args)
        {
        }
    }

    // this ClassDefinitionFromParentNamespace is a test
    // to make sure that we won't jump here from This.Is.Nested.Namespace
    public class ClassDefinitionFromParentNamespace
    {
    }
}
