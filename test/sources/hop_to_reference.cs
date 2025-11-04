
public class HopToReference
{
    [Alfa]
    private void Method1([TestAttr] int argument)
    {
    }

    [AttributeWow]
    [AlfaAttribute]
    public HopToReference()
    {
        Method1();
        Method1<GenericParam>();


        var class2 = new Class2<Test, Pest>();
        Class2 class22 = new();
        Class2<GenT, GenZ> class23 = new();

        // invocation in a lambda
        Task.Run(() => Method1());
        Task.Run<Meow>(() => Method1());
    }
}

private class AlfaAttribute : Attribute
{
}
