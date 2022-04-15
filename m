Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A25D2C38A02
	for <ocfs2-devel@archiver.kernel.org>; Fri, 15 Apr 2022 04:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=EhzRMAliWQfAp1Rh6krPu4+eAG1WRlU9Bdv6/WRPHMQ=;
 b=aTINCrbJ2KN+Noc72jvLspPHV23NHseyA4rlZlhiGiXG3sV9AMlfV9EEakazsDBBsW8VJ8s80pj0
   MAvSmQTazuuNJcvTDfup12TcKH0hiS86h/kBrTsPsvJHVr3WUxBecUXdX36Cj1tXsp15D/uEbBnY
   Uy/o1cOkCJj+lV+eOixW5IAcwTZw1mIksCIx9TMG9dtnwTy2uBEtzFmcYFNaWxYhrMC3sM+rMJL7
   xAgtejq3Xc0VtSLEZxAj2WwC1u25C6a17/Zd5nRI+y2U8P3jMhSvW7S4h9rKdXsjfX4g/26/TFJW
   ptj2WPpLw3Iut7V81stD/IguKudnrorcvQA/Pg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=EhzRMAliWQfAp1Rh6krPu4+eAG1WRlU9Bdv6/WRPHMQ=;
 b=HkcRaGPraKHzely7xfP6ncCq3+/GZC6Bwn6p8UVWiWAeO2LLeCK9wTsOf+niEEGYTLL3lQdyhCs5
   rOttsGoXkhklRD0mlRgIQNiYddPU3dgCMRUGoxUvRksIdmulWvVBe1gVLqKk0h4vNQxlQatGzuUH
   mslocOoFJdkcrPjeaG0SCSY5dJJblEBPiI2S9sb4YA5B3YXQhi5msiDSHqHA/BYck2lUaiU8+REl
   CodH05c98VmmuXt1ka6VcZ92DoE5EGmxAnwTt/xxjfcKsVGl0mBCdkCdhLeSjBZZjKatdNRaQsz3
   yFLga9V2WazXSgoFtrsnB1i+IdeEdc2X5YvF+Q==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RAD0042Y6Z3Q400@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 15 Apr 2022 04:54:39 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=A3F4pzgWH2QQ0wtpIeTWEbWkE7zvp2Hf2SzUvBBV6uI=; b=2blFxPm6xz5pgZn6E5jvsGqhvn
 2WDz/E43ISZl4v/rhlHMaqtSb4lVbmKeEW11/ljs0aiEkq0TnWEDxeJnrojcMAcOqNB8N3gDxJnoZ
 0NRetUsPJHvzddTt7lmgpHndIYp7bFipN2chfdRidmHIR3lH3yyIVmQny7lS+2WzaIVhTRY61ZPLW
 cNdIp932vWgZbDLAr3bVHO1tMLGx1FOnjxoa9UVQZYEIwSKlwU7ByTf62px4tvbNkH8lyOAfKg6eV
 fvQs7AcyDRrAWF5ZnpqPRd0RsttREedP1tYS6zdjKYykJ8LivF4bs1Leq71tf07T70LHtI3i4RcFf
 TuAsL+Kw==;
To: Jens Axboe <axboe@kernel.dk>
Date: Fri, 15 Apr 2022 06:52:51 +0200
Message-id: <20220415045258.199825-21-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220415045258.199825-1-hch@lst.de>
References: <20220415045258.199825-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10317
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 priorityscore=181 mlxscore=0 malwarescore=0 mlxlogscore=873 bulkscore=0
 spamscore=0 phishscore=0 lowpriorityscore=0 clxscore=224 adultscore=0
 suspectscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
 linux-xfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
 linux-fsdevel@vger.kernel.org, ntfs3@lists.linux.dev,
 linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH 20/27] block: use bdev_discard_alignment in
	part_discard_alignment_show
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
X-ServerName: bombadil.infradead.org
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-ORIG-GUID: HnmTObvivFFQfni0icFcD9W38ZQzBFGb
X-Proofpoint-GUID: HnmTObvivFFQfni0icFcD9W38ZQzBFGb
Reporting-Meta:
 AAE0IoEmOF0ubqBkHjr2JUX5XcnRIUrhFYEtK6E7dqOzAJKjwXAWlIYqeA07I7s1
 NVYR8gD4khEmNXifJWsZBeCEb2pTweEA+x7E9ww2DAcLm2B9z4PJ44HxYLvEym0e
 K9ljple8KKr6T5wfbhaRNZB6jhEz8i+wnI6R1XO5kH2KYmF90QBnR1yixJdHl623
 q9vMXoSiABaiS1nX4IEg87UvKe2i7YbDxxjKAIwmuW+34S9bLlg6PWv0yhrD48b3
 eLEii0v/pQVdAkaTzTLq1oYYi9yRs7VR5Yykh5HllrhIC5U6NdAQBN3Rl7tFcUJd
 Gfny5B3BKsPnQ3sthZru6F9HwS/S8PIguLM6UnkuKXqq4oOL6DISWXT8QZndZTii
 S3dBkFgylLEnmjkMxoKwy6z4UGprD6RKv0kbfVsNlu2kUh3SA/Z99zI4X3GG2A8i
 5jjg4sPaiXJkksqlDPGvycpEccRnOqXuaLWpHRhI4RE+znJlzM9L1v5dCFkg1DJK
 iYLWMAzHmeVaHxX6g3wkMZqfwXdGnh746B8JI4UefveN

Use the bdev based alignment helper instead of open coding it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/partitions/core.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/block/partitions/core.c b/block/partitions/core.c
index 240b3fff521e4..70dec1c78521d 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -206,11 +206,7 @@ static ssize_t part_alignment_offset_show(struct device *dev,
 static ssize_t part_discard_alignment_show(struct device *dev,
 					   struct device_attribute *attr, char *buf)
 {
-	struct block_device *bdev = dev_to_bdev(dev);
-
-	return sprintf(buf, "%u\n",
-		queue_limit_discard_alignment(&bdev_get_queue(bdev)->limits,
-				bdev->bd_start_sect));
+	return sprintf(buf, "%u\n", bdev_discard_alignment(dev_to_bdev(dev)));
 }
 
 static DEVICE_ATTR(partition, 0444, part_partition_show, NULL);
-- 
2.30.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
