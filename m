Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73DC7C352B6
	for <ocfs2-devel@archiver.kernel.org>; Fri, 15 Apr 2022 04:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=cwEipjtz5TsMu7s+eVS2suOdN/j7ma/Jn0HsJ6PZBRQ=;
 b=YaHEWDSUut7AV66JZK6zoBBM1bQ9DJwgQXF8tCI384flVyiu/s+IX6oLeoqfp6UaGZWCMwYDk4xO
   qtA+hKEy71yQ/wbqhUMLfN0GyG7JwgKCMWt8LcJPpTQcULW1Q5KMuIs2HQ41xbN6fZMvzc1HWbEu
   mnypmBeXgsSR1S/Ss+iC+9AeCX1hMrL+oxYJkFjpDU6b9WAjL62Lz05lkHv16OxqsO0FKt6HxngB
   pF08J13b7WP8kM8CEDaCMDz6mVWWsGpPx+bGKFDsjfsxb2LWyNnUP0CSJToWs/2LL9pTL7rUQS5u
   gGI6m4Su+mA84vUiZvyNdbMUxZDH5UnGyrzVBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=cwEipjtz5TsMu7s+eVS2suOdN/j7ma/Jn0HsJ6PZBRQ=;
 b=VP617P4I8KPPTU7F2o+tPRWrTVVbNlElSzBX/BthrX9wMCepHBFkjKG+KRkVd9gsk5ehf9xj6qY4
   AjaalfdyAGkaKHsn4r1/iK2wQ4vGL88WsBKWtpWZHmAw+BtHBspehVNbBEUTKeS3jXBZJkDPKiau
   21/ysYbRi9Mo26rx0L1Ct/8zII5d2oUxbs+eDjQrG9HtpUqr6EMe1wfpNNiVQDOl8D5up+7056C1
   YnuV6MpZRZFsOHu+8MNWn8Gu5AzvxNjsGIArai/6kOMfp2ZB+YDtxPzgDdSSs8YnVERI0B365aAx
   DluyEjk8mhns+T1zu3Mey0WYq7ihA61Dpl/1ag==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RAD00B206YGE2C0@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 15 Apr 2022 04:54:16 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
 To:From:Sender:Reply-To:Content-ID:Content-Description;
 bh=XZGhvwW8WnEXnqFpyMAZS4hEeSHoeSYBiqC69zbelFo=; b=Gxz7Y5uJ+XKe3DFB5F+glNf4Qd
 +ilmHliKeg1fmYV7/5LLANJc72+LNxw8j97CHk5ziFCgc1uz7kS3J7fxsGIO6cnBRc/aEIND8YKio
 0SkKbU86rwF6U+vXBBwyr3GFqwWasgE9TCw8n+hO0zPxSPP5I4ZPpiX7PrV0Nkluz9OYVJwj4Hmwy
 oKidnHT0/AqxHbe4vf+J+1VyQBy8myzVvzFwGzWB5MOWnMsTyORGtxjAzgY+jPvDzJzijUERBo3GF
 IuBPqJCO6mtg8vZGmw86bOvzf7HW3Tdf+1Wt8evubUZivpuvFh33FBjqoHj3OCwfnGHVCD1k5Crl7
 crl4uuXw==;
To: Jens Axboe <axboe@kernel.dk>
Date: Fri, 15 Apr 2022 06:52:36 +0200
Message-id: <20220415045258.199825-6-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220415045258.199825-1-hch@lst.de>
References: <20220415045258.199825-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10317
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=310
 mlxlogscore=789 impostorscore=0 priorityscore=30 mlxscore=0 adultscore=0
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
Subject: [Ocfs2-devel] [PATCH 05/27] drbd: use bdev based limit helpers in
	drbd_send_sizes
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
X-Proofpoint-ORIG-GUID: YVdMduD6WosQNvlb6ehwkTzAd-6zKHMe
X-Proofpoint-GUID: YVdMduD6WosQNvlb6ehwkTzAd-6zKHMe
Reporting-Meta:
 AAEM/JB5c+5pYfAk4vHpNc7zQQhy0ZUB3yz14Kd6WHipWf903Jdsh1SmWeXrQRAO
 ksE1e6LvR1EZm8iyc0mKqcvZDtVJEy81wT/75HuUNF+Dzp9DXGIYGAz37H4kIJj3
 WXxfGnHgC6zTfEt6Mmu7F8KsfKs7rPyyhf7dofRCIJfIGPnNMfjEg6psd+CnGCFE
 9GCf8oUouRO2jMb0dlkyJeIQdLQg+VuLKaQ5lyPgvD8mSkgVQ5SazTowYtDHA13+
 tZHJvtU7eYAztcUgac04z23ZLsWVeXw8thiY2OhJGwAdKUw8IDORwBU+9IPyRNYw
 BOHLRNkd4B41JbH15tMhk3H6ZkMQo57gp6eRM3L4TU4ogUzv8WQrBB4W9ExPsnsT
 Bd1PQp5fNYs5JgfmoUHQkcR1etbaiAPHmO+PoGMyzJCJlPdYgn2QTIbio6QfRHMR
 OF3kuui4FedFIbpR5DhfG1FEzl/HPvDJBNfouILqyhoqXrW0duwwbiLvhHk+Lix5
 L8AAGte+KFfrYWYh9ZPawKaWmTxt+/Ug89/kDYo88zCu

VXNlIHRoZSBiZGV2IGJhc2VkIGxpbWl0cyBoZWxwZXJzIHdoZXJlIHRoZXkgZXhpc3QuCgpTaWdu
ZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4KQWNrZWQtYnk6IENocmlz
dG9waCBCw7ZobXdhbGRlciA8Y2hyaXN0b3BoLmJvZWhtd2FsZGVyQGxpbmJpdC5jb20+Ci0tLQog
ZHJpdmVycy9ibG9jay9kcmJkL2RyYmRfbWFpbi5jIHwgMTIgKysrKysrKy0tLS0tCiAxIGZpbGUg
Y2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvYmxvY2svZHJiZC9kcmJkX21haW4uYyBiL2RyaXZlcnMvYmxvY2svZHJiZC9kcmJkX21h
aW4uYwppbmRleCAzNjc3MTUyMDVjODYwLi5jMzliMDRiZGEyNjFmIDEwMDY0NAotLS0gYS9kcml2
ZXJzL2Jsb2NrL2RyYmQvZHJiZF9tYWluLmMKKysrIGIvZHJpdmVycy9ibG9jay9kcmJkL2RyYmRf
bWFpbi5jCkBAIC05MjQsNyArOTI0LDkgQEAgaW50IGRyYmRfc2VuZF9zaXplcyhzdHJ1Y3QgZHJi
ZF9wZWVyX2RldmljZSAqcGVlcl9kZXZpY2UsIGludCB0cmlnZ2VyX3JlcGx5LCBlbnUKIAogCW1l
bXNldChwLCAwLCBwYWNrZXRfc2l6ZSk7CiAJaWYgKGdldF9sZGV2X2lmX3N0YXRlKGRldmljZSwg
RF9ORUdPVElBVElORykpIHsKLQkJc3RydWN0IHJlcXVlc3RfcXVldWUgKnEgPSBiZGV2X2dldF9x
dWV1ZShkZXZpY2UtPmxkZXYtPmJhY2tpbmdfYmRldik7CisJCXN0cnVjdCBibG9ja19kZXZpY2Ug
KmJkZXYgPSBkZXZpY2UtPmxkZXYtPmJhY2tpbmdfYmRldjsKKwkJc3RydWN0IHJlcXVlc3RfcXVl
dWUgKnEgPSBiZGV2X2dldF9xdWV1ZShiZGV2KTsKKwogCQlkX3NpemUgPSBkcmJkX2dldF9tYXhf
Y2FwYWNpdHkoZGV2aWNlLT5sZGV2KTsKIAkJcmN1X3JlYWRfbG9jaygpOwogCQl1X3NpemUgPSBy
Y3VfZGVyZWZlcmVuY2UoZGV2aWNlLT5sZGV2LT5kaXNrX2NvbmYpLT5kaXNrX3NpemU7CkBAIC05
MzMsMTMgKzkzNSwxMyBAQCBpbnQgZHJiZF9zZW5kX3NpemVzKHN0cnVjdCBkcmJkX3BlZXJfZGV2
aWNlICpwZWVyX2RldmljZSwgaW50IHRyaWdnZXJfcmVwbHksIGVudQogCQltYXhfYmlvX3NpemUg
PSBxdWV1ZV9tYXhfaHdfc2VjdG9ycyhxKSA8PCA5OwogCQltYXhfYmlvX3NpemUgPSBtaW4obWF4
X2Jpb19zaXplLCBEUkJEX01BWF9CSU9fU0laRSk7CiAJCXAtPnFsaW0tPnBoeXNpY2FsX2Jsb2Nr
X3NpemUgPQotCQkJY3B1X3RvX2JlMzIocXVldWVfcGh5c2ljYWxfYmxvY2tfc2l6ZShxKSk7CisJ
CQljcHVfdG9fYmUzMihiZGV2X3BoeXNpY2FsX2Jsb2NrX3NpemUoYmRldikpOwogCQlwLT5xbGlt
LT5sb2dpY2FsX2Jsb2NrX3NpemUgPQotCQkJY3B1X3RvX2JlMzIocXVldWVfbG9naWNhbF9ibG9j
a19zaXplKHEpKTsKKwkJCWNwdV90b19iZTMyKGJkZXZfbG9naWNhbF9ibG9ja19zaXplKGJkZXYp
KTsKIAkJcC0+cWxpbS0+YWxpZ25tZW50X29mZnNldCA9CiAJCQljcHVfdG9fYmUzMihxdWV1ZV9h
bGlnbm1lbnRfb2Zmc2V0KHEpKTsKLQkJcC0+cWxpbS0+aW9fbWluID0gY3B1X3RvX2JlMzIocXVl
dWVfaW9fbWluKHEpKTsKLQkJcC0+cWxpbS0+aW9fb3B0ID0gY3B1X3RvX2JlMzIocXVldWVfaW9f
b3B0KHEpKTsKKwkJcC0+cWxpbS0+aW9fbWluID0gY3B1X3RvX2JlMzIoYmRldl9pb19taW4oYmRl
dikpOworCQlwLT5xbGltLT5pb19vcHQgPSBjcHVfdG9fYmUzMihiZGV2X2lvX29wdChiZGV2KSk7
CiAJCXAtPnFsaW0tPmRpc2NhcmRfZW5hYmxlZCA9IGJsa19xdWV1ZV9kaXNjYXJkKHEpOwogCQlw
dXRfbGRldihkZXZpY2UpOwogCX0gZWxzZSB7Ci0tIAoyLjMwLjIKCgpfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpPY2ZzMi1kZXZlbCBtYWlsaW5nIGxpc3QK
T2NmczItZGV2ZWxAb3NzLm9yYWNsZS5jb20KaHR0cHM6Ly9vc3Mub3JhY2xlLmNvbS9tYWlsbWFu
L2xpc3RpbmZvL29jZnMyLWRldmVs
