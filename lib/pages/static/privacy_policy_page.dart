import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'static_page_scaffold.dart';
import 'static_page_helpers.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StaticPageScaffold(
      title: 'Privacy Policy',
      children: [
        Row(
          children: [
            pageIntroBadge(Icons.privacy_tip_rounded),
            SizedBox(width: 3.2.w),
            Expanded(
              child: Text(
                'Aapki privacy hamare liye ahem hai. Neeche wazeh alfaaz mein bataya gaya hai ke hum kya maloomat handle karte hain.',
                style: TextStyle(fontSize: 12.5.sp, color: Colors.black54, height: 1.5),
              ),
            ),
          ],
        ),
        paragraph('Last updated: September 2026'),
        sectionHeading('Overview'),
        paragraph(
          'Punjab Education Schemes app/website Punjab ke education-related sarkari schemes (jaise Laptop Scheme, Honhaar Scholarship, PEEF, TEVTA, wagera) ke baare mein asaan aur mukhtasar maloomat faraham karta hai. Ye ek independent, informational resource hai aur Punjab Government ki taraf se officially operate nahi kiya jata.',
        ),
        sectionHeading('Information We Collect'),
        paragraph('App istemal karne ke liye aapko koi personal account banane ya apna naam, email, ya phone number dene ki zaroorat nahi hoti. Phir bhi kuch technical maloomat automatically collect ho sakti hai:'),
        bulletLine('Device type, browser/app version aur operating system (crash-free performance ke liye).'),
        bulletLine('Anonymous usage patterns, jaise kaunsi scheme cards zyada dekhi jati hain.'),
        bulletLine('Approximate location (agar app permission se allow ki gayi ho), sirf content ko relevant banane ke liye.'),
        sectionHeading('Advertising & Cookies'),
        paragraph(
          'Ye app third-party advertising networks (jaise Adsterra) use karti hai taake app ko chalane ki cost cover ho sake. Ye networks cookies ya similar technologies ke zariye anonymous, non-personally-identifiable data collect kar sakte hain, taake relevant ads dikhayi ja saken. Hum khud kisi bhi ad network ko aapki personal maloomat faraham nahi karte.',
        ),
        sectionHeading('How We Use Information'),
        bulletLine('App ko behtar banane aur bugs theek karne ke liye.'),
        bulletLine('Content aur schemes list ko relevant rakhne ke liye.'),
        bulletLine('Ad networks ke zariye app ko sustainable rakhne ke liye.'),
        paragraph('Hum aapki maloomat kabhi bhi kisi teesri party ko becha nahi karte.'),
        sectionHeading('Third-Party / Official Links'),
        paragraph(
          'Ye app kabhi kabhi aapko official Punjab Government websites ya dusre external links par bhejti hai taake aap authentic maloomat dekh saken. Ek dafa aap in websites par pohanch jayen, wahan ki apni alag privacy policy lagu hoti hai — hum un websites ke content ya practices ke zimmedar nahi hain.',
        ),
        sectionHeading("Children's Privacy"),
        paragraph('Ye app students aur unke walidain ke liye general informational content faraham karti hai. Hum jaan-boojh kar kisi bhi umar ke bachon se personal maloomat collect nahi karte.'),
        sectionHeading('Changes to This Policy'),
        paragraph('Ye privacy policy waqtan-fawqtan update ho sakti hai. Koi bhi badi tabdeeli is page par reflect ho jayegi, is liye kabhi kabhi is page ko dobara check kar liya karen.'),
        sectionHeading('Contact'),
        paragraph('Agar aapke is privacy policy ke baare mein koi sawal hon, to hamein Contact Us page ke zariye rabta karen.'),
      ],
    );
  }
}
