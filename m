Return-Path: <SRS0=xZbm=HE=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAD31C433E0
	for <ocfs2-devel@archiver.kernel.org>; Tue,  2 Feb 2021 03:20:05 +0000 (UTC)
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5090564EA1
	for <ocfs2-devel@archiver.kernel.org>; Tue,  2 Feb 2021 03:20:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5090564EA1
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
	by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1123K4x3105113;
	Tue, 2 Feb 2021 03:20:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : date :
 message-id : references : in-reply-to : content-id : mime-version : cc :
 subject : list-id : list-unsubscribe : list-archive : list-post :
 list-help : list-subscribe : content-type : content-transfer-encoding :
 sender; s=corp-2020-01-29;
 bh=593+egdEyF8wKl5yFXa1xkQezqRq2XcVz+tUp8pqcTY=;
 b=N+b29H7GrObm2uR73fjV+F7cPXeBVDOuKG26oK6oL71hQK+xft8cyb5g9dzoq9f6jikd
 s5sRXjK2hzpLKSLeAgV9zfze6oVlJuXvWUarq8XqudjDuUAyu8o77zqpWTwglYEDhPhq
 jI/G/dZUcyoH43Z4OQRGTg5mtFUAbtBLXBJBwWeBKTA8rXqt3CO6QKtLxCquTcREhs5R
 2GF8sl5oDnJU56GQaSmwLvtbfX6LqAo64t9t70BZQfkaUjWTeat1VdFPmsvlwLuueK8s
 o5fMwjqRpxdSNpjQeCwu4CK4gJu/issiD+1OQYnsj+pCIoM7gtJJjlJ/QYiD35OmlR+W +A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2120.oracle.com with ESMTP id 36cydkrgkt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Feb 2021 03:20:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1123GZKm116706;
	Tue, 2 Feb 2021 03:18:03 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 36dhcvymjf-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Tue, 02 Feb 2021 03:18:03 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1l6mCY-0002GM-6E; Mon, 01 Feb 2021 19:18:02 -0800
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <herbert.van.den.bergh@oracle.com>)
	id 1l5OHo-0003Pf-Hv
	for ocfs2-devel@oss.oracle.com; Thu, 28 Jan 2021 23:33:44 -0800
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	10T7QFgZ154339; Fri, 29 Jan 2021 07:33:44 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
	by userp3030.oracle.com with ESMTP id 368wr1e88g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Jan 2021 07:33:44 +0000
Received: from DM5PR10MB1418.namprd10.prod.outlook.com (2603:10b6:3:e::11) by
	DM6PR10MB4202.namprd10.prod.outlook.com (2603:10b6:5:222::12) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.20.3805.16; Fri, 29 Jan 2021 07:33:42 +0000
Received: from DM5PR10MB1418.namprd10.prod.outlook.com
	([fe80::a876:7968:da81:f895]) by
	DM5PR10MB1418.namprd10.prod.outlook.com
	([fe80::a876:7968:da81:f895%8]) with mapi id 15.20.3784.020;
	Fri, 29 Jan 2021 07:33:42 +0000
From: Herbert Van Den Bergh <herbert.van.den.bergh@oracle.com>
To: Gang He <GHe@suse.com>
Thread-Topic: [Ocfs2-devel] About the status of reflink-tools
Thread-Index: AQHW9eoHk9vNPZLg6kys0MprgFWE8Ko+Nk4A
Date: Fri, 29 Jan 2021 07:33:42 +0000
Message-ID: <3E55B25E-76CC-4FFE-BF98-0637BCB4D9CC@ORACLE.COM>
References: <AM6PR04MB6488440A41759D9FF9A3C5A6CFB99@AM6PR04MB6488.eurprd04.prod.outlook.com>
In-Reply-To: <AM6PR04MB6488440A41759D9FF9A3C5A6CFB99@AM6PR04MB6488.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.com; dkim=none (message not signed)
	header.d=none; suse.com; dmarc=none action=none header.from=oracle.com; 
