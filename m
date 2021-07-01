Return-Path: <SRS0=i0EA=LZ=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2CF1C11F64
	for <ocfs2-devel@archiver.kernel.org>; Thu,  1 Jul 2021 11:03:11 +0000 (UTC)
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5BBAD6144F
	for <ocfs2-devel@archiver.kernel.org>; Thu,  1 Jul 2021 11:03:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5BBAD6144F
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=fail smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
	by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 161B3AMi033374;
	Thu, 1 Jul 2021 11:03:10 GMT
Received: from oracle.com (userp3030.oracle.com [156.151.31.80])
	by userp2130.oracle.com with ESMTP id 39frct01sf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Jul 2021 11:03:09 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
	by pps.onprem (8.16.0.36/8.16.0.36) with SMTP id 161B39J8108181;
	Thu, 1 Jul 2021 11:03:09 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 39dsc3kxku-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 01 Jul 2021 11:03:08 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lyuNF-0001UD-Nr; Thu, 01 Jul 2021 03:56:49 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ghe@suse.com>) id 1lyuMo-0001TJ-Vt
	for ocfs2-devel@oss.oracle.com; Thu, 01 Jul 2021 03:56:23 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	161Atxex102725
	for <ocfs2-devel@oss.oracle.com>; Thu, 1 Jul 2021 10:56:22 GMT
Received: from mx0a-00069f01.pphosted.com (mx0a-00069f01.pphosted.com
	[205.220.165.26]) by aserp3020.oracle.com with ESMTP id 39dv2a3rrb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 01 Jul 2021 10:56:22 +0000
Received: from pps.filterd (m0246575.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	161Alk07016734
	for <ocfs2-devel@oss.oracle.com>; Thu, 1 Jul 2021 10:56:21 GMT
Authentication-Results: ppops.net; spf=pass smtp.mailfrom=ghe@suse.com;
	dkim=pass header.d=suse.com header.s=mimecast20200619;
	dmarc=pass header.from=suse.com
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102])
	by mx0b-00069f01.pphosted.com with ESMTP id 39h5fvu3t3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 01 Jul 2021 10:56:20 +0000
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
	(mail-am5eur03lp2054.outbound.protection.outlook.com [104.47.8.54])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-29-XfZX1WUQPJm8iJnnYTJYiA-1; Thu, 01 Jul 2021 12:56:17 +0200
X-MC-Unique: XfZX1WUQPJm8iJnnYTJYiA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
	b=CqjgZyVJ3/Eon4zp2RwjgpD8YQ3pJ5aKA6CTzkbCHcXthmEnC5drwhUyleXdV6I7YS4YVG/Ik6Xu9AQLQaZBQuPUI4/9QFJy0AuB9LnPLLvfUnsmNCRdUz8/iGcjOI42PdSKl1xrZ5Ya4PdB3YU3dchGgMkh9y1/x9Gdy6ZGhPxZ7tqkc7b8qmMkr+sv9vmGVq8Dbjn0SVPZKpDkf9YuMTrRz7GJPOdY9GNENcpTSKL8isl8cXMTVAxK4/bmcRkS/Xh149DG0BO+57N4nmu2Vdek+rWCnTdDM8tPSo3QWPHbBjREKP4meOrvfSPq00fjDB72iIq9ktc6zOaFNwStSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
	s=arcselector9901;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=lBkCGXz1ie1nECnbIJ4T1VcYy3nD2jtpGDU0IY8A/D4=;
	b=j/TRuFyj6ZaL+Fxt7NQtyCs8CMLchgwHFB4ACFhSZBT19mAJ4IvFTrevtvvAyVDz/WeJgI+2Hsilk+4nkD2F93GIUhpwfSXKqjJEbsmtl9s362BVjYrrIO74Fcfwp0DeB2A055/7poV4Uk1Pppab7RWSJ6EHSf/RvuveSSVj381sygS41wJpITbyaIk9cElOnsJ7pBSgV242Sxv32rZSgoqc7Bm/kQG5fHXpnFH3AYhIY0qw8rg9ITniz3e8wO+9MB98eGRm29pXgoT/GwfddeowkFLZ1ThNqUeD6bsxdJ2aZLXZH9xR0/inw5LEnU6dPI0P+CZYzCzEQypaVuPNWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
	smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
	dkim=pass header.d=suse.com; arc=none
