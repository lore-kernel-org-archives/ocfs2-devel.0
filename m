Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BDA9C433F5
	for <ocfs2-devel@archiver.kernel.org>; Thu, 20 Jan 2022 08:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=n3lNilTlPTaLnGpkKdTmSselgetUun49LUNmrKDZdaU=;
 b=lBWLfCU99T9KQ6YLlbUefjgya7sLlK+0u71acw+LY//gF4+pEDZSsp05p4hu/uaBkUD7uorJoFW4
   /JaRpoBVPOrwR1k9nNZ8wg+jyQTsFCPKgxKw9UuDOJ6n4M256Lm/HAiOtNeqIAn6mmcMxabF5tXq
   Gup6zcKvYuIwF8uLx9R8b1cYTt1KCBe2iH9/p6gC9EnkuAQlT7E2yVOoRFix8yPsujhMBVyWEqwh
   eb0lPZL8IMCPXk1YZOnSPn4fv7/Hyixrq+BlfnINCnVBe46ru0KEWsfnfyw4AqpmOaiHRVrMLxDX
   AojmlCqduFglLk1NC8ijHdnbiaCimxyRLoq64Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=n3lNilTlPTaLnGpkKdTmSselgetUun49LUNmrKDZdaU=;
 b=Cen242vMojG82HtS9kaHOt6soXIl8VrwGntfKjNlHR/UuDwBeO/Mc2BjzeAGxFhess9vu7Z986tV
   Vpe/z/m6qveAAGPw8TKyj9Z++rx13J269GlcUFPm3Al8lcwPJICRjYBHZrS9FFRYSZ1mX5pA22/H
   kuKUiIwkoH0YWHByBkblGc5gm7c0hsT6DsKHS29aAmc7CyUyUdt3Nbygcvgoy3IKPr94vCcdpEQf
   ZG9z9E9EQhR/xZDFmKcWpDeLNgMjAOoClxbNQu4dgWgL+xSSqnltNMG5CWns7Keedr8ukCrzdHKK
   L00nQXV/81c5oe/oqRFOG5O7Ffa/HIfvWRGBug==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220104 64bit (built Jan  4
 2022))
 with ESMTPS id <0R6000F2G17PWPC0@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 20 Jan 2022 08:07:01 +0000 (GMT)
Authentication-results: aserp3010.oracle.com; spf=fail
 smtp.mailfrom=joseph.qi@linux.alibaba.com; dmarc=none
 header.from=linux.alibaba.com
Message-id: <6182eaf6-9f24-609a-ea07-4ad385576aa1@linux.alibaba.com>
Date: Thu, 20 Jan 2022 16:06:34 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Content-language: en-US
To: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>,
 junxiao.bi@oracle.com, rajesh.sivaramasubramaniom@oracle.com,
 ocfs2-devel@oss.oracle.com
References:
 <1642658834-18657-1-git-send-email-gautham.ananthakrishna@oracle.com>
In-reply-to:
 <1642658834-18657-1-git-send-email-gautham.ananthakrishna@oracle.com>
X-Source-IP: 47.88.44.36
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10232
 signatures=668683
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 bulkscore=0 malwarescore=0 spamscore=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 clxscore=164 priorityscore=0 adultscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201200042 domainage_hfrom=8316
Subject: Re: [Ocfs2-devel] [PATCH RFC 1/1] ocfs2: fix a deadlock caused by
 commit 6f1b228529ae49b0
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
From: Joseph Qi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Joseph Qi <joseph.qi@linux.alibaba.com>
Content-type: text/plain; charset="utf-8"
Content-transfer-encoding: base64
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R791e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04394;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=4; SR=0;
 TI=SMTPD_---0V2LmSm1_1642665994;
X-ServerName: out4436.biz.mail.alibaba.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: pMFeEJ1n4nZJzlTs3kZmvQdA5VXIx1eE
X-Proofpoint-ORIG-GUID: pMFeEJ1n4nZJzlTs3kZmvQdA5VXIx1eE
Reporting-Meta:
 AAGT8HymoysC/+j+RSGtZiYPH7iG3WYBbaH0eD0JyUc237Apt/lzrDrQy9cMY6dq
 Vxg7OwHIoW8jScblJbIqOFvO7WiZRITepm7HKY+ISxoM5boLtFSrbcusnbp/btB3
 tcq9jO7hM3XCqnoGxu0vGpqo0cVX1xCxq50qWKSeoAD55crYYtd06zsmESCFJvjB
 hqYx9OlDU1CICk69285P9oLilm2DWrVPBnIRe+Uo2yNtBIFMIxXyg7UuQUIsF5gq
 Sb2PL0IykUR7qE3oGRgQoRQjhfdLGhg1sdWnoPFVrD2K7su0L2qz/ojWyD/xKGYX
 i/SsDn/HHwmQ3Is5IASujwAPlYvKevkOSy6YHKG6CWilEKCDf1OrLQUS2BhebSM2
 zAFqzWKfE5JGyBKZhZ8sASPFIC19fl4D8GqTn2C8OdRU1eGB31z+32IHHnsjKCaI
 QOkheQXYoetT7dnVMiiq1kdXVLILD+OyWjnMrhvT//2z0rahOqjQuEmsPJt5+Ygr
 35jaTzJCDh27BJYw42yGNHsISf5jjmPcqkfbR7iFrXo=

