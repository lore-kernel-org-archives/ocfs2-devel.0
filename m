Return-Path: <SRS0=z2TF=H2=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 227C9C433DB
	for <ocfs2-devel@archiver.kernel.org>; Wed, 24 Feb 2021 21:55:55 +0000 (UTC)
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id ADB2F64EFA
	for <ocfs2-devel@archiver.kernel.org>; Wed, 24 Feb 2021 21:55:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ADB2F64EFA
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
	by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11OLtVAi121720;
	Wed, 24 Feb 2021 21:55:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : date :
 message-id : references : in-reply-to : content-id : mime-version : cc :
 subject : list-id : list-unsubscribe : list-archive : list-post :
 list-help : list-subscribe : content-type : content-transfer-encoding :
 sender; s=corp-2020-01-29;
 bh=Lt8vImWR10yT+hFh/EcKR7Nik9QrYgIUTDZfsIys+HE=;
 b=md3QpkGoYhPkmnMftQAlL4QsG24hRdibpBfoN753tNK9tY2QBkg+bKh51iXF0j/gUZs8
 GkS6gdujp6t4UPAsRHmlr71uUwqtoJzv/6Xiuh6OIzt3+k5Ozv1QyetZOyGK2cOob+1t
 WXUy/9QerKYD6q9XAb5NdbcFDWjWdBo4hENxlMSqNw99qPvhowBibPtgDFo0gP6Zqq/D
 39udHRpngEcOoe6GpdfTSAjgOOYmOkFY0cbb/Uduu6ZffClcU3fdv5liIpYippjBDLwc
 CowWor+oXccfNTqPvPeZdqYDEHoOFEW1gpoLpT45YswIFk8HAkLZ6nOEP24GD7BZN9Rt jA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by userp2130.oracle.com with ESMTP id 36tsur4hsh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Feb 2021 21:55:53 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11OLseuw009356;
	Wed, 24 Feb 2021 21:55:52 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 36ucc0dx61-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 24 Feb 2021 21:55:52 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lF22H-00084c-Nh; Wed, 24 Feb 2021 13:49:33 -0800
Received: from userp3020.oracle.com ([156.151.31.79])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <wen.gang.wang@oracle.com>) id 1lF21o-00083h-IL
	for ocfs2-devel@oss.oracle.com; Wed, 24 Feb 2021 13:49:04 -0800
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	11OLkBkQ143650
	for <ocfs2-devel@oss.oracle.com>; Wed, 24 Feb 2021 21:49:04 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com
	(mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
	by userp3020.oracle.com with ESMTP id 36uc6tp2mw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 24 Feb 2021 21:49:04 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
	by SA2PR10MB4537.namprd10.prod.outlook.com (2603:10b6:806:116::23)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.33;
	Wed, 24 Feb 2021 21:49:02 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
	([fe80::74cc:15dc:8911:4291]) by
	SN6PR10MB2701.namprd10.prod.outlook.com
	([fe80::74cc:15dc:8911:4291%4]) with mapi id 15.20.3868.033;
	Wed, 24 Feb 2021 21:49:02 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: "Lentes, Bernd" <bernd.lentes@helmholtz-muenchen.de>
Thread-Topic: [Ocfs2-devel] error message in log: ocfs2_reflink_ioctl:4431
	ERROR:	status = -17
Thread-Index: g5xUhHWN9KIR5CmwxPJXuTW4kSHzTvVrXEYA5yqc6AqY1uuggA==
Date: Wed, 24 Feb 2021 21:49:02 +0000
Message-ID: <B8316D3D-A4CB-4248-9596-C26FB7B914FB@oracle.com>
References: <1884783914.58523079.1614110913964.JavaMail.zimbra@helmholtz-muenchen.de>
	<01866DBC-59D3-4D41-B404-C76FCA6B6221@oracle.com>
	<834203578.59367045.1614157887078.JavaMail.zimbra@helmholtz-muenchen.de>
In-Reply-To: <834203578.59367045.1614157887078.JavaMail.zimbra@helmholtz-muenchen.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.40.0.2.32)
authentication-results: helmholtz-muenchen.de; dkim=none (message not signed)
	header.d=none; helmholtz-muenchen.de;
	dmarc=none action=none header.from=oracle.com;
