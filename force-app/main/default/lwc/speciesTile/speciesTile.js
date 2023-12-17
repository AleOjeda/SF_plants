import { LightningElement, api } from "lwc";

export default class SpeciesTile extends LightningElement {
  @api specie;

  get isOutdoors() {
    return this.specie.Location__c.includes("Outdoors");
  }

  get isIndoors() {
    return this.specie.Location__c.includes("Indoors");
  }

  navigateToRecordViewPage() {
    console.log("hola");
  }
}
