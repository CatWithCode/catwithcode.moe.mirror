// Public Functions:

// Reading and Writing Page-Header:
function WriteHeader() {
    var test = loadFile('/Assets/BaseFiles/TopBar.html')

    if(test != null){
        document.write(loadFile('/Assets/BaseFiles/TopBar.html'));
    } else {

    }
}

// Reading and Writing Footer-Header:
function WriteFooter(dateText) {
    var test = loadFile('/Assets/BaseFiles/TopBar.html')

    if(test != null){
        document.write(loadFile('/Assets/BaseFiles/Footer.html').replace("###DATE_TEXT###", dateText));
    } else {

    }
}


// Internel Functions:
function loadFile(filePath) {
    // Creating Request:
    var xmlhttp = new XMLHttpRequest();

    // Getting the File: 
    xmlhttp.open("GET", filePath, false);
    xmlhttp.send();

    // Retrun if the File was found, else do fallback:
    if (xmlhttp.status==200) {
        return xmlhttp.responseText;
    } else {
        return null;
    }
  }