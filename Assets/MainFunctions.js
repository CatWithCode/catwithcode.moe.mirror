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

// Loads File from a desired location synchronised:
function syncLoadFile(filePath) {
    // Creating Request:
    var xmlhttp = new XMLHttpRequest();

    // Getting the File: 
    xmlhttp.open("GET", filePath, false);
    xmlhttp.send();

    // Retrun if the File was found, else do fallback:
    if (xmlhttp.status==200) {
        return xmlhttp.responseText;
    }
}