enum EventType {
  notExisting,
  notReported,
  earthquake,
  anthropogenicEvent,
  collapse,
  cavityCollapse,
  mineCollapse,
  buildingCollapse,
  explosion,
  accidentalExplosion,
  chemicalExplosion,
  controlledExplosion,
  experimentalExplosion,
  industrialExplosion,
  miningExplosion,
  quarryBlast,
  roadCut,
  blastingLevee,
  nuclearExplosion,
  inducedOrTriggeredEvent,
  rockBurst,
  reservoirLoading,
  fluidInjection,
  fluidExtraction,
  crash,
  planeCrash,
  trainCrash,
  boatCrash,
  otherEvent,
  atmosphericEvent,
  sonicBoom,
  sonicBlast,
  acousticNoise,
  thunder,
  avalanche,
  snowAvalanche,
  debrisAvalanche,
  hydroacousticEvent,
  iceQuake,
  slide,
  landslide,
  rockslide,
  meteorite,
  volcanicEruption
}

EventType eventTypeFromText(String _rawEventType) {
  switch (_rawEventType) {
    case "not existing":
      return EventType.notExisting;
    case "not reported":
      return EventType.notReported;
    case "earthquake":
      return EventType.earthquake;
    case "anthropogenic event":
      return EventType.anthropogenicEvent;
    case "collapse":
      return EventType.collapse;
    case "cavity collapse":
      return EventType.cavityCollapse;
    case "mine collapse":
      return EventType.mineCollapse;
    case "building collapse":
      return EventType.buildingCollapse;
    case "explosion":
      return EventType.explosion;
    case "accidental explosion":
      return EventType.accidentalExplosion;
    case "chemical explosion":
      return EventType.chemicalExplosion;
    case "controlled explosion":
      return EventType.controlledExplosion;
    case "experimental explosion":
      return EventType.experimentalExplosion;
    case "industrial explosion":
      return EventType.inducedOrTriggeredEvent;
    case "mining explosion":
      return EventType.miningExplosion;
    case "quarry blast":
      return EventType.quarryBlast;
    case "road cut":
      return EventType.roadCut;
    case "blasting levee":
      return EventType.blastingLevee;
    case "nuclear explosion":
      return EventType.nuclearExplosion;
    case "induced or triggered event":
      return EventType.inducedOrTriggeredEvent;
    case "rock burst":
      return EventType.rockBurst;
    case "reservoir loading":
      return EventType.reservoirLoading;
    case "fluid injection":
      return EventType.fluidInjection;
    case "fluid extraction":
      return EventType.fluidExtraction;
    case "crash":
      return EventType.crash;
    case "plane crash":
      return EventType.planeCrash;
    case "train crash":
      return EventType.trainCrash;
    case "boat crash":
      return EventType.boatCrash;
    case "other event":
      return EventType.otherEvent;
    case "atmospheric event":
      return EventType.atmosphericEvent;
    case "sonic boom":
      return EventType.sonicBoom;
    case "sonic blast":
      return EventType.sonicBlast;
    case "acoustic noise":
      return EventType.acousticNoise;
    case "thunder":
      return EventType.thunder;
    case "avalanche":
      return EventType.avalanche;
    case "snow avalanche":
      return EventType.snowAvalanche;
    case "debris avalanche":
      return EventType.debrisAvalanche;
    case "hydroacoustic event":
      return EventType.hydroacousticEvent;
    case "ice quake":
      return EventType.iceQuake;
    case "slide":
      return EventType.slide;
    case "landslide":
      return EventType.landslide;
    case "rockslide":
      return EventType.rockslide;
    case "meteorite":
      return EventType.meteorite;
    case "volcanic eruption":
      return EventType.volcanicEruption;
    default:
      return EventType.earthquake;
  }
}
