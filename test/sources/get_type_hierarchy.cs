
public class Class1Generation1
{
}

public class Class1Generation2 : Class1Generation1
{
}

public class Class2Generation2 : Class1Generation1
{
}

public class Class1Generation3 : Class1Generation2
{
}

public class Class1Generation4 : Class1Generation3
{
}

public class Class2Generation4 : Class1Generation3
{
}

public class Parent
{
}

public class GenericParent<T> : Parent
{
}

public class Child<T> : GenericParent<T>
{
    // test case, query for type arguments
    // must be precies and not confuse T with K, P
    class Meow<K, P>
    {
    }

    class Bark<T> : Meow<K, P>
    {
    }
}

public class Child<T,V> : GenericParent<T>
{
}

// spaces here are intentionally for testing purposes
public class Child<T, V, Z> : GenericParent<T>
{
}