x-originating-ip: [2600:1700:89c8:4280:8ced:bb90:f265:18d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c005d0cc-853a-4c1c-bbcd-08d8c428341f
x-ms-traffictypediagnostic: DM6PR10MB4202:
x-ms-exchange-transport-forked: True
x-oracle-tenancy: 1
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0PewR9lAE1IjVJmjnCWIYSbjLm2bzYL5Py6nDmoyI6b+khPRKcNubVHvaiJYPRdAZaiGA6IyapKwzYaV92N0bkIm7XBI7H5HWo92nQvwRuXwHtW8zTwbe+AJPQLu75X/nPJwiKLMDM54mQi0Qa//lZ8N++nirKf5SNaR/0SHFozlz+JsprTuEnPIunMNFv81ZCR73lkQa7FfpOxPxuRM0hYMj5eWMv/HqMfdHf8RH2CEWZI5IxcdWZeENGm/QVqEPDT64pkotFYyao+f3VjqR0lNC/csbf2ALxhZ/3f/IcoEZsn9nhQnuP73A5hBmm/yVA7Y8bLQJTEEZOOvsN3ZL4FOJCSRPchusPG2v260aMddTqIgbd91Vs4k/Yr8QGRdnGcxqYcQ/iKtbtMM3YdHhN3YdeMZDtKWJ25Deay6ekvmp59XHgUosAd79w9TENDtMaIBIwNytuPxVzVem0YQS0KdQrcBx7Iz6/mN8bjv0TOJpXVKAWiKyTa8lRfWOO6A5k6R9HIBpMHcRRYnb2TrSXR3lMaQKhECFqx2Z6U6iyiFLJVoW2m4BxhCPLk3BsB+
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:DM5PR10MB1418.namprd10.prod.outlook.com; PTR:; CAT:NONE; SFS:;
	DIR:INB; 
x-ms-exchange-antispam-messagedata: =?utf-8?B?Q08rU2VJS2J0WXMxcWJWVHNCVllkaURFN1ZLcVUrUWYyNHY0OXhBYi9kWnJH?=
	=?utf-8?B?UmMwdGpZVzlFdU93OXBWaGdHU1l3WVU0dmZEeVZYVlhBYnB6d3NSZzJqUWVS?=
	=?utf-8?B?RkV2c2F4a1FxMG9lNlZFUTZRZXBTOVpOUnMrbnhHVFo1VDh1bkIydnF2aGhN?=
	=?utf-8?B?dlF5MjQ0MUhzME1VU2tkbHBrR3JZU1gybVlYemxUNFh2aDFyVzVEWXFBek1a?=
	=?utf-8?B?cEkwQWFoRmRwZ3BlRXpTMVFEdzB2aEQ4UFZtZkIxVCttVnI4KzVOOVN0anZw?=
	=?utf-8?B?N01RYldpQUpjUy9GVGVadEIwS3N5VXFHUGJxU2VYRnVydzlPNENEc2FaU1hV?=
	=?utf-8?B?d3lacS9VQmFiY1REempVYWJTNGN6b0pBWmtJRmpqZ2xXOGUzd1RqOEdHTDdW?=
	=?utf-8?B?eFdWWkJRL0RDREhJa0UrS3pDZVhHaEYyWjd0TjV6TitjSkRPUCthOFduTWlr?=
	=?utf-8?B?S2ZMZXAzSE5lWUhFUUF4MitnNUlzY2Y2azRXa1FTZEFjT2hwTGZyQnB0TEFa?=
	=?utf-8?B?dytqamgrVzd5ckJVMmZ2TGNjdFZ5RWkveFJTNE5xN3prODlDcnpaZTdZalJn?=
	=?utf-8?B?ckx0TG5heGZBM0RST1J3b21QcEd0NmhyNmpncEx6OWVncU5TZHZ3Nzk0NVJp?=
	=?utf-8?B?Rzg4RGF0MkFlOFlBN0Jud3lhNCtLYjE3b2JKajFTRTE0bUliOXcyRm1NY20x?=
	=?utf-8?B?dXNyUFI0MlQ1c21lVGhJVm1kdWREYkR0b0JRUllwSnNjak8rdkFEWTIrdlE4?=
	=?utf-8?B?bFh0WDN3MDlxd0hFUzkrVmdCeU1vU2FGeUJOR1hzVHB6Q1IzUU12N2ZtVTB5?=
	=?utf-8?B?d1FYdFlxKzBTTUpKNWptalVMaHVmYkptcDZYNjF3azJpTDVmSzhuRE5CaXF0?=
	=?utf-8?B?cE9sdlJuL2ZoRURrSE9QZ0k3TENxaEoxbHJ4WnhGTTBCS04xUDRrQkgzdlB1?=
	=?utf-8?B?UnVUdkhZVHJhKy9qNnFXeUwvUlpLeUh5SGVzVzdSbHQ4N1NWcHd4M3hNZzJM?=
	=?utf-8?B?a2hqRGtMYzU0bkhCL2ZrNFk4eUVMY0F4aHBLbDVxVWh1d0FEVjIyNDZERG5S?=
	=?utf-8?B?Sm5HU2ZaeHlhWkgrNTlaY0VmUkE1YzB4QmJEd2x4VDIwcmloUlE5bisycEFE?=
	=?utf-8?B?SERYUzRRUzZiamh4SlNyWWw2N0J0Y25UR2c3TEFEM29ZZDdRYkVUZnhKbW9w?=
	=?utf-8?B?MFJyUERkd0ZSQUhWeWw4YloybW45U2d4WGdmOVNiS3dxVkNjSW5oQnVmK2JH?=
	=?utf-8?B?QnpnZTdzTUJKSWtYRnRjb0RMNzEzUlNSU29ob3BlSlpaUlVrdnY4YlZyV1d4?=
	=?utf-8?B?djZFTUZwQXRhTWxtYkhHcUlkQy81SlhPSGV0QnNKR1VRNnF3QjM5S1Y2U2Q3?=
	=?utf-8?B?QnJZNEFIbGg2RWZYTGhKOWZPMit1VTJLVVBhUmxFOHJzVENENXBrNmVua1c3?=
	=?utf-8?B?NTlSV2ZGaGJUSGtiTlg2NWE4QjVJNW1KcDN0L0dvK29Jc3pUMG45d1c2OEcy?=
	=?utf-8?B?cjFKNkl4YXRLTUxkUE9ZV3lzZktHV1ExeERxRXRnQnlUNTB5d1UxOFZ5b1ln?=
	=?utf-8?B?UktuUT09?=
Content-ID: <B801FE5696014A4EB3DE969BAC345312@namprd10.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1418.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c005d0cc-853a-4c1c-bbcd-08d8c428341f
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2021 07:33:42.3936 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: csxL5iG7avPEbPaX3USZPc7+VHJoeYY7iyRcqKSr/p2PoYIhfG84mXsd7Gh2H2xS1wwsaov1IcU3aXq5KoPFcwMDU4MABD8drrE6AuXpLOOLegtligz8hENA/Lyu1D2i
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4202
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 04
X-MS-Exchange-CrossPremises-AuthSource: DM5PR10MB1418.namprd10.prod.outlook.com
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-SCL: -1
X-MS-Exchange-CrossPremises-messagesource: StoreDriver
X-MS-Exchange-CrossPremises-BCC: Herbert Van Den Bergh
	<herbert.van.den.bergh@oracle.com>
X-MS-Exchange-CrossPremises-originalclientipaddress: 2600:1700:89c8:4280:8ced:bb90:f265:18d
X-MS-Exchange-CrossPremises-transporttraffictype: Email
X-MS-Exchange-CrossPremises-antispam-scancontext: DIR:Originating; SFV:SKI;
	SKIP:0; 
X-MS-Exchange-CrossPremises-processed-by-journaling: Journal Agent
X-OrganizationHeadersPreserved: DM6PR10MB4202.namprd10.prod.outlook.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9878
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
	spamscore=0 phishscore=0
	adultscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 bulkscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2101290038
X-Mailman-Approved-At: Mon, 01 Feb 2021 19:18:01 -0800
Cc: "ocfs2-tools@oss.oracle.com" <ocfs2-tools@oss.oracle.com>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] About the status of reflink-tools
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.9
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9882 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102020024
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9882 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 clxscore=1015
 spamscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102020024

