Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 285BDC4332F
	for <ocfs2-devel@archiver.kernel.org>; Thu, 20 Oct 2022 02:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=CXT05zVtpfk6mwf31NaLznla+5weMK5C6n0Xnq5Lr6s=;
 b=nLdRf96mqT6ueEmjI7jR+00Bv/g8g7bLdyMofedflgnW8oxQQ/8f0j4hBLSu7IZt5lNcN2JIzSuI
   o0BbC6xWDtKsvViJz1fUBos+k/oyFPL57LwXOGfxJkLoKMHBIcQp9C5MoWOzCbyx8D1nBFEpaJvC
   4Yha4n9RLNA/nbMzI/qXgPF2XgcLcRpkNfsLxk6e5lt/Onqhj7hfiez7Jf9APjjvzhRNyHAaIjpU
   FEvPWi7BMYNC9Q8rfm+YGwNHGV9iT+304Hmt8eQJjrPKZwXihKCRNziQsQ7dwjs98chDP1wcwuTI
   nsanGrnyg6USHcvFiT3EecbWZgGpGcL9k6mrfw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=CXT05zVtpfk6mwf31NaLznla+5weMK5C6n0Xnq5Lr6s=;
 b=OW0OojAGSnlezwjQN+3oswBpfEIZHr6C2vfaAcX/R0SjeoNDDU4e6IL0u7Gz3FmqjAMDFXVN0L95
   oi3SQ0NpHO5QzpobGuHbuLtY1koqc7Y+3NhVIrugrSjWwkNUmbfF0C1y2PqL16FAUG1hBU84RMYp
   RPxvajcTew7mTu/TtlgSkhlUyQTWeSQkmaq8GiOrv3hpgNWSgmw4bHhCpJcVrMCKYqOEi5+ucA2Q
   R1klMpcI5RsXtOGBfeu7nyofeIcDFAQTbx9yYJpy5udy3LQ1AfHEqEFQrXTOMw1zEHYrs5ID8nvT
   RTV3VYQJs6PsXcII47DQn1C1tV8yK93NEX0Prw==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RK100A2N4JWTV60@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 20 Oct 2022 02:07:08 +0000 (GMT)
Message-id: <30747fd7-fe79-2ed8-ce63-425a008e3e4f@linux.alibaba.com>
Date: Thu, 20 Oct 2022 10:06:48 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.3
Content-language: en-US
To: Yang Yingliang <yangyingliang@huawei.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20221018075213.736562-1-yangyingliang@huawei.com>
 <bf27f347-5ced-98e5-f188-659cc2a9736f@linux.alibaba.com>
 <09bb2844-e20a-98e8-c2af-5b6c4795d48e@huawei.com>
 <c7a3bdac-3ed6-e695-5c45-e7007615a4d9@linux.alibaba.com>
 <0db486eb-6927-927e-3629-958f8f211194@huawei.com>
 <1adbbf98-2700-27c8-4aca-9510bca91458@linux.alibaba.com>
 <f6bc6dd3-f7b7-e757-fc36-d1cfbc7305e5@huawei.com>
In-reply-to: <f6bc6dd3-f7b7-e757-fc36-d1cfbc7305e5@huawei.com>
X-Source-IP: 47.90.199.15
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10505
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 malwarescore=0 spamscore=0 clxscore=126 lowpriorityscore=0 bulkscore=0
 impostorscore=0 mlxlogscore=999 adultscore=0 suspectscore=0 priorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210200010 domainage_hfrom=8589
Cc: ocfs2-devel <ocfs2-devel@oss.oracle.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R141e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046050;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=7; SR=0;
 TI=SMTPD_---0VScf.A8_1666231608;
X-ServerName: out199-15.us.a.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: 3ohWKkdm-R3v09MwRHSjoVNjFjGIXBHa
X-Proofpoint-GUID: 3ohWKkdm-R3v09MwRHSjoVNjFjGIXBHa
Reporting-Meta:
 AAH4jRW2wmIAIX8AYd6baCtuEPi2ikNTKnmZqsxpYPZH6RR83Eyhg6Tnv0LCb0RE
 OK8vryatDcM7MCgfIsn/CueoMaQEhFCTZTCr/7vhU9KAyURQEbUIFmbvjZeUFUoF
 QDQQF1LjYLQBT4SxSQRKcMGThBsHEInHJc3BNoIINYvAD9CpM29kYMBUqzPZ2hdV
 9JHZTWPSArB9XcT/hAcNcK2V/3lc26W9fRr24lAyVN745vJc+VhtGxuEzrX9eqnH
 WXQM6gfvMxdR8fgpBdLAnLVsJ4+x1s6TG9fGrE8hewNOjbpTP876Cm0bFv68Rw1o
 aa6OjIlZS0Z+paL5qreG/zvrTGUlXLdwU8LofMEypSsBBfdYsNodpX+Ww1/E7czc
 dN264CnlKUcehQP8XX1uilAalrlrmHLuzpoCvdJSJm6n/IQaYHEXWPed7xJtOhpy
 6GnsS3mnBCRmLi4DHuaGFE8ERT7j3hJSy7DDnBJNJFZsdbgOu6hJRvtBjBz22PJQ
 70QY+U0pj/J5J2t8zhuE4jPV8+TLnMZN1HsziWHwWpuG

CgpPbiAxMC8xOS8yMiAxMDo1NyBBTSwgWWFuZyBZaW5nbGlhbmcgd3JvdGU6Cj4gCj4gT24gMjAy
Mi8xMC8xOSAxMDoyNiwgSm9zZXBoIFFpIHdyb3RlOgo+Pgo+PiBPbiAxMC8xOC8yMiAxMDoyOCBQ
TSwgWWFuZyBZaW5nbGlhbmcgd3JvdGU6Cj4+PiBPbiAyMDIyLzEwLzE4IDIxOjM5LCBKb3NlcGgg
UWkgd3JvdGU6Cj4+Pj4gT24gMTAvMTgvMjIgNjozMyBQTSwgWWFuZyBZaW5nbGlhbmcgd3JvdGU6
Cj4+Pj4+IEhpLAo+Pj4+Pgo+Pj4+PiBPbiAyMDIyLzEwLzE4IDE3OjAyLCBKb3NlcGggUWkgd3Jv
dGU6Cj4+Pj4+PiBIaSwKPj4+Pj4+Cj4+Pj4+PiBPbiAxMC8xOC8yMiAzOjUyIFBNLCBZYW5nIFlp
bmdsaWFuZyB3cm90ZToKPj4+Pj4+PiBJbmplY3QgZmF1bHQgd2hpbGUgcHJvYmluZyBtb2R1bGUs
IGtzZXRfcmVnaXN0ZXIoKSBtYXkgZmFpbCwKPj4+Pj4+PiBpZiBpdCBmYWlscywgYnV0IHRoZSBy
ZWZjb3VudCBvZiBrb2JqZWN0IGlzIG5vdCBkZWNyZWFzZWQgdG8KPj4+Pj4+PiAwLCB0aGUgbmFt
ZSBhbGxvY2F0ZWQgaW4ga29iamVjdF9zZXRfbmFtZSgpIGlzIGxlYWtlZC4gRml4Cj4+Pj4+Pj4g
dGhpcyBieSBjYWxsaW5nIGtzZXRfcHV0KCksIHNvIHRoYXQgbmFtZSBjYW4gYmUgZnJlZWQgaW4K
Pj4+Pj4+PiBjYWxsYmFjayBmdW5jdGlvbiBrb2JqZWN0X2NsZWFudXAoKS4KPj4+Pj4+Pgo+Pj4+
Pj4+IHVucmVmZXJlbmNlZCBvYmplY3QgMHhmZmZmODg4MTAwZGE5MzQ4IChzaXplIDgpOgo+Pj4+
Pj4+IMKgwqDCoMKgIGNvbW0gIm1vZHByb2JlIiwgcGlkIDI1NywgamlmZmllcyA0Mjk0NzAxMDk2
IChhZ2UgMzMuMzM0cykKPj4+Pj4+PiDCoMKgwqDCoCBoZXggZHVtcCAoZmlyc3QgOCBieXRlcyk6
Cj4+Pj4+Pj4gwqDCoMKgwqDCoMKgIDZjIDZmIDY3IDZkIDYxIDczIDZiIDAwwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbG9nbWFzay4KPj4+Pj4+PiDC
oMKgwqDCoCBiYWNrdHJhY2U6Cj4+Pj4+Pj4gwqDCoMKgwqDCoMKgIFs8MDAwMDAwMDAzMDZlNDQx
Yz5dIF9fa21hbGxvY19ub2RlX3RyYWNrX2NhbGxlcisweDQ0LzB4MWIwCj4+Pj4+Pj4gwqDCoMKg
wqDCoMKgIFs8MDAwMDAwMDA3YzQ5MWE5ZT5dIGtzdHJkdXArMHgzYS8weDcwCj4+Pj4+Pj4gwqDC
oMKgwqDCoMKgIFs8MDAwMDAwMDAxNTcxOWEzYj5dIGtzdHJkdXBfY29uc3QrMHg2My8weDgwCj4+
Pj4+Pj4gwqDCoMKgwqDCoMKgIFs8MDAwMDAwMDA4NGU0NThlYT5dIGt2YXNwcmludGZfY29uc3Qr
MHgxNDkvMHgxODAKPj4+Pj4+PiDCoMKgwqDCoMKgwqAgWzwwMDAwMDAwMDkxMzAyYjQyPl0ga29i
amVjdF9zZXRfbmFtZV92YXJncysweDU2LzB4MTUwCj4+Pj4+Pj4gwqDCoMKgwqDCoMKgIFs8MDAw
MDAwMDA1ZjQ4ZWVhYz5dIGtvYmplY3Rfc2V0X25hbWUrMHhhYi8weGUwCj4+Pj4+Pj4KPj4+Pj4+
PiBGaXhlczogMzQ5ODBjYThmYWViICgiRHJpdmVyczogY2xlYW4gdXAgZGlyZWN0IHNldHRpbmcg
b2YgdGhlIG5hbWUgb2YgYSBrc2V0IikKPj4+Pj4+PiBTaWduZWQtb2ZmLWJ5OiBZYW5nIFlpbmds
aWFuZyA8eWFuZ3lpbmdsaWFuZ0BodWF3ZWkuY29tPgo+Pj4+Pj4+IC0tLQo+Pj4+Pj4+IMKgwqDC
oCBmcy9vY2ZzMi9jbHVzdGVyL21hc2tsb2cuYyB8IDcgKysrKysrLQo+Pj4+Pj4+IMKgwqDCoCAx
IGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCj4+Pj4+Pj4KPj4+
Pj4+PiBkaWZmIC0tZ2l0IGEvZnMvb2NmczIvY2x1c3Rlci9tYXNrbG9nLmMgYi9mcy9vY2ZzMi9j
bHVzdGVyL21hc2tsb2cuYwo+Pj4+Pj4+IGluZGV4IDU2Mzg4MWRkYmYwMC4uN2Y5YmE4MTZkOTU1
IDEwMDY0NAo+Pj4+Pj4+IC0tLSBhL2ZzL29jZnMyL2NsdXN0ZXIvbWFza2xvZy5jCj4+Pj4+Pj4g
KysrIGIvZnMvb2NmczIvY2x1c3Rlci9tYXNrbG9nLmMKPj4+Pj4+PiBAQCAtMTU2LDYgKzE1Niw3
IEBAIHN0YXRpYyBzdHJ1Y3Qga3NldCBtbG9nX2tzZXQgPSB7Cj4+Pj4+Pj4gwqDCoMKgIGludCBt
bG9nX3N5c19pbml0KHN0cnVjdCBrc2V0ICpvMmNiX2tzZXQpCj4+Pj4+Pj4gwqDCoMKgIHsKPj4+
Pj4+PiDCoMKgwqDCoMKgwqDCoCBpbnQgaSA9IDA7Cj4+Pj4+Pj4gK8KgwqDCoCBpbnQgcmV0Owo+
Pj4+Pj4+IMKgwqDCoCDCoMKgwqDCoMKgIHdoaWxlIChtbG9nX2F0dHJzW2ldLmF0dHIubW9kZSkg
ewo+Pj4+Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbWxvZ19kZWZhdWx0X2F0dHJzW2ldID0g
Jm1sb2dfYXR0cnNbaV0uYXR0cjsKPj4+Pj4+PiBAQCAtMTY1LDcgKzE2NiwxMSBAQCBpbnQgbWxv
Z19zeXNfaW5pdChzdHJ1Y3Qga3NldCAqbzJjYl9rc2V0KQo+Pj4+Pj4+IMKgwqDCoCDCoMKgwqDC
oMKgIGtvYmplY3Rfc2V0X25hbWUoJm1sb2dfa3NldC5rb2JqLCAibG9nbWFzayIpOwo+Pj4+Pj4+
IMKgwqDCoMKgwqDCoMKgIG1sb2dfa3NldC5rb2JqLmtzZXQgPSBvMmNiX2tzZXQ7Cj4+Pj4+Pj4g
LcKgwqDCoCByZXR1cm4ga3NldF9yZWdpc3RlcigmbWxvZ19rc2V0KTsKPj4+Pj4+PiArwqDCoMKg
IHJldCA9IGtzZXRfcmVnaXN0ZXIoJm1sb2dfa3NldCk7Cj4+Pj4+PiBJZiByZWdpc3RlciBmYWls
cywgaXQgd2lsbCBjYWxsIHVucmVnaXN0ZXIgaW4gbzJjYl9zeXNfaW5pdCgpLCB3aGljaAo+Pj4+
Pj4gd2lsbCBwdXQga29iamVjdC4KPj4+Pj4gVGhleSBhcmUgZGlmZmVyZW50IGtzZXRzLCB0aGUg
a3NldCB1bnJlZ2lzdGVyZWQgaW4gbzJjYl9zeXNfaW5pdCgpIGlzICdvMmNiX2tzZXQnLCB0aGUK
Pj4+Pj4ga3NldCB1c2VkIHRvIHJlZ2lzdGVyZWQgaW4gbWxvZ19zeXNfaW5pdCgpIGlzICdtbG9n
X2tzZXQnLCBhbmQgdGhleSBob2xkIGRpZmZlcmVuY2UKPj4+Pj4gcmVmY291bnRzLgo+Pj4+PiBZ
ZXMsIHlvdSBhcmUgcmlnaHQuIEkndmUgbWl4ZWQgdGhlIHR3byBrc2V0cyB1cC4KPj4+PiBJbiB0
aGVvcnksIGtzZXRfcmVnaXN0ZXIoKSBtYXkgcmV0dXJuIGVycm9yIGJlY2F1c2Ugb2YgYSBOVUxM
IGtzZXQsIHNvCj4+Pj4gaGVyZSB3ZSBtYXkgbm90IGNhbGwga3NldF9wdXQoKSBkaXJlY3RseSwg
SSdtIG5vdCBzdXJlIGlmIGEgc3RhdGljCj4+Pj4gY2hlY2tlciB3aWxsIGhhcHB5Lgo+Pj4+IFRo
b3VnaCB0aGlzIGNhbid0IGhhcHBlbiBzaW5jZSBpdCdzIGFscmVhZHkgc3RhdGljYWxseSBhbGxv
Y2F0ZWQuLi4KPj4+IGtzZXRfcmVnaXN0ZXIoKSBtYXkgZmFpbCBpZiBrb2JqZWN0X2FkZF9pbnRl
cm5hbCgpIHJldHVybiBlcnJvciAoY2FuJ3QgYWxsb2NhdGUgbWVtb3J5KSwgdGhlIG5hbWUKPj4+
ICJsb2dtYXNrIiBpcyBkeW5hbWljYWxseSBhbGxvY3RhdGVkIHdoaWxlIG9jZnMyIGlzIGNvbXBp
bGUgYXMgbW9kdWxlIGFuZCBpbnNlcnQgaXQgKGlmIG9jZnMyIGlzCj4+PiBidWlsdCBpbiBrZXJu
ZWwsIHRoZSBuYW1lIGlzIGNvbnN0YW50LCBpdCB3b24ndCBjYXVzZSBhIGxlYWspLCBzbyB0aGUg
bmFtZSBjYW4gYmUgbGVha2VkLgo+PiBXaGF0IEkgbWVhbiBpcyBrc2V0X3JlZ2lzdGVyKCkgbWF5
IGZhaWwgd2l0aCBtYW55IHJlYXNvbnMsIG9yIGV2ZW4KPj4gd2l0aG91dCBrc2V0X2luaXQoKS4K
Pj4gSSB3b25kZXIgaWYgd2UgaGF2ZSB0byBoYW5kbGUgdGhpcyBpbnRlcm5hbCBrc2V0X3JlZ2lz
dGVyKCksIGJ1dCBub3QKPj4gbGVhdmUgaXQgdG8gY2FsbGVyLiBUaGlzIG1heSBiZW5lZml0IG90
aGVyIGNhbGxlcnMgYXMgd2VsbC4KPj4KPj4gU29tZXRoaW5nIGxpa2U6Cj4+IGVyciA9IGtvYmpl
Y3RfYWRkX2ludGVybmFsKCZrLT5rb2JqKTsKPj4gaWYgKGVycikgewo+PiDCoMKgwqDCoGtzZXRf
cHV0KGspOwo+PiDCoMKgwqDCoHJldHVybiBlcnI7Cj4+IH0KPiBJIGhhZCB0aGluayBhYm91dCB0
aGlzIG1ldGhvZCB0byBmaXggdGhpcywgYnV0IHNvbWUga3NldCBpcyBhbGxvY2F0ZWQgZHluYW1p
Y2FsbHkgaW4gZHJpdmVyIGFuZAo+IGl0J3MgZnJlZWQgaW4gY2FsbGJhY2sgZnVuY3Rpb24gd2hp
Y2ggaXMgY2FsbGVkIGFmdGVyIGtzZXRfcHV0KCkgYW5kIGluIGVycm9yIHBhdGggaW4gZHJpdmVy
IHdpbGwgZnJlZQo+IGl0IGFnYWluLCBpdCBsZWFkcyBkb3VibGUgZnJlZSBpbiBzb21lIGRyaXZl
cnMuCj4gCkkgZG9uJ3QgdGhpbmsgaXQncyBnb29kIGlkZWEgdGhhdCBjYWxsZXIgaGFzIHRvIHRh
a2UgY2FyZSBwYXJ0IG9mIHRoZQppbnRlcm5hbCBsb2dpYyBvZiBrc2V0X3JlZ2lzdGVyKCkgaW4g
Y2FzZSBvZiBlcnJvci4KSGkgR3JlZywgd2hhdCBkbyB5b3UgdGhpbms/CgpUaGFua3MsCkpvc2Vw
aAoKPiBJIHRoaW5rIGtzZXRfcmVnaXN0ZXIoKSBpcyBzaW1pbGFyIHdpdGggZGV2aWNlX3JlZ2lz
dGVyKCksIGlmIGl0IGZhaWxzIG5lZWQgYW5vdGhlciBwdXQgZnVuY3Rpb24gdG8gZ2l2ZQo+IHVw
IHJlZmVyZW5jZSBpbiBkcml2ZXIuCj4gCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwpPY2ZzMi1kZXZlbCBtYWlsaW5nIGxpc3QKT2NmczItZGV2ZWxAb3Nz
Lm9yYWNsZS5jb20KaHR0cHM6Ly9vc3Mub3JhY2xlLmNvbS9tYWlsbWFuL2xpc3RpbmZvL29jZnMy
LWRldmVs
