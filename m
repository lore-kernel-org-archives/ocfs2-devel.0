Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E4B9C4321E
	for <ocfs2-devel@archiver.kernel.org>; Sat,  9 Apr 2022 04:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Bnq9Vf3h0mEM9ld19nug5DVOk9ghIfXz7QRUAQ0ZHlI=;
 b=gh73CkgGMu2uez1+mnZ7RnLPwijVSIQZq/OIM4rk7rwCpTiG9sUEWWPeglNokLyI1KHXLjv2Ntfy
   bJJrrmkROqFq2BmShygKZIMUHzgTO2RAs8RoF8SE2JORbM9HyIGGn+twwE5gY1hZOEX7Q95cEtGp
   S8/jW5H3EyOsTz5w+r5lNxpqqMfCFZwLUmPoyv4G5slWZVAGm24PBoRv4399+zIHPHkJcEOwQ36A
   Dfaa/omxyxsgDpWCBoMabJ/QuCCFjZVo8uqmkrkw5UZRCIcg6Qv6SaHJJI9NyWQAFq5kr4Iv8a/Q
   eu6kLuLuzBpkhREwmZA4gtiY2VdFUXYyHuBZ9A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Bnq9Vf3h0mEM9ld19nug5DVOk9ghIfXz7QRUAQ0ZHlI=;
 b=cpGb1d5ZLQlk3Qo1EGAEEPt73a8MJXmbYAsK7ou48yEeY65Pl70YozKaUBf6KM+hRMzYWnYRagyW
   3XP83BCX1PuykDbUyJHv8GnoR499ySt6d2MnvGjc/7r2oWAlArTUuW2ou2HSpGNN1p5yloRCA1bW
   klJE5tF2wG9yobqw8wO78dTitiw1cefI+qxjO9t0Ap26dkEQDDWcrwU6a44F3xIkMxUYr2WDHRCE
   7MlKTzv9tjMn57Q2FRvrZxleZDS/ArQ6yiuRg5hkQQl/NKfNn+MdstW3DKrqJjsUaN6WZAY7EHtB
   SsDKj8U0nRWzHRYISf8DZbH290hIqMaBCZBIUg==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RA200GY62U9ZW80@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 09 Apr 2022 04:51:45 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
 To:From:Sender:Reply-To:Content-ID:Content-Description;
 bh=mSb0+dwzgM6VKYFxP/SxijH+ZlgC/mCnwmCWElH9Px8=; b=GeHiEC33kqU3XVD5nL4JSSzw9j
 UuYbGyM2BXXR+stmsdf5DjhZy4DmQUWQMFN0vSfrL8aUhBe+6Ofrgbj+Dbx5uxEAqYOBhWREkppXD
 kdRzxDavbe8DbbMc6qyOhN2cA6i5obcc9Wc+hP+sVKryA1uBRUfBVDOlYnio24jRKSkCpFo+tSiXl
 6u0gF+2q2d7oaysxI+ClBO5UEjKSEG5mJBDObnDrEZKJSMP7hUVOwIlO/C7MDHMssw01IKDI4CTXp
 PRCDWE+Bw8zXMLtTw0QbfZSkAUMsYs8Kzz9wpJlJkYu9q6ou7iULbQ0RWrchfFLVlYlgnHKpBsjXJ
 gpZHWQ4w==;
To: Jens Axboe <axboe@kernel.dk>
Date: Sat,  9 Apr 2022 06:50:22 +0200
Message-id: <20220409045043.23593-7-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220409045043.23593-1-hch@lst.de>
References: <20220409045043.23593-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10311
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=487
 spamscore=0 clxscore=230 mlxscore=0 phishscore=0 priorityscore=60
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204090027
Cc: jfs-discussion@lists.sourceforge.net, linux-nvme@lists.infradead.org,
 virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
 dm-devel@redhat.com, target-devel@vger.kernel.org,
 linux-mtd@lists.infradead.org, drbd-dev@lists.linbit.com,
 linux-s390@vger.kernel.org, linux-nilfs@vger.kernel.org,
 linux-scsi@vger.kernel.org, cluster-devel@redhat.com,
 xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org,
 linux-um@lists.infradead.org, nbd@other.debian.org,
 linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
 ceph-devel@vger.kernel.org, linux-raid@vger.kernel.org,
 linux-mmc@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, =?UTF-8?q?Christoph=20B=C3=B6hmwalder?=
 <christoph.boehmwalder@linbit.com>, ocfs2-devel@oss.oracle.com,
 linux-fsdevel@vger.kernel.org, ntfs3@lists.linux.dev,
 linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH 06/27] drbd: use bdev_alignment_offset instead	of
 queue_alignment_offset
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
From: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Christoph Hellwig <hch@lst.de>
Content-type: text/plain; charset="utf-8"
Content-transfer-encoding: base64
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-ServerName: bombadil.infradead.org
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-ORIG-GUID: HSerfNsyzJbar8yOmwCQ-IvMmqH16Khh
X-Proofpoint-GUID: HSerfNsyzJbar8yOmwCQ-IvMmqH16Khh
Reporting-Meta:
 AAGSEfAjIrZKovNAR1e3NFXvW95t7m6XYJ8rfRN1UqJU4gp5SQSONOzH5ujhbMcG
 VjQ1j1Y7rR63ZUyw6nvfFWSQazaviqu67oZDGbnFv2n+wvuKl21pDbTAwSlR6JRP
 I8TPmFdDYFO2rg+E17nzXRJTo7MznX3ZI9oUz/WIQ3rX2bR26z/n3IFOp6zvwbfU
 NveFLxhNAOCCWaWcz5n7FUq57vps4eyZm91OJCbFjyjKRCZ+fO49qZx/1dq0Lbu0
 0cNwFrdfjkXe6FidQHA6k0jIyTTw+91DLsqmkb5c6OauYUk9cGk8hkINSWs1UQHo
 4PzHCgFTIcGt0CYvbe4sBrh0Q9D9vWsefVnN9u90/U3qKsEWh99JRucIARIPkSLD
 xY6IfKM4MRHGaBAMsNFJcYT9hvgEcSCgVNxjwU/6gGkPg5mDGTNl6hfIWKFX9t9Q
 TkKq948Wqq2rKMci+EUHvqhu5d69oGwoyVg1B8zPRSCo7eeQYPJoiTdOQAcgcFVj
 LQjx2bgmuNpNuaJ7kQ3go1aQ1dEL3taKHL424tilFKGT

VGhlIGJkZXYgdmVyc2lvbiBkb2VzIHRoZSByaWdodCB0aGluZyBmb3IgcGFydGl0aW9ucywgc28g
dXNlIHRoYXQuCgpGaXhlczogOTEwNGQzMWE3NTlmICgiZHJiZDogaW50cm9kdWNlIFdSSVRFX1NB
TUUgc3VwcG9ydCIpClNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRl
PgpBY2tlZC1ieTogQ2hyaXN0b3BoIELDtmhtd2FsZGVyIDxjaHJpc3RvcGguYm9laG13YWxkZXJA
bGluYml0LmNvbT4KLS0tCiBkcml2ZXJzL2Jsb2NrL2RyYmQvZHJiZF9tYWluLmMgfCAyICstCiAx
IGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQg
YS9kcml2ZXJzL2Jsb2NrL2RyYmQvZHJiZF9tYWluLmMgYi9kcml2ZXJzL2Jsb2NrL2RyYmQvZHJi
ZF9tYWluLmMKaW5kZXggYWEyYzIxYWViNzQ3Yy4uZWFlNjI5YzRmNmVhZiAxMDA2NDQKLS0tIGEv
ZHJpdmVycy9ibG9jay9kcmJkL2RyYmRfbWFpbi5jCisrKyBiL2RyaXZlcnMvYmxvY2svZHJiZC9k
cmJkX21haW4uYwpAQCAtOTM5LDcgKzkzOSw3IEBAIGludCBkcmJkX3NlbmRfc2l6ZXMoc3RydWN0
IGRyYmRfcGVlcl9kZXZpY2UgKnBlZXJfZGV2aWNlLCBpbnQgdHJpZ2dlcl9yZXBseSwgZW51CiAJ
CXAtPnFsaW0tPmxvZ2ljYWxfYmxvY2tfc2l6ZSA9CiAJCQljcHVfdG9fYmUzMihiZGV2X2xvZ2lj
YWxfYmxvY2tfc2l6ZShiZGV2KSk7CiAJCXAtPnFsaW0tPmFsaWdubWVudF9vZmZzZXQgPQotCQkJ
Y3B1X3RvX2JlMzIocXVldWVfYWxpZ25tZW50X29mZnNldChxKSk7CisJCQljcHVfdG9fYmUzMihi
ZGV2X2FsaWdubWVudF9vZmZzZXQoYmRldikpOwogCQlwLT5xbGltLT5pb19taW4gPSBjcHVfdG9f
YmUzMihiZGV2X2lvX21pbihiZGV2KSk7CiAJCXAtPnFsaW0tPmlvX29wdCA9IGNwdV90b19iZTMy
KGJkZXZfaW9fb3B0KGJkZXYpKTsKIAkJcC0+cWxpbS0+ZGlzY2FyZF9lbmFibGVkID0gYmxrX3F1
ZXVlX2Rpc2NhcmQocSk7Ci0tIAoyLjMwLjIKCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwpPY2ZzMi1kZXZlbCBtYWlsaW5nIGxpc3QKT2NmczItZGV2ZWxA
b3NzLm9yYWNsZS5jb20KaHR0cHM6Ly9vc3Mub3JhY2xlLmNvbS9tYWlsbWFuL2xpc3RpbmZvL29j
ZnMyLWRldmVs
