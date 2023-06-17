Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33FAFEB64D9
	for <ocfs2-devel@archiver.kernel.org>; Sat, 17 Jun 2023 08:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=mxMHqPm/fM4IH/nPI8EJ3RWDjpFcZByssozRora/ovo=;
 b=0PdEWdIPPJFhb7Jj6cCsSR3hqUxGUQHvEWAtm6icV/uCO5bJtbEi1wR72WYmr5jRO4feCb7vVRDG
   YJKZ+s7g+PGoQ1PTCOn/Lx6hJ1CfjrTnIZ/pK69WyVr6l5/LNeGkOULLoA4A2BgrBSgFpZwTuYZb
   X0BkSTxWxhvRD0ZVoaSj3ls0I3k2Vq9Oo46QLsmoXtmGpD/SPa4UQ0PHCXJJiHqkZXPEQoW/07We
   xO4c8DiWIwbwUuE3m/xdn7gHgSCuiVLdIzCZpdm3XedklTKVL3Sef2AwinWasl6cEBdNtOeigA5+
   jTl/ACAFQFhAlUWN8YqdMiuBMsGyaPz+33BtUg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=mxMHqPm/fM4IH/nPI8EJ3RWDjpFcZByssozRora/ovo=;
 b=ugXc9g7MQ0tTR/H1yiLUUaDC+cr8Lqd9Y0KeRqrNyk61G5/fvMX/bCM/0Oh1ae3bM97/da+uHXmx
   hWvfEe8q2rKeQEeSrZy6Mv3VoWjvN2tVh2Zca3UyCYFerI7Q/QVl/tmlHZ6WYuelH5CejM0kl5Hu
   a5yS5ToeDW6L3l6EQP+lSRJbh6da4Ba2Z1YlrnM92H+4EqB+6+oztHyYoDmuCsgIVGjFe+XU1gRr
   U1nEM8ejp9zL1jfPr5vmXal/M87MoKg+4FjFazSLZMIRd/9YltdcP/ZF8H41vuyB1nlAPUETTRjy
   7QknqTPgUbOnu5987ZNiFjEredBwe3JQXrKCWA==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWE00L2U2EAQR80@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 17 Jun 2023 08:32:34 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1686990735; bh=dnbSsN0EUWAXVV7rMasB/szChKyw8IVfdcGsY8W4Kso=;
 h=Subject:To:Cc:From:Date:From;
 b=c6Tw+V0POhX9pxqmFYUIKQXIJ6z/BrDWr/TlS273GLSUhhtReogV0JikD52fxDjm9
 PwlXzNdrYESzHN3gSrgFoCo1jogStQlWAYNvCP2K8mkKEGRF8xglwicIsJez+zcnb+
 y+vJdyvJiFregLgFDOQiwJ/CMHkuVuEYCY99x9FU=
To: akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
 gregkh@linuxfoundation.org, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 junxiao.bi@oracle.com, lhenriques@suse.de, mark@fasheh.com,
 ocfs2-devel@oss.oracle.com, piaojun@huawei.com
Date: Sat, 17 Jun 2023 10:31:59 +0200
Message-id: <2023061759-unboxed-sulfur-6e68@gregkh>
MIME-version: 1.0
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10743
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 adultscore=0 priorityscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 impostorscore=0 clxscore=203
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306170077 domainage_hfrom=7830
Cc: stable-commits@vger.kernel.org
Subject: [Ocfs2-devel] Patch "ocfs2: check new file size on fallocate call"	has
 been added to the 5.4-stable tree
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
X-Proofpoint-GUID: v-EvIbdszR03NzQ4_kTq8QT5h8SUcKE4
X-Proofpoint-ORIG-GUID: v-EvIbdszR03NzQ4_kTq8QT5h8SUcKE4
Reporting-Meta:
 AAHMvcl9p8tKZ1dPZnzoLsKjOoMvaf7eLlTyBris1gL+tzkS3r2Cj+6gJ2lITXMl
 xmHlxgcmKKRiz2byrmS5FPedlGHi0fbVSMLqsb6pEcYYdy2GFLMT1nK8xGe2Bd8b
 ++9olnI8ImKhB/wJfAC30eQFsgwUGdbdfcy0/1gD70QDLlXodN7j5M+Zj1XuBw0q
 ILR3PJ7Yb8EXfhHe2g1l/BMp41ut/J4XuNYXHaLCxBUHvl0x2nheRZmcnFY4cfPv
 vMy2pX+akLpdhlcMvX2TjLkMwelqiehOVlT9z16d0TJGqm1PyGGMnpBN5o5TNeqi
 fOm17IF6Wrk5k6Gc9c4FABgCysJLV9d4vIdrI4SR7cEfujiOucCvCMRXIr6vL5VY
 ZTbrSM2P6TKCP4rJ0UOOIhxX8GdEsODGyFtrfiKbTvcYP8VhwS1lAiSZl1lWDArL
 apxtQIl+v15W8hypqpxiBi0wTUxqDesHc7s1IspFoiblZ2mfmidZitXhN3zDWm/n
 EvVj9jQbzDa/93vxWAs9X9sYQSdDxfFrkxO8OTiA1uDS

ClRoaXMgaXMgYSBub3RlIHRvIGxldCB5b3Uga25vdyB0aGF0IEkndmUganVzdCBhZGRlZCB0aGUg
cGF0Y2ggdGl0bGVkCgogICAgb2NmczI6IGNoZWNrIG5ldyBmaWxlIHNpemUgb24gZmFsbG9jYXRl
IGNhbGwKCnRvIHRoZSA1LjQtc3RhYmxlIHRyZWUgd2hpY2ggY2FuIGJlIGZvdW5kIGF0OgogICAg
aHR0cDovL3d3dy5rZXJuZWwub3JnL2dpdC8/cD1saW51eC9rZXJuZWwvZ2l0L3N0YWJsZS9zdGFi
bGUtcXVldWUuZ2l0O2E9c3VtbWFyeQoKVGhlIGZpbGVuYW1lIG9mIHRoZSBwYXRjaCBpczoKICAg
ICBvY2ZzMi1jaGVjay1uZXctZmlsZS1zaXplLW9uLWZhbGxvY2F0ZS1jYWxsLnBhdGNoCmFuZCBp
dCBjYW4gYmUgZm91bmQgaW4gdGhlIHF1ZXVlLTUuNCBzdWJkaXJlY3RvcnkuCgpJZiB5b3UsIG9y
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
Mi9maWxlLmMKKysrIGIvZnMvb2NmczIvZmlsZS5jCkBAIC0yMTAzLDE0ICsyMTAzLDIwIEBAIHN0
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
CgpxdWV1ZS01LjQvb2NmczItY2hlY2stbmV3LWZpbGUtc2l6ZS1vbi1mYWxsb2NhdGUtY2FsbC5w
YXRjaApxdWV1ZS01LjQvb2NmczItZml4LXVzZS1hZnRlci1mcmVlLXdoZW4tdW5tb3VudGluZy1y
ZWFkLW9ubHktZmlsZXN5c3RlbS5wYXRjaAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18KT2NmczItZGV2ZWwgbWFpbGluZyBsaXN0Ck9jZnMyLWRldmVsQG9z
cy5vcmFjbGUuY29tCmh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFpbG1hbi9saXN0aW5mby9vY2Zz
Mi1kZXZlbA==
