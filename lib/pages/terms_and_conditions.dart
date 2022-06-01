import 'package:flutter/material.dart';
import '../components/modules/my_app_bar.dart';
import '../components/modules/my_drawer_phone.dart';
import '../utility_methods.dart';

const double title = 20.0;
const double description = 19.0;
const double titleHeight = 13.0;
const double descriptionHeight = 10.0;

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Terms & Conditions',
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: const MyDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: kPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Updated at 2021-09-27',
                style: kTextStyle(size: 23.0),
              ),
              const SizedBox(height: 22.0),
              Text(
                'General Terms',
                style: kTextStyle(size: title)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'By using PoS, you confirm that you are in agreement with and bound by the terms of service contained in the Terms & Conditions outlined below. These terms apply to the user of POS',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: descriptionHeight),
              Text(
                'PoS will not be responsible for any outcome that may occur during the course of usage of our resources. We reserve the rights to change prices and revise the resources usage policy in any moment.',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'License',
                style: kTextStyle(size: title)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'RCS grants you a revocable, non-exclusive, non-transferable, limited license to use the app strictly in accordance with the terms of this Agreement.',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: descriptionHeight),
              Text(
                'These Terms & Conditions are a contract between you and RCS (referred to in these Terms & Conditions as “RCS”, "us", "we" or "our"), the provider of the RCS website and the services accessible from the RCS company (which are collectively referred to in these Terms & Conditions as the "RCS Service").',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: descriptionHeight),
              Text(
                'You are agreeing to be bound by these Terms & Conditions. If you do not agree to these Terms & Conditions, please do not use the RCS Service. In these Terms & Conditions, "you" refers both to you  as an individual and to the entity you represent. If you violate any of these Terms & Conditions, we reserve the right to delete your POS software and you agree to indemnify.',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'Meanings',
                style: kTextStyle(size: title)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'For this Terms & Conditions:',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: descriptionHeight),
              Text(
                '-Company: when this policy mentions ‚“Company”, “we”, “us” , or “our”, it refers to RCS, (Mandalay) that is responsible for your information under this Terms & Conditions.',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: descriptionHeight),
              Text(
                ' -Country: where PoS or the owners/founders of PoS are based, in this case is Myanmar',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: descriptionHeight),
              Text(
                '-Device: any internet connected device such as a phone and tablet that can be used to run POS and use the services.',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: descriptionHeight),
              Text(
                ' -Service: refers to the service provided by RCS as described in the relative terms (if available) and on this platform.',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: descriptionHeight),
              Text(
                ' -Third-party service: refers to advertisers, contest sponsors, promotional and marketing partners, and others who provide our content or whose products or services we think may interest you.',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: descriptionHeight),
              Text(
                ' -Website: RCS’s site, which can be accessed via this URL: www.rcs-mm.com',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: descriptionHeight),
              Text(
                ' -You: a person or entity that is using PoS and RCS Services',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'Restrictions',
                style: kTextStyle(size: title)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'You agree not to, and you will not permit others to',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: descriptionHeight),
              Text(
                '-License, sell, rent, lease, assign, distribute, transmit, host, outsource, disclose or otherwise commercially exploit the app or make the platform available to any third party',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: descriptionHeight),
              Text(
                ' -Modify, make derivative works of, disassemble, decrypt, reverse compile or reverse engineer any part of the app.',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: descriptionHeight),
              Text(
                ' -Remove, alter or obscure any proprietary notice (including any notice of copyright or trademark) of PoS or its affiliates, partners, suppliers or the licensors of the app.',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'Return and Refund Policy',
                style: kTextStyle(size: title)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'Thanks for shopping at RCS. We appreciate the fact that you like to buy the stuff we build. We also want to make sure you have a rewarding experience while you’re exploring, evaluating, and purchasing our products.',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: descriptionHeight),
              Text(
                'As with any shopping experience, there are terms and conditions that apply to transactions at POS. We’ll be as brief as our attorneys will allow. The main thing to remember is that by using POS, you agree to the terms along with RCS’s Privacy Policy.',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: descriptionHeight),
              Text(
                "If, for any reason, You are not completely satisfied with any good or service that we provide, don't hesitate to contact us and we will discuss any of the issues you are going through with our product.",
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'Your Suggestions',
                style: kTextStyle(size: title)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'Any feedback, comments, ideas, improvements or suggestions (collectively, "Suggestions") provided by you to POS with respect to the app shall remain the sole and exclusive property of POS.',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: descriptionHeight),
              Text(
                'RCS shall be free to use, copy, modify, publish, or redistribute the Suggestions for any purpose and in any way without any credit or any compensation to you.',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'Your Consent',
                style: kTextStyle(size: title)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: titleHeight),
              Text(
                "We've updated our Terms & Conditions to provide you with complete transparency into what is being set when you visit our site and how it's being used. By using our app, or buying, you hereby consent to our Terms & Conditions.",
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'Changes To Our Terms & Conditions',
                style: kTextStyle(size: title)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'You acknowledge and agree that RCS may stop (permanently or temporarily) providing the Service (or any features within the Service) to you or to users generally at RCS’s sole discretion, without prior notice to you. You may stop using the Service at any time. You do not need to specifically inform RCS when you stop using the Service. ',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: descriptionHeight),
              Text(
                'If we decide to change our Terms & Conditions, we will post those changes on RCS website, and/or update the Terms & Conditions modification date below.',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'Modifications to Our app',
                style: kTextStyle(size: title)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'RCS reserves the right to modify, suspend or discontinue, temporarily or permanently, the app or any service to which it connects, with or without notice and without liability to you.',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'Updates to Our app',
                style: kTextStyle(size: title)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'RCS may from time to time provide enhancements or improvements to the features/ functionality of the app, which may include patches, bug fixes, updates, upgrades and other modifications ("Updates").',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: descriptionHeight),
              Text(
                'Updates may modify or delete certain features and/or functionalities of the app. You agree that RCS has no obligation to (i) provide any Updates, or (ii) continue to provide or enable any particular features and/or functionalities of the app to you.',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: descriptionHeight),
              Text(
                'You further agree that all Updates will be (i) deemed to constitute an integral part of the app, and (ii) subject to the terms and conditions of this Agreement.',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'Copyright Infringement Notice',
                style: kTextStyle(size: title)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'If you are a copyright owner or such owner’s agent and believe any material on our app constitutes an infringement on your copyright, please contact us setting forth the following information: (a) a physical or electronic signature of the copyright owner or a person authorized to act on his behalf; (b) identification of the material that is claimed to be infringing; (c) your contact information, including your address, telephone number, and an email; (d) a statement by you that you have a good faith belief that use of the material is not authorized by the copyright owners; and (e) the a statement that the information in the notification is accurate, and, under penalty of perjury you are authorized to act on behalf of the owner.',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'Indemnification',
                style: kTextStyle(size: title)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: titleHeight),
              Text(
                "You agree to indemnify and hold RCS and its parents, subsidiaries, affiliates, officers, employees, agents, partners and licensors (if any) harmless from any claim or demand, including reasonable attorneys' fees, due to or arising out of your: (a) use of the app; (b) violation of this Agreement or any law or regulation; or (c) violation of any right of a third party.",
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: titleHeight),
              Text(
                "Severability",
                style: kTextStyle(size: title)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'If any provision of this Agreement is held to be unenforceable or invalid, such provision will be changed and interpreted to accomplish the objectives of such provision to the greatest extent possible under applicable law and the remaining provisions will continue in full force and effect.',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: descriptionHeight),
              Text(
                'This Agreement, together with the Privacy Policy and any other legal notices published by RCS on the Services, shall constitute the entire agreement between you and RCS concerning the Services. If any provision of this Agreement is deemed invalid by a court of competent jurisdiction, the invalidity of such provision shall not affect the validity of the remaining provisions of this Agreement, which shall remain in full force and effect. No waiver of any term of this Agreement shall be deemed a further or continuing waiver of such term or any other term, and RCS’s failure to assert any right or provision under this Agreement shall not constitute a waiver of such right or provision. YOU AND RCS AGREE THAT ANY CAUSE OF ACTION ARISING OUT OF OR RELATED TO THE SERVICES MUST COMMENCE WITHIN ONE (1) YEAR AFTER THE CAUSE OF ACTION ACCRUES. OTHERWISE, SUCH CAUSE OF ACTION IS PERMANENTLY BARRED.',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'Waiver',
                style: kTextStyle(size: title)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: titleHeight),
              Text(
                "Except as provided herein, the failure to exercise a right or to require performance of an obligation under this Agreement shall not effect a party's ability to exercise such right or require such performance at any time thereafter nor shall be the waiver of a breach constitute waiver of any subsequent breach.",
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: descriptionHeight),
              Text(
                'No failure to exercise, and no delay in exercising, on the part of either party, any right or any power under this Agreement shall operate as a waiver of that right or power. Nor shall any single or partial exercise of any right or power under this Agreement preclude further exercise of that or any other right granted herein. In the event of a conflict between this Agreement and any applicable purchase or other terms, the terms of this Agreement shall govern.',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'Amendments to this Agreement',
                style: kTextStyle(size: title)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: titleHeight),
              Text(
                "RCS reserves the right, at its sole discretion, to modify or replace this Agreement at any time. If a revision is material we will provide at least 30 days' notice prior to any new terms taking effect. What constitutes a material change will be determined at our sole discretion.",
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: descriptionHeight),
              Text(
                'By continuing to access or use our app after any revisions become effective, you agree to be bound by the revised terms. If you do not agree to the new terms, you are no longer authorized to use RCS.',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'Entire Agreement',
                style: kTextStyle(size: title)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: titleHeight),
              Text(
                "The Agreement constitutes the entire agreement between you and RCS regarding your use of the app and supersedes all prior and contemporaneous written or oral agreements between you and RCS. You may be subject to additional terms and conditions that apply when you use or purchase other RCS's services, which RCS will provide to you at the time of such use or purchase.",
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'Updates to Our Terms',
                style: kTextStyle(size: title)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'We may change our Service and policies, and we may need to make changes to these Terms so that they accurately reflect our Service and policies. Unless otherwise required by law, we will notify you (for example, through our Service) before we make changes to these Terms and give you an opportunity to review them before they go into effect. Then, if you continue to use the Service, you will be bound by the updated Terms. If you do not want to agree to these or any updated Terms, you can not update your POS software.',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'Intellectual Property',
                style: kTextStyle(size: title)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'The app and its entire contents, features and functionality (including but not limited to all information, software, text, displays, images, video and audio, and the design, selection and arrangement thereof), are owned by RCS, its licensors or other providers of such material and are protected by Myanmar and international copyright, trademark, patent, trade secret and other intellectual property or proprietary rights laws. The material may not be copied, modified, reproduced, downloaded or distributed in any way, in whole or in part, without the express prior written permission of RCS, unless and except as is expressly provided in these Terms & Conditions. Any unauthorized use of the material is prohibited.',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'Agreement to Arbitrate',
                style: kTextStyle(size: title)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'This section applies to any dispute EXCEPT IT DOESN’T INCLUDE A DISPUTE RELATING TO CLAIMS FOR INJUNCTIVE OR EQUITABLE RELIEF REGARDING THE ENFORCEMENT OR VALIDITY OF YOUR OR RCS’s INTELLECTUAL PROPERTY RIGHTS. The term “dispute” means any dispute, action, or other controversy between you and RCS concerning the Services or this agreement, whether in contract, warranty, tort, statute, regulation, ordinance, or any other legal or equitable basis. “Dispute” will be given the broadest possible meaning allowable under law.',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'Notice of Dispute',
                style: kTextStyle(size: title)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'In the event of a dispute, you or RCS must give the other a Notice of Dispute, which is a written statement that sets forth the name, address, and contact information of the party giving it, the facts giving rise to the dispute, and the relief requested. You must send any Notice of Dispute via email to: contact@rcs-mm.com. RCS will send any Notice of Dispute to you by mail to your address if we have it, or otherwise to your email address. You and RCS will attempt to resolve any dispute through informal negotiation within sixty (60) days from the date the Notice of Dispute is sent. After sixty (60) days, you or RCS may commence arbitration.',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'Binding Arbitration',
                style: kTextStyle(size: title)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'If you and RCS don’t resolve any dispute by informal negotiation, any other effort to resolve the dispute will be conducted exclusively by binding arbitration as described in this section. You are giving up the right to litigate (or participate in as a party or class member) all disputes in court before a judge or jury. The dispute shall be settled by binding arbitration in accordance with the commercial arbitration rules of Myanmar. Either party may seek any interim or preliminary injunctive relief from any court of competent jurisdiction, as necessary to protect the party’s rights or property pending the completion of arbitration. Any and all legal, accounting, and other costs, fees, and expenses incurred by the prevailing party shall be borne by the non-prevailing party.',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'Submissions and Privacy',
                style: kTextStyle(size: title)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'In the event that you submit or post any ideas, creative suggestions, designs, photographs, information, advertisements, data or proposals, including ideas for new or improved products, services, features, technologies or promotions, you expressly agree that such submissions will automatically be treated as non-confidential and non-proprietary and will become the sole property of RCS without any compensation or credit to you whatsoever. RCS and its affiliates shall have no obligations with respect to such submissions or posts and may use the ideas contained in such submissions or posts for any purposes in any medium in perpetuity, including, but not limited to, developing, manufacturing, and marketing products and services using such ideas.',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'Promotions',
                style: kTextStyle(size: title)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'RCS may, from time to time, include contests, promotions, sweepstakes, or other activities (“Promotions”) that require you to submit material or information concerning yourself. Please note that all Promotions may be governed by separate rules that may contain certain eligibility requirements, such as restrictions as to age and geographic location. You are responsible to read all Promotions rules to determine whether or not you are eligible to participate. If you enter any Promotion, you agree to abide by and to comply with all Promotions Rules.',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: descriptionHeight),
              Text(
                "Additional terms and conditions may apply to purchases of goods or services on or through the Services, which terms and conditions are made a part of this Agreement by this reference.",
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'Typographical Errors',
                style: kTextStyle(size: title)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'In the event a product and/or service is listed at an incorrect price or with incorrect information due to typographical error, we shall have the right to refuse or cancel any orders placed for the product and/or service listed at the incorrect price. We shall have the right to refuse or cancel any such order. ',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'Miscellaneous',
                style: kTextStyle(size: title)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'If for any reason a court of competent jurisdiction finds any provision or portion of these Terms & Conditions to be unenforceable, the remainder of these Terms & Conditions will continue in full force and effect. Any waiver of any provision of these Terms & Conditions will be effective only if in writing and signed by an authorized representative of RCS. RCS will be entitled to injunctive or other equitable relief (without the obligations of posting any bond or surety) in the event of any breach or anticipatory breach by you. RCS operates and controls the RCS Service from its offices in Myanmar. The Service is not intended for distribution to or use by any person or entity in any jurisdiction or country where such distribution or use would be contrary to law or regulation. Accordingly, those persons who choose to buy the RCS Service from other locations do so on their own initiative and are solely responsible for compliance with local laws, if and to the extent local laws are applicable. These Terms & Conditions (which include and incorporate the RCS Privacy Policy) contains the entire understanding, and supersedes all prior understandings, between you and P RCS concerning its subject matter, and cannot be changed or modified by you. The section headings used in this Agreement are for convenience only and will not be given any legal import.',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'Disclaimer',
                style: kTextStyle(size: title)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'RCS is not responsible for any content, code or any other imprecision.',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: descriptionHeight),
              Text(
                'RCS does not provide warranties or guarantees.',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: descriptionHeight),
              Text(
                'In no event shall RCS be liable for any special, direct, indirect, consequential, or incidental damages or any damages whatsoever, whether in an action of contract, negligence or other tort, arising out of or  in connection with the use of the Service or the contents of the Service. RCS reserves the right to make additions, deletions, or modifications to the contents on the Service at any time without prior notice.',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: descriptionHeight),
              Text(
                'The PoS Service and its contents are provided "as is" and "as available" without any warranty or representations of any kind, whether express or implied. RCS is a distributor and not a publisher of the content supplied by third parties; as such, RCS exercises no editorial control over such content and makes no warranty or representation as to the accuracy, reliability or currency of any information, content, service or merchandise provided through or accessible via the PoS Service. Without limiting the foregoing, RCS specifically disclaims all warranties and representations in any content transmitted on or in connection with the RCS Service or on sites that may appear as links on the PoS Service, or in the products provided as a part of, or otherwise in connection with, the PoS Service, including without limitation any warranties of merchantability, fitness for a particular purpose or non-infringement of third party rights. No oral advice or written information given by RCS or any of its affiliates, employees, officers, directors, agents, or the like will create a warranty. Price and availability information is subject to change without notice. Without limiting the foregoing, RCS does not warrant that the PoS Service will be uninterrupted, uncorrupted, timely, or error-free.',
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: titleHeight),
              Text(
                'Contact Us',
                style: kTextStyle(size: title)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: titleHeight),
              Text(
                "Don't hesitate to contact us if you have any questions.",
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: descriptionHeight),
              Text(
                "-Via Email: contact@rcs-mm.com",
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: descriptionHeight),
              Text(
                "-Via Phone Number: 09 799501600",
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: descriptionHeight),
              Text(
                "-Via this Link: www.rcs-mm.com",
                style: kTextStyle(size: description),
              ),
              const SizedBox(height: descriptionHeight),
              Text(
                "-Via this Address: No.24, 2F, 87D St, Bet 22x23 Sts, Aung Myay Thar Zan Tsp, Mandalay",
                style: kTextStyle(size: description),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
