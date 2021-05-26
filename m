Return-Path: <SRS0=dXbG=KV=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BEE2C47087
	for <ocfs2-devel@archiver.kernel.org>; Wed, 26 May 2021 02:14:37 +0000 (UTC)
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A62FD61413
	for <ocfs2-devel@archiver.kernel.org>; Wed, 26 May 2021 02:14:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A62FD61413
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=ocfs2-devel-bounces@oss.oracle.com
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
	by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14Q2APRq021424;
	Wed, 26 May 2021 02:14:33 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by userp2120.oracle.com with ESMTP id 38ptkp7kr6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 May 2021 02:14:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14Q2AC37053285;
	Wed, 26 May 2021 02:14:32 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 38qbqssv5r-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Wed, 26 May 2021 02:14:31 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1llj0z-0005cH-G4; Tue, 25 May 2021 19:11:21 -0700
Received: from userp3030.oracle.com ([156.151.31.80])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <joseph.qi@linux.alibaba.com>) id 1llj0w-0005bs-Mm
	for ocfs2-devel@oss.oracle.com; Tue, 25 May 2021 19:11:18 -0700
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14Q2BHoY167309
	for <ocfs2-devel@oss.oracle.com>; Wed, 26 May 2021 02:11:18 GMT
Received: from userp2030.oracle.com (userp2030.oracle.com [156.151.31.89])
	by userp3030.oracle.com with ESMTP id 38pq2urwju-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Wed, 26 May 2021 02:11:18 +0000
Received: from pps.filterd (userp2030.oracle.com [127.0.0.1])
	by userp2030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	14Q23EnC047236
	for <ocfs2-devel@oss.oracle.com>; Wed, 26 May 2021 02:11:17 GMT
Received: from out30-130.freemail.mail.aliyun.com
	(out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by userp2030.oracle.com with ESMTP id 38rnjn140f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Wed, 26 May 2021 02:11:17 +0000
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R161e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1;
	HT=alimailimapcm10staff010182156082;
	MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=4; SR=0;
	TI=SMTPD_---0Ua7bxmw_1621995070; 
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com
	fp:SMTPD_---0Ua7bxmw_1621995070) by smtp.aliyun-inc.com(127.0.0.1);
	Wed, 26 May 2021 10:11:11 +0800
To: Junxiao Bi <junxiao.bi@oracle.com>, ocfs2-devel@oss.oracle.com
References: <20210521233612.75185-1-junxiao.bi@oracle.com>
	<35a1d32b-b8d7-ea9b-d28c-6b4fd837605d@linux.alibaba.com>
	<8aa90f5d-e4db-5107-1d3c-383294871196@oracle.com>
	<21d8b289-541d-50f5-6f86-de3ee69c56c5@linux.alibaba.com>
	<35283832-3294-19e0-6542-d1f925711fe8@oracle.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <cbeec344-adb3-0dc4-51ee-4716c07176f3@linux.alibaba.com>
Date: Wed, 26 May 2021 10:11:10 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <35283832-3294-19e0-6542-d1f925711fe8@oracle.com>
Content-Language: en-US
X-PDR: PASS
X-Source-IP: 115.124.30.130
X-ServerName: out30-130.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
	include:spf2.service.alibaba.com
	include:spf1.ocm.aliyun.com  include:spf2.ocm.aliyun.com
	include:spf1.staff.mail.aliyun.com include:a.hichina.mail.aliyun.com
	include:b.hichina.mail.aliyun.com -all
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
	bulkscore=0 adultscore=0
	malwarescore=0 phishscore=0 impostorscore=0 suspectscore=0 clxscore=197
	mlxlogscore=999 priorityscore=60 lowpriorityscore=0 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2105260013
X-Spam: Clean
X-MIME-Autoconverted: from 8bit to base64 by userp3030.oracle.com id
	14Q2BHoY167309
Cc: linux-fsdevel@vger.kernel.org, jack@suse.cz
Subject: Re: [Ocfs2-devel] [PATCH v2] ocfs2: fix data corruption by fallocate
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
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260014
X-Proofpoint-GUID: e1q8HjBr5tdGKampS5q1hQ_8f6wtRoZi
X-Proofpoint-ORIG-GUID: e1q8HjBr5tdGKampS5q1hQ_8f6wtRoZi
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 clxscore=1034 lowpriorityscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105260014

