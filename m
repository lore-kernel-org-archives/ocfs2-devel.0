Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B79C8C7EE29
	for <ocfs2-devel@archiver.kernel.org>; Fri, 26 May 2023 01:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=7CZjaamTq1B4hxzQ3sCHCeiLRcZO3onN0s2tZCvuHVo=;
 b=wyepCgZs1WGTNebG9Stmq2LNSRvXNpgWcQ3jvaT7SsBwGQMuFg0Bob+JTPvijyXFFPvr5GDpp1SE
   UolTJjnEvJ98EXLop/Kp3OKNojgJrhfXZ0i53U4IMYWnsYOQ8whN6dJC/vTrKsejVA5y8cOztjp0
   lYj/Uv6/ANGw5vHGsTEPmLMh0VzsBKAhi9LB7yiszgVot7Jq6fA/QqeJsf7pdKztlP8qRrArfbYD
   fF9zqfbWiEewg6TceSfDdQ7HTcB4zR01YYw3kCOxlT0NPRLorVnTHdq9+jjxHKby6mDBmaBHKqfs
   BZt68B/KXhepdO7U9sDQ9lsmF/xHnOIPOJbyLw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=7CZjaamTq1B4hxzQ3sCHCeiLRcZO3onN0s2tZCvuHVo=;
 b=Kl0oyEgKobkJegzqx5xeknZYNvRQuaVx/PWkesCgSD+XPhX6zwVAtsH0uJXECBMpa3g+UiPEmz7f
   zOcCC01RNMvyCJ5BTyFX3ViknUjGkE4RCBfp1mYhxcyQ9ceNRKrOYNKRbVeNcJ3mguxyLdzKB66e
   4IcuaD4amRmV4TBJwlTzco+8AcWHWEnSq2MZL9r1Eh04eDrr8q6gUjhSoW8sP6ub3oT2gBOreHmL
   9WVc53h5aoaHBnjmI4lwgBB0uD/P0oxl8Z0Fld1viMfCHmA5tszDc6C701nWiY3UKb4Aw442dRYm
   ek05mIhReqFShuUpxH9UydjVrVk+s43EB4KKwQ==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230522 64bit (built May 22
 2023))
 with ESMTPS id <0RV80022USHB5S10@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 26 May 2023 01:36:47 +0000 (GMT)
Message-id: <efbc350b-9529-7cc1-5d96-d3261404cfa0@linux.alibaba.com>
Date: Fri, 26 May 2023 09:36:25 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Content-language: en-US
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 piaojun@huawei.com, mark@fasheh.com, lhenriques@suse.de,
 junxiao.bi@oracle.com, jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
 ocfs2-devel@oss.oracle.com
References: <20230525205556.680DCC433EF@smtp.kernel.org>
In-reply-to: <20230525205556.680DCC433EF@smtp.kernel.org>
X-Source-IP: 115.124.30.112
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10721
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 suspectscore=0
 malwarescore=0 impostorscore=0 spamscore=0 lowpriorityscore=0
 priorityscore=126 bulkscore=0 phishscore=0 adultscore=0 mlxscore=0
 clxscore=150 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305260012 domainage_hfrom=8807
Subject: Re: [Ocfs2-devel] +
 ocfs2-fix-use-after-free-when-unmounting-read-only-filesystem.patch added to
 mm-hotfixes-unstable branch
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R201e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046059;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=10; SR=0;
 TI=SMTPD_---0VjU1w8w_1685064985;
X-ServerName: out30-112.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: 2WRACRgPafnVncP4KhNN0sNBKUqKVvzN
X-Proofpoint-ORIG-GUID: 2WRACRgPafnVncP4KhNN0sNBKUqKVvzN
Reporting-Meta:
 AAHLYjwYkFpDCdu/uDN+ijTE4rwI91PquadtLvgXWO+cmVnKucRY/dIoL6WlYWc+
 tqVvJvpNlDYPPmyPKqBOOO0iTTElpnF+Zt8cippG2/Kc4sZpH/Uy3bW5MWIfW0AK
 P3sR+6oDpQOfJAIDr54HSa7bNdMHDz2eQzNvylhDAvjU+1X5mtOYCLxim9xwA+/H
 FS6KpdNwPDdbW1J3wBdQBGrabV8IyfWLcAwn0EdOChL+hrY2+udBmKoTeHAKAJ5W
 IX0SSHrMAUAlnMotqOaQXfLrNBk4McC9bch+6/8OMw+uAUJtVWXsiuHQpZHW2fI7
 PSMx9fZaxlur09estu2Ubzs4DRF+WPN8YZ32i+/rjmTNEx8pSd8+GycawgFwTUEl
 SiTsxrZcZSmSI4wi2cb0Ea4D83Yu6sSGDVI+arhjQ4YwjEz1diDskhBxWHFoUjS7
 kG2b1K7SCaFib7fG0Dyy+VQSUjNO/Fq6jMLg6zIdvFPjqOTPh/5SjHm5RdRUg2lA
 zW5XGZ2yFB5q4z96QKn625RK8nv+CX/uQpWZkNTuo5Hshg==

