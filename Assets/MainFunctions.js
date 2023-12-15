// Public Functions:

// Reading and Writing Page-Header:
function WriteHeader() {
    document.write(loadFile('/Assets/BaseFiles/TopBar.html'));
}

// Reading and Writing Footer-Header:
function WriteFooter(dateText) {
    document.write(loadFile('/Assets/BaseFiles/Footer.html').replace("###DATE_TEXT###", dateText));
}


// Internel Functions:

// Loads files from a desired location:
function loadFile(filePath) {
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