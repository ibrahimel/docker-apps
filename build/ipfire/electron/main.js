// Modules to control application life and create native browser window
const {app, BrowserWindow} = require('electron')

let mainWindow

function createWindow () {
  // Create the browser window.
  mainWindow = new BrowserWindow({
    width: 1200,
    height: 800,
    title: 'ipfire',
    icon: '/usr/share/icons/ipfire.png',
    autoHideMenuBar: true,
    sandbox: false,
    webPreferences: {
      plugins: true,
      nodeIntegration: false
    }
  })


mainWindow.loadURL('https://172.17.0.250:444')

// Open the DevTools.
// mainWindow.webContents.openDevTools()

// Emitted when the window is closed.
mainWindow.on('closed', function () {
  mainWindow = null
})
}

// SSL/TSL: this is the self signed certificate support
app.on('certificate-error', (event, webContents, url, error, certificate, callback) => {
  // On certificate error we disable default behaviour (stop loading the page)
  // and we then say "it is all fine - true" to the callback
  event.preventDefault();
  callback(true);
});

// Quit when all windows are closed.
app.on('window-all-closed', function () {
  if (process.platform !== 'darwin') {
    app.quit()
  }
})

app.on('activate', function () {
  if (mainWindow === null) {
    createWindow()
  }
})

app.on('widevine-ready', (version) => {
  console.log('Widevine ' + version + ' is ready to be used!');
  createWindow()
});

app.on('widevine-update-pending', (currentVersion, pendingVersion) => {
  console.log('Widevine ' + currentVersion + ' is ready to be upgraded to ' + pendingVersion + '!');
});

app.on('widevine-error', (error) => {
  console.log('Widevine installation encounterted an error: ' + error);
  //process.exit(1)
});

app.on('login', function(event, webContents, request, authInfo, callback) {
  event.preventDefault();
  callback('admin', '');
});