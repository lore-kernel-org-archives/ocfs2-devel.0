Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C249BC7EE23
	for <ocfs2-devel@archiver.kernel.org>; Mon, 29 May 2023 20:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=lJG9UIZeAQZBzqLem32BBppIx2vbNb8QaBVFQm37j3g=;
 b=lnyey4Hcfr19W9DVM2p450OuZi6OxyhDYtA6mbiZQnikrMIJonMihfq9uqcrGzPltEbKokscDZeH
   tKkGLgVAGTefcH7f1Kvx6Oix9oTtKIIi+eC4/Wn6v32XXCHrsIDW5TbEz1Qf9AenTXAtpCXxeS7L
   VI8bQ3vKCMkm4Az1uL35LSD2EO3phBwD7ZExhMvduDtPVehPsiGhXGaaLWyvYWaVEuriwQC4Qhng
   sMC17m7N1MgLqn4uetN+TqhuVgmg9nbpWbKxyJx+0yinPJkLdEof81SWKuQQDuqyyEuqpzJrEi5C
   pbIesb8Xa/fHUBstjTJyWlJa87qwvt61R1EFDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=lJG9UIZeAQZBzqLem32BBppIx2vbNb8QaBVFQm37j3g=;
 b=FthFFnh/BdX8Ake8F8M0FifH+zqGblWx618QANpSi6GtGBYskB8AC8U0mOrmg+wNuC1JJPXcm4P6
   ytnpVq+jq0oLL7xLTLi79HZq6GgN71wLFvh3y7tCnJBfSybos+xPqSkf1sp6DKpkgdonlY9aEPAD
   zgXuDfYZSnCA+u+XpUeCBi/dgh6q3ucxCYRm3il98cs/65S+tatWd6garsYoQK3VmxpVLpDotffy
   hN7DFFo5Qc8tEvHtHOLKe9y29XFCTi9YvWkpvdgeDvSCnbwVMyNLVru4OG9CkuGXEPRRtpGZFT1z
   iVss4jzKg6vqpGjK8fHkgTYcMIRx7HHjIaPPjw==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230522 64bit (built May 22
 2023))
 with ESMTPS id <0RVF00036SHZCI50@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 29 May 2023 20:20:23 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
 t=1684834391;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=/lOsj+GiEHTCgI/sii2dYOxPg7fwJmqfZ38JOxtYg30=;
 b=MrAQpfWLUi8IpVF/ihwJRsY81cRa/l0ICrSmRAiXdf0bw6F/jxlB/xcG75ZZYbt+i/w+tE
 4U0Gak5572dT/I9Awv/hOLzFw0Pq3mou8ftOdQWICeKYkAqO0l9fBeMcsNdEZXzJLHGe1H
 /9W813DNmhVFkCQSRASut1VGW0HPlVg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
 s=susede2_ed25519; t=1684834391;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=/lOsj+GiEHTCgI/sii2dYOxPg7fwJmqfZ38JOxtYg30=;
 b=hQaqF6vIDr8I6gzKDszU8Yir1ZU20woRIgODrQOtMrUjacCbU11TEWx1y9MWXcd1vReh3u
 VGSCYvIRftLAkxDg==
To: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>, Heming Zhao <heming.zhao@suse.com>
Date: Tue, 23 May 2023 10:33:10 +0100
Message-id: <20230523093310.2628-1-lhenriques@suse.de>
MIME-version: 1.0
X-Source-IP: 195.135.220.28
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10718
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 phishscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0 suspectscore=0
 adultscore=0 impostorscore=0 mlxscore=0 priorityscore=158 clxscore=40
 mlxlogscore=982 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305230078
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: fix use-after-free when unmounting
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
From: =?UTF-8?q?Lu=C3=ADs=20Henriques?= via Ocfs2-devel
 <ocfs2-devel@oss.oracle.com>
Reply-to: =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
Content-type: text/plain; charset="utf-8"
Content-transfer-encoding: base64
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: smtp-out1.suse.de
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:195.135.220.0/27
 ip6:2001:67c:2178:6::/120 ~all
X-Spam: Clean
X-Proofpoint-ORIG-GUID: hnygpYMo4MqQ7REjKz7OjFiyv8KzlcI5
X-Proofpoint-GUID: hnygpYMo4MqQ7REjKz7OjFiyv8KzlcI5
X-Mailman-Approved-At: Mon, 29 May 2023 20:20:22 +0000
Reporting-Meta:
 AAH6PMghFWHgU8v6fVDw5z5shb+R7t3uG+I0lRjClK7d8QY/htez+jtSKEadiLJi
 yOIb0IVyR8qcBCqh5XIiVG1icWGfBK5A1JViJAsU5XUjgDL6Dg0HP5bV0EOhdqRa
 4gJBcH1Z61HoZEt6XCIAewDiP9gffNpzA1haDzz6zp533weLvryV+n0wvthktl3t
 LerZUjLxDydvIAeB5wVBQBPkx9F0tbLMaLRwxK1vx6U0tm9REc3mILKXa3hJGcPi
 UhPoYvHa63NEmCec/fRpmfZOzSnQUp9Eq+YrZ5UcnoQg/SWhrz9JWfTo+HEUk/At
 Hub47n7V865PNTBdcuL921CrGWzlF5cY0ok8NBnb9zAL+d4Y4VVrxsBXUfsachUn
 TlE2Wp/lFAKKQODr7Y6Kzk1cMzcvZr7jTP/5YBlcKyum/Yg8vITEFr+Xq7e51/GH
 8MVY25hfLXv5PPBgkVBAuHiatYeuhuB5Opi+4qzRxcqdqF/DrS8vOgPEp98fIfDy
 +cAybX0z6AbI2IYA+URbKNDrd9MrCa8ZUBQxfOhGTf0S

SXQncyB0cml2aWFsIHRvIHRyaWdnZXIgYSB1c2UtYWZ0ZXItZnJlZSBidWcgaW4gdGhlIG9jZnMy
IHF1b3RhcyBjb2RlIHVzaW5nCmZzdGVzdCBnZW5lcmljLzQ1Mi4gIEFmdGVyIGEgcmVhZC1vbmx5
IHJlbW91bnQsIHF1b3RhcyBhcmUgc3VzcGVuZGVkIGFuZApvY2ZzMl9tZW1fZHFpbmZvIGlzIGZy
ZWVkIHRocm91Z2ggLT5vY2ZzMl9sb2NhbF9mcmVlX2luZm8oKS4gIFdoZW4gdW5tb3VudGluZwp0
aGUgZmlsZXN5c3RlbSwgYW4gVUFGIGFjY2VzcyB0byB0aGUgb2luZm8gd2lsbCBldmVudHVhbGx5
IGNhdXNlIGEgY3Jhc2guCgpCVUc6IEtBU0FOOiBzbGFiLXVzZS1hZnRlci1mcmVlIGluIHRpbWVy
X2RlbGV0ZSsweDU0LzB4YzAKUmVhZCBvZiBzaXplIDggYXQgYWRkciBmZmZmODg4MDM4OWE4MjA4
IGJ5IHRhc2sgdW1vdW50LzY2OQouLi4KQ2FsbCBUcmFjZToKIDxUQVNLPgogLi4uCiB0aW1lcl9k
ZWxldGUrMHg1NC8weGMwCiB0cnlfdG9fZ3JhYl9wZW5kaW5nKzB4MzEvMHgyMzAKIF9fY2FuY2Vs
X3dvcmtfdGltZXIrMHg2Yy8weDI3MAogb2NmczJfZGlzYWJsZV9xdW90YXMuaXNyYS4wKzB4M2Uv
MHhmMCBbb2NmczJdCiBvY2ZzMl9kaXNtb3VudF92b2x1bWUrMHhkZC8weDQ1MCBbb2NmczJdCiBn
ZW5lcmljX3NodXRkb3duX3N1cGVyKzB4YWEvMHgyODAKIGtpbGxfYmxvY2tfc3VwZXIrMHg0Ni8w
eDcwCiBkZWFjdGl2YXRlX2xvY2tlZF9zdXBlcisweDRkLzB4YjAKIGNsZWFudXBfbW50KzB4MTM1
LzB4MWYwCiAuLi4KIDwvVEFTSz4KCkFsbG9jYXRlZCBieSB0YXNrIDYzMjoKIGthc2FuX3NhdmVf
c3RhY2srMHgxYy8weDQwCiBrYXNhbl9zZXRfdHJhY2srMHgyMS8weDMwCiBfX2thc2FuX2ttYWxs
b2MrMHg4Yi8weDkwCiBvY2ZzMl9sb2NhbF9yZWFkX2luZm8rMHhlMy8weDlhMCBbb2NmczJdCiBk
cXVvdF9sb2FkX3F1b3RhX3NiKzB4MzRiLzB4NjgwCiBkcXVvdF9sb2FkX3F1b3RhX2lub2RlKzB4
ZmUvMHgxYTAKIG9jZnMyX2VuYWJsZV9xdW90YXMrMHgxOTAvMHgyZjAgW29jZnMyXQogb2NmczJf
ZmlsbF9zdXBlcisweDE0ZWYvMHgyMTIwIFtvY2ZzMl0KIG1vdW50X2JkZXYrMHgxYmUvMHgyMDAK
IGxlZ2FjeV9nZXRfdHJlZSsweDZjLzB4YjAKIHZmc19nZXRfdHJlZSsweDNlLzB4MTEwCiBwYXRo
X21vdW50KzB4YTkwLzB4ZTEwCiBfX3g2NF9zeXNfbW91bnQrMHgxNmYvMHgxYTAKIGRvX3N5c2Nh
bGxfNjQrMHg0My8weDkwCiBlbnRyeV9TWVNDQUxMXzY0X2FmdGVyX2h3ZnJhbWUrMHg3Mi8weGRj
CgpGcmVlZCBieSB0YXNrIDY1MDoKIGthc2FuX3NhdmVfc3RhY2srMHgxYy8weDQwCiBrYXNhbl9z
ZXRfdHJhY2srMHgyMS8weDMwCiBrYXNhbl9zYXZlX2ZyZWVfaW5mbysweDJhLzB4NTAKIF9fa2Fz
YW5fc2xhYl9mcmVlKzB4ZjkvMHgxNTAKIF9fa21lbV9jYWNoZV9mcmVlKzB4ODkvMHgxODAKIG9j
ZnMyX2xvY2FsX2ZyZWVfaW5mbysweDJiYS8weDNmMCBbb2NmczJdCiBkcXVvdF9kaXNhYmxlKzB4
MzVmLzB4YTcwCiBvY2ZzMl9zdXNwX3F1b3Rhcy5pc3JhLjArMHgxNTkvMHgxYTAgW29jZnMyXQog
b2NmczJfcmVtb3VudCsweDE1MC8weDU4MCBbb2NmczJdCiByZWNvbmZpZ3VyZV9zdXBlcisweDFh
NS8weDNhMAogcGF0aF9tb3VudCsweGM4YS8weGUxMAogX194NjRfc3lzX21vdW50KzB4MTZmLzB4
MWEwCiBkb19zeXNjYWxsXzY0KzB4NDMvMHg5MAogZW50cnlfU1lTQ0FMTF82NF9hZnRlcl9od2Zy
YW1lKzB4NzIvMHhkYwoKQ2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPgpTaWduZWQtb2ZmLWJ5
OiBMdcOtcyBIZW5yaXF1ZXMgPGxoZW5yaXF1ZXNAc3VzZS5kZT4KLS0tCkNoYW5nZXMgc2luY2Ug
djE6CiAtIEZpeGVkIGNoYW5nZWxvZyB0byBleHBsaWNpdGx5IHN0YXRlICdyZWFkLW9ubHkgcmVt
b3VudCcKIC0gQWRkZWQgS0FTQU4gc3BsYXQgdG8gY2hhbmdlbG9nCgogZnMvb2NmczIvc3VwZXIu
YyB8IDYgKysrKy0tCiAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9u
cygtKQoKZGlmZiAtLWdpdCBhL2ZzL29jZnMyL3N1cGVyLmMgYi9mcy9vY2ZzMi9zdXBlci5jCmlu
ZGV4IDBiMGU2YTEzMjEwMS4uOTg4ZDFjMDc2ODYxIDEwMDY0NAotLS0gYS9mcy9vY2ZzMi9zdXBl
ci5jCisrKyBiL2ZzL29jZnMyL3N1cGVyLmMKQEAgLTk1Miw4ICs5NTIsMTAgQEAgc3RhdGljIHZv
aWQgb2NmczJfZGlzYWJsZV9xdW90YXMoc3RydWN0IG9jZnMyX3N1cGVyICpvc2IpCiAJZm9yICh0
eXBlID0gMDsgdHlwZSA8IE9DRlMyX01BWFFVT1RBUzsgdHlwZSsrKSB7CiAJCWlmICghc2JfaGFz
X3F1b3RhX2xvYWRlZChzYiwgdHlwZSkpCiAJCQljb250aW51ZTsKLQkJb2luZm8gPSBzYl9kcWlu
Zm8oc2IsIHR5cGUpLT5kcWlfcHJpdjsKLQkJY2FuY2VsX2RlbGF5ZWRfd29ya19zeW5jKCZvaW5m
by0+ZHFpX3N5bmNfd29yayk7CisJCWlmICghc2JfaGFzX3F1b3RhX3N1c3BlbmRlZChzYiwgdHlw
ZSkpIHsKKwkJCW9pbmZvID0gc2JfZHFpbmZvKHNiLCB0eXBlKS0+ZHFpX3ByaXY7CisJCQljYW5j
ZWxfZGVsYXllZF93b3JrX3N5bmMoJm9pbmZvLT5kcWlfc3luY193b3JrKTsKKwkJfQogCQlpbm9k
ZSA9IGlncmFiKHNiLT5zX2RxdW90LmZpbGVzW3R5cGVdKTsKIAkJLyogVHVybiBvZmYgcXVvdGFz
LiBUaGlzIHdpbGwgcmVtb3ZlIGFsbCBkcXVvdCBzdHJ1Y3R1cmVzIGZyb20KIAkJICogbWVtb3J5
IGFuZCBzbyB0aGV5IHdpbGwgYmUgYXV0b21hdGljYWxseSBzeW5jZWQgdG8gZ2xvYmFsCgpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpPY2ZzMi1kZXZlbCBt
YWlsaW5nIGxpc3QKT2NmczItZGV2ZWxAb3NzLm9yYWNsZS5jb20KaHR0cHM6Ly9vc3Mub3JhY2xl
LmNvbS9tYWlsbWFuL2xpc3RpbmZvL29jZnMyLWRldmVs