DQpDYW4gd2Ugc2ltcGx5IHJlcGxhY2UgaV9zaXplX3JlYWQoKSB3aXRoICdvcmlnX2lzaXplJyBh
bmQgbGVhdmUgaXNpemUNCnVwZGF0ZSBhbG9uZyB3aXRoIG90aGVyIGRpcnR5IGlub2RlIG9wZXJh
dGlvbnM/DQpJIHRoaW5rIHRoaXMgbWFrZXMgbW9yZSBjb21mb3J0YWJsZSBmb3IgdGhlIGRpcnR5
IGlub2RlIHRyYW5zYWN0aW9uLg0KDQpUaGFua3MsDQpKb3NlcGggDQoNCk9uIDUvMjYvMjEgMTo1
OCBBTSwgSnVueGlhbyBCaSB3cm90ZToNCj4gSSB3b3VsZCBsaWtlIG1ha2UgdGhlIGZvbGxvd2lu
ZyBjaGFuZ2UgdG8gdGhlIHBhdGNoLCBpcyB0aGF0IG9rIHRvIHlvdT8NCj4gDQo+IGRpZmYgLS1n
aXQgYS9mcy9vY2ZzMi9maWxlLmMgYi9mcy9vY2ZzMi9maWxlLmMNCj4gaW5kZXggMTc0NjlmYzdi
MjBlLi43NzU2NTc5NDMwNTcgMTAwNjQ0DQo+IC0tLSBhL2ZzL29jZnMyL2ZpbGUuYw0KPiArKysg
Yi9mcy9vY2ZzMi9maWxlLmMNCj4gQEAgLTE5OTksOSArMTk5OSwxMiBAQCBzdGF0aWMgaW50IF9f
b2NmczJfY2hhbmdlX2ZpbGVfc3BhY2Uoc3RydWN0IGZpbGUgKmZpbGUsIHN0cnVjdCBpbm9kZSAq
aW5vZGUsDQo+IMKgwqDCoMKgwqDCoMKgIH0NCj4gDQo+IMKgwqDCoMKgwqDCoMKgIC8qIHplcm9v
dXQgZW9mIGJsb2NrcyBpbiB0aGUgY2x1c3Rlci4gKi8NCj4gLcKgwqDCoMKgwqDCoCBpZiAoIXJl
dCAmJiBjaGFuZ2Vfc2l6ZSAmJiBvcmlnX2lzaXplIDwgc2l6ZSkNCj4gK8KgwqDCoMKgwqDCoCBp
ZiAoIXJldCAmJiBjaGFuZ2Vfc2l6ZSAmJiBvcmlnX2lzaXplIDwgc2l6ZSkgew0KPiDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0ID0gb2NmczJfemVyb291dF9wYXJ0aWFsX2NsdXN0
ZXIoaW5vZGUsIG9yaWdfaXNpemUsDQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzaXplIC0gb3Jp
Z19pc2l6ZSk7DQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmICghcmV0KQ0KPiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaV9zaXplX3dyaXRl
KGlub2RlLCBzaXplKTsNCj4gK8KgwqDCoMKgwqDCoCB9DQo+IMKgwqDCoMKgwqDCoMKgIHVwX3dy
aXRlKCZPQ0ZTMl9JKGlub2RlKS0+aXBfYWxsb2Nfc2VtKTsNCj4gwqDCoMKgwqDCoMKgwqAgaWYg
KHJldCkgew0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbWxvZ19lcnJubyhyZXQp
Ow0KPiBAQCAtMjAxOCw5ICsyMDIxLDYgQEAgc3RhdGljIGludCBfX29jZnMyX2NoYW5nZV9maWxl
X3NwYWNlKHN0cnVjdCBmaWxlICpmaWxlLCBzdHJ1Y3QgaW5vZGUgKmlub2RlLA0KPiDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZ290byBvdXRfaW5vZGVfdW5sb2NrOw0KPiDCoMKgwqDC
oMKgwqDCoCB9DQo+IA0KPiAtwqDCoMKgwqDCoMKgIGlmIChjaGFuZ2Vfc2l6ZSAmJiBpX3NpemVf
cmVhZChpbm9kZSkgPCBzaXplKQ0KPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpX3Np
emVfd3JpdGUoaW5vZGUsIHNpemUpOw0KPiAtDQo+IMKgwqDCoMKgwqDCoMKgIGlub2RlLT5pX2N0
aW1lID0gaW5vZGUtPmlfbXRpbWUgPSBjdXJyZW50X3RpbWUoaW5vZGUpOw0KPiDCoMKgwqDCoMKg
wqDCoCByZXQgPSBvY2ZzMl9tYXJrX2lub2RlX2RpcnR5KGhhbmRsZSwgaW5vZGUsIGRpX2JoKTsN
Cj4gwqDCoMKgwqDCoMKgwqAgaWYgKHJldCA8IDApDQo+IA0KPiBUaGFua3MsDQo+IA0KPiBKdW54
aWFvLg0KPiANCj4gT24gNS8yNC8yMSA3OjA0IFBNLCBKb3NlcGggUWkgd3JvdGU6DQo+PiBUaGFu
a3MgZm9yIHRoZSBleHBsYW5hdGlvbnMuDQo+PiBBIHRpbnkgY2xlYW51cCwgd2UgY2FuIHVzZSAn
b3JpZ19pc2l6ZScgaW5zdGVhZCBvZiBpX3NpemVfcmVhZCgpIGxhdGVyDQo+PiBpbiBfX29jZnMy
X2NoYW5nZV9maWxlX3NwYWNlKCkuDQo+PiBPdGhlciBsb29rcyBnb29kIHRvIG1lLg0KPj4gUmV2
aWV3ZWQtYnk6IEpvc2VwaCBRaSA8am9zZXBoLnFpQGxpbnV4LmFsaWJhYmEuY29tPg0KPj4NCj4+
IE9uIDUvMjUvMjEgMTI6MjMgQU0sIEp1bnhpYW8gQmkgd3JvdGU6DQo+Pj4gVGhhdCB3aWxsIG5v
dCB3b3JrLCBidWZmZXIgd3JpdGUgemVybyBmaXJzdCwgdGhlbiB1cGRhdGUgaV9zaXplLCBpbiBi
ZXR3ZWVuIHdyaXRlYmFjayBjb3VsZCBiZSBraWNrZWQgaW4gYW5kIGNsZWFyIHRob3NlIGRpcnR5
IGJ1ZmZlcnMgYmVjYXVzZSB0aGV5IHdlcmUgb3V0IG9mIGlfc2l6ZS4gQmVzaWRlIHRoYXQsIE9D
RlMyX0lPQ19SRVNWU1A2NCB3YXMgbmV2ZXIgZG9pbmcgcmlnaHQgam9iLCBpdCBkaWRuJ3QgdGFr
ZSBjYXJlIGVvZiBibG9ja3MgaW4gdGhlIGxhc3QgY2x1c3RlciwgdGhhdCBtYWRlIGV2ZW4gYSBz
aW1wbGUgZmFsbG9jYXRlIHRvIGV4dGVuZCBmaWxlIHNpemUgY291bGQgY2F1c2UgY29ycnVwdGlv
bi4gVGhpcyBwYXRjaCBmaXhlZCBib3RoIGlzc3Vlcy4NCj4+Pg0KPj4+IFRoYW5rcywNCj4+Pg0K
Pj4+IEp1bnhpYW8uDQo+Pj4NCj4+PiBPbiA1LzIzLzIxIDQ6NTIgQU0sIEpvc2VwaCBRaSB3cm90
ZToNCj4+Pj4gSGkgSnVueGlhbywNCj4+Pj4gSWYgY2hhbmdlX3NpemUgaXMgdHJ1ZSAoIUZBTExP
Q19GTF9LRUVQX1NJWkUpLCBpdCB3aWxsIHVwZGF0ZSBpc2l6ZQ0KPj4+PiBpbiBfX29jZnMyX2No
YW5nZV9maWxlX3NwYWNlKCkuIFdoeSBkbyB3ZSBoYXZlIHRvIHplcm9vdXQgZmlyc3Q/DQo+Pj4+
DQo+Pj4+IFRoYW5rcywNCj4+Pj4gSm9zZXBoDQo+Pj4+DQo+Pj4+IE9uIDUvMjIvMjEgNzozNiBB
TSwgSnVueGlhbyBCaSB3cm90ZToNCj4+Pj4+IFdoZW4gZmFsbG9jYXRlIHB1bmNoZXMgaG9sZXMg
b3V0IG9mIGlub2RlIHNpemUsIGlmIG9yaWdpbmFsIGlzaXplIGlzIGluDQo+Pj4+PiB0aGUgbWlk
ZGxlIG9mIGxhc3QgY2x1c3RlciwgdGhlbiB0aGUgcGFydCBmcm9tIGlzaXplIHRvIHRoZSBlbmQg
b2YgdGhlDQo+Pj4+PiBjbHVzdGVyIHdpbGwgYmUgemVyb2VkIHdpdGggYnVmZmVyIHdyaXRlLCBh
dCB0aGF0IHRpbWUgaXNpemUgaXMgbm90DQo+Pj4+PiB5ZXQgdXBkYXRlZCB0byBtYXRjaCB0aGUg
bmV3IHNpemUsIGlmIHdyaXRlYmFjayBpcyBraWNrZWQgaW4sIGl0IHdpbGwNCj4+Pj4+IGludm9r
ZSBvY2ZzMl93cml0ZXBhZ2UoKS0+YmxvY2tfd3JpdGVfZnVsbF9wYWdlKCkgd2hlcmUgdGhlIHBh
Z2VzIG91dA0KPj4+Pj4gb2YgaW5vZGUgc2l6ZSB3aWxsIGJlIGRyb3BwZWQuIFRoYXQgd2lsbCBj
YXVzZSBmaWxlIGNvcnJ1cHRpb24uIEZpeA0KPj4+Pj4gdGhpcyBieSB6ZXJvIG91dCBlb2YgYmxv
Y2tzIHdoZW4gZXh0ZW5kaW5nIHRoZSBpbm9kZSBzaXplLg0KPj4+Pj4NCj4+Pj4+IFJ1bm5pbmcg
dGhlIGZvbGxvd2luZyBjb21tYW5kIHdpdGggcWVtdS1pbWFnZSA0LjIuMSBjYW4gZ2V0IGEgY29y
cnVwdGVkDQo+Pj4+PiBjb3ZlcnRlZCBpbWFnZSBmaWxlIGVhc2lseS4NCj4+Pj4+DQo+Pj4+PiDC
oMKgwqDCoMKgIHFlbXUtaW1nIGNvbnZlcnQgLXAgLXQgbm9uZSAtVCBub25lIC1mIHFjb3cyICRx
Y293X2ltYWdlIFwNCj4+Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgLU8gcWNvdzIg
LW8gY29tcGF0PTEuMSAkcWNvd19pbWFnZS5jb252DQo+Pj4+Pg0KPj4+Pj4gVGhlIHVzYWdlIG9m
IGZhbGxvY2F0ZSBpbiBxZW11IGlzIGxpa2UgdGhpcywgaXQgZmlyc3QgcHVuY2hlcyBob2xlcyBv
dXQgb2YNCj4+Pj4+IGlub2RlIHNpemUsIHRoZW4gZXh0ZW5kIHRoZSBpbm9kZSBzaXplLg0KPj4+
Pj4NCj4+Pj4+IMKgwqDCoMKgwqAgZmFsbG9jYXRlKDExLCBGQUxMT0NfRkxfS0VFUF9TSVpFfEZB
TExPQ19GTF9QVU5DSF9IT0xFLCAyMjc2MTk2MzUyLCA2NTUzNikgPSAwDQo+Pj4+PiDCoMKgwqDC
oMKgIGZhbGxvY2F0ZSgxMSwgMCwgMjI3NjE5NjM1MiwgNjU1MzYpID0gMA0KPj4+Pj4NCj4+Pj4+
IHYxOiBodHRwczovL3d3dy5zcGluaWNzLm5ldC9saXN0cy9saW51eC1mc2RldmVsL21zZzE5Mzk5
OS5odG1sDQo+Pj4+Pg0KPj4+Pj4gQ2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPg0KPj4+Pj4g
Q2M6IEphbiBLYXJhIDxqYWNrQHN1c2UuY3o+DQo+Pj4+PiBTaWduZWQtb2ZmLWJ5OiBKdW54aWFv
IEJpIDxqdW54aWFvLmJpQG9yYWNsZS5jb20+DQo+Pj4+PiAtLS0NCj4+Pj4+DQo+Pj4+PiBDaGFu
Z2VzIGluIHYyOg0KPj4+Pj4gLSBzdWdnZXN0ZWQgYnkgSmFuIEthcmEsIHVzaW5nIHNiX2lzc3Vl
X3plcm9vdXQgdG8gemVybyBlb2YgYmxvY2tzIGluIGRpc2sgZGlyZWN0bHkuDQo+Pj4+Pg0KPj4+
Pj4gwqDCoCBmcy9vY2ZzMi9maWxlLmMgfCA0OSArKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKy0tDQo+Pj4+PiDCoMKgIDEgZmlsZSBjaGFuZ2VkLCA0NyBpbnNl
cnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPj4+Pj4NCj4+Pj4+IGRpZmYgLS1naXQgYS9mcy9v
Y2ZzMi9maWxlLmMgYi9mcy9vY2ZzMi9maWxlLmMNCj4+Pj4+IGluZGV4IGYxN2MzZDMzZmIxOC4u
MTc0NjlmYzdiMjBlIDEwMDY0NA0KPj4+Pj4gLS0tIGEvZnMvb2NmczIvZmlsZS5jDQo+Pj4+PiAr
KysgYi9mcy9vY2ZzMi9maWxlLmMNCj4+Pj4+IEBAIC0xODU1LDYgKzE4NTUsNDUgQEAgaW50IG9j
ZnMyX3JlbW92ZV9pbm9kZV9yYW5nZShzdHJ1Y3QgaW5vZGUgKmlub2RlLA0KPj4+Pj4gwqDCoMKg
wqDCoMKgIHJldHVybiByZXQ7DQo+Pj4+PiDCoMKgIH0NCj4+Pj4+IMKgwqAgKy8qDQo+Pj4+PiAr
ICogemVybyBvdXQgcGFydGlhbCBibG9ja3Mgb2Ygb25lIGNsdXN0ZXIuDQo+Pj4+PiArICoNCj4+
Pj4+ICsgKiBzdGFydDogZmlsZSBvZmZzZXQgd2hlcmUgemVybyBzdGFydHMsIHdpbGwgYmUgbWFk
ZSB1cHBlciBibG9jayBhbGlnbmVkLg0KPj4+Pj4gKyAqIGxlbjogaXQgd2lsbCBiZSB0cmltbWVk
IHRvIHRoZSBlbmQgb2YgY3VycmVudCBjbHVzdGVyIGlmICJzdGFydCArIGxlbiINCj4+Pj4+ICsg
KsKgwqDCoMKgwqAgaXMgYmlnZ2VyIHRoYW4gaXQuDQo+Pj4+PiArICovDQo+Pj4+PiArc3RhdGlj
IGludCBvY2ZzMl96ZXJvb3V0X3BhcnRpYWxfY2x1c3RlcihzdHJ1Y3QgaW5vZGUgKmlub2RlLA0K
Pj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHU2NCBzdGFydCwg
dTY0IGxlbikNCj4+Pj4+ICt7DQo+Pj4+PiArwqDCoMKgIGludCByZXQ7DQo+Pj4+PiArwqDCoMKg
IHU2NCBzdGFydF9ibG9jaywgZW5kX2Jsb2NrLCBucl9ibG9ja3M7DQo+Pj4+PiArwqDCoMKgIHU2
NCBwX2Jsb2NrLCBvZmZzZXQ7DQo+Pj4+PiArwqDCoMKgIHUzMiBjbHVzdGVyLCBwX2NsdXN0ZXIs
IG5yX2NsdXN0ZXJzOw0KPj4+Pj4gK8KgwqDCoCBzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiID0gaW5v
ZGUtPmlfc2I7DQo+Pj4+PiArwqDCoMKgIHU2NCBlbmQgPSBvY2ZzMl9hbGlnbl9ieXRlc190b19j
bHVzdGVycyhzYiwgc3RhcnQpOw0KPj4+Pj4gKw0KPj4+Pj4gK8KgwqDCoCBpZiAoc3RhcnQgKyBs
ZW4gPCBlbmQpDQo+Pj4+PiArwqDCoMKgwqDCoMKgwqAgZW5kID0gc3RhcnQgKyBsZW47DQo+Pj4+
PiArDQo+Pj4+PiArwqDCoMKgIHN0YXJ0X2Jsb2NrID0gb2NmczJfYmxvY2tzX2Zvcl9ieXRlcyhz
Yiwgc3RhcnQpOw0KPj4+Pj4gK8KgwqDCoCBlbmRfYmxvY2sgPSBvY2ZzMl9ibG9ja3NfZm9yX2J5
dGVzKHNiLCBlbmQpOw0KPj4+Pj4gK8KgwqDCoCBucl9ibG9ja3MgPSBlbmRfYmxvY2sgLSBzdGFy
dF9ibG9jazsNCj4+Pj4+ICvCoMKgwqAgaWYgKCFucl9ibG9ja3MpDQo+Pj4+PiArwqDCoMKgwqDC
oMKgwqAgcmV0dXJuIDA7DQo+Pj4+PiArDQo+Pj4+PiArwqDCoMKgIGNsdXN0ZXIgPSBvY2ZzMl9i
eXRlc190b19jbHVzdGVycyhzYiwgc3RhcnQpOw0KPj4+Pj4gK8KgwqDCoCByZXQgPSBvY2ZzMl9n
ZXRfY2x1c3RlcnMoaW5vZGUsIGNsdXN0ZXIsICZwX2NsdXN0ZXIsDQo+Pj4+PiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgICZucl9jbHVzdGVycywgTlVMTCk7DQo+Pj4+PiArwqDCoMKg
IGlmIChyZXQpDQo+Pj4+PiArwqDCoMKgwqDCoMKgwqAgcmV0dXJuIHJldDsNCj4+Pj4+ICvCoMKg
wqAgaWYgKCFwX2NsdXN0ZXIpDQo+Pj4+PiArwqDCoMKgwqDCoMKgwqAgcmV0dXJuIDA7DQo+Pj4+
PiArDQo+Pj4+PiArwqDCoMKgIG9mZnNldCA9IHN0YXJ0X2Jsb2NrIC0gb2NmczJfY2x1c3RlcnNf
dG9fYmxvY2tzKHNiLCBjbHVzdGVyKTsNCj4+Pj4+ICvCoMKgwqAgcF9ibG9jayA9IG9jZnMyX2Ns
dXN0ZXJzX3RvX2Jsb2NrcyhzYiwgcF9jbHVzdGVyKSArIG9mZnNldDsNCj4+Pj4+ICvCoMKgwqAg
cmV0dXJuIHNiX2lzc3VlX3plcm9vdXQoc2IsIHBfYmxvY2ssIG5yX2Jsb2NrcywgR0ZQX05PRlMp
Ow0KPj4+Pj4gK30NCj4+Pj4+ICsNCj4+Pj4+IMKgwqAgLyoNCj4+Pj4+IMKgwqDCoCAqIFBhcnRz
IG9mIHRoaXMgZnVuY3Rpb24gdGFrZW4gZnJvbSB4ZnNfY2hhbmdlX2ZpbGVfc3BhY2UoKQ0KPj4+
Pj4gwqDCoMKgICovDQo+Pj4+PiBAQCAtMTg2NSw3ICsxOTA0LDcgQEAgc3RhdGljIGludCBfX29j
ZnMyX2NoYW5nZV9maWxlX3NwYWNlKHN0cnVjdCBmaWxlICpmaWxlLCBzdHJ1Y3QgaW5vZGUgKmlu
b2RlLA0KPj4+Pj4gwqDCoCB7DQo+Pj4+PiDCoMKgwqDCoMKgwqAgaW50IHJldDsNCj4+Pj4+IMKg
wqDCoMKgwqDCoCBzNjQgbGxlbjsNCj4+Pj4+IC3CoMKgwqAgbG9mZl90IHNpemU7DQo+Pj4+PiAr
wqDCoMKgIGxvZmZfdCBzaXplLCBvcmlnX2lzaXplOw0KPj4+Pj4gwqDCoMKgwqDCoMKgIHN0cnVj
dCBvY2ZzMl9zdXBlciAqb3NiID0gT0NGUzJfU0IoaW5vZGUtPmlfc2IpOw0KPj4+Pj4gwqDCoMKg
wqDCoMKgIHN0cnVjdCBidWZmZXJfaGVhZCAqZGlfYmggPSBOVUxMOw0KPj4+Pj4gwqDCoMKgwqDC
oMKgIGhhbmRsZV90ICpoYW5kbGU7DQo+Pj4+PiBAQCAtMTg5Niw2ICsxOTM1LDcgQEAgc3RhdGlj
IGludCBfX29jZnMyX2NoYW5nZV9maWxlX3NwYWNlKHN0cnVjdCBmaWxlICpmaWxlLCBzdHJ1Y3Qg
aW5vZGUgKmlub2RlLA0KPj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqAgZ290byBvdXRfaW5vZGVf
dW5sb2NrOw0KPj4+Pj4gwqDCoMKgwqDCoMKgIH0NCj4+Pj4+IMKgwqAgK8KgwqDCoCBvcmlnX2lz
aXplID0gaV9zaXplX3JlYWQoaW5vZGUpOw0KPj4+Pj4gwqDCoMKgwqDCoMKgIHN3aXRjaCAoc3It
Pmxfd2hlbmNlKSB7DQo+Pj4+PiDCoMKgwqDCoMKgwqAgY2FzZSAwOiAvKlNFRUtfU0VUKi8NCj4+
Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgIGJyZWFrOw0KPj4+Pj4gQEAgLTE5MDMsNyArMTk0Myw3
IEBAIHN0YXRpYyBpbnQgX19vY2ZzMl9jaGFuZ2VfZmlsZV9zcGFjZShzdHJ1Y3QgZmlsZSAqZmls
ZSwgc3RydWN0IGlub2RlICppbm9kZSwNCj4+Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNyLT5s
X3N0YXJ0ICs9IGZfcG9zOw0KPj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqAgYnJlYWs7DQo+Pj4+
PiDCoMKgwqDCoMKgwqAgY2FzZSAyOiAvKlNFRUtfRU5EKi8NCj4+Pj4+IC3CoMKgwqDCoMKgwqDC
oCBzci0+bF9zdGFydCArPSBpX3NpemVfcmVhZChpbm9kZSk7DQo+Pj4+PiArwqDCoMKgwqDCoMKg
wqAgc3ItPmxfc3RhcnQgKz0gb3JpZ19pc2l6ZTsNCj4+Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
IGJyZWFrOw0KPj4+Pj4gwqDCoMKgwqDCoMKgIGRlZmF1bHQ6DQo+Pj4+PiDCoMKgwqDCoMKgwqDC
oMKgwqDCoCByZXQgPSAtRUlOVkFMOw0KPj4+Pj4gQEAgLTE5NTcsNiArMTk5NywxMSBAQCBzdGF0
aWMgaW50IF9fb2NmczJfY2hhbmdlX2ZpbGVfc3BhY2Uoc3RydWN0IGZpbGUgKmZpbGUsIHN0cnVj
dCBpbm9kZSAqaW5vZGUsDQo+Pj4+PiDCoMKgwqDCoMKgwqAgZGVmYXVsdDoNCj4+Pj4+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHJldCA9IC1FSU5WQUw7DQo+Pj4+PiDCoMKgwqDCoMKgwqAgfQ0KPj4+
Pj4gKw0KPj4+Pj4gK8KgwqDCoCAvKiB6ZXJvb3V0IGVvZiBibG9ja3MgaW4gdGhlIGNsdXN0ZXIu
ICovDQo+Pj4+PiArwqDCoMKgIGlmICghcmV0ICYmIGNoYW5nZV9zaXplICYmIG9yaWdfaXNpemUg
PCBzaXplKQ0KPj4+Pj4gK8KgwqDCoMKgwqDCoMKgIHJldCA9IG9jZnMyX3plcm9vdXRfcGFydGlh
bF9jbHVzdGVyKGlub2RlLCBvcmlnX2lzaXplLA0KPj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIHNpemUgLSBvcmlnX2lzaXplKTsNCj4+Pj4+IMKgwqDCoMKgwqDC
oCB1cF93cml0ZSgmT0NGUzJfSShpbm9kZSktPmlwX2FsbG9jX3NlbSk7DQo+Pj4+PiDCoMKgwqDC
oMKgwqAgaWYgKHJldCkgew0KPj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqAgbWxvZ19lcnJubyhy
ZXQpOw0KPj4+Pj4NCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fCk9jZnMyLWRldmVsIG1haWxpbmcgbGlzdApPY2ZzMi1kZXZlbEBvc3Mub3JhY2xlLmNvbQpo
dHRwczovL29zcy5vcmFjbGUuY29tL21haWxtYW4vbGlzdGluZm8vb2NmczItZGV2ZWw=
