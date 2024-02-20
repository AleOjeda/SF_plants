declare module "@salesforce/apex/SpeciesService.getFilteredSpecies" {
  export default function getFilteredSpecies(param: {searchText: any}): Promise<any>;
}
declare module "@salesforce/apex/SpeciesService.getSpeciesWithPlants" {
  export default function getSpeciesWithPlants(): Promise<any>;
}
declare module "@salesforce/apex/SpeciesService.createSpeciesWithPlant" {
  export default function createSpeciesWithPlant(param: {speciesName: any, plantAcquisitionDate: any}): Promise<any>;
}
