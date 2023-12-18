import { LightningElement, wire } from "lwc";
import getAllSpec from "@salesforce/apex/SpeciesService.getFilteredSpecies";

export default class SpeciesList extends LightningElement {
  // PROPERTIES, GETTERS & SETTERS
  searchText = ""; // Inicializo para que me otorgue las plantas en load.

  // LIFECYCLE HOOKS

  // WIRE
  @wire(getAllSpec, { searchText: "$searchText" })
  // @wire(getAllSpec)
  species; /* Decorador // modifica lo que sigue. */

  // METHODS
  handleInputChange(event) {
    const searchText = event.target.value;
    if (searchText.length >= 2 || searchText.length === 0) {
      this.searchText = searchText;
    }
  }

  // species.data ---> datos devueltos por APEX.
  // species.error --> si error, se almacena acá.
}
