Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48420CCA486
	for <ocfs2-devel@archiver.kernel.org>; Wed,  8 Jun 2022 15:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=AlRx/cP/Ur6RbKJ/6+OjCFmNM2+36PWWp8cfGuVTibs=;
 b=ZJJcDziQ0GnjPeXkfky10sdPeLMtUdsR2VWSuhSjW/eNJ7bB992bbQCkqfL/U1aXK21V997IcKBU
   RXW0cSlIYM9kvBqT9Cdn+Frq2li2Pj0lqceuef/q5c8acVf2dPPUdOt1vb0n8MqEaBgMmi0+uwCb
   j8YmxnN3h4UKcA8SDWgPTZiteg5i/PdytTpGqJZ3ZtEghx3HZPRuclnnURRcVYTdd+Fc/agq2yZ7
   Bl/skonOlBZs6slg5tx3wWm4ypkNScQKoQ8gX/gUrVV8D4gA3d/UeXhCOmgdQr9mF4IQTMP+PojA
   9rlxkN2A2FtZgaoR3ip6cITSNhGpTwkmhIiK1g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=AlRx/cP/Ur6RbKJ/6+OjCFmNM2+36PWWp8cfGuVTibs=;
 b=SzfQ/TgOV7p4+Z/EVJAHqbEugTixyXMnq1qe0X4cZtgiliae4D2Emvsn4GeVnrdU2qrmKLYa+0NI
   nSeaNywV7F7/E1Iv8kcVjtjR2KMRJ3u56AEpXOlDB3OaBg/Oa2Di3v7DWUmjnjPPFzmPPCsXH2gB
   A0lKXkePKAbNM3XVWCqWvGRvpxZQ7sh/wbAg4y9CK0iYXUb5c1dPmX13Q++HyLShrzJ+e/5A72AZ
   Yq/PqGoBt31L/xCgmkzBoB/MSnNMnsevEsAI/69ngidaZWGAlkYWsb79+/Aqa41de23FBf8iFY9P
   aJewsy8VJk9UljKCv0prRJbZgwdcQ1j17+pkGw==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD500BONZ6A6T10@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 08 Jun 2022 15:03:46 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 Content-Type:Content-ID:Content-Description;
 bh=LQ6sNBHr75tM+bJ1BpDjSqem3+pLGhgLRwy7i2aOU6Y=; b=Tdl7Vy7/bS7YUA6mx6+jHtRUCX
 eRx+GVhSe9l35Jy6XQ4NY5cbVzQOoht+6EwkvzS+FYXJGjIed/shYXcsq39K1Ku6w2b59jc7rB4RL
 T6I2VMDHBOb1Jq/k7WDXHO1/Y3wcfRPY+OwsnbStciOqAnJtMjuVoCXp6jwXexKgNaEdpONswZdY3
 IfVqt3vm8g55BzHQkGY9kMEHS/RynrXo0lZoHsYG5H2c+x3KOeVyJvIQu4/NvOHj9PAOKh1C+gg2L
 AK6FXUvhjy0znRrM/z5+iY7ADDuXlH9PJw+4I3iFoHT0rOWevtAKgZ2XvCn01XmFdy19SlpiRmhBq
 31qn6SvA==;
To: linux-fsdevel@vger.kernel.org
Date: Wed,  8 Jun 2022 16:02:36 +0100
Message-id: <20220608150249.3033815-7-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220608150249.3033815-1-willy@infradead.org>
References: <20220608150249.3033815-1-willy@infradead.org>
MIME-version: 1.0
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10372
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 mlxlogscore=940 suspectscore=0 mlxscore=0
 phishscore=0 priorityscore=250 bulkscore=0 clxscore=163 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206080064 domainage_hfrom=8380
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-ext4@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH v2 06/19] mm/migrate: Convert
	buffer_migrate_page() to buffer_migrate_folio()
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
X-Proofpoint-GUID: SYi_XiV1XT8-M4SSwZ9JzOXwkpJc187c
X-Proofpoint-ORIG-GUID: SYi_XiV1XT8-M4SSwZ9JzOXwkpJc187c
Reporting-Meta:
 AAEUdjyrjDXGADmYWdFqLWtJrFm2+/QdRxjhutZ920/o126QkpEupFLc2jTNKNi1
 lAnYamPZDznTKltv+cmBD53AOt2VzcIdO7grsXQeqcriKkrcUYBymqxOZ6FU4OMm
 U4265nIYkQUv00VDAhLDDtm+6mJZB3jtwagoOaT7pPeY1TEn9SldnaTRLGY5RKfD
 AX/pXgIbI8Gw417IGwOMDxuzyOvhZFbS2R6eiui3vS0gYJ064eNXHtI2KHZoxKvK
 JPNVbqnnW9A/6AY2OFBhKutWLdVKRebdWX7j4Wb0SORcinbPVfBlNZNzYQdyd4sk
 Gx2Cu6CQInerJAr9U+jDW4YsQAhRueE2EcE+7bmYxqOZ6ymF+1j9VBMnviXzSMyd
 52yt3oJtrUhdeddEFwgYj38/RcaHRUqd3PRD7o5aWjKOGtqDGqnDwt8ZKm1jaGgp
 owd3dA0gsBadyeQst5q4utm6m4xV3PwOjibg9SFpSNN9koiID3LjnP/yqnPDY8sW
 3K4hn6cyzlbILhYywcIoEQvqQkebMNCmVpFKjH2nK14=

