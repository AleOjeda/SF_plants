import { createElement } from "lwc";
import SpeciesTile from "c/speciesTile";
import { getNavigateCalledWith } from "lightning/navigation";

describe("c-species-tile", () => {
  afterEach(() => {
    // The jsdom instance is shared across test cases in a single file so reset the DOM
    while (document.body.firstChild) {
      document.body.removeChild(document.body.firstChild);
    }
  });

  // Helper function to wait until the microtask queue is empty. This is needed for promise
  // timing when calling imperative Apex.
  //   async function flushPromises() {
  //     return Promise.resolve();
  //   }

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

  it("Test click ViewDetails", () => {
    //GIVEN
    const element = createElement("c-species-tile", {
      is: SpeciesTile
    });
    element.specie = {
      Name: "Jazmin",
      //   Location__c: "Indoors"
      Id: "1234"
    };

    // WHEN
    document.body.appendChild(element);
    // THEN
    const buttonEl = element.shadowRoot.querySelector("lightning-button");
    // Selector for no class could also be 'lightning-button:not([class])'
    buttonEl.click();

    const { pageReference } = getNavigateCalledWith();

    // Verify component called with correct event type and params
    // navigateToRecordViewPage() {
    //     this[NavigationMixin.Navigate]({
    //       type: "standard__recordPage",
    //       attributes: {
    //         objectApiName: "Species__c",
    //         recordId: this.specie.Id,
    //         actionName: "view"
    //       }
    //     });
    //   }
    expect(pageReference.type).toBe("standard__recordPage");
    expect(pageReference.attributes.actionName).toBe("view");
    expect(pageReference.attributes.recordId).toBe("1234");
  });
});
