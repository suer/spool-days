import { Capabilities } from "@wdio/types";
import { remote, Browser } from "webdriverio";
import { TestHelper } from "./test_helper.js";

const opts: Capabilities.WebdriverIOConfig = {
  path: "/",
  port: 4723,
  capabilities: {
    platformName: "iOS",
    "appium:automationName": "XCUITest",
    "appium:bundleId": "org.codefirst.SpoolDays",
    "appium:deviceName": process.env.IOS_DEVICE_NAME ?? "iPhone 16",
    "appium:platformVersion": process.env.IOS_PLATFORM_VERSION ?? "18.6",
    "appium:language": "ja",
    "appium:locale": "JP",
  },
};

async function captureTopPage(driver: Browser) {
  await TestHelper.screenshot(driver, "top-view.png");
}


async function captureAddPage(driver: Browser) {
  await TestHelper.clickForXPath(driver, "//XCUIElementTypeButton[@name='追加']");
  await TestHelper.screenshot(driver, "add-view.png");
}

async function main(): Promise<void> {
  const driver: Browser = await remote(opts);
  await captureTopPage(driver);
  await captureAddPage(driver);
}

if (require.main === module) {
  main().catch((error) => {
    console.error(error);
    process.exit(1);
  });
}
