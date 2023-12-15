// Public Functions:

// Creating Page-Header:
async function WriteHeader() {
    document.getElementById("Header").innerHTML = await this.aSyncLoadFile('/Assets/BaseFiles/TopBar.html');
}

// Creating Footer-Header:
async function WriteFooter(dateText) {
    document.getElementById("Footer").innerHTML = (await this.aSyncLoadFile('/Assets/BaseFiles/Footer.html')).replace("###DATE_TEXT###", dateText);
}

// Internel Functions:
// Loads File from a desired location asynchronously:
async function aSyncLoadFile(filePath) {
    return fetch(filePath)
        .then((response)=>response.text())
        .then((responseText)=>{return responseText});
}