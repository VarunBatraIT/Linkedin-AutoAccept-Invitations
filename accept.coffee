pathToSeleniumJar = "."
acceptInvitationsUrl = 'https://www.linkedin.com/inbox/#invitations'
homePage = 'https://www.linkedin.com/'
webdriver = require("selenium-webdriver")
SeleniumServer = require("selenium-webdriver/remote").SeleniumServer

server = new SeleniumServer(pathToSeleniumJar,
  port: 4444
)
server.start()
driver = new webdriver.Builder().usingServer(server.address()).withCapabilities(webdriver.Capabilities.chrome()).build()
promise = driver.getTitle();
try
  promise.then(
    #login
    (title)->
      driver.get homePage
      driver.findElement(webdriver.By.id("session_key-login")).sendKeys process.argv[2]
      driver.findElement(webdriver.By.id("session_password-login")).sendKeys process.argv[3]
      driver.findElement(webdriver.By.id("signin")).submit()
  )
  promise.then(
  #accept invitation
    (title)->
      driver.get acceptInvitationsUrl
      driver.sleep(10000)
      driver.findElement(webdriver.By.className("bulk-chk")).click();
      driver.findElement(webdriver.By.css("#invitations .topActionBar ul li:first-child")).click()
      driver.sleep(10000)
  )
  promise.then(
    (title)->
      driver.quit()
  )
catch error
  console.log error
  driver.quit();
