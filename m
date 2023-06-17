Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90259EB64D9
	for <ocfs2-devel@archiver.kernel.org>; Sat, 17 Jun 2023 08:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=O83cIRZALvTa9739MJfK1jzY5m4Fuf47zwacAeYPbJE=;
 b=1E2tusWoG50WpE+SDKitdmKxz4FMbdSFMIuKUAwjZXhBuP2p3kjdk5vM/MtoFMdlQUJ8Esgbm+Dj
   KzXBM1Gt5CTLjkLYtuf3nDZn7gFc9OshHXELShv4bya5jcqxHHEv5KZLy5OtvIpd0lT/qvHMWB15
   Kqt32UOUjTOPl9vmrUYWY6Oz/W6+yLUAKp+b5C8GgelyRiVwxtmz2WLWf4h1UdUv2s3TpoJnqE+i
   PbN/x47r7P6CjJnaOP+OnnN7CtX22PqIdsl+FH/ofkRFQmgJ02kSZUh1KdDXshDVZ+4Tew+A+gRH
   0fMZwZk5BT5DZyopXXEHI9KAhDKWfy7PXOzARw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=O83cIRZALvTa9739MJfK1jzY5m4Fuf47zwacAeYPbJE=;
 b=eXVruxAJwTSX6mLnVQRaLtVO62nSaD4RGGVSnuzZq35m6wFj5w1QlW+3/OkpotUJ7bpk4mleVIMx
   EF+m4oQeiIaJYjxbk+LZuJzBVa7ooJ4WjlLZNojWo0BO5Ylo0+5yjgOBrKxolECQ1z5IRnt9anT5
   Lts4edRFBBp+LWL4SEFzmNq5aSqvp3CbpToiIYc11TvXBikwGVX1G3nr2xxQ8PAyG7LrjzbLqFff
   dz8ZsFhCK+uWSghyf62kUyvPLdMUl3VdoqN/MXYmyc9t0vyD7mkuhOmZWA+oJnVPEzMqTeqajGde
   8wjQxTzoEmFtIYufSG3wwS0fGDjVI4h5afdFwg==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWE00G892IONSA0@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 17 Jun 2023 08:35:12 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1686990900; bh=vUQR1Nkmwcfp9bM7eqV2VJp7FK2Yf7VM225tafZC17g=;
 h=Subject:To:Cc:From:Date:From;
 b=dT2jvIEvk3P1ZBNFqi+joNzeNpkFqt4zZMwGd2jhXaIbe3wec+mpYahqIVrrfidwr
 3SlOxTLg9g5tK9oc6wOrNezXq5Oc+G734VnUKlQ+3DRChiMI4g5c1hz9S/NfffnRXz
 0PzIHirK+PdsKhfKCusz7BkakFchiDf6427oXrxY=
To: akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
 gregkh@linuxfoundation.org, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 junxiao.bi@oracle.com, lhenriques@suse.de, mark@fasheh.com,
 ocfs2-devel@oss.oracle.com, piaojun@huawei.com
Date: Sat, 17 Jun 2023 10:32:47 +0200
Message-id: <2023061747-cubbyhole-darkness-4550@gregkh>
MIME-version: 1.0
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10743
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 mlxscore=0 priorityscore=30 impostorscore=0 clxscore=203
 spamscore=0 adultscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306170077 domainage_hfrom=7830
Cc: stable-commits@vger.kernel.org
Subject: [Ocfs2-devel] Patch "ocfs2: check new file size on fallocate call"	has
 been added to the 6.1-stable tree
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
X-Proofpoint-GUID: Kt-CglW9qMLYLpVmgEfIUMPQtpQ5vlgt
X-Proofpoint-ORIG-GUID: Kt-CglW9qMLYLpVmgEfIUMPQtpQ5vlgt
Reporting-Meta:
 AAHIWLRLoYbZRyUC4nLlO51BMGGUo3KfrIcxC0+ll++O3yPaB6RrSKdP6JvAWQH0
 g6M3Lz26Dki5qCfnQctj8FF7bViCbN9I/lwgM0HVLKii/PFD9+KjdgbHS8MGBgXi
 yFvSdkGiWuGJoVuMZDRrJTirnI2arlz0zTJzY4P8U39lBDhvMhjGgz6zUG9Z7sBV
 Kf2RmMapYzij974Vc7vra7+KY2Cv7viTcMP6UMLc3G40YHBgrCvar7AxQOqmMpQG
 b0AJI+lU6U0WiTPjegNOOjTwpmfimJdZcVenmlAnP2P1D4ifD3U/P0IQzwH4L4+R
 g1oWu0W+SMqisL++IpNiX/ljN6gHBpOrny3YzPsunBgHpQVjeGm2zTAfJqpiyomA
 VOKHlq+9FxtWcyN7tFjEh1rs4F01SwZCoHj8O0NHZORrTBoFpwxYmQrssRspO4/3
 DxzG+92+aetS61nkBqAQ8IEprB9GgFmZ1LSQS/6cmwgNXBMBJ4XhF/hQv1qqioDA
 7ecFvzKFD9exZZey912Iak1xGX2DGRe0fQSwAvbMAQguog==

ClRoaXMgaXMgYSBub3RlIHRvIGxldCB5b3Uga25vdyB0aGF0IEkndmUganVzdCBhZGRlZCB0aGUg
cGF0Y2ggdGl0bGVkCgogICAgb2NmczI6IGNoZWNrIG5ldyBmaWxlIHNpemUgb24gZmFsbG9jYXRl
IGNhbGwKCnRvIHRoZSA2LjEtc3RhYmxlIHRyZWUgd2hpY2ggY2FuIGJlIGZvdW5kIGF0OgogICAg
aHR0cDovL3d3dy5rZXJuZWwub3JnL2dpdC8/cD1saW51eC9rZXJuZWwvZ2l0L3N0YWJsZS9zdGFi
bGUtcXVldWUuZ2l0O2E9c3VtbWFyeQoKVGhlIGZpbGVuYW1lIG9mIHRoZSBwYXRjaCBpczoKICAg
ICBvY2ZzMi1jaGVjay1uZXctZmlsZS1zaXplLW9uLWZhbGxvY2F0ZS1jYWxsLnBhdGNoCmFuZCBp
dCBjYW4gYmUgZm91bmQgaW4gdGhlIHF1ZXVlLTYuMSBzdWJkaXJlY3RvcnkuCgpJZiB5b3UsIG9y
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
CgpxdWV1ZS02LjEvb2NmczItY2hlY2stbmV3LWZpbGUtc2l6ZS1vbi1mYWxsb2NhdGUtY2FsbC5w
YXRjaApxdWV1ZS02LjEvb2NmczItZml4LXVzZS1hZnRlci1mcmVlLXdoZW4tdW5tb3VudGluZy1y
ZWFkLW9ubHktZmlsZXN5c3RlbS5wYXRjaAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18KT2NmczItZGV2ZWwgbWFpbGluZyBsaXN0Ck9jZnMyLWRldmVsQG9z
cy5vcmFjbGUuY29tCmh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFpbG1hbi9saXN0aW5mby9vY2Zz
Mi1kZXZlbA==
