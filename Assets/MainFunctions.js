// Public Functions:

// Creating Page-Header:
async function WriteHeader() {
    document.getElementById("Header").innerHTML = await this.aSyncLoadFile('/Assets/BaseFiles/Header.html');
}

// Creating Page-Footer:
async function WriteFooter(dateText, usedLicense = "CC BY-NC-ND 4.0") {
    document.getElementById("Footer").innerHTML = (await this.aSyncLoadFile('/Assets/BaseFiles/Footer.html')).replace("###DATE_TEXT###", dateText).replace("###LICENSE###", usedLicense);
}

// Write HTML-Head (NOT async because of WebCrawler):
function WriteHead() {
    document.write('\
    \
        <meta name="viewport" content="width=device-width, initial-scale=1.0">\
        <link rel="stylesheet" href="/Assets/styles.css">\
        <link rel="icon" type="image/x-icon" href="/Assets/favicon.gif">\
        <meta name="description" content="Blog for random computer stuff from my daily life. Girl from Germany. Work as a Software Developer. Programming, Linux, Hacking, Modding and tinkering.">\
    ');
}

// Internel Functions:
// Loads File from a desired location asynchronously:
async function aSyncLoadFile(filePath) {
    return fetch(filePath)
        .then((response)=>response.text())
        .then((responseText)=>{return responseText});
}