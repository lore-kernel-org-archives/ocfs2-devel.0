Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 375F1CCA47B
	for <ocfs2-devel@archiver.kernel.org>; Wed,  8 Jun 2022 15:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=iO6MEkXy5EVe2q2O9h1aId3LZSXxjBv2zmYw315hpWw=;
 b=TN0C+/Pt1UmfE7EKTbddHt6ZZoH2o6Fm2QmXCiynA75RD9BaiaSvsaqeg43R9z2P2jZ8ySIlWKjT
   sVNBhElsGG+dGngRMVQBWzakUnmq5nSvRbS4WpJN3wIbJ2Ng65Tebmmct7rm5rxh+dEvyNRj14nU
   KUr5CV8492wijhYTa5tnjHOxEy0F0qWPXhzqOZ0ZzAFfi78DHHT2qQnErrsP61dVVPNoaZKpLU6C
   Fuef4NL8VEPxhj3By3EbaQSnXRtTf4MOA+vFiPp241LcRbnYerqnI0eG+5HRebyIsEULBgD5azf8
   jvYEiBN3CQFQG/zXvggP6GHIGL7t+iX72EQJyg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=iO6MEkXy5EVe2q2O9h1aId3LZSXxjBv2zmYw315hpWw=;
 b=JHYhfGo4iq4hBY2geU8IZwmtiZLq9AIC1jXc7UxHBN5hCCyHXGUqZy7WadjunjQN7P5ba3YLdiUo
   5QDmEkuQ7nCDstR1IAWgZjIL+N9zYFW1EL9Do5Orz6GT2Fu6BGGUJERxZaQiTtZjK0M5boezHfSx
   S8qyo3XcmVkjmuoPju9pR6JdbA/ThF6Wtw9e/0BuxuKbtvI4QdQsoVwPrapCU7tYJzvIBGBx0vzj
   uiKoY3zhXVRVbU4QEDxlIFf/BY3zOLq/TR6V4v2Rao+ZB1N69riFlEvQfd3wgHb5PxvpdO06b2pg
   naPN7QQMyX0i2BjvbsuD7atI1HLOFrShePHRDA==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD500PXGZ5Z3EE0@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 08 Jun 2022 15:03:35 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 Content-Type:Content-ID:Content-Description;
 bh=ebo5nyfkwGkX0SM0pROh1Dct7QqdSa3ZjR42/FbSW98=; b=VP4hPmud7SPFmC3bIKYlVqSBNM
 ye5qs83/sHqcoYsTLqQd+m9uMu5ak7kQqhrxPejY6kjGezj2IywtVb2KqugczyFSDrVR4wV9pSrVK
 iSf/0bC449kpqY51nqYYffjd6WE1rtpD+iRnk+HIYHGnjNZhOOroRGUq/pB0InvMW4DRxGDTxdKau
 LV1b+mg2Re0TultwkHBXglCIcQryDYl7+UF2rFc7QVpqSYJdzc0Al5iEjRY7dgk86mOekBEL9k1YS
 ihpfsRLVoOMwePjy82T+0hAWr4N6/fZmtc9OYicZTzmrFQgTMbaOM2r5zfKDW1WGYyLJ19faZbb2i
 WKGEyvZA==;
To: linux-fsdevel@vger.kernel.org
Date: Wed,  8 Jun 2022 16:02:33 +0100
Message-id: <20220608150249.3033815-4-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220608150249.3033815-1-willy@infradead.org>
References: <20220608150249.3033815-1-willy@infradead.org>
MIME-version: 1.0
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10372
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 mlxlogscore=634 spamscore=0 adultscore=0 clxscore=163
 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0 priorityscore=220
 mlxscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206080064 domainage_hfrom=8380
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-ext4@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH v2 03/19] fs: Add aops->migrate_folio
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
X-Proofpoint-GUID: ivwtHS9q2itZfJgjoACNrs28MqWNbt-U
X-Proofpoint-ORIG-GUID: ivwtHS9q2itZfJgjoACNrs28MqWNbt-U
Reporting-Meta:
 AAGV/xBgEY8U4jnG7Ct5344KLVN0JMtnuEc5OFM0Kzdr7qgh3YAVTHZFE/CW/Iea
 lIM0zAdL1PRZbe8tWPie5JOC5PzoJWhwk5wHrmOAkywKCCl1+jSYlH/PQIX8p8df
 S6ukctEg8L7muZ3nbTfpYLXF+8CLKzwW/TnI0/IdVg8r7hklan7Iw+C54U7TpPtZ
 RjKuAs05Hu8f6k67h0TBPQ/Clk3cFhq6R/a62xooureVTLZNvBmYNZKC49IVAay7
 UC+6RJkGpGR/eCwWl1xtgSGSbHXycb47QP+Nin5TwjXiGT1oI8aQHSt6qoPvIzmq
 SWuW68usgGn1yoDwf1455weJ/5byrEFLnzsdxtsMaALpi5GfSko6+2GG2V15hWps
 /URvlOF/2t5Wr+qj4oXIBK9kL7Xpq1QvKKJYnuQ1QxN67bQG0eXATzCQ4gi1z9j4
 rO7xyiB1cSrzrvwuSGmLHA6BjN3vqrX2pCo4bvTFskWvWsMZJuPEwJ995xYmQmFe
 dB0VoME5qPrS+tdxzfBlRzhnFQ0BiOTTuOl5Co0WFDE=

