Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 819E5C43334
	for <ocfs2-devel@archiver.kernel.org>; Mon, 13 Jun 2022 15:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=IeLS7lwQSWxxsMGSepTSHebYuvW9PiTk1KPvOcBQ3oI=;
 b=jRRwWncvZ+YAIs88Qn9W2EnwvdDfEtXUAe4IDx4BZBo8cB7Fsv51OZQYjJyK8OR2+zCKdbRukrbE
   va2Dd3yY8qlFMerESugDdGGSavthDp4o0uGqJIJIMT2eG2NdyvCgOUAciJ260ayQt8oO4bOY+JoV
   PmbzTnWEMebNpVx86gohK0seeKwamQGxQzY9SQMW4mFjYACe4NJ9HtOxc5U1Qk8058hSusSivRNE
   didDAOi1OuDS93iGlULOumH0fTqSGleKJ0652b1QJDjaOQQvXNMEwi3OWy3xKMbl/DLFKUv3mk4A
   EvtMZ44sTioHBz8T5ob8WuDtnNSwHR+df8Z4Kg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=IeLS7lwQSWxxsMGSepTSHebYuvW9PiTk1KPvOcBQ3oI=;
 b=p6rwQWV6xJ9bCD4kPYmTqQRvZy/j7cjvTqN8nbf67RG5sfF2xhTCdR8mks+ngukBUlsQGOpOLp/l
   jP/gtspcP7UWawLfkzXG7pMSQAjDcT69umY1rd6V/sequv/03O20HoteT1qxBrqUdizmNn5kVPkw
   tDIpS/l6M4X/AgjPciEAWFc8OnnHunjHC3Y2gnNUyAt+P0lhh5JJninPlX/XYAPFV3eISiVwAX5C
   wghGIwJ24aDaJcAJ8sTMYtK+SdppvKotaRIwyDzjCOnEy8tent3Mg8GCcK5VqMko5eXy9bBCm2GI
   ZQyO2D+xM2gz349e3rhsE/QZRzSVAUJWt0tung==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220531 64bit (built May 31
 2022))
 with ESMTPS id <0RDF0073EADIRT90@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 13 Jun 2022 15:44:06 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to
 : cc : subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=yO64HU3G/FdoEbGkP+UunqkY3ObZHis5CPoQQDbJUMQ=;
 b=d9flrFzEdKTO/pAILhmiC9HMy1rfufoQZ1iukvlVe+3bk9mFVkVuSxrRKb+gvTRdQ7Tt
 gQw3XMXHcuHywVuvMKlqX8z3PcIqA5SrEaJvyg8ChGnjaGceyt2ccQp+Aw63KIDoo6iQ
 CI/3jHiz+GtuIDvS5PfnkR0KwEsdnzBPcr7zVUdCeRDCHVlerKKo2DNttuZq00Y6nl+F
 Cr40oyye4RSp7BZP4i0FK037Qfd1Cw9okMqneyk3J8h5uLmgMeNlacUlfW4S/mvu/2tI
 x8I4G84iWCnIhNBX2qXYwO2OdapObQFvM7dRB0qvvbsae+6n1TLQJZj5KHjUQR2g0ec0 TA==
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D3T5QO2o35FMOyjfEF7TQ7dgHkHVIf5VoAlufBZ4hn24z2mFbNQu11vsO5JYP8mUnQdiAuEHe4OfKxkPymnWxk7InWFYMbYg1tj0RkQoMAvem1c7j8NzISBfXcxaaPFLhvVcOGzcn5QMzmSO8wihbefzInMCuab3SvR4yr7pQjgmiERoWVn6FhhMzbARi1WhCSeIXOHcWSdDWiONwfeYyjbabg2lodnTAJVRhl5D/gGvGUffA9u3wy4XTQvEX41JqT9epzcWOl9fQ5ctsa37NVeT596tmUGSmGeZR83K7AbK/cejRXWT6BFYloUe3EF5+mJaZBGrqdhtU0P/G2wajA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yO64HU3G/FdoEbGkP+UunqkY3ObZHis5CPoQQDbJUMQ=;
 b=E7mPnaf5CiXPVcccum/JYUH8XlqBmv1UTtqrYtDS4y/1vUkNp+Q/Jp07H7/uEh38gonvNGt1izK/vM8n0mBJCzNlX7q09L8RZvJm1EGEgT38pGuViYIOEGPjQzneQGF/5ve1gfylibw5HzW/l+OJ1UGO7/NGUX9ZSumXbMViBT6eSxlx6aDbvClaiBplsPkDApY4IIJln2OaMHueQgnqr0lprScGBIvNzb/5pp5PRPq/qlrNyQzHftyG2e8FefcK3vIVoadVMmN6H6brALo0e1rrYnDH5DsIy8J1lgtqC19SpEDWFhQa5WfSq+XlyRKjqoZGvdbhuT4EJl+g+tHmwg==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yO64HU3G/FdoEbGkP+UunqkY3ObZHis5CPoQQDbJUMQ=;
 b=azbwriwgoVbOV9bbqR1v8ArSVg07IjHLcbFw+FnSsDbURy9Os5MrvrgYVmhNM11j3QBSKYnUxFMpv3y0Mt2dbSjZwF+w8wx+nLOQs74xVoKJvKtig/Vr18GhhZl8Tbye4M7SbabNDNHnGH3EkrfRXVr2ZRfpYOQJkxV2xinY0Ug=
To: "heming.zhao@suse.com" <heming.zhao@suse.com>
Thread-topic: [PATCH 1/1] ocfs2: fix ocfs2_find_slot repeats alloc same slot
 issue
Thread-index: AQHYeyVOSZ6tlDH7tkODDrbeV7JfGa1L15kAgAEpGgCAAAYKgIAAB5YAgAB0I+w=
Date: Mon, 13 Jun 2022 15:43:50 +0000
Message-id: <FFE0CF5B-76C7-49E0-B9AC-02C7FC21BADD@oracle.com>
References: <20220608104808.18130-1-heming.zhao@suse.com>
 <20220608104808.18130-2-heming.zhao@suse.com>
 <09b33ef3-b93a-5b50-d87d-8667ed993e5d@linux.alibaba.com>
 <faee689f-7a04-2042-636c-80fb48bc30ed@suse.com>
 <8dd30c4e-d572-bfd0-f261-b9cfcd8b5b4d@linux.alibaba.com>
 <28b5b33b-1942-b128-d3f0-5e3592338dad@suse.com>
In-reply-to: <28b5b33b-1942-b128-d3f0-5e3592338dad@suse.com>
Accept-Language: en-US
Content-language: zh-CN
X-MS-Has-Attach:
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:SJ0PR10MB4752.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
MIME-version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2022 15:43:50.0152 (UTC)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,
 18.0.874 definitions=2022-06-13_07:2022-06-13, 2022-06-13 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 adultscore=0 spamscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206130070
Cc: "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH 1/1] ocfs2: fix ocfs2_find_slot repeats alloc
 same slot issue
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: Junxiao Bi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Junxiao Bi <junxiao.bi@oracle.com>
Content-type: text/plain; charset="utf-8"
Content-transfer-encoding: base64
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 26085b15-3e5b-40d5-d775-08da4d5382eb
x-ms-traffictypediagnostic: BN7PR10MB2737:EE_
x-oracle-tenancy: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 9QnBaPQLd2X0ah5L8RDSALxPF9s4/TCT3OM24aPi6Xwi37PQOeSxCrluNPn9FXHBw7nyqSUx+xg/r8i5l/BqA3QD1/f3GpO8hSlJK3GZkiZGYxqK30/gWK2LNXolULkWIcvedOUXGpg1RVM0x0YTqvlsF7jMwaSPnCBery5vbBQM4EA+brnaN53WWV2yEbPdhPGtnMM5PMFucLu7r4pTAoaq/mJ/dVVjfyH4Lgh6tY7JMHzJJt+ZaCCjDmFGEJzazXChAxYK/cOsoUHHtpQdMLAq9cXRrUzfAfxbKmS+YAiRt4wlpS8A6IYql97aWJvL1j3S2RH4rrtRX/YZOEc8sHtjcOIShn4C8QYMcH/C8fdlP9M/atKqhNvqrjDWH/ViI1xaZljTN5nJc7edMaBuB2liJgJyxGPHxVmokSv2SNJiRu2/+4iJxScleCA0J5/j7Pj/JVsYUI8TRAD6y3cNlGwf/WdoxO+YVerbHdQNU8+TB5Y32AHAgCbn4/MJU3hrMnMT6nX2aysIr0V72Nu/ocUxN3VblhbUTca5OxS603LF6YhMecpNCvBnGpQ9KKpLpAI4SNePs/5QlrQJD8hmTyW2NKOlLqqTTY5nAvFlc08=
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id:
 26085b15-3e5b-40d5-d775-08da4d5382eb
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname:
 zAjSN++BAdn9h2Z4FIynxKwhQV1BhoLeWLYWf8+qJuKFRD3l78ivS10gSB7nVCqYP8PXUpgQBX5u2arm74AwEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR10MB2737
