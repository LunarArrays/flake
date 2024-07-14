{config, lib, ...}:
{
	config = lib.mkIf config.arctic.apps.firefox.enable {
		programs.firefox.profiles = {
			default.settings = {
"_user.js.parrot"= "START: Oh yes= the Norwegian Blue... what's wrong with it?";

/* 0000: disable about:config warning ***/
"browser.aboutConfig.showWarning"= false;

/*** [SECTION 0100]: STARTUP ***/
/* 0102: set startup page [SETUP-CHROME]
 * 0=blank= 1=home= 2=last visited page= 3=resume previous session
 * [NOTE] Session Restore is cleared with history (2811= and not used in Private Browsing mode
 * [SETTING] General>Startup>Restore previous session ***/
 "browser.startup.page" = 3;
"browser.newtabpage.enabled"= false;
/* 0105: disable sponsored content on Firefox Home (Activity Stream
 * [SETTING] Home>Firefox Home Content ***/
"browser.newtabpage.activity-stream.showSponsored"= false; 
"browser.newtabpage.activity-stream.showSponsoredTopSites"= false;
/* 0106: clear default topsites
 * [NOTE] This does not block you from adding your own ***/
"browser.newtabpage.activity-stream.default.sites"= "";

/*** [SECTION 0200]: GEOLOCATION ***/
/* 0201: use Mozilla geolocation service instead of Google if permission is granted [FF74+]
 * Optionally enable logging to the console (defaults to false ***/
"geo.provider.network.url"= "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";
/* 0202: disable using the OS's geolocation service ***/
"geo.provider.use_gpsd"= false; 
"geo.provider.use_geoclue"= false; 

/*** [SECTION 0300]: QUIETER FOX ***/
/** RECOMMENDATIONS ***/
/* 0320: disable recommendation pane in about:addons (uses Google Analytics ***/
"extensions.getAddons.showPane"= false; 
/* 0321: disable recommendations in about:addons' Extensions and Themes panes [FF68+] ***/
"extensions.htmlaboutaddons.recommendations.enabled"= false;
/* 0322: disable personalized Extension Recommendations in about:addons and AMO [FF65+]
 * [NOTE] This pref has no effect when Health Reports (0331 are disabled
 * [SETTING] Privacy & Security>Firefox Data Collection & Use>Allow Firefox to make personalized extension recommendations
 * [1] https://support.mozilla.org/kb/personalized-extension-recommendations ***/
"browser.discovery.enabled"= false;
/* 0323: disable shopping experience [FF116+]
 * [1] https://bugzilla.mozilla.org/show_bug.cgi?id=1840156#c0 ***/
"browser.shopping.experience2023.enabled"= false; 
/** TELEMETRY ***/
/* 0330: disable new data submission [FF41+]
 * If disabled= no policy is shown or upload takes place= ever
 * [1] https://bugzilla.mozilla.org/1195552 ***/
"datareporting.policy.dataSubmissionEnabled"= false;
/* 0331: disable Health Reports
 * [SETTING] Privacy & Security>Firefox Data Collection & Use>Allow Firefox to send technical... data ***/
"datareporting.healthreport.uploadEnabled"= false;
/* 0332: disable telemetry
 * The "unified" pref affects the behavior of the "enabled" pref
 * - If "unified" is false then "enabled" controls the telemetry module
 * - If "unified" is true then "enabled" only controls whether to record extended data
 * [NOTE] "toolkit.telemetry.enabled" is now LOCKED to reflect prerelease (true or release builds (false [2]
 * [1] https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/internals/preferences.html
 * [2] https://medium.com/georg-fritzsche/data-preference-changes-in-firefox-58-2d5df9c428b5 ***/
"toolkit.telemetry.unified"= false;
"toolkit.telemetry.enabled"= false; "toolkit.telemetry.server"= "data:=";
"toolkit.telemetry.archive.enabled"= false;
"toolkit.telemetry.newProfilePing.enabled"= false; 
"toolkit.telemetry.shutdownPingSender.enabled"= false; 
"toolkit.telemetry.updatePing.enabled"= false; 
"toolkit.telemetry.bhrPing.enabled"= false; 
"toolkit.telemetry.firstShutdownPing.enabled"= false; 
/* 0333: disable Telemetry Coverage
 * [1] https://blog.mozilla.org/data/2018/08/20/effectively-measuring-search-in-firefox/ ***/
"toolkit.telemetry.coverage.opt-out"= true; 
"toolkit.coverage.opt-out"= true; 
"toolkit.coverage.endpoint.base"= "";
/* 0334: disable PingCentre telemetry (used in several System Add-ons [FF57+]
 * Defense-in-depth: currently covered by 0331 ***/
"browser.ping-centre.telemetry"= false;
/* 0335: disable Firefox Home (Activity Stream telemetry ***/
"browser.newtabpage.activity-stream.feeds.telemetry"= false;
"browser.newtabpage.activity-stream.telemetry"= false;

/** STUDIES ***/
/* 0340: disable Studies
 * [SETTING] Privacy & Security>Firefox Data Collection & Use>Allow Firefox to install and run studies ***/
"app.shield.optoutstudies.enabled"= false;
/* 0341: disable Normandy/Shield [FF60+]
 * Shield is a telemetry system that can push and test "recipes"
 * [1] https://mozilla.github.io/normandy/ ***/
"app.normandy.enabled"= false;
"app.normandy.api_url"= "";

/** CRASH REPORTS ***/
/* 0350: disable Crash Reports ***/
"breakpad.reportURL"= "";
"browser.tabs.crashReporting.sendReport"= false; 
/* 0351: enforce no submission of backlogged Crash Reports [FF58+]
 * [SETTING] Privacy & Security>Firefox Data Collection & Use>Allow Firefox to send backlogged crash reports  ***/
"browser.crashReports.unsubmittedCheck.autoSubmit2"= false; 
/** OTHER ***/
/* 0360: disable Captive Portal detection
 * [1] https://www.eff.org/deeplinks/2017/08/how-captive-portals-interfere-wireless-security-and-privacy ***/
"captivedetect.canonicalURL"= "";
"network.captive-portal-service.enabled"= false; /* 0361: disable Network Connectivity checks [FF65+]
 * [1] https://bugzilla.mozilla.org/1460537 ***/
"network.connectivity-service.enabled"= false;

/*** [SECTION 0400]: SAFE BROWSING (SB
   SB has taken many steps to preserve privacy. If required= a full url is never sent
   to Google= only a part-hash of the prefix= hidden with noise of other real part-hashes.
   Firefox takes measures such as stripping out identifying parameters and since SBv4 (FF57+
   doesn't even use cookies. (#Turn on browser.safebrowsing.debug to monitor this activity

   [1] https://feeding.cloud.geek.nz/posts/how-safe-browsing-works-in-firefox/
   [2] https://wiki.mozilla.org/Security/Safe_Browsing
   [3] https://support.mozilla.org/kb/how-does-phishing-and-malware-protection-work
   [4] https://educatedguesswork.org/posts/safe-browsing-privacy/
***/
/* 0401: disable SB (Safe Browsing
 * [WARNING] Do this at your own risk! These are the master switches
 * [SETTING] Privacy & Security>Security>... Block dangerous and deceptive content ***/
"browser.safebrowsing.downloads.remote.enabled"= false;
/*** [SECTION 0600]: BLOCK IMPLICIT OUTBOUND [not explicitly asked for - e.g. clicked on] ***/
/* 0601: disable link prefetching
 * [1] https://developer.mozilla.org/docs/Web/HTTP/Link_prefetching_FAQ ***/
"network.prefetch-next"= false;
/* 0602: disable DNS prefetching
 * [1] https://developer.mozilla.org/docs/Web/HTTP/Headers/X-DNS-Prefetch-Control ***/
"network.dns.disablePrefetch"= true;
/* 0603: disable predictor / prefetching ***/
"network.predictor.enabled"= false;
"network.predictor.enable-prefetch"= false; 
/* 0604: disable link-mouseover opening connection to linked server
 * [1] https://news.slashdot.org/story/15/08/14/2321202/how-to-quash-firefoxs-silent-requests ***/
"network.http.speculative-parallel-limit"= 0;
/* 0605: disable mousedown speculative connections on bookmarks and history [FF98+] ***/
"browser.places.speculativeConnect.enabled"= false;
/* 0610: enforce no "Hyperlink Auditing" (click tracking
 * [1] https://www.bleepingcomputer.com/news/software/major-browsers-to-prevent-disabling-of-click-tracking-privacy-risk/ ***/

/*** [SECTION 0700]: DNS / DoH / PROXY / SOCKS ***/
/* 0702: set the proxy server to do any DNS lookups when using SOCKS
 * e.g. in Tor= this stops your local DNS server from knowing your Tor destination
 * as a remote Tor node will handle the DNS request
 * [1] https://trac.torproject.org/projects/tor/wiki/doc/TorifyHOWTO/WebBrowsers ***/
"network.proxy.socks_remote_dns"= true;
/* 0703: disable using UNC (Uniform Naming Convention paths [FF61+]
 * [SETUP-CHROME] Can break extensions for profiles on network shares
 * [1] https://bugzilla.mozilla.org/1413868 ***/
"network.file.disable_unc_paths"= true; /* 0704: disable GIO as a potential proxy bypass vector
 * Gvfs/GIO has a set of supported protocols like obex= network= archive= computer=
 * dav= cdda= gphoto2= trash= etc. From FF87-117= by default only sftp was accepted
 * [1] https://bugzilla.mozilla.org/1433507
 * [2] https://en.wikipedia.org/wiki/GVfs
 * [3] https://en.wikipedia.org/wiki/GIO_(software ***/
"network.gio.supported-protocols"= ""; 
/* 0705: disable proxy direct failover for system requests [FF91+]
 * [WARNING] Default true is a security feature against malicious extensions [1]
 * [SETUP-CHROME] If you use a proxy and you trust your extensions
 * [1] https://blog.mozilla.org/security/2021/10/25/securing-the-proxy-api-for-firefox-add-ons/ ***/
/*** [SECTION 0800]: LOCATION BAR / SEARCH BAR / SUGGESTIONS / HISTORY / FORMS ***/
/* 0801: disable location bar making speculative connections [FF56+]
 * [1] https://bugzilla.mozilla.org/1348275 ***/
"browser.urlbar.speculativeConnect.enabled"= false;
/* 0802: disable location bar contextual suggestions
 * [SETTING] Privacy & Security>Address Bar>Suggestions from...
 * [1] https://blog.mozilla.org/data/2021/09/15/data-and-firefox-suggest/ ***/
"browser.urlbar.suggest.quicksuggest.nonsponsored"= false; 
"browser.urlbar.suggest.quicksuggest.sponsored"= false; 
/* 0803: disable live search suggestions
 * [NOTE] Both must be true for the location bar to work
 * [SETUP-CHROME] Override these if you trust and use a privacy respecting search engine
 * [SETTING] Search>Provide search suggestions | Show search suggestions in address bar results ***/
"browser.search.suggest.enabled"= false;
"browser.urlbar.suggest.searches"= false;
/* 0805: disable urlbar trending search suggestions [FF118+]
 * [SETTING] Search>Search Suggestions>Show trending search suggestions (FF119 ***/
"browser.urlbar.trending.featureGate"= false;
/* 0806: disable urlbar suggestions ***/
"browser.urlbar.addons.featureGate"= false; 
"browser.urlbar.mdn.featureGate"= false; 
"browser.urlbar.pocket.featureGate"= false; 
"browser.urlbar.weather.featureGate"= false; 
/* 0807: disable urlbar clipboard suggestions [FF118+] ***/
/* 0810: disable search and form history
 * [SETUP-WEB] Be aware that autocomplete form data can be read by third parties [1][2]
 * [NOTE] We also clear formdata on exit (2811
 * [SETTING] Privacy & Security>History>Custom Settings>Remember search and form history
 * [1] https://blog.mindedsecurity.com/2011/10/autocompleteagain.html
 * [2] https://bugzilla.mozilla.org/381681 ***/
"browser.formfill.enable"= false;
/* 0815: disable tab-to-search [FF85+]
 * Alternatively= you can exclude on a per-engine basis by unchecking them in Options>Search
 * [SETTING] Privacy & Security>Address Bar>When using the address bar= suggest>Search engines ***/
/* 0820: disable coloring of visited links
 * [SETUP-HARDEN] Bulk rapid history sniffing was mitigated in 2010 [1][2]. Slower and more expensive
 * redraw timing attacks were largely mitigated in FF77+ [3]. Using RFP (4501 further hampers timing
 * attacks. Don't forget clearing history on exit (2811. However= social engineering [2#limits][4][5]
 * and advanced targeted timing attacks could still produce usable results
 * [1] https://developer.mozilla.org/docs/Web/CSS/Privacy_and_the_:visited_selector
 * [2] https://dbaron.org/mozilla/visited-privacy
 * [3] https://bugzilla.mozilla.org/1632765
 * [4] https://earthlng.github.io/testpages/visited_links.html (see github wiki APPENDIX A on how to use
 * [5] https://lcamtuf.blogspot.com/2016/08/css-mix-blend-mode-is-bad-for-keeping.html ***/
/* 0830: enable separate default search engine in Private Windows and its UI setting
 * [SETTING] Search>Default Search Engine>Choose a different default search engine for Private Windows only ***/
"browser.search.separatePrivateDefault"= true; 
"browser.search.separatePrivateDefault.ui.enabled"= true; 

/*** [SECTION 0900]: PASSWORDS
   [1] https://support.mozilla.org/kb/use-primary-password-protect-stored-logins-and-pas
***/
/* 0903: disable auto-filling username & password form fields
 * can leak in cross-site forms *and* be spoofed
 * [NOTE] Username & password is still available when you enter the field
 * [SETTING] Privacy & Security>Logins and Passwords>Autofill logins and passwords
 * [1] https://freedom-to-tinker.com/2017/12/27/no-boundaries-for-user-identities-web-trackers-exploit-browser-login-managers/
 * [2] https://homes.esat.kuleuven.be/~asenol/leaky-forms/ ***/
"signon.autofillForms"= false;
/* 0904: disable formless login capture for Password Manager [FF51+] ***/
"signon.formlessCapture.enabled"= false;
/* 0905: limit (or disable HTTP authentication credentials dialogs triggered by sub-resources [FF41+]
 * hardens against potential credentials phishing
 * 0 = don't allow sub-resources to open HTTP authentication credentials dialogs
 * 1 = don't allow cross-origin sub-resources to open HTTP authentication credentials dialogs
 * 2 = allow sub-resources to open HTTP authentication credentials dialogs (default ***/
"network.auth.subresource-http-auth-allow"= 1;
/* 0906: enforce no automatic authentication on Microsoft sites [FF91+] [WINDOWS 10+]
 * [SETTING] Privacy & Security>Logins and Passwords>Allow Windows single sign-on for...
 * [1] https://support.mozilla.org/kb/windows-sso ***/

/*** [SECTION 1000]: DISK AVOIDANCE ***/
/* 1001: disable disk cache
 * [SETUP-CHROME] If you think disk cache helps perf= then feel free to override this
 * [NOTE] We also clear cache on exit (2811 ***/
"browser.cache.disk.enable"= false;
/* 1002: disable media cache from writing to disk in Private Browsing
 * [NOTE] MSE (Media Source Extensions are already stored in-memory in PB ***/
"browser.privatebrowsing.forceMediaMemoryCache"= true; 
"media.memory_cache_max_size"= 65536;
/* 1003: disable storing extra session data [SETUP-CHROME]
 * define on which sites to save extra session data such as form content= cookies and POST data
 * 0=everywhere= 1=unencrypted sites= 2=nowhere ***/
"browser.sessionstore.privacy_level"= 2;
/* 1005: disable automatic Firefox start and session restore after reboot [FF62+] [WINDOWS]
 * [1] https://bugzilla.mozilla.org/603903 ***/
"toolkit.winRegisterApplicationRestart"= false;
/* 1006: disable favicons in shortcuts [WINDOWS]
 * URL shortcuts use a cached randomly named .ico file which is stored in your
 * profile/shortcutCache directory. The .ico remains after the shortcut is deleted
 * If set to false then the shortcuts use a generic Firefox icon ***/
"browser.shell.shortcutFavicons"= false;

/*** [SECTION 1200]: HTTPS (SSL/TLS / OCSP / CERTS / HPKP
   Your cipher and other settings can be used in server side fingerprinting
   [TEST] https://www.ssllabs.com/ssltest/viewMyClient.html
   [TEST] https://browserleaks.com/ssl
   [TEST] https://ja3er.com/
   [1] https://www.securityartwork.es/2017/02/02/tls-client-fingerprinting-with-bro/
***/
/** SSL (Secure Sockets Layer / TLS (Transport Layer Security ***/
/* 1201: require safe negotiation
 * Blocks connections to servers that don't support RFC 5746 [2] as they're potentially vulnerable to a
 * MiTM attack [3]. A server without RFC 5746 can be safe from the attack if it disables renegotiations
 * but the problem is that the browser can't know that. Setting this pref to true is the only way for the
 * browser to ensure there will be no unsafe renegotiations on the channel between the browser and the server
 * [SETUP-WEB] SSL_ERROR_UNSAFE_NEGOTIATION: is it worth overriding this for that one site?
 * [STATS] SSL Labs (Nov 2023 reports over 99.5% of top sites have secure renegotiation [4]
 * [1] https://wiki.mozilla.org/Security:Renegotiation
 * [2] https://datatracker.ietf.org/doc/html/rfc5746
 * [3] https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2009-3555
 * [4] https://www.ssllabs.com/ssl-pulse/ ***/
"security.ssl.require_safe_negotiation"= true;
/* 1206: disable TLS1.3 0-RTT (round-trip time [FF51+]
 * This data is not forward secret= as it is encrypted solely under keys derived using
 * the offered PSK. There are no guarantees of non-replay between connections
 * [1] https://github.com/tlswg/tls13-spec/issues/1001
 * [2] https://www.rfc-editor.org/rfc/rfc9001.html#name-replay-attacks-with-0-rtt
 * [3] https://blog.cloudflare.com/tls-1-3-overview-and-q-and-a/ ***/
"security.tls.enable_0rtt_data"= false;

/** OCSP (Online Certificate Status Protocol
   [1] https://scotthelme.co.uk/revocation-is-broken/
   [2] https://blog.mozilla.org/security/2013/07/29/ocsp-stapling-in-firefox/
***/
/* 1211: enforce OCSP fetching to confirm current validity of certificates
 * 0=disabled= 1=enabled (default= 2=enabled for EV certificates only
 * OCSP (non-stapled leaks information about the sites you visit to the CA (cert authority
 * It's a trade-off between security (checking and privacy (leaking info to the CA
 * [NOTE] This pref only controls OCSP fetching and does not affect OCSP stapling
 * [SETTING] Privacy & Security>Security>Certificates>Query OCSP responder servers...
 * [1] https://en.wikipedia.org/wiki/Ocsp ***/
"security.OCSP.enabled"= 1; 
/* 1212: set OCSP fetch failures (non-stapled= see 1211 to hard-fail
 * [SETUP-WEB] SEC_ERROR_OCSP_SERVER_ERROR
 * When a CA cannot be reached to validate a cert= Firefox just continues the connection (=soft-fail
 * Setting this pref to true tells Firefox to instead terminate the connection (=hard-fail
 * It is pointless to soft-fail when an OCSP fetch fails: you cannot confirm a cert is still valid (it
 * could have been revoked and/or you could be under attack (e.g. malicious blocking of OCSP servers
 * [1] https://blog.mozilla.org/security/2013/07/29/ocsp-stapling-in-firefox/
 * [2] https://www.imperialviolet.org/2014/04/19/revchecking.html ***/
"security.OCSP.require"= true;

/** CERTS / HPKP (HTTP Public Key Pinning ***/ 
/* 1223: enable strict PKP (Public Key Pinning
 * 0=disabled= 1=allow user MiTM (default; such as your antivirus= 2=strict
 * [SETUP-WEB] MOZILLA_PKIX_ERROR_KEY_PINNING_FAILURE ***/
"security.cert_pinning.enforcement_level"= 2;
/* 1224: enable CRLite [FF73+]
 * 0 = disabled
 * 1 = consult CRLite but only collect telemetry
 * 2 = consult CRLite and enforce both "Revoked" and "Not Revoked" results
 * 3 = consult CRLite and enforce "Not Revoked" results= but defer to OCSP for "Revoked" (default
 * [1] https://bugzilla.mozilla.org/buglist.cgi?bug_id=1429800=1670985=1753071
 * [2] https://blog.mozilla.org/security/tag/crlite/ ***/
"security.remote_settings.crlite_filters.enabled"= true;
"security.pki.crlite_mode"= 2;

/** MIXED CONTENT ***/
/* 1241: disable insecure passive content (such as images on https pages ***/
/* 1244: enable HTTPS-Only mode in all windows
 * When the top-level is HTTPS= insecure subresources are also upgraded (silent fail
 * [SETTING] to add site exceptions: Padlock>HTTPS-Only mode>On (after "Continue to HTTP Site"
 * [SETTING] Privacy & Security>HTTPS-Only Mode (and manage exceptions
 * [TEST] http://example.com [upgrade]
 * [TEST] http://httpforever.com/ | http://http.rip [no upgrade] ***/
"dom.security.https_only_mode"= true; 
/* 1245: enable HTTPS-Only mode for local resources [FF77+] ***/
/* 1246: disable HTTP background requests [FF82+]
 * When attempting to upgrade= if the server doesn't respond within 3 seconds= Firefox sends
 * a top-level HTTP request without path in order to check if the server supports HTTPS or not
 * This is done to avoid waiting for a timeout which takes 90 seconds
 * [1] https://bugzilla.mozilla.org/buglist.cgi?bug_id=1642387=1660945 ***/
"dom.security.https_only_mode_send_http_background_request"= false;

/** UI (User Interface ***/
/* 1270: display warning on the padlock for "broken security" (if 1201 is false
 * Bug: warning padlock not indicated for subresources on a secure page! [2]
 * [1] https://wiki.mozilla.org/Security:Renegotiation
 * [2] https://bugzilla.mozilla.org/1353705 ***/
"security.ssl.treat_unsafe_negotiation_as_broken"= true;
/* 1272: display advanced information on Insecure Connection warning pages
 * only works when it's possible to add an exception
 * i.e. it doesn't work for HSTS discrepancies (https://subdomain.preloaded-hsts.badssl.com/
 * [TEST] https://expired.badssl.com/ ***/
"browser.xul.error_pages.expert_bad_cert"= true;

/*** [SECTION 1600]: REFERERS
                  full URI: https://example.com:8888/foo/bar.html?id=1234
     scheme+host+port+path: https://example.com:8888/foo/bar.html
          scheme+host+port: https://example.com:8888
   [1] https://feeding.cloud.geek.nz/posts/tweaking-referrer-for-privacy-in-firefox/
***/
/* 1602: control the amount of cross-origin information to send [FF52+]
 * 0=send full URI (default= 1=scheme+host+port+path= 2=scheme+host+port ***/
"network.http.referer.XOriginTrimmingPolicy"= 2;

/*** [SECTION 1700]: CONTAINERS ***/
/* 1701: enable Container Tabs and its UI setting [FF50+]
 * [SETTING] General>Tabs>Enable Container Tabs
 * https://wiki.mozilla.org/Security/Contextual_Identity_Project/Containers ***/
"privacy.userContext.enabled"= true;
"privacy.userContext.ui.enabled"= true;
/* 1702: set behavior on "+ Tab" button to display container menu on left click [FF74+]
 * [NOTE] The menu is always shown on long press and right click
 * [SETTING] General>Tabs>Enable Container Tabs>Settings>Select a container for each new tab ***/
/*** [SECTION 2000]: PLUGINS / MEDIA / WEBRTC ***/
/* 2002: force WebRTC inside the proxy [FF70+] ***/
"media.peerconnection.ice.proxy_only_if_behind_proxy"= true;
/* 2003: force a single network interface for ICE candidates generation [FF42+]
 * When using a system-wide proxy= it uses the proxy interface
 * [1] https://developer.mozilla.org/en-US/docs/Web/API/RTCIceCandidate
 * [2] https://wiki.mozilla.org/Media/WebRTC/Privacy ***/
"media.peerconnection.ice.default_address_only"= true;
/* 2004: force exclusion of private IPs from ICE candidates [FF51+]
 * [SETUP-HARDEN] This will protect your private IP even in TRUSTED scenarios after you
 * grant device access= but often results in breakage on video-conferencing platforms ***/
/*** [SECTION 2400]: DOM (DOCUMENT OBJECT MODEL ***/
/* 2402: prevent scripts from moving and resizing open windows ***/
"dom.disable_window_move_resize"= true;

/*** [SECTION 2600]: MISCELLANEOUS ***/
/* 2603: remove temp files opened from non-PB windows with an external application
 * [1] https://bugzilla.mozilla.org/buglist.cgi?bug_id=302433=1738574 ***/
"browser.download.start_downloads_in_tmp_dir"= true; 
"browser.helperApps.deleteTempFileOnExit"= true;
/* 2606: disable UITour backend so there is no chance that a remote page can use it ***/
"browser.uitour.enabled"= false;
/* 2608: reset remote debugging to disabled
 * [1] https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/16222 ***/
"devtools.debugger.remote-enabled"= false; 
/* 2615: disable websites overriding Firefox's keyboard shortcuts [FF58+]
 * 0 (default or 1=allow= 2=block
 * [SETTING] to add site exceptions: Ctrl+I>Permissions>Override Keyboard Shortcuts ***/
"permissions.manager.defaultsUrl"= "";
/* 2617: remove webchannel whitelist ***/
"webchannel.allowObject.urlWhitelist"= "";
/* 2619: use Punycode in Internationalized Domain Names to eliminate possible spoofing
 * [SETUP-WEB] Might be undesirable for non-latin alphabet users since legitimate IDN's are also punycoded
 * [TEST] https://www.xn--80ak6aa92e.com/ (www.apple.com
 * [1] https://wiki.mozilla.org/IDN_Display_Algorithm
 * [2] https://en.wikipedia.org/wiki/IDN_homograph_attack
 * [3] https://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=punycode+firefox
 * [4] https://www.xudongz.com/blog/2017/idn-phishing/ ***/
"network.IDN_show_punycode"= true;
/* 2620: enforce PDFJS= disable PDFJS scripting
 * This setting controls if the option "Display in Firefox" is available in the setting below
 *   and by effect controls whether PDFs are handled in-browser or externally ("Ask" or "Open With"
 * [WHY] pdfjs is lightweight= open source= and secure: the last exploit was June 2015 [1]
 *   It doesn't break "state separation" of browser content (by not sharing with OS= independent apps.
 *   It maintains disk avoidance and application data isolation. It's convenient. You can still save to disk.
 * [NOTE] JS can still force a pdf to open in-browser by bundling its own code
 * [SETUP-CHROME] You may prefer a different pdf reader for security/workflow reasons
 * [SETTING] General>Applications>Portable Document Format (PDF
 * [1] https://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=pdf.js+firefox ***/
"pdfjs.disabled"= false; 
"pdfjs.enableScripting"= false; 
/* 2624: disable middle click on new tab button opening URLs or searches using clipboard [FF115+] */
"browser.tabs.searchclipboardfor.middleclick"= false; 

/** DOWNLOADS ***/
/* 2651: enable user interaction for security by always asking where to download
 * [SETUP-CHROME] On Android this blocks longtapping and saving images
 * [SETTING] General>Downloads>Always ask you where to save files ***/
"browser.download.useDownloadDir"= false;
/* 2652: disable downloads panel opening on every download [FF96+] ***/
"browser.download.alwaysOpenPanel"= false;
/* 2653: disable adding downloads to the system's "recent documents" list ***/
"browser.download.manager.addToRecentDocs"= false;
/* 2654: enable user interaction for security by always asking how to handle new mimetypes [FF101+]
 * [SETTING] General>Files and Applications>What should Firefox do with other files ***/
"browser.download.always_ask_before_handling_new_types"= true;

/** EXTENSIONS ***/
/* 2660: limit allowed extension directories
 * 1=profile= 2=user= 4=application= 8=system= 16=temporary= 31=all
 * The pref value represents the sum: e.g. 5 would be profile and application directories
 * [SETUP-CHROME] Breaks usage of files which are installed outside allowed directories
 * [1] https://archive.is/DYjAM ***/
"extensions.enabledScopes"= 5;
"extensions.postDownloadThirdPartyPrompt"= false;
"privacy.sanitize.sanitizeOnShutdown"= true;

/** SANITIZE ON SHUTDOWN: IGNORES "ALLOW" SITE EXCEPTIONS ***/
/* 2811: set/enforce what items to clear on shutdown (if 2810 is true [SETUP-CHROME]
 * [NOTE] If "history" is true= downloads will also be cleared
 * [NOTE] "sessions": Active Logins: refers to HTTP Basic Authentication [1]= not logins via cookies
 * [1] https://en.wikipedia.org/wiki/Basic_access_authentication ***/
"privacy.clearOnShutdown.cache"= true;     
"privacy.clearOnShutdown.downloads"= true; 
"privacy.clearOnShutdown.formdata"= true;  
"privacy.clearOnShutdown.history"= false;   
"privacy.clearOnShutdown.sessions"= false;  
/** SANITIZE ON SHUTDOWN: RESPECTS "ALLOW" SITE EXCEPTIONS FF103+ ***/
/* 2815: set "Cookies" and "Site Data" to clear on shutdown (if 2810 is true [SETUP-CHROME]
 * [NOTE] Exceptions: A "cookie" block permission also controls "offlineApps" (see note below.
 * serviceWorkers require an "Allow" permission. For cross-domain logins= add exceptions for
 * both sites e.g. https://www.youtube.com (site + https://accounts.google.com (single sign on
 * [NOTE] "offlineApps": Offline Website Data: localStorage= service worker cache= QuotaManager (IndexedDB= asm-cache
 * [WARNING] Be selective with what sites you "Allow"= as they also disable partitioning (1767271
 * [SETTING] to add site exceptions: Ctrl+I>Permissions>Cookies>Allow (when on the website in question
 * [SETTING] to manage site exceptions: Options>Privacy & Security>Permissions>Settings ***/
"privacy.clearOnShutdown.cookies"= true; 
"privacy.clearOnShutdown.offlineApps"= true; 

/** SANITIZE MANUAL: IGNORES "ALLOW" SITE EXCEPTIONS ***/
/* 2820: reset default items to clear with Ctrl-Shift-Del [SETUP-CHROME]
 * This dialog can also be accessed from the menu History>Clear Recent History
 * Firefox remembers your last choices. This will reset them when you start Firefox
 * [NOTE] Regardless of what you set "downloads" to= as soon as the dialog
 * for "Clear Recent History" is opened= it is synced to the same as "history" ***/
"privacy.cpd.cache"= true;    
"privacy.cpd.formdata"= true; 
"privacy.cpd.history"= true;  
"privacy.cpd.sessions"= true; 
"privacy.cpd.offlineApps"= false; 
"privacy.cpd.cookies"= false;
/* 2822: reset default "Time range to clear" for "Clear Recent History" (2820
 * Firefox remembers your last choice. This will reset the value when you start Firefox
 * 0=everything= 1=last hour= 2=last two hours= 3=last four hours= 4=today
 * [NOTE] Values 5 (last 5 minutes and 6 (last 24 hours are not listed in the dropdown=
 * which will display a blank value= and are not guaranteed to work ***/
"privacy.sanitize.timeSpan"= 0;

/*** [SECTION 4000]: FPP (fingerprintingProtection
   RFP (4501 overrides FPP

   In FF118+ FPP is on by default in private windows (4001 and in FF119+ is controlled
   by ETP (2701. FPP will also use Remote Services in future to relax FPP protections
   on a per site basis for compatibility (pref coming.

   1826408 - restrict fonts to system (kBaseFonts + kLangPackFonts (Windows= Mac= some Linux
      https://searchfox.org/mozilla-central/search?path=StandardFonts*.inc
   1858181 - subtly randomize canvas per eTLD+1= per session and per window-mode (FF120+
***/
/* 4001: enable FPP in PB mode [FF114+]
 * [NOTE] In FF119+= FPP for all modes (7106 is enabled with ETP Strict (2701 ***/
/* 4002: set global FPP overrides [FF114+]
 * Controls what protections FPP uses globally= including "RFPTargets" (despite the name these are
 * not used by RFP e.g. "+AllTargets=-CSSPrefersColorScheme" or "-AllTargets=+CanvasRandomization"
 * [NOTE] Be aware that not all RFP protections are necessarily in RFPTargets
 * [WARNING] Not recommended. Either use RFP or FPP at defaults
 * [1] https://searchfox.org/mozilla-central/source/toolkit/components/resistfingerprinting/RFPTargets.inc ***/

/*** [SECTION 4500]: RFP (resistFingerprinting
   RFP overrides FPP (4000

   It is an all-or-nothing buy in: you cannot pick and choose what parts you want
   [TEST] https://arkenfox.github.io/TZP/tzp.html

   [WARNING] DO NOT USE extensions to alter RFP protected metrics

    418986 - limit window.screen & CSS media queries (FF41
   1281949 - spoof screen orientation (FF50
   1330890 - spoof timezone as UTC0 (FF55
   1360039 - spoof navigator.hardwareConcurrency as 2 (FF55
 FF56
   1333651 - spoof User Agent & Navigator API
      version: android version spoofed as ESR (FF119 or lower
      OS: JS spoofed as Windows 10= OS 10.15= Android 10= or Linux | HTTP Headers spoofed as Windows or Android
   1369319 - disable device sensor API
   1369357 - disable site specific zoom
   1337161 - hide gamepads from content
   1372072 - spoof network information API as "unknown" when dom.netinfo.enabled = true
   1333641 - reduce fingerprinting in WebSpeech API
 FF57
   1369309 - spoof media statistics
   1382499 - reduce screen co-ordinate fingerprinting in Touch API
   1217290 & 1409677 - enable some fingerprinting resistance for WebGL
   1354633 - limit MediaError.message to a whitelist
 FF58+
   1372073 - spoof/block fingerprinting in MediaDevices API (FF59
      Spoof: enumerate devices as one "Internal Camera" and one "Internal Microphone"
      Block: suppresses the ondevicechange event
   1039069 - warn when language prefs are not set to "en*" (also see 0210= 0211 (FF59
   1222285 & 1433592 - spoof keyboard events and suppress keyboard modifier events (FF59
      Spoofing mimics the content language of the document. Currently it only supports en-US.
      Modifier events suppressed are SHIFT and both ALT keys. Chrome is not affected.
   1337157 - disable WebGL debug renderer info (FF60
   1459089 - disable OS locale in HTTP Accept-Language headers (ANDROID (FF62
   1479239 - return "no-preference" with prefers-reduced-motion (FF63
   1363508 - spoof/suppress Pointer Events (FF64
   1492766 - spoof pointerEvent.pointerid (FF65
   1485266 - disable exposure of system colors to CSS or canvas (FF67
   1494034 - return "light" with prefers-color-scheme (FF67
   1564422 - spoof audioContext outputLatency (FF70
   1595823 - return audioContext sampleRate as 44100 (FF72
   1607316 - spoof pointer as coarse and hover as none (ANDROID (FF74
   1621433 - randomize canvas (previously FF58+ returned an all-white canvas (FF78
   1506364 - return "no-preference" with prefers-contrast (FF80
   1653987 - limit font visibility to bundled and "Base Fonts" (Windows= Mac= some Linux (FF80
   1461454 - spoof smooth=true and powerEfficient=false for supported media in MediaCapabilities (FF82
    531915 - use fdlibm's sin= cos and tan in jsmath (FF93= ESR91.1
   1756280 - enforce navigator.pdfViewerEnabled as true and plugins/mimeTypes as hard-coded values (FF100-115
   1692609 - reduce JS timing precision to 16.67ms (previously FF55+ was 100ms (FF102
   1422237 - return "srgb" with color-gamut (FF110
   1794628 - return "none" with inverted-colors (FF114
***/
/* 4501: enable RFP
 * [SETUP-WEB] RFP can cause some website breakage: mainly canvas= use a canvas site exception via the urlbar.
 * RFP also has a few side effects: mainly timezone is UTC= and websites will prefer light theme
 * [NOTE] pbmode applies if true and the original pref is false
 * [1] https://bugzilla.mozilla.org/418986 ***/
"privacy.resistFingerprinting"= true; 
/* 4502: set new window size rounding max values [FF55+]
 * [SETUP-CHROME] sizes round down in hundreds: width to 200s and height to 100s= to fit your screen
 * [1] https://bugzilla.mozilla.org/1330882 ***/
"privacy.window.maxInnerWidth"= 1600;
"privacy.window.maxInnerHeight"= 900;
/* 4503: disable mozAddonManager Web API [FF57+]
 * [NOTE] To allow extensions to work on AMO= you also need 2662
 * [1] https://bugzilla.mozilla.org/buglist.cgi?bug_id=1384330=1406795=1415644=1453988 ***/
"privacy.resistFingerprinting.block_mozAddonManager"= true;
/* 4504: enable RFP letterboxing [FF67+]
 * Dynamically resizes the inner window by applying margins in stepped ranges [2]
 * If you use the dimension pref= then it will only apply those resolutions.
 * The format is "width1xheight1= width2xheight2= ..." (e.g. "800x600= 1000x1000"
 * [SETUP-WEB] This is independent of RFP (4501. If you're not using RFP= or you are but
 * dislike the margins= then flip this pref= keeping in mind that it is effectively fingerprintable
 * [WARNING] DO NOT USE: the dimension pref is only meant for testing
 * [1] https://bugzilla.mozilla.org/1407366
 * [2] https://hg.mozilla.org/mozilla-central/rev/6d2d7856e468#l2.32 ***/
"privacy.resistFingerprinting.letterboxing"= true; 
"browser.display.use_system_colors"= false; 
/* 4511: enforce non-native widget theme
 * Security: removes/reduces system API calls= e.g. win32k API [1]
 * Fingerprinting: provides a uniform look and feel across platforms [2]
 * [1] https://bugzilla.mozilla.org/1381938
 * [2] https://bugzilla.mozilla.org/1411425 ***/
"widget.non-native-theme.enabled"= true; /* 4512: enforce links targeting new windows to open in a new tab instead
 * 1=most recent window or tab= 2=new window= 3=new tab
 * Stops malicious window sizes and some screen resolution leaks.
 * You can still right-click a link and open in a new window
 * [SETTING] General>Tabs>Open links in tabs instead of new windows
 * [TEST] https://arkenfox.github.io/TZP/tzp.html#screen
 * [1] https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/9881 ***/
"browser.link.open_newwindow"= 3;/* 4513: set all open window methods to abide by "browser.link.open_newwindow" (4512
 * [1] https://searchfox.org/mozilla-central/source/dom/tests/browser/browser_test_new_window_from_content.js ***/
"browser.link.open_newwindow.restriction"= 0;
/* 4520: disable WebGL (Web Graphics Library
 * [SETUP-WEB] If you need it then override it. RFP still randomizes canvas for naive scripts ***/
"webgl.disabled"= true;

/*** [SECTION 5000]: OPTIONAL OPSEC
   Disk avoidance= application data isolation= eyeballs...
***/
"extensions.blocklist.enabled"= true; /* 6002: enforce no referer spoofing
 * [WHY] Spoofing can affect CSRF (Cross-Site Request Forgery protections ***/
"network.http.referer.spoofSource"= false; 
/* 6004: enforce a security delay on some confirmation dialogs such as install= open/save
 * [1] https://www.squarefree.com/2004/07/01/race-conditions-in-security-dialogs/ ***/
"security.dialog_enable_delay"= 1000;
/* 6008: enforce no First Party Isolation [FF51+]
 * [WARNING] Replaced with network partitioning (FF85+ and TCP (2701= and enabling FPI
 * disables those. FPI is no longer maintained except at Tor Project for Tor Browser's config ***/
"privacy.firstparty.isolate"= false; 
/* 6009: enforce SmartBlock shims (about:compat [FF81+]
 * [1] https://blog.mozilla.org/security/2021/03/23/introducing-smartblock/ ***/
"extensions.webcompat.enable_shims"= true; 
/* 6010: enforce no TLS 1.0/1.1 downgrades
 * [TEST] https://tls-v1-1.badssl.com:1010/ ***/
"security.tls.version.enable-deprecated"= false; 
/* 6011: enforce disabling of Web Compatibility Reporter [FF56+]
 * Web Compatibility Reporter adds a "Report Site Issue" button to send data to Mozilla
 * [WHY] To prevent wasting Mozilla's time with a custom setup ***/
"extensions.webcompat-reporter.enabled"= false;
/* 6012: enforce Quarantined Domains [FF115+]
 * [WHY] https://support.mozilla.org/kb/quarantined-domains */
"extensions.quarantinedDomains.enabled"= true; 

/*** [SECTION 7000]: DON'T BOTHER ***/
"browser.startup.homepage_override.mstone"= "ignore";
/* 9002: disable General>Browsing>Recommend extensions/features as you browse [FF67+] ***/
"browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons"= false;
"browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features"= false;
/* 9003: disable What's New toolbar icon [FF69+] ***/
"browser.messaging-system.whatsNewPanel.enabled"= false;
/* 9004: disable search terms [FF110+]
 * [SETTING] Search>Search Bar>Use the address bar for search and navigation>Show search terms instead of URL... ***/
"browser.urlbar.showSearchTerms.enabled"= false;
        };
      };
    };
}
