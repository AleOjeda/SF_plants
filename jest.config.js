const { jestConfig } = require("@salesforce/sfdx-lwc-jest/config");
const setupFilesAfterEnv = jestConfig.setupFilesAfterEnv || [];
// setupFilesAfterEnv.push("<rootDir>/jest-sa11y-setup.js");
module.exports = {
  ...jestConfig,
  moduleNameMapper: {
    // Jest mocks
    "^lightning/navigation$":
      "<rootDir>/force-app/test/jest-mocks/lightning/navigation"
  },
  // setupFiles: ["jest-canvas-mock"],
  setupFilesAfterEnv,
  testTimeout: 10000,
  modulePathIgnorePatterns: ["<rootDir>/.localdevserver"]
};
