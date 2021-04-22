Return-Path: <SRS0=okW4=JT=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D321C43460
	for <ocfs2-devel@archiver.kernel.org>; Thu, 22 Apr 2021 16:36:32 +0000 (UTC)
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CD7A6613B8
	for <ocfs2-devel@archiver.kernel.org>; Thu, 22 Apr 2021 16:36:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CD7A6613B8
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
	by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13MGaUND152566;
	Thu, 22 Apr 2021 16:36:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : date :
 message-id : references : in-reply-to : content-id : mime-version : cc :
 subject : list-id : list-unsubscribe : list-archive : list-post :
 list-help : list-subscribe : content-type : content-transfer-encoding :
 sender; s=corp-2020-01-29;
 bh=aTxSkR5obhwQ4iJUzioMdXDd+E8yH6nq09LeHCM8VzQ=;
 b=GLGinggo0KJu8AEXNUyWmEXHuDc6hPMorrxk3w6sg1g0g7jxTWWgFfc1zKShZLAt8Avl
 x9xJKpdTJada6zMtWJfLzIGOf4P8infgE4TLYe8pqEIVdi2ScEPuX4u7RMHkiNU8hycW
 QS6rHyFal7qG6SixqaIb32bgCzoXzN/Tr1NvGcvYkg3TUDyJeW269cj/Nb1Ad8DA7Jdx
 RMIXE9WE3xP1xGd4w1JDAM6wO+z1QCYuhE1fuS4zmWAWvhkw2AHLUS9tw+ECwl82/5T9
 pHjCLG5wXSWHD9xsGi3KudATUd+FtCNqjQvSd/vdCC3zBo489UAzzyNu/Mz7lJGyWlHk DA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by userp2120.oracle.com with ESMTP id 38022y5d9m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Apr 2021 16:36:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13MGa9dl170685;
	Thu, 22 Apr 2021 16:36:29 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 383cdrs44w-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Thu, 22 Apr 2021 16:36:29 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lZcJY-000209-Gu; Thu, 22 Apr 2021 09:36:28 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <wen.gang.wang@oracle.com>) id 1lZcJW-0001zt-G5
	for ocfs2-devel@oss.oracle.com; Thu, 22 Apr 2021 09:36:26 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	13MGaA7l170727
	for <ocfs2-devel@oss.oracle.com>; Thu, 22 Apr 2021 16:36:26 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com
	(mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
	by userp3030.oracle.com with ESMTP id 383cdrs425-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Thu, 22 Apr 2021 16:36:26 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
	by SN6PR10MB2557.namprd10.prod.outlook.com (2603:10b6:805:3f::22)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20;
	Thu, 22 Apr 2021 16:36:23 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
	([fe80::459d:9552:66ce:5b44]) by
	SN6PR10MB2701.namprd10.prod.outlook.com
	([fe80::459d:9552:66ce:5b44%3]) with mapi id 15.20.4065.023;
	Thu, 22 Apr 2021 16:36:23 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Thread-Topic: [Ocfs2-devel] Possible fs corruption when hole punch races with
	other ops
Thread-Index: AQHXNsuohRmYiyry8kWgBDUydto7Maq/38GAgAB7lICAAFcggIAAAsMAgAAIc4A=
Date: Thu, 22 Apr 2021 16:36:23 +0000
Message-ID: <7C502B8A-F978-4DB3-897B-9E726D39F08E@oracle.com>
References: <20210421162953.GA13863@quack2.suse.cz>
	<c4d119be-e263-366c-c2c2-6c58ee852977@linux.alibaba.com>
	<20210422104425.GC26221@quack2.suse.cz>
	<3A2B19E3-3DFF-454E-BFC9-A6B48629509F@oracle.com>
	<20210422160608.GB547183@magnolia>
In-Reply-To: <20210422160608.GB547183@magnolia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: kernel.org; dkim=none (message not signed)
	header.d=none; kernel.org; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [71.198.166.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 10e37458-c655-45f0-4aa3-08d905acc47a
x-ms-traffictypediagnostic: SN6PR10MB2557:
x-ms-exchange-transport-forked: True
x-oracle-tenancy: 1
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kWPjOObKF7JNEscLcOV7OYmN7+u5ZCOTKwQkpQAvVdn4/ssqExAKDhGcd6L/HbsqxEBTBi0RplbIZu56mK07S4Q7HJrpbstLrl2aDea3c736RrnLKPOW12A9MGWQBwyK4EZKIipthAImobwm2xigq9+kEMnFXBf9FJPBifHGkZy2uNPrSKAlvq+vHyUw6iJ5C9fZR2kw5Me/b9eZnkgN5g2eyeKIGvLm4h1E6Ic+Tg+2gJr0ChgwywRO/UIDVlSxRQX8AUvKihGlMvU7n2b+RYVVX4oX5MIpUuBWCRafCUg2EX7bqZgjkspvTbcTgVfl6KgsTTtYjvZo8FqdQ9dPXhqGwFhKwPZORVmRlWf2XCA40jd73XPTCT4dXHFE3iNb6AaT9aE83WcrFuEg01G70p3FFWFbJ4dEU5ReayGJ/ORjMMWL2M+voIUsOs7JXaOq6uAnXjtN5n12ixrlQjJLeDhWldZgmQJrU0qEfw6xEwg3FLkTfE6JYWRaYSXVZ1mkhBZ8+vf/fnZ9xVtNnw4hbnWVHj11m9I7bzHhGwwUOswVqbtXpbeWnY0YrHNL2/7aSysGes/x/5Nz+YnlTUTpXRgt3BSL6SWvawupZ/kCO7vtMfG3Ux7KD4j7tvrqRYKE/TPEdw6gUS4pXy0dWmIIAQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:SN6PR10MB2701.namprd10.prod.outlook.com; PTR:; CAT:NONE; SFS:;
	DIR:INB; 
x-ms-exchange-antispam-messagedata: =?utf-8?B?eVp3WGhmNks0SkxaRmlGUXMwdll6YkNxcm9iemtVRFJlZ00veXlNY1k5N2po?=
	=?utf-8?B?U0IvSGN1VG1WOGk5dmd6ZnlxVEFFdE5UTkRTTWgwSEREdXFManIvTHBsQkJu?=
	=?utf-8?B?YlBtN1A4ZUVHeldQU1hxbXgzQkViNXg2YWdVekl0bmxVWnh3WHFYQmNPczVw?=
	=?utf-8?B?bVI0Q0Rkb2h1RG1aQnhBd2pDZ1ZYRkV3UERhWktsdkx3WEE5Vnh2aFI4MHN3?=
	=?utf-8?B?QVZhY0VWVDNkdnBQOW9sL0RBbVRlK0RmcktyQi80eXJ2aEE3VllJK2JlVW1S?=
	=?utf-8?B?V3Y0WUI0T2MzSEU2QlYvbmgwOHNpcHFqN3V0NS9mbE5TM0xJTE5lakcwUjlG?=
	=?utf-8?B?dFZ5U2UxQ0xwTTM4elRiTHVEUUxlQUNDZ3I5U05zbHdVb3cxcFhYQ1B2NndG?=
	=?utf-8?B?YVBOUUFqSWtRa2l1UVdDdGZDZmtXTDRwM3RpaGZHU2hxRllBWm5KK0FxaGR5?=
	=?utf-8?B?TzUvOUxVWFM4TDhSY3FXYUNmeUhhM1dka2s3clpqTUVDL3RlS2VSOWw4SnBm?=
	=?utf-8?B?bjNUQW50bGp5eEEybmtvL2huVkRrUVJmZFVVMGdMZ2txVkJzYmpvd1F6ODFk?=
	=?utf-8?B?WGptZlYzNElRaXMxQm9uNjBCRXRGTDlBWkVQeTVmY1NhcWhJbWxzRDVwNUNS?=
	=?utf-8?B?WlpMTnNnQmo5R1BmdE84S0dnc21SQnpUR3lScHpGOFpBVkZaV3U3THNoYnJZ?=
	=?utf-8?B?c2pRYnFyVDdtekptTFZqU2daMFFiOUVBdUJzVCtsWmFYN3BicWpvR2Q3OUln?=
	=?utf-8?B?bk9mOXJiVFpHZXNxSjVuWE9jamlUUHNtOFRCY2dGTXYwY3hwaS9iR2hoTHdw?=
	=?utf-8?B?RTBFSWg5M1FMeS9aRmNVMHZVckcvWWF2bjdZN1VrM0JLNVVYZ1pnQWQvSkdy?=
	=?utf-8?B?Ulo0K3Q4OWwyMEFSb1BnbktvZGw2L0tNTVF2a3U5S211RkE1NCszR3ozK3JC?=
	=?utf-8?B?eXBOL0hyTzJhTVIyQStCSGRBNm11U04zUEI0eVduc0pCdlFyb0dBc000WlhX?=
	=?utf-8?B?MHFzS3pvbmdhM1lUdjZmREJuQnpQcTZHTDVWejk4WGJra3ByN0ZxWGM0UXZX?=
	=?utf-8?B?Zno1UWh2OGg3WUxSYVExbll6MnNORGpzQWJMYVVpMk1SSW5ZczFrN2N5S3VL?=
	=?utf-8?B?VTFGMzI4QlIxZ3BLWkFneStGUEpqZWFqVlEwbFEwcDh4aTl6WVNnT2MyQzB3?=
	=?utf-8?B?eFZiTjNubHdrTWNNYmlmVWRvb1ZmK2lmY2VUL2dDZksrTTREL0ZobmpRSFpm?=
	=?utf-8?B?N3JJWUlWemFyYVNoNjNzOEVmcjJJK2RvT0tmYTNPSWtTNVFMZS9ZNjVQckFI?=
	=?utf-8?B?WklJQVNsdC81dkR0NmNWcG1ZL3hZVzRpd2ZEMytwOG1mRUNUODZjMzcyQURw?=
	=?utf-8?B?UGh6eWVpZTJzTHF3OVFQa3g3Z3BrTjF4cEtEZE0vUWN5ZFpPSGVNeUVHcGFP?=
	=?utf-8?B?VTN5aC9nNWNDd0VleTNXRkhDc0dBbTIvNkxYQXh3a3dIOUhMT3hucXQ0Y3JG?=
	=?utf-8?B?UXp4bEUrNWpvOUZVSDEvSW9hVUxSbml2YXFvZzNhZW1scEdWekVXZSswRGhI?=
	=?utf-8?B?bldrWUlIbnpLdmZsbEplb2t1b3ViRGF2VlRZQzV2dEdqS2VaUXBXM0lrUXIv?=
	=?utf-8?B?YVMyYkFHM3Z1QnF4bEljWGs5RzZyTmR0d0dFOExDVTJkM0J1TzQzWXdxV0xN?=
	=?utf-8?B?TkxTYUptTHIwSVJXMHV1Q0FkemJkVnVVUUI3cXorQ2habXpYcnY2eXZ1cjhB?=
	=?utf-8?Q?sVUz7ZmRjEqNknmF7BXYaiRB83gGs4PsoxkdEsD?=
Content-ID: <F278D9BB46770943A590936AAB4C2FDD@namprd10.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10e37458-c655-45f0-4aa3-08d905acc47a
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2021 16:36:23.7459 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ndUGZ65B6RYuI+/N2Gp/KMjqc16NbR5Wa5ht8673YeQwdhgEZ86yfROXRziiD4RX6WfslQ6y2yHvfYTaSt4b5likW+xTYa/XOlzXzRCcYRU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2557
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
X-OrganizationHeadersPreserved: SN6PR10MB2557.namprd10.prod.outlook.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
	spamscore=0 bulkscore=0
	suspectscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104060000 definitions=main-2104220124
Cc: Jan Kara <jack@suse.cz>, ocfs2-devel ML <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] Possible fs corruption when hole punch races
	with	other ops
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220124
X-Proofpoint-ORIG-GUID: 6VcnUgchA0tbWQVorZfeXBR51OG7gLYw
X-Proofpoint-GUID: 6VcnUgchA0tbWQVorZfeXBR51OG7gLYw
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 spamscore=0 bulkscore=0 phishscore=0 clxscore=1015 impostorscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220124

DQoNCj4gT24gQXByIDIyLCAyMDIxLCBhdCA5OjA2IEFNLCBEYXJyaWNrIEouIFdvbmcgPGRqd29u
Z0BrZXJuZWwub3JnPiB3cm90ZToNCj4gDQo+IE9uIFRodSwgQXByIDIyLCAyMDIxIGF0IDAzOjU2
OjE1UE0gKzAwMDAsIFdlbmdhbmcgV2FuZyB3cm90ZToNCj4+IEhpIEhvbnphLA0KPj4gDQo+PiBC
eSDigJxob2xlIHB1bmNoaW5nIG9wZXJhdGlvbuKAnSwgeW91IG1lYW50IGRlYWxsb2NhdGUgc29t
ZSBkYXRhIGJsb2Nrcw0KPj4gZnJvbSBhIGZpbGUgYW5kIGtlZXAgdGhlIGZpbGUgc2l6ZSB1bmNo
YW5nZWQsIGFmdGVyIHRoYXQgb3BlcmF0aW9uDQo+PiBzb21lIOKAnGhvbGVzIiBhcmUgbWFkZSBp
biB0aGF0IGZpbGUsIHJpZ2h0Pw0KPj4gSSBhbSBqdXN0IGN1cmlvdXMgdGhhdCBkbyB3ZSByZWFs
bHkgaGF2ZSBlbmQgdXNlciBwcm9ncmFtcyB0aGF0IGRvDQo+PiBob2xlIHB1bmNoaW5nIG9uIGZp
bGVzPyBPciBob2xlIHB1bmNoaW5nIGlzIG9ubHkgdXNlZCBmb3IgZGV2ZWxvcG1lbnQNCj4+IHB1
cnBvc2U/DQo+IA0KPiBZZXMsIHdlIGRvLiAgUUVNVSBkb2VzIGl0IHRvIGltYWdlIGZpbGVzLCB2
YXJpb3VzICRkYXRhYmFzZSBwcm9kdWN0cywNCg0KSG0sIHRvIHJ1biBhIGhvbGUgcHVuY2hpbmcs
IHRoYXQgbWVhbnMgdGhlIGRhdGEgYmxvY2tzIHRvIGRlYWxsb2NhdGUgd2VyZSB1c2VmdWwgYnV0
IG5vdyBhcmUgbm8gbG9uZ2VyIHVzZWZ1bC4gDQpGb3IgUUVNVSwgaXQgZG9lcyBob2xlIHB1bmNo
aW5nIGF0IGd1ZXN0IHJ1biB0aW1lIGZvciBndWVzdCBGUyB0cmltcz8gRG9u4oCZdCBrbm93IGlu
IHdoYXQgY2FzZXMgREJzIG1ha2UgdXNlIG9mIGhvbGUgcHVuY2hpbmcuDQpXZWxsLCBnb29kIHRv
IGtub3cuDQoNClRoYW5rcyBEYXJyaWNrLg0KDQp3ZW5nYW5nDQoNCj4gZXRjLi4uDQo+IA0KPiAt
LUQNCj4gDQo+PiANCj4+IHRoYW5rcywNCj4+IHdlbmdhbmcNCj4+IA0KPj4gT24gQXByIDIyLCAy
MDIxLCBhdCAzOjQ0IEFNLCBKYW4gS2FyYSA8amFja0BzdXNlLmN6PG1haWx0bzpqYWNrQHN1c2Uu
Y3o+PiB3cm90ZToNCj4+IA0KPj4gSGVsbG8hDQo+PiANCj4+IE9uIFRodSAyMi0wNC0yMSAxMToy
MjowNywgSm9zZXBoIFFpIHdyb3RlOg0KPj4gQ2hlY2tlZCB0aGUgY29kZSBmbG93LCBpdCBzZWVt
cyB0aGUgcmFjZSB5b3Ugd29ycmllZCB0cnVseSBleGlzdHMuDQo+PiBXZSBoYXZlIHRvIHRha2Ug
aXBfYWxsb2Nfc2VtIGJlZm9yZSBjYWxsaW5nIGludG8gb2NmczJfZ2V0X2Jsb2NrKCkuDQo+PiAN
Cj4+IE9LLCB0aGF0J3Mgd2hhdCBJIGFzc3VtZWQgYnV0IHRoaXMgd29uJ3QgYmUgZWFzeS4gQmVj
YXVzZSBvY2ZzMl93cml0ZXBhZ2UoKQ0KPj4gaXMgY2FsbGVkIHdpdGggYSBwYWdlIGxvY2tlZCBi
dXQgb2NmczJfcmVtb3ZlX2lub2RlX3JhbmdlKCkgZ2V0cyBjYWxsZWQNCj4+IHVuZGVyIGlwX2Fs
bG9jX3NlbSBhbmQgbG9ja3MgcGFnZXMgaW4gb2NmczJfdHJ1bmNhdGVfY2x1c3Rlcl9wYWdlcygp
IC0+DQo+PiB0cnVuY2F0ZV9pbm9kZV9wYWdlc19yYW5nZSgpLiBXaGljaCBjcmVhdGVzIEFCQkEg
ZGVhZGxvY2suIFNvIHlvdSdsbA0KPj4gcHJvYmFibHkgbmVlZCB0byBjb21lIHVwIHdpdGggYSBz
aW1pbGFyIGRhbmNlIGxpa2UgaW4gb2NmczJfcmVhZHBhZ2UoKS4NCj4+IA0KPj4gQnV0IGFmdGVy
IGZpeGluZyB0aGlzLCBpcF9hbGxvY19zZW0gc2hvdWxkIHByb3ZpZGUgeW91IHdpdGggZW5vdWdo
DQo+PiBwcm90ZWN0aW9uIHNvIHRoYXQgb2NmczIgaXNuJ3QgcHJvbmUgdG8gcmFjZXMgYmV0d2Vl
biBob2xlIHB1bmNoIGFuZA0KPj4gcmVhZGFoZWFkIC8gZmF1bHQgbXkgd29yayB3aWxsIGJlIG1v
c3RseSBpcnJlbGV2YW50IGZvciBPQ0ZTMi4NCj4+IA0KPj4gVGhhbmtzIGZvciBjb25maXJtYXRp
b24hDQo+PiANCj4+IEhvbnphDQo+PiANCj4+IE9uIDQvMjIvMjEgMTI6MjkgQU0sIEphbiBLYXJh
IHdyb3RlOg0KPj4gSGVsbG8sDQo+PiANCj4+IEknbSB1bmlmeWluZyBwcm90ZWN0aW9uIHZhcmlv
dXMgZmlsZXN5c3RlbXMgdXNlIHRvIHByb3RlY3QgaG9sZSBwdW5jaA0KPj4gb3BlcmF0aW9ucyBm
cm9tIHJhY2luZyB3aXRoIG90aGVyIG9wZXJhdGlvbnMgKGxpa2UgcmVhZGFoZWFkLCBwYWdlIGZh
dWx0LA0KPj4gd3JpdGVwYWdlIGV0Yy4pLiBJIHdhcyBsb29raW5nIGludG8gT0NGUzIgYW5kIEkg
dGhpbmsgaXQgaXMgcHJvbmUgdG8gYQ0KPj4gZm9sbG93aW5nIHJhY2Ugd2hpY2ggY2FuIHBvc3Np
Ymx5IGxlYWQgdG8gZmlsZXN5c3RlbSBjb3JydXB0aW9uLiBCdXQgbWF5YmUNCj4+IEkgbWlzcyBz
b21ldGhpbmcgc28gdGhhdCdzIHdoeSBJJ20gd3JpdGluZyBoZXJlLiBUaGUgc2NlbmFyaW8gSSdt
IGNvbmNlcm5lZA0KPj4gYWJvdXQgaXM6DQo+PiANCj4+IENQVTEgQ1BVMg0KPj4gb2NmczJfcmVt
b3ZlX2lub2RlX3JhbmdlKCkgb2NmczJfd3JpdGVwYWdlKCkNCj4+IC4uLiAgIGJsb2NrX3dyaXRl
X2Z1bGxfcGFnZSgpDQo+PiBvY2ZzMl9yZW1vdmVfYnRyZWVfcmFuZ2UoKSAgICAgb2NmczJfZXh0
ZW50X21hcF9nZXRfYmxvY2tzKCkNCj4+IA0KPj4gTm93IG9jZnMyX2V4dGVudF9tYXBfZ2V0X2Js
b2NrcygpIHJ1bnMgd2l0aG91dCBwcm90ZWN0aW9uIG9mIGlwX2FsbG9jX3NlbQ0KPj4gQUZBSUNU
IGFuZCBzbyBib3RoIHRoZXNlIG9wZXJhdGlvbnMgY2FuIGJlIG1vZGlmeWluZyBleHRlbnQgbWFw
IGF0IHRoZSBzYW1lDQo+PiB0aW1lPyBXaGF0IGFtIEkgbWlzc2luZz8NCj4+IA0KPj4gSG9uemEN
Cj4+IA0KPj4gLS0NCj4+IEphbiBLYXJhIDxqYWNrQHN1c2UuY29tPG1haWx0bzpqYWNrQHN1c2Uu
Y29tPj4NCj4+IFNVU0UgTGFicywgQ1INCj4+IA0KPj4gX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18NCj4+IE9jZnMyLWRldmVsIG1haWxpbmcgbGlzdA0KPj4g
T2NmczItZGV2ZWxAb3NzLm9yYWNsZS5jb208bWFpbHRvOk9jZnMyLWRldmVsQG9zcy5vcmFjbGUu
Y29tPg0KPj4gaHR0cHM6Ly9vc3Mub3JhY2xlLmNvbS9tYWlsbWFuL2xpc3RpbmZvL29jZnMyLWRl
dmVsDQo+PiANCj4gDQo+PiBfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXw0KPj4gT2NmczItZGV2ZWwgbWFpbGluZyBsaXN0DQo+PiBPY2ZzMi1kZXZlbEBvc3Mu
b3JhY2xlLmNvbQ0KPj4gaHR0cHM6Ly9vc3Mub3JhY2xlLmNvbS9tYWlsbWFuL2xpc3RpbmZvL29j
ZnMyLWRldmVsDQo+IA0KDQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwpPY2ZzMi1kZXZlbCBtYWlsaW5nIGxpc3QKT2NmczItZGV2ZWxAb3NzLm9yYWNsZS5j
b20KaHR0cHM6Ly9vc3Mub3JhY2xlLmNvbS9tYWlsbWFuL2xpc3RpbmZvL29jZnMyLWRldmVs