x-originating-ip: [71.198.166.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 051aba4a-90de-4b43-6bb0-08d8d90dffe5
x-ms-traffictypediagnostic: SA2PR10MB4537:
x-ms-exchange-transport-forked: True
x-oracle-tenancy: 1
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gr6YiTgO6H9enxsle83lVqJdBoeobQBkCgXUY+5GqbvaDpwV1KJCrPbOc1KmpUBaDfizh65QZtM1ryeGybXfAtYKb01Xfdk3O0wjSoBYknDwWrcnrqS2iz17FkZGvh1ylN2T+Dv/8cklSUtqx1ygsR9a3Jc01Vg6rxWvEPqz4VYlcmxgmMj+pcW1jiQ4WNCeL5SAnqVTaLiv6nYTwch2zE7FsycbcGkXEQbGt/r27r2r2pWoOeC0MUerK+8w247o7BvWwSNpsMT34h1pDidAHOwu1uMJCtYsDRBXMi8+kiBiR+6wk8ec446shvn/INM/A7mp74Q+LKbLEdzQFSCWQQg25ftMKaQF78QIrlJ2EPZTw/Q76nNDo5cZk49iwlowJ7h04yE/BrGcWznBF64rVn9ApFwI6vjNOWLgk4ryqniQb7OkUVKifkFB1000epm4oy24ceyUP0zLjZbF1IkvwdU682aws5udySLsdskz/9wHHXw8HI6BszkPKKU14o+B1erSIfI3CTGfndGArDdwDV410zfnx2Kq04sW6W/JkHVjDv9cBN/WIdwmhXdqG50v
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:SN6PR10MB2701.namprd10.prod.outlook.com; PTR:; CAT:NONE; SFS:;
	DIR:INB; 
x-ms-exchange-antispam-messagedata: =?utf-8?B?U1RmM2pkckhYQjVLcnVBUGJ6S0E3bm5Db0tlcU91UytZU0ZZbldjc1N3dzVD?=
	=?utf-8?B?SG5jb0pFdThHQWRPbzBKMWZYVkRKRjdlQkhpam03aVhKdWdZelV2Sm51ZXlW?=
	=?utf-8?B?ekk5N2NEa3BvT081NmFoN2x4eTRtejV0MEQ3dmVBRGppKzFaRmo4cTA2UDIy?=
	=?utf-8?B?d3YzTUg1bkVTQ05NQ0dXNkk3UDVJRmlqQ2dtSENRQUlZS1JhN3VqMXl1NllZ?=
	=?utf-8?B?WDB5aDNDTWY5YklNS0ZQb3NRSGFkUENCcVVYdTdFNW0wV3RtQlRFYytZYUNz?=
	=?utf-8?B?T202QzZwcVJYWTFoMVV1V056aXE2MDd1dWtvb3piQmRCTUVSYTAvZmJxQ2hn?=
	=?utf-8?B?ZWx1UlgwYTI0bE1kVzIwVVlGNHNrak1zQ2NrQUYvUFFtclVxNjlEc2F3Zy9G?=
	=?utf-8?B?aGFUd3FUQXNiS3M0YjJSczlrTW56dUVNZVJzbTVodXRMMzNoaWVVRjh1WmJI?=
	=?utf-8?B?NlNEWW81T3I2dlE5OUVrbXkza0dkSk9zSXNWUmhaUVdzNFcveVprZGRkSVcv?=
	=?utf-8?B?UzQwUW1aRGJYMElqWnE0bUZ1ck5rOUhZdHZCUzZpYlZnbVVORUtVQnZRb092?=
	=?utf-8?B?VldMOW9nM290bFBKWHJMSzlTdGo2bEc4WWVxQXZYdmxUUDgxT3NFaHQzOTUz?=
	=?utf-8?B?RzB6RGo1NW10SXdEMDRSV1FWdmNRRWw2T3pxdFY5OGNDUVUwMDNPM1BxcU16?=
	=?utf-8?B?bGhONURWOHNnTE81YTdYMlVTdDVScGV5TDhCNWtINEhKVitERXZSa3AxelNx?=
	=?utf-8?B?SnhXdWMrMVBhc1dRQWZPNm0xNUUweFJ0eWhTQUl3U3hGMHMvZlZuRnFycTlQ?=
	=?utf-8?B?TjlMQUIwOHY4eEl6L1NHLytiY3pXSjlyNVUxamQ0WE9rTzYyUXBmNnFJVWtz?=
	=?utf-8?B?R0JGRllPWnBkcTZKdjJzWEVJSjNpQ0hYTUpjTDJPS24zMTlDY0lxK0N1bWM3?=
	=?utf-8?B?RDd4MXhlUUJESDZPYzJmclhYMTlCVk9wRWROM0FpNlBidHFIRVZzdE1sblhJ?=
	=?utf-8?B?cFNGR1AzQTFDNjhwbC83RTBxOHBDSVZCZThtVXFOLzI0K0QyRU1vSDQyUGhi?=
	=?utf-8?B?Qzh3aDRSRUgwMDhUWXdTTitlYmdVSmxNTFV6eVM3MFFlaDJIdzc2aFk1VThH?=
	=?utf-8?B?MGJNWEg0bC9SRjU0V2doWHdQUVM5YmYydW5Bdmd5REdEdGluRmdmWGNPOHln?=
	=?utf-8?B?Vm1XdkQrTmhYUGt2SFFETU41aTRobTZtVlUrZTY3TkpXQXN0eTQ0b1NBV1ZT?=
	=?utf-8?B?bHRNTFlmajhYSWJzQWhnTmVFV2RmRitTeG83VXRXY29BYmpOMTNoeDVBcTJq?=
	=?utf-8?B?K0N2VWFVUE03ZU45N3RzeVdjWURBTFl2dGNHbXY2NmZuL3BPRUdiWVh1N3FV?=
	=?utf-8?B?SEMwc2svMzFicmFGLzV5dnkreTlzT2t2disrcHJ5T2lNblRLeExIUnNGM3pm?=
	=?utf-8?B?U3IyV3pFRmFHMC9LUkhsUlNreS9DbkVBbks3QWpNbnRUYlVpM1lqWkRteTgz?=
	=?utf-8?B?a1d5cnRKYlk5bkFucUhFVXRlYTh4QytIQ1BhQ3Y1elZMbUV3T2w1dUlzOTg3?=
	=?utf-8?B?bm53QjF5SFd1Mngwa20wdmhqS2U0cnV3WXRZU1R3bVdvY1FaTDgrZ09lMjVj?=
	=?utf-8?B?WVlHd253WjNtbElzOTU5UzE1RnMwdmdmKy9XWXBiaFgyNnVtMHpGVjZDNmox?=
	=?utf-8?B?QTZ4Ym93dCt0dUFCcGJ2Ung2d2U3MGVOd2EvTFJBS090RTNSeERTY01YNkNB?=
	=?utf-8?Q?F6wdOZhVfDapo0RM1hxK3O+n9/LJysa6tsiJCSZ?=
Content-ID: <E0E1E093EAAC604A9CE072FE203F041F@namprd10.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 051aba4a-90de-4b43-6bb0-08d8d90dffe5
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2021 21:49:02.2453 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Gw5xp5s0iPf68RnmG8bkK3T7XV9tueFySiBxXoeERyFeAavG7vSrAtaKYrKlgIfSCKxe9U1jwhgXyyu4sgc8KM0EE7Dpc0NuLSEevOYLof0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4537
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 04
X-MS-Exchange-CrossPremises-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-SCL: -1
X-MS-Exchange-CrossPremises-messagesource: StoreDriver
X-MS-Exchange-CrossPremises-BCC: 
X-MS-Exchange-CrossPremises-originalclientipaddress: 71.198.166.82
X-MS-Exchange-CrossPremises-transporttraffictype: Email
X-MS-Exchange-CrossPremises-antispam-scancontext: DIR:Originating; SFV:SKI;
	SKIP:0; 
X-MS-Exchange-CrossPremises-processed-by-journaling: Journal Agent
X-OrganizationHeadersPreserved: SA2PR10MB4537.namprd10.prod.outlook.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9905
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	mlxscore=0 spamscore=0
	mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2102240167
Cc: ocfs2-devel <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] error message in log: ocfs2_reflink_ioctl:4431
 ERROR:	status = -17
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9905 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102240169
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9905 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102240169

