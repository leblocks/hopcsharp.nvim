
namespace This.Is.Namespace.One;

[Attributed1]
public class Class1 : Interface1, Interface2, ImportantBaseClass {

    public Class1() {}

    public Class2 Foo() {}

    public Class2 Bar() {}
}

public class Attributed1Attribute : Attribute {

}

public enum Enum1 {
    One, Two, Three
}

public struct Struct1 {
}

public record Record1 {
}

public interface IInterface {}
