Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01092CCA485
	for <ocfs2-devel@archiver.kernel.org>; Mon,  6 Jun 2022 20:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ufj5svfC2INUMvENyYAqqd/TM8uJgDXbzIMnYpSNakk=;
 b=Aw/hQS3HM4p3TXCeyMpXwH6Mcomyxk1ECTuEsBGZCdbf7WYgd0M1/EdJ+YKmOYh+S6mjWaobNKec
   a/mulV2/hqIwpV/pbGUgF0jGQ6Fq2wwqaa2lWxQxrZ3W9kL29M8mPJ9HsmnFFnWZw0fHRI6SIJhn
   wFVlnV3DocooJ0Ka7CMsktzL/QhE4lHfAocM7OmiasEhid7pnMRkem7CASYBHftXwBAib+hwPSwi
   GhaFbaOyFxG00k2Ta/0LUpREG7SeKsvp2R/HRTOY81/FNKRrcyuAC9weuqiDOmOMz4DQ+UqOgTwu
   CVvSvXB8+cVKua8UnSTUE0JN5eJXj3geOk2G3Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ufj5svfC2INUMvENyYAqqd/TM8uJgDXbzIMnYpSNakk=;
 b=T2a06S4xO4TnAQ38Gb+qGhO8U7wMEDhvdNuR730yQumPhV6/QNfMw+QhhY+uw7j2OWBUBgoOzYz+
   mI6f0ZImcV69r6xTNbjXzET9AN0dqc0ZqShqc11HBHJEIXOHtee3v1+PcUqnwuPFSVjxWm3jHGiB
   P0gR0dhC58mPfROLVvVUcUw9BiNHHjRTU/b5KdNOaEPxfnVt7tQSEe3WkUiUce0tXedLM5NYrorA
   B6qo+gUWi9o+oZ2fLdC0+vIIdSjC1KgUOVwKjKTYD2Fb/u+SIQnVkd8U48uVdv7AGnqIbwKJNGra
   oEJ8hJF4cSxSDnSetSoIrwnZj3wpAUTrPQ9tVg==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD2002EYPGUOU30@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 06 Jun 2022 20:41:18 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 Content-Type:Content-ID:Content-Description;
 bh=6sny7mgbMzuLsgsgFN8vZ/E7WcZlP1DaRKRtHbfX8Jw=; b=ukaURbWCm8w3KS3KzoVJUL3FxY
 wPlS18+1fh2iCVNChPqRPFTRbEAtlGq0XwMOhU5vLgXypaXzfZHPQHZ1bZ4aQLr6Cu5P4yx0Kxma8
 0yqfDFojKiDMNDRg/HtYwsxO/5Fhsv16i+mFYNs6xr/xrTZFC/MBisglBy5L4jIm9MB5Kv2FAVqXV
 XxvToTCQvDD1XlfJcZCtmPoTaDK39ctCmCZdLVOEq8NDfk4AFr30qp2hJ/HL+HMnFTZ0pIgzaZ1s1
 wQ/JRTi1nkJymMfIe48lYeHhHid1CC1P28h0uKjey4WY0qpcZHqgqc7fRJ3/TEyvZHuwFjaV+eKj3
 1m9LeW5g==;
To: linux-fsdevel@vger.kernel.org
Date: Mon,  6 Jun 2022 21:40:42 +0100
Message-id: <20220606204050.2625949-13-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220606204050.2625949-1-willy@infradead.org>
References: <20220606204050.2625949-1-willy@infradead.org>
MIME-version: 1.0
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10370
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 clxscore=163 impostorscore=0 adultscore=0 priorityscore=108 bulkscore=0
 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=577 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206060082 domainage_hfrom=8378
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-ext4@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH 12/20] f2fs: Convert to filemap_migrate_folio()
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
X-Proofpoint-ORIG-GUID: rBwquFiPGKp1XSfInh8SnVji7IdweOHK
X-Proofpoint-GUID: rBwquFiPGKp1XSfInh8SnVji7IdweOHK
Reporting-Meta:
 AAEdPrqLCFY7r7G7k3NOnXgTLFDvRMAkJOj1nNWRtdVINk8yzveq8HATThCmR31P
 UbzSuoRVU9OmERKNBKor7IvldrBUJzFw2sYtQ7LHu0qH3vy5dn/o6iElQua9nTjT
 60kS3MMiSNVySLSSySUKnJ9M2PVdgSL2DkMWnpLz8BHrkjKTbMUdXi2JqMDL5HO7
 zJr95DsRpIGeld4PzXT7IprgvvBAytbQDWFrSDXfIF+8l9gsiUK5PN27IuocTNl4
 3jntqDt+iqqfdXHqsqIkJ0g4TTMOZhwai/bD6iYsvhjzXHdyVXqrJH3iXXp+vlW+
 tnehzavsnQZLcBovja3gu7QhWrUR1Aaw360+Jk8ALRhDZr84CaxjYFL6fT4c4nk6
 eZgbsQimI13CS7IoOElZH94R9YV8y4YYEdopVapg738LkaJjIf/yIa9F0FiIRKZe
 M68gJjrE1kBirYG1j9eyWJvxojyeXSP1lmMg0MImhELBZ46Uwvqo5HLijPcCah98
 WWRr73aiGnctqrXQeuhorhneP1DYLN1rwDTv6bGtJZ22

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
