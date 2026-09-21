# Punjab Education Schemes (Flutter Web)

Green/gold/white color scheme, CM Punjab header, aur 5 education schemes ki list.

**Flow:** Home (scheme cards, short detail) → card pe click → Ad page (3 sec placeholder) → Detail page (poori detail) → "Home pe wapas jayen".

## Chalane ka tareeqa
```bash
flutter pub get
flutter run -d chrome
```

## Web ke liye build
```bash
flutter build web
```
Output `build/web` folder mein banega.

## Content/Schemes edit karna
`lib/main.dart` mein sab se upar `schemeItems` list hai — har scheme ka `title`, `shortDesc` (home pe) aur `fullDetail` (detail page pe) yahan hai. Naya scheme add karna ho to isi list mein ek aur `SchemeItem(...)` daal dein.

## ZAROORI — Images ke baare mein
Is app mein filhaal **CM Punjab ki tasveer aur schemes ki images placeholder (icons) ke tor par** hain, asal photos nahi. Wajah:

1. **Copyright**: Kisi bhi real cheif minister ya government scheme ki tasveer copyrighted ho sakti hai. Bina permission/license ke istemal karna copyright violation ban sakta hai.
2. Behtar tareeqa: Punjab Government ki **official website/social media (verified pages)** se images download karen jahan wo public-use ke liye specifically share ki gayi hon, ya phir apne official press-kit se image lein.
3. Image lagane ke liye code mein jahan `TODO` comments hain (HomePage header, scheme card, DetailPage), wahan `Container` ki jagah `Image.asset('assets/images/xyz.png')` ya `Image.network('https://...')` use karen.

## Content ki accuracy
Schemes ka detail is app mein **general/summary style** mein hai (public reports par based, 2026). Eligibility, numbers, aur apply karne ka tareeqa waqt ke sath badalta rehta hai — publish karne se pehle **Punjab Government ki official website** se cross-check zaroor karen, taake ghalat information na phaile.

## Real ads kaise lagayen
Flutter Web pe AdMob/Meta ke mobile SDK kaam nahi karte. Website ke liye **Google AdSense** ka HTML/JS script `web/index.html` mein daalna hoga, aur `AdPage` mein jahan "AD PLACEHOLDER" hai wahan asli ad-unit embed karni hogi.
