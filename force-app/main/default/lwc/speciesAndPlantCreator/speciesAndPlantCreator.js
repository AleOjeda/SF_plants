import { LightningElement, api } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import createSpeciesWithPlant from "@salesforce/apex/SpeciesService.createSpeciesWithPlant";
import { CloseActionScreenEvent } from "lightning/actions";
export default class SpeciesAndPlantCreator extends LightningElement {
  speciesName;
  plantAcquisitionDate;
  @api recordId;
  //handleSpeciesNameChange
  handleSpeciesNameChange(event) {
    this.speciesName = event.target.value;
  }
  //handleAcquisitionDateChange
  handleAcquisitionDateChange(event) {
    this.plantAcquisitionDate = event.target.value;
  }
  handleCancelButtonClick() {
    this.dispatchEvent(new CloseActionScreenEvent());
  }
  //handleButtonClick
  handleCreateButtonClick() {
    console.log(
      "Registro desde el que se lanzó la quick action: " +
        this.recordId +
        this.plantAcquisitionDate +
        this.speciesName
    );
    createSpeciesWithPlant({
      speciesName: this.speciesName,
      plantAcquisitionDate: this.plantAcquisitionDate
    })
      .then(() => {
        const evt = new ShowToastEvent({
          title: "Success",
          message: "Species & Plant created correctly",
          variant: "success"
        });
        this.dispatchEvent(evt);
      })
      .catch((err) => {
        console.log(err);
        const evt = new ShowToastEvent({
          title: "Error",
          message: "Species & Plant not created correctly" + err,
          variant: "error"
        });
        this.dispatchEvent(evt);
      });
  }
  //rollback
}