SGkgQW5kcmV3LAoKVGhlcmUgaXMgYW4gdXBkYXRlZCB2ZXJzaW9uIHYyLCB3aGljaCBkZXNjcmli
ZSBtb3JlIGNsZWFybHkgYWJvdXQgdGhlCmNhc2U6Cmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL29j
ZnMyLWRldmVsL2U5ZmM0YjJmLTFmY2MtN2MzMS1mMzQ2LTU5ZWNjZmY1MGY5YkBsaW51eC5hbGli
YWJhLmNvbS9ULyN1CgpUaGFua3MsCkpvc2VwaAoKT24gNS8yNi8yMyA0OjU1IEFNLCBBbmRyZXcg
TW9ydG9uIHdyb3RlOgo+IFRoZSBwYXRjaCB0aXRsZWQKPiAgICAgIFN1YmplY3Q6IG9jZnMyOiBm
aXggdXNlLWFmdGVyLWZyZWUgd2hlbiB1bm1vdW50aW5nIHJlYWQtb25seSBmaWxlc3lzdGVtCj4g
aGFzIGJlZW4gYWRkZWQgdG8gdGhlIC1tbSBtbS1ob3RmaXhlcy11bnN0YWJsZSBicmFuY2guICBJ
dHMgZmlsZW5hbWUgaXMKPiAgICAgIG9jZnMyLWZpeC11c2UtYWZ0ZXItZnJlZS13aGVuLXVubW91
bnRpbmctcmVhZC1vbmx5LWZpbGVzeXN0ZW0ucGF0Y2gKPiAKPiBUaGlzIHBhdGNoIHdpbGwgc2hv
cnRseSBhcHBlYXIgYXQKPiAgICAgIGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51
eC9rZXJuZWwvZ2l0L2FrcG0vMjUtbmV3LmdpdC90cmVlL3BhdGNoZXMvb2NmczItZml4LXVzZS1h
ZnRlci1mcmVlLXdoZW4tdW5tb3VudGluZy1yZWFkLW9ubHktZmlsZXN5c3RlbS5wYXRjaAo+IAo+
IFRoaXMgcGF0Y2ggd2lsbCBsYXRlciBhcHBlYXIgaW4gdGhlIG1tLWhvdGZpeGVzLXVuc3RhYmxl
IGJyYW5jaCBhdAo+ICAgICBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5l
bC9naXQvYWtwbS9tbQo+IAo+IEJlZm9yZSB5b3UganVzdCBnbyBhbmQgaGl0ICJyZXBseSIsIHBs
ZWFzZToKPiAgICBhKSBDb25zaWRlciB3aG8gZWxzZSBzaG91bGQgYmUgY2MnZWQKPiAgICBiKSBQ
cmVmZXIgdG8gY2MgYSBzdWl0YWJsZSBtYWlsaW5nIGxpc3QgYXMgd2VsbAo+ICAgIGMpIElkZWFs
bHk6IGZpbmQgdGhlIG9yaWdpbmFsIHBhdGNoIG9uIHRoZSBtYWlsaW5nIGxpc3QgYW5kIGRvIGEK
PiAgICAgICByZXBseS10by1hbGwgdG8gdGhhdCwgYWRkaW5nIHN1aXRhYmxlIGFkZGl0aW9uYWwg
Y2Mncwo+IAo+ICoqKiBSZW1lbWJlciB0byB1c2UgRG9jdW1lbnRhdGlvbi9wcm9jZXNzL3N1Ym1p
dC1jaGVja2xpc3QucnN0IHdoZW4gdGVzdGluZyB5b3VyIGNvZGUgKioqCj4gCj4gVGhlIC1tbSB0
cmVlIGlzIGluY2x1ZGVkIGludG8gbGludXgtbmV4dCB2aWEgdGhlIG1tLWV2ZXJ5dGhpbmcKPiBi
cmFuY2ggYXQgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2Fr
cG0vbW0KPiBhbmQgaXMgdXBkYXRlZCB0aGVyZSBldmVyeSAyLTMgd29ya2luZyBkYXlzCj4gCj4g
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCj4g
RnJvbTogTHXDrXMgSGVucmlxdWVzIDxvY2ZzMi1kZXZlbEBvc3Mub3JhY2xlLmNvbT4KPiBTdWJq
ZWN0OiBvY2ZzMjogZml4IHVzZS1hZnRlci1mcmVlIHdoZW4gdW5tb3VudGluZyByZWFkLW9ubHkg
ZmlsZXN5c3RlbQo+IERhdGU6IE1vbiwgMjIgTWF5IDIwMjMgMTE6MjE6MTIgKzAxMDAKPiAKPiBJ
dCdzIHRyaXZpYWwgdG8gdHJpZ2dlciBhIHVzZS1hZnRlci1mcmVlIGJ1ZyBpbiB0aGUgb2NmczIg
cXVvdGFzIGNvZGUKPiB1c2luZyBmc3Rlc3QgZ2VuZXJpYy80NTIuICBBZnRlciBtb3VudGluZyBh
IGZpbGVzeXN0ZW0gYXMgcmVhZC1vbmx5LAo+IHF1b3RhcyBhcmUgc3VzcGVuZGVkIGFuZCBvY2Zz
Ml9tZW1fZHFpbmZvIGlzIGZyZWVkIHRocm91Z2gKPiAtPm9jZnMyX2xvY2FsX2ZyZWVfaW5mbygp
LiAgV2hlbiB1bm1vdW50aW5nIHRoZSBmaWxlc3lzdGVtLCBhbiBVQUYgYWNjZXNzCj4gdG8gdGhl
IG9pbmZvIHdpbGwgZXZlbnR1YWxseSBjYXVzZSBhIGNyYXNoLgo+IAo+IExpbms6IGh0dHBzOi8v
bGttbC5rZXJuZWwub3JnL3IvMjAyMzA1MjIxMDIxMTIuOTAzMS0xLWxoZW5yaXF1ZXNAc3VzZS5k
ZQo+IFNpZ25lZC1vZmYtYnk6IEx1w61zIEhlbnJpcXVlcyA8bGhlbnJpcXVlc0BzdXNlLmRlPgo+
IFJldmlld2VkLWJ5OiBKb3NlcGggUWkgPGpvc2VwaC5xaUBsaW51eC5hbGliYWJhLmNvbT4KPiBU
ZXN0ZWQtYnk6IEpvc2VwaCBRaSA8am9zZXBoLnFpQGxpbnV4LmFsaWJhYmEuY29tPgo+IENjOiBN
YXJrIEZhc2hlaCA8bWFya0BmYXNoZWguY29tPgo+IENjOiBKb2VsIEJlY2tlciA8amxiZWNAZXZp
bHBsYW4ub3JnPgo+IENjOiBKdW54aWFvIEJpIDxqdW54aWFvLmJpQG9yYWNsZS5jb20+Cj4gQ2M6
IENoYW5nd2VpIEdlIDxnZWNoYW5nd2VpQGxpdmUuY24+Cj4gQ2M6IEdhbmcgSGUgPGdoZUBzdXNl
LmNvbT4KPiBDYzogSnVuIFBpYW8gPHBpYW9qdW5AaHVhd2VpLmNvbT4KPiBTaWduZWQtb2ZmLWJ5
OiBBbmRyZXcgTW9ydG9uIDxha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnPgo+IC0tLQo+IAo+ICBm
cy9vY2ZzMi9zdXBlci5jIHwgICAgNiArKysrLS0KPiAgMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0
aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKPiAKPiAtLS0gYS9mcy9vY2ZzMi9zdXBlci5jfm9jZnMy
LWZpeC11c2UtYWZ0ZXItZnJlZS13aGVuLXVubW91bnRpbmctcmVhZC1vbmx5LWZpbGVzeXN0ZW0K
PiArKysgYS9mcy9vY2ZzMi9zdXBlci5jCj4gQEAgLTk1Miw4ICs5NTIsMTAgQEAgc3RhdGljIHZv
aWQgb2NmczJfZGlzYWJsZV9xdW90YXMoc3RydWN0Cj4gIAlmb3IgKHR5cGUgPSAwOyB0eXBlIDwg
T0NGUzJfTUFYUVVPVEFTOyB0eXBlKyspIHsKPiAgCQlpZiAoIXNiX2hhc19xdW90YV9sb2FkZWQo
c2IsIHR5cGUpKQo+ICAJCQljb250aW51ZTsKPiAtCQlvaW5mbyA9IHNiX2RxaW5mbyhzYiwgdHlw
ZSktPmRxaV9wcml2Owo+IC0JCWNhbmNlbF9kZWxheWVkX3dvcmtfc3luYygmb2luZm8tPmRxaV9z
eW5jX3dvcmspOwo+ICsJCWlmICghc2JfaGFzX3F1b3RhX3N1c3BlbmRlZChzYiwgdHlwZSkpIHsK
PiArCQkJb2luZm8gPSBzYl9kcWluZm8oc2IsIHR5cGUpLT5kcWlfcHJpdjsKPiArCQkJY2FuY2Vs
X2RlbGF5ZWRfd29ya19zeW5jKCZvaW5mby0+ZHFpX3N5bmNfd29yayk7Cj4gKwkJfQo+ICAJCWlu
b2RlID0gaWdyYWIoc2ItPnNfZHF1b3QuZmlsZXNbdHlwZV0pOwo+ICAJCS8qIFR1cm4gb2ZmIHF1
b3Rhcy4gVGhpcyB3aWxsIHJlbW92ZSBhbGwgZHF1b3Qgc3RydWN0dXJlcyBmcm9tCj4gIAkJICog
bWVtb3J5IGFuZCBzbyB0aGV5IHdpbGwgYmUgYXV0b21hdGljYWxseSBzeW5jZWQgdG8gZ2xvYmFs
Cj4gXwo+IAo+IFBhdGNoZXMgY3VycmVudGx5IGluIC1tbSB3aGljaCBtaWdodCBiZSBmcm9tIG9j
ZnMyLWRldmVsQG9zcy5vcmFjbGUuY29tIGFyZQo+IAo+IG9jZnMyLWZpeC11c2UtYWZ0ZXItZnJl
ZS13aGVuLXVubW91bnRpbmctcmVhZC1vbmx5LWZpbGVzeXN0ZW0ucGF0Y2gKCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCk9jZnMyLWRldmVsIG1haWxpbmcg
bGlzdApPY2ZzMi1kZXZlbEBvc3Mub3JhY2xlLmNvbQpodHRwczovL29zcy5vcmFjbGUuY29tL21h
aWxtYW4vbGlzdGluZm8vb2NmczItZGV2ZWw=