Use a folio throughout __buffer_migrate_folio(), add kernel-doc for
buffer_migrate_folio() and buffer_migrate_folio_norefs(), move their
declarations to buffer.h and switch all filesystems that have wired
them up.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/fops.c                |  2 +-
 fs/ext2/inode.c             |  4 +-
 fs/ext4/inode.c             |  4 +-
 fs/ntfs/aops.c              |  6 +--
 fs/ocfs2/aops.c             |  2 +-
 include/linux/buffer_head.h | 10 +++++
 include/linux/fs.h          | 12 ------
 mm/migrate.c                | 76 ++++++++++++++++++++++---------------
 8 files changed, 65 insertions(+), 51 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index d6b3276a6c68..743fc46d0aad 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -417,7 +417,7 @@ const struct address_space_operations def_blk_aops = {
 	.write_end	= blkdev_write_end,
 	.writepages	= blkdev_writepages,
 	.direct_IO	= blkdev_direct_IO,
-	.migratepage	= buffer_migrate_page_norefs,
+	.migrate_folio	= buffer_migrate_folio_norefs,
 	.is_dirty_writeback = buffer_check_dirty_writeback,
 };
 
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 360ce3604a2d..84570c6265aa 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -973,7 +973,7 @@ const struct address_space_operations ext2_aops = {
 	.bmap			= ext2_bmap,
 	.direct_IO		= ext2_direct_IO,
 	.writepages		= ext2_writepages,
-	.migratepage		= buffer_migrate_page,
+	.migrate_folio		= buffer_migrate_folio,
 	.is_partially_uptodate	= block_is_partially_uptodate,
 	.error_remove_page	= generic_error_remove_page,
 };