Provide a folio-based replacement for aops->migratepage.  Update the
documentation to document migrate_folio instead of migratepage.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/filesystems/locking.rst |  5 ++--
 Documentation/filesystems/vfs.rst     | 13 ++++++-----
 Documentation/vm/page_migration.rst   | 33 ++++++++++++++-------------
 include/linux/fs.h                    |  4 +++-
 mm/compaction.c                       |  4 +++-
 mm/migrate.c                          | 11 +++++----
 6 files changed, 40 insertions(+), 30 deletions(-)

diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
index c0fe711f14d3..3d28b23676bd 100644
--- a/Documentation/filesystems/locking.rst
+++ b/Documentation/filesystems/locking.rst
@@ -253,7 +253,8 @@ prototypes::
 	void (*free_folio)(struct folio *);
 	int (*direct_IO)(struct kiocb *, struct iov_iter *iter);
 	bool (*isolate_page) (struct page *, isolate_mode_t);
-	int (*migratepage)(struct address_space *, struct page *, struct page *);
+	int (*migrate_folio)(struct address_space *, struct folio *dst,
+			struct folio *src, enum migrate_mode);
 	void (*putback_page) (struct page *);
 	int (*launder_folio)(struct folio *);
 	bool (*is_partially_uptodate)(struct folio *, size_t from, size_t count);
@@ -281,7 +282,7 @@ release_folio:		yes
 free_folio:		yes
 direct_IO:
 isolate_page:		yes
-migratepage:		yes (both)
+migrate_folio:		yes (both)
 putback_page:		yes
 launder_folio:		yes
 is_partially_uptodate:	yes
diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
index a08c652467d7..3ae1b039b03f 100644
--- a/Documentation/filesystems/vfs.rst
+++ b/Documentation/filesystems/vfs.rst
@@ -740,7 +740,8 @@ cache in your filesystem.  The following members are defined:
 		/* isolate a page for migration */
 		bool (*isolate_page) (struct page *, isolate_mode_t);
 		/* migrate the contents of a page to the specified target */
-		int (*migratepage) (struct page *, struct page *);
+		int (*migrate_folio)(struct mapping *, struct folio *dst,
+				struct folio *src, enum migrate_mode);
 		/* put migration-failed page back to right list */
 		void (*putback_page) (struct page *);
 		int (*launder_folio) (struct folio *);
@@ -935,12 +936,12 @@ cache in your filesystem.  The following members are defined:
 	is successfully isolated, VM marks the page as PG_isolated via
 	__SetPageIsolated.
 
-``migrate_page``
+``migrate_folio``
 	This is used to compact the physical memory usage.  If the VM
-	wants to relocate a page (maybe off a memory card that is
-	signalling imminent failure) it will pass a new page and an old
-	page to this function.  migrate_page should transfer any private
-	data across and update any references that it has to the page.
+	wants to relocate a folio (maybe from a memory device that is
+	signalling imminent failure) it will pass a new folio and an old
+	folio to this function.  migrate_folio should transfer any private
+	data across and update any references that it has to the folio.
 
 ``putback_page``
 	Called by the VM when isolated page's migration fails.
diff --git a/Documentation/vm/page_migration.rst b/Documentation/vm/page_migration.rst
index 8c5cb8147e55..e0f73ddfabb1 100644
--- a/Documentation/vm/page_migration.rst
+++ b/Documentation/vm/page_migration.rst
@@ -181,22 +181,23 @@ which are function pointers of struct address_space_operations.
    Once page is successfully isolated, VM uses page.lru fields so driver
    shouldn't expect to preserve values in those fields.
 
