Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC326C77B78
	for <ocfs2-devel@archiver.kernel.org>; Wed, 22 Mar 2023 17:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=25Rypcv0xhWJv7HoS3BfBHkZci+0MNI+u/jTA2yaJL4=;
 b=DuSzmzrhaTeF0ht3wT5pibnP8PAfvDR8IEv2TFPk3hhmbxUVQXuRgZG7akNP8WnC4PVYPq93Ud+k
   2+G17o91/doahwn/HUKU/AkBmXwSnN55FibNk/rXQR07DCLv0D+/p5BMKq5htG1jOmF+V8drAy9u
   z3Fhs9HTqbMm7NVkCHf740CeRn2UXsgf0OqSgXhvJz4L9S+lV3iKeUoSiV683dGhncWuZWPHPBcw
   xjs5EBLZBxKhOMOM1np7COSHgk4Vjf6FSI/oaazuouOudx3fKkY0qVMvpbPh44pCjh/RFBmKSaM2
   zZ3Jk/mGLZWUGCyCr/1qDzUz1aVh6CT9ID32Zg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=25Rypcv0xhWJv7HoS3BfBHkZci+0MNI+u/jTA2yaJL4=;
 b=S1jZJkPlQYRSzbACjT6i3/gGDDtQhcAXZHlbAbVN21/q7y2Ooh/18Kudkf7fiFSqHaXh7PaZp7yw
   Yv6SCTjREwkyFYroiuy8dBXLbJHWOWYarxN2LsR943MNTb+HA6KWmSIimVdTgOqfsSva1GLzb7Cs
   pzmhKpVg6ytn+q4tsKLpedJ7uzbNzgriI9pyi7aIHHNuvET/7O0QBFSc01P5I7+Yss02FHH5JKh3
   1RS9PcvaZ2Jh15wnWQIxWvbQPhLbsQOlj8DE75pvYN7bHN/GhFvbvm8c4rhz7J1Kl+il5J05RizL
   4tZGhHqGXUfg4L05MMYTVoaj5PKwT1kILrPxww==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RRX00G6LM18NU70@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 22 Mar 2023 17:03:08 +0000 (GMT)
Message-id: <24a46ae8-6e50-2f45-f099-45743bb013c4@linux.alibaba.com>
Date: Fri, 10 Mar 2023 11:47:38 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
To: Al Viro <viro@zeniv.linux.org.uk>, Yangtao Li <frank.li@vivo.com>
References: <20230309152127.41427-1-frank.li@vivo.com>
 <20230309152127.41427-2-frank.li@vivo.com> <20230310031547.GD3390869@ZenIV>
 <2fa31829-03f0-7bfb-a89b-e3917c479733@linux.alibaba.com>
In-reply-to: <2fa31829-03f0-7bfb-a89b-e3917c479733@linux.alibaba.com>
X-Source-IP: 115.124.30.111
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10644
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=100 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0
 impostorscore=0 phishscore=0 mlxlogscore=999 lowpriorityscore=0 clxscore=33
 bulkscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303100028 domainage_hfrom=8730
Cc: brauner@kernel.org, tytso@mit.edu, agruenba@redhat.com, chao@kernel.org,
 linux-kernel@vger.kernel.org, cluster-devel@redhat.com, rpeterso@redhat.com,
 huyue2@coolpad.com, adilger.kernel@dilger.ca, jefflexu@linux.alibaba.com,
 linux-fsdevel@vger.kernel.org, xiang@kernel.org, linux-ext4@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH v3 2/6] erofs: convert to use i_blockmask()
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
From: Gao Xiang via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Gao Xiang <hsiangkao@linux.alibaba.com>
Content-transfer-encoding: base64
Content-type: text/plain; charset="utf-8"; Format="flowed"
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R191e4; CH=green;
 DM=||false|; DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=ay29a033018045192;
 MF=hsiangkao@linux.alibaba.com; NM=1; PH=DS; RN=20; SR=0;
 TI=SMTPD_---0VdVeWEX_1678420058;
