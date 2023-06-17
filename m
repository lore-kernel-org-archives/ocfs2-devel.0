Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3F00EB64DA
	for <ocfs2-devel@archiver.kernel.org>; Sat, 17 Jun 2023 08:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=2pxd8kTFupR4W0o2t+8ejoyd+lLtc3QppkGG8PRXYN4=;
 b=t+UGggXp9AokiF3vepyjTktv0qC8WF4L4onxHVXoM9KJYni9zRUODMmW/p1f/3XH4nSOVCwLLaZP
   NbWVKIU1c2trlFlp2kwdVZbZQO/j3x70109rXK3jyyZ3dKQ+VrexIGsLWqxgm2oUWs9Sv+pHenr0
   s8C+QZMbbSExjPmi1Qfi+1jcWEfKNkxpSwQFLtilaQATade2/6kE+o47EdU1gNCddg05Y37WkUF4
   XSJnQ7Nw/jsxqXzxENSEkMSv36r8rrcXGVsOPRkg0guGPBe9sGWlxn7w+xWkaUMgUXI3AoUaMy9o
   HESYqJLBf2Y6s4KlpXjAW+ZO+exXX14HJOJrhg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=2pxd8kTFupR4W0o2t+8ejoyd+lLtc3QppkGG8PRXYN4=;
 b=XRez3M55r8cccPNZbVvBn8Ia3pbK7Jnrcf1JtpLXszsEle7OekvLbpzU5H+0ZGVeFuRbi5o9gWO3
   +i0WZR8dIcuyxN8hCXfEGhNTl0VXhGLsn1GwL48+iPeG8DPmh59Jha6w64npecsHB8C7DIP31mKM
   mAQk5UoPFS4aY3Hj1pwkOnwFcCqys9/q0RFUyq2mNaAOuhIiSucFetn/LycPuxXM5frjyfP40bQp
   ag/rSL12ugzPmA1lBW9bvHjfLMJ2+DumYizViUCsbu3a7IlSgt5z3pngo5TbbeBXCW8yLCtmqSdx
   O1CUHOk9vPK05s69Gx4SoGW+kqEyRZVyb6R47g==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWE0056M2M7EV00@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 17 Jun 2023 08:37:19 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1686991027; bh=LflAlvoHQrg5uRCh4P0SS0th94PICDo+kdB2dgQefWQ=;
 h=Subject:To:Cc:From:Date:From;
 b=PLw+QuuFZsNBWjMBYbuoQvaosbvEodOK6SuPStfWlVWe20VhK2BvKTHcvQYcT7knN
 MAymEyMPHWFnFkYZsiJeotmVZ7na/DnNmos7VFAXkwhWNd+lESQQRj9SoH2DXJEmxr
 2vnvD/nUyxuau+mNR+O6liiZBpcr7UPoBBaWEa1I=
To: akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
 gregkh@linuxfoundation.org, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 junxiao.bi@oracle.com, lhenriques@suse.de, mark@fasheh.com,
 ocfs2-devel@oss.oracle.com, piaojun@huawei.com
Date: Sat, 17 Jun 2023 10:33:11 +0200
Message-id: <2023061710-paralysis-unaware-faf8@gregkh>
MIME-version: 1.0
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10743
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 adultscore=0 priorityscore=48 bulkscore=0 suspectscore=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 impostorscore=0 clxscore=203
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306170078 domainage_hfrom=7830
Cc: stable-commits@vger.kernel.org
Subject: [Ocfs2-devel] Patch "ocfs2: check new file size on fallocate call"	has
 been added to the 6.3-stable tree
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
From: gregkh--- via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: gregkh@linuxfoundation.org
Content-type: text/plain; charset="utf-8"
Content-transfer-encoding: base64
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-stable: commit
X-Patchwork-Hint: ignore
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:72.55.140.81 ip4:52.25.139.140
 ip4:139.178.84.217 ip6:2604:1380:4641:c500::1 ip4:145.40.68.75
 ip6:2604:1380:4601:e00::1 ip4:145.40.73.55 ip6:2604:1380:40e1:4800::1
 include:_spf.google.com include:amazonses.com include:_spf.salesforce.com -all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: u1Tv1ZPY7357GijGprnSFDHDP8HBdhVl
X-Proofpoint-GUID: u1Tv1ZPY7357GijGprnSFDHDP8HBdhVl
Reporting-Meta:
 AAHnDXiYslLs7nvdzu17+Dyb1d1xNU7gb2toJf0505uM7Bbv2zMH/KcqMEA2F89q
 TNywbGxs/NBTA2bpRNkBSD3I9obyuyd4hL3gK/CJCouiIZzCFrfe0EkG7OL+HK4d
 0A4deBfvv5hirY/nI7oM9cmEo+KKs6J619tgyXHor4a7KE2DK5Toc8G2P+vrmr5W
 qq/9KVJAt/WTCQ4lTiIeMMw52BSLsBH3h2QfhKPwQIzuDxlAiRVz6KMGKz1QMJx8
 i/PwPRQYEZZ2tCx0q99r9qb0aRxZx6CaLS8H6i0z0bMkBPHrWhWmgdMeH7lKGTFz
 DK8AxFFBGqLTKaeLfkupfHx08hRr6wNkpdfwo7nS487Pbx8n3QhKZK3UJLxukM+G
 FNDnCjmyPVGFApmkxHtzOSXq7NHtLhMyivLkm7T6HUN24o7NBC9gYEWStZd2ODK/
 tnfL3CkczXCg0Hsdf4Da3uZ4MOhn6/x03S6tGWyAUVWRotYNekbEijLeWtpCiuMX
 CBxqj6R/F1L+RfxfiELC25pCxZKHe5gHBYgDKSU+CPd72Q==

ClRoaXMgaXMgYSBub3RlIHRvIGxldCB5b3Uga25vdyB0aGF0IEkndmUganVzdCBhZGRlZCB0aGUg
cGF0Y2ggdGl0bGVkCgogICAgb2NmczI6IGNoZWNrIG5ldyBmaWxlIHNpemUgb24gZmFsbG9jYXRl
IGNhbGwKCnRvIHRoZSA2LjMtc3RhYmxlIHRyZWUgd2hpY2ggY2FuIGJlIGZvdW5kIGF0OgogICAg
aHR0cDovL3d3dy5rZXJuZWwub3JnL2dpdC8/cD1saW51eC9rZXJuZWwvZ2l0L3N0YWJsZS9zdGFi
bGUtcXVldWUuZ2l0O2E9c3VtbWFyeQoKVGhlIGZpbGVuYW1lIG9mIHRoZSBwYXRjaCBpczoKICAg
ICBvY2ZzMi1jaGVjay1uZXctZmlsZS1zaXplLW9uLWZhbGxvY2F0ZS1jYWxsLnBhdGNoCmFuZCBp
dCBjYW4gYmUgZm91bmQgaW4gdGhlIHF1ZXVlLTYuMyBzdWJkaXJlY3RvcnkuCgpJZiB5b3UsIG9y
IGFueW9uZSBlbHNlLCBmZWVscyBpdCBzaG91bGQgbm90IGJlIGFkZGVkIHRvIHRoZSBzdGFibGUg
dHJlZSwKcGxlYXNlIGxldCA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4ga25vdyBhYm91dCBpdC4K
CgpGcm9tIDI2YTZmZmZmN2RlNWRkMzY5Y2RiMTJlMzhiYTExZGI2ODJmMWRlYzAgTW9uIFNlcCAx
NyAwMDowMDowMCAyMDAxCkZyb206ID0/VVRGLTg/cT9MdT1DMz1BRHM9MjBIZW5yaXF1ZXM/PSA8
b2NmczItZGV2ZWxAb3NzLm9yYWNsZS5jb20+CkRhdGU6IE1vbiwgMjkgTWF5IDIwMjMgMTY6MjY6
NDUgKzAxMDAKU3ViamVjdDogb2NmczI6IGNoZWNrIG5ldyBmaWxlIHNpemUgb24gZmFsbG9jYXRl
IGNhbGwKTUlNRS1WZXJzaW9uOiAxLjAKQ29udGVudC1UeXBlOiB0ZXh0L3BsYWluOyBjaGFyc2V0
PVVURi04CkNvbnRlbnQtVHJhbnNmZXItRW5jb2Rpbmc6IDhiaXQKCkZyb206IEx1w61zIEhlbnJp
cXVlcyA8b2NmczItZGV2ZWxAb3NzLm9yYWNsZS5jb20+Cgpjb21taXQgMjZhNmZmZmY3ZGU1ZGQz
NjljZGIxMmUzOGJhMTFkYjY4MmYxZGVjMCB1cHN0cmVhbS4KCldoZW4gY2hhbmdpbmcgYSBmaWxl
IHNpemUgd2l0aCBmYWxsb2NhdGUoKSB0aGUgbmV3IHNpemUgaXNuJ3QgYmVpbmcKY2hlY2tlZC4g
IEluIHBhcnRpY3VsYXIsIHRoZSBGU0laRSB1bGltaXQgaXNuJ3QgYmVpbmcgY2hlY2tlZCwgd2hp
Y2ggbWFrZXMKZnN0ZXN0IGdlbmVyaWMvMjI4IGZhaWwuICBTaW1wbHkgYWRkaW5nIGEgY2FsbCB0
byBpbm9kZV9uZXdzaXplX29rKCkgZml4ZXMKdGhpcyBpc3N1ZS4KCkxpbms6IGh0dHBzOi8vbGtt
bC5rZXJuZWwub3JnL3IvMjAyMzA1MjkxNTI2NDUuMzI2ODAtMS1saGVucmlxdWVzQHN1c2UuZGUK
U2lnbmVkLW9mZi1ieTogTHXDrXMgSGVucmlxdWVzIDxsaGVucmlxdWVzQHN1c2UuZGU+ClJldmll
d2VkLWJ5OiBNYXJrIEZhc2hlaCA8bWFya0BmYXNoZWguY29tPgpSZXZpZXdlZC1ieTogSm9zZXBo
IFFpIDxqb3NlcGgucWlAbGludXguYWxpYmFiYS5jb20+CkNjOiBKb2VsIEJlY2tlciA8amxiZWNA
ZXZpbHBsYW4ub3JnPgpDYzogSnVueGlhbyBCaSA8anVueGlhby5iaUBvcmFjbGUuY29tPgpDYzog
Q2hhbmd3ZWkgR2UgPGdlY2hhbmd3ZWlAbGl2ZS5jbj4KQ2M6IEdhbmcgSGUgPGdoZUBzdXNlLmNv
bT4KQ2M6IEp1biBQaWFvIDxwaWFvanVuQGh1YXdlaS5jb20+CkNjOiA8c3RhYmxlQHZnZXIua2Vy
bmVsLm9yZz4KU2lnbmVkLW9mZi1ieTogQW5kcmV3IE1vcnRvbiA8YWtwbUBsaW51eC1mb3VuZGF0
aW9uLm9yZz4KU2lnbmVkLW9mZi1ieTogR3JlZyBLcm9haC1IYXJ0bWFuIDxncmVna2hAbGludXhm
b3VuZGF0aW9uLm9yZz4KLS0tCiBmcy9vY2ZzMi9maWxlLmMgfCAgICA4ICsrKysrKystCiAxIGZp
bGUgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgotLS0gYS9mcy9vY2Zz
Mi9maWxlLmMKKysrIGIvZnMvb2NmczIvZmlsZS5jCkBAIC0yMTAwLDE0ICsyMTAwLDIwIEBAIHN0
YXRpYyBsb25nIG9jZnMyX2ZhbGxvY2F0ZShzdHJ1Y3QgZmlsZQogCXN0cnVjdCBvY2ZzMl9zcGFj
ZV9yZXN2IHNyOwogCWludCBjaGFuZ2Vfc2l6ZSA9IDE7CiAJaW50IGNtZCA9IE9DRlMyX0lPQ19S
RVNWU1A2NDsKKwlpbnQgcmV0ID0gMDsKIAogCWlmIChtb2RlICYgfihGQUxMT0NfRkxfS0VFUF9T
SVpFIHwgRkFMTE9DX0ZMX1BVTkNIX0hPTEUpKQogCQlyZXR1cm4gLUVPUE5PVFNVUFA7CiAJaWYg
KCFvY2ZzMl93cml0ZXNfdW53cml0dGVuX2V4dGVudHMob3NiKSkKIAkJcmV0dXJuIC1FT1BOT1RT
VVBQOwogCi0JaWYgKG1vZGUgJiBGQUxMT0NfRkxfS0VFUF9TSVpFKQorCWlmIChtb2RlICYgRkFM
TE9DX0ZMX0tFRVBfU0laRSkgewogCQljaGFuZ2Vfc2l6ZSA9IDA7CisJfSBlbHNlIHsKKwkJcmV0
ID0gaW5vZGVfbmV3c2l6ZV9vayhpbm9kZSwgb2Zmc2V0ICsgbGVuKTsKKwkJaWYgKHJldCkKKwkJ
CXJldHVybiByZXQ7CisJfQogCiAJaWYgKG1vZGUgJiBGQUxMT0NfRkxfUFVOQ0hfSE9MRSkKIAkJ
Y21kID0gT0NGUzJfSU9DX1VOUkVTVlNQNjQ7CgoKUGF0Y2hlcyBjdXJyZW50bHkgaW4gc3RhYmxl
LXF1ZXVlIHdoaWNoIG1pZ2h0IGJlIGZyb20gb2NmczItZGV2ZWxAb3NzLm9yYWNsZS5jb20gYXJl
CgpxdWV1ZS02LjMvb2NmczItY2hlY2stbmV3LWZpbGUtc2l6ZS1vbi1mYWxsb2NhdGUtY2FsbC5w
YXRjaApxdWV1ZS02LjMvb2NmczItZml4LXVzZS1hZnRlci1mcmVlLXdoZW4tdW5tb3VudGluZy1y
ZWFkLW9ubHktZmlsZXN5c3RlbS5wYXRjaAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18KT2NmczItZGV2ZWwgbWFpbGluZyBsaXN0Ck9jZnMyLWRldmVsQG9z
cy5vcmFjbGUuY29tCmh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFpbG1hbi9saXN0aW5mby9vY2Zz
Mi1kZXZlbA==