-2. ``int (*migratepage) (struct address_space *mapping,``
-|	``struct page *newpage, struct page *oldpage, enum migrate_mode);``
-
-   After isolation, VM calls migratepage() of driver with the isolated page.
-   The function of migratepage() is to move the contents of the old page to the
-   new page
-   and set up fields of struct page newpage. Keep in mind that you should
-   indicate to the VM the oldpage is no longer movable via __ClearPageMovable()
-   under page_lock if you migrated the oldpage successfully and returned
-   MIGRATEPAGE_SUCCESS. If driver cannot migrate the page at the moment, driver
-   can return -EAGAIN. On -EAGAIN, VM will retry page migration in a short time
-   because VM interprets -EAGAIN as "temporary migration failure". On returning
-   any error except -EAGAIN, VM will give up the page migration without
-   retrying.
-
-   Driver shouldn't touch the page.lru field while in the migratepage() function.
+2. ``int (*migrate_folio) (struct address_space *mapping,``
+|	``struct folio *dst, struct folio *src, enum migrate_mode);``
+
+   After isolation, VM calls the driver's migrate_folio() with the
+   isolated folio.  The purpose of migrate_folio() is to move the contents
+   of the source folio to the destination folio and set up the fields
+   of destination folio.  Keep in mind that you should indicate to the
+   VM the source folio is no longer movable via __ClearPageMovable()
+   under folio if you migrated the source successfully and returned
+   MIGRATEPAGE_SUCCESS.  If driver cannot migrate the folio at the
+   moment, driver can return -EAGAIN. On -EAGAIN, VM will retry folio
+   migration in a short time because VM interprets -EAGAIN as "temporary
+   migration failure".  On returning any error except -EAGAIN, VM will
+   give up the folio migration without retrying.
+
+   Driver shouldn't touch the folio.lru field while in the migrate_folio()
+   function.
 
 3. ``void (*putback_page)(struct page *);``
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 5d8ee3155ca2..47431cf8fbb3 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -362,9 +362,11 @@ struct address_space_operations {
 	void (*free_folio)(struct folio *folio);
 	ssize_t (*direct_IO)(struct kiocb *, struct iov_iter *iter);
 	/*
-	 * migrate the contents of a page to the specified target. If
+	 * migrate the contents of a folio to the specified target. If
 	 * migrate_mode is MIGRATE_ASYNC, it must not block.
 	 */
+	int (*migrate_folio)(struct address_space *, struct folio *dst,
+			struct folio *src, enum migrate_mode);
 	int (*migratepage) (struct address_space *,
 			struct page *, struct page *, enum migrate_mode);
 	int (*launder_folio)(struct folio *);
diff --git a/mm/compaction.c b/mm/compaction.c
index f23efba1d118..458f49f9ab09 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1042,7 +1042,9 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 				goto isolate_fail_put;
 
 			mapping = page_mapping(page);
-			migrate_dirty = !mapping || mapping->a_ops->migratepage;
+			migrate_dirty = !mapping ||
+					mapping->a_ops->migrate_folio ||
+					mapping->a_ops->migratepage;
 			unlock_page(page);
 			if (!migrate_dirty)
 				goto isolate_fail_put;
diff --git a/mm/migrate.c b/mm/migrate.c
index 3ce6fee87efa..e064b998ead0 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -856,14 +856,17 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
 
 		if (!mapping)
 			rc = migrate_page(mapping, &dst->page, &src->page, mode);
-		else if (mapping->a_ops->migratepage)
+		else if (mapping->a_ops->migrate_folio)
 			/*
-			 * Most pages have a mapping and most filesystems
-			 * provide a migratepage callback. Anonymous pages
+			 * Most folios have a mapping and most filesystems
+			 * provide a migrate_folio callback. Anonymous folios
 			 * are part of swap space which also has its own
-			 * migratepage callback. This is the most common path
+			 * migrate_folio callback. This is the most common path
 			 * for page migration.
 			 */
+			rc = mapping->a_ops->migrate_folio(mapping, dst, src,
+								mode);
+		else if (mapping->a_ops->migratepage)
 			rc = mapping->a_ops->migratepage(mapping, &dst->page,
 							&src->page, mode);
 		else
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
