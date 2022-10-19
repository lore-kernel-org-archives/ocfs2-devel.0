Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B96FC4332F
	for <ocfs2-devel@archiver.kernel.org>; Wed, 19 Oct 2022 02:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=hgHinNXKeVdIZhuzbURDanqYjM4gxFLvtoZiUPt3KaM=;
 b=2e+QbvYcUnl1MGI8jH+jnnDwjKsj6guRLEjhMat2MOORyt+ohubc9k3lyKL+QEBSSAoeOa5pLM2z
   UYBLSA3CtXhMHJCxFtn6bD1V9Vjwq5GmiXvmFLzFlkRUPMZmgP4p7tp59KA+TIkWgwYNRx6Xv2G2
   cPmFbEioAmcxTnwsB4xZNYilCaCDxcHIlfMB9JL20Nv9iQ4/Et5ppShJLdcyzykJFThc7YzPuil2
   snk+td6+S0E9nBZx7m3kuxcyL5EAgaB12mJ2aPPz1/mknuH18ENDeOx3sxJ4s+KE5YNsqvsfnGwE
   5jQYTVcT7yuSdHb4PjCzwT9xJkZRMjSOx3iKxA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=hgHinNXKeVdIZhuzbURDanqYjM4gxFLvtoZiUPt3KaM=;
 b=HzLZDzbo11W45cpx5wOuZft3nkX7mWXf8vmpBC/a2nQP+e8/Qmj77wKz5KEk45v5oydg6Iyrg6gw
   iwuWg+YajwSH5t8TJvBQ+y1XW32+raopXzoISh1sLi15aNgHyEC0dBgDvY0lrzIXiUUwNGw+snc/
   B0Rn9aUc3q8ZWZY8uUpFPAwVpVrYy+lz2oA6T+u+wUZmpo49Pi51CX2pVB5g3tB05LkqGhCEnKxQ
   30EtujQvrBVlMsuqC19HK3LXMrPu+z3JOHkpxpBxBljQSaWdrDmj4kUUAk+QcIu2EPy3GZAWBCNJ
   Donz3AizwZSen15Bj9FBAbMzlqWPDpw3wlE6bA==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RJZ0001FASD9CB0@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 19 Oct 2022 02:26:37 +0000 (GMT)
Message-id: <1adbbf98-2700-27c8-4aca-9510bca91458@linux.alibaba.com>
Date: Wed, 19 Oct 2022 10:26:15 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.3
To: Yang Yingliang <yangyingliang@huawei.com>, linux-kernel@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
References: <20221018075213.736562-1-yangyingliang@huawei.com>
 <bf27f347-5ced-98e5-f188-659cc2a9736f@linux.alibaba.com>
 <09bb2844-e20a-98e8-c2af-5b6c4795d48e@huawei.com>
 <c7a3bdac-3ed6-e695-5c45-e7007615a4d9@linux.alibaba.com>
 <0db486eb-6927-927e-3629-958f8f211194@huawei.com>
Content-language: en-US
In-reply-to: <0db486eb-6927-927e-3629-958f8f211194@huawei.com>
X-Source-IP: 115.124.30.130
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10504
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 priorityscore=1501 bulkscore=0 clxscore=-8 mlxscore=0 lowpriorityscore=0
 impostorscore=0 adultscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210190011 domainage_hfrom=8588
Cc: gregkh@linuxfoundation.org
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: possible memory leak in
	mlog_sys_init()
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R661e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018045176;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=7; SR=0;
 TI=SMTPD_---0VSYJtJM_1666146375;
X-ServerName: out30-130.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: QymL1e6gnjE7LA3-IBLbd7i8bdTAtDO1
X-Proofpoint-GUID: QymL1e6gnjE7LA3-IBLbd7i8bdTAtDO1
Reporting-Meta:
 AAGJfDpudEcL/pZ8zr/1bevqBM5/bTyZv04eqHjHfeXf0tAK50SBZJxJJimCxoyl
 1q8plvbB+VHrMOUuVYDQY7ljUdYcwhCfAHHmwT8nVdC7fvdl7AB5lbS6ejNDykQi
 2QIn9DrBf1y3z+1GBaEvpTZaszNylo8ZCoKujY2aVmF76Frq/+BjQSuvb1ZZhk6b
 e+/AKErEqNg0485h4gWyQjJOAIX1z/VxgAXBMxgu+0+hBnzQ09U3yVFzX5DeWYqZ
 xIsqQQtoZd4lHx0I8eThPp8ILd4VP3qxro2Hy3ke0VmAErthtRLKa7Ngrms67MKS
 pp+SZ8Vna/f8o8lPfxJ3pG6sgY8SCeZCv70ZZiUkT5PgE1foFhuU3aqLaCWr6zZV
 vzD6F1F+2NwdeXATxgWhL9C/3ZDXa7H5V7xtqBfHkOzk2oRZly4T8PKolJh1WvfG
 kMzevgJqDJIWmJG26TLoAihx1vuI8/d9ZRktWA23Gezr6Z3WHLLRBkct0WN6V0C3
 FzNpECzZTBl4tUM+fp9I9qzfX6FdYa/aZn4pO9XJECs=

CgpPbiAxMC8xOC8yMiAxMDoyOCBQTSwgWWFuZyBZaW5nbGlhbmcgd3JvdGU6Cj4gCj4gT24gMjAy
Mi8xMC8xOCAyMTozOSwgSm9zZXBoIFFpIHdyb3RlOgo+Pgo+PiBPbiAxMC8xOC8yMiA2OjMzIFBN
LCBZYW5nIFlpbmdsaWFuZyB3cm90ZToKPj4+IEhpLAo+Pj4KPj4+IE9uIDIwMjIvMTAvMTggMTc6
MDIsIEpvc2VwaCBRaSB3cm90ZToKPj4+PiBIaSwKPj4+Pgo+Pj4+IE9uIDEwLzE4LzIyIDM6NTIg
UE0sIFlhbmcgWWluZ2xpYW5nIHdyb3RlOgo+Pj4+PiBJbmplY3QgZmF1bHQgd2hpbGUgcHJvYmlu
ZyBtb2R1bGUsIGtzZXRfcmVnaXN0ZXIoKSBtYXkgZmFpbCwKPj4+Pj4gaWYgaXQgZmFpbHMsIGJ1
dCB0aGUgcmVmY291bnQgb2Yga29iamVjdCBpcyBub3QgZGVjcmVhc2VkIHRvCj4+Pj4+IDAsIHRo
ZSBuYW1lIGFsbG9jYXRlZCBpbiBrb2JqZWN0X3NldF9uYW1lKCkgaXMgbGVha2VkLiBGaXgKPj4+
Pj4gdGhpcyBieSBjYWxsaW5nIGtzZXRfcHV0KCksIHNvIHRoYXQgbmFtZSBjYW4gYmUgZnJlZWQg
aW4KPj4+Pj4gY2FsbGJhY2sgZnVuY3Rpb24ga29iamVjdF9jbGVhbnVwKCkuCj4+Pj4+Cj4+Pj4+
IHVucmVmZXJlbmNlZCBvYmplY3QgMHhmZmZmODg4MTAwZGE5MzQ4IChzaXplIDgpOgo+Pj4+PiDC
oMKgwqAgY29tbSAibW9kcHJvYmUiLCBwaWQgMjU3LCBqaWZmaWVzIDQyOTQ3MDEwOTYgKGFnZSAz
My4zMzRzKQo+Pj4+PiDCoMKgwqAgaGV4IGR1bXAgKGZpcnN0IDggYnl0ZXMpOgo+Pj4+PiDCoMKg
wqDCoMKgIDZjIDZmIDY3IDZkIDYxIDczIDZiIDAwwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbG9nbWFzay4KPj4+Pj4gwqDCoMKgIGJhY2t0cmFjZToK
Pj4+Pj4gwqDCoMKgwqDCoCBbPDAwMDAwMDAwMzA2ZTQ0MWM+XSBfX2ttYWxsb2Nfbm9kZV90cmFj
a19jYWxsZXIrMHg0NC8weDFiMAo+Pj4+PiDCoMKgwqDCoMKgIFs8MDAwMDAwMDA3YzQ5MWE5ZT5d
IGtzdHJkdXArMHgzYS8weDcwCj4+Pj4+IMKgwqDCoMKgwqAgWzwwMDAwMDAwMDE1NzE5YTNiPl0g
a3N0cmR1cF9jb25zdCsweDYzLzB4ODAKPj4+Pj4gwqDCoMKgwqDCoCBbPDAwMDAwMDAwODRlNDU4
ZWE+XSBrdmFzcHJpbnRmX2NvbnN0KzB4MTQ5LzB4MTgwCj4+Pj4+IMKgwqDCoMKgwqAgWzwwMDAw
MDAwMDkxMzAyYjQyPl0ga29iamVjdF9zZXRfbmFtZV92YXJncysweDU2LzB4MTUwCj4+Pj4+IMKg
wqDCoMKgwqAgWzwwMDAwMDAwMDVmNDhlZWFjPl0ga29iamVjdF9zZXRfbmFtZSsweGFiLzB4ZTAK
Pj4+Pj4KPj4+Pj4gRml4ZXM6IDM0OTgwY2E4ZmFlYiAoIkRyaXZlcnM6IGNsZWFuIHVwIGRpcmVj
dCBzZXR0aW5nIG9mIHRoZSBuYW1lIG9mIGEga3NldCIpCj4+Pj4+IFNpZ25lZC1vZmYtYnk6IFlh
bmcgWWluZ2xpYW5nIDx5YW5neWluZ2xpYW5nQGh1YXdlaS5jb20+Cj4+Pj4+IC0tLQo+Pj4+PiDC
oMKgIGZzL29jZnMyL2NsdXN0ZXIvbWFza2xvZy5jIHwgNyArKysrKystCj4+Pj4+IMKgwqAgMSBm
aWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQo+Pj4+Pgo+Pj4+PiBk
aWZmIC0tZ2l0IGEvZnMvb2NmczIvY2x1c3Rlci9tYXNrbG9nLmMgYi9mcy9vY2ZzMi9jbHVzdGVy
L21hc2tsb2cuYwo+Pj4+PiBpbmRleCA1NjM4ODFkZGJmMDAuLjdmOWJhODE2ZDk1NSAxMDA2NDQK
Pj4+Pj4gLS0tIGEvZnMvb2NmczIvY2x1c3Rlci9tYXNrbG9nLmMKPj4+Pj4gKysrIGIvZnMvb2Nm
czIvY2x1c3Rlci9tYXNrbG9nLmMKPj4+Pj4gQEAgLTE1Niw2ICsxNTYsNyBAQCBzdGF0aWMgc3Ry
dWN0IGtzZXQgbWxvZ19rc2V0ID0gewo+Pj4+PiDCoMKgIGludCBtbG9nX3N5c19pbml0KHN0cnVj
dCBrc2V0ICpvMmNiX2tzZXQpCj4+Pj4+IMKgwqAgewo+Pj4+PiDCoMKgwqDCoMKgwqAgaW50IGkg
PSAwOwo+Pj4+PiArwqDCoMKgIGludCByZXQ7Cj4+Pj4+IMKgwqAgwqDCoMKgwqDCoCB3aGlsZSAo
bWxvZ19hdHRyc1tpXS5hdHRyLm1vZGUpIHsKPj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqAgbWxv
Z19kZWZhdWx0X2F0dHJzW2ldID0gJm1sb2dfYXR0cnNbaV0uYXR0cjsKPj4+Pj4gQEAgLTE2NSw3
ICsxNjYsMTEgQEAgaW50IG1sb2dfc3lzX2luaXQoc3RydWN0IGtzZXQgKm8yY2Jfa3NldCkKPj4+
Pj4gwqDCoCDCoMKgwqDCoMKgIGtvYmplY3Rfc2V0X25hbWUoJm1sb2dfa3NldC5rb2JqLCAibG9n
bWFzayIpOwo+Pj4+PiDCoMKgwqDCoMKgwqAgbWxvZ19rc2V0LmtvYmoua3NldCA9IG8yY2Jfa3Nl
dDsKPj4+Pj4gLcKgwqDCoCByZXR1cm4ga3NldF9yZWdpc3RlcigmbWxvZ19rc2V0KTsKPj4+Pj4g
K8KgwqDCoCByZXQgPSBrc2V0X3JlZ2lzdGVyKCZtbG9nX2tzZXQpOwo+Pj4+IElmIHJlZ2lzdGVy
IGZhaWxzLCBpdCB3aWxsIGNhbGwgdW5yZWdpc3RlciBpbiBvMmNiX3N5c19pbml0KCksIHdoaWNo
Cj4+Pj4gd2lsbCBwdXQga29iamVjdC4KPj4+IFRoZXkgYXJlIGRpZmZlcmVudCBrc2V0cywgdGhl
IGtzZXQgdW5yZWdpc3RlcmVkIGluIG8yY2Jfc3lzX2luaXQoKSBpcyAnbzJjYl9rc2V0JywgdGhl
Cj4+PiBrc2V0IHVzZWQgdG8gcmVnaXN0ZXJlZCBpbiBtbG9nX3N5c19pbml0KCkgaXMgJ21sb2df
a3NldCcsIGFuZCB0aGV5IGhvbGQgZGlmZmVyZW5jZQo+Pj4gcmVmY291bnRzLgo+Pj4gWWVzLCB5
b3UgYXJlIHJpZ2h0LiBJJ3ZlIG1peGVkIHRoZSB0d28ga3NldHMgdXAuCj4+IEluIHRoZW9yeSwg
a3NldF9yZWdpc3RlcigpIG1heSByZXR1cm4gZXJyb3IgYmVjYXVzZSBvZiBhIE5VTEwga3NldCwg
c28KPj4gaGVyZSB3ZSBtYXkgbm90IGNhbGwga3NldF9wdXQoKSBkaXJlY3RseSwgSSdtIG5vdCBz
dXJlIGlmIGEgc3RhdGljCj4+IGNoZWNrZXIgd2lsbCBoYXBweS4KPj4gVGhvdWdoIHRoaXMgY2Fu
J3QgaGFwcGVuIHNpbmNlIGl0J3MgYWxyZWFkeSBzdGF0aWNhbGx5IGFsbG9jYXRlZC4uLgo+IGtz
ZXRfcmVnaXN0ZXIoKSBtYXkgZmFpbCBpZiBrb2JqZWN0X2FkZF9pbnRlcm5hbCgpIHJldHVybiBl
cnJvciAoY2FuJ3QgYWxsb2NhdGUgbWVtb3J5KSwgdGhlIG5hbWUKPiAibG9nbWFzayIgaXMgZHlu
YW1pY2FsbHkgYWxsb2N0YXRlZCB3aGlsZSBvY2ZzMiBpcyBjb21waWxlIGFzIG1vZHVsZSBhbmQg
aW5zZXJ0IGl0IChpZiBvY2ZzMiBpcwo+IGJ1aWx0IGluIGtlcm5lbCwgdGhlIG5hbWUgaXMgY29u
c3RhbnQsIGl0IHdvbid0IGNhdXNlIGEgbGVhayksIHNvIHRoZSBuYW1lIGNhbiBiZSBsZWFrZWQu
CgpXaGF0IEkgbWVhbiBpcyBrc2V0X3JlZ2lzdGVyKCkgbWF5IGZhaWwgd2l0aCBtYW55IHJlYXNv
bnMsIG9yIGV2ZW4Kd2l0aG91dCBrc2V0X2luaXQoKS4KSSB3b25kZXIgaWYgd2UgaGF2ZSB0byBo
YW5kbGUgdGhpcyBpbnRlcm5hbCBrc2V0X3JlZ2lzdGVyKCksIGJ1dCBub3QKbGVhdmUgaXQgdG8g
Y2FsbGVyLiBUaGlzIG1heSBiZW5lZml0IG90aGVyIGNhbGxlcnMgYXMgd2VsbC4KClNvbWV0aGlu
ZyBsaWtlOgplcnIgPSBrb2JqZWN0X2FkZF9pbnRlcm5hbCgmay0+a29iaik7CmlmIChlcnIpIHsK
CWtzZXRfcHV0KGspOwoJcmV0dXJuIGVycjsKfQoKVGhhbmtzLApKb3NlcGgKCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCk9jZnMyLWRldmVsIG1haWxpbmcg
bGlzdApPY2ZzMi1kZXZlbEBvc3Mub3JhY2xlLmNvbQpodHRwczovL29zcy5vcmFjbGUuY29tL21h
aWxtYW4vbGlzdGluZm8vb2NmczItZGV2ZWw=
