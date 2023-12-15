import { LightningElement, wire } from "lwc";
import getAllSpec from "@salesforce/apex/SpeciesService.getAllSpecies";

export default class SpeciesList extends LightningElement {
  @wire(getAllSpec) species; /* Decorador // modifica lo que sigue. */

  // species.data ---> datos devueltos por APEX.
  // species.error --> si error, se almacena acá.
}
