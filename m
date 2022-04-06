Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D6CBC433EF
	for <ocfs2-devel@archiver.kernel.org>; Wed,  6 Apr 2022 06:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=OOuGpF2IDOuGrtFfwSThFzxd3u1mhnY8DbD9OeHtOXc=;
 b=Lyum8OSfrTPmVursI61DQFBApIIEjEZVGqA/BBdqb2Oy4Z/ltr/vhRqjSC35Q5ygwFuiRVltbqxt
   QuqR8tG75jTXnIFM+/gVkhH12M81SwRYe0PE5iOz4ZTzhm702hbhXlgtLkT6kOlYgBPYbLeNwpKU
   zrrlS/YMSu99E3zGAiWkHn0mjtXkMmXjw/L5g9kmhnm6e20AoV54vR1ELtzYaz/dMcJyZZzTsDHP
   aHJRaQcFnhb0w7LQd1Gst/K1HNSj2P0Dun50S9XUWjWlxx6fQTIUG5Iiyap8eD3LTWBzIWhr1Cps
   k6I7BNYKi71ztFiTUd2tGEfoC+bohOUxvP6zKw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=OOuGpF2IDOuGrtFfwSThFzxd3u1mhnY8DbD9OeHtOXc=;
 b=GE/rvpbIPYjLo/Si11k2YhEjRD47vnV7u+lOYdhA1+PobcncH+WGo0JEUVAwPXWq3pE9VrecKMdZ
   mcSXRx2+N+/RxdZgy0KXTwGZNkcs1esv5bx+gS1VvRNIV1MwGPuk7YhOi0f55yKwrfXkktDceYho
   PjzCKzsyUrNZGG8OEC0jJbRww6T0EFY5R7cuK9bQEVi0XJMVfET9Xjk6VT4lmG8fFNL4vFNIcPf4
   XSWIQO5/OLC/LIGJwo5zaTmL89OYfT2KrnGYrka9a7i1hImywiSlo+d3YsLDPULYATz5JL1ji2zN
   WXByqO+f1CzHdsujlim8ljkLoFGByVcdS57ARw==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9W00ILRMAM2A30@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 06 Apr 2022 06:06:22 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=OGJvHxXgCvw9/l2/0Y6T0ivupEa5/VICLVgDi4pj6zk=; b=SGjGHiHxXhTBb30pFVsmtYoofW
 AXRkPwj9L+IToaoBSWN/RSxSSuBK+pJDBU/ojpwlgCD+rUR4zw9pN8EFDE29pkKOW63auHTvvxwCA
 PC6e0Da7Eiu1hFS/uIysLLSexy3aaIErbCMYeQH3HFSJ8bABmb6owDVYICpwPc9JKy6Ef8YTyDd/h
 SpNQxuUWxQhBUfv6Iv5iH1SH6hdeTIk5hPArvSrbVe9a1T+UDbpIkKauh2JPDG7p1MdAcg6ES2qNP
 pANlA2vT9XhPzqH+DYD3Rh3z9Pdg8L6xQ3HlNdFcmLcX+EpDCJ45aTaIIck6oVGd/w30i6T7ad6VR
 N9+UdC5Q==;
To: Jens Axboe <axboe@kernel.dk>
Date: Wed,  6 Apr 2022 08:04:58 +0200
Message-id: <20220406060516.409838-10-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220406060516.409838-1-hch@lst.de>
References: <20220406060516.409838-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10308
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
 clxscore=351 priorityscore=60 mlxlogscore=466 phishscore=0 bulkscore=0
 spamscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204060026
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
Subject: [Ocfs2-devel] [PATCH 09/27] mm: use bdev_is_zoned in claim_swapfile
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
X-Proofpoint-GUID: zLz8CFx8T5eG-0ek7fcwjVgEw1vSILjx
X-Proofpoint-ORIG-GUID: zLz8CFx8T5eG-0ek7fcwjVgEw1vSILjx
Reporting-Meta:
 AAG7octwdjZkja8Mm1fLuSxNK9W8ri2OgDimeKiPp3Nh5yWFGYcP0Vh6K5uyxV/T
 gH8veL7G3tZvT3Wa+4qhgf8sDMLMlLmHkL7SeWTrpyP988lE9hXp+3tm5OyV31gz
 qIRvZYQqkoBzBcq/bHOb2Vom86Rsv0i5XJNuIw0n9k2xhLxFkYS/B5ViIQQb599S
 RY5RSjYfDfETFfqqdgJxj00+ybnjhfy72JlQyw2IGikE8iBQQM9Z8kfMckurEAzM
 xaekEKRVHHNLQW8MyBNFKvVgEdgY1RwxVrtqQxzp+vg3RfMzXIpxDfpCsYoNkO18
 R+phdApt+SuL6CDBs0L0+QEOURCfkOiLs8CRXwK++Tlc8tMV1xXBpjUdXXCX+nNQ
 wrqHAteWPAZEe+8wRzabC/4v15xP2tUnqvevnjR8qUCWWbzhSMPWf3TsjixVmpon
 qjWyX+CfY8jSI58nd6gca/Nt9D/ibXFQMPp6LO5EpQz+LbApNxozbHlMCkabsGnb
 P0dhAMBXyRAnGfEjOHYqDCcNNCBwvdy8JrL0L/lTu4+f

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
