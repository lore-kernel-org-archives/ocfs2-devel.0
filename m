Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B4E7C77B7C
	for <ocfs2-devel@archiver.kernel.org>; Wed, 24 May 2023 03:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=dwW0ZhpyCIyC3LgIYSxbLaSVTqq5HU4NHRSvqA10bXk=;
 b=fnzCRJnl+pQ+fprSf1/X6HEuILwWrcJFARb9gXSVrPlHGwp7Lu3m3vmW9tgKdmiEDF3pvH24K8SA
   CWHvBjn4rp4QaF+D4wm+v7JXUeoE0rnZ2HRQ2asJ0XCDtWg/zCJQ7uF6T3BI8hXBVi9nXJoVY4B9
   rsCavacdc9QyqETxMWIeSqGLhR/vfUM5+S3ceMgvVdmLYgHKsGW7MAfIXQ8zansnkvfRjh3tHiaP
   EM76ioXgTKe0tWCbDtgG67hNH+kbn9IXk4DvtcuCsuWNyciqxWET/MdZJkKyYPkaTVABPHfhk5GR
   7G/EpNhH3XTQbs4r1gYvaIwYgW/AJxefVU03vg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=dwW0ZhpyCIyC3LgIYSxbLaSVTqq5HU4NHRSvqA10bXk=;
 b=r5VEbaDTlLJnxEyb24Q33FXIFzNbtYn/1Du9IiwvJkYHt+dF83Y26Ka6CuLlBtOblDMLPzMvNm4q
   O9RDSbLMr8+4TTNvziBSi1xVqY79M4tILetDMllggxj+HQ8CEio/7TfwoCfuhAW70kGYnn6TMXpI
   GwlRFGXHwYAmtYhBxCZdmzZVF6Fb0E9Ged/6nmnrlUyKeR3pIwbJMtnC0XB0DBOE9p2ER9thYxcI
   1MsZkkxI+83Ime7F/qGASu1LuPs5+8tanUT+XjWM9tpUAXEFmmBXv3lP4hcdlZfcCax7bLty0l/U
   RA6CUJhgX/awnLjOy21RlcBawugEXYw6q2lwrw==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230420 64bit (built Apr 20
 2023))
 with ESMTPS id <0RV500AY48SQAAD0@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 24 May 2023 03:38:50 +0000 (GMT)
Message-id: <e9fc4b2f-1fcc-7c31-f346-59eccff50f9b@linux.alibaba.com>
Date: Wed, 24 May 2023 11:38:28 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Content-language: en-US
To: =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Heming Zhao <heming.zhao@suse.com>, akpm <akpm@linux-foundation.org>
References: <20230523093310.2628-1-lhenriques@suse.de>
In-reply-to: <20230523093310.2628-1-lhenriques@suse.de>
X-Source-IP: 115.124.30.119
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10719
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 phishscore=0 clxscore=160 lowpriorityscore=0 spamscore=0 priorityscore=48
 impostorscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305240029 domainage_hfrom=8805
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v2] ocfs2: fix use-after-free when unmounting
 read-only filesystem
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R681e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046059;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=7; SR=0;
 TI=SMTPD_---0VjMPeag_1684899508;