X-ServerName: out30-111.freemail.mail.aliyun.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf1.service.alibaba.com
 include:spf2.service.alibaba.com include:spf1.ocm.aliyun.com
 include:spf2.ocm.aliyun.com include:spf1.staff.mail.aliyun.com
 include:a.hichina.mail.aliyun.com include:b.hichina.mail.aliyun.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: SwqdkG9U0OeZhoxf__gWfn02c-UE6K3C
X-Proofpoint-GUID: SwqdkG9U0OeZhoxf__gWfn02c-UE6K3C
X-Mailman-Approved-At: Wed, 22 Mar 2023 17:03:04 +0000
Reporting-Meta:
 AAECB8ZoSgJXAFTfOPt6KDx6qHBNTi27pcNLeZQ8VIRCBEQMfrfUYjPdDWMuyw9V
 ryUvKHsSfv/Xw0Es+/nMhE6DA4TZzdA/KnJtyHycCI7JWNBY0qXUKxLnhKoj7zJa
 YwIlvTMBBSk+LrLsiGGT7dhaId7hrQxBe0a3peLX/ptcRvVW4bB4wqTj+xiO37qT
 14lJIKN9xohjOSFep5gi3ZrXMn+VVCJNfv2bWA8RtaDKCamG3mw/7X/aHNLSOoRY
 cbMuYJVuhg+OYjBmLf+oopu3MFMXF/lpHWiqnG80qg3ZDPORsBbBHV+BwkX6iNC1
 lElfujmEgJ8psd6AhVTRH1A82uobaERZgJ1q4wX2TS16vEagKbW83mJ2Np2r1s/7
 Lo+ueL3/DeWut7s1jhGW1tHcifOizDIjx6dHKeDVvsRxnEgzrVq3dyJ1dNB+CZzb
 l3Mx/IqSF69mWmOyIuFG8OxCUMGG9NcoOceFgBL4m5zD2uE3DGABMaMGZTrAUOyu
 zVl1rqZTxFGNkmUWRQri+IotelsIwb5YSrsjDJAxY/9JwA==

CgpPbiAyMDIzLzMvMTAgMTE6NDIsIEdhbyBYaWFuZyB3cm90ZToKPiBIaSBBbCwKPiAKPiBPbiAy
MDIzLzMvMTAgMTE6MTUsIEFsIFZpcm8gd3JvdGU6Cj4+IE9uIFRodSwgTWFyIDA5LCAyMDIzIGF0
IDExOjIxOjIzUE0gKzA4MDAsIFlhbmd0YW8gTGkgd3JvdGU6Cj4+PiBVc2UgaV9ibG9ja21hc2so
KSB0byBzaW1wbGlmeSBjb2RlLgo+Pgo+PiBVbW0uLi7CoCBXaGF0J3MgdGhlIGJyYW5jaHBvaW50
IGZvciB0aGF0IHNlcmllcz/CoCBOb3QgdGhlIG1haW5saW5lIC0KPj4gdGhlcmUgd2UgaGF2ZSBp
X2Jsb2Nrc2l6ZSgpIG9wZW4tY29kZWQuLi4KPiAKPiBBY3R1YWxseSBZdWUgSHUgc2VudCBvdXQg
YSBjbGVhbi11cCBwYXRjaCBhbmQgSSBhcHBsaWVkIHRvIC1uZXh0IGZvcgo+IGFsbW9zdCBhIHdl
ZWsgYW5kIHdpbGwgYmUgdXBzdHJlYW1lZCBmb3IgNi4zLXJjMjoKPiAKPiBodHRwczovL2xvcmUu
a2VybmVsLm9yZy9yL2EyMzhkY2ExLTI1NmYtYWUyZi00YTMzLWU1NDg2MWZlNGZmYkBrZXJuZWwu
b3JnL1QvI3QKClNvcnJ5IHRoaXMgbGluazoKaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvci8wMjYx
ZGUzMS1lOThiLTg1Y2QtODBkZS05NmFmNWE3NmUxNWNAbGludXguYWxpYmFiYS5jb20KCllhbmd0
YW8ncyBzdWdnZXN0aW9uIHdhcyB0byB1c2UgR0VOTUFTSywgYW5kIEknbSBub3Qgc3VyZSBpdCdz
IGEgZ29vZCB3YXkKc2luY2UgKGlfYmxvY2tzaXplKGlub2RlKSAtIDEpIGlzIHNpbXBsZSBlbm91
Z2gsIGFuZCB0aGVuIGl0IGJlY29tZXMgbGlrZQp0aGlzLgoKVGhhbmtzLApHYW8gWGlhbmcKCgo+
IAo+IEFuZCB0aGVuIFlhbmd0YW8gd291bGQgbGlrZSB0byB3cmFwIHRoaXMgYXMgYSBuZXcgVkZT
IGhlbHBlciwgSSdtIG5vdAo+IHN1cmUgd2h5IGl0J3MgbmVjZXNzYXJ5IHNpbmNlIGl0IGRvZXNu
J3Qgc2F2ZSBhIGxvdCBidXQgYW55d2F5LCBJJ20gb3Blbgo+IHRvIGl0IGlmIFZGUyBjb3VsZCBo
YXZlIHN1Y2ggbmV3IGhlbHBlci4KPiAKPiBUaGFua3MsCj4gR2FvIFhpYW5nCj4gCj4+Cj4+PiBT
aWduZWQtb2ZmLWJ5OiBZYW5ndGFvIExpIDxmcmFuay5saUB2aXZvLmNvbT4KPj4+IC0tLQo+Pj4g
djM6Cj4+PiAtbm9uZQo+Pj4gdjI6Cj4+PiAtY29udmVydCB0byBpX2Jsb2NrbWFzaygpCj4+PiDC
oCBmcy9lcm9mcy9kYXRhLmMgfCAyICstCj4+PiDCoCAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRp
b24oKyksIDEgZGVsZXRpb24oLSkKPj4+Cj4+PiBkaWZmIC0tZ2l0IGEvZnMvZXJvZnMvZGF0YS5j
IGIvZnMvZXJvZnMvZGF0YS5jCj4+PiBpbmRleCA3ZThiYWY1NmZhYTUuLmU5ZDE4NjljZDRiMyAx
MDA2NDQKPj4+IC0tLSBhL2ZzL2Vyb2ZzL2RhdGEuYwo+Pj4gKysrIGIvZnMvZXJvZnMvZGF0YS5j
Cj4+PiBAQCAtMzgwLDcgKzM4MCw3IEBAIHN0YXRpYyBzc2l6ZV90IGVyb2ZzX2ZpbGVfcmVhZF9p
dGVyKHN0cnVjdCBraW9jYiAqaW9jYiwgc3RydWN0IGlvdl9pdGVyICp0bykKPj4+IMKgwqDCoMKg
wqDCoMKgwqDCoCBpZiAoYmRldikKPj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGJsa3Np
emVfbWFzayA9IGJkZXZfbG9naWNhbF9ibG9ja19zaXplKGJkZXYpIC0gMTsKPj4+IMKgwqDCoMKg
wqDCoMKgwqDCoCBlbHNlCj4+PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBibGtzaXplX21hc2sg
PSBpX2Jsb2Nrc2l6ZShpbm9kZSkgLSAxOwo+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYmxr
c2l6ZV9tYXNrID0gaV9ibG9ja21hc2soaW5vZGUpOwo+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgIGlm
ICgoaW9jYi0+a2lfcG9zIHwgaW92X2l0ZXJfY291bnQodG8pIHwKPj4+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgaW92X2l0ZXJfYWxpZ25tZW50KHRvKSkgJiBibGtzaXplX21hc2spCj4+
PiAtLSAKPj4+IDIuMjUuMQo+Pj4KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fCk9jZnMyLWRldmVsIG1haWxpbmcgbGlzdApPY2ZzMi1kZXZlbEBvc3Mub3Jh
Y2xlLmNvbQpodHRwczovL29zcy5vcmFjbGUuY29tL21haWxtYW4vbGlzdGluZm8vb2NmczItZGV2
ZWw=
