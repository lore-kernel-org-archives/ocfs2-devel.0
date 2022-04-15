Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85842C4167E
	for <ocfs2-devel@archiver.kernel.org>; Fri, 15 Apr 2022 04:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=4HrxbBKGAGQguG7bJJuOJASvTKxjd1X/2cJ7fGdyC9Y=;
 b=TvIDy0Gpj9BhRdgXHgaqpiNQWZyHM6YVGP2feyVXDIDtUHsIKXt5pPDj4kEzXrv6GN96s5kuq8QA
   shuEtaGmnttX2s3sU3/3DxgniCDmKnskoPm6ifHE21PBy8qYWVWwEkWF1jvNj2HtEUT5BZnOksDo
   UlYGMJ8jc/9bhUNwmy/oeVayR5uIc0/2uNBwfA2ADfYfjyf3FjwHBGN/YXzTMyjjOnh8CYXQ81AM
   iuqr2z+JIaKrds6GA6VKayFP5ydKjnhk38mgp1kcuKcMH4ZPG3dGeVEu8Cp2nsyms0U+ZSmkwNff
   xhlvagAQyNuenr78p0xQ/5Jdty6JkwuoMeXM2A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=4HrxbBKGAGQguG7bJJuOJASvTKxjd1X/2cJ7fGdyC9Y=;
 b=uW1AjrP4l6tAEMIRakGe3PzEfIZGLtPN/f3taAQ6NaBNXeglk3sFav+ugdymir+EgJnIOxdKMOS4
   TmZDMZU7VcHsjkQifgj7JYg72XsSaF8w/g9FWpJ/lcSruG+6SjNO6quhmNRHWV6CD0MoRxAPAiiC
   NsODQcLEyT0rvWQGinRaGAdkE1izu1/iAN0OL5L3Cxze4mjVNUaxrVSqbsFh8IraQxO3HXCn03uU
   /ztjtmCuM4fOCbqwKFvUyVx6lMZhUvdWFwpQUt+xQo5c6OXZS9fc37I0Q5cQniPDJZ57PYCuclEh
   TADAclsDlDjz67DBDHLHC7qRXy92fAGkvVQ3bQ==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RAD00MQY6YTGWB0@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 15 Apr 2022 04:54:29 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=V+N3WPhcjqbqmVRPAoIxuBjo6dgh1f5KuPVQDpaEGEs=; b=nvLDGsPTiAetPju9xhjyf64KX7
 7ozMCWWCzv+ARhNAuWIGIewpeBs3t3aim/vmyIsXxJJQ8D6e6M3a/IJbXoQcPtzLYF8SFlKXBpOqM
 ETxPrnhTBR4f07V6gtDeEqdGfb51nKXQBTRpYPNUhpzcsR3DXwU2yZKBDkC9971ryVgupM8yHNByX
 XVPHLYl9bzyBrPwqQLBM+QwlQjI8z/UzTo262uc5gVNBSBEUT1iHLOtxrGXvyRuwX4DfSfPrfgzSz
 mZOGRfCY5mWiQtABTIuaX0+Vh6+ub+qekGvIjW8PCF25qEYReZ47iYhf1WPmN6PzqNTyFHnP9LWNJ
 HQK2650A==;
To: Jens Axboe <axboe@kernel.dk>
Date: Fri, 15 Apr 2022 06:52:47 +0200
Message-id: <20220415045258.199825-17-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220415045258.199825-1-hch@lst.de>
References: <20220415045258.199825-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 127.0.0.1
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10317
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 priorityscore=126 adultscore=0 mlxlogscore=999
 bulkscore=0 clxscore=225 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204150029
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
 linux-xfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
 linux-fsdevel@vger.kernel.org, ntfs3@lists.linux.dev,
 linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH 16/27] block: use bdev_alignment_offset in
	part_alignment_offset_show
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
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-ServerName: localhost
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-ORIG-GUID: GlMI26_GLkjWkumDoA4FNRzjm5HZ38Aa
X-Proofpoint-GUID: GlMI26_GLkjWkumDoA4FNRzjm5HZ38Aa
Reporting-Meta:
 AAH+kgVZA0vYewW9kyiGXo4CGCW5cP4gge7qpYD6fzmuR/LclAi2i55MGlqe1tRD
 pb8XRffJeZ7lspVJEQ/YcN55TerMEgeiGI9F7JX8YE98WmP08Ik2Qwq6itjX9RME
 fzeSRAbsgPNqgXw6cK67y5tIu7RUuWJfOD73UAXUG1EvBC7autynRNaZ6fmSkHXR
 9mwsT3/9RdUIqdAWLrJCF4KFT1x1uXiijx0qK5LmuMo4IAnbQ3LuCoSpq534PMhN
 OzuDCBwj8bbqsFHPyeSKNPFd/2trxaOFFbiL1a8x5IPC4zmjfP1tMpu3nNrriQvI
 5N9bA3qpI721/W2sFgERkKbWzg16g+LN9z4piGhpjg1rc8rAWXXMrSm7tyRxwc7q
 d7A0afQ67WnD0vg81xz6LmBoKkkSANdE14qDQh83bO76ItMRCdBRyxIMBJSLBEhf
 aJlO/pTiOG66m5eA1tLHiQ+p/fO/mYM5BnYwg42vVi3BohX4BJJHFKiQh91qcDRl
 yaCiHg/aqOiqsFomsZHSrv8BTylUvIDmvAL36xUi/BwH

Replace the open coded offset calculation with the proper helper.
This is an ABI change in that the -1 for a misaligned partition is
properly propagated, which can be considered a bug fix and matches
what is done on the whole device.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/partitions/core.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/block/partitions/core.c b/block/partitions/core.c
index 2ef8dfa1e5c85..240b3fff521e4 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -200,11 +200,7 @@ static ssize_t part_ro_show(struct device *dev,
 static ssize_t part_alignment_offset_show(struct device *dev,
 					  struct device_attribute *attr, char *buf)
 {
-	struct block_device *bdev = dev_to_bdev(dev);
-
-	return sprintf(buf, "%u\n",
-		queue_limit_alignment_offset(&bdev_get_queue(bdev)->limits,
-				bdev->bd_start_sect));
+	return sprintf(buf, "%u\n", bdev_alignment_offset(dev_to_bdev(dev)));
 }
 
 static ssize_t part_discard_alignment_show(struct device *dev,
-- 
2.30.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
