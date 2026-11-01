/****************************************************************************
 * Eigene Overrides, werden ans Ende der Betterfox user.js gehaengt.
 * Spaetere Eintraege gewinnen, daher ueberschreibt alles hier Betterfox.
 * Hinweis: user.js wird bei jedem Start angewendet. Wer etwas dauerhaft
 * aendern will, aendert es hier im Repo und laesst das Skript neu laufen.
 ****************************************************************************/

/** OBERFLAECHE: Nova, kompakt ***/
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true); // userChrome.css erlauben
user_pref("browser.nova.enabled", true);
user_pref("browser.compactmode.show", true);
user_pref("browser.uidensity", 1);
// Webseiten immer hell darstellen, unabhaengig vom dunklen Firefox-Theme (0 = dunkel, 1 = hell, 2 = wie Theme)
user_pref("layout.css.prefers-color-scheme.content-override", 1);
user_pref("browser.toolbars.bookmarks.visibility", "always");   // wie die Edge-Favoritenleiste
user_pref("browser.toolbars.bookmarks.showOtherBookmarks", true); // "Weitere Lesezeichen" rechts, wie in Edge

/** TABS OBEN WIE IN EDGE, TAB-GRUPPEN AN ***/
user_pref("sidebar.revamp", true);
user_pref("sidebar.verticalTabs", false);
user_pref("sidebar.visibility", "hide-sidebar");   // keine Seitenleiste am Rand, nur bei Bedarf ueber das Menue
user_pref("sidebar.expandOnHover", false);
user_pref("browser.tabs.groups.enabled", true);

/** TAB-VERHALTEN WIE EDGE ***/
user_pref("browser.tabs.insertRelatedAfterCurrent", true);  // Links aus einem Tab landen direkt darunter
user_pref("browser.tabs.insertAfterCurrent", false);        // Strg+T haengt den neuen Tab ans Ende
user_pref("browser.tabs.selectOwnerOnClose", true);         // nach dem Schliessen zurueck zum Ursprungstab
user_pref("browser.ctrlTab.sortByRecentlyUsed", false);     // Strg+Tab der Reihe nach, nicht nach Verlauf
user_pref("browser.tabs.loadInBackground", true);           // Mittelklick oeffnet im Hintergrund
user_pref("browser.link.open_newwindow", 3);                // Links, die ein neues Fenster wollen, als Tab
user_pref("browser.tabs.warnOnClose", false);               // keine Rueckfrage beim Schliessen, Sitzung kommt ja wieder
user_pref("browser.tabs.hoverPreview.enabled", true);       // Vorschaukarte beim Ueberfahren eines Tabs
user_pref("browser.tabs.hoverPreview.showThumbnails", true);
user_pref("browser.tabs.splitView.enabled", true);          // geteilte Ansicht: zwei Tabs markieren, Rechtsklick

/** SITZUNG WIEDERHERSTELLEN (Arc, Vivaldi) ***/
user_pref("browser.startup.page", 3);
user_pref("browser.tabs.closeWindowWithLastTab", false);

/** SCHLAFENDE TABS (Edge) ***/
user_pref("browser.tabs.unloadOnLowMemory", true);

/** ADRESSLEISTE ALS RECHNER UND EINHEITENUMRECHNER (Chrome) ***/
user_pref("browser.urlbar.suggest.calculator", true);
user_pref("browser.urlbar.unitConversion.enabled", true);
user_pref("browser.urlbar.trimHttps", true);

/** WEICHES SCROLLEN WIE IN CHROMIUM ***/
user_pref("general.smoothScroll.msdPhysics.enabled", true);

/** PRIVATSPHAERE (Brave, LibreWolf) ***/
user_pref("privacy.globalprivacycontrol.enabled", true);
user_pref("dom.private-attribution.submission.enabled", false);

/** KI-FUNKTIONEN AUS ***/
user_pref("browser.ml.enable", false);
user_pref("browser.ml.chat.enabled", false);
user_pref("browser.ml.linkPreview.enabled", false);
user_pref("browser.tabs.groups.smart.enabled", false);
user_pref("extensions.ml.enabled", false);

/** PASSWOERTER UND FORMULARE UEBER 1PASSWORD ***/
user_pref("signon.rememberSignons", false);
user_pref("signon.autofillForms", false);
user_pref("extensions.formautofill.creditCards.enabled", false);
user_pref("extensions.formautofill.addresses.enabled", false);

/** FIREFOX SYNC: was synchronisiert wird (Passwoerter und Zahlungsdaten bleiben bei 1Password) ***/
user_pref("services.sync.engine.bookmarks", true);
user_pref("services.sync.engine.history", true);
user_pref("services.sync.engine.tabs", true);
user_pref("services.sync.engine.addons", true);
user_pref("services.sync.engine.prefs", true);
user_pref("services.sync.engine.passwords", false);
user_pref("services.sync.engine.addresses", false);
user_pref("services.sync.engine.creditcards", false);

/** DRM AN, DAMIT NETFLIX UND CO. LAUFEN (anders als LibreWolf) ***/
user_pref("media.eme.enabled", true);

/** KLEINIGKEITEN ***/
user_pref("findbar.highlightAll", true);
