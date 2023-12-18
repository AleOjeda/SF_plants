import { LightningElement, wire } from "lwc";
import getAllSpec from "@salesforce/apex/SpeciesService.getFilteredSpecies";

export default class SpeciesList extends LightningElement {
  searchText;

  handleInputChange(event) {
    this.searchText = event.target.value;
  }
  @wire(getAllSpec, { searchText: "$searchText" })
  species; /* Decorador // modifica lo que sigue. */

  // species.data ---> datos devueltos por APEX.
  // species.error --> si error, se almacena acá.
}
