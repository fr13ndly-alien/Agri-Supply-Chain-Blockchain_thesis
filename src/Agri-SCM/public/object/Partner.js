
class Partner {
    constructor (pubKey, partnerid, GLN, name, partnerAddress, proof, typeOfPartner) {
        this.pubKey = pubKey;
        this.partnerid = partnerid;
        this.GLN = GLN;
        this.name = name;
        this.partnerAddress = partnerAddress;
        this.proof = proof;
    };

    get getPubKey () {return this.pubKey};
    get getParterid () {return this.partnerid};
    get getGLN () {return this.GLN};
    get getName () {return this.name};
    get getPartnerAddress () {return this.partnerAddress};
    get getProof () {return this.proof};
    get getTypeOfPartner () {return this.typeOfPartner};
}

module.exports = Partner;