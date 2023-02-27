Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5DDAC64ED6
	for <ocfs2-devel@archiver.kernel.org>; Mon, 27 Feb 2023 03:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=kELpJ93PYSdoMNTYp3+VqtHpB8JzQs0wFPSa1oN/HEw=;
 b=wkvkXFzQRtpHod4A4Z/8yLi0G4e2nhcw07b3FzP4Uk9bVbzbt7qUGlLh5rX20Wh9ByLjpQdN4x6E
   M2JQwVHqWnHUQkJxnBXsV6bqi0ElBo8bwpr6K+FoC+FEDnzFK6I6gLFRoNMm9fZlrT7E5toLP/KI
   hHO7A9u4UTWo8fJ7STMqeKHklF8qgcBx7PKMlWX+tqRJExBQ1NeM/9EH13jW5vCNn+jv3QbYTuWH
   Ccsz7w8Xv3FEnPJ1YflfYbUkqNXuZF3DHPkiNT+tHYeRBNDNemRIyhM3neunRC6mivLZEX2lJfnz
   4g8LW5iAlnoq62dwhCd0twii1N+TJLuUWSup4A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=kELpJ93PYSdoMNTYp3+VqtHpB8JzQs0wFPSa1oN/HEw=;
 b=E2+5DMG1GlA2zqeNEhyu/L4KqJFf797LALL3AQcuf4kTXlKJokLsxLjnX0SyMpJC2E7JpQQx/bjf
   P9S35TeqOUtoxd8uZ7MkH/zNT5zhJd8lToriU2Hi/mutAn5ncsnkW5AnV2+CYMNImce3Mnyf/2ZW
   1KUXREpdtZeVmCmi7Rmseawwexfhk1LWU7g9jVsXOboxKGmaqMABWP+QKjB770SU+mIcyO1JnpEg
   3TmeuyYgORpwnMIrm28k6zx1mJ/jxeBly9h0vXIpD0GncuG1aXLhmJXhzu921WsJgkDFEIVnG7uW
   WZ8z+I3/I+Cug3MiA4ePFTr6wMmcw57veLSHKg==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RQP00KTXXOHPOB0@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 27 Feb 2023 03:00:17 +0000 (GMT)
Message-id: <ab580a75-91c8-d68a-3455-40361be1bfa8@linux.alibaba.com>
Date: Mon, 27 Feb 2023 10:59:56 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Content-language: en-US
To: Heming Zhao <heming.zhao@suse.com>, Joseph Qi <jiangqi903@gmail.com>,
 ocfs2-devel@oss.oracle.com
References: <20230224003251.otqzmap2f64o3fpf@c73>
 <5280652e-8a02-7ec0-8f4e-44ab53796e5f@linux.alibaba.com>
 <913a31c3-c3fe-b421-da63-e7d436ec674f@suse.com>
 <5d9e2335-c00c-6c7f-1e51-88c23b49aa7f@gmail.com>
 <87be76c0-b94a-d6e6-3435-e1764110302a@suse.com>
 <e1fc4970-010f-17a5-c2b3-7bf2dc937e73@gmail.com>
 <20230226084544.weep4qypu3mzgjic@c73> <20230226152238.a2wxbriw2sbxmkbk@c73>
In-reply-to: <20230226152238.a2wxbriw2sbxmkbk@c73>
X-Source-IP: 115.124.30.119
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10633
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxlogscore=999 impostorscore=0
 spamscore=0 mlxscore=0 lowpriorityscore=0 priorityscore=48 phishscore=0
 clxscore=73 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302270021 domainage_hfrom=8719
Subject: Re: [Ocfs2-devel] report BUG: io_uring triggers umount error
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
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046060;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=3; SR=0;
 TI=SMTPD_---0VcVkQUS_1677466796;
X-ServerName: out30-119.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: FHKJa9cCfkH64pOYiVDqUy0gGxBizWly
X-Proofpoint-GUID: FHKJa9cCfkH64pOYiVDqUy0gGxBizWly
Reporting-Meta:
 AAFxiDeaCKOXmWDBLf0nfEvGBB8vB3aDILtEQZVXV/pd49k2YbNB53j65p0Or26K
 ntDaFMNCiD3j4mXT9m5Hn9G0QFI/cNDGZTUk0buuDNudGck820i8KUNw8g/fM4uL
 ACo/IupPYfdrs97SR2IbeIT5SkfsXZNDjfv0vYAa/ZMShTVjhCwmcI4cAWFPjrqO
 scv7515v7EkJWS72Dx/eL3eYXdobRVJIB3SEmsJ5E1wt7nHiGIyVHsPk9vV19FKD
 mVxeOaJU5gXkXiFxyKFHFfFLuMPk3eiLrjJuJW/ipgR1O3qjaImrmI7FQ7bi9IRp
 vgjUMQEU9AXxJFu6u8Udxqtjg8HPt7sAQ11GXFflBc1BxDUItuWfX/2z2CGBrmSi
 Zy0CSe1DFmstqdIbRVEmwHIfgLMFg38qAx2e+lRIbShg5CygzVNsYGHMxKenAEpS
 7Xtdpv13rawiICzxYlfz/EDHhieyN8UFKvV2QbFUEHgpXTomJSi/UA4EmftO5Sjw
 uhAPo0vXiaybpeiktqC2z8XWcO/0I89/97BkTz7pKvgY

CgpPbiAyLzI2LzIzIDExOjIyIFBNLCBIZW1pbmcgWmhhbyB3cm90ZToKPiBPbiBTdW4sIEZlYiAy
NiwgMjAyMyBhdCAwNDo0NTo0NFBNICswODAwLCBIZW1pbmcgWmhhbyB2aWEgT2NmczItZGV2ZWwg
d3JvdGU6Cj4+IE9uIEZyaSwgRmViIDI0LCAyMDIzIGF0IDA2OjU5OjQ3UE0gKzA4MDAsIEpvc2Vw
aCBRaSB3cm90ZToKPj4+Cj4+Pgo+Pj4gT24gMi8yNC8yMyA0OjAzIFBNLCBIZW1pbmcgWmhhbyB3
cm90ZToKPj4+PiBPbiAyLzI0LzIzIDM6NTIgUE0sIEpvc2VwaCBRaSB3cm90ZToKPj4+Pj4KPj4+
Pj4KPj4+Pj4gT24gMi8yNC8yMyAzOjQ4IFBNLCBIZW1pbmcgWmhhbyB2aWEgT2NmczItZGV2ZWwg
d3JvdGU6Cj4+Pj4+PiBPbiAyLzI0LzIzIDI6NTQgUE0sIEpvc2VwaCBRaSB3cm90ZToKPj4+Pj4+
PiBJIGNhbiByZXByb2R1Y2UgdGhpcyBpbiBteSBsb2NhbCBWTS4KPj4+Pj4+PiBJJ3ZlIHRyYWNl
ZCBvY2ZzMl9kaXNtb3VudF92b2x1bWUgYW5kIGZvdW5kIHRoYXQgaXQgaGFzbid0IGJlZW4gY2Fs
bGVkLgo+Pj4+Pj4+IFNvIEVCVVNZIGlzIHJldHVybmVkIGluIFZGUyBsYXllci4gSSBndWVzcyBz
b21ldGhpbmcgd3Jvbmcgd2hlbiBkb2luZwo+Pj4+Pj4+IGEgY29weSB3aXRoIGxpbmtlZCBTUUVz
IChub3JtYWwgY29weSBzZWVtcyBubyBwcm9ibGVtKS4KPj4+Pj4+Pgo+Pj4+Pj4KPj4+Pj4+IEkg
YW0gaW5jbGluZWQgdG8gYWdyZWUgd2l0aCB5b3UuIEkgYWxzbyB0ZXN0IGxpYnVyaW5nIGV4YW1w
bGVzIGFwcHMKPj4+Pj4+IG9uIGV4dDQgcGFydGl0aW9uLCBldmVyeXRoaW5nIGxvb2tzIGZpbmUu
Cj4+Pj4+Pgo+Pj4+Pj4gSSB1c2VkIGJlbG93IGJwZnRyYWNlIG1ldGhvZCwgdGhlIHJldHZhbCBp
cyAnMycuCj4+Pj4+PiDCoMKgYnBmdHJhY2UgLWUgJ2tyOm1udF9nZXRfY291bnR7cHJpbnRmKCIl
ZFxuIiwgcmV0dmFsKTt9Jwo+Pj4+Pj4KPj4+Pj4+IEl0IHJlc3BvbmRzIHRvIGZsb3c6IHBhdGhf
dW1vdW50KCkgPT4gZG9fdW1vdW50ID0+IG1udF9nZXRfY291bnQgKGdldHMgJzMnKQo+Pj4+Pj4K
Pj4+Pj4gWWVzLCB0aGF0J3MgdGhlIHBsYWNlIHJldHVybiBFQlVTWS4KPj4+Pj4gU28gdGhlIHBy
b2JsZW0gc2VlbXMgdG8gYmUgZ2V0bW50L3B1dG1udCBub3QgbWF0Y2ggaW4gdGhpcyBjYXNlLgo+
Pj4+Pgo+Pj4+Cj4+Pj4gSSBkaWRuJ3QgZmFtaWxpYXIgd2l0aCBzZXR0aW5nIHVwIGtlcm5lbCBi
aS1zZWFyY2ggZW52LiBJIHVzZWQgb25lIGxhc3QgeWVhcgo+Pj4+IG9wZW5TVVNFIHR1bWJsd2Vl
ZCAod2l0aCBrZXJuZWwgNS4xNi4yKSwgdGhpcyB1bW91bnQgaXNzdWUgZG9lc24ndCBleGlzdC4K
Pj4+PiBTbyB0aGVyZSBpcyBhIHBvc3NpYmlsaXR5IG9uZSBvY2ZzMiBjb21taXQgaW50cm9kdWNl
ZCB0aGlzIGlzc3VlLgo+Pj4gWW91IGNhbiBjaGVja291dCBlYWNoIG1haWxpbmUgdmVyc2lvbiBs
aWtlIExpbnV4IDYuMCwgNi4xLCAuLi4gYW5kIHRyeQo+Pj4gdG8gY2hlY2sgaWYgaXQgY2FuIGJl
IHJlcHJvZHVjZWQuCj4+Cj4+IEkgZHJvcCB0aGlzIG1ldGhvZCwgbXkgbWFjaGluZSBjcHUgaXMg
b2xkLCBjb21waWxpbmcga2VybmVsIHdpbGwgdGFrZSB0b28gbXVjaAo+PiB0aW1lLgo+Pgo+Pj4K
Pj4+IEkndmUgdHJpZWQgdHJhY2UgbW50Z2V0L21udHB1dCB1c2luZyB0aGUgZm9sbG93aW5nIGJw
ZnRyYWNlIHNjcmlwdCwKPj4+IGxpbmstY3Agb3V0cHV0IHNob3dzIGl0IG1pc3NlcyBhIGZwdXQu
Cj4+Pgo+Pj4gI2luY2x1ZGUgPGxpbnV4L21vdW50Lmg+Cj4+PiAjaW5jbHVkZSA8bGludXgvc3Ry
aW5nLmg+Cj4+Pgo+Pj4ga3Byb2JlOm1udGdldAo+Pj4gewo+Pj4gCSRuID0gKChzdHJ1Y3QgdmZz
bW91bnQgKilhcmcwKS0+bW50X3NiLT5zX3R5cGUtPm5hbWU7Cj4+Pgo+Pj4gCWlmICghc3RybmNt
cChzdHIoJG4pLCAib2NmczIiLCA1KSkgewo+Pj4gCQlAW2NvbW1dICs9IDE7Cj4+Pgo+Pj4gCQlw
cmludGYoIiVzIiwga3N0YWNrKTsKPj4+IAl9Cj4+PiB9Cj4+Pgo+Pj4ga3Byb2JlOm1udHB1dAo+
Pj4gewo+Pj4gCSRuID0gKChzdHJ1Y3QgdmZzbW91bnQgKilhcmcwKS0+bW50X3NiLT5zX3R5cGUt
Pm5hbWU7Cj4+Pgo+Pj4gCWlmICghc3RybmNtcChzdHIoJG4pLCAib2NmczIiLCA1KSkgewo+Pj4g
CQlAW2NvbW1dICs9MTsKPj4+Cj4+PiAJCXByaW50ZigiJXMiLCBrc3RhY2spOwo+Pj4gCX0KPj4+
IH0KPj4+Cj4+Cj4+IEkgdXNlZCBiZWxvdyBzY3JpcHQgdG8gZmluZCBzb3VyY2UgZmlsZSBob2xk
IGZfY291bnQuCj4+Cj4+IGUuZzogLi9saW5rLWNwIC9tbnQvYWEuYmluIC9tbnQvMQo+PiBUaGUg
c2NyaXB0IHdpbGwgc2hvdyBmX2NvdW50IG9mIGFhLmJpbiBvbmx5IGRvd24gdG8gMy4gV2UgZXhw
ZWN0IGZfY291bnQgdmFsdWUKPj4gZG93biB0byAxIHRoZW4gdHJpZ2dlciBtbnRwdXQuCj4+Cj4+
IGBgYAo+PiAjaW5jbHVkZSA8bGludXgvbW91bnQuaD4KPj4gI2luY2x1ZGUgPGxpbnV4L3N0cmlu
Zy5oPgo+PiAjaW5jbHVkZSA8bGludXgvZGNhY2hlLmg+Cj4+ICNpbmNsdWRlIDxsaW51eC9wYXRo
Lmg+Cj4+ICNpbmNsdWRlIDxsaW51eC9mc19zdHJ1Y3QuaD4KPj4gI2luY2x1ZGUgPGxpbnV4L2Zz
Lmg+Cj4+ICNpbmNsdWRlIDxsaW51eC9pb191cmluZ190eXBlcy5oPgo+Pgo+PiBrOmZwdXQKPj4g
ewo+PiAJJGYgPSAoc3RydWN0IGZpbGUgKilhcmcwOwo+PiAJJGNudCA9ICRmLT5mX2NvdW50Owo+
Pgo+PiAJaWYgKCFzdHJuY21wKGNvbW0sICJsaW5rLWNwIiwgNykpIHsKPj4gCQlwcmludGYoIlxu
IFtsaW5rLWNwXSBmcHV0KCkgbmFtZTolcyBmX2NvdW50OiVsbGQgPCVwPiBtbnQ6JXBcbiIsCj4+
IAkJCSAgIAlzdHIoJGYtPmZfcGF0aC5kZW50cnktPmRfbmFtZS5uYW1lKSwgJGNudC5jb3VudGVy
LCBrcHRyKCRmKSwga3B0cigkZi0+Zl9wYXRoLm1udCkpOwo+PiAJCS8vcHJpbnRmKCIlc1xuIiwg
a3N0YWNrKTsKPj4gCX0KPj4gfQo+PiBgYGAKPj4KPiAKPiBJIGFtIG5vdCBmYW1pbGlhciB3aXRo
IGlvX3VyaW5nLCBhbmQgY2FuJ3QgbWFrZSBzdXJlIG15IGFuYWx5c2lzIGlzIGNvcnJlY3QuCj4g
QmVjYXVzZSBvY2ZzMl9maWxlX3JlYWRfaXRlcigpIHJldHVybnMgLUVPUE5PVFNVUFAsIHRoZW4g
ZmFpbHMKPiBpb19pdGVyX2RvX3JlYWQoKSwgdGhlIGlvX2lzc3VlX3NxZSBtaXNzaW5nIGZwdXQo
KSB3aGljaCBjYXVzZXMgdW1vdW50IGZhaWx1cmUKPiBpc3N1ZS4KPiAKPiBpb19pc3N1ZV9zcWUK
PiAgKyBpb19hc3NpZ25fZmlsZSAvL2NhbGwgZmdldCgpLCBidXQgbWlzc2luZyBmcHV0KCkKPiAg
KyBkZWYtPmlzc3VlKCkKPiAgfCAgaW9fcmVhZAo+ICB8ICAgKyBpb19pdGVyX2RvX3JlYWQKPiAg
fCAgIHwgIG9jZnMyX2ZpbGVfcmVhZF9pdGVyCj4gIHwgICB8ICAgcmV0dXJuOiAtRU9QTk9UU1VQ
UCAvL2lvY2ItPmtpX2ZsYWdzOjB4OAo+ICB8ICAgKyBraW9jYl9kb25lCj4gIHwgICAgICArIGlv
X3J3X2RvbmUoJnJ3LT5raW9jYiwgcmV0KQo+ICB8ICAgICAgfCAgIGtpb2NiLT5raV9jb21wbGV0
ZShraW9jYiwgcmV0KQo+ICB8ICAgICAgfCAgICBpb19jb21wbGV0ZV9ydwo+ICB8ICAgICAgfCAg
ICAgIF9faW9fY29tcGxldGVfcndfY29tbW9uCj4gIHwgICAgICB8ICAgICAgICsgcmVxLT5mbGFn
cyB8PSBSRVFfRl9SRUlTU1VFIHwgUkVRX0ZfUEFSVElBTF9JTzsKPiAgfCAgICAgIHwgICAgICAg
KyByZXR1cm4gdHJ1ZQo+ICB8ICAgICAgKyBpb19yZXFfdGFza19xdWV1ZV9yZWlzc3VlL2lvX3Jl
cV90YXNrX3F1ZXVlX2ZhaWwKPiAgfCAgICAgICsgcmV0dXJuIElPVV9JU1NVRV9TS0lQX0NPTVBM
RVRFOwo+ICB8Cj4gICsgcmV0dXJuIDA7Cj4gClNlZW1zIG5vdCB0aGUgY2FzZS4KUmVpc3N1ZSB3
aWxsIHF1ZXVlIHdvcmsgdG8gaW93cSwgYW5kIGZwdXQgd2lsbCBmaW5hbGx5IGdldCBjYWxsZWQg
aW4KaW9fd3FfZnJlZV93b3JrKCkgb25jZSB3b3JrIGlzIGhhbmRsZWQuCgpUaGFua3MsCkpvc2Vw
aAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KT2NmczIt
ZGV2ZWwgbWFpbGluZyBsaXN0Ck9jZnMyLWRldmVsQG9zcy5vcmFjbGUuY29tCmh0dHBzOi8vb3Nz
Lm9yYWNsZS5jb20vbWFpbG1hbi9saXN0aW5mby9vY2ZzMi1kZXZlbA==
