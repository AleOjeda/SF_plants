import { LightningElement, api } from "lwc";
import { NavigationMixin } from "lightning/navigation";
export default class SpeciesTile extends NavigationMixin(LightningElement) {
  @api specie;

  get isOutdoors() {
    return this.specie.Location__c.includes("Outdoors");
  }

  get isIndoors() {
    return this.specie.Location__c.includes("Indoors");
  }

  navigateToRecordViewPage() {
    /* Navigate to Record View Page */
    this[NavigationMixin.Navigate]({
      type: "standard__recordPage",
      attributes: {
        objectApiName: "Species__c",
        recordId: this.specie.Id,
        actionName: "view"
      }
    });
  }
}
