using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using OpenQA.Selenium.Chrome;

namespace MvcMovie.UiTests.Helpers
{
    public static class DriverHelper
    {
        public static ChromeDriver CreateHeadlessChromeDriver()
        {
            var chromeOptions = new ChromeOptions();
            chromeOptions.AddArgument("--headless");
            return new ChromeDriver(chromeOptions);
        }
    }
}
