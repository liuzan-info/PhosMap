function Pop() {
  var cssRuleFile = "style.css";

  let lnk = document.createElement("link");
  lnk.setAttribute("rel", "stylesheet");
  lnk.setAttribute("type", "text/css");
  lnk.setAttribute("href", cssRuleFile);
  document.getElementsByTagName("head")[0].appendChild(lnk);

  let styl = "undefined";
  var conDivObj;

  var fadeInTime = 10; // If needed could be served as an customizable option to the user
  var fadeOutTime = 10;

  let cookie = {
    name: "cookieconsent_status",
    path: "/",
    expiryDays: 365 * 24 * 60 * 60 * 5000,
  };

  let content = {
    /// Add a field for link color
    // message:
    //    "PhosMap only uses necessary cookies. The website cannot function properly without these cookies, and can only be disabled by changing your browser preferences. By clicking “Accept”, you consent to our use of cookies. Alternatively, please install PhosMap locally according to our ",
    btnText: "Accept",
    mode: "  banner bottom",
    theme: " theme-classic",
    palette: " palette1",
    // link: "Learn more",
    link: "github",
    href: "https://github.com/liuzan-info/PhosMap",
    target: "_blank",
  };

  let createPopUp = function () {
    console.log(content);
    if (typeof conDivObj === "undefined") {
      conDivObj = document.createElement("DIV");
      conDivObj.style.opacity = 0;
      conDivObj.setAttribute("id", "spopupCont");
    }
    conDivObj.innerHTML =
      '<div id="poper" class="window ' +
      content.mode +
      content.theme +
      content.palette +
      '"><span id="msg" class="message">' +
      // content.message +
      "PhosMap uses necessary cookies to improve functionality from " +
      "<a target='_blank' class='policylink' href = 'https://posit.co/about/posit-service-terms-of-use/'>Posit ShinyApps.io</a>" +
      ". By clicking “Accept”, you consent to our use of cookies." +
      "<br/>" +
      "Alternatively, please install PhosMap locally according to our " +
      '<a id="plcy-lnk" class="policylink" href="' +
      content.href +
      '"' +
      " target=" +
      content.target +
      ">" +
      content.link +
      '</a>' +
      '.' +
      '</span>' +
      '<div id="btn" class="compliance"><a href="#" id="cookie-btn" class="spopupbtnok" >' +
      content.btnText +
      '</a></div><span class="credit"></span></div>';
    document.body.appendChild(conDivObj);
    fadeIn(conDivObj);
  
    document
      .getElementById("cookie-btn")
      .addEventListener("click", function () {
        saveCookie();
        fadeOut(conDivObj);
      });
  };

  let fadeOut = function (element) {
    var op = 1;
    var timer = setInterval(function () {
      if (op <= 0.1) {
        clearInterval(timer);
        conDivObj.parentElement.removeChild(conDivObj);
      }
      element.style.opacity = op;
      element.style.filter = "alpha(opacity=" + op * 100 + ")";
      op -= op * 0.1;
    }, fadeOutTime);
  };
  let fadeIn = function (element) {
    var op = 0.1;
    var timer = setInterval(function () {
      if (op >= 1) {
        clearInterval(timer);
      }
      element.style.opacity = op;
      element.style.filter = "alpha(opacity=" + op * 100 + ")";
      op += op * 0.1;
    }, fadeInTime);
  };

  let checkCookie = function (key) {
    var keyValue = document.cookie.match("(^|;) ?" + key + "=([^;]*)(;|$)");
    return keyValue ? true : false;
  };

  let saveCookie = function () {
    var expires = new Date();
    expires.setTime(expires.getTime() + cookie.expiryDays);
    document.cookie =
      cookie.name +
      "=" +
      "ok" +
      ";expires=" +
      expires.toUTCString() +
      "path=" +
      cookie.path;
  };

  this.init = function (param) {
    if (checkCookie(cookie.name)) return;

    if (typeof param === "object") {
      if ("ButtonText" in param) content.btnText = param.ButtonText;
      if ("Mode" in param) content.mode = " " + param.Mode;
      if ("Theme" in param) content.theme = " " + param.Theme;
      if ("Palette" in param) content.palette = " " + param.Palette;
      if ("Message" in param) content.message = param.Message;
      if ("LinkText" in param) content.link = param.LinkText;
      if ("Location" in param) content.href = param.Location;
      if ("Target" in param) content.target = param.Target;
      if ("Time" in param)
        setTimeout(function () {
          createPopUp();
        }, param.Time * 1000);
      else createPopUp();
    }
  };
}
window.start = new Pop();
