import 'package:flutter/material.dart';
import '../models/scheme_item.dart';

const List<SchemeItem> schemeItems = [
  SchemeItem(
    title: 'CM Punjab Laptop Scheme',
    shortDesc: 'Talented students ko free laptop diya jata hai.',
    fullDetail:
        'Is scheme ke tehat Punjab bhar ke deserving students ko digital learning ko asaan banane ke liye free laptops diye ja rahe hain. Pehle phase mein chhoti tadad se shuru hone wala ye program ab lakhon students tak barhaya ja chuka hai, taake talba online resources aur digital tools tak behtar rasai hasil kar saken. Apply karne ke liye apne college/university ke through official Punjab portal check karen.',
    icon: Icons.laptop_mac_rounded,
    officialUrl: 'https://cmlaptophed.punjab.gov.pk/',
    imageAsset: 'assets/cmlaptopscheme.jpg', // TEST image — pehla card
  ),
  SchemeItem(
    title: 'Honhaar Scholarship Program',
    shortDesc: 'Talented students ke liye full tuition scholarship.',
    fullDetail:
        'Honhaar Scholarship Program un talba ke liye hai jo mehnati hain magar financial masail ki wajah se apni taleem jari rakhne mein mushkil mehsoos karte hain. Is program mein tuition fee ki mukammal ya jazbi coverage di jati hai, sath hi dusri educational support bhi shamil hoti hai. Hazaron students har saal is scholarship se faida uthate hain.',
    icon: Icons.school_rounded,
    officialUrl: 'https://honhaarscholarship.punjabhec.gov.pk/',imageAsset: 'assets/Honhaar-scholarship-program.jpg'
   
  ),
  SchemeItem(
    title: 'School Teacher Internship (STI)',
    shortDesc: 'Fresh graduates ke liye paid teaching internship.',
    fullDetail:
        'School Teacher Internship Program fresh graduates ko government schools mein teaching ka practical tajurba hasil karne ka moka deta hai, sath hi ek maasiyana stipend bhi milta hai. Ye program naye teachers ko classroom experience aur professional training dono faraham karta hai, jo unki future teaching career ke liye faidamand sabit hota hai.',
    icon: Icons.person_pin_circle_rounded,
    officialUrl: 'https://hed.punjab.gov.pk/',imageAsset: 'assets/internshipprogramme.jpg',
  ),
  SchemeItem(
    title: 'PEEF Scholarships',
    shortDesc: 'Punjab Educational Endowment Fund ki financial support.',
    fullDetail:
        'Punjab Educational Endowment Fund (PEEF) un deserving students ko scholarships deta hai jo school, college ya university level par acadmically achi performance rakhte hain magar aage taleem jari rakhne ke liye financial madad ki zaroorat hoti hai. Har saal naye applications open hote hain, jinki eligibility income aur academic record par depend karti hai.',
    icon: Icons.account_balance_rounded,
    officialUrl: 'https://www.peef.org.pk/',
  imageAsset: 'assets/peefprogramme.jpg',
  ),
  SchemeItem(
    title: 'TEVTA Skill Development',
    shortDesc: 'Youth ke liye technical & vocational training.',
    fullDetail:
        'TEVTA (Technical Education and Vocational Training Authority) ke tehat ye program nojawano ko market-oriented technical aur vocational skills sikhata hai — jaise IT, trades, aur dusre professional courses — taake unki employability behtar ho aur wo job market mein khud ko behtar tareeqe se establish kar saken.',
    icon: Icons.build_circle_rounded,
    officialUrl: 'https://tevta.gop.pk/',
     imageAsset: 'assets/cmTevtaprogramme.jpg'
  ),
];
