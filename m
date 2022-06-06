Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD67EC43334
	for <ocfs2-devel@archiver.kernel.org>; Mon,  6 Jun 2022 20:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=FqMaegU8esU4J4gWGo2ztjGHdixvEhcvbwtIRtlyCwk=;
 b=VP5OHT5CThkCdmjXAm3OfQWf9bGzQ9Z8EBKadrInaV7CzAFmPr2S0db+yLX5SRRKZEm1pyPaja5N
   aH+cQ0Dosl18Sa/nYIZouXAPaG1Ez4vFOW0Xx89lU8F04g+BV3/oZ5iO1vb0pwGgcNguSklP2GyO
   ZQRjL+fKBXjr+g+V1ZMU0Z4gznMj8N1ywAcYnnk6EySB4Qh1g/l2hp/Y4sWRUwSu+dPAfeUXipYO
   FjjMpVDeS7JQrALdAzc3FnSv4o+CbnlpFl/OzUQSmoserGPPCD/vmOHLgzsYSopdH8gkYMXZJlVW
   pJspPE7MQFBt+AWtNLK/o78pUSINpB07qe7odQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=FqMaegU8esU4J4gWGo2ztjGHdixvEhcvbwtIRtlyCwk=;
 b=MeERSWTV2BhUIUhjKCuTrEkj5v6LHsBayYj3LnEX5/munPn4TN+Xj9EqsvLrypiVfUsRV2sKUTaw
   cl6JxOePpSLlPqRfnM3O4fZ15p9h1T8vM8cIjSBZmCriGKky9rmGJ5lbKCqZGaXCT5SuAKXQkfbi
   5GQI9q1Ab/VvJNwQbZPM9Mm8BvdBN4vE0Ni33jk2iMeBXhMeokqL62vAVPaFtGvEit6y+fPNa9pU
   LmSUNHU7v3jSsZJOxDSalK+09LCQ40tl788UUKFwc0Cq+fYJdWVALVOJ9CVgh7Y2+aEfHPmgwUKK
   KoPwPUie46s4XDYfbIR4tNlM8O6Nu5Wn9je6CA==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220517 64bit (built May 17
 2022))
 with ESMTPS id <0RD200EZ2PGYZH90@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 06 Jun 2022 20:41:22 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
 References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
 Content-Type:Content-ID:Content-Description;
 bh=kE0e2Kem5Koy9+vslnILU6wEa1eL+hykAc5m9l3vWOk=; b=ZoXiXG9BhM3nKy91XF85EEhCmA
 x+0+yDgen/JSqUZUOVrwHT2sFkEanrz3b2SRuNhvzkelnmhYQHo3H5w/lxp1m923om6t4J7ZBUl8z
 pqKeMISVHEu+agUZTchcA5vX6IHgvtaY6xD0zwlwV/HMr83Qrrmrw9nOYpeT9HsqSYa9t3+G8ito5
 +M1oHyKTE0ou+70T4p6ln1KzUCbrPs+Utdwzu5MZlydpjTnq7ZPCSNY9IZnONucAQSNa3TpoQh/zU
 mT3rM0C0mKEd0upHPAairhB+80Ltbs64qeDsd1SFTpgmwfYyIdteGzVQaO27TBq0NroBwtsgwigi6
 jlonzS1Q==;
To: linux-fsdevel@vger.kernel.org
Date: Mon,  6 Jun 2022 21:40:31 +0100
Message-id: <20220606204050.2625949-2-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-reply-to: <20220606204050.2625949-1-willy@infradead.org>
References: <20220606204050.2625949-1-willy@infradead.org>
MIME-version: 1.0
X-Source-IP: 90.155.50.34
X-Proofpoint-Virus-Version: vendor=nai engine=6400 definitions=10370
 signatures=594849
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 clxscore=163 impostorscore=0 adultscore=0 priorityscore=108 bulkscore=0
 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=567 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206060082 domainage_hfrom=8378
Cc: linux-aio@kvack.org, linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
 linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com,
 linux-ext4@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH 01/20] fs: Add aops->migrate_folio
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
X-Proofpoint-ORIG-GUID: MWh38C5wMeLkyNCuaXxUenZq1Kd9fFB2
X-Proofpoint-GUID: MWh38C5wMeLkyNCuaXxUenZq1Kd9fFB2
Reporting-Meta:
 AAHQEyQGSzSJQNGu8bPCUMoAs4dNlMrHzztuJWhktkafkkoBvrE1ujnh/k4YV8eR
 7ywSA1cPhApfMmn2clYr4TSVj51jM5oSm2LCs8jRxGrHAVWr3qinG/qtKeLtlMiP
 s4U53ypcE6LC2Yt07P4Y5T6yWDmwxLvckHGVlPIXaYBOvUJ3f6hE9zc+5qRYEKDW
 n9ONya+AdDDcOwiIrbHA8WokV3OMHblHZuecaEjVO8r8Utjz08NLR+ZNn6W9YhN8
 KHNXvfo7lyaxqMlG5iNVTtMBoqN4CLULxgInwHfm4pnygwckSoHHDMw13oU0Z7zP
 B2TvgJi/0AJdB4scLx1czF99auQhNoIY6Iu2jHfZX39nVcY6v9LeUbeRaF7tOxc3
 /pTMOTkh8wm35dyUnhAryrptOIl2+zLczdKOaXFQVuhB85+666PeP1dtC7LpVkJA
 JTR6XTkzhyRLWgkfyT0Q5+LFF8cxOUBTqESdwp4ofufsL448xZWMfqWFje2PUEva
 D2RDAHV4wek9ofbjtJ5XLoAn7jP87zWtTwksjOX3Dpax

Provide a folio-based replacement for aops->migratepage.  Update the
documentation to document migrate_folio instead of migratepage.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 Documentation/filesystems/locking.rst |  5 ++--
 Documentation/filesystems/vfs.rst     | 13 ++++++-----
 Documentation/vm/page_migration.rst   | 33 ++++++++++++++-------------
 include/linux/fs.h                    |  4 +++-
 mm/compaction.c                       |  4 +++-
 mm/migrate.c                          | 19 ++++++++++-----
 6 files changed, 46 insertions(+), 32 deletions(-)

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
index 9ad5e3520fae..7b380fa66983 100644
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
 	bool (*isolate_page)(struct page *, isolate_mode_t);
diff --git a/mm/compaction.c b/mm/compaction.c
index 1f89b969c12b..db34b459e5d9 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1045,7 +1045,9 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
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
index e51588e95f57..75cb6aa38988 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -858,14 +858,17 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
 	if (likely(is_lru)) {
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
@@ -883,8 +886,12 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
 			goto out;
 		}
 
-		rc = mapping->a_ops->migratepage(mapping, &dst->page,
-						&src->page, mode);
+		if (mapping->a_ops->migrate_folio)
+			rc = mapping->a_ops->migrate_folio(mapping, dst, src,
+								mode);
+		else
+			rc = mapping->a_ops->migratepage(mapping, &dst->page,
+							&src->page, mode);
 		WARN_ON_ONCE(rc == MIGRATEPAGE_SUCCESS &&
 				!folio_test_isolated(src));
 	}
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
