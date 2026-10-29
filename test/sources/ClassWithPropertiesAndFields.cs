
namespace This.Is.Namespace.One;

public class ClassWithPropertiesAndFields {
    private bool m_Field1;
    private bool m_Field2;
    public bool Property1 { get; set; }
    public bool Property2 { get; set; }
}

public record RecordWithPropertiesAndFields {
    private bool m_Field1;
    private bool m_Field2;
    public bool Property1 { get; set; }
    public bool Property2 { get; set; }
}

public struct StructWithPropertiesAndFields {
    private bool m_Field1;
    private bool m_Field2;
    public bool Property1 { get; set; }
    public bool Property2 { get; set; }
}

