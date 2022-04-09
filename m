Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E0A4C433FE
	for <ocfs2-devel@archiver.kernel.org>; Sat,  9 Apr 2022 04:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=4HrxbBKGAGQguG7bJJuOJASvTKxjd1X/2cJ7fGdyC9Y=;
 b=viN139iyDmfU6ID5+2PE3KfqysiE3lAF3ha68GPRYl57+AfArgeDLxeI+eR1PvcadQq8i+9x5EuA
   +A65bESTIHDU+s8ne3/VN+zbiaHHAjR95IG+IQGozG7XpwYZ2iKkkz1vlSpr9Y6FQzPrd/B5FaCW
   4ro1PJWgZ1xUtVBuumRJClj+G+d/rfJrYDy7ZY6TrQI5bhWZaqghHz3BuU8AeJd1BLQ75hFfY1oy
   F6gKMwoBNlVvxyfDd/TjWKj1PUaZ6gQKkmK6V2lmo9CY00qdKVTB8X57rxaplfzjKg5tyio6B6z6
   rihRPq0LvIIBVJqZykEjNbd50ok4fqRTSqAorg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=4HrxbBKGAGQguG7bJJuOJASvTKxjd1X/2cJ7fGdyC9Y=;
 b=qafpUkDoU9D0gbV/80fPnlva7Jub88B1m3qoQ6rJGwwsYeIhs6u/XePLfV8V8UdIzYr5Twvnu/um
   G9MnfPdMs74BgXOQ/m9NRA1oZ2F3ShYGh9M+Ey9N39eETIG6G+819mIWwyVsbct4OMY+f4RBYmTe
   GDRW97oQrO7t3VhBIQFJY6fOzOpUeoFWMrviToPmaqmeCbmmls5yrGO025UEVlRMGo7eYVTpQLtK
   J+FYqtaXQKGZfX6BU6fRIeRyjp4O5lP7MKzwaO5MsgLu+eur388z3k3kLAbhIPNyuSv29hTIJHcr
   rkxHaZbIaPM2K89IrXiy+o7ArMTlHBHOBjxVqA==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RA200OHP2V6KN20@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 09 Apr 2022 04:52:18 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=V+N3WPhcjqbqmVRPAoIxuBjo6dgh1f5KuPVQDpaEGEs=; b=tiIaiEVMWAbVYZUjb2lOkfyysx
 dbx49Qpm+lo+UUevAGrVDIkvKOBa+44snHlQ0a+KaxdGF8tKMoYuXWs/fvRv0ae96tcME++4ORVYu
 qYaC1vBwLvlzDvH7/c4A7h9mvUaVl8+MzbhpnW7kmDycYjo20v3XRILfplXYTrbZMX8JEk4N43tKH
 ZGQP+OitiIrdN0xV7JNnkLHd6fyLWakKMo7lxXmk9Yj+ODdh4QMMFZVM+vhTm4zDm7nCREr0fmSsA
 waBKGG0G7evAOkXMc1HpZXEoglbkXIOtFpSCT7RrqLEic0YOHBHXQ9EKk4JuDHcopl0LFeqmVS4RI
 X94UE+Ww==;
To: Jens Axboe <axboe@kernel.dk>
Date: Sat,  9 Apr 2022 06:50:32 +0200
Message-id: <20220409045043.23593-17-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220409045043.23593-1-hch@lst.de>
References: <20220409045043.23593-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 127.0.0.1
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10311
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 spamscore=0 clxscore=234 mlxscore=0 phishscore=0 priorityscore=254
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
X-Proofpoint-GUID: GtHTf4woTxrf6MMswXTSg7DYMr7SlHvE
X-Proofpoint-ORIG-GUID: GtHTf4woTxrf6MMswXTSg7DYMr7SlHvE
Reporting-Meta:
 AAFQ3Y4DMhQgdJqMfnK77xkwq0/oyZWlNhuSDFad4CAJtwFPUqH698cqTfSaqjSe
 9WnZCDpSF8XO+o2ESCmFzll12eAB8kj3CQAdpd3IvI9rbVMHw05a89QffsQ3+oFS
 FYGY+x8FQFEa4Z7FxYsG9m/PJR9Fe4eYBDrN37pN9Z0XzbMddrAQU4EOfd3sSJbn
 fEJlpndQb5JPlzVvO4MUixiL/QtM3zR03CEFqAjtQMXESXepxl7sIr1aaodRWHhr
 vZkT8azncr2S1sQUmiPgnTonGsN4rl0TZZ4wJbyMDG8SEtN/9yOn6VIMYsypgmJR
 p2cj9D6cOTBSYb50nZL7LRthtACPYfxeC66okIFTaooQzxpMuOqaggGBAwtMlcv+
 JE7U+7L3xRx02hP+p8yOJrlawGjWEdSzfbovoVCtgZ4CzYDmEL76CHOa9WHi5c29
 2SVLKZZIyiuKIqq/3odEXo3TOA9iBNbSaip/n5qP1deLCanwnuHv5bYHdskYn3OL
 1Sh09CdGqhWWHoUgPd+u6+gfgKFPuviY4pKiyRTq6dsh

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
