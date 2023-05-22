Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50188C7EE26
	for <ocfs2-devel@archiver.kernel.org>; Mon, 22 May 2023 12:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=GZ3EgggDN/MIF7H/fzkKglCXV0gMTucdc+euRm13BTk=;
 b=oHj0GPIcBrviF5ITRAxg9cVHH/SaV0apNC2rk/0mvf8BDq49NC0F7scp4KOIolPnrBMOQQviNR8b
   OF6Kgm8FVsO0/lDIAD1Rd/VG7zRnxwR3HBrlR+yD18flfLzl/Ug7kDVQ50NxHzO/L3NRiny9M+Yj
   karN59sG6l+hiPz4wqvOXYeE2CNhvlu6WYcIDvmIL0XBbXaRFXOB5RuV0Q3rFwlxhobt7USa8y+U
   5sp/uzxylOuFlSqj90GBO3o6Er9SfMY1yqIzW7nRdbTm2Ra1FAinhQLotB0pqiLJsAXT+xnTZDIB
   ubUd7ILqp8MhgyFESfd1egqNY27DdCbzgDv/Yg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=GZ3EgggDN/MIF7H/fzkKglCXV0gMTucdc+euRm13BTk=;
 b=Iaxc7KQ4kfP7eNbesOmG6YMhR2uAeFnBQFjFOe25q80/tqQ7FvqeMdnKtkQtX08E8mgBqzpuVrC3
   YE3XYTzodJBDxZtl82fgpE0hxsv0IXtYK5ymduMAnsRFS74ZyrfFiZKJsJ61otc8bZImFIEcvE/x
   otXP0whlQvoDIkT8pWkjKL4WtblpkSTFl1iI3ZODspzOHNNF7jb+VJhu0W7CHZ09R7amY/DRjaKi
   TLKKKMd6wkHUE/ovd7gg3+G76A4QhZb50xzKb1pdxj7QB/aA/dNB56ktVbMM8d8r+aqcqt5atZur
   uZY5rYmpnfu/Tf778kB3VYhkvRCEJqijNiDtow==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230420 64bit (built Apr 20
 2023))
 with ESMTPS id <0RV2001NB6QU4X60@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 22 May 2023 12:01:42 +0000 (GMT)
Message-id: <a57047d6-8f57-3dde-f15f-b24f63d675cd@linux.alibaba.com>
Date: Mon, 22 May 2023 20:01:25 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Content-language: en-US
To: =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
References: <20230522102506.9205-1-lhenriques@suse.de>
In-reply-to: <20230522102506.9205-1-lhenriques@suse.de>
X-Source-IP: 115.124.30.132
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10717
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 priorityscore=120 malwarescore=0 bulkscore=0 phishscore=0 clxscore=105
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305220100 domainage_hfrom=8803
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: fix use-after-free when unmounting
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
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R321e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018046059;
 MF=joseph.qi@linux.alibaba.com; NM=1; PH=DS; RN=6; SR=0;
 TI=SMTPD_---0VjEZgMP_1684756885;
X-ServerName: out30-132.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-GUID: 4eNNe2e6Kik10cET2LMiI4l5dmaiRNIK
X-Proofpoint-ORIG-GUID: 4eNNe2e6Kik10cET2LMiI4l5dmaiRNIK
Reporting-Meta:
 AAHwq37idYvwFadZzEtyenXv37wh+ku8BryD23ne6AN7GRNEMR2Jy0jOnKraBHpX
 f0i9AjM+MnmW+L6ygF9CqiTtTzg/q63nHqFCdjPSC3Sg40sm8nzF6oRIbBekXr4k
 VP6LKpBuH5N13yP+5CznR0PSMiO8GSdf3Sc04ooUrBKHb4wP2hmX9UN48EMCu8fC
 K19VJB3Vdfor//wRzDdliQyqEHWLD/rXq7tFFrWdX/4Zrcb52riRX8DEwOEaB9dE
 8rbVsoCxLT+IT9yq8kzrQ6sj3xgeMJ74m6Mxu9ELtLGEykc8lPe6Ilslsfw2bD1v
 i0lUj3h42+AhAgia60AkQT17bKOrh7Q7mpVShZ9saSeK+Tehi3JjK1NV5ZRtkgk8
 iNYKnZi1e8hu5F3XDQavYsSYRYozzDoB7AL/74uZxL0CnQMSzxD7XGQlxT7GaMQW
 NzWwtdd3JsX07pB315T/rRLVC6vRpRWKCADjvoDwGhNiqZwIqC82sN++xUmacPFk
 yn8pqyYY241WP3kqsS4vtqonU6IilIa9r5mVIys06C0k