SGkgR2FuZywNCg0KVGhlIHJlZmxpbmsgZnVuY3Rpb25hbGl0eSBoYXMgYmVlbiBtZXJnZWQgaW50
byB0aGUgY29yZXV0aWxzIHBhY2thZ2UvcHJvamVjdC4gVGhlIGNwIGNvbW1hbmQgbm93IGhhcyBh
IOKAlHJlZmxpbmsgb3B0aW9uLiBDaGVjayBpdCBvdXQuIElmIHRoaXMgaXNu4oCZdCB3aGF0IHlv
deKAmXJlIGxvb2tpbmcgZm9yLCB0aGVuIHBsZWFzZSBlbGFib3JhdGUuDQoNClRoYW5rcywNCkhl
cmJlcnQuDQoNCj4gT24gSmFuIDI4LCAyMDIxLCBhdCA2OjU5IFBNLCBHYW5nIEhlIDxHSGVAc3Vz
ZS5jb20+IHdyb3RlOg0KPiANCj4gSGkgR3V5cywNCj4gDQo+IFlvdSBrbm93LCBvY2ZzMiByZWZs
aW5rIHJlbGF0ZWQgdXRpbGl0aWVzIHdlcmUgbWFpbnRhaW5lZCBieSBhIHNlcGVyYXRlZCBwcm9q
ZWN0IHJlZmxpbmstdG9vbHMsDQo+IFdoYXQgaXMgdGhpcyBwcm9qZWN0J3Mgc3RhdHVzPyBlLmcu
IHdobyBpcyBtYWludGFpbmluZyBpdCwgd2hlcmUgY2FuIHdlIGRvd25sb2FkIHRoZSBsYXRlc3Qg
c291cmNlIGNvZGU/DQo+IA0KPiANCj4gVGhhbmtzDQo+IEdhbmcNCj4gDQo+IF9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fDQo+IE9jZnMyLWRldmVsIG1haWxp
bmcgbGlzdA0KPiBPY2ZzMi1kZXZlbEBvc3Mub3JhY2xlLmNvbQ0KPiBodHRwczovL29zcy5vcmFj
bGUuY29tL21haWxtYW4vbGlzdGluZm8vb2NmczItZGV2ZWwNCg0KX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18KT2NmczItZGV2ZWwgbWFpbGluZyBsaXN0Ck9j
ZnMyLWRldmVsQG9zcy5vcmFjbGUuY29tCmh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFpbG1hbi9s
aXN0aW5mby9vY2ZzMi1kZXZlbA==
