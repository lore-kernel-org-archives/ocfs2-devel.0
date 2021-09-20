Return-Path: <SRS0=pBtb=OK=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26B58C433F5
	for <ocfs2-devel@archiver.kernel.org>; Mon, 20 Sep 2021 15:39:50 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9639161163
	for <ocfs2-devel@archiver.kernel.org>; Mon, 20 Sep 2021 15:39:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9639161163
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KEucX9023310;
	Mon, 20 Sep 2021 15:39:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : date :
 message-id : references : in-reply-to : content-id : mime-version : cc :
 subject : list-id : list-unsubscribe : list-archive : list-post :
 list-help : list-subscribe : content-type : content-transfer-encoding :
 sender; s=corp-2021-07-09;
 bh=NvgKa6gsTIeSNhNZRPEnT2fiBQBoRt3+TlnKsf3LYdY=;
 b=rAjjL28wb7sac27eW4tvrwyMOsEmsUar2LTAzIQ1wxZQ12Ti89NH/Dli8kM1pe+MhvHr
 gmENdiUd7RAuCrOMkYa/iN96NznnWzrCAGP0pce12TMwCWiptoWTR+pkuiAuSBJ4CQ6D
 X/w/N4SJgITJy5oL2UH8gYsO7oo5UMHFxiZy8km4FAEF4PmQ7X5UUXkn3uvNrDkQH/9P
 SsyPYdQFUuuxyjvRX4/f2jlGo0z3mAszDGJiXZBnJKbt21R5Z23NSyTnrHiktCxMYiTF
 DbkVVtDNXFrkkVKv6KXBgXOFZ8hqu7i38l6Mfi7Ufcv1e8e8KSCpSUQbp+sMkPBhyIna aQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3b66gn341v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Sep 2021 15:39:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18KFVlVk032615;
	Mon, 20 Sep 2021 15:39:46 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3b557vqdnx-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 20 Sep 2021 15:39:46 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mSLLQ-0000UI-LU; Mon, 20 Sep 2021 08:36:36 -0700
Received: from aserp3020.oracle.com ([141.146.126.70])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <wen.gang.wang@oracle.com>) id 1mSLKx-0000TM-Le
	for ocfs2-devel@oss.oracle.com; Mon, 20 Sep 2021 08:36:07 -0700
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	18KFV0ai106943
	for <ocfs2-devel@oss.oracle.com>; Mon, 20 Sep 2021 15:36:07 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com
	(mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
	by aserp3020.oracle.com with ESMTP id 3b57x46vqb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 20 Sep 2021 15:36:07 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
	by SN6PR10MB3455.namprd10.prod.outlook.com (2603:10b6:805:cd::23)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14;
	Mon, 20 Sep 2021 15:36:04 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
	([fe80::64da:7ae6:af82:ebfe]) by
	SN6PR10MB2701.namprd10.prod.outlook.com
	([fe80::64da:7ae6:af82:ebfe%5]) with mapi id 15.20.4523.018;
	Mon, 20 Sep 2021 15:36:04 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Thread-Topic: [Ocfs2-devel] [PATCH] ocfs2: drop acl cache for directories too
Thread-Index: AQHXoGLGs1pAWXC/V0ihKWBTAq2JU6uW59WAgBGehgCAAKbDAIAD/IyA
Date: Mon, 20 Sep 2021 15:36:04 +0000
Message-ID: <51F22A71-1491-45F5-AFFC-F838839CFBE7@oracle.com>
References: <20210903012631.6099-1-wen.gang.wang@oracle.com>
	<9e8cbfe1-527f-0e75-ba9b-8bcea674645d@linux.alibaba.com>
	<85B74B11-37F6-4FA1-A072-515DF41AE29A@oracle.com>
	<5538daf4-2563-c529-a6ee-8431094187fc@linux.alibaba.com>
In-Reply-To: <5538daf4-2563-c529-a6ee-8431094187fc@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: linux.alibaba.com; dkim=none (message not signed)
	header.d=none;linux.alibaba.com; dmarc=none action=none
	header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4eb1e6e4-eabe-411a-198f-08d97c4c5b68
x-ms-traffictypediagnostic: SN6PR10MB3455:
x-ms-exchange-transport-forked: True
x-oracle-tenancy: 1
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NgW3zrGaaS9B6+Wf7A6+zQA1unoV+14BJXZzweUPTs4Zy/6GM9X4vpQoUiS6QHQPRr/zfRU4mDw9YZpAIRfFaJaDapUdSvlaT6SjJcPVHYGR/3imtqIu+woBfo+b4oxda3DiSSj+jabITj0oSraRmoAxLu8BpYVTI2VymWCS7T694XU58QkCmve8orokyQesX5yhwHIbf9q6qEwunZ94exriFfWxaEI92R2sblIDQ72XgmsCsAxLskQAITZuof/WtJ/FWWczHKlffe0XYfF/hwftcSGAwEuf4SsLibZ0ZtmtIGbHMLikO0dan/+pmZhn/nm39JgJrSFr4EHMYKPm85ml5PZASFfQOM5l1AhUYrrSV456wksSzBOFLw0iOFkNn1BJi9dwMgbrpeC+QF+TcWyW0y62L3FBg7OyqdVuooGI7Y/qM+hlrpz3gOIaW0ZsgKL+sOqpntkgsGiW0i1gFyv47Il9M74akI/SUPU6OnknTgS/lKASGdH/ehlnhtaS8wF8jjoxheCNv4GDMgFzl7/wDiNK+OCgN2n9bKCoFxbbIorHN5nmdjDgnkYmkCqUC398rajETu17G3iDC5ANOEonN1qafAH4p69+5J7bZ/I=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:SN6PR10MB2701.namprd10.prod.outlook.com; PTR:; CAT:NONE; SFS:;
	DIR:INB; 
Content-ID: <323BE20DD65E284E92D60CD110390FD8@namprd10.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4eb1e6e4-eabe-411a-198f-08d97c4c5b68
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2021 15:36:04.1753 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MQeR4krLk0M7oFMPepHH6WGEuICm19FnOnhfOw2wPxCi5R4QY6dkmNBp3LdzB2Gvfwfd2FoIIvLA6xWovevrLq3FT/7iz5nVXaNOzeMEvWA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3455
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 04
X-MS-Exchange-CrossPremises-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-SCL: -1
X-MS-Exchange-CrossPremises-messagesource: StoreDriver
X-MS-Exchange-CrossPremises-BCC: 
X-MS-Exchange-CrossPremises-originalclientipaddress: 2606:b400:8301:1010::16aa
X-MS-Exchange-CrossPremises-transporttraffictype: Email
X-MS-Exchange-CrossPremises-antispam-scancontext: DIR:Originating; SFV:SKI;
	SKIP:0; 
X-MS-Exchange-CrossPremises-processed-by-journaling: Journal Agent
X-OrganizationHeadersPreserved: SN6PR10MB3455.namprd10.prod.outlook.com
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10113
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	mlxscore=0 adultscore=0
	phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109030001 definitions=main-2109200099
Cc: ocfs2-devel ML <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: drop acl cache for directories too
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10113 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 spamscore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109200099
X-Proofpoint-GUID: n0Z-d2CGtlj0o-8IfIuIMbJ28qihHNLF
X-Proofpoint-ORIG-GUID: n0Z-d2CGtlj0o-8IfIuIMbJ28qihHNLF

DQoNCj4gT24gU2VwIDE3LCAyMDIxLCBhdCA3OjQzIFBNLCBKb3NlcGggUWkgPGpvc2VwaC5xaUBs
aW51eC5hbGliYWJhLmNvbT4gd3JvdGU6DQo+IA0KPiBJdCBoYXMgYWxyZWFkeSBiZWVuIGFkZGVk
IGluIC1tbSB0cmVlLg0KDQp0aGFua3MhDQp3ZW5nYW5nDQoNCj4gDQo+IFRoYW5rcywNCj4gSm9z
ZXBoDQo+IA0KPiBPbiA5LzE4LzIxIDEyOjQ2IEFNLCBXZW5nYW5nIFdhbmcgd3JvdGU6DQo+PiBI
aSBBbmRyZXcsDQo+PiANCj4+IENhbiB5b3UgcGxzIG1lcmdlIHRoaXMgcGF0Y2ggaWYgaXTigJlz
IG5vdCBhbHJlYWR5IG9uIHRoZSB3YXk/DQo+PiANCj4+IHRoYW5rcywNCj4+IHdlbmdhbmcNCj4+
IA0KPj4gT24gU2VwIDYsIDIwMjEsIGF0IDQ6NDIgQU0sIEpvc2VwaCBRaSA8am9zZXBoLnFpQGxp
bnV4LmFsaWJhYmEuY29tPG1haWx0bzpqb3NlcGgucWlAbGludXguYWxpYmFiYS5jb20+PiB3cm90
ZToNCj4+IA0KPj4gDQo+PiANCj4+IE9uIDkvMy8yMSA5OjI2IEFNLCBXZW5nYW5nIFdhbmcgd3Jv
dGU6DQo+PiBvY2ZzMl9kYXRhX2NvbnZlcnRfd29ya2VyKCkgaXMgY3VycmVudGx5IGRyb3BwaW5n
IGFueSBjYWNoZWQgYWNsIGluZm8NCj4+IGZvciBGSUxFIGJlZm9yZSBkb3duLWNvbnZlcnRpbmcg
bWV0YSBsb2NrLiBJdCBzaG91bGQgYWxzbyBkcm9wIGZvciBESVJFQ1RPUlkuDQo+PiBPdGhlcndp
c2UgdGhlIHNlY29uZCBhY2wgbG9va3VwIHJldHVybnMgdGhlIGNhY2hlZCBvbmUgKGZyb20gVkZT
IGxheWVyKSB3aGljaA0KPj4gY291bGQgYmUgYWxyZWFkeSBzdGFsZS4NCj4+IA0KPj4gVGhlIHBy
b2JsZW0gd2UgYXJlIHNlZWluZyBpcyB0aGF0IHRoZSBhY2wgY2hhbmdlcyBvbiBvbmUgbm9kZSBk
b2Vzbid0IGdldA0KPj4gcmVmcmVzaGVkIG9uIG90aGVyIG5vZGVzIGluIHRoZSBmb2xsb3dpbmcg
Y2FzZToNCj4+IA0KPj4gTm9kZSAxICAgICAgICAgICAgICAgICAgICBOb2RlIDINCj4+IC0tLS0t
LS0tLS0tLS0tICAgICAgICAgICAgLS0tLS0tLS0tLS0tLS0tLQ0KPj4gZ2V0ZmFjbCBkaXIxDQo+
PiANCj4+ICBnZXRmYWNsIGRpcjEgICAgPC0tIHRoaXMgaXMgT0sNCj4+IA0KPj4gc2V0ZmFjbCAt
bSB1OnVzZXIxOnJ3WCBkaXIxDQo+PiBnZXRmYWNsIGRpcjEgICA8LS0gc2VlIHRoZSBjaGFuZ2Ug
Zm9yIHVzZXIxDQo+PiANCj4+ICBnZXRmYWNsIGRpcjEgICAgPC0tIGNhbid0IHNlZSBjaGFuZ2Ug
Zm9yIHVzZXIxDQo+PiANCj4+IFNpZ25lZC1vZmYtYnk6IFdlbmdhbmcgV2FuZyA8d2VuLmdhbmcu
d2FuZ0BvcmFjbGUuY29tPG1haWx0bzp3ZW4uZ2FuZy53YW5nQG9yYWNsZS5jb20+Pg0KPj4gDQo+
PiBMb29rcyBzYW5lIHRvIG1lLg0KPj4gUmV2aWV3ZWQtYnk6IEpvc2VwaCBRaSA8am9zZXBoLnFp
QGxpbnV4LmFsaWJhYmEuY29tPG1haWx0bzpqb3NlcGgucWlAbGludXguYWxpYmFiYS5jb20+Pg0K
Pj4gDQo+PiAtLS0NCj4+IGZzL29jZnMyL2RsbWdsdWUuYyB8IDMgKystDQo+PiAxIGZpbGUgY2hh
bmdlZCwgMiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+PiANCj4+IGRpZmYgLS1naXQg
YS9mcy9vY2ZzMi9kbG1nbHVlLmMgYi9mcy9vY2ZzMi9kbG1nbHVlLmMNCj4+IGluZGV4IDUwYTg2
M2ZjMTc3OS4uMjA3ZWM2MTU2OWVhIDEwMDY0NA0KPj4gLS0tIGEvZnMvb2NmczIvZGxtZ2x1ZS5j
DQo+PiArKysgYi9mcy9vY2ZzMi9kbG1nbHVlLmMNCj4+IEBAIC0zOTMzLDcgKzM5MzMsNyBAQCBz
dGF0aWMgaW50IG9jZnMyX2RhdGFfY29udmVydF93b3JrZXIoc3RydWN0IG9jZnMyX2xvY2tfcmVz
ICpsb2NrcmVzLA0KPj4gb2kgPSBPQ0ZTMl9JKGlub2RlKTsNCj4+IG9pLT5pcF9kaXJfbG9ja19n
ZW4rKzsNCj4+IG1sb2coMCwgImdlbmVyYXRpb246ICV1XG4iLCBvaS0+aXBfZGlyX2xvY2tfZ2Vu
KTsNCj4+IC0gZ290byBvdXQ7DQo+PiArIGdvdG8gb3V0X2ZvcmdldDsNCj4+IH0NCj4+IA0KPj4g
aWYgKCFTX0lTUkVHKGlub2RlLT5pX21vZGUpKQ0KPj4gQEAgLTM5NjQsNiArMzk2NCw3IEBAIHN0
YXRpYyBpbnQgb2NmczJfZGF0YV9jb252ZXJ0X3dvcmtlcihzdHJ1Y3Qgb2NmczJfbG9ja19yZXMg
KmxvY2tyZXMsDQo+PiBmaWxlbWFwX2ZkYXRhd2FpdChtYXBwaW5nKTsNCj4+IH0NCj4+IA0KPj4g
K291dF9mb3JnZXQ6DQo+PiBmb3JnZXRfYWxsX2NhY2hlZF9hY2xzKGlub2RlKTsNCj4+IA0KPj4g
b3V0Og0KPj4gDQoNCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fCk9jZnMyLWRldmVsIG1haWxpbmcgbGlzdApPY2ZzMi1kZXZlbEBvc3Mub3JhY2xlLmNvbQpo
dHRwczovL29zcy5vcmFjbGUuY29tL21haWxtYW4vbGlzdGluZm8vb2NmczItZGV2ZWw=