CgpPbiA1LzIyLzIzIDY6MjUgUE0sIEx1w61zIEhlbnJpcXVlcyB3cm90ZToKPiBJdCdzIHRyaXZp
YWwgdG8gdHJpZ2dlciBhIHVzZS1hZnRlci1mcmVlIGJ1ZyBpbiB0aGUgb2NmczIgcXVvdGFzIGNv
ZGUgdXNpbmcKPiBmc3Rlc3QgZ2VuZXJpYy80NTIuICBBZnRlciBtb3VudGluZyBhIGZpbGVzeXN0
ZW0gYXMgcmVhZC1vbmx5LCBxdW90YXMgYXJlCgpnZW5lcmljLzQ1MiBpcyBmb3IgdGVzdGluZyBl
eHQ0IG1vdW50ZWQgd2l0aCBkYXggYW5kIHJvLgpCdXQgb2NmczIgZG9lc24ndCBzdXBwb3J0IGRh
eCB5ZXQuIAoKPiBzdXNwZW5kZWQgYW5kIG9jZnMyX21lbV9kcWluZm8gaXMgZnJlZWQgdGhyb3Vn
aCAtPm9jZnMyX2xvY2FsX2ZyZWVfaW5mbygpLiAgV2hlbgo+IHVubW91bnRpbmcgdGhlIGZpbGVz
eXN0ZW0sIGFuIFVBRiBhY2Nlc3MgdG8gdGhlIG9pbmZvIHdpbGwgZXZlbnR1YWxseSBjYXVzZSBh
Cj4gY3Jhc2guCgpJbiBvY2ZzMl9maWxsX3N1cGVyKCksIGl0IHdvbid0IGVuYWJsZSBxdW90YSBp
ZiBpcyBhIHJlYWRvbmx5IG1vdW50LgpEbyB5b3UgbWVhbiByZW1vdW50IGFzIHJlYWRvbmx5PwoK
VGhhbmtzLApKb3NlcGgKCj4gCj4gQ2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPgo+IFNpZ25l
ZC1vZmYtYnk6IEx1w61zIEhlbnJpcXVlcyA8bGhlbnJpcXVlc0BzdXNlLmRlPgo+IC0tLQo+ICBm
cy9vY2ZzMi9zdXBlci5jIHwgNiArKysrLS0KPiAgMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9u
cygrKSwgMiBkZWxldGlvbnMoLSkKPiAKPiBkaWZmIC0tZ2l0IGEvZnMvb2NmczIvc3VwZXIuYyBi
L2ZzL29jZnMyL3N1cGVyLmMKPiBpbmRleCAwYjBlNmExMzIxMDEuLjk4OGQxYzA3Njg2MSAxMDA2
NDQKPiAtLS0gYS9mcy9vY2ZzMi9zdXBlci5jCj4gKysrIGIvZnMvb2NmczIvc3VwZXIuYwo+IEBA
IC05NTIsOCArOTUyLDEwIEBAIHN0YXRpYyB2b2lkIG9jZnMyX2Rpc2FibGVfcXVvdGFzKHN0cnVj
dCBvY2ZzMl9zdXBlciAqb3NiKQo+ICAJZm9yICh0eXBlID0gMDsgdHlwZSA8IE9DRlMyX01BWFFV
T1RBUzsgdHlwZSsrKSB7Cj4gIAkJaWYgKCFzYl9oYXNfcXVvdGFfbG9hZGVkKHNiLCB0eXBlKSkK
PiAgCQkJY29udGludWU7Cj4gLQkJb2luZm8gPSBzYl9kcWluZm8oc2IsIHR5cGUpLT5kcWlfcHJp
djsKPiAtCQljYW5jZWxfZGVsYXllZF93b3JrX3N5bmMoJm9pbmZvLT5kcWlfc3luY193b3JrKTsK
PiArCQlpZiAoIXNiX2hhc19xdW90YV9zdXNwZW5kZWQoc2IsIHR5cGUpKSB7Cj4gKwkJCW9pbmZv
ID0gc2JfZHFpbmZvKHNiLCB0eXBlKS0+ZHFpX3ByaXY7Cj4gKwkJCWNhbmNlbF9kZWxheWVkX3dv
cmtfc3luYygmb2luZm8tPmRxaV9zeW5jX3dvcmspOwo+ICsJCX0KPiAgCQlpbm9kZSA9IGlncmFi
KHNiLT5zX2RxdW90LmZpbGVzW3R5cGVdKTsKPiAgCQkvKiBUdXJuIG9mZiBxdW90YXMuIFRoaXMg
d2lsbCByZW1vdmUgYWxsIGRxdW90IHN0cnVjdHVyZXMgZnJvbQo+ICAJCSAqIG1lbW9yeSBhbmQg
c28gdGhleSB3aWxsIGJlIGF1dG9tYXRpY2FsbHkgc3luY2VkIHRvIGdsb2JhbAoKX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KT2NmczItZGV2ZWwgbWFpbGlu
ZyBsaXN0Ck9jZnMyLWRldmVsQG9zcy5vcmFjbGUuY29tCmh0dHBzOi8vb3NzLm9yYWNsZS5jb20v
bWFpbG1hbi9saXN0aW5mby9vY2ZzMi1kZXZlbA==
