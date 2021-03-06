// Modules to control application life and create native browser window
const {app, BrowserWindow} = require('electron')

let mainWindow

function createWindow () {
  // Create the browser window.
  mainWindow = new BrowserWindow({
    width: 1200,
    height: 800,
    title: 'hyperledger-wiki',
    icon: '/usr/share/icons/hyperledger-wiki.png',
    autoHideMenuBar: true,
    sandbox: false,
    webPreferences: {
      plugins: true,
      nodeIntegration: false
    }
  })


mainWindow.loadURL('https://wiki.hyperledger.org')

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

app.on('ready', createWindow)