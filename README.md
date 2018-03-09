# Demonstration of Various Bugs

* FIXED: **[DefaultConnectionLimit](DefaultConnectionLimit/DefaultConnectionLimit/DefaultConnectionLimit.cs)** demonstrates a bug that was introduced with [.NET Framework 4.7.1](https://github.com/Microsoft/dotnet/blob/master/releases/net471/dotnet471-changes.md). Connection-specific configurations are no longer being applied, instead the default settings, like the connection limit, is being used. This can have some serious performance ramifications for applications using different limits for specific connections. The work around described in [ServicePoint.ConnectionLimit default behavior with loopback changed unexpectedly](https://github.com/Microsoft/dotnet/blob/master/releases/net471/KnownIssues/534719-Networking%20ServicePoint.ConnectionLimit%20default%20behavior%20with%20loopback%20changed%20unexpectedly.md) is not really that helpful for these cases.
This issue got resolved with [.NET Framework 4.7.2 preview](https://blogs.msdn.microsoft.com/dotnet/2018/02/05/announcing-net-framework-4-7-2-early-access-build-3052/).