X-ServerName: out30-119.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: NYAcmGLsKAsvckqHnpHZuee_9EU0TQyW
X-Proofpoint-GUID: NYAcmGLsKAsvckqHnpHZuee_9EU0TQyW
Reporting-Meta:
 AAHmFp9wDyaWXhxQWGaFXamppkJmsxkhOOfIYZaqurfWwlKd7heaGeMfbAQdVCD8
 fwx6eJWDrC2M4rhmIwXYy1aS9CECuYnQ690/4RNwf+tOJme6On8/wxwjrIZqosxZ
 boC9R2PSeQZIZiBU4ApE4mwwUajRPIJk2xka5AE9sfNqRpjHj+bAds/DjX60Y6u2
 7l4NvUnPnmfcVDA2mx1eXTg22giDbcIOLanni7eZyYmzO4WkNF8fTTc5uXcf47IL
 5c4vaZ747BM8anZzn3ar088RczrQb4frVgjbVVZC65QdQ5YFlyRq9a+lAhiXvCcY
 XULUnOG0w2DkMmKHLoSUWNxwXPk9KR5gyUoTFtofHuaFjjFNiO7QAEousmBJqTg2
 td6K3ek7KFNdfdFAcixR5H5CDt5GwiigtF0oqNsgf88TcdVTeOcP6ysuOdW7k0qF
 bd0gcXZ0Onc3VOi55wEnh7jRoCHA95eM1sM3G0DvVv5Io7PoqmySMtOxwH2kq89u
 3se5fFEpOcwgj+UWclchRfxGkiisIVWhQ45nrXxZp6IEUQ==