X-Proofpoint-GUID: aGYIOSav7MZVy-fWBDS4WCIB9XNzWH4x
X-Proofpoint-ORIG-GUID: aGYIOSav7MZVy-fWBDS4WCIB9XNzWH4x
Reporting-Meta:
 AAEuJcKP7ygU/09FStu39oMVIxvNPvA7dhyi8TDU4CArLcSWdf7OmLPHNiWr8UjW
 sgUlvLe2rkTxKWQfjsMckIc3F1xMk0FF548kxabTG6OvznESNvU0cCHwfxU1iRBr
 ZFQjuQsSo6doDtVNRQmjoVmjZPx+erpNr7t6IyuILZMwgdnmZ4gZYYCXYVjEmQ4J
 TZwJMSBph9M9dnLBU05EIRilaB/ugXowMDVlWzuMLS4v7MzmI3hR7T50IVrtBceW
 iKCapIakRck58PvUaQ9dZs6obokTdtqb0eTtzxZ9O55cA5A0k/5JHqMFbKoZYZoX
 fgVKnNITUlIe+1TPo7pzX6m46WBlgIc5eagBRMGblzD5dj8hqDdswn+bmDP7NOBw
 1BPA03wTrG0eJDDt7KoztwKFcYmAGQ9xx1byvtHIOzXheOvQTpMWgkVnxqwnXNEd
 N1t1wjjR/Cqfilrem9Jxv9lTKIW6fI8xEL5e9PSd206UlvrHlgxNviSrkvqeO4E+
 NPRVywvaTKNuvElR+xdSqkbp1tdxP5SwKVJ5EglU/dfk

