Return-Path: <SRS0=KptY=KF=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1025C433B4
	for <ocfs2-devel@archiver.kernel.org>; Mon, 10 May 2021 15:50:56 +0000 (UTC)
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6EB6061409
	for <ocfs2-devel@archiver.kernel.org>; Mon, 10 May 2021 15:50:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6EB6061409
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14AFnoQO087599;
	Mon, 10 May 2021 15:50:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : date :
 message-id : references : in-reply-to : content-id : mime-version : cc :
 subject : list-id : list-unsubscribe : list-archive : list-post :
 list-help : list-subscribe : content-type : content-transfer-encoding :
 sender; s=corp-2020-01-29;
 bh=PnFEVBBHYboNQFYJPQGdGg0q7au/oL/+sZalD+n2Zl4=;
 b=YeJXePEZA1pKb8VqMBG94sRtwR5s1gugtwv4GbQ9+QkUgQZPgQpoB9y+Vqvt1BK2r6KT
 BHo0PyGs7R6UwfRBYbutnEi/hxSJSWOX6Ld2YXeWHyFQyQ8jxgXDSagBwuj5rPowpGUZ
 lqJNb9T54RPwYFmH6VMkGjhYefTCQLLuPTyD8MBBk8hEG8YRzxthW+I1V8vvteFHL0Np
 4uRbcjgvJBXZQ2mwMkMcl6EnflvhQxO8iPXGMdJbdhkVIRC3b7wbP5PjBt7mFr9NpZ6T
 WBARJO3tK7Zcvak0VvLoYb60vOMNv2gR3qYIZw7rbmSwnFhPNFvhGPjbIHPTBP7f5Owi AQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by aserp2130.oracle.com with ESMTP id 38dg5bbuk1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 May 2021 15:50:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14AFVXZk102059;
	Mon, 10 May 2021 15:50:54 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3030.oracle.com with ESMTP id 38dfrvnaj3-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Mon, 10 May 2021 15:50:54 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1lg8BJ-0005wH-2F; Mon, 10 May 2021 08:50:53 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <wen.gang.wang@oracle.com>) id 1lg8BF-0005uu-UK
	for ocfs2-devel@oss.oracle.com; Mon, 10 May 2021 08:50:50 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14AFVXJ5102036
	for <ocfs2-devel@oss.oracle.com>; Mon, 10 May 2021 15:50:49 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com
	(mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
	by userp3030.oracle.com with ESMTP id 38dfrvnaep-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Mon, 10 May 2021 15:50:49 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20)
	by SN6PR10MB2766.namprd10.prod.outlook.com (2603:10b6:805:46::33)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.26;
	Mon, 10 May 2021 15:50:46 +0000
Received: from SN6PR10MB2701.namprd10.prod.outlook.com
	([fe80::459d:9552:66ce:5b44]) by
	SN6PR10MB2701.namprd10.prod.outlook.com
	([fe80::459d:9552:66ce:5b44%3]) with mapi id 15.20.4108.032;
	Mon, 10 May 2021 15:50:46 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Thread-Topic: [Ocfs2-devel] [PATCH v2] ocfs2: Reomve err less than zero check
Thread-Index: AQHXRYkPxMPQNbSFOEK6538DsP9rzKrc3WkA
Date: Mon, 10 May 2021 15:50:46 +0000
Message-ID: <1EED85DE-EFE1-4FBA-9AA5-648D8E586DD9@oracle.com>
References: <1620643062-124920-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1620643062-124920-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: linux.alibaba.com; dkim=none (message not signed)
	header.d=none;linux.alibaba.com; dmarc=none action=none
	header.from=oracle.com;
