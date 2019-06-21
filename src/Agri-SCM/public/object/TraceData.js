
class TraceData {
    constructor (ownerAddr, dateCreate, desc, previousBarcode, publicBarcode) {
        this.owner = owner;
        this.dateCreate = dateCreate;
        this.desc = desc;
        this.previousBarcode = previousBarcode;
        this.publicBarcode =  publicBarcode;
    }

    get getOwner () {return this.owner};
    get getDateCreate () {return this.dateCreate};
    get getDesc () {return this.desc};
    get getPreviousBarcode () {return this.previousBarcode};
    get getPublicBarcode () {return this.publicBarcode};
}

module.exports = TraceData;