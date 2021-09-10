Return-Path: <SRS0=6dL3=OA=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13963C433F5
	for <ocfs2-devel@archiver.kernel.org>; Fri, 10 Sep 2021 17:04:54 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C1B56611B0
	for <ocfs2-devel@archiver.kernel.org>; Fri, 10 Sep 2021 17:04:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C1B56611B0
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18AGu0Y9002711;
	Fri, 10 Sep 2021 17:04:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : date :
 message-id : references : in-reply-to : content-id : mime-version : cc :
 subject : list-id : list-unsubscribe : list-archive : list-post :
 list-help : list-subscribe : content-type : content-transfer-encoding :
 sender; s=corp-2021-07-09;
 bh=02Fx851cb6hyKKcfHg03nOsgiedeoep1HaEbbBHsYco=;
 b=kmo1psIC8J9GRmXvApYzgR3cyhubWsMuBZppA1Ml82VYPSgUGxiWYx6IRU7smMrMdf51
 W+oRImcVF6Q7cnCqsyk3hjzlRnhejPmWZRgEGwFhRdLKPMzLskRINW4WxJyRDX7TmMrO
 n6P4wK3cMbwWoikUH+VN5Netqv6Hz7BMaE9pSV/dMbdXjNZ3sNryOfR41FkEkTcfE/os
 /oPWWUMvg6GA7CgvORVy5PfaYxyoey3q8D3PdH7LonGI/NsXQ+GAVdjO56vIqu0Eg+IX
 q8kPvLVYcnpWsFpM5T6X8EYk1FhOHd+0/MMYR7O2/NAwcw3xdaHp0HFXySjARRQxtOFq Qw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : date :
 message-id : references : in-reply-to : content-id : mime-version : cc :
 subject : list-id : list-unsubscribe : list-archive : list-post :
 list-help : list-subscribe : content-type : content-transfer-encoding :
 sender; s=corp-2020-01-29;
 bh=02Fx851cb6hyKKcfHg03nOsgiedeoep1HaEbbBHsYco=;
 b=AUBWJ+8Ql77SYmOa+kz0c+mhhsarYy1IAHUZo4im4tcN4BwINYeB6F4uZhaaOhxZpKau
 sTSzIgH4jV2FdtPGcDTdBcD0STvs4scVDca+rwEgvZGC+M3oMakvQjB/BQO3zyS9T7LN
 qoxiyfo73s7TO5mbZ6O0iQUS51r4inWlknYJsO0g2qXgEL10d/0el12rSEsE5p/WzH4+
 YEDF35U9UVDuKlcOdI5sbsCoRiDYCzqS8/wuT4QSSJjDzKikTWcEECktyweUf/a4RY5u
 xrpttg8pcjmBjLfvUWrZo+gxz/1bsKdgjke9E9+aMOI5oP1pZUNanVCPcukD0jp7QfFA og== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3aytx4thvu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Sep 2021 17:04:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18AH0xZR152564;
	Fri, 10 Sep 2021 17:04:51 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 3aytfu5q99-1;
	Fri, 10 Sep 2021 17:04:51 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mOjuH-0001uZ-MV; Fri, 10 Sep 2021 10:01:41 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <wen.gang.wang@oracle.com>) id 1mOjth-0001tO-Fo
	for ocfs2-devel@oss.oracle.com; Fri, 10 Sep 2021 10:01:05 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	18AH0x1c152573
	for <ocfs2-devel@oss.oracle.com>; Fri, 10 Sep 2021 17:01:05 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com
	(mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by userp3030.oracle.com with ESMTP id 3aytfu5jsn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Fri, 10 Sep 2021 17:01:03 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
	by SA2PR10MB4604.namprd10.prod.outlook.com (2603:10b6:806:11c::22)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16;
	Fri, 10 Sep 2021 17:00:47 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
	([fe80::64da:7ae6:af82:ebfe]) by
	SN6PR10MB2701.namprd10.prod.outlook.com
	([fe80::64da:7ae6:af82:ebfe%5]) with mapi id 15.20.4500.018;
	Fri, 10 Sep 2021 17:00:47 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Thread-Topic: [Ocfs2-devel] [PATCH v2] ocfs2: Fix handle refcount leak in two
	exception handling paths
Thread-Index: AQHXpJ+H0ttR42xfTUiCjMce85OD7KuaYEsAgAEsHACAAHAfAIAAh6mAgAD9XQA=
Date: Fri, 10 Sep 2021 17:00:47 +0000
Message-ID: <70C24A61-6E9C-43D8-BB43-1D56A8081E19@oracle.com>
References: <20210908102055.10168-1-cymi20@fudan.edu.cn>
	<06d9e055-29b9-731c-5a36-d888f2c83188@linux.alibaba.com>
	<6018AF95-3613-4D43-A3E6-7BAA0E0BE009@oracle.com>
	<c48fb54e-0dd9-42c7-f53d-2ea58fb97255@linux.alibaba.com>
	<CED0D2AD-7905-490E-8D36-50D192CD9BF1@oracle.com>
	<ee86ea1a-0348-e975-3c67-8d574eaadbe3@linux.alibaba.com>
In-Reply-To: <ee86ea1a-0348-e975-3c67-8d574eaadbe3@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: linux.alibaba.com; dkim=none (message not signed)
	header.d=none;linux.alibaba.com; dmarc=none action=none
	header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 100d97de-cee3-4469-f059-08d9747c8945
x-ms-traffictypediagnostic: SA2PR10MB4604:
x-ms-exchange-transport-forked: True
x-oracle-tenancy: 1
x-ms-oob-tlc-oobclassifiers: OLM:949;
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ivhQYoQzS3TZxBjD1su/HnHdRNiRVcJHP+8zNW00GbBe+8rER+4rzamFRvFeEvp9qJVj+8G5xCfKH+DIvbAEagR2ZJrRKvHd4MeZeQFAHHDwN5Fbnx7KaR3ONOx7ou2kZlyp9Jg4x2lDqgZUrKi6+tT6pY3y80Qdy6suMh+KCwz5xxnm54mWTLNkA0xez4hkl3NA4EAqthXayE9E1S6ck4QW754NC2nsN8fIJ0/cUMgEyKtU7Sh6XBmhfxd5MlXRrf9HdkgWN21FkjBYgqjduNaSvQFy3fLESqrHLCUlf1eh+atBh7vBED1YdSNAhdn4tMXIAHIzqoZ72jiC3JT5c5RxkuTRso2MRI4qT3MdqCs/v+1JTDAqoEZGAWI5ArB72JJQ0UKpGbSdxh9sU/zeyLy5aC4kjxG+OnTi5VRnjjOXkPgpcR5xjDFGDQIMM3tPMj8bXjIdlmuGxIbukZRkIpNrEl0+GH4w4F7aXsGR3RbheSV0TQJv3oq8mMhyGr49NmppePu+VBpszqf4jridEGxS5MEqmPzp2/zNSjrTsAwabHEMgCeaFDkFEQy/eZvFavotyncfO/i8H85BBuRIcfE9uhsLelinYYl/Nn0kjkw=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:SN6PR10MB2701.namprd10.prod.outlook.com; PTR:; CAT:NONE; SFS:;
	DIR:INB; 
Content-ID: <8E1267F022600B439DD03BDDA99E2273@namprd10.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 100d97de-cee3-4469-f059-08d9747c8945
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2021 17:00:47.6215 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tileHCFlJ3JnXUnSxkuqGzDz7lua/G0EcScwW5qjWmgvs0M7Hon71b1NtCnJfbc9NLbx3XAG+V59N/zrhjnM92CW1bBhFl/tsMtmjBFoFDI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4604
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
X-OrganizationHeadersPreserved: SA2PR10MB4604.namprd10.prod.outlook.com
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10103
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
	bulkscore=0 phishscore=0
	spamscore=0 malwarescore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2109030001 definitions=main-2109100099
Cc: Chenyuan Mi <cymi20@fudan.edu.cn>, Xin Tan <tanxin.ctf@gmail.com>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        "yuanxzhang@fudan.edu.cn" <yuanxzhang@fudan.edu.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH v2] ocfs2: Fix handle refcount leak in two
 exception handling paths
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
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10103 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 spamscore=0 malwarescore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109100099
X-Proofpoint-ORIG-GUID: pCFnpCoQ1ugJlUQnkr51uyVDwmCGanY3
X-Proofpoint-GUID: pCFnpCoQ1ugJlUQnkr51uyVDwmCGanY3

