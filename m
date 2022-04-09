Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BEE3C433FE
	for <ocfs2-devel@archiver.kernel.org>; Sat,  9 Apr 2022 04:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=OOuGpF2IDOuGrtFfwSThFzxd3u1mhnY8DbD9OeHtOXc=;
 b=GKP3Q2x2GmhKl7ZeUopgUg1+nirr7AhSQT3hiVINEvnBwP5/IugkW35wlcEK9yrbg6gD4F0S/OoI
   4MaGuqbn70zCHwuLiVN2tQ5gKm+HswEaoZ0JtbV2hYG2wL++PykwYU6wf2vZWk+ggH1X+gOSBvpl
   TQLtWxihLm6WjcAeMczjtgJ/zLasB9FHSaVy8YtqTbBYZLTz3XQt2e3QdT4i8XuLpECW31fXD0Xs
   NzOZZ9reTfsRokXGHB3kGdc+W6VuESJ+dcOX8PdtzfGvTRjsi4m//zUjz/6FN398kS9i94n6ryrX
   HhdEQduqyIF0SEq0B3sao3Bigp4zib6kepRzZg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=OOuGpF2IDOuGrtFfwSThFzxd3u1mhnY8DbD9OeHtOXc=;
 b=SX6ezwBn6lDLVnd3L1C0FkslSfW/SgG0wGdqDB2cfv2e6Hdend6GyUuFglJY/vYwiRJc2+65GC3W
   cip0HtCpSs8Qs0+TKpJqiUTEa8CQjN4s77kBRxb290DsdFYtCBgfZav3pPlPPifEpTF8v+hmMygh
   Ri5OMJHDvdvxxtKMYhHUKU1XZDh/XVto1TiYChTV8SeQ1iWgBKsZpx6dbfSs8ts8SurwtDlwaUzV
   VLlsBq2sjuxyhVhkAqQIFoqo61MD3JSG2WGXkKhFFjIaRDN9QyDI/HwLHXjp6DPCmhRe4eGJBCAo
   Bw4nstzSHhlvJxOgAwru2Wj6PI2dxHZXSdLKdA==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0RA2004J42UGHE80@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sat, 09 Apr 2022 04:51:52 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=OGJvHxXgCvw9/l2/0Y6T0ivupEa5/VICLVgDi4pj6zk=; b=bvdxNtIBSK2e/CHWOJvjhJQ/pD
 ziWAaN1+H5rv0PFjwCtxUb32HQisXqhv0CfdNRRakGSvxS2SlGM7sa31KM+kznDnIR/AZLVb6CdU4
 vS8DuWDB+gUHx5md6g+mCQSqz3crMjKTJ6PsdykxY9osHuidQtFbDkq6qQ9nvfWGIgIk4Rkp02Mzl
 WCYI+BDG1gl4hW/mPoncA+V1yctBgiee9+ltyBfbzQvs00T9mPYBlaJ4i/TRsB0Z4Fkgt4oIU5qzV
 IXkEEPpdqsWu7ooiuyvMhxa14Ribw7Jyx9BT4vHhU8n59256QhhUPR6N/0aIFpZCRpJfpeccBNtOP
 uiV7Ifjw==;
To: Jens Axboe <axboe@kernel.dk>
Date: Sat,  9 Apr 2022 06:50:26 +0200
Message-id: <20220409045043.23593-11-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-reply-to: <20220409045043.23593-1-hch@lst.de>
References: <20220409045043.23593-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10311
 signatures=695566
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=458
 spamscore=0 clxscore=228 mlxscore=0 phishscore=0 priorityscore=0
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
X-Proofpoint-ORIG-GUID: T2joWuFSU8ypvsKaY1xIFfUB7Ga44Hww
X-Proofpoint-GUID: T2joWuFSU8ypvsKaY1xIFfUB7Ga44Hww
Reporting-Meta:
 AAHi1IzLqLhixU7IgGt7Y3I6WVGyaNthInS9fbYO+wd0MGbmu23nwraBI0NHU2V3
 NMwtl1nAnd3Ntbrs+4UEyfcpn0V52pjK5o+6rlbDX/K8J6IqzLxpl44V+3noxqrW
 WxJ/0Ryk/zhILTfUIU0R+X2SIwx33w7uxU6Ndr8ptLcufuJcoSY0aggJUHUgvMXV
 TqDWCt7tO8yabBs4SB900xQlSB9sqQWMDKiMubDjf8lsz4vDuf7pBV1oT5m2Nv6s
 Cr+93yGreErvG1a6KEhlkFzVgVbNPSyfob5cYBqUbBzxoe2FTSuepfW5LUiZ46hT
 50XU58MBizY65mzbVcrBvqalmK13RHSbpRzY8x2BaC8cCNJ/lcFJZsJmLOTH9I1v
 dfZsF/4XrPUW79VPy5zJQo9izz1lMBKzdtKB8MIc1oM6JpAa4eChOuJq3lTTnuun
 uMQivFl4OplXrgsT5O/vS/qvjgRRspXbsbY7ITFDVK1tNbiXsNtwSV6uAGa7b+qE
 hVXj8YyGa/L4o4h0B5ygt2eP6UMpQ77xZwAk22pnU2/S

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
