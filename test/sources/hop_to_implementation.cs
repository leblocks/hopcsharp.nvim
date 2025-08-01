
namespace This.Is.Namespace.Two;

public class HopToImplementation : IContainMethods, AbstractHopToImplementation {
    public string GetString() {
        return "stringsky";
    }

    public void DoSomething() {
        // doing something
    }
}

interface IContainMethods {
    public string GetString();
}

public abstract class AbstractHopToImplementation {
    public abstract void DoSomething();
}