Received: from AM6PR04MB6488.eurprd04.prod.outlook.com (2603:10a6:20b:f8::21)
	by AM7PR04MB6885.eurprd04.prod.outlook.com (2603:10a6:20b:10d::24)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.23;
	Thu, 1 Jul 2021 10:56:16 +0000
Received: from AM6PR04MB6488.eurprd04.prod.outlook.com
	([fe80::b973:ec65:6b36:1eaa]) by
	AM6PR04MB6488.eurprd04.prod.outlook.com
	([fe80::b973:ec65:6b36:1eaa%6]) with mapi id 15.20.4287.023;
	Thu, 1 Jul 2021 10:56:16 +0000
From: Gang He <GHe@suse.com>
To: "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Thread-Topic: Find one ocfs2 hang between reflink and ocfs2_complete_recovery
Thread-Index: AQHXbmbcfMC68VOsR0OBZt0+1Pe7Rg==
Date: Thu, 1 Jul 2021 10:56:15 +0000
Message-ID: <AM6PR04MB64888A5193ED47F1E8081287CF009@AM6PR04MB6488.eurprd04.prod.outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oss.oracle.com; dkim=none (message not signed)
	header.d=none; oss.oracle.com;
	dmarc=none action=none header.from=suse.com; 
x-originating-ip: [60.251.47.115]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fe5570ea-fdc4-4361-b029-08d93c7ed95f
x-ms-traffictypediagnostic: AM7PR04MB6885:
x-microsoft-antispam-prvs: <AM7PR04MB6885092562F0E22995172847CF009@AM7PR04MB6885.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nFueRL/34otG1xR1CGUohatqaQmmfFsxlD5/Jq4I2CKKa/H/ymCqogkvfJhQq9SSDUQdiO7Y8UwFOeTIdHyZy/S57AgJGZ6IBeuXMRWUlafRRBI7DawIK/J1clcx69/MRfuAqDp2fkpBF9s/hWor0eMzY0xfmxibiaqFIES0cGfFzZPOXC1VTOOeybnFYoW5NWTE7YGgbHkU0GK0Vhf/YMq9OdpljF+IoNQDqQIbbelPb+G2L3U9EQS6ifuith1w9ZydNjTj8BKjhLGrkq7h198r7rcs/kqbUb8/G/pZj2HEqCKW4nmg/Za5TyefuOGl9sNH1dsnydetoDusmLAedkF5umQ73awE4AhPnzP0ltTPsDIrYy0h6vOV8J5JDlYVyTLiSe3iHoODQwRXORz0malYEy35BrMU2rMTH6qlvH7TZ9sWpsv0B+KPR/ii3nuNri6opE2tPHrZuVVSeJtACC0XH8xvCwIRGRLfoCYie8WWReNQCm+FgQZYaIWr102SWlPNddjx9GUVcoRnI6qU0XnEKxf2aMNl6ynG5hcU/T9YCsoQI5L4qEJB1/wFDgRosKl3gmAXuW2wBSO3Ug3BEMQO7t+h5arf2jGbYDIjip29acFbFCsnQTAkdT2uhq21OSBTi19M4j58JuiAzRHJKg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:; IPV:NLI; SFV:NSPM;
	H:AM6PR04MB6488.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
	SFS:(39850400004)(396003)(346002)(376002)(366004)(136003)(33656002)(6916009)(52536014)(8936002)(83380400001)(186003)(7696005)(86362001)(8676002)(316002)(6506007)(71200400001)(2906002)(9686003)(38100700002)(122000001)(26005)(55016002)(5660300002)(66446008)(64756008)(55236004)(478600001)(66556008)(66476007)(91956017)(66946007)(76116006);
	DIR:OUT; SFP:1101; 
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RG9VcWgxWDEwQWZ6MVErK3lGS3A2YUVEU3RLb3JYQjRWM2FaTlkzUG5KTkps?=
	=?utf-8?B?aXNHSXc3VnVhbURIOFNqSW5FUkdHYys3Q3lrY2lRelJKZTdJVmMrdEx4aEx6?=
	=?utf-8?B?L3YyY3QwZ3pTNFEvandYaGducFNMblNCM3E1U3ZpVDRDZXNiYjErZG1KVnR3?=
	=?utf-8?B?c1FvK1d5UFNlemV2bCtHT1hPQnpGTURqdlAzVDkrQ0NkVTJFUXhwYXBKMGRp?=
	=?utf-8?B?N2hHaWh2SlB3WXorZ0lwZHlmb2J0d243b0ZhYzlHdERFVXEvZ21wSkxMSW9t?=
	=?utf-8?B?NGI2QjMrcUcveTdQVzdpZWRhOWhrZkIxNWUvWWFOVXROWHhuaEZqWThONXpv?=
	=?utf-8?B?KzNwOGZ5NDluWTNTN1V0QUNFdXRhUWYzWTFLcmVteFExWlFsYXBObEM2NEtQ?=
	=?utf-8?B?SDJmWUs1dU1rL2dJYk5hbE5vOEhjTmUvYVJJM0p5ck1VK2FjSlRRV3B0RlRH?=
	=?utf-8?B?ODNHL2xGU2FGTEZySlJ3NmNEbE5iV3o5eTZBWG5sUnhyV3JFb0IzY2lNb2tM?=
	=?utf-8?B?bG16YWQzYktYTWEvSlNFUTVJbVZ4cDlXZEFmZW5WMWlKdmlnS2lkMERObW9s?=
	=?utf-8?B?Y0tMNEQxTmJnQ2dkd2haeFcxUm9tNEtUbFo3ZWFkRlFtdC9WVWNabkx2Ui9p?=
	=?utf-8?B?bGtGYWxzQ1lJYUF1Y1BHdmxVWEg3VWxiaEpLbUlHOG9tQTZHZ1NLUGZZVHlm?=
	=?utf-8?B?ZWE4V0NtL1c2YWNzTXJEMWxFU01qMGNLaDd1OVc0RGk4aHhaVDFENmlTeW1y?=
	=?utf-8?B?anduVG5DbGZMa2ZhdlN0a21STEplZExkZ3cydDJtMmZXREdzQVdWNEkvbS80?=
	=?utf-8?B?dkNhd0UxdmI2bnlSUVdMVEl6ZXkwRmh4eG90N1VFZ1lGNnB6cWdlVXVlUVE2?=
	=?utf-8?B?YTAxTEtuY2FnK29TYzUyVVBrS3NNQWk5Z0Yrbk5VUnFPVXBwcWMzUXExZ3Jl?=
	=?utf-8?B?WC84NGZ4Z2Fvc0pxeCtwKzJEWDJNMTZHa1BEaktFbVZna2FSQnF3dmFlMHdn?=
	=?utf-8?B?ajV1MGtsZTMydFNjNkFDaXBVbkd0alpVdTdwcVhvZ3UySy9aZlhSSkRUanMz?=
	=?utf-8?B?bjdkMDRXM3hwajluOFY2VDllT0pDcHNZaUorcGdSWnlwMldsMG53d293a1F3?=
	=?utf-8?B?aDdHNzR1K2owekgyYzNGK0VoUHhwejNRRGdPYXNxd1ZZMVBSUnRlejBjK2ww?=
	=?utf-8?B?U1VCY3dmcUxVUFZCa1QrdjFBYy9DMG9lLzlvNERxWVp1UGpud0ZYcm00VU42?=
	=?utf-8?B?czA1ZzNDNWtrUGpEL1VGbVJKcmpyUlMwTFcrU0czUzB4NU4xTjk2N1pXeDRr?=
	=?utf-8?B?RUdNWW5SN04wZ2xQckdZa09yVzBWdFc3UytLVVhxME1tWHNINzRyVkYyUE5U?=
	=?utf-8?B?YTczelYxWHA5R2o3ME5VMHlNbytEUXh4OGJVeFJ2UE13Uy80ZzRoZWduUTly?=
	=?utf-8?B?VENvWGE2OVBCZU9pQmo1MUh0dW9RYW9xS2hDbHpOdzhzMk5QK29rd3M3VExq?=
	=?utf-8?B?UWlqeHVFRGgvNnN1NE9mMHRocVdyam94Rk1yTGtsTGh3OHdQSDBXUVZhbnZ3?=
	=?utf-8?B?Y1B5MnRsYnVTVHM1YTFrUU1qN2xwMHY2ZHdSemIrdGhYTDRDdTBmN2xzNlBQ?=
	=?utf-8?B?RU4ydWlGSzY2cTR2OHBPUWFwbG4xT0NXK0RBU0lJaDVLNjJTNjkraFAyVWJy?=
	=?utf-8?B?aW9BeldkWW9JZXZjV0FJTFdmQU10N3RIczlVc3NlbjE5Wmdlak5QMUFQRFhT?=
	=?utf-8?Q?ju02MjxHuN29GNjOgw=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB6488.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe5570ea-fdc4-4361-b029-08d93c7ed95f
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2021 10:56:15.8599 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XwLjX5xeyCjZeQ5ICCuqmSUKv/ApP9ZK8FpUXrWO3PCdnoJRMtKTb5Agll9Yvnnw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6885
X-Source-IP: 194.104.109.102
X-ServerName: de-smtp-delivery-102.mimecast.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.suse.com
	include:de._netblocks.mimecast.com
	include:amazonses.com include:spf.protection.outlook.com
	include:_spf.qemailserver.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10031
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
	mlxlogscore=999
	malwarescore=0 lowpriorityscore=0 bulkscore=0 mlxscore=0 suspectscore=0
	clxscore=176 adultscore=0 impostorscore=0 spamscore=0 priorityscore=174
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107010071
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10031
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
	spamscore=0 adultscore=0
	malwarescore=0 mlxlogscore=994 suspectscore=0 phishscore=0 mlxscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2107010072
