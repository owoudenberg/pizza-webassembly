using HostWorld.wit.imports.pizza4dotnet.example.v0_1_0;

string name = args.Length > 0 ? args[0] : "world";
// Console.WriteLine("What's your name?");
// string name = Console.ReadLine();

string greeting = GreetingInterop.Greet(name);

Console.WriteLine(greeting);
