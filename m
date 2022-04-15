Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 463A1C352A8
	for <ocfs2-devel@archiver.kernel.org>; Fri, 15 Apr 2022 04:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=fSzeLRk5fjRArIud+CXERDm6IqyYRcNVZ5zIzjPLDhw=;
 b=H7VRlOnGuDO7sNBerkzCfJVUy6A2QlspW3uTPbO8I6jDwbz/UhvGDCnNW7jUAEB8a+xuAnZ3zoMZ
   fZ4gboJSri7VLdEUUvEO6nRlOS0yYduUrKFI+UzBa75uRReQj6PP5dx4k2G/KI7LwRnkzc1U6d/P
   YzKYcYLn5RALw8QrSW+RpXi+8e8yoYqQxaIzYW0zwUgQOyMutYhSdzzhPhjyaCCfgicJm8L3BnU3
   LSgBUupels/QFePqSGg7dFsZsz4TgexU9l8jvDF5rlOsMQG17mcuZ0PdqUBVX9RM4aUFcxKjvX7/
   MuKlPqCH44w/dOUtL6L6t3JfunUqYuaGEUc1OA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=fSzeLRk5fjRArIud+CXERDm6IqyYRcNVZ5zIzjPLDhw=;
 b=a5bKZf8FOBoc+MiNQvSTDZ/dvA3s2yFYGWh77jXaEMdjJFdmLEt/rYcyxHXTlh0TrG1H30j2wdzA
   bRGmgNCIp4FdGxGsIcsPWhf5MVYS8tslcFhucHvnodL+cYF1qy58xGBSFz105JogiPCxKBSgm4Os
   qEB2BrQodh99FnUMPhQOpOxIggYSo0pz0rrncSxm+SQWnXnP4dZQomhCGgl0xq/14G5v1yceCMJq
   AIxhqDAN7XrR9FdVXWe385lUjzrXaU1fYpBSP0BpQDNRtzrgUX9y/BZs20iZN0qSA85DQ5wBr1DC
   HDggb+wCdMxCCBP5Mu86BltUiUZMxXbE6RqpYQ==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RAD00B2I6YQE2C0@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 15 Apr 2022 04:54:26 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
 To:From:Sender:Reply-To:Content-ID:Content-Description;
 bh=pjOlLI0zIPscdljJBqydWvc1kCbsO4mNomowvsnW144=; b=qvkOjPFjyqYMQWW/2QWIK68ENP
 k2NNTMvf9yJkIIsMinaHWq3ShtV9GAA9eD1j84n/4A1YSynSJPbH7xunvM4gFW2tBAaf34uDjFYTF
 Cf27zURP5kxthNnuilxHYkuF0+dYk/s+KgITZDeRBuWDyLf29iyj7NC5GSjUBL7HTLudqqDHJV7jI
 umQOzmF/ghCqietP9jcYeXWa5VJNEKLQMKEWsHvHjmzPuAlTBx/BxH8sjV6Sj89/sE85wKvCAMm7z
 4onw1pEIPzrLUGePDGOaGXDfMTfY5lSCh3pdlvTomsyZDMHzABEpf6210R46hSLONPkgfa2cukRRf
 iN4Lrpmg==;
To: Jens Axboe <axboe@kernel.dk>
Date: Fri, 15 Apr 2022 06:52:37 +0200
Message-id: <20220415045258.199825-7-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220415045258.199825-1-hch@lst.de>
References: <20220415045258.199825-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10317
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=310
 mlxlogscore=528 impostorscore=0 priorityscore=0 mlxscore=0 adultscore=0
 bulkscore=0 spamscore=0 suspectscore=0 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204150029
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
X-Proofpoint-ORIG-GUID: e239qaxYmzvh6zvYOFNccyKlK2OtrlOO
X-Proofpoint-GUID: e239qaxYmzvh6zvYOFNccyKlK2OtrlOO
Reporting-Meta:
 AAHubPBLBEdBMwcFxWjeXCkxAe4em2Ltg69laooP3SJu4VNHZydgzL8IZZLTc/Tp
 4KG91DkOwT61+rjv635z9DD7ieTBlX2ltYIJNcukyhUZhdWzjGSUwXTwopZCGnZV
 Me0q+ipXZRDjNnpfX1Ba77J4DqPtu0/F5/KxLAm+2VZKPcPXH1FS6Ue8Ktcla6Up
 /cXX+om2u6IhLvao3DOjkvapBgYRNFLAN/wjCVEvUR9QAyhCBtECLBtccf542PL8
 7/TTX8u10BfzHnyaCpMaY5bmOZ66Ldp2fJydJVHmNLD2HqZZcJgZYlVmXPJrjxl8
 ghq1xSTmw36KUM8OEHTAxxmVTBSGWRYRcZOCHIRNaUpi0FoKsxlY3KjACac4B0PH
 dIMIbPUjj/8gp85rLp9tF1+10E65zg44yxlUDKlQfqoUgWdQ57G7pL/zeo04dZdy
 hUSFgOTMirVrYSTaIlfQlNEDVnadKG1nTedv9UEnn8qdKcXvWP6G1fvmBtgrBFX0
 RNrQIn5Y8paFleZZZuTFZ9x1QADyXiXyifUG2m0XkuDnjA==

VGhlIGJkZXYgdmVyc2lvbiBkb2VzIHRoZSByaWdodCB0aGluZyBmb3IgcGFydGl0aW9ucywgc28g
dXNlIHRoYXQuCgpGaXhlczogOTEwNGQzMWE3NTlmICgiZHJiZDogaW50cm9kdWNlIFdSSVRFX1NB
TUUgc3VwcG9ydCIpClNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRl
PgpBY2tlZC1ieTogQ2hyaXN0b3BoIELDtmhtd2FsZGVyIDxjaHJpc3RvcGguYm9laG13YWxkZXJA
bGluYml0LmNvbT4KLS0tCiBkcml2ZXJzL2Jsb2NrL2RyYmQvZHJiZF9tYWluLmMgfCAyICstCiAx
IGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQg
YS9kcml2ZXJzL2Jsb2NrL2RyYmQvZHJiZF9tYWluLmMgYi9kcml2ZXJzL2Jsb2NrL2RyYmQvZHJi
ZF9tYWluLmMKaW5kZXggYzM5YjA0YmRhMjYxZi4uN2I1MDFjOGQ1OTkyOCAxMDA2NDQKLS0tIGEv
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
