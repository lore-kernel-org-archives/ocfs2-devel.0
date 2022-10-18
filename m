Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C5D2C433FE
	for <ocfs2-devel@archiver.kernel.org>; Tue, 18 Oct 2022 13:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=c09gIYpNtL244DZ6OTdTUHzcGsKEBzaL5j0CXQEFZyY=;
 b=1cek3dIyVXRTKCoOTcotr4A8l5nQNWcazuzcDDDlk80zpzjrAMMbqc7bz+1ueeExvvCKNqcehvzE
   Rd8zrWFMDTGLLzuLVEuuCJvSKVKhlCSgjLNnumOXPmQLgr3U+NoXnoQFiLpUmLaxwqYeXBdb+FPj
   C6cXrc4s0EMCBlY9hyXCiF+DCddX+6qzH7dGJS+K2fzDIcz2KYwDDt+O6B01hmpZWpRpCTF8LYCQ
   3tKm+fEZK4IFtV1PP14pekaWI9BHXveUbXyDuhB0Ta2YtaZ9hqEQDQKSXA4nBLTQpKh/otY602Px
   1zm0l0d8BckdOi3WN/MjF3lfKHK8nQFGYG/39w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=c09gIYpNtL244DZ6OTdTUHzcGsKEBzaL5j0CXQEFZyY=;
 b=frFWMTyDRtPN/wrJNEvpTWPBkWhHgoX/2Bi9SPOAT9z963rikcHOK6uY8mRTqkdJjp9CTnLbBxKA
   RT4eJ7kK6mxebMxKvbERTMHo7jQS2WEI71TOpA6RAs2jJAxTLm4VBTrN8iMoQp80ICaRVJf8tFVG
   W01FvCogRycvxhICuvy+1U+AXMTpXYsTpZxdvXH2EijfjKrY/EaMlSd7JFQ1MM19lrDcDEsDBeL4
   aI7m98Sj/NErK5H6i8mQV2VPZ4W70oZow3QZK5+Ki5LB5Ki3uwNzMW/6NWbuRWOhGDmw3457JN8p
   MKhQWGIOF3Rlh4xI+xpFjs7mPBu3htrCxTxaLg==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RJY0039PBAQFX50@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 18 Oct 2022 13:40:02 +0000 (GMT)
Message-id: <c7a3bdac-3ed6-e695-5c45-e7007615a4d9@linux.alibaba.com>
Date: Tue, 18 Oct 2022 21:39:36 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.3
Content-language: en-US
To: Yang Yingliang <yangyingliang@huawei.com>, linux-kernel@vger.kernel.org,
 ocfs2-devel@oss.oracle.com
References: <20221018075213.736562-1-yangyingliang@huawei.com>
 <bf27f347-5ced-98e5-f188-659cc2a9736f@linux.alibaba.com>
 <09bb2844-e20a-98e8-c2af-5b6c4795d48e@huawei.com>
In-reply-to: <09bb2844-e20a-98e8-c2af-5b6c4795d48e@huawei.com>
X-Source-IP: 115.124.30.130
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10504
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 spamscore=0
 lowpriorityscore=0 clxscore=18 impostorscore=0 priorityscore=199 phishscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210180077 domainage_hfrom=8587
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R131e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046060;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=7; SR=0;
 TI=SMTPD_---0VSWMbx8_1666100376;
X-ServerName: out30-130.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: izFEEhLvj0OdMxQ5fCnNl_i_Pq3s4iVw
X-Proofpoint-GUID: izFEEhLvj0OdMxQ5fCnNl_i_Pq3s4iVw
Reporting-Meta:
 AAEWDXVOKKyiejcJkC4P49H8mxsOZATaviv7gfeEUQGPMPb4/1mbJh18MdBknX7C
 J9hEWJCPdOagejpfIkgnfqxZyi1D8iTVeqg9BmFmxy6+1kpFrVAGF2VCKr+LzzWI
 O8eEtv/I7NpaysvQNve11duOrQp/baDJ73Lmyt/k94e4ZNDj3CsKZ+guSNcXpw7G
 M0X1UgJXo4c8XPMvUqVkwu4WcFcI+OWQx0DpQjpuvRdXC8h9c81zShuyb01WtyJr
 0XQL7vw7W0EIKhop2pSk5pfWuNsIOCF+rNeCEg2b07BfJ+Z7/FPlsbX+/5eXam1u
 /6aPi+cs8UIPP8lxa3TkgT/JlYox6noD4GMxYsJ8yJUn8xs40IYJUrNqv+4DUore
 3obV54xXoc9WU8bmD6SMFnc8cwOfuwxiv1XAJy4EcVsl8AiUr/LUHa7tHkQo0kCb
 nIubxHz7rKuzKLFFEd6mQSAyxq1jkrbc4n9Q+Dq0ID9GnHav5BwQ6r0O0nvHVJ2c
 OSorLyG59HJ4GckHhXhtPv+GI8Lqggi/UveDzUXIhxdH

CgpPbiAxMC8xOC8yMiA2OjMzIFBNLCBZYW5nIFlpbmdsaWFuZyB3cm90ZToKPiBIaSwKPiAKPiBP
biAyMDIyLzEwLzE4IDE3OjAyLCBKb3NlcGggUWkgd3JvdGU6Cj4+IEhpLAo+Pgo+PiBPbiAxMC8x
OC8yMiAzOjUyIFBNLCBZYW5nIFlpbmdsaWFuZyB3cm90ZToKPj4+IEluamVjdCBmYXVsdCB3aGls
ZSBwcm9iaW5nIG1vZHVsZSwga3NldF9yZWdpc3RlcigpIG1heSBmYWlsLAo+Pj4gaWYgaXQgZmFp
bHMsIGJ1dCB0aGUgcmVmY291bnQgb2Yga29iamVjdCBpcyBub3QgZGVjcmVhc2VkIHRvCj4+PiAw
LCB0aGUgbmFtZSBhbGxvY2F0ZWQgaW4ga29iamVjdF9zZXRfbmFtZSgpIGlzIGxlYWtlZC4gRml4
Cj4+PiB0aGlzIGJ5IGNhbGxpbmcga3NldF9wdXQoKSwgc28gdGhhdCBuYW1lIGNhbiBiZSBmcmVl
ZCBpbgo+Pj4gY2FsbGJhY2sgZnVuY3Rpb24ga29iamVjdF9jbGVhbnVwKCkuCj4+Pgo+Pj4gdW5y
ZWZlcmVuY2VkIG9iamVjdCAweGZmZmY4ODgxMDBkYTkzNDggKHNpemUgOCk6Cj4+PiDCoMKgIGNv
bW0gIm1vZHByb2JlIiwgcGlkIDI1NywgamlmZmllcyA0Mjk0NzAxMDk2IChhZ2UgMzMuMzM0cykK
Pj4+IMKgwqAgaGV4IGR1bXAgKGZpcnN0IDggYnl0ZXMpOgo+Pj4gwqDCoMKgwqAgNmMgNmYgNjcg
NmQgNjEgNzMgNmIgMDDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBsb2dtYXNrLgo+Pj4gwqDCoCBiYWNrdHJhY2U6Cj4+PiDCoMKgwqDCoCBbPDAwMDAw
MDAwMzA2ZTQ0MWM+XSBfX2ttYWxsb2Nfbm9kZV90cmFja19jYWxsZXIrMHg0NC8weDFiMAo+Pj4g
wqDCoMKgwqAgWzwwMDAwMDAwMDdjNDkxYTllPl0ga3N0cmR1cCsweDNhLzB4NzAKPj4+IMKgwqDC
oMKgIFs8MDAwMDAwMDAxNTcxOWEzYj5dIGtzdHJkdXBfY29uc3QrMHg2My8weDgwCj4+PiDCoMKg
wqDCoCBbPDAwMDAwMDAwODRlNDU4ZWE+XSBrdmFzcHJpbnRmX2NvbnN0KzB4MTQ5LzB4MTgwCj4+
PiDCoMKgwqDCoCBbPDAwMDAwMDAwOTEzMDJiNDI+XSBrb2JqZWN0X3NldF9uYW1lX3ZhcmdzKzB4
NTYvMHgxNTAKPj4+IMKgwqDCoMKgIFs8MDAwMDAwMDA1ZjQ4ZWVhYz5dIGtvYmplY3Rfc2V0X25h
bWUrMHhhYi8weGUwCj4+Pgo+Pj4gRml4ZXM6IDM0OTgwY2E4ZmFlYiAoIkRyaXZlcnM6IGNsZWFu
IHVwIGRpcmVjdCBzZXR0aW5nIG9mIHRoZSBuYW1lIG9mIGEga3NldCIpCj4+PiBTaWduZWQtb2Zm
LWJ5OiBZYW5nIFlpbmdsaWFuZyA8eWFuZ3lpbmdsaWFuZ0BodWF3ZWkuY29tPgo+Pj4gLS0tCj4+
PiDCoCBmcy9vY2ZzMi9jbHVzdGVyL21hc2tsb2cuYyB8IDcgKysrKysrLQo+Pj4gwqAgMSBmaWxl
IGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQo+Pj4KPj4+IGRpZmYgLS1n
aXQgYS9mcy9vY2ZzMi9jbHVzdGVyL21hc2tsb2cuYyBiL2ZzL29jZnMyL2NsdXN0ZXIvbWFza2xv
Zy5jCj4+PiBpbmRleCA1NjM4ODFkZGJmMDAuLjdmOWJhODE2ZDk1NSAxMDA2NDQKPj4+IC0tLSBh
L2ZzL29jZnMyL2NsdXN0ZXIvbWFza2xvZy5jCj4+PiArKysgYi9mcy9vY2ZzMi9jbHVzdGVyL21h
c2tsb2cuYwo+Pj4gQEAgLTE1Niw2ICsxNTYsNyBAQCBzdGF0aWMgc3RydWN0IGtzZXQgbWxvZ19r
c2V0ID0gewo+Pj4gwqAgaW50IG1sb2dfc3lzX2luaXQoc3RydWN0IGtzZXQgKm8yY2Jfa3NldCkK
Pj4+IMKgIHsKPj4+IMKgwqDCoMKgwqAgaW50IGkgPSAwOwo+Pj4gK8KgwqDCoCBpbnQgcmV0Owo+
Pj4gwqAgwqDCoMKgwqDCoCB3aGlsZSAobWxvZ19hdHRyc1tpXS5hdHRyLm1vZGUpIHsKPj4+IMKg
wqDCoMKgwqDCoMKgwqDCoCBtbG9nX2RlZmF1bHRfYXR0cnNbaV0gPSAmbWxvZ19hdHRyc1tpXS5h
dHRyOwo+Pj4gQEAgLTE2NSw3ICsxNjYsMTEgQEAgaW50IG1sb2dfc3lzX2luaXQoc3RydWN0IGtz
ZXQgKm8yY2Jfa3NldCkKPj4+IMKgIMKgwqDCoMKgwqAga29iamVjdF9zZXRfbmFtZSgmbWxvZ19r
c2V0LmtvYmosICJsb2dtYXNrIik7Cj4+PiDCoMKgwqDCoMKgIG1sb2dfa3NldC5rb2JqLmtzZXQg
PSBvMmNiX2tzZXQ7Cj4+PiAtwqDCoMKgIHJldHVybiBrc2V0X3JlZ2lzdGVyKCZtbG9nX2tzZXQp
Owo+Pj4gK8KgwqDCoCByZXQgPSBrc2V0X3JlZ2lzdGVyKCZtbG9nX2tzZXQpOwo+PiBJZiByZWdp
c3RlciBmYWlscywgaXQgd2lsbCBjYWxsIHVucmVnaXN0ZXIgaW4gbzJjYl9zeXNfaW5pdCgpLCB3
aGljaAo+PiB3aWxsIHB1dCBrb2JqZWN0Lgo+IFRoZXkgYXJlIGRpZmZlcmVudCBrc2V0cywgdGhl
IGtzZXQgdW5yZWdpc3RlcmVkIGluIG8yY2Jfc3lzX2luaXQoKSBpcyAnbzJjYl9rc2V0JywgdGhl
Cj4ga3NldCB1c2VkIHRvIHJlZ2lzdGVyZWQgaW4gbWxvZ19zeXNfaW5pdCgpIGlzICdtbG9nX2tz
ZXQnLCBhbmQgdGhleSBob2xkIGRpZmZlcmVuY2UKPiByZWZjb3VudHMuCj4gWWVzLCB5b3UgYXJl
IHJpZ2h0LiBJJ3ZlIG1peGVkIHRoZSB0d28ga3NldHMgdXAuCkluIHRoZW9yeSwga3NldF9yZWdp
c3RlcigpIG1heSByZXR1cm4gZXJyb3IgYmVjYXVzZSBvZiBhIE5VTEwga3NldCwgc28KaGVyZSB3
ZSBtYXkgbm90IGNhbGwga3NldF9wdXQoKSBkaXJlY3RseSwgSSdtIG5vdCBzdXJlIGlmIGEgc3Rh
dGljCmNoZWNrZXIgd2lsbCBoYXBweS4KVGhvdWdoIHRoaXMgY2FuJ3QgaGFwcGVuIHNpbmNlIGl0
J3MgYWxyZWFkeSBzdGF0aWNhbGx5IGFsbG9jYXRlZC4uLgoKVGhhbmtzLApKb3NlcGgKCl9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCk9jZnMyLWRldmVsIG1h
aWxpbmcgbGlzdApPY2ZzMi1kZXZlbEBvc3Mub3JhY2xlLmNvbQpodHRwczovL29zcy5vcmFjbGUu
Y29tL21haWxtYW4vbGlzdGluZm8vb2NmczItZGV2ZWw=