DQo+IOWcqCAyMDIy5bm0NuaciDEz5pel77yM5LiK5Y2IMTo0OO+8jGhlbWluZy56aGFvQHN1c2Uu
Y29tIOWGmemBk++8mg0KPiANCj4g77u/T24gNi8xMy8yMiAxNjoyMSwgSm9zZXBoIFFpIHdyb3Rl
Og0KPj4+IE9uIDYvMTMvMjIgMzo1OSBQTSwgaGVtaW5nLnpoYW9Ac3VzZS5jb20gd3JvdGU6DQo+
Pj4gT24gNi8xMi8yMiAyMjoxNiwgSm9zZXBoIFFpIHdyb3RlOg0KPj4+PiBIaSwNCj4+Pj4gDQo+
Pj4+IFdoeSBjYW4ndCB1c2UgbG9jYWwgbW91bnQ/IEkgZG9uJ3QgcmVtZW1iZXIgaWYgd2UgZGlz
Y3VzcyBhYm91dCB0aGlzLg0KPj4+PiANCj4+PiBTb3JyeSwgSSBjYW4ndCBmb2xsb3cgeW91ciBx
dWVzdGlvbi4NCj4+PiBEbyB5b3UgbWVhbiB3aHkgcmV2ZXJ0IGNvbW1pdCA5MTJmNjU1ZDc4YzU/
DQo+Pj4gDQo+Pj4gb3IgeW91IGFyZSBpbnRlcmVzdCB3aXRoIHRoZSBmZWF0dXJlIGxvY2FsIG1v
dW50Pw0KPj4+IHRoZSBsb2NhbCBtb3VudCBpcyBjcmVhdGVkIGJ5IG1rZnMub2NmczIsIHdoaWNo
IGNhbid0IGJlIGNvbnZlcnRlZCB0byBjbHVzdGVyZWQuDQo+Pj4gc2VlIG1rZnMub2NmczIoOCkg
Jy1NJyBvcHRpb24uDQo+Pj4gDQo+PiBXaGF0IEp1bnhpYW8ncyBtYWluIGNvbmNlcm4gaXMgZGF0
YSBjb3JydXB0aW9uLCBzbyBJJ20gYWZyYWlkIHdlIGhhdmUgdG8NCj4+IGludHJvZHVjZSBhbiBv
bmRpc2sgZmVhdHVyZSBiaXQgdG8gcHJldmVudCBtaXhlZCBub2NsdXN0ZXIgYW5kIGNsdXN0ZXIN
Cj4+IG1vdW50LCBzaW1pbGFyIHRvIGxvY2FsIG1vdW50Lg0KPiANCj4gdGhpcyBwYXRjaCBkZWZp
bmVkIHR3byBuZXcgdmFyaWFudHMvZmxhZ3M6DQo+ICNkZWZpbmUgT0NGUzJfU0xPVE1BUF9DTFVT
VEVSICAgMQ0KPiAjZGVmaW5lIE9DRlMyX1NMT1RNQVBfTk9DTFVTVEVSIDINCj4gDQo+IChJIGV4
cGVjdCkgVW5kZXIgT0NGUzJfU0xPVE1BUF9DTFVTVEVSLCBmb3IgY2x1c3RlcmVkIG1vdW50IG1v
ZGUgYW5kIGZvciBjb21wYXRpYmlsaXR5LA0KPiBhbnl0aGluZyBkb2Vzbid0IG5lZWQgdG8gYmUg
Y2hhbmdlZC4NCj4gDQo+IE9DRlMyX1NMT1RNQVBfTk9DTFVTVEVSIHdpbGwgaW50cm9kdWNlIGEg
bmV3IHZhbHVlIGZvciBzbG90bWFwIGFyZWEuDQo+IHRoaXMgbmV3IHZhbHVlIG9ubHkgdGFrZSBl
ZmZlY3QgYWZ0ZXIgYSBzdWNjZXNzZnVsbHkgbm9jbHVzdGVyIG1vdW50Lg0KPiAocGxzIGZpeCBt
ZSksIGV4aXN0ZWQga2VybmVsL3VzZXIgc3BhY2UgY29kZSBkb24ndCBkbyBhbnkgc3BlY2lhbCBo
YW5kbGUgZm9yDQo+IG5vY2x1c3RlcmVkIG1vdW50IG1vZGUgaW4gc2xvdG1hcCBhcmVhLiBTbyB0
aGUgbmV3IHZhbHVlIGlzIGFsc28gY29tcGF0aWJpbGl0eS4NCj4gDQo+IEFuZCB0aGUgcGF0Y2gg
Y2FuIGFsc28gcHJldmVudCBtaXhlZCBtb3VudCwgdGhlIHJlbGF0ZWQgY29kZSBpcyBpbiBvY2Zz
Ml9maW5kX3Nsb3QoKS4NCj4gY29kZSBsb2dpYzoNCj4gLSBub2NsdXN0ZXJlZCBtb3VudCBjb25k
aXRpb246IHNsb3RtYXAgaXMgZW1wdHkgb3IgYWxyZWFkeSBtb3VudGVkIHdpdGggbm9jbHVzdGVy
ZWQNCj4gLSBjbHVzdGVyZWQgbW91bnQgY29uZGl0aW9uOiBzbG90bWFwIGlzIGVtcHR5IG9yIGFs
cmVhZHkgbW91bnRlZCB3aXRoIGNsdXN0ZXJlZC4NCj4gLSBhbGwgb3RoZXIgY29uZGl0aW9ucyB3
aWxsIGJlIGRlbmllZC4NCkZpbmRpbmcgc2xvdCByZXF1aXJlZCByZWFkaW5nIHNsb3QgbWFwIGFu
ZCB0aGVuICB1cGRhdGUgc2xvdCBtYXAuIEl0IGlzIG5vdCBhdG9taWMgLCB5b3UgY2Fu4oCZdCBw
cmV2ZW50IG1peGVkIG1vdW50IHVudGlsIHlvdSBoYXZlIGEgY2x1c3RlciBsb2NrLg0KPiANCj4+
IEFub3RoZXIgc2NlbmFyaW8gaXMgam91cm5hbCByZXBsYXkgYWZ0ZXIgY3Jhc2guDQo+IA0KPiB0
aGlzIHBhdGNoIHNldCBhIHJ1bGU6DQo+IElmIGxhc3QgbW91bnQgZGlkbid0IGRvIHVtb3VudCwg
KGVnOiBjcmFzaCBoYXBwZW5lZCksIHRoZSBuZXh0IG1vdW50IE1VU1QgYmUgc2FtZSBtb3VudCB0
eXBlLg0KPiAocGxlYXNlIGFsc28gY2hlY2sgYWJvdmUgbGluZXMgb2YgJ2NvZGUgbG9naWMnLikN
Cj4gDQo+IEluIG15IHZpZXcsIHRoaXMgcnVsZSBpcyBlbm91Z2ggdG8gaGFuZGxlIGNyYXNoIHNj
ZW5hcmlvLg0KPiBTbyBteSBwYXRjaCBzaG91bGQgYmUgcG9saXNoZWQgaW4gc29tZXdoZXJlLCBi
dXQgaXQgaXMgd29ya2FibGUuDQo+IA0KPiBUaGFua3MsDQo+IEhlbWluZw0KX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KT2NmczItZGV2ZWwgbWFpbGluZyBs
aXN0Ck9jZnMyLWRldmVsQG9zcy5vcmFjbGUuY29tCmh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFp
bG1hbi9saXN0aW5mby9vY2ZzMi1kZXZlbA==
