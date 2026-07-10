namespace This.Is.Reference.Namespace.Internal
{
    internal static class ClassWithInternalModifier
    {
        internal static async Task AlfaMethod()
        {
            var type = typeof(Class2);
        }

        public static void Method()
        {
        }
    }
}

