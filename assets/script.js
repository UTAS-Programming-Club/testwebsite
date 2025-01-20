function UpdateMode(dark) {
  const preferDark = matchMedia('(prefers-color-scheme: dark)').matches;
  document.getElementById("dark-mode-toggle").checked = dark ^ preferDark;
}

function UpdateUrl(url, dark) {
  const urlObj = new URL(url);
  urlObj.searchParams.set("mode", dark ? "dark" : "light");
  return urlObj;
}

function FindUrl(link) {
  const url = new URL(link);
  return url.href.startsWith(location.origin) && url.pathname.endsWith(".html") &&
         link.ariaCurrent != "page";
}

function UpdateNavItems(dark) {
  const links = [...document.getElementsByTagName("a")];
  const siteLinks = links.filter(FindUrl);
  for (let link of siteLinks) {
    link.href = UpdateUrl(link.href, dark);
  }
}

addEventListener("DOMContentLoaded", (event) => {
  const urlMode = new URLSearchParams(location.search).get("mode");
  let dark = urlMode == "dark";
  if (!urlMode) {
    dark = matchMedia('(prefers-color-scheme: dark)').matches;
  }
  UpdateMode(dark);
  history.pushState({}, null, UpdateUrl(location, dark));
  UpdateNavItems(dark);

  const jsOnlyElements = [...document.getElementsByClassName("js-only")];
  for (let element of jsOnlyElements) {
    element.hidden = false;
  }
});

matchMedia('(prefers-color-scheme: dark)').addEventListener('change', event => {
  UpdateMode(event.matches);
  history.pushState({}, null, UpdateUrl(location, event.matches));
  UpdateNavItems(event.matches);
});

// TODO: Check for ?dark being removed via browser back and change to light mode
function ToggleDarkMode() {
  const dark = new URLSearchParams(location.search).get("mode") == "dark";
  // TODO: Fix this being flipped
  UpdateMode(dark);
  history.pushState({}, null, UpdateUrl(location, !dark));
  UpdateNavItems(!dark);
}
