/****************************************************************************
 * Eigene Overrides, werden ans Ende der Betterfox user.js gehaengt.
 * Spaetere Eintraege gewinnen, daher ueberschreibt alles hier Betterfox.
 * Hinweis: user.js wird bei jedem Start angewendet. Wer etwas dauerhaft
 * aendern will, aendert es hier im Repo und laesst das Skript neu laufen.
 ****************************************************************************/

/** OBERFLAECHE: Nova, kompakt ***/
user_pref("browser.nova.enabled", true);
user_pref("browser.compactmode.show", true);
user_pref("browser.uidensity", 1);
user_pref("browser.toolbars.bookmarks.visibility", "never");

/** VERTIKALE TABS UND TAB-GRUPPEN (Arc, Zen, Edge) ***/
user_pref("sidebar.revamp", true);
user_pref("sidebar.verticalTabs", true);
user_pref("browser.tabs.groups.enabled", true);

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

/** DRM AN, DAMIT NETFLIX UND CO. LAUFEN (anders als LibreWolf) ***/
user_pref("media.eme.enabled", true);

/** KLEINIGKEITEN ***/
user_pref("findbar.highlightAll", true);