Subject: [Ocfs2-devel] Find one ocfs2 hang between reflink and
	ocfs2_complete_recovery
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10031 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 bulkscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107010072
X-Proofpoint-GUID: JY6l1nFmo7XU4-VOwb2btpzfM8Rf_xRw
X-Proofpoint-ORIG-GUID: JY6l1nFmo7XU4-VOwb2btpzfM8Rf_xRw
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10031 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 clxscore=1011 mlxscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 priorityscore=1501 bulkscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107010072

SGkgR3V5cywKClRoZXJlIGFyZSB0aHJlZSBub2RlIG9jZnMyIGNsdXN0ZXIsIHdoZW4gdGhlIHVz
ZXIgcnVuIHJlZmxpbmsgY29tbWFuZCBkdXJpbmcgb2NmczIgbm9kZSBkb2VzIHJlY292ZXJ5KGUu
Zy4gb25lIG5vZGUgaXMgZmVuY2VkKS4KClRoZSBoYW5nIHByb2JsZW0gd2FzIGNhdXNlZCBkbG0g
ZGVhZCBsb2NrIGJldHdlZW4gcmtzYXBoMTggYW5kIHJrc2FwaDE5LCB0aGUgZGV0YWlsZWQgcHJv
Y2Vzc2VzIGFyZSBhcyBiZWxvdywKCkp1biAwMSAxMjozMzoxMCBya3NhcGgxOCBrZXJuZWw6IHRh
c2s6cmVmbGluayAgICAgICAgIHN0YXRlOkQgc3RhY2s6ICAgIDAgcGlkOiA3NTE1IHBwaWQ6ICA3
NDM5IGZsYWdzOjB4MDAwMDQwMDAKSnVuIDAxIDEyOjMzOjEwIHJrc2FwaDE4IGtlcm5lbDogQ2Fs
bCBUcmFjZToKSnVuIDAxIDEyOjMzOjEwIHJrc2FwaDE4IGtlcm5lbDogIF9fc2NoZWR1bGUrMHgy
ZmQvMHg3NTAKSnVuIDAxIDEyOjMzOjEwIHJrc2FwaDE4IGtlcm5lbDogIHNjaGVkdWxlKzB4MmYv
MHhhMApKdW4gMDEgMTI6MzM6MTAgcmtzYXBoMTgga2VybmVsOiAgc2NoZWR1bGVfdGltZW91dCsw
eDFjYy8weDMxMApKdW4gMDEgMTI6MzM6MTAgcmtzYXBoMTgga2VybmVsOiAgPyBvY2ZzMl9jb250
cm9sX2NmdSsweDUwLzB4NTAgW29jZnMyX3N0YWNrX3VzZXJdCkp1biAwMSAxMjozMzoxMCBya3Nh
cGgxOCBrZXJuZWw6ICA/IDB4ZmZmZmZmZmZjMDhmNzAwMApKdW4gMDEgMTI6MzM6MTAgcmtzYXBo
MTgga2VybmVsOiAgd2FpdF9mb3JfY29tcGxldGlvbisweGJhLzB4MTQwCkp1biAwMSAxMjozMzox
MCBya3NhcGgxOCBrZXJuZWw6ICA/IHdha2VfdXBfcSsweGEwLzB4YTAKSnVuIDAxIDEyOjMzOjEw
IHJrc2FwaDE4IGtlcm5lbDogIF9fb2NmczJfY2x1c3Rlcl9sb2NrLmlzcmEuNDErMHgzYjUvMHg4
MjAgW29jZnMyXQpKdW4gMDEgMTI6MzM6MTAgcmtzYXBoMTgga2VybmVsOiAgPyBvY2ZzMl9pbm9k
ZV9sb2NrX2Z1bGxfbmVzdGVkKzB4MWZjLzB4OTYwIFtvY2ZzMl0KSnVuIDAxIDEyOjMzOjEwIHJr
c2FwaDE4IGtlcm5lbDogIG9jZnMyX2lub2RlX2xvY2tfZnVsbF9uZXN0ZWQrMHgxZmMvMHg5NjAg
W29jZnMyXQpKdW4gMDEgMTI6MzM6MTAgcmtzYXBoMTgga2VybmVsOiAgb2NmczJfbXZfb3JwaGFu
ZWRfaW5vZGVfdG9fbmV3KzB4MzQ2LzB4N2UwIFtvY2ZzMl0KSnVuIDAxIDEyOjMzOjEwIHJrc2Fw
aDE4IGtlcm5lbDogID8gX3Jhd19zcGluX3VubG9ja19pcnFyZXN0b3JlKzB4MTQvMHgyMApKdW4g
MDEgMTI6MzM6MTAgcmtzYXBoMTgga2VybmVsOiAgb2NmczJfcmVmbGluaysweDMzNS8weDRjMCBb
b2NmczJdCkp1biAwMSAxMjozMzoxMCBya3NhcGgxOCBrZXJuZWw6ICA/IG9jZnMyX3JlZmxpbmtf
aW9jdGwrMHgyY2EvMHgzNjAgW29jZnMyXQpKdW4gMDEgMTI6MzM6MTAgcmtzYXBoMTgga2VybmVs
OiAgb2NmczJfcmVmbGlua19pb2N0bCsweDJjYS8weDM2MCBbb2NmczJdCkp1biAwMSAxMjozMzox
MCBya3NhcGgxOCBrZXJuZWw6ICBvY2ZzMl9pb2N0bCsweDI1ZS8weDY3MCBbb2NmczJdCkp1biAw
MSAxMjozMzoxMCBya3NhcGgxOCBrZXJuZWw6ICBkb192ZnNfaW9jdGwrMHhhMC8weDY4MApKdW4g
MDEgMTI6MzM6MTAgcmtzYXBoMTgga2VybmVsOiAga3N5c19pb2N0bCsweDcwLzB4ODAKSnVuIDAx
IDEyOjMzOjEwIHJrc2FwaDE4IGtlcm5lbDogIF9feDY0X3N5c19pb2N0bCsweDE2LzB4MjAKSnVu
IDAxIDEyOjMzOjEwIHJrc2FwaDE4IGtlcm5lbDogIGRvX3N5c2NhbGxfNjQrMHg1Yi8weDFlMApK
dW4gMDEgMTI6MzM6MTAgcmtzYXBoMTgga2VybmVsOiAgZW50cnlfU1lTQ0FMTF82NF9hZnRlcl9o
d2ZyYW1lKzB4NDQvMHhhOQpKdW4gMDEgMTI6MzM6MTAgcmtzYXBoMTgga2VybmVsOiBSSVA6IDAw
MzM6MHg3ZjFiYjJhYWY5ZTcKClRoZSByZWZsaW5rIHByb2Nlc3MgaXMgZ2V0aW5nIG9ycGhhbl9k
aXJfaW5vZGUob2NmczIgc3lzdGVtIGZpbGUgcGVyIG5vZGUpIGRsbSBsb2NrIGFmdGVyIGl0IGhh
cyBhY3F1aXJlZCB0aGUgcmVmbGluayB0YXJnZXQgZmlsZSBpbm9kZSBkbG0gbG9jaywgdGhlIHJl
ZmxpbmsgdGFyZ2V0IGZpbGUgaXMgcHV0IGluIG9ycGhhbl9kaXJfaW5vZGUgZGlyZWN0b3J5IGR1
cmluZyB0aGUgcmVmbGluayBvcGVyYXRpb24uCgpKdW4gMDEgMTI6MzM6MTcgcmtzYXBoMTkga2Vy
bmVsOiBXb3JrcXVldWU6IG9jZnMyX3dxIG9jZnMyX2NvbXBsZXRlX3JlY292ZXJ5IFtvY2ZzMl0K
SnVuIDAxIDEyOjMzOjE3IHJrc2FwaDE5IGtlcm5lbDogQ2FsbCBUcmFjZToKSnVuIDAxIDEyOjMz
OjE3IHJrc2FwaDE5IGtlcm5lbDogIF9fc2NoZWR1bGUrMHgyZmQvMHg3NTAKSnVuIDAxIDEyOjMz
OjE3IHJrc2FwaDE5IGtlcm5lbDogIHNjaGVkdWxlKzB4MmYvMHhhMApKdW4gMDEgMTI6MzM6MTcg
cmtzYXBoMTkga2VybmVsOiAgc2NoZWR1bGVfdGltZW91dCsweDFjYy8weDMxMApKdW4gMDEgMTI6
MzM6MTcgcmtzYXBoMTkga2VybmVsOiAgPyBvY2ZzMl9jb250cm9sX2NmdSsweDUwLzB4NTAgW29j
ZnMyX3N0YWNrX3VzZXJdCkp1biAwMSAxMjozMzoxNyBya3NhcGgxOSBrZXJuZWw6ICA/IDB4ZmZm
ZmZmZmZjMDg2MjAwMApKdW4gMDEgMTI6MzM6MTcgcmtzYXBoMTkga2VybmVsOiAgd2FpdF9mb3Jf
Y29tcGxldGlvbisweGJhLzB4MTQwCkp1biAwMSAxMjozMzoxNyBya3NhcGgxOSBrZXJuZWw6ICA/
IHdha2VfdXBfcSsweGEwLzB4YTAKSnVuIDAxIDEyOjMzOjE3IHJrc2FwaDE5IGtlcm5lbDogIF9f
b2NmczJfY2x1c3Rlcl9sb2NrLmlzcmEuNDErMHgzYjUvMHg4MjAgW29jZnMyXQpKdW4gMDEgMTI6
MzM6MTcgcmtzYXBoMTkga2VybmVsOiAgPyBvY2ZzMl9pbm9kZV9sb2NrX2Z1bGxfbmVzdGVkKzB4
MWZjLzB4OTYwIFtvY2ZzMl0KSnVuIDAxIDEyOjMzOjE3IHJrc2FwaDE5IGtlcm5lbDogIG9jZnMy
X2lub2RlX2xvY2tfZnVsbF9uZXN0ZWQrMHgxZmMvMHg5NjAgW29jZnMyXQpKdW4gMDEgMTI6MzM6
MTcgcmtzYXBoMTkga2VybmVsOiAgb2NmczJfZXZpY3RfaW5vZGUrMHgxOGEvMHg4MTAgW29jZnMy
XQpKdW4gMDEgMTI6MzM6MTcgcmtzYXBoMTkga2VybmVsOiAgZXZpY3QrMHhjYS8weDFiMApKdW4g
MDEgMTI6MzM6MTcgcmtzYXBoMTkga2VybmVsOiAgb2NmczJfb3JwaGFuX2ZpbGxkaXIrMHg5Mi8w
eDE0MCBbb2NmczJdCkp1biAwMSAxMjozMzoxNyBya3NhcGgxOSBrZXJuZWw6ICBvY2ZzMl9kaXJf
Zm9yZWFjaF9ibGsrMHg0YjIvMHg1NzAgW29jZnMyXQpKdW4gMDEgMTI6MzM6MTcgcmtzYXBoMTkg
a2VybmVsOiAgPyBvY2ZzMl9pbm9kZV9sb2NrX2Z1bGxfbmVzdGVkKzB4NDg3LzB4OTYwIFtvY2Zz
Ml0KSnVuIDAxIDEyOjMzOjE3IHJrc2FwaDE5IGtlcm5lbDogIG9jZnMyX2Rpcl9mb3JlYWNoKzB4
NTQvMHg4MCBbb2NmczJdCkp1biAwMSAxMjozMzoxNyBya3NhcGgxOSBrZXJuZWw6ICBvY2ZzMl9x
dWV1ZV9vcnBoYW5zKzB4ZjIvMHgxZjAgW29jZnMyXQpKdW4gMDEgMTI6MzM6MTcgcmtzYXBoMTkg
a2VybmVsOiAgPyBfX29jZnMyX3JlY292ZXJ5X21hcF90ZXN0KzB4NTAvMHg1MCBbb2NmczJdCkp1
biAwMSAxMjozMzoxNyBya3NhcGgxOSBrZXJuZWw6ICA/IGNoYWNoYV9ibG9ja19nZW5lcmljKzB4
NmMvMHhiMApKdW4gMDEgMTI6MzM6MTcgcmtzYXBoMTkga2VybmVsOiAgPyBvY2ZzMl9yZWNvdmVy
X29ycGhhbnMrMHgxMmQvMHg0ZjAgW29jZnMyXQpKdW4gMDEgMTI6MzM6MTcgcmtzYXBoMTkga2Vy
bmVsOiAgb2NmczJfcmVjb3Zlcl9vcnBoYW5zKzB4MTJkLzB4NGYwIFtvY2ZzMl0KSnVuIDAxIDEy
OjMzOjE3IHJrc2FwaDE5IGtlcm5lbDogID8gaW50ZXJuYWxfYWRkX3RpbWVyKzB4NGUvMHg3MApK
dW4gMDEgMTI6MzM6MTcgcmtzYXBoMTkga2VybmVsOiAgb2NmczJfY29tcGxldGVfcmVjb3Zlcnkr
MHgxOWEvMHg0NTAgW29jZnMyXQpKdW4gMDEgMTI6MzM6MTcgcmtzYXBoMTkga2VybmVsOiAgPyBx
dWV1ZV9kZWxheWVkX3dvcmtfb24rMHgyYS8weDQwCkp1biAwMSAxMjozMzoxNyBya3NhcGgxOSBr
ZXJuZWw6ICA/IG9jZnMyX29ycGhhbl9zY2FuX3dvcmsrMHgxMTAvMHgyYzAgW29jZnMyXQpKdW4g
MDEgMTI6MzM6MTcgcmtzYXBoMTkga2VybmVsOiAgcHJvY2Vzc19vbmVfd29yaysweDFmNC8weDNl
MApKdW4gMDEgMTI6MzM6MTcgcmtzYXBoMTkga2VybmVsOiAgd29ya2VyX3RocmVhZCsweDJkLzB4
M2UwCkp1biAwMSAxMjozMzoxNyBya3NhcGgxOSBrZXJuZWw6ICA/IHByb2Nlc3Nfb25lX3dvcmsr
MHgzZTAvMHgzZTAKSnVuIDAxIDEyOjMzOjE3IHJrc2FwaDE5IGtlcm5lbDogIGt0aHJlYWQrMHgx
MGQvMHgxMzAKSnVuIDAxIDEyOjMzOjE3IHJrc2FwaDE5IGtlcm5lbDogID8ga3RocmVhZF9wYXJr
KzB4YTAvMHhhMApKdW4gMDEgMTI6MzM6MTcgcmtzYXBoMTkga2VybmVsOiAgcmV0X2Zyb21fZm9y
aysweDIyLzB4NDAKClRoZSBvY2ZzMl9jb21wbGV0ZV9yZWNvdmVyeSByb3V0aW5lIGlzIGdldGlu
ZyB0aGF0IG9ycGhhbiBmaWxlIGlub2RlIGRsbSBsb2NrIGFmdGVyIGl0IGhhcyBhY3F1aXJlZCBv
cnBoYW5fZGlyX2lub2RlIGRsbSBsb2NrLiDigIsKVGhlbiwgdGhlIGhhbmcgbG9va3MgbGlrZSBB
QkJBIGRlYWQgbG9jay4KClNvIGZhciwgSSBjYW5ub3QgcmVwcm9kdWNlIHRoaXMgcmFjZSBjb25k
aXRpb24sIGJ1dCBhY2NvcmRpbmcgdG8gdGhlIGJhY2t0cmFjZXMgYW5kIHRoZSByZWxhdGVkIHNv
dXJjZSBjb2RlLCB0aGlzIHByb2JsZW0gZG9lcyBleGlzdC4KVGhlIHRyaWdnZXJpbmcgY29uZGl0
aW9ucyBhcmUgcmVsYXRlZCB0bywgdGhlIG5vZGUgaXMgcnVuaW5nIHJlZmxpbmsgY29tbWFuZCB3
aGVuIApvbmUgbm9kZSBpcyBmZW5jZWQvZG93biAodGhlIGRsbSByZWNvdmVyeSByb3V0aW5lIGlz
IHRyaWdnZXJlZCkuIAoKQW55IGNvbW1lbnRzPwoKVGhhbmtzCkdhbmcKX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KT2NmczItZGV2ZWwgbWFpbGluZyBsaXN0
Ck9jZnMyLWRldmVsQG9zcy5vcmFjbGUuY29tCmh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFpbG1h
bi9saXN0aW5mby9vY2ZzMi1kZXZlbA==