@@ -989,7 +989,7 @@ const struct address_space_operations ext2_nobh_aops = {
 	.bmap			= ext2_bmap,
 	.direct_IO		= ext2_direct_IO,
 	.writepages		= ext2_writepages,
-	.migratepage		= buffer_migrate_page,
+	.migrate_folio		= buffer_migrate_folio,
 	.error_remove_page	= generic_error_remove_page,
 };
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1aaea53e67b5..53877ffe3c41 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3633,7 +3633,7 @@ static const struct address_space_operations ext4_aops = {
 	.invalidate_folio	= ext4_invalidate_folio,
 	.release_folio		= ext4_release_folio,
 	.direct_IO		= noop_direct_IO,
-	.migratepage		= buffer_migrate_page,
+	.migrate_folio		= buffer_migrate_folio,
 	.is_partially_uptodate  = block_is_partially_uptodate,
 	.error_remove_page	= generic_error_remove_page,
 	.swap_activate		= ext4_iomap_swap_activate,
@@ -3668,7 +3668,7 @@ static const struct address_space_operations ext4_da_aops = {
 	.invalidate_folio	= ext4_invalidate_folio,
 	.release_folio		= ext4_release_folio,
 	.direct_IO		= noop_direct_IO,
-	.migratepage		= buffer_migrate_page,
+	.migrate_folio		= buffer_migrate_folio,
 	.is_partially_uptodate  = block_is_partially_uptodate,
 	.error_remove_page	= generic_error_remove_page,
 	.swap_activate		= ext4_iomap_swap_activate,
diff --git a/fs/ntfs/aops.c b/fs/ntfs/aops.c
index 9e3964ea2ea0..5f4fb6ca6f2e 100644
--- a/fs/ntfs/aops.c
+++ b/fs/ntfs/aops.c
@@ -1659,7 +1659,7 @@ const struct address_space_operations ntfs_normal_aops = {
 	.dirty_folio	= block_dirty_folio,
 #endif /* NTFS_RW */
 	.bmap		= ntfs_bmap,
-	.migratepage	= buffer_migrate_page,
+	.migrate_folio	= buffer_migrate_folio,
 	.is_partially_uptodate = block_is_partially_uptodate,
 	.error_remove_page = generic_error_remove_page,
 };
@@ -1673,7 +1673,7 @@ const struct address_space_operations ntfs_compressed_aops = {
 	.writepage	= ntfs_writepage,
 	.dirty_folio	= block_dirty_folio,
 #endif /* NTFS_RW */
-	.migratepage	= buffer_migrate_page,
+	.migrate_folio	= buffer_migrate_folio,
 	.is_partially_uptodate = block_is_partially_uptodate,
 	.error_remove_page = generic_error_remove_page,
 };
@@ -1688,7 +1688,7 @@ const struct address_space_operations ntfs_mst_aops = {
 	.writepage	= ntfs_writepage,	/* Write dirty page to disk. */
 	.dirty_folio	= filemap_dirty_folio,
 #endif /* NTFS_RW */
-	.migratepage	= buffer_migrate_page,
+	.migrate_folio	= buffer_migrate_folio,
 	.is_partially_uptodate	= block_is_partially_uptodate,
 	.error_remove_page = generic_error_remove_page,
 };
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 767df51f8657..1d489003f99d 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -2462,7 +2462,7 @@ const struct address_space_operations ocfs2_aops = {
 	.direct_IO		= ocfs2_direct_IO,
 	.invalidate_folio	= block_invalidate_folio,
 	.release_folio		= ocfs2_release_folio,
-	.migratepage		= buffer_migrate_page,
+	.migrate_folio		= buffer_migrate_folio,
 	.is_partially_uptodate	= block_is_partially_uptodate,
 	.error_remove_page	= generic_error_remove_page,
 };
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index c9d1463bb20f..b0366c89d6a4 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -267,6 +267,16 @@ int nobh_truncate_page(struct address_space *, loff_t, get_block_t *);
 int nobh_writepage(struct page *page, get_block_t *get_block,
                         struct writeback_control *wbc);
 
+#ifdef CONFIG_MIGRATION
+extern int buffer_migrate_folio(struct address_space *,
+		struct folio *dst, struct folio *src, enum migrate_mode);
+extern int buffer_migrate_folio_norefs(struct address_space *,
+		struct folio *dst, struct folio *src, enum migrate_mode);
+#else
+#define buffer_migrate_folio NULL
+#define buffer_migrate_folio_norefs NULL
+#endif
+
 void buffer_init(void);
 
 /*
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 47431cf8fbb3..9e6b17da4e11 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3215,18 +3215,6 @@ extern int generic_check_addressable(unsigned, u64);
 
 extern void generic_set_encrypted_ci_d_ops(struct dentry *dentry);
 
-#ifdef CONFIG_MIGRATION
-extern int buffer_migrate_page(struct address_space *,
-				struct page *, struct page *,
-				enum migrate_mode);
-extern int buffer_migrate_page_norefs(struct address_space *,
-				struct page *, struct page *,
-				enum migrate_mode);
-#else
-#define buffer_migrate_page NULL
-#define buffer_migrate_page_norefs NULL
-#endif
-
 int may_setattr(struct user_namespace *mnt_userns, struct inode *inode,
 		unsigned int ia_valid);
 int setattr_prepare(struct user_namespace *, struct dentry *, struct iattr *);
diff --git a/mm/migrate.c b/mm/migrate.c
index 6b6fec26f4d0..2975f0c4d7cf 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -656,23 +656,23 @@ static bool buffer_migrate_lock_buffers(struct buffer_head *head,
 	return true;
 }
 
-static int __buffer_migrate_page(struct address_space *mapping,
-		struct page *newpage, struct page *page, enum migrate_mode mode,
+static int __buffer_migrate_folio(struct address_space *mapping,
+		struct folio *dst, struct folio *src, enum migrate_mode mode,
 		bool check_refs)
 {
 	struct buffer_head *bh, *head;
 	int rc;
 	int expected_count;
 
-	if (!page_has_buffers(page))
-		return migrate_page(mapping, newpage, page, mode);
+	head = folio_buffers(src);
+	if (!head)
+		return migrate_page(mapping, &dst->page, &src->page, mode);
 
 	/* Check whether page does not have extra refs before we do more work */
-	expected_count = expected_page_refs(mapping, page);
-	if (page_count(page) != expected_count)
+	expected_count = expected_page_refs(mapping, &src->page);
+	if (folio_ref_count(src) != expected_count)
 		return -EAGAIN;
 
-	head = page_buffers(page);
 	if (!buffer_migrate_lock_buffers(head, mode))
 		return -EAGAIN;
 
@@ -703,23 +703,22 @@ static int __buffer_migrate_page(struct address_space *mapping,
 		}
 	}
 
-	rc = migrate_page_move_mapping(mapping, newpage, page, 0);
+	rc = folio_migrate_mapping(mapping, dst, src, 0);
 	if (rc != MIGRATEPAGE_SUCCESS)
 		goto unlock_buffers;
 
-	attach_page_private(newpage, detach_page_private(page));
+	folio_attach_private(dst, folio_detach_private(src));
 
 	bh = head;
 	do {
-		set_bh_page(bh, newpage, bh_offset(bh));
+		set_bh_page(bh, &dst->page, bh_offset(bh));
 		bh = bh->b_this_page;
-
 	} while (bh != head);
 
 	if (mode != MIGRATE_SYNC_NO_COPY)
-		migrate_page_copy(newpage, page);
+		folio_migrate_copy(dst, src);
 	else
-		migrate_page_states(newpage, page);
+		folio_migrate_flags(dst, src);
 
 	rc = MIGRATEPAGE_SUCCESS;
 unlock_buffers:
@@ -729,34 +728,51 @@ static int __buffer_migrate_page(struct address_space *mapping,
 	do {
 		unlock_buffer(bh);
 		bh = bh->b_this_page;
-
 	} while (bh != head);
 
 	return rc;
 }
 
-/*
- * Migration function for pages with buffers. This function can only be used
- * if the underlying filesystem guarantees that no other references to "page"
- * exist. For example attached buffer heads are accessed only under page lock.
+/**
+ * buffer_migrate_folio() - Migration function for folios with buffers.
+ * @mapping: The address space containing @src.
+ * @dst: The folio to migrate to.
+ * @src: The folio to migrate from.
+ * @mode: How to migrate the folio.
+ *
+ * This function can only be used if the underlying filesystem guarantees
+ * that no other references to @src exist. For example attached buffer
+ * heads are accessed only under the folio lock.  If your filesystem cannot
+ * provide this guarantee, buffer_migrate_folio_norefs() may be more
+ * appropriate.
+ *
+ * Return: 0 on success or a negative errno on failure.
  */
-int buffer_migrate_page(struct address_space *mapping,
-		struct page *newpage, struct page *page, enum migrate_mode mode)
+int buffer_migrate_folio(struct address_space *mapping,
+		struct folio *dst, struct folio *src, enum migrate_mode mode)
 {
-	return __buffer_migrate_page(mapping, newpage, page, mode, false);
+	return __buffer_migrate_folio(mapping, dst, src, mode, false);
 }
-EXPORT_SYMBOL(buffer_migrate_page);
+EXPORT_SYMBOL(buffer_migrate_folio);
 
-/*
- * Same as above except that this variant is more careful and checks that there
- * are also no buffer head references. This function is the right one for
- * mappings where buffer heads are directly looked up and referenced (such as
- * block device mappings).
+/**
+ * buffer_migrate_folio_norefs() - Migration function for folios with buffers.
+ * @mapping: The address space containing @src.
+ * @dst: The folio to migrate to.
+ * @src: The folio to migrate from.
+ * @mode: How to migrate the folio.
+ *
+ * Like buffer_migrate_folio() except that this variant is more careful
+ * and checks that there are also no buffer head references. This function
+ * is the right one for mappings where buffer heads are directly looked
+ * up and referenced (such as block device mappings).
+ *
+ * Return: 0 on success or a negative errno on failure.
  */
-int buffer_migrate_page_norefs(struct address_space *mapping,
-		struct page *newpage, struct page *page, enum migrate_mode mode)
+int buffer_migrate_folio_norefs(struct address_space *mapping,
+		struct folio *dst, struct folio *src, enum migrate_mode mode)
 {
-	return __buffer_migrate_page(mapping, newpage, page, mode, true);
+	return __buffer_migrate_folio(mapping, dst, src, mode, true);
 }
 #endif
 
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
