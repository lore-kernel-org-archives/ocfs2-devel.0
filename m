Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28F9BC433EF
	for <ocfs2-devel@archiver.kernel.org>; Wed,  8 Jun 2022 15:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ufj5svfC2INUMvENyYAqqd/TM8uJgDXbzIMnYpSNakk=;
 b=O5eJoB2ekwRe+kPZyO3xdB8rlp6q43mwRVkMhtZLD75AlUYx/folZCkCgi0Qi8+Nkm5WOV2/aX1x
   iHgq5s69rpLbA6XBIDldp900mS0mb8E8pRztMU3F5SSXxwMAuqnjR8qkPlgcFtePFsh7Y8lrEmw3
   kkd4X+4BBvBeVO03ZcLYfCSk6oXiYX0MeznPh4/Qolv7YGUx5HwL/vwVbQM28F5LSsYkBA2nyp8P
   iwGnKzzaebPY51AVYqEm9ahozgpcWdqoJCRj5bt/tP9RTBdpDKQsWwpFUP9bmMuXr1w87EK/0pyT
   +UnyAAqibLauzUpvlHc6dvrSCFjayXTr0qHPpg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ufj5svfC2INUMvENyYAqqd/TM8uJgDXbzIMnYpSNakk=;
 b=N17bwGS8CChdHxrRAEOkGk+iVdzv7ltf//cXewSXtjZulIS09euSu3G/ACHNVAUQx4dxr+GyRqXD
   G11ghlE60BL7oY7UwRIbCVKzsb9R87eQYvrnh7rgGJ4VSSFC4i/NQSUEXBuKd0ILNpSSls6FX1Y3
   /TffNLbQWas/HpW4XYiZDTtmnG5OfESDFJnC7RCpG5JMzGGDmSBBG0PxjFirvYsPqlFVxIbh3Hgu
   wEM0MmYc6kYzLl94cHsl1oMl1VFAYh8T38OVRzZ88uPuOkWpvYrRU20+JYwj0H5I828Ot+2LdRI2
   M/GO9mLyuqLOX82DhCYOLWKImc5wBl07UUFn0Q==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD500CKHZ6EST10@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 08 Jun 2022 15:03:50 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 Content-Type:Content-ID:Content-Description;
 bh=6sny7mgbMzuLsgsgFN8vZ/E7WcZlP1DaRKRtHbfX8Jw=; b=hiZDwkFzLkpw4nMGSQ9j6t8W6q
 vvmKP/IIvikzofOHXwsx0H+rcgkObjb6HmPODgSF68eOauY/+iZZqt5bXHtz9ijuINOnOgv2mFiBV
 5M6lkjPPGdm88+DMS7Hh/nHzu8bQIW+WXPytwScUVzFHXpxTDC4AmUKFjHtWfaHqeeuhQu4d7IOAn
 Leo6f1ZcVRUIaXyW8nY9kbO03KCT8UR3mivr867QazlQMkDev7LpY1lO3BMshouOC11vMO/aT+lSl
 oAou1WWo/zmr5pC6ttZ+bmRMwT5RYtouNJChkW1uaO5hfxGEGrSJ7GKa+qvLx6bXsARbYByI4xzeb
 30T712Tw==;
To: linux-fsdevel@vger.kernel.org
Date: Wed,  8 Jun 2022 16:02:44 +0100
Message-id: <20220608150249.3033815-15-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220608150249.3033815-1-willy@infradead.org>
References: <20220608150249.3033815-1-willy@infradead.org>
MIME-version: 1.0
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10372
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=163
 priorityscore=220 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=0
 spamscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0 mlxlogscore=540
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206080064 domainage_hfrom=8380
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-ext4@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH v2 14/19] f2fs: Convert to	filemap_migrate_folio()
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
From: "Matthew Wilcox \(Oracle\) via Ocfs2-devel" <ocfs2-devel@oss.oracle.com>
Reply-to: "Matthew Wilcox \(Oracle\)" <willy@infradead.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: casper.infradead.org
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-ORIG-GUID: WSTizzcpK2_D7mMRPCLMoVgoYHSBVa_l
X-Proofpoint-GUID: WSTizzcpK2_D7mMRPCLMoVgoYHSBVa_l
Reporting-Meta:
 AAGSNHyQ3WL5X+m7Gz79NNTymd+P4h6kFrS8ung13tzyAOYW4VpFa/FcAXXTM7Uk
 fZR34GuUtOTDHWGDZC0zpLdRaeFmjmMGgmzFJSziqQfOGDiDdERAf2eQ1UAsuZq6
 gmUDRnx96Z0tI/nEBFbcLN+SLyVDhgBWcEt1UbUgMZY+sLJRe/GQ9nSl2bb1i56x
 FjD3TGw22HHdZ30/kDmUEDCm4EjBx1Hk4exjibmzZ/bv4vXDLXdY2L8To93q4/7e
 SXSi0jcHwBtAqq6KjdZYwzZs7rIbWio/XihGk/QOMWipDZc2d1XHyYuXmLKKyyFt
 frY4HTUEfagBVYr8i++G5uASSmSzJNJtMjnCfZ5Ul8iZB41g+/XCLUWntQb5UPAQ
 A9PjK+xRhexks9kloDe24onisxX4lYtO7pzSs1EhKTzhZMjCtiTcOaRlhWYOwpjr
 ciwRJ0pOMhYhXC4IclX+1cJu4XYGP5XHwPvllm99QscEIVfk3AQqFNPfOltiCD/b
 NZ3s/WBnFYyznVcfvt6/zT2nB50r6HRmmZxsfM4nAR94Yg==

