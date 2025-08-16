import { Browser } from "webdriverio";

export class TestHelper {
  static async waitForXPath(driver: Browser, xpath: string, timeout = 10000) {
    const element = driver.$(xpath);
    await element.waitForDisplayed({ timeout });
  }
  static async clickForXPath(driver: Browser, xpath: string) {
    const button = driver.$(xpath);
    await button.click();
  }
  static async screenshot(driver: Browser, filename: string) {
    await driver.saveScreenshot("images/" + filename);
  }
}