DQoNCj4gT24gU2VwIDksIDIwMjEsIGF0IDY6NTMgUE0sIEpvc2VwaCBRaSA8am9zZXBoLnFpQGxp
bnV4LmFsaWJhYmEuY29tPiB3cm90ZToNCj4gDQo+IA0KPiANCj4gT24gOS8xMC8yMSAxOjQ4IEFN
LCBXZW5nYW5nIFdhbmcgd3JvdGU6DQo+PiANCj4+IA0KPj4gT24gU2VwIDksIDIwMjEsIGF0IDQ6
MDcgQU0sIEpvc2VwaCBRaSA8am9zZXBoLnFpQGxpbnV4LmFsaWJhYmEuY29tPG1haWx0bzpqb3Nl
cGgucWlAbGludXguYWxpYmFiYS5jb20+PiB3cm90ZToNCj4+IA0KPj4gSGkgV2VuZ2FuZywNCj4+
IA0KPj4gT24gOS85LzIxIDE6MTIgQU0sIFdlbmdhbmcgV2FuZyB3cm90ZToNCj4+IEhpLA0KPj4g
DQo+PiBTb3JyeSBmb3IgbGF0ZSBpbnZvbHZpbmcsIGJ1dCB0aGlzIGRvZXNu4oCZdCBsb29rIHJp
Z2h0IHRvIG1lLg0KPj4gDQo+PiBPbiBTZXAgOCwgMjAyMSwgYXQgMzo1MSBBTSwgSm9zZXBoIFFp
IDxqb3NlcGgucWlAbGludXguYWxpYmFiYS5jb208bWFpbHRvOmpvc2VwaC5xaUBsaW51eC5hbGli
YWJhLmNvbT4+IHdyb3RlOg0KPj4gDQo+PiANCj4+IA0KPj4gT24gOS84LzIxIDY6MjAgUE0sIENo
ZW55dWFuIE1pIHdyb3RlOg0KPj4gVGhlIHJlZmVyZW5jZSBjb3VudGluZyBpc3N1ZSBoYXBwZW5z
IGluIHR3byBleGNlcHRpb24gaGFuZGxpbmcgcGF0aHMNCj4+IG9mIG9jZnMyX3JlcGxheV90cnVu
Y2F0ZV9yZWNvcmRzKCkuIFdoZW4gZXhlY3V0aW5nIHRoZXNlIHR3byBleGNlcHRpb24NCj4+IGhh
bmRsaW5nIHBhdGhzLCB0aGUgZnVuY3Rpb24gZm9yZ2V0cyB0byBkZWNyZWFzZSB0aGUgcmVmY291
bnQgb2YgaGFuZGxlDQo+PiBpbmNyZWFzZWQgYnkgb2NmczJfc3RhcnRfdHJhbnMoKSwgY2F1c2lu
ZyBhIHJlZmNvdW50IGxlYWsuDQo+PiANCj4+IEZpeCB0aGlzIGlzc3VlIGJ5IHVzaW5nIG9jZnMy
X2NvbW1pdF90cmFucygpIHRvIGRlY3JlYXNlIHRoZSByZWZjb3VudA0KPj4gb2YgaGFuZGxlIGlu
IHR3byBoYW5kbGluZyBwYXRocy4NCj4+IA0KPj4gU2lnbmVkLW9mZi1ieTogQ2hlbnl1YW4gTWkg
PGN5bWkyMEBmdWRhbi5lZHUuY248bWFpbHRvOmN5bWkyMEBmdWRhbi5lZHUuY24+Pg0KPj4gU2ln
bmVkLW9mZi1ieTogWGl5dSBZYW5nIDx4aXl1eWFuZzE5QGZ1ZGFuLmVkdS5jbjxtYWlsdG86eGl5
dXlhbmcxOUBmdWRhbi5lZHUuY24+Pg0KPj4gU2lnbmVkLW9mZi1ieTogWGluIFRhbiA8dGFueGlu
LmN0ZkBnbWFpbC5jb208bWFpbHRvOnRhbnhpbi5jdGZAZ21haWwuY29tPj4NCj4+IA0KPj4gUmV2
aWV3ZWQtYnk6IEpvc2VwaCBRaSA8am9zZXBoLnFpQGxpbnV4LmFsaWJhYmEuY29tPG1haWx0bzpq
b3NlcGgucWlAbGludXguYWxpYmFiYS5jb20+Pg0KPj4gLS0tDQo+PiBmcy9vY2ZzMi9hbGxvYy5j
IHwgMiArKw0KPj4gMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKQ0KPj4gDQo+PiBkaWZm
IC0tZ2l0IGEvZnMvb2NmczIvYWxsb2MuYyBiL2ZzL29jZnMyL2FsbG9jLmMNCj4+IGluZGV4IGYx
Y2M4MjU4ZDM0YS4uYjA1ZmRlN2VkYzNhIDEwMDY0NA0KPj4gLS0tIGEvZnMvb2NmczIvYWxsb2Mu
Yw0KPj4gKysrIGIvZnMvb2NmczIvYWxsb2MuYw0KPj4gQEAgLTU5NDAsNiArNTk0MCw3IEBAIHN0
YXRpYyBpbnQgb2NmczJfcmVwbGF5X3RydW5jYXRlX3JlY29yZHMoc3RydWN0IG9jZnMyX3N1cGVy
ICpvc2IsDQo+PiBzdGF0dXMgPSBvY2ZzMl9qb3VybmFsX2FjY2Vzc19kaShoYW5kbGUsIElOT0RF
X0NBQ0hFKHRsX2lub2RlKSwgdGxfYmgsDQo+PiBPQ0ZTMl9KT1VSTkFMX0FDQ0VTU19XUklURSk7
DQo+PiBpZiAoc3RhdHVzIDwgMCkgew0KPj4gKyBvY2ZzMl9jb21taXRfdHJhbnMob3NiLCBoYW5k
bGUpOw0KPj4gbWxvZ19lcnJubyhzdGF0dXMpOw0KPj4gZ290byBiYWlsOw0KPj4gfQ0KPj4gQEAg
LTU5NjQsNiArNTk2NSw3IEBAIHN0YXRpYyBpbnQgb2NmczJfcmVwbGF5X3RydW5jYXRlX3JlY29y
ZHMoc3RydWN0IG9jZnMyX3N1cGVyICpvc2IsDQo+PiAgICAgZGF0YV9hbGxvY19iaCwgc3RhcnRf
YmxrLA0KPj4gICAgIG51bV9jbHVzdGVycyk7DQo+PiBpZiAoc3RhdHVzIDwgMCkgew0KPj4gKyBv
Y2ZzMl9jb21taXRfdHJhbnMob3NiLCBoYW5kbGUpOw0KPj4gDQo+PiBBcyBhIHRyYW5zYWN0aW9u
LCBzdHVmZiBleHBlY3RlZCB0byBiZSBpbiB0aGUgc2FtZSBoYW5kbGUgc2hvdWxkIGJlIHRyZWF0
ZWQgYXMgYXRvbWljLg0KPj4gSGVyZSB0aGUgc3R1ZmYgaW5jbHVkZXMgdGhlIHRsX2JoIGFuZCBv
dGhlciBtZXRhZGF0YSBibG9jayB3aGljaCB3aWxsIGJlIG1vZGlmaWVkIGluIG9jZnMyX2ZyZWVf
Y2x1c3RlcnMoKS4NCj4+IENvbWluZyBoZXJlLCBzb21lIG9mIHJlbGF0ZWQgbWV0YSBibG9ja3Mg
bWF5IGJlIGluIHRoZSBoYW5kbGUgYnV0IG90aGVycyBhcmUgbm90IGR1ZSB0byB0aGUgZXJyb3Ig
aGFwcGVuZWQuDQo+PiBJZiB5b3UgZG8gYSBjb21taXQsIHBhcnRpYWwgbWV0YSBibG9ja3MgYXJl
IGNvbW1pdHRlZCB0byBsb2cuIOKAlCB0aGF0IGJyZWFrcyB0aGUgYXRvbWljIGlkZWEsIGl0IHdp
bGwgY2F1c2UgRlMgaW5jb25zaXN0ZW5jeS4NCj4+IFNvIHdoYXTigJlzIHJlYXNvbiB5b3Ugd2Fu
dCB0byBjb21taXQgdGhlIG1ldGEgYmxvY2sgY2hhbmdlcywgd2hpY2ggaXMgbm90IGFsbCBvZiBl
eHBlY3RlZCwgaW4gdGhpcyBoYW5kbGUgdG8gam91cm5hbCBsb2c/DQo+PiANCj4+IERvIHlvdSBy
ZWFsbHkgc2VlIGEgaGl0IG9uIHRoZSBmYWlsdXJlPyBvciBqdXN0IHlvdSBkZXRlY3RlZCB0aGUg
cmVmY291bnQgbGVhayBieSBjb2RlIHJldmlldz8NCj4+IA0KPj4gWW91IG1heSB3YW50IHRvIGxv
b2sgYXQgb2NmczJfam91cm5hbF9kaXJ0eSgpIGZvciB0aGUgZXJyb3IgaGFuZGxpbmcgcGFydC4N
Cj4+IA0KPj4gDQo+PiBGb3IgdGhlIGZpcnN0IGVycm9yIGhhbmRsaW5nLCBzaW5jZSB3ZSBkb24n
dCBjYWxsIG9jZnMyX2pvdXJuYWxfZGlydHkoKQ0KPj4geWV0LCBzbyB3b24ndCBiZSBhIHByb2Js
ZW0uDQo+PiBGb3IgdGhlIHNlY29uZCBlcnJvciBoYW5kbGluZywgSSB0aGluayB3ZSBkb24ndCBo
YXZlIGEgYmV0dGVyIHdheS4gTG9vaw0KPj4gYXQgb3RoZXIgY2FsbGVycyBvZiBvY2ZzMl9mcmVl
X2NsdXN0ZXJzKCksIHdlIHNpbXBseSBpZ25vcmUgdGhlIGVycm9yDQo+PiBjb2RlLg0KPj4gQW55
d2F5LCB3ZSBzaG91bGQgY29tbWl0IHRyYW5zYWN0aW9uIGlmIHN0YXJ0cywgb3RoZXJ3aXNlIGpv
dXJuYWwgd2lsbA0KPj4gYmUgYWJub3JtYWwuDQo+PiANCj4+IEkgZG9uJ3QgdGhpbmsgc28uIElm
IGVycm9yIGhhcHBlbmVkLCB3ZSBzaG91bGQgZmFpbCBvY2ZzMiwgcmF0aGVyIHRoYW4gZG8gYSBw
YXJ0aWFsIGNvbW1pdHRpbmcuDQo+PiANCj4gDQo+IFVtbS4uLiBub3QgZXhhY3RseS4uLg0KPiBU
YWtlIG9jZnMyX2ZyZWVfY2x1c3RlcnMoKSBmb3IgZXhhbXBsZSwgd2hlbiBpdCBmYWlscyBpbiBj
YXNlIG9mIEVJTyBvcg0KPiBFTk9NRU0sIHdlIGNhbid0IGp1c3QgYWJvcnQgam91cm5hbCBpbiBz
dWNoIGNhc2VzLCBiZWNhdXNlIGl0IGlzIG5vdCBzbw0KPiBzZXJpb3VzLCBvbmx5IGEgYml0IGJs
b2NrcyBzdGlsbCBvY2N1cGllZCBhbmQgdGhleSB3aWxsIHJlY292ZXJ5IGR1cmluZw0KPiB0aGUg
bmV4dCBtb3VudC4gDQoNClNvIGFyZSB5b3Ugc3VyZSBhIHBhcnRpYWwgam91cm5hbCBjb21taXRt
ZW50IHdvbuKAmXQgY2F1c2UgRlMgaW5jb25zaXN0ZW5jeT8gYW55IHByb29mIGZvciB0aGF0Pw0K
UHJvYmxlbSBpcyBub3QganVzdCBpZiB3ZSBjYW4gdHJ5IHRvIGZyZWUgdGhlIGJsb2NrcyBhZ2Fp
biBvciBub3QuIFRoZSBwcm9ibGVtIGlzIEZTIGluIGluY29uc2lzdGVudCBzdGF0ZS4NCg0KSSBk
aWRu4oCZdCBsb29rIGludG8gb2NmczJfZnJlZV9jbHVzdGVycygpIGZ1cnRoZXIsIGJ1dCBjYW4g
aW1hZ2UgdGhpcyBjYXNlOg0KDQoxKSBXZSBhcmUgZ29pbmcgdG8gZnJlZSBzb21lIGNsdXN0ZXJz
L2Jsb2Nrcy4gDQoyKSBXZSBtYXkgbmVlZCBhIG5ldyAobm90IG1lcmdpbmcgaW50byBleGlzdGlu
ZykgcmVjb3JkIHRvIHJlbWVtYmVyIHRoZSBuZXcgZnJlZSBleHRlbnQuIA0KMykgVGhlIG5ldyBy
ZWNvcmQgbmVlZHMgdG8gYmUgaW5zZXJ0ZWQgaW50byBmcmVlIGV4dGVudCB0cmVlLg0KNCkgdGhl
IGJsb2NrIChibG9jayBBKSB3aGVyZSB0aGUgbmV3IHJlY29yZCB0byBiZSBpbnNlcnRlZCBjb3Vs
ZCBiZSBhbHJlYWR5IGZ1bGwgdGh1cyBubyBzcGFjZSBmb3IgdGhlIG5ldyByZWNvcmQuDQo1KSB0
aGVuIHdlIG5lZWQgYXQgbGVhc3QgYSBuZXcgYmxvY2sgKGJsb2NrIEIpIHRvIHN0b3JlIHRoZSBu
ZXcgcmVjb3JkLiAodG8gbWFpbnRhaW4gdGhlIGZyZWUgYmxvY2sgYnRyZWUsIG1heWJlIGFub3Ro
ZXIgYmxvY2ssIGJsb2NrIEMgaXMgbmVlZGVkIHRvbykuDQo2KSBTbyB3ZSBuZWVkIHRvIHNhdmUg
dGhlIHBvaW50ZXIgKGJsb2NrIG51bWJlcikgb2YgYmxvY2sgQiBpbiBibG9jayBBIGFuZCBzdG9y
ZSB0aGUgbmV3IHJlY29yZCBpbiBibG9jayBCLg0KNykgSW4gdGhpcyBjYXNlIHdlIG5lZWQgdG8g
bWFrZSBzdXJlIGJsb2NrIEEgYW5kIGJsb2NrIEIgZWl0aGVyIGJvdGggaW4gam91cm5hbCBsb2cs
IG9yIG5vbmUgb2YgdGhlbSBpbiBqb3VybmFsIGxvZy4gIFdlIGRvbuKAmXQgYWxsb3cgYmxvY2sg
QSBpcyBpbiBqb3VybmFsIGJvdCBibG9jayBCIGlzIG5vdCwgcmlnaHQ/DQoNCmdvIGJhY2sgdG8g
cXVlc3Rpb24sICAgRXJyb3IgY291bGQgYWZ0ZXIgYmxvY2sgQiBpcyBhZGRlZCB0byBqb3VybmFs
IGhhbmRsZSBidXQgYmVmb3JlIGJsb2NrIEEgaXMgYWRkZWQuIEluIGNhc2Ugd2UgZG8gYSBqb3Vy
bmFsIGNvbW1pdCB3aGVuIGhpdHRpbmcgdGhhdCBlcnJvciwgd2UgYXJlIGNvbW1pdHRpbmcgYmxv
Y2sgQiB0byBqb3VybmFsIGJ1dCBsZWF2aW5nIGJsb2NrIEEgbm90IGluLg0KSWYgcGFuaWMgaGFw
cGVuZWQsIGJsb2NrIEEgY291bGQgbmV2ZXIgaGFzIHRoZSBwb2ludGVyIHBvaW50aW5nIHRvIGJs
b2NrIEIuIFRoZSByZXN1bHQgaXMgYmxvY2sgQiBpcyBwZXJtYW5lbnRseSBsb3N0ICh3ZSBjYW4g
bmV2ZXIgcmV1c2UgdGhpcyBibG9jayBhZ2FpbikuIA0KT3IgaWYgd2UgYWRkIGJsb2NrIEEgdG8g
am91cm5hbCBmaXJzdCBiZWZvcmUgYWRkaW5nIGJsb2NrIEIgYW5kIGVycm9yIGhhcHBlbnMgQWZ0
ZXIgYmxvY2sgQSBpcyBhZGRlZCBhbmQgYmVmb3JlIGJsb2NrIEIgaXMgYWRkZWQuICBUaGVuIHdl
IGhhdmUgdGhlIHBvaW50ZXIgcG9pbnRpbmcgdG8gYmxvY2sgQiBpbiBibG9jayBBIGFmdGVyIHBh
bmljLCBidXQgYmxvY2sgQiBkb2VzbuKAmXQgY29udGFpbiB2YWxpZCBjb250ZW50cy4gVGhlIHJl
c3VsdCBpcyB0aGF0IHdlIHdpbGwgaGl0IHByb2JsZW0gd2hlbiB2aXNpdGluZyBibG9jayBCIGFz
IGEgdmFsaWQgYnRyZWUgYmxvY2suDQoNCg0KPiBUaGF0J3Mgd2h5IHdlIGhhdmUgImVycm9ycz1j
b250aW51ZSIgaW4gbW9zdCBmaWxlc3lzdGVtcywgd2Ugc2hvdWxkIGFsd2F5cw0KPiBjb25zaWRl
ciB0aGUgYnVzaW5lc3MgY29udGludWl0eSBmaXJzdC4NCj4gQWxzbyB5b3UgY2FuIGxvb2sgYXQg
ZXh0NF9mcmVlX2Jsb2NrcygpIGZvciByZWZlcmVuY2UuDQoNCk9DRlMyIGRvZXNu4oCZdCBzdXBw
b3J0IEVSUk9SU19DT05ULCBvciB0byBzYXkgaXQganVzdCBpZ25vcmUgdGhhdCBvcHRpb24uICBO
byBtYXR0ZXIgRVJST1JTX0NPTlQgaXMgc3VwcG9ydGVkIG9yIG5vdCBieSBPQ0ZTMiwNClRoZSBr
ZXkgaXMgbm90IHRvIGxlYXZlIHRoZSBGUyBpbiBpbmNvbnNpc3RlbnQgc3RhdGUuDQoNCnRoYW5r
cywNCndlbmdhbmcNCg0KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18KT2NmczItZGV2ZWwgbWFpbGluZyBsaXN0Ck9jZnMyLWRldmVsQG9zcy5vcmFjbGUuY29t
Cmh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFpbG1hbi9saXN0aW5mby9vY2ZzMi1kZXZlbA==