filemap_migrate_folio() fits f2fs's needs perfectly.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/f2fs/checkpoint.c |  4 +---
 fs/f2fs/data.c       | 40 +---------------------------------------
 fs/f2fs/f2fs.h       |  4 ----
 fs/f2fs/node.c       |  4 +---
 4 files changed, 3 insertions(+), 49 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 6d8b2bf14de0..8259e0fa97e1 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -463,9 +463,7 @@ const struct address_space_operations f2fs_meta_aops = {
 	.dirty_folio	= f2fs_dirty_meta_folio,
 	.invalidate_folio = f2fs_invalidate_folio,
 	.release_folio	= f2fs_release_folio,
-#ifdef CONFIG_MIGRATION
-	.migratepage    = f2fs_migrate_page,
-#endif
+	.migrate_folio	= filemap_migrate_folio,
 };
 
 static void __add_ino_entry(struct f2fs_sb_info *sbi, nid_t ino,
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 7fcbcf979737..318a3f91ad74 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -3751,42 +3751,6 @@ static sector_t f2fs_bmap(struct address_space *mapping, sector_t block)
 	return blknr;
 }
 
-#ifdef CONFIG_MIGRATION
-#include <linux/migrate.h>
-
-int f2fs_migrate_page(struct address_space *mapping,
-		struct page *newpage, struct page *page, enum migrate_mode mode)
-{
-	int rc, extra_count = 0;
-
-	BUG_ON(PageWriteback(page));
-
-	rc = migrate_page_move_mapping(mapping, newpage,
-				page, extra_count);
-	if (rc != MIGRATEPAGE_SUCCESS)
-		return rc;
-
-	/* guarantee to start from no stale private field */
-	set_page_private(newpage, 0);
-	if (PagePrivate(page)) {
-		set_page_private(newpage, page_private(page));
-		SetPagePrivate(newpage);
-		get_page(newpage);
-
-		set_page_private(page, 0);
-		ClearPagePrivate(page);
-		put_page(page);
-	}
-
-	if (mode != MIGRATE_SYNC_NO_COPY)
-		migrate_page_copy(newpage, page);
-	else
-		migrate_page_states(newpage, page);
-
-	return MIGRATEPAGE_SUCCESS;
-}
-#endif
-
 #ifdef CONFIG_SWAP
 static int f2fs_migrate_blocks(struct inode *inode, block_t start_blk,
 							unsigned int blkcnt)
@@ -4018,15 +3982,13 @@ const struct address_space_operations f2fs_dblock_aops = {
 	.write_begin	= f2fs_write_begin,
 	.write_end	= f2fs_write_end,
 	.dirty_folio	= f2fs_dirty_data_folio,
+	.migrate_folio	= filemap_migrate_folio,
 	.invalidate_folio = f2fs_invalidate_folio,
 	.release_folio	= f2fs_release_folio,
 	.direct_IO	= noop_direct_IO,
 	.bmap		= f2fs_bmap,
 	.swap_activate  = f2fs_swap_activate,
 	.swap_deactivate = f2fs_swap_deactivate,
-#ifdef CONFIG_MIGRATION
-	.migratepage    = f2fs_migrate_page,
-#endif
 };
 
 void f2fs_clear_page_cache_dirty_tag(struct page *page)
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index d9bbecd008d2..f258a1b6faed 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -3764,10 +3764,6 @@ int f2fs_write_single_data_page(struct page *page, int *submitted,
 void f2fs_write_failed(struct inode *inode, loff_t to);
 void f2fs_invalidate_folio(struct folio *folio, size_t offset, size_t length);
 bool f2fs_release_folio(struct folio *folio, gfp_t wait);
-#ifdef CONFIG_MIGRATION
-int f2fs_migrate_page(struct address_space *mapping, struct page *newpage,
-			struct page *page, enum migrate_mode mode);
-#endif
 bool f2fs_overwrite_io(struct inode *inode, loff_t pos, size_t len);
 void f2fs_clear_page_cache_dirty_tag(struct page *page);
 int f2fs_init_post_read_processing(void);
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 836c79a20afc..ed1cbfb0345f 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -2163,9 +2163,7 @@ const struct address_space_operations f2fs_node_aops = {
 	.dirty_folio	= f2fs_dirty_node_folio,
 	.invalidate_folio = f2fs_invalidate_folio,
 	.release_folio	= f2fs_release_folio,
-#ifdef CONFIG_MIGRATION
-	.migratepage	= f2fs_migrate_page,
-#endif
+	.migrate_folio	= filemap_migrate_folio,
 };
 
 static struct free_nid *__lookup_free_nid_list(struct f2fs_nm_info *nm_i,
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