CgpPbiA1LzIzLzIzIDU6MzMgUE0sIEx1w61zIEhlbnJpcXVlcyB3cm90ZToKPiBJdCdzIHRyaXZp
YWwgdG8gdHJpZ2dlciBhIHVzZS1hZnRlci1mcmVlIGJ1ZyBpbiB0aGUgb2NmczIgcXVvdGFzIGNv
ZGUgdXNpbmcKPiBmc3Rlc3QgZ2VuZXJpYy80NTIuICBBZnRlciBhIHJlYWQtb25seSByZW1vdW50
LCBxdW90YXMgYXJlIHN1c3BlbmRlZCBhbmQKPiBvY2ZzMl9tZW1fZHFpbmZvIGlzIGZyZWVkIHRo
cm91Z2ggLT5vY2ZzMl9sb2NhbF9mcmVlX2luZm8oKS4gIFdoZW4gdW5tb3VudGluZwo+IHRoZSBm
aWxlc3lzdGVtLCBhbiBVQUYgYWNjZXNzIHRvIHRoZSBvaW5mbyB3aWxsIGV2ZW50dWFsbHkgY2F1
c2UgYSBjcmFzaC4KPiAKPiBCVUc6IEtBU0FOOiBzbGFiLXVzZS1hZnRlci1mcmVlIGluIHRpbWVy
X2RlbGV0ZSsweDU0LzB4YzAKPiBSZWFkIG9mIHNpemUgOCBhdCBhZGRyIGZmZmY4ODgwMzg5YTgy
MDggYnkgdGFzayB1bW91bnQvNjY5Cj4gLi4uCj4gQ2FsbCBUcmFjZToKPiAgPFRBU0s+Cj4gIC4u
Lgo+ICB0aW1lcl9kZWxldGUrMHg1NC8weGMwCj4gIHRyeV90b19ncmFiX3BlbmRpbmcrMHgzMS8w
eDIzMAo+ICBfX2NhbmNlbF93b3JrX3RpbWVyKzB4NmMvMHgyNzAKPiAgb2NmczJfZGlzYWJsZV9x
dW90YXMuaXNyYS4wKzB4M2UvMHhmMCBbb2NmczJdCj4gIG9jZnMyX2Rpc21vdW50X3ZvbHVtZSsw
eGRkLzB4NDUwIFtvY2ZzMl0KPiAgZ2VuZXJpY19zaHV0ZG93bl9zdXBlcisweGFhLzB4MjgwCj4g
IGtpbGxfYmxvY2tfc3VwZXIrMHg0Ni8weDcwCj4gIGRlYWN0aXZhdGVfbG9ja2VkX3N1cGVyKzB4
NGQvMHhiMAo+ICBjbGVhbnVwX21udCsweDEzNS8weDFmMAo+ICAuLi4KPiAgPC9UQVNLPgo+IAo+
IEFsbG9jYXRlZCBieSB0YXNrIDYzMjoKPiAga2FzYW5fc2F2ZV9zdGFjaysweDFjLzB4NDAKPiAg
a2FzYW5fc2V0X3RyYWNrKzB4MjEvMHgzMAo+ICBfX2thc2FuX2ttYWxsb2MrMHg4Yi8weDkwCj4g
IG9jZnMyX2xvY2FsX3JlYWRfaW5mbysweGUzLzB4OWEwIFtvY2ZzMl0KPiAgZHF1b3RfbG9hZF9x
dW90YV9zYisweDM0Yi8weDY4MAo+ICBkcXVvdF9sb2FkX3F1b3RhX2lub2RlKzB4ZmUvMHgxYTAK
PiAgb2NmczJfZW5hYmxlX3F1b3RhcysweDE5MC8weDJmMCBbb2NmczJdCj4gIG9jZnMyX2ZpbGxf
c3VwZXIrMHgxNGVmLzB4MjEyMCBbb2NmczJdCj4gIG1vdW50X2JkZXYrMHgxYmUvMHgyMDAKPiAg
bGVnYWN5X2dldF90cmVlKzB4NmMvMHhiMAo+ICB2ZnNfZ2V0X3RyZWUrMHgzZS8weDExMAo+ICBw
YXRoX21vdW50KzB4YTkwLzB4ZTEwCj4gIF9feDY0X3N5c19tb3VudCsweDE2Zi8weDFhMAo+ICBk
b19zeXNjYWxsXzY0KzB4NDMvMHg5MAo+ICBlbnRyeV9TWVNDQUxMXzY0X2FmdGVyX2h3ZnJhbWUr
MHg3Mi8weGRjCj4gCj4gRnJlZWQgYnkgdGFzayA2NTA6Cj4gIGthc2FuX3NhdmVfc3RhY2srMHgx
Yy8weDQwCj4gIGthc2FuX3NldF90cmFjaysweDIxLzB4MzAKPiAga2FzYW5fc2F2ZV9mcmVlX2lu
Zm8rMHgyYS8weDUwCj4gIF9fa2FzYW5fc2xhYl9mcmVlKzB4ZjkvMHgxNTAKPiAgX19rbWVtX2Nh
Y2hlX2ZyZWUrMHg4OS8weDE4MAo+ICBvY2ZzMl9sb2NhbF9mcmVlX2luZm8rMHgyYmEvMHgzZjAg
W29jZnMyXQo+ICBkcXVvdF9kaXNhYmxlKzB4MzVmLzB4YTcwCj4gIG9jZnMyX3N1c3BfcXVvdGFz
LmlzcmEuMCsweDE1OS8weDFhMCBbb2NmczJdCj4gIG9jZnMyX3JlbW91bnQrMHgxNTAvMHg1ODAg
W29jZnMyXQo+ICByZWNvbmZpZ3VyZV9zdXBlcisweDFhNS8weDNhMAo+ICBwYXRoX21vdW50KzB4
YzhhLzB4ZTEwCj4gIF9feDY0X3N5c19tb3VudCsweDE2Zi8weDFhMAo+ICBkb19zeXNjYWxsXzY0
KzB4NDMvMHg5MAo+ICBlbnRyeV9TWVNDQUxMXzY0X2FmdGVyX2h3ZnJhbWUrMHg3Mi8weGRjCj4g
Cj4gQ2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPgo+IFNpZ25lZC1vZmYtYnk6IEx1w61zIEhl
bnJpcXVlcyA8bGhlbnJpcXVlc0BzdXNlLmRlPgpSZXZpZXdlZC1ieTogSm9zZXBoIFFpIDxqb3Nl
cGgucWlAbGludXguYWxpYmFiYS5jb20+ClRlc3RlZC1ieTogSm9zZXBoIFFpIDxqb3NlcGgucWlA
bGludXguYWxpYmFiYS5jb20+CgpUZXN0ZWQgd2l0aCBmb2xsb3dpbmcgcHJvY2VkdXJlczoKbWtm
cy5vY2ZzMiAtYiA0ayAtQyAxTSAtTiAyIC0tZnMtZmVhdHVyZXM9dXNycXVvdGEsZ3JwcXVvdGEg
L2Rldi92ZGMKL2V0Yy9pbml0LmQvbzJjYi5pbml0IG9ubGluZSBvY2ZzMmNsdXN0ZXIKbW91bnQu
b2NmczIgLW8gdXNycXVvdGEsZ3JwcXVvdGEgL2Rldi92ZGMgL21udC9vY2ZzMgptb3VudC5vY2Zz
MiAtbyByZW1vdW50LHJvLGhlYXJ0YmVhdD1sb2NhbCAvZGV2L3ZkYyAvbW50L29jZnMyCnVtb3Vu
dCAvbW50L29jZnMyCgo+IC0tLQo+IENoYW5nZXMgc2luY2UgdjE6Cj4gIC0gRml4ZWQgY2hhbmdl
bG9nIHRvIGV4cGxpY2l0bHkgc3RhdGUgJ3JlYWQtb25seSByZW1vdW50Jwo+ICAtIEFkZGVkIEtB
U0FOIHNwbGF0IHRvIGNoYW5nZWxvZwo+IAo+ICBmcy9vY2ZzMi9zdXBlci5jIHwgNiArKysrLS0K
PiAgMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKPiAKPiBk
aWZmIC0tZ2l0IGEvZnMvb2NmczIvc3VwZXIuYyBiL2ZzL29jZnMyL3N1cGVyLmMKPiBpbmRleCAw
YjBlNmExMzIxMDEuLjk4OGQxYzA3Njg2MSAxMDA2NDQKPiAtLS0gYS9mcy9vY2ZzMi9zdXBlci5j
Cj4gKysrIGIvZnMvb2NmczIvc3VwZXIuYwo+IEBAIC05NTIsOCArOTUyLDEwIEBAIHN0YXRpYyB2
b2lkIG9jZnMyX2Rpc2FibGVfcXVvdGFzKHN0cnVjdCBvY2ZzMl9zdXBlciAqb3NiKQo+ICAJZm9y
ICh0eXBlID0gMDsgdHlwZSA8IE9DRlMyX01BWFFVT1RBUzsgdHlwZSsrKSB7Cj4gIAkJaWYgKCFz
Yl9oYXNfcXVvdGFfbG9hZGVkKHNiLCB0eXBlKSkKPiAgCQkJY29udGludWU7Cj4gLQkJb2luZm8g
PSBzYl9kcWluZm8oc2IsIHR5cGUpLT5kcWlfcHJpdjsKPiAtCQljYW5jZWxfZGVsYXllZF93b3Jr
X3N5bmMoJm9pbmZvLT5kcWlfc3luY193b3JrKTsKPiArCQlpZiAoIXNiX2hhc19xdW90YV9zdXNw
ZW5kZWQoc2IsIHR5cGUpKSB7Cj4gKwkJCW9pbmZvID0gc2JfZHFpbmZvKHNiLCB0eXBlKS0+ZHFp
X3ByaXY7Cj4gKwkJCWNhbmNlbF9kZWxheWVkX3dvcmtfc3luYygmb2luZm8tPmRxaV9zeW5jX3dv
cmspOwo+ICsJCX0KPiAgCQlpbm9kZSA9IGlncmFiKHNiLT5zX2RxdW90LmZpbGVzW3R5cGVdKTsK
PiAgCQkvKiBUdXJuIG9mZiBxdW90YXMuIFRoaXMgd2lsbCByZW1vdmUgYWxsIGRxdW90IHN0cnVj
dHVyZXMgZnJvbQo+ICAJCSAqIG1lbW9yeSBhbmQgc28gdGhleSB3aWxsIGJlIGF1dG9tYXRpY2Fs
bHkgc3luY2VkIHRvIGdsb2JhbAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18KT2NmczItZGV2ZWwgbWFpbGluZyBsaXN0Ck9jZnMyLWRldmVsQG9zcy5vcmFj
bGUuY29tCmh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFpbG1hbi9saXN0aW5mby9vY2ZzMi1kZXZl
bA==
