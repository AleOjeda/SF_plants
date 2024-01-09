import { createElement } from "lwc";
import SpeciesTile from "c/speciesTile";

describe("c-species-tile", () => {
  afterEach(() => {
    // The jsdom instance is shared across test cases in a single file so reset the DOM
    while (document.body.firstChild) {
      document.body.removeChild(document.body.firstChild);
    }
  });

  // Helper function to wait until the microtask queue is empty. This is needed for promise
  // timing when calling imperative Apex.
  async function flushPromises() {
    return Promise.resolve();
  }

  it("DOM renderiza Ok con datos de inicialización", () => {
    //GIVEN
    // Create component
    const element = createElement("c-species-tile", {
      is: SpeciesTile
    });
    element.specie = {
      Name: "Jazmin"
      //   Location__c: "Indoors"
    };

    // WHEN
    document.body.appendChild(element);

    // THEN

    // Query lightning-card element Name
    const lightningLayoutEl =
      element.shadowRoot.querySelector("lightning-card");
    expect(lightningLayoutEl).not.toBeNull();
    expect(lightningLayoutEl.title).toBe(element.specie.Name);
  });
});
