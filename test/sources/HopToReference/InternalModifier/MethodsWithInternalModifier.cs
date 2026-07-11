namespace This.Is.Reference.Namespace.Internal
{
    internal partial static class ClassWithInternalModifier
    {
        internal static async Task AlfaMethod()
        {
            var type = typeof(Class2);
        }

        public static void Method()
        {
        }
    }

    public interface ModifiersInterfaceForTest
    {
    }

    static struct ModifierStruct
    {
    }

    private enum Enumsky
    {
        ONE,
        TWO,
        THREE,
    }

    internal static record RecordMe
    {
    }

    class JustClass
    {
    }
}

