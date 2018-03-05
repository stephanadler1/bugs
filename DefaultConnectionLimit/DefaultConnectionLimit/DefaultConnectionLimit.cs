namespace DefaultConnectionLimit
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Win32;
    using System.Net;
    using System.Net.Http;
    using System.Threading.Tasks;

    /// <summary>
    /// This demonstrates a bug that got introduced with the .NET Framework 4.7.1 update where
    /// <see cref="ServicePoint.ConnectionLimit"/>s are no longer applied to new connections being
    /// made with the <see cref="HttpClient"/>, but the <see cref="ServicePointManager.DefaultConnectionLimit"/>
    /// is being applied instead.
    /// </summary>
    [TestClass]
    public class DefaultConnectionLimit
    {
        public TestContext TestContext { get; set; }

        /// <summary>
        /// This test behaves differently depending on the version of .NET Framework installed on the machine.
        /// If running with .NET prior 4.7.1 the test succeeds, if running with 4.7.1 it fails.
        /// This is irrespective of the way the connection limits are being configured. It can also be 
        /// reproduced if configured in an app.config with 
        ///     <connectionManagement>
        ///       <clear/>
        ///       <add address="https://www.bing.com" maxconnection="20"/>
        ///       <add address="*" maxconnection="10"/>
        ///     </connectionManagement>
        /// </summary>
        [TestMethod]
        public async Task ConnectionSpecificConnectionLimitsAreHonored()
        {
            DetermineDotNetFramework();

            // Set the default value to something other than 2 or 4.
            const int defaultConnectionLimit = 10;
            const int bingConnectionLimit = 20;

            Assert.AreNotEqual(defaultConnectionLimit, bingConnectionLimit, "Please choose different limits.");

            var uri = new Uri("https://www.bing.com");
            ServicePointManager.DefaultConnectionLimit = defaultConnectionLimit;
            ServicePoint sp = ServicePointManager.FindServicePoint(uri);
            sp.ConnectionLimit = bingConnectionLimit;

            using (var httpClient = new HttpClient())
            {
                httpClient.BaseAddress = uri;

                HttpResponseMessage response = await httpClient.GetAsync("/").ConfigureAwait(false);

                sp = ServicePointManager.FindServicePoint(uri);
                Assert.AreEqual(bingConnectionLimit, sp.ConnectionLimit, $"If run with .NET 4.7.1 installed on the machine, this check fails and instead sp.ConnectionLimit == ServicePointManager.DefaultConnectionLimit ({defaultConnectionLimit})");
            }
        }

        private void DetermineDotNetFramework()
        {
            using (RegistryKey localMachineHive = RegistryKey.OpenBaseKey(RegistryHive.LocalMachine, RegistryView.Default))
            using (RegistryKey frameworKey = localMachineHive.OpenSubKey(@"SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full"))
            {
                object releaseObj = frameworKey?.GetValue("Release", null);
                if (releaseObj != null)
                {
                    // https://docs.microsoft.com/en-us/dotnet/framework/migration-guide/how-to-determine-which-versions-are-installed
                    switch ((int)releaseObj)
                    {
                        case 460798:
                            this.TestContext.WriteLine(".NET Framework 4.7 with Creators Update on Windows 10");
                            break;

                        case 460805:
                            this.TestContext.WriteLine(".NET Framework 4.7");
                            break;

                        case 461308:
                            this.TestContext.WriteLine(".NET Framework 4.7.1 with Fall Creators Update on Windows 10");
                            break;

                        case 461310:
                            this.TestContext.WriteLine(".NET Framework 4.7.1");
                            break;

                        default:
                            this.TestContext.WriteLine($"Undetermined: {(int)releaseObj}");
                            break;
                    }
                }
            }
        }
    }
}