DQoNCj4gT24gRmViIDI0LCAyMDIxLCBhdCAxOjExIEFNLCBMZW50ZXMsIEJlcm5kIDxiZXJuZC5s
ZW50ZXNAaGVsbWhvbHR6LW11ZW5jaGVuLmRlPiB3cm90ZToNCj4gDQo+IA0KPiAtLS0tLSBPbiBG
ZWIgMjMsIDIwMjEsIGF0IDExOjI0IFBNLCBXZW5nYW5nIFdhbmcgd2VuLmdhbmcud2FuZ0BvcmFj
bGUuY29tIHdyb3RlOg0KPiANCj4+ICNkZWZpbmUgRUVYSVNUIDE3IC8qIEZpbGUgZXhpc3RzICov
DQo+IA0KPj4gWW91IG1heSBhbHJlYWR5IGhhdmUgdGhlIGZpbGUgY3JlYXRlZCBmcm9tIHRoZSBv
dGhlciBub2RlLg0KPiANCj4+IHdlbmdhbmcNCj4gDQo+IA0KPiBIaSBXZW5nYW5nLA0KPiANCj4g
dGhhbmtzIGZvciB5b3VyIGhlbHAuDQo+IA0KPiBUaGUgcmVmbGluayBpcyBjcmVhdGVkIHZpYToN
Cj4gcmVmbGluayAtZnYgL3BhdGgvdG8vZG9tYWluLnJhdyAvbW50L29jZnMyL3JlZmxpbmsNCj4g
DQo+IE9mIGNvdXJzZSB0aGlzIGZpbGUgZXhpc3RzIGFscmVhZHkgYmVjYXVzZSB0aGUgc2tyaXB0
IHJhbiBhbHNvIG9uZSBkYXkgYmVmb3JlLg0KPiBCdXQgZnJvbSB3aGljaCBub2RlIHRoZSBwcmV2
aW91cyBvbmUgd2FzIGNyZWF0ZWQgaXMgdW5wcmVkaWN0YWJsZSwgaXQgbWlnaHQgYmUgdGhlIHNh
bWUNCj4gYnV0IGFsc28gdGhlIG90aGVyIG9uZS4NCj4gDQo+IElzIHRoZSBtZXNzYWdlIHNldmVy
ZSBvciBkb24ndCBpIGhhdmUgdG8gYm90aGVyIGFib3V0IGl0ID8NCj4gDQoNCk9DRlMyIGlzIGEg
c2hhcmVkLXN0b3JhZ2UgY2x1c3RlciBGUy4gIEZvciB0aGUgcmVmbGlua3MsIHlvdSBuZWVkIGFu
ZCBzaG91bGQgY3JlYXRlIHRoZW0gb25seSBmcm9tIG9uZSBvZiB0aGUgbm9kZXMuIERvbuKAmXQg
ZG8gZHVwbGljYXRlZCB3b3JrIChyZWZsaW5rKSBvbiBvdGhlciBub2Rlcy4NCg0KdGhhbmtzLA0K
d2VuZ2FuZw0KDQoNCj4gVGhhbmtzLg0KPiANCj4gQmVybmQNCj4gSGVsbWhvbHR6IFplbnRydW0g
TcO8bmNoZW4NCj4gDQo+IEhlbG1ob2x0eiBaZW50cnVtIE11ZW5jaGVuDQo+IERldXRzY2hlcyBG
b3JzY2h1bmdzemVudHJ1bSBmdWVyIEdlc3VuZGhlaXQgdW5kIFVtd2VsdCAoR21iSCkNCj4gSW5n
b2xzdGFlZHRlciBMYW5kc3RyLiAxDQo+IDg1NzY0IE5ldWhlcmJlcmcNCj4gd3d3LmhlbG1ob2x0
ei1tdWVuY2hlbi5kZQ0KPiBBdWZzaWNodHNyYXRzdm9yc2l0emVuZGU6IE1pbkRpci5pbiBQcm9m
LiBEci4gVmVyb25pa2Egdm9uIE1lc3NsaW5nDQo+IEdlc2NoYWVmdHNmdWVocnVuZzogUHJvZi4g
RHIuIG1lZC4gRHIuIGguYy4gTWF0dGhpYXMgVHNjaG9lcCwgS2Vyc3RpbiBHdWVudGhlcg0KPiBS
ZWdpc3RlcmdlcmljaHQ6IEFtdHNnZXJpY2h0IE11ZW5jaGVuIEhSQiA2NDY2DQo+IFVTdC1JZE5y
OiBERSAxMjk1MjE2NzENCj4gDQoNCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fCk9jZnMyLWRldmVsIG1haWxpbmcgbGlzdApPY2ZzMi1kZXZlbEBvc3Mub3Jh
Y2xlLmNvbQpodHRwczovL29zcy5vcmFjbGUuY29tL21haWxtYW4vbGlzdGluZm8vb2NmczItZGV2
ZWw=
