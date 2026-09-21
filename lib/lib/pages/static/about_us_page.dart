import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'static_page_scaffold.dart';
import 'static_page_helpers.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StaticPageScaffold(
      title: 'About Us',
      children: [
        Row(
          children: [
            pageIntroBadge(Icons.diversity_3_rounded),
            SizedBox(width: 3.2.w),
            Expanded(
              child: Text(
                'Punjab bhar ke talba tak education schemes ki maloomat asaan tareeqe se pohanchana — yehi hamara maqsad hai.',
                style: TextStyle(fontSize: 12.5.sp, color: Colors.black54, height: 1.5),
              ),
            ),
          ],
        ),
        sectionHeading('Hamari Kahani'),
        paragraph(
          'Har saal Punjab Government ki taraf se students ke liye kayi behtareen education schemes aur scholarships launch hoti hain — laptop distribution se le kar tuition scholarships tak. Magar ye maloomat aksar mukhtalif websites, notifications aur press releases mein bikhri hoti hai, jis wajah se bohat se deserving students in mauqon se faida uthane se reh jate hain. Ye app isi masle ka hal hai: ek hi jagah par, saada aur mukhtasar andaz mein.',
        ),
        sectionHeading('Hamara Maqsad'),
        bulletLine('Punjab ki major education schemes ko ek jagah collect karna.'),
        bulletLine('Har scheme ka mukhtasar magar mukammal overview dena, taake talba jald samajh saken.'),
        bulletLine('Students ko seedha official Punjab Govt websites tak guide karna, jahan wo apply kar saken.'),
        bulletLine('Maloomat ko jitna mumkin ho, up-to-date rakhna.'),
        sectionHeading('Hum Kya Karte Hain'),
        paragraph(
          'Hamari team available public maloomat ko research kar ke har scheme ki eligibility, benefits aur application process ka khulasa banati hai. Application process khud humare app mein nahi hota — hum har waqt aapko official Punjab Government portal ki taraf refer karte hain, taake application 100% authentic aur secure rahe.',
        ),
        sectionHeading('Independence Disclaimer'),
        paragraph(
          'Ye website/app independent hai aur Punjab Government se officially affiliated nahi hai. Isay Punjab Government ka koi department chalata nahi. Hum sirf ek informational bridge hain, is liye hamesha final aur latest maloomat ke liye sarkari website ko authoritative source samjha jaye.',
        ),
        sectionHeading('Hamara Wada'),
        paragraph('Hum accuracy aur transparency ki koshish karte hain, lekin schemes ki details tabdeel ho sakti hain. Agar aap ko koi ghalti nazar aye, to Contact Us page ke zariye humein zaroor batayen — hum jald update karenge.'),
      ],
    );
  }
}