x-originating-ip: [71.198.166.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: df2ca04a-6acb-4d08-371c-08d913cb6092
x-ms-traffictypediagnostic: SN6PR10MB2766:
x-ms-exchange-transport-forked: True
x-oracle-tenancy: 1
x-ms-oob-tlc-oobclassifiers: OLM:989;
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uur4xjPoP7Kf6wr8xDk7YNVzQyFXE6eHut8gbA+GiLP5G0aIR0V+F0CbSFULZSOpWHfU7pT9Z8GRuIDTpPnN+0nU1K8oMjCM1rq6GoRmIuRxBNJgd7GyZFBR5vcONUbWIhcdACtpHBUiMkxY1T+miWQNWl0NMEm2yonkFJ0dvQ8oUxqwVRB82wln3rBm6LEzeIU1UKU8b2qKUXqZzgQZdBcgjZprYy4Vn90is7HcbYw0gImDX1odbCsU/n5vnu9QtNPc+MDL4bb95X7i4w55OQr+lXFFb6bDLa69W9+4cv6uKAuA36iqhWTOwzFWbwcF/jAVDBO+pw9C018hK6oFJOe1SwFr8f1u2B1YRLRvR1/j62AemwliR18idUc9dFlauU+tG5QQpR0Slc6nK4NiIbFOguduoPm+CF172p6du2vxjB2Sx2QbXZYC4h74W98rkt1P4p0V36GtosKlL88QrozqsJ4cg2iFY5wcbSOJgSBuV8HcAVEFL2MZvjU7YdiF/zu0CEvrOrULCk9VOIWx4pr9hG7wilDUL8EPUihy43Rzzc9Vxk5WbXNXjqLRzUfUNBPnlHStzyWl5EdLspbsgPWTpnhqiHNo1lcZtPXOwyQjWahpfeu25qcN2Zv/OMUytzyw+n4nRUdmad8gqPSnAQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:; IPV:NLI; SFV:SKI;
	H:SN6PR10MB2701.namprd10.prod.outlook.com; PTR:; CAT:NONE; SFS:;
	DIR:INB; 
x-ms-exchange-antispam-messagedata: =?utf-8?B?VFV3ZElmVUZhdXFRNFZWcWE4ZXF6Z01tdzM1aTFUaDFVS0Z4R2JxVkprYjBT?=
	=?utf-8?B?anRkdjJKWG1oZ1VMV1F6Z252RFBob09UMGR0SlJBUjRHckpkeW1YQXZrZ3Fz?=
	=?utf-8?B?R1hHaU9RZlp0STdERnpTR2FvMTJBOWxrRmtoN3VzQ1k2dWtIODh2M0s5UG1G?=
	=?utf-8?B?MW1Md3pXbWVOaXphRFlwTkQ5blRNV3RKSU0velBCWStrM25Va0NYM2tCWTZM?=
	=?utf-8?B?UVgyazN0NmxlQkFpb0lXaE95Ykhqdy96U0k3YmZsZk93VG9mcW4zMlVCN1hX?=
	=?utf-8?B?eEFyU3F6Zkw4b3BTb0pLZHo3N3JWOXlDNmFjZXNEVkN3d1Nnd1ZGUkpWYTZ4?=
	=?utf-8?B?VzgwTmxndXdIWmVXblViUTBGaXpwSkI0YXVCSkxhUkwrSlNpQW1QeDV4Zk1E?=
	=?utf-8?B?dnpoYU5GOUxpTjNYMVZzdkZiRU01dkYxVFpvSjN2TFFrT2ZqVjRGelhZYm95?=
	=?utf-8?B?UEkvUk9iVHpNcGtqVFdHd0p5ODRyT0VBSlBTSXZUVmtKT1VTZEZsZ2dDdk15?=
	=?utf-8?B?YnIvUlRPZDBGUmtsYnE4RkxWcEUvZThSVlZjc0Z6eUswVXBqdTBFNDhRSllY?=
	=?utf-8?B?VVI3RXBQSXpKK3l2RHpwUGU1WDM1RkZMTTJRdmVrN2hGNG8rZGY5ZXY3QWdX?=
	=?utf-8?B?M3IyT0JUVHpVVlFIcVRTYXV2Yzg1NWtFNktpZDZpRjZnK0ZJT29JM01MV0Rr?=
	=?utf-8?B?ZzUzUzdKMS9udXlsR25oRWxvM3lvSE9Pa0NlOC92VWJOVzlsY2FQVWgveU8v?=
	=?utf-8?B?Nm5lUUpxaHp4SEpXeXJsK0ZuRlBFR3h4dkNiUEo3Ynhja1k0ejJHbHp5akdJ?=
	=?utf-8?B?TFF6SlVXYzY1K2d1N3dQTHZ2dlRWOTMzTHVPVjdIN01aZHYyaXo0bjJYTTJL?=
	=?utf-8?B?UGdSck91UVZrQTZWZkVWMUFzQTJMOGFvS3g1UjVBaUlNOWVFREZFaXB0WXJB?=
	=?utf-8?B?Y0NIM3NlU1Z4cnJQZWdtSC9hcDFCbjQ5dkRlazkvK0Uxd2F4ZlpjbmoyakZH?=
	=?utf-8?B?QSt1VUNCMlhXNThsQS9qcTVzeVZreUd4YWxROWJjVHBEZGJaSkFJU1FCZ2xV?=
	=?utf-8?B?MENLNHJ5TC9BWVBjK2tWLzlzSXp2MkxPWWo0aEdaZDh0OUJhaWlVYnRTd3FO?=
	=?utf-8?B?c0FISUU5YXdtbDFUTzk3bDZkanJ6UnExSFBtRDJMRDluR0o2WkNubUdpYUR3?=
	=?utf-8?B?ckZwbXJvbVE0MFo3dVBwR3BrSkozb1llZzFQYlZ2K1JGbWZHb0NqRGJkQ29i?=
	=?utf-8?B?WmNmUzFkbHQxL1I2emFZdXluTlFGeVRqV1gvOThMb1JUbWd5MnVxRmdpOGRC?=
	=?utf-8?B?QitIWXp5Sk1HaTl2cE9KVXJCVTRSNGZNMDdFK1JyNmdlWHBNN09jWEJPUUtE?=
	=?utf-8?B?d3diL0w4N1Z6SG4vZjNrSlBTcFk3WkFidWpuc0s4NktId0tQdWNqcktKTUda?=
	=?utf-8?B?MHBhSUtYQ0t6TU92ZjVpakUvQVBJckdxN1NnNVJMSVlxcFdnQVV2MVRlczFN?=
	=?utf-8?B?ckcxMVRuV1FIWVRrUEttVmJ3SzBHdzRuOG1xb1d0UFVzbHNFSFczYm5iNCtD?=
	=?utf-8?B?RSsyczd3Y0laWUx5SGVoeVk0NTdnQjEraGo1MUM5ZERkUFlIK2U3ZzByUlNE?=
	=?utf-8?B?bnBBbmpNUlNOVjZpYXZGR0NrZldtSjNyL3ZiU0Q4aWd0bzZFbW4wQXQ5YzEz?=
	=?utf-8?B?K2k3ZVYvOTZnN05DWkFwNE1YRWRla3M2aUdEekNGMkJ3bWdjSURSZm1uc0NW?=
	=?utf-8?Q?A5HjagpvYqj8eVVAoNrocDZVo/cY9lIgJMWnNcu?=
Content-ID: <D47CC74CFA872C49ACFD742C65B6D700@namprd10.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2701.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df2ca04a-6acb-4d08-371c-08d913cb6092
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2021 15:50:46.7600 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7utcMz2CYi2GaiZ5ZH42YV93vtJWt13SnfNLT5vSWndUubNbSAcj9HttJrkq3gJKM/AMK5TOghb4cm5+26ekTDGVGyHdqZnQmgx0RN4uNRo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2766
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
X-OrganizationHeadersPreserved: SN6PR10MB2766.namprd10.prod.outlook.com
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
	phishscore=0
	adultscore=0 bulkscore=0 mlxscore=0 suspectscore=0 malwarescore=0
	spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2105100110
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH v2] ocfs2: Reomve err less than zero check
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 bulkscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105100110
X-Proofpoint-GUID: XlObPIzt7sgTymXjhHJUa1nlVhh1VYHk
X-Proofpoint-ORIG-GUID: XlObPIzt7sgTymXjhHJUa1nlVhh1VYHk
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 bulkscore=0 spamscore=0 clxscore=1011 priorityscore=1501 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 impostorscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105100111