CgpPbiAxLzIwLzIyIDI6MDcgUE0sIEdhdXRoYW0gQW5hbnRoYWtyaXNobmEgd3JvdGU6Cj4gY29t
bWl0IDZmMWIyMjg1MjlhZTQ5YjBmODVhYjg5YmNkYjZjMzY1ZGY0MDE1NTggY2F1c2VkIGEgZGVh
ZGxvY2sKPiB3aGljaCB3YXMgdW5jb3ZlcmVkIGJ5IG91ciBpbnRlcm5hbCB0ZXN0cy4gVGhlIGRl
YWRsb2NrIGlzIGFzIGZvb2xsb3dzOgoKdHlwbywgcy9mb29sbG93cy9mb2xsb3dzCj4gCj4gVGFz
ayAxOgo+IEExKSBqYmQyX2pvdXJuYWxfY29tbWl0X3RyYW5zYWN0aW9uKCkKPiBBMikgICAgICAg
ICBzcGluX2xvY2soJmpoLT5iX3N0YXRlX2xvY2spOwo+IEEzKSAgICAgICAgIF9famJkMl9qb3Vy
bmFsX3JlbW92ZV9jaGVja3BvaW50KCkKPiBBNCkgICAgICAgICAgICAgICAgICAgICAgICAgamJk
Ml9qb3VybmFsX3B1dF9qb3VybmFsX2hlYWQoKQo+IEE1KSAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgamJkX2xvY2tfYmhfam91cm5hbF9oZWFkKCkKPiAKPiBUYXNrIDI6
Cj4gQjEpIG9jZnMyX3Rlc3RfYmdfYml0X2FsbG9jYXRhYmxlKCkKPiBCMikgICAgICAgICBqYmRf
bG9ja19iaF9qb3VybmFsX2hlYWQoKQo+IEIzKSAgICAgICAgIHNwaW5fbG9jaygmamgtPmJfc3Rh
dGVfbG9jayk7Cj4gCj4gQTEtPkEyLT5BMy0+QTQtPkIxLT5CMi0+QjMoYmxvY2tlZCktPkE1KGJs
b2NrZWQpCj4gCj4gTm93IGNhdXNlIHByb2Nlc3MgMiBoYXMgdGhlIGpiZCBsb2NrLCBpdCBkb2Vz
buKAmXQgbGV0IHByb2Nlc3MgMSB0byBjb250aW51ZSBhZnRlciBBNS4KPiBQcm9jZXNzIDIgbm93
IGlzIHdhaXRpbmcgZm9yIGJfc3RhdGVfbG9jayB0byBiZSByZWxlYXNlZCBieSBwcm9jZXNzIDEu
Cj4gCj4gVGhpcyBwYXRjaCByZXNvbHZlcyB0aGUgZGVhZGxvY2suCj4gCj4gU2lnbmVkLW9mZi1i
eTogR2F1dGhhbSBBbmFudGhha3Jpc2huYSA8Z2F1dGhhbS5hbmFudGhha3Jpc2huYUBvcmFjbGUu
Y29tPgo+IC0tLQo+ICBmcy9vY2ZzMi9zdWJhbGxvYy5jIHwgNCArKy0tCj4gIDEgZmlsZSBjaGFu
Z2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCj4gCj4gZGlmZiAtLWdpdCBhL2Zz
L29jZnMyL3N1YmFsbG9jLmMgYi9mcy9vY2ZzMi9zdWJhbGxvYy5jCj4gaW5kZXggNDgxMDE3ZS4u
ZmQ5OTU4NzAgMTAwNjQ0Cj4gLS0tIGEvZnMvb2NmczIvc3ViYWxsb2MuYwo+ICsrKyBiL2ZzL29j
ZnMyL3N1YmFsbG9jLmMKPiBAQCAtMTI1OSw3ICsxMjU5LDcgQEAgc3RhdGljIGludCBvY2ZzMl90
ZXN0X2JnX2JpdF9hbGxvY2F0YWJsZShzdHJ1Y3QgYnVmZmVyX2hlYWQgKmJnX2JoLAo+ICAJaWYg
KCFidWZmZXJfamJkKGJnX2JoKSkKPiAgCQlyZXR1cm4gMTsKPiAgCj4gLQlqYmRfbG9ja19iaF9q
b3VybmFsX2hlYWQoYmdfYmgpOwo+ICsJamJkMl9qb3VybmFsX2dyYWJfam91cm5hbF9oZWFkKGJn
X2JoKTsKClNlZW1zIHdlIGhhdmUgdG8gY2hlY2sgdGhlIHJldHVybmVkICdqaCcgaGVyZS4KSWYg
TlVMTCwgd2UgY2FuIGZpbmlzaCB0aGUgYml0IHRlc3QgZWFybGllciwgZWxzZSB3ZSBjYW4gdXNl
IHRoaXMgJ2poJyBkaXJlY3RseS4KQW5kIHRoZSBmb2xsb3dpbmcgY2hlY2sgd2l0aG91dCBiaCBs
b2NrIGlzIHVuc2FmZS4KClRoYW5rcywKSm9zZXBoCgo+ICAJaWYgKGJ1ZmZlcl9qYmQoYmdfYmgp
KSB7Cj4gIAkJamggPSBiaDJqaChiZ19iaCk7Cj4gIAkJc3Bpbl9sb2NrKCZqaC0+Yl9zdGF0ZV9s
b2NrKTsKPiBAQCAtMTI3MCw3ICsxMjcwLDcgQEAgc3RhdGljIGludCBvY2ZzMl90ZXN0X2JnX2Jp
dF9hbGxvY2F0YWJsZShzdHJ1Y3QgYnVmZmVyX2hlYWQgKmJnX2JoLAo+ICAJCQlyZXQgPSAxOwo+
ICAJCXNwaW5fdW5sb2NrKCZqaC0+Yl9zdGF0ZV9sb2NrKTsKPiAgCX0KPiAtCWpiZF91bmxvY2tf
Ymhfam91cm5hbF9oZWFkKGJnX2JoKTsKPiArCWpiZDJfam91cm5hbF9wdXRfam91cm5hbF9oZWFk
KGJnX2JoKTsKPiAgCj4gIAlyZXR1cm4gcmV0Owo+ICB9CgpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwpPY2ZzMi1kZXZlbCBtYWlsaW5nIGxpc3QKT2NmczIt
ZGV2ZWxAb3NzLm9yYWNsZS5jb20KaHR0cHM6Ly9vc3Mub3JhY2xlLmNvbS9tYWlsbWFuL2xpc3Rp
bmZvL29jZnMyLWRldmVs
