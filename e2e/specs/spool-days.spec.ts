import { Capabilities } from "@wdio/types";
import { remote, Browser } from "webdriverio";
import { TestHelper } from "./test_helper.js";

const opts: Capabilities.WebdriverIOConfig = {
  path: "/",
  port: 4723,
  connectionRetryTimeout: 900000,
  connectionRetryCount: 1,
  logLevel: "debug",
  capabilities: {
    platformName: "iOS",
    "appium:automationName": "XCUITest",
    "appium:bundleId": "org.codefirst.SpoolDays",
    "appium:udid": process.env.IOS_DEVICE_UDID ?? "auto",
    "appium:language": "ja",
    "appium:locale": "JP",
    "appium:simulatorStartupTimeout": 900000,
    "appium:wdaLaunchTimeout": 900000,
    "appium:showXcodeLog": true,
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
