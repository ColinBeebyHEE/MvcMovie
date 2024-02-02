using MvcMovie.UiTests.Helpers;
using OpenQA.Selenium;
using FluentAssertions;
using OpenQA.Selenium.Chrome;

namespace MvcMovie.UiTests
{
    public class SeleniumTest
    {
        [Fact]
        public void HomePage_CheckTitle()
        {
            //Given
            //IWebDriver driver = DriverHelper.CreateHeadlessChromeDriver();

            var chromeOptions = new ChromeOptions();
            chromeOptions.AddArgument("--headless");
            IWebDriver driver = new ChromeDriver(chromeOptions);

            //driver.Navigate().GoToUrl("https://colins-mvc-movie-linux-web-app.azurewebsites.net");

            driver.Navigate().GoToUrl(Environment.GetEnvironmentVariable("MOVIE_URL"));

            var h1Element = driver.FindElement(By.TagName("h1"));
            h1Element.Text.Should().BeEquivalentTo("Welcome");
        }
    }
}