Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C797C433FE
	for <ocfs2-devel@archiver.kernel.org>; Wed, 19 Oct 2022 02:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=cSKBtM7OnVT+zzqIflrd6Mf4V+E/LLS1LXIkN2pz0f8=;
 b=qAubF5Ul/LpieNwJfZtY+jeNyWb+sjCn9btw77z3bDkmk/HTHctAGETdiI6Q4E2axsrSkfSZYy+u
   kCsqxgdVE+NcWr1p91NtDUWGJ4AhBXkhmWc2qecQVs28/HS8xDy4oi6W0YsKH5/Kgmccth03M8v9
   ZR6a4tVCLKAJ6N+trGZcuPrD4GM5NNLsheXg0BCh/ThW9PHjzSq1nXqk7aZUvWQrF9WGX9MFwJMr
   /muQUkugp65tlrhAb1tG191qgMmK9TKHIMwHIUeQLCCSdkMt7/w577ypEWwxV5b5JBcSMtVNx6+h
   hu1s4QEd4PIwxSiGPtOqT0KiMWJYoKkK3hMO1w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=cSKBtM7OnVT+zzqIflrd6Mf4V+E/LLS1LXIkN2pz0f8=;
 b=eAb+SU0Eyp/+LrrzY/14mONxzHRR2jrO6A62IeEdzl7jjF4ShP8/hpCf2fCfJpoS5E3nYKN0crQk
   cxETnK/dYuoGFjxAYdnDQK9koBt279Yt5x4FxZw5qj3+lMXwn4zxgoNWv7bgQ/bv5/KFm4D6VkHf
   VJNDzNli+lXOvrxcDbKe6TJvmZ7WP+IdxiY1oWSnASMtOD7UXV6QX0idlhQRZpuZkrtyd4Ue4uWb
   TB84CVx1H2fI8xt9eVTpULz7FLTbmM2wjasvFEVbfbrfLUqeUF+wwAgBLePoaUMeqq5qFmnDTSYt
   1A85JG3dyUlqQPsSuKHGWFK+1zOFnGYJcMeGkw==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220914 64bit (built Sep 14
 2022))
 with ESMTPS id <0RJZ000A3C9CBNE0@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 19 Oct 2022 02:58:24 +0000 (GMT)
To: Joseph Qi <joseph.qi@linux.alibaba.com>, <linux-kernel@vger.kernel.org>,
 <ocfs2-devel@oss.oracle.com>
References: <20221018075213.736562-1-yangyingliang@huawei.com>
 <bf27f347-5ced-98e5-f188-659cc2a9736f@linux.alibaba.com>
 <09bb2844-e20a-98e8-c2af-5b6c4795d48e@huawei.com>
 <c7a3bdac-3ed6-e695-5c45-e7007615a4d9@linux.alibaba.com>
 <0db486eb-6927-927e-3629-958f8f211194@huawei.com>
 <1adbbf98-2700-27c8-4aca-9510bca91458@linux.alibaba.com>
Message-id: <f6bc6dd3-f7b7-e757-fc36-d1cfbc7305e5@huawei.com>
Date: Wed, 19 Oct 2022 10:57:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-version: 1.0
In-reply-to: <1adbbf98-2700-27c8-4aca-9510bca91458@linux.alibaba.com>
Content-language: en-US
X-Originating-IP: [10.174.178.174]
X-Source-IP: 45.249.212.187
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10504
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 mlxscore=0 impostorscore=0 phishscore=0 bulkscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 malwarescore=0 adultscore=0 mlxlogscore=999
 clxscore=-86 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210190015 domainage_hfrom=8317
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
From: Yang Yingliang via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Yang Yingliang <yangyingliang@huawei.com>
Content-transfer-encoding: base64
Content-type: text/plain; charset="utf-8"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-ServerName: szxga01-in.huawei.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:45.249.212.32 ip4:45.249.212.35
 ip4:45.249.212.255 ip4:45.249.212.187/29 ip4:45.249.212.191 ip4:168.195.93.47
 ip4:185.176.79.56 ip4:119.8.179.247 ip4:119.8.89.136/31 ip4:119.8.89.135
 ip4:119.8.177.36/31 ip4:119.8.177.38 -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: rTRCPQ8QLueICOL1mydRRzb9gPoJ-C9c
X-Proofpoint-GUID: rTRCPQ8QLueICOL1mydRRzb9gPoJ-C9c
Reporting-Meta:
 AAEIscxTQA7YgNWPyT+a7IFXO6vHNiSOGReA2LvBwlFeRXG9gwtXHtBCcKURBFah
 XZCz9d5WySkJS+LJYaeQpv5gfARZ+QeY7KdZ10Cl1WQstrOzHDDQRJ3lwgvG+b0T
 JyOWJXa6+IcHk1FVuVIaTmEJ6fn2742puooSCxSeQIRQzRVIo93SLjSREJZ6MEjk
 NfQRUPYzYb/Oasp713EdBKuNwlyVB4Xt1ZF/2Ca6532IF54L6zKEJ2CfCVDbu4Ab
 7sKQo1Woz6HLWbXUT1QDW1HsfzrjzCNYZFUo9MfYKHfjVFFvXMYx86uqtu8ep8Jr
 xouDSpNqYBYLb7no5RqUwn5ccnhU4nX8i7OckYxBXeVWvn6MhfDZGllG2j8HH8jY
 FEF19TeAf+O2nox0dgHTOTUsgX9D+OJmcWL2RAXfVJwUdvCFCyuWmUiCWXjyiY7S
 bnLcKZ17wLDpWUUhjWt/fbi32pEq5sE1hNViAokE+4GhdL5cqRjs2Fe8Hkeri0A8
 U0i6EOVK6t79Vf97dullg1zAIoDPz5cI1E9MbXel44qg

Ck9uIDIwMjIvMTAvMTkgMTA6MjYsIEpvc2VwaCBRaSB3cm90ZToKPgo+IE9uIDEwLzE4LzIyIDEw
OjI4IFBNLCBZYW5nIFlpbmdsaWFuZyB3cm90ZToKPj4gT24gMjAyMi8xMC8xOCAyMTozOSwgSm9z
ZXBoIFFpIHdyb3RlOgo+Pj4gT24gMTAvMTgvMjIgNjozMyBQTSwgWWFuZyBZaW5nbGlhbmcgd3Jv
dGU6Cj4+Pj4gSGksCj4+Pj4KPj4+PiBPbiAyMDIyLzEwLzE4IDE3OjAyLCBKb3NlcGggUWkgd3Jv
dGU6Cj4+Pj4+IEhpLAo+Pj4+Pgo+Pj4+PiBPbiAxMC8xOC8yMiAzOjUyIFBNLCBZYW5nIFlpbmds
aWFuZyB3cm90ZToKPj4+Pj4+IEluamVjdCBmYXVsdCB3aGlsZSBwcm9iaW5nIG1vZHVsZSwga3Nl
dF9yZWdpc3RlcigpIG1heSBmYWlsLAo+Pj4+Pj4gaWYgaXQgZmFpbHMsIGJ1dCB0aGUgcmVmY291
bnQgb2Yga29iamVjdCBpcyBub3QgZGVjcmVhc2VkIHRvCj4+Pj4+PiAwLCB0aGUgbmFtZSBhbGxv
Y2F0ZWQgaW4ga29iamVjdF9zZXRfbmFtZSgpIGlzIGxlYWtlZC4gRml4Cj4+Pj4+PiB0aGlzIGJ5
IGNhbGxpbmcga3NldF9wdXQoKSwgc28gdGhhdCBuYW1lIGNhbiBiZSBmcmVlZCBpbgo+Pj4+Pj4g
Y2FsbGJhY2sgZnVuY3Rpb24ga29iamVjdF9jbGVhbnVwKCkuCj4+Pj4+Pgo+Pj4+Pj4gdW5yZWZl
cmVuY2VkIG9iamVjdCAweGZmZmY4ODgxMDBkYTkzNDggKHNpemUgOCk6Cj4+Pj4+PiAgwqDCoMKg
IGNvbW0gIm1vZHByb2JlIiwgcGlkIDI1NywgamlmZmllcyA0Mjk0NzAxMDk2IChhZ2UgMzMuMzM0
cykKPj4+Pj4+ICDCoMKgwqAgaGV4IGR1bXAgKGZpcnN0IDggYnl0ZXMpOgo+Pj4+Pj4gIMKgwqDC
oMKgwqAgNmMgNmYgNjcgNmQgNjEgNzMgNmIgMDDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBsb2dtYXNrLgo+Pj4+Pj4gIMKgwqDCoCBiYWNrdHJhY2U6
Cj4+Pj4+PiAgwqDCoMKgwqDCoCBbPDAwMDAwMDAwMzA2ZTQ0MWM+XSBfX2ttYWxsb2Nfbm9kZV90
cmFja19jYWxsZXIrMHg0NC8weDFiMAo+Pj4+Pj4gIMKgwqDCoMKgwqAgWzwwMDAwMDAwMDdjNDkx
YTllPl0ga3N0cmR1cCsweDNhLzB4NzAKPj4+Pj4+ICDCoMKgwqDCoMKgIFs8MDAwMDAwMDAxNTcx
OWEzYj5dIGtzdHJkdXBfY29uc3QrMHg2My8weDgwCj4+Pj4+PiAgwqDCoMKgwqDCoCBbPDAwMDAw
MDAwODRlNDU4ZWE+XSBrdmFzcHJpbnRmX2NvbnN0KzB4MTQ5LzB4MTgwCj4+Pj4+PiAgwqDCoMKg
wqDCoCBbPDAwMDAwMDAwOTEzMDJiNDI+XSBrb2JqZWN0X3NldF9uYW1lX3ZhcmdzKzB4NTYvMHgx
NTAKPj4+Pj4+ICDCoMKgwqDCoMKgIFs8MDAwMDAwMDA1ZjQ4ZWVhYz5dIGtvYmplY3Rfc2V0X25h
bWUrMHhhYi8weGUwCj4+Pj4+Pgo+Pj4+Pj4gRml4ZXM6IDM0OTgwY2E4ZmFlYiAoIkRyaXZlcnM6
IGNsZWFuIHVwIGRpcmVjdCBzZXR0aW5nIG9mIHRoZSBuYW1lIG9mIGEga3NldCIpCj4+Pj4+PiBT
aWduZWQtb2ZmLWJ5OiBZYW5nIFlpbmdsaWFuZyA8eWFuZ3lpbmdsaWFuZ0BodWF3ZWkuY29tPgo+
Pj4+Pj4gLS0tCj4+Pj4+PiAgwqDCoCBmcy9vY2ZzMi9jbHVzdGVyL21hc2tsb2cuYyB8IDcgKysr
KysrLQo+Pj4+Pj4gIMKgwqAgMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMSBkZWxl
dGlvbigtKQo+Pj4+Pj4KPj4+Pj4+IGRpZmYgLS1naXQgYS9mcy9vY2ZzMi9jbHVzdGVyL21hc2ts
b2cuYyBiL2ZzL29jZnMyL2NsdXN0ZXIvbWFza2xvZy5jCj4+Pj4+PiBpbmRleCA1NjM4ODFkZGJm
MDAuLjdmOWJhODE2ZDk1NSAxMDA2NDQKPj4+Pj4+IC0tLSBhL2ZzL29jZnMyL2NsdXN0ZXIvbWFz
a2xvZy5jCj4+Pj4+PiArKysgYi9mcy9vY2ZzMi9jbHVzdGVyL21hc2tsb2cuYwo+Pj4+Pj4gQEAg
LTE1Niw2ICsxNTYsNyBAQCBzdGF0aWMgc3RydWN0IGtzZXQgbWxvZ19rc2V0ID0gewo+Pj4+Pj4g
IMKgwqAgaW50IG1sb2dfc3lzX2luaXQoc3RydWN0IGtzZXQgKm8yY2Jfa3NldCkKPj4+Pj4+ICDC
oMKgIHsKPj4+Pj4+ICDCoMKgwqDCoMKgwqAgaW50IGkgPSAwOwo+Pj4+Pj4gK8KgwqDCoCBpbnQg
cmV0Owo+Pj4+Pj4gIMKgwqAgwqDCoMKgwqDCoCB3aGlsZSAobWxvZ19hdHRyc1tpXS5hdHRyLm1v
ZGUpIHsKPj4+Pj4+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoCBtbG9nX2RlZmF1bHRfYXR0cnNbaV0g
PSAmbWxvZ19hdHRyc1tpXS5hdHRyOwo+Pj4+Pj4gQEAgLTE2NSw3ICsxNjYsMTEgQEAgaW50IG1s
b2dfc3lzX2luaXQoc3RydWN0IGtzZXQgKm8yY2Jfa3NldCkKPj4+Pj4+ICDCoMKgIMKgwqDCoMKg
wqAga29iamVjdF9zZXRfbmFtZSgmbWxvZ19rc2V0LmtvYmosICJsb2dtYXNrIik7Cj4+Pj4+PiAg
wqDCoMKgwqDCoMKgIG1sb2dfa3NldC5rb2JqLmtzZXQgPSBvMmNiX2tzZXQ7Cj4+Pj4+PiAtwqDC
oMKgIHJldHVybiBrc2V0X3JlZ2lzdGVyKCZtbG9nX2tzZXQpOwo+Pj4+Pj4gK8KgwqDCoCByZXQg
PSBrc2V0X3JlZ2lzdGVyKCZtbG9nX2tzZXQpOwo+Pj4+PiBJZiByZWdpc3RlciBmYWlscywgaXQg
d2lsbCBjYWxsIHVucmVnaXN0ZXIgaW4gbzJjYl9zeXNfaW5pdCgpLCB3aGljaAo+Pj4+PiB3aWxs
IHB1dCBrb2JqZWN0Lgo+Pj4+IFRoZXkgYXJlIGRpZmZlcmVudCBrc2V0cywgdGhlIGtzZXQgdW5y
ZWdpc3RlcmVkIGluIG8yY2Jfc3lzX2luaXQoKSBpcyAnbzJjYl9rc2V0JywgdGhlCj4+Pj4ga3Nl
dCB1c2VkIHRvIHJlZ2lzdGVyZWQgaW4gbWxvZ19zeXNfaW5pdCgpIGlzICdtbG9nX2tzZXQnLCBh
bmQgdGhleSBob2xkIGRpZmZlcmVuY2UKPj4+PiByZWZjb3VudHMuCj4+Pj4gWWVzLCB5b3UgYXJl
IHJpZ2h0LiBJJ3ZlIG1peGVkIHRoZSB0d28ga3NldHMgdXAuCj4+PiBJbiB0aGVvcnksIGtzZXRf
cmVnaXN0ZXIoKSBtYXkgcmV0dXJuIGVycm9yIGJlY2F1c2Ugb2YgYSBOVUxMIGtzZXQsIHNvCj4+
PiBoZXJlIHdlIG1heSBub3QgY2FsbCBrc2V0X3B1dCgpIGRpcmVjdGx5LCBJJ20gbm90IHN1cmUg
aWYgYSBzdGF0aWMKPj4+IGNoZWNrZXIgd2lsbCBoYXBweS4KPj4+IFRob3VnaCB0aGlzIGNhbid0
IGhhcHBlbiBzaW5jZSBpdCdzIGFscmVhZHkgc3RhdGljYWxseSBhbGxvY2F0ZWQuLi4KPj4ga3Nl
dF9yZWdpc3RlcigpIG1heSBmYWlsIGlmIGtvYmplY3RfYWRkX2ludGVybmFsKCkgcmV0dXJuIGVy
cm9yIChjYW4ndCBhbGxvY2F0ZSBtZW1vcnkpLCB0aGUgbmFtZQo+PiAibG9nbWFzayIgaXMgZHlu
YW1pY2FsbHkgYWxsb2N0YXRlZCB3aGlsZSBvY2ZzMiBpcyBjb21waWxlIGFzIG1vZHVsZSBhbmQg
aW5zZXJ0IGl0IChpZiBvY2ZzMiBpcwo+PiBidWlsdCBpbiBrZXJuZWwsIHRoZSBuYW1lIGlzIGNv
bnN0YW50LCBpdCB3b24ndCBjYXVzZSBhIGxlYWspLCBzbyB0aGUgbmFtZSBjYW4gYmUgbGVha2Vk
Lgo+IFdoYXQgSSBtZWFuIGlzIGtzZXRfcmVnaXN0ZXIoKSBtYXkgZmFpbCB3aXRoIG1hbnkgcmVh
c29ucywgb3IgZXZlbgo+IHdpdGhvdXQga3NldF9pbml0KCkuCj4gSSB3b25kZXIgaWYgd2UgaGF2
ZSB0byBoYW5kbGUgdGhpcyBpbnRlcm5hbCBrc2V0X3JlZ2lzdGVyKCksIGJ1dCBub3QKPiBsZWF2
ZSBpdCB0byBjYWxsZXIuIFRoaXMgbWF5IGJlbmVmaXQgb3RoZXIgY2FsbGVycyBhcyB3ZWxsLgo+
Cj4gU29tZXRoaW5nIGxpa2U6Cj4gZXJyID0ga29iamVjdF9hZGRfaW50ZXJuYWwoJmstPmtvYmop
Owo+IGlmIChlcnIpIHsKPiAJa3NldF9wdXQoayk7Cj4gCXJldHVybiBlcnI7Cj4gfQpJIGhhZCB0
aGluayBhYm91dCB0aGlzIG1ldGhvZCB0byBmaXggdGhpcywgYnV0IHNvbWUga3NldCBpcyBhbGxv
Y2F0ZWQgCmR5bmFtaWNhbGx5IGluIGRyaXZlciBhbmQKaXQncyBmcmVlZCBpbiBjYWxsYmFjayBm
dW5jdGlvbiB3aGljaCBpcyBjYWxsZWQgYWZ0ZXIga3NldF9wdXQoKSBhbmQgaW4gCmVycm9yIHBh
dGggaW4gZHJpdmVyIHdpbGwgZnJlZQppdCBhZ2FpbiwgaXQgbGVhZHMgZG91YmxlIGZyZWUgaW4g
c29tZSBkcml2ZXJzLgoKSSB0aGluayBrc2V0X3JlZ2lzdGVyKCkgaXMgc2ltaWxhciB3aXRoIGRl
dmljZV9yZWdpc3RlcigpLCBpZiBpdCBmYWlscyAKbmVlZCBhbm90aGVyIHB1dCBmdW5jdGlvbiB0
byBnaXZlCnVwIHJlZmVyZW5jZSBpbiBkcml2ZXIuCgpUaGFua3MsCllhbmcKPgo+IFRoYW5rcywK
PiBKb3NlcGgKPgo+IC4KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCk9jZnMyLWRldmVsIG1haWxpbmcgbGlzdApPY2ZzMi1kZXZlbEBvc3Mub3JhY2xlLmNv
bQpodHRwczovL29zcy5vcmFjbGUuY29tL21haWxtYW4vbGlzdGluZm8vb2NmczItZGV2ZWw=
