// Modules to control application life and create native browser window
const {app, BrowserWindow} = require('electron')

let mainWindow

function createWindow () {
  // Create the browser window.
  mainWindow = new BrowserWindow({
    width: 1200,
    height: 800,
    title: 'ProtonMail',
    icon: '/usr/share/icons/protonmail.png',
    autoHideMenuBar: true,
    sandbox: false,
    webPreferences: {
      plugins: true,
      nodeIntegration: false
    }
  })

  mainWindow.loadURL('https://mail.protonmail.com')

  // Open the DevTools.
  // mainWindow.webContents.openDevTools()

  // Emitted when the window is closed.
  mainWindow.on('closed', function () {
    mainWindow = null
  })
}

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