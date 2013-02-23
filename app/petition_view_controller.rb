class PetitionViewController < UIViewController
  attr_accessor :navController

  def initWithPetition(petitionObject)
    @petition = petitionObject
    initWithNibName(nil, bundle: nil)
  end

  def loadView
    background = UIColor.blackColor
    self.view = UIView.alloc.initWithFrame(UIScreen.mainScreen.applicationFrame)
    self.view.backgroundColor = background

    webFrame = UIScreen.mainScreen.applicationFrame
    webFrame.origin.y = 0.0

    @webView = UIWebView.alloc.initWithFrame(webFrame)
    @webView.backgroundColor = background
    @webView.scalesPageToFit = true
    @webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)
    @webView.delegate = self
    @webView.loadHTMLString(generateHtml, baseURL:nil)
  end

  def webViewDidFinishLoad(webView)
    self.view.addSubview(@webView)
  end

  def webView(inWeb, shouldStartLoadWithRequest:inRequest, navigationType:inType)
    if inType == UIWebViewNavigationTypeLinkClicked && inRequest.URL.scheme != 'file' 
      UIApplication.sharedApplication.openURL(inRequest.URL)
      return false
    end
    true
  end

  def viewDidLoad
    super

    self.title = "View"

    button = UIBarButtonItem.alloc.init
    button.title = 'Signatures'
    button.target = self
    button.action = 'signatures'
    button.tintColor = UIColor.blackColor

    self.navigationItem.rightBarButtonItem = button
  end

  def signatures
    viewController = SignaturesController.alloc.initWithPetition(@petition)
    @navController.pushViewController(viewController, animated: true)
  end

  def generateHtml
    "<html>
      <head>
        <style>
          #{css}
        </style>

        <meta name='viewport' content='initial-scale=1.0'>
      </head>

      <body>
        #{htmlBody}
      </body>
    </html>"
  end

  def htmlBody
    <<-HTML
      <div id="top">
        <h1>#{@petition.title}</h1>
      </div>

      <div id="text">
        #{@petition.body}
      </div>

      #{responseInfo}

      #{signatureInfo}

      #{issuesInfo}

      <div class='pad'>&nbsp;</div>
    HTML
  end

  def responseInfo
    if @petition.response
      "<div id='response'>
        <p><a href='#{@petition.response.url}'>Click here to view the administration's response</a>
      </div>"
    else
      ""
    end
  end

  def issuesInfo
    if @petition.issues
      "<div id='issues'>
        <h3>Issues</h3>
        <ul>
        #{@petition.issues.map {|i| '<li>' + i.name + '</li>'}.join}
        </ul>
      </div>"
    else
      ""
    end
  end

  def signatureInfo
    <<-HTML
    <div id="info">
      <table><tr><td>
      <div class="meta">
        <h3>#{@petition.signature_count}</h3>
        <h4>SIGNATURES</h4>
      </div></td>

      <td><div class="meta">
        <h3>#{@petition.signatures_needed}</h3>
        <h4>NEEDED</h4>
      </div></td></tr></table>
    </div>
    HTML
  end

  def css
    <<-CSS
    BODY, HTML { 
      font-family: Helvetica;
      margin: 0px;
      padding: 0px;
      background: #eee;
    }

    H1 {
      font-size: 14pt;
      color: #eee;
    }

    #top {
      background: #111;
      padding: 10px;
      border: 0px;
      border-bottom: 4px solid #000;
    }

    #text {
      background: #fff;
      border: 1px solid #ddd;
      margin: 10px;
      border-radius: 4px;
      padding: 10px;
      font-size: 10pt;
      line-height: 1.55;
    } 

    #info table {
      width: 100%;
    }

    .meta {
      margin: auto;
      margin-bottom: 20px;
    }

    .meta h3 {
      font-size: 18pt;
      font-weight: bold;
      color: #333;
      text-align: center;
      margin: 0px;
      padding: 0px;
    }

    .meta h4 {
      margin: 0px;
      padding: 0px;
      font-size: 8pt;
      color: #999;
      text-align: center;
    }

    /* Only necessary until I fix the webview frame */
    .pad {
      margin-bottom: 40px;
    }

    #issues {
      padding: 10px;
    }

    #issues h3 {
      margin-top: 0px;
      padding-top: 0px;
    }

    #response {
      padding: 10px;
      background: #3d9947;
      border: 1px solid #1d7927;
      border-radius: 4px;
      margin: 10px;
      text-align: center;
    }

    #respose h3 {
      padding-top: 0px;
      margin-top: 0px;
      color: white;
    }

    #response p a {
      color: white;
      font-weight: bold;
    }

    CSS
  end
end