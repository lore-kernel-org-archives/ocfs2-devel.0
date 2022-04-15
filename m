Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6B17C433F5
	for <ocfs2-devel@archiver.kernel.org>; Fri, 15 Apr 2022 04:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=OOuGpF2IDOuGrtFfwSThFzxd3u1mhnY8DbD9OeHtOXc=;
 b=1lGXk9+MEEvCcsjFeuQsyBvlbcP0FJoZGM9fRRFLSXep6tyaYK3wDe4spy4RAsKqv7WlG5JS9lTI
   YwAmIqFW5duvPlW71sv8adbOku/19jYfAisGJeReLfY25GlExTGJ93IzX6YXCoJxicCW2PXk9qbA
   b7ox9zOPsWaxb+u3MTDLp+8LAUpw+rb735E2Xjao/BAfnBOyhynx7aPIJ/WpcSv7HJkd0BLzOjP+
   DrlsvgnwjTpSPCXzj6r6H90h74QOZdPyn1cLDpLfvxuHVfYPgIUaP2LryBlxza6XfUJqBZGI0jYM
   beh2TVwYuIjuNCOHwf9Ec8obvuvt/J7N9X2yjg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=OOuGpF2IDOuGrtFfwSThFzxd3u1mhnY8DbD9OeHtOXc=;
 b=E38KxQH2W4S1Gl2ptwvrv3pCPFL42iNGK0Sprbr3A3960qWcoBRxdRLaHrBub6cjZAehGq+rMv1u
   PdIZkcBtQicJQoC8o9EJ/40zx38uOhsg1WFaMwwWvBOJ+E+CcNzyatyjA+c7eXL04z4uzIvlLFKX
   hFV/wxKjbbkq/v9BnfI1MMmdqOInVycD6y5U9hJ15ct6VhBm+bWy86cKQe73hcV0WF7MCdUJ4ft+
   3EJJgeMEd5/RHCO+1WHCnSi8bBtzF/KX/5yylGYKFoJwCVmx0PNW80xvQ0SEUnDICpcHbfwdRFHX
   O/HKkzjSxb8Y5M6BWFDGvxVErUjP+9N3DtBfJA==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RAD0041F6Z2Q400@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Fri, 15 Apr 2022 04:54:38 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=OGJvHxXgCvw9/l2/0Y6T0ivupEa5/VICLVgDi4pj6zk=; b=V1O5NFc1OlhQKBAtPUESXrscbH
 +gcfK8CWzUYJRweVfHt/gmcJRbnnyENCL0uxhp1nElH2rQXnBLZskSDze6nM9j3gF5JGx31h7pu9N
 vPub4AczDFXqMD/nyRBLgGmvIyYUqZBGTv5Cc6JJINS7BJNf0/btoIeeLCOjZ4a5fxHer4O2Wp+wl
 3U3FDeLPVBAqUisUOlzqQt8zs+kHINf2usFr1NigldxLvR21wl2YG3uLr/6AwNNFGfA7YCs2iW8C/
 bPJ75RbYfKAHSDs+/fiusGnx0gVrEkfUrP1ZPu0GLZCLsq5AzPGOB49mYYVnrdML7RbrD/GaYtdc7
 GVJ2xQ0g==;
To: Jens Axboe <axboe@kernel.dk>
Date: Fri, 15 Apr 2022 06:52:41 +0200
Message-id: <20220415045258.199825-11-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220415045258.199825-1-hch@lst.de>
References: <20220415045258.199825-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10317
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 impostorscore=0 suspectscore=0 malwarescore=0 clxscore=267 lowpriorityscore=0
 priorityscore=156 mlxscore=0 adultscore=0 mlxlogscore=504 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
Subject: [Ocfs2-devel] [PATCH 10/27] mm: use bdev_is_zoned in claim_swapfile
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
X-Proofpoint-ORIG-GUID: WJUmC8MI8EQi3px7TuOkVr75Hec4HIED
X-Proofpoint-GUID: WJUmC8MI8EQi3px7TuOkVr75Hec4HIED
Reporting-Meta:
 AAHWQaFJ7vLMjYNc/QzHDkPsRjypfqMewwqxiwlvmPCsiSmf9zl+oZGuCscerbey
 2gx4I/iIaVcqlorxPjKEeh6sVb/SYsO2NOJctJ4J3H/dfq9v3d9jEwMnxlQqLcB5
 Hjk5o2Lm90Z/btxN3ucoHiV71t0FGkZjsHnqRVeenqpW4sPZYpP6z0K+SGlgvLty
 BOxBMAiCtq2RSZdB4L1JDR5yV5AzUpPKJ4lnA9ZdMkXTxPpY6BsQbdttwdfIT/lT
 Fy9FZy455NxJ/LmwNoCkVCZNHMhwDQ9b64gWxX9wA0WjVRanla8MEoviI4qlFJs+
 yWrTbfuToCrHETX02j+xrFY+xoY6DQtVvBUlrYzdaPyDX33OeUy8NRjGBJ3805u+
 1buuWai6WudOU3zKOpOAjsQEmSgu+zEsK8lWoxjLBAqFj1a7PFJrSJpFINuhgfBR
 qL8+Funke9vMNLQiO3kdmFVIPBzLh8WOL+4C/ZXiRbzQOHsbUhCqYm1w6soeiKDZ
 LE8AyOdaljyLOHzMTnywHaK+W5iBjzSHNLvFQWnkAKVm

Use the bdev based helper instead of poking into the queue.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/swapfile.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 63c61f8b26118..4c7537162af5e 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2761,7 +2761,7 @@ static int claim_swapfile(struct swap_info_struct *p, struct inode *inode)
 		 * write only restriction.  Hence zoned block devices are not
 		 * suitable for swapping.  Disallow them here.
 		 */
-		if (blk_queue_is_zoned(p->bdev->bd_disk->queue))
+		if (bdev_is_zoned(p->bdev))
 			return -EINVAL;
 		p->flags |= SWP_BLKDEV;
 	} else if (S_ISREG(inode->i_mode)) {
-- 
2.30.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