SGkgSmlhcGVuZywNCg0KVGhvdWdoIHRoZSB0eXBlIG9mIGVudW0gZGxtX3N0YXR1cyBoYXMgYSB2
YWx1ZSByYW5nZSBzdGFydGluZyBmcm9tIHplcm8sICBJdCBjYW4gYmUgYXNzaWduZWQgd2l0aCBu
ZWdhdGl2ZSB2YWx1ZXMgd2l0aG91dCB3YXJuaW5ncy4NCkkgYW0gd29uZGVyaW5nIHdoeSB5b3Ug
YXJlIHN1cmUgaXQgY2Fu4oCZdCBiZSBuZWdhdGl2ZT8gIFlvdSB3ZW50IG92ZXIgYWxsIHRoZSBj
YWxsaW5nIHBhdGggYW5kIHNvIHlvdSBhcmUgc3VyZSBpdCBjYW7igJl0IGJlIG5lZ2F0aXZlPw0K
SWYgeW91IGRpZCB0aGF0LCBJ4oCZZCB0aGluay9ndWVzcyB5b3Ugc2hvdWxkIGFsc28gYmUgYWJs
ZSB0byBzYXkgaXQgY2Fu4oCZdCBiZSBETE1fTUFYU1RBVFMgb3IgYmlnZ2VyLCByaWdodD8gSWYg
bm90LCB3aGljaCBjYWxsaW5nIHBhdGggYXJlIHJldHVybmluZyA+PSBETE1fTUFYU1RBVFMgdmFs
dWU/DQp3ZSBzaG91bGQgZml4IHRoYXQgdG9vLg0KDQpJ4oCZZCB0aGluayB3ZSBzaG91bGQgdHJl
YXQgdGhlIHR3byBjb25kaXRpb25zIG9mIChlcnIgPj0gRExNX01BWFNUQVRTKSBhbmQgdGhlIChl
cnIgPCAwKSB0aGUgc2FtZSB3YXkuICBJZiBrZWVwLCBrZWVwIGJvdGguIGlmIHJlbW92ZSwgcmVt
b3ZlIGJvdGguDQpJ4oCZbSBzdXNwZWN0aW5nIHRoZSBjb2NjaWNoZWNrIHdhcm5pbmcgaXMgYmFz
ZWQgb24gdGhlIHR5cGUgb2YgZW51bSAoc3RhcnRpbmcgd2l0aCAwKSwgYnV0IGlmIHRoYXTigJlz
IHRoZSBvbmx5IHRoZW9yeSB0byByZW1vdmUgKGVyciA8IDApLCBJdOKAmXMgTkFLIGZyb20gbWUu
DQoNCnRoYW5rcywNCndlbmdhbmcNCg0KPiBPbiBNYXkgMTAsIDIwMjEsIGF0IDM6MzcgQU0sIEpp
YXBlbmcgQ2hvbmcgPGppYXBlbmcuY2hvbmdAbGludXguYWxpYmFiYS5jb20+IHdyb3RlOg0KPiAN
Cj4gQmVjYXVzZSBlbnVtIGRsbV9zdGF0dXMgc3RhcnRzIGZyb20gMCwgdGhlIGNoZWNrIGZvciBl
cnIgPCAwIGlzIGFsd2F5cw0KPiBmYWxzZS4NCj4gDQo+IENsZWFuIHVwIHRoZSBmb2xsb3dpbmcg
Y29jY2ljaGVjayB3YXJuaW5nOg0KPiANCj4gZnMvb2NmczIvZGxtL2RsbWRlYnVnLmM6MjIyIGRs
bV9lcnJuYW1lKCkgd2FybjogdW5zaWduZWQgJ2VycicgaXMgbmV2ZXINCj4gbGVzcyB0aGFuIHpl
cm8uDQo+IA0KPiBmcy9vY2ZzMi9kbG0vZGxtZGVidWcuYzoyMTQgZGxtX2Vycm1zZygpIHdhcm46
IHVuc2lnbmVkICdlcnInIGlzIG5ldmVyDQo+IGxlc3MgdGhhbiB6ZXJvLg0KPiANCj4gUmVwb3J0
ZWQtYnk6IEFiYWNpIFJvYm90IDxhYmFjaUBsaW51eC5hbGliYWJhLmNvbT4NCj4gU2lnbmVkLW9m
Zi1ieTogSmlhcGVuZyBDaG9uZyA8amlhcGVuZy5jaG9uZ0BsaW51eC5hbGliYWJhLmNvbT4NCj4g
LS0tDQo+IENoYW5nZXMgaW4gdjI6DQo+ICAtVXBkYXRlIGNvbW1pdCBsb2cuDQo+IA0KPiBmcy9v
Y2ZzMi9kbG0vZGxtZGVidWcuYyB8IDQgKystLQ0KPiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRp
b25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2ZzL29jZnMyL2RsbS9k
bG1kZWJ1Zy5jIGIvZnMvb2NmczIvZGxtL2RsbWRlYnVnLmMNCj4gaW5kZXggZDQ0MmNmNS4uODE3
OTE0ZCAxMDA2NDQNCj4gLS0tIGEvZnMvb2NmczIvZGxtL2RsbWRlYnVnLmMNCj4gKysrIGIvZnMv
b2NmczIvZGxtL2RsbWRlYnVnLmMNCj4gQEAgLTIxMSw3ICsyMTEsNyBAQCB2b2lkIGRsbV9wcmlu
dF9vbmVfbG9jayhzdHJ1Y3QgZGxtX2xvY2sgKmxvY2tpZCkNCj4gDQo+IGNvbnN0IGNoYXIgKmRs
bV9lcnJtc2coZW51bSBkbG1fc3RhdHVzIGVycikNCj4gew0KPiAtCWlmIChlcnIgPj0gRExNX01B
WFNUQVRTIHx8IGVyciA8IDApDQo+ICsJaWYgKGVyciA+PSBETE1fTUFYU1RBVFMpDQo+IAkJcmV0
dXJuIGRsbV9lcnJtc2dzW0RMTV9NQVhTVEFUU107DQo+IAlyZXR1cm4gZGxtX2Vycm1zZ3NbZXJy
XTsNCj4gfQ0KPiBAQCAtMjE5LDcgKzIxOSw3IEBAIGNvbnN0IGNoYXIgKmRsbV9lcnJtc2coZW51
bSBkbG1fc3RhdHVzIGVycikNCj4gDQo+IGNvbnN0IGNoYXIgKmRsbV9lcnJuYW1lKGVudW0gZGxt
X3N0YXR1cyBlcnIpDQo+IHsNCj4gLQlpZiAoZXJyID49IERMTV9NQVhTVEFUUyB8fCBlcnIgPCAw
KQ0KPiArCWlmIChlcnIgPj0gRExNX01BWFNUQVRTKQ0KPiAJCXJldHVybiBkbG1fZXJybmFtZXNb
RExNX01BWFNUQVRTXTsNCj4gCXJldHVybiBkbG1fZXJybmFtZXNbZXJyXTsNCj4gfQ0KPiAtLSAN
Cj4gMS44LjMuMQ0KPiANCj4gDQo+IF9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fDQo+IE9jZnMyLWRldmVsIG1haWxpbmcgbGlzdA0KPiBPY2ZzMi1kZXZlbEBv
c3Mub3JhY2xlLmNvbQ0KPiBodHRwczovL29zcy5vcmFjbGUuY29tL21haWxtYW4vbGlzdGluZm8v
b2NmczItZGV2ZWwNCg0KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18KT2NmczItZGV2ZWwgbWFpbGluZyBsaXN0Ck9jZnMyLWRldmVsQG9zcy5vcmFjbGUuY29t
Cmh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFpbG1hbi9saXN0aW5mby9vY2ZzMi1kZXZlbA==
