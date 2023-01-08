Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEA1DC677F1
	for <ocfs2-devel@archiver.kernel.org>; Sun,  8 Jan 2023 16:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=jszucWulttQ5q5Drd8oOBuA+KtV7PN4RyLWi7ybtAJ0=;
 b=Hdj9XtwMdslWLblEazeN+9nuZMAW9N85/vdis3HcW1OpiNwLH2tFsXxgT/soMySgB7NRSaR5Umdg
   DT214pl3CA/TcvEGosbxb1gqpHU9Xh+W7g2XkuycW5hGEuhPcH4vwHN3sstTTNa6Wyz8XTohSrN1
   ToIQKi59gIRK4iDWbGAXW9Gdw+8YCkAncqApm0mLfu244r/N4EWRsqC9a78zo27tcpGvZOtFYhho
   /sriFAwmglSvfJR/XL4O0bwxHsVO2vwnTBglsE9otG7DXP/E3m5zIIlIJBthgSD6VqY4PlyXW3HO
   zfXzLpG4WX/b2+NC2kMBUhuXXlPjhdNarEh8FQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=jszucWulttQ5q5Drd8oOBuA+KtV7PN4RyLWi7ybtAJ0=;
 b=XjixkPQPBSEziOrINdQfRDIbdf47CwEpE4ziHq11Nn08OORaEj9ds+Q6xt+esh5442BwHv48BQbp
   8L0jaZjPXz06vtRPazEYKxDM77rkYADx5Qn94E+ejAu7Wm8iHqgGaJLscfOIxyh9Q4mXssY0Ce0B
   iA0EdZi/XUBGn/byY7paYFIgopEeCW7XD0+ALjvmjiFmRWgoeDWJpEiwjOfrgSB2sMTEzHsvFNCm
   VX+S3anGS/vTyk63mpk6L+a4RAZiJT7UTnymdySpocnPMxwZnE+ait7MJEqgvQD3J77FNmY+lbGf
   Gm67KQwopAQJ1tg30wwaLmPVKlHM8OyscS7Crg==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0RO600MG7F3ULXD0@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 08 Jan 2023 16:57:30 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=BznR/4w1o26qgOdWpgaXoEzrG7xwT/5BaeqDtDNhkG0=; b=KycIApiWI5yISCZouDp8O8ipc4
 dsl/ueN8sUNA33Tp9c717pqGJ+DRYXWPrwamlDfC9ftc159YEu3rH4iisYVgqRu/w53sUAME1wPCf
 MTqnBKQrVKo99G/ggyD2TGlKA9HTNX06xjiq6D39LxRqspHtjdzrjwPj/R4YOGTbHKRoxYyqU+GgO
 hplk+/amqkkU5IiaF7B9o2QiTNtdVdmhnSylKAIJ1PkTIFxh3AiZkBHips001Vc6L9c4I1xFVKuNI
 30m27hquq2Q0Y5e4zNu+1vbMwCxkSGN7IoC06MseeAUTxFVjrgD8hhd2XQ2oWt/MRiFklab9eYZBQ
 21VcibDQ==;
To: Andrew Morton <akpm@linux-foundation.org>, Chris Mason <clm@fb.com>,
 Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
 Dave Kleikamp <shaggy@kernel.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Evgeniy Dushistov <dushistov@mail.ru>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Sun,  8 Jan 2023 17:56:40 +0100
Message-id: <20230108165645.381077-3-hch@lst.de>
X-Mailer: git-send-email 2.35.1
In-reply-to: <20230108165645.381077-1-hch@lst.de>
References: <20230108165645.381077-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10584
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=301
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=778 spamscore=0
 phishscore=0 impostorscore=0 malwarescore=0 priorityscore=60 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301080126
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 jfs-discussion@lists.sourceforge.net, ocfs2-devel@oss.oracle.com,
 linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH 2/7] btrfs: stop using write_one_page in
	btrfs_scratch_superblock
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
X-Proofpoint-GUID: 8wJWdGAucdQjJ9K8UaxZBKbgcY20XgZX
X-Proofpoint-ORIG-GUID: 8wJWdGAucdQjJ9K8UaxZBKbgcY20XgZX
Reporting-Meta:
 AAGPFm+mo19dtJcTATGl0O4VHJNUwwD7Tl0qAD3T4Pl7VkGLloX+h0Kdj7IzOedt
 qV3HobP7JuosD8PdFxSAy5VKRmptp/3Kf5EZ9ImqlU0SJhstkgtFS5G0nW5c4zSr
 DIOOAGA9pA+iBDL1VpGN0GCitXgK70i3RIWRwWGEZDR4p1TGVJ5Spd22t6cylFoG
 B3WJXv7dHQpv4CaHp+N1qy80uGOXD4mIL3519r6WdlAMVSs36BG91+htW7r6jE/y
 4eElunXdSmRduUtM3sfBJ5k54ey/64Kld9HGi2DtjNgG+T/3D6cYeepdoRH9eNAv
 cWzu0WUri71m6Kc3InXPo7idHTSAUXJwGUAk618Q8yxZaGizcHJz32FzUzMWuMvK
 xpJSSjyUi6evLYkTr/grBlL6HFVTmUk+7jHmJ19BGLCBJC+WE0ZQh79VT/5E221B
 XUuMhS6+gAFRcZRk5DNdnZn08NgrgDpSOA6YQ5054ouGRaGCF4Hv5ngwIi0tDN3Z
 fSv46czu+dVTJMWQqtbB1XL6pXKyEIjCVWwgZOIjb5YM

write_one_page is an awkward interface that expects the page locked
and ->writepage to be implemented.  Just mark the sb dirty, put
the page and then call the proper bdev helper to sync the range.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/btrfs/volumes.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1378f5ad5ed4c4..10e98b004a2fa3 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2009,23 +2009,22 @@ static void btrfs_scratch_superblock(struct btrfs_fs_info *fs_info,
 				     struct block_device *bdev, int copy_num)
 {
 	struct btrfs_super_block *disk_super;
-	struct page *page;
+	const size_t len = sizeof(disk_super->magic);
+	u64 bytenr = btrfs_sb_offset(copy_num);
 	int ret;
 
-	disk_super = btrfs_read_dev_one_super(bdev, copy_num, false);
+	disk_super = btrfs_read_disk_super(bdev, bytenr, bytenr);
 	if (IS_ERR(disk_super))
 		return;
-	memset(&disk_super->magic, 0, sizeof(disk_super->magic));
-	page = virt_to_page(disk_super);
-	set_page_dirty(page);
-	lock_page(page);
-	/* write_on_page() unlocks the page */
-	ret = write_one_page(page);
+	memset(&disk_super->magic, 0, len);
+	set_page_dirty(virt_to_page(disk_super));
+	btrfs_release_disk_super(disk_super);
+
+	ret = sync_blockdev_range(bdev, bytenr, bytenr + len - 1);
 	if (ret)
 		btrfs_warn(fs_info,
 			"error clearing superblock number %d (%d)",
 			copy_num, ret);
-	btrfs_release_disk_super(disk_super);
 }
 
 void btrfs_scratch_superblocks(struct btrfs_fs_info *fs_info,
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
