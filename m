Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 416E0C433F5
	for <ocfs2-devel@archiver.kernel.org>; Fri, 15 Apr 2022 04:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=b/Mu/tNkTvj83TzTpjVfeJwQdLdU1evL2qba9H6BTTg=;
 b=Fcb+EhhvfETkpP1pLXKXFW5gn8EuJzcfxhI7eU3av9G/ZhBGNv5rnOEsiTBb8JuA9ZitJWxApt/8
   qvEAXlZmrIaPYJD4kHLuRxleOs0Hy9k6s0cyLVIBTkcRsRd91Q/5LkCnLa6Fm5Dnh+uPBQCu11a7
   pM2m1blMNeYGOE6DgVgM3T+zOwF+5HtBr/y7ZFTDGT4EjJTUqO2UcrIIwbtWGhY3404bClTR9ld0
   2TxmVL399U99UrbY9y0SnFigldR1fhTcAf6C5YBeFGOPqv+uW7wgY5yHyyYUo8/0ncHedBa6oWPb
   jPWBvV0UUPnEjVxGumNHRtEOUkUs0dnZnR8dxw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=b/Mu/tNkTvj83TzTpjVfeJwQdLdU1evL2qba9H6BTTg=;
 b=Szm7BV+SFvARzm5M2d7TAZ1xRrJuvjPAiEAn842DCnDFHq3UIYFt61ba4PCObqmeqBflXY6LBLev
   fyuztFbMFL6ev68x5bd8cJ7wRqtBexrPAPlpBStcHphG7oGVD8RSi/g7iMf9GIIWvXQB51EHrdGA
   oqi9Qk37Oo4jC+kEVNxXTi5/bBgyKo7B+l4nrfqGKY53vpXI6HsqK2epPSXSxsjufhHuv+cq7lni
   FOchWe0sl0NG9OzjuBgWycOrDCN1u2a02/hRQIbwmlWYzLPam7S+Xjie+1znUiFQPAHfQXVN8cux
   p/QoWnPoi6FfjNo3fFcG/L6SBUYZcrWYY3i6TQ==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RAD002G06YQH560@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 15 Apr 2022 04:54:26 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=OTIsP1OizukmDhxFkiULvJk6rKtH8rZ66Toc2zFZ06c=; b=ooMRjv2JAUzFUPyfh+XZqWb8QW
 Q9pjLNLNX62Z8C2MtoU6HU3VpVt4OAZRBuYSsD6pXMOi8ZjLOdl54eYy3Tp24LGUVsHa2hBE7Y0RM
 gDKNIKXjx2hbqJA1iCpB6nzk3wFq7ScIOiguPmNGaxWjNFoSpuysiesbbWxhRLyGcBXCzqkMTGuuD
 XDeeqdLlxhy91bRF+ZdOWJypNUbEcjrD8gjGqtH4BhZffx0JY9uZOYdBApIPmQ3bzD93iVI7xEHYb
 JNb40WmRbrFCmN1/+6dAisHF7eHMEiTWRFZXLfqhSoZ7Cj20tDlAxwUfcT/Ob7kj6Vu7zsHN8pcpE
 pX9GukFg==;
To: Jens Axboe <axboe@kernel.dk>
Date: Fri, 15 Apr 2022 06:52:34 +0200
Message-id: <20220415045258.199825-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220415045258.199825-1-hch@lst.de>
References: <20220415045258.199825-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 127.0.0.1
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10317
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 priorityscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=988 bulkscore=0 spamscore=0 phishscore=0
 lowpriorityscore=0 clxscore=255 adultscore=0 suspectscore=0 impostorscore=0
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
Subject: [Ocfs2-devel] [PATCH 03/27] target: fix discard alignment on	partitions
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
X-Proofpoint-GUID: 53IWFdBMB1fqaQ0yZMOH801yyA-i_9Q1
X-Proofpoint-ORIG-GUID: 53IWFdBMB1fqaQ0yZMOH801yyA-i_9Q1
Reporting-Meta:
 AAFVwXbrvTSIMrb9wQhpXkx7pmcZzkQMcdM566gAyIV+lXOjWPXzjKKBvDIHG+Ae
 3v4CvJGGEgv7iOaBhZfmN33E+BdoAg04ESR09yBtFiHs0bUf6HhNdBLq6wHdl1PP
 IuKi/FvPICC5TjtWfKL55J5vsQnL8HVAJTXwNXKgOB54xKCZfnGR9CJ2lnfVGQeP
 GWonj9ad568tKOKGD0EK0TWKL9KthOERBId6GxDVdHDh9KEDSpouM8xQIO2ZPx4I
 Lapxxz3ghDo6ojNVSnnPttDpuea4viHvVMzSJy4rVByA7KJd//89nc5fUHdL9Ks0
 f9wWKIGi+z0V8rAZyd5PT8OV2DjB5G+FB9mkkFRusBC6eEgr85N5/dACuMq/4cV3
 memel1y0tP4kMp0G3zJ0oJvPsDxXY9HwJyfXeLCttumWlQAx6B/9ywChNnOvinG5
 olp658tjpCPc1M/kFu+gLXk3Z6wEL9SY/M1FcplrEbuTIHC48AO/aY4/SFDHR5in
 0Fguv/WFXaRB0xiNX2v5FVdhocNO7jmXFQRdJsBweKgpAg==

Use the proper bdev_discard_alignment helper that accounts for partition
offsets.

Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/target/target_core_device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 3a1ec705cd80b..16e775bcf4a7c 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -849,8 +849,8 @@ bool target_configure_unmap_from_queue(struct se_dev_attrib *attrib,
 	 */
 	attrib->max_unmap_block_desc_count = 1;
 	attrib->unmap_granularity = q->limits.discard_granularity / block_size;
-	attrib->unmap_granularity_alignment = q->limits.discard_alignment /
-								block_size;
+	attrib->unmap_granularity_alignment =
+		bdev_discard_alignment(bdev) / block_size;
 	return true;
 }
 EXPORT_SYMBOL(target_configure_unmap_from_queue);
-- 
2.30.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
