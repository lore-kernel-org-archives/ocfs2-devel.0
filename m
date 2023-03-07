Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C455AC6FD1B
	for <ocfs2-devel@archiver.kernel.org>; Tue,  7 Mar 2023 14:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=2s5N974RdN9/bgpkkFfvcfwfKYfHQwuEfV103A4xrpk=;
 b=Fj7b4xk7+f82SJcBnoXb0VmJUZwKlXHY6S9HTw8XCvdaCG9WEzJvW3Ftvud4moKz+oyYOZBoqqRX
   Ts+BSCRQXAGkAav6FVvbEtHACBLmiuZGlopFU+cuNXj4ViaZC4qieJeKRHKKM+BTtkuzthyOc/Gw
   o+FudaUGI+6/misYX9xVn1mY3l3DI6OWvqGEYCOn3L4zocpvLOK+Lf33vvfueiUmcmvMLXnxjGgt
   y68PraNNMGg3a8/C5rCZ7aZeAqmAx9UV+f3//wmsZ4K5Tyq3+RlUxTEaiMvR05MZJXtWLp13UdgI
   7/0aZclDo3UiTyfnEJ9666bs7STnBJa7SBRbqQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=2s5N974RdN9/bgpkkFfvcfwfKYfHQwuEfV103A4xrpk=;
 b=Ex/ZtjnUPw9XE9lPVmOA2S3W/2vfQcFj6EeX52XBI+C/9xdGW13cTdtQ2/+E2KKLAeaFAuSynr5C
   EVDRQBxGWDfRWE1RJCnQlHXn1aKXDyWOmw7zchgn6QxDcj4lKWx7GBQDTOW9FadWWqor2PybPl40
   a0bC7kDF40THZkT1aG6mSpo7gB6jnYk5OgLgPudjvi1MHfL20fvngww7X3cGhew24XYMYpe2ydo1
   ZlOPeboM3oq4/QECMc3veuy5oxQz1lp66yW0ZrBlto+9jhdVmeawDgL8UX4XeDzF7N83kmrToM+j
   xlgnC1sZMMTFmv2vruSUCqCohJzFf0xJPrLIfA==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RR5006MXN1N8R50@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 07 Mar 2023 14:32:11 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=/RNkTDKS2WBrD6C+qsVR+GmNvP6pOcUw93T+SGmGsfM=; b=iZ5jSjP0MVkSxWbgvMmGMNyDiY
 nEZGs1wKSUggfMNQWTqbbozLmzTRzCQTT/191nJlNXZ9tcouXCWkhiQzifpvSxsR4ihrUG8n653l7
 ewfOkrFqodzD7GoOEn94bCbqxdckXBjWW5ru5M1f3ET5zdGtF6WLShkU0BKJrQGRCRF52RoHzYI/A
 rEJtMXGAnpHjdKyRVkKYP0N8W1OF6Vi6sKePoaJPvLFHcQRQwXIM+Luh1sLAE5vvaPEowETfjuBkK
 ecfedBlN773L+CKkxSy+/21q6SwKznlMSnzWDciWjR5G96fRQDiFR3xA+lQhUCyNpaDfsoxmut62p
 brGMjfkg==;
To: Andrew Morton <akpm@linux-foundation.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Evgeniy Dushistov <dushistov@mail.ru>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Tue,  7 Mar 2023 15:31:25 +0100
Message-id: <20230307143125.27778-4-hch@lst.de>
X-Mailer: git-send-email 2.39.1
In-reply-to: <20230307143125.27778-1-hch@lst.de>
References: <20230307143125.27778-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10642
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0
 lowpriorityscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 priorityscore=0
 clxscore=176 mlxscore=0 impostorscore=0 spamscore=0 suspectscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303070130
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 Dave Kleikamp <dave.kleikamp@oracle.com>, ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH 3/3] mm,	jfs: move write_one_page/folio_write_one
 to jfs
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
X-Proofpoint-GUID: ot3-rnT9xUb7O_oTyk8f2IC0isPXyca8
X-Proofpoint-ORIG-GUID: ot3-rnT9xUb7O_oTyk8f2IC0isPXyca8
Reporting-Meta:
 AAEOZWbl9hdtoHiKNnOV/w5r4oyy2CAkNCT6nc78TOVLkIP3A33wQtasDJ9rMefX
 iOubKy4EiKJLriORCzfVZkG1qsT54+w1ud0dMw+2dKS/K2HxFHq+gOLYTAjGenyg
 tFXGUlD0ZzbWpva096qzsebUklw9JklDgoeF5/PqU4b91dqFMXC4nx1Dg1BrhMOR
 iPltgNG7MA4b1SlgUZm7Ui12qCUmxCAM/12D0hUzOzADrl9PHZUYCNApCi9k1AsW
 k6Ywp2zlL+o/wpp6KMg9QQEnzclMdVvC2RxCOZ5aX/lYrT5KkYIwDBGegLqPhPvH
 0a0U8EGdlxz14JbIz2qSeN9gWsTwNCQb+7EKJW3Ekk1U0gn52jlGdJb/JQQHL95/
 x3xUss9Yn5RG4QN0h9hQxnvGlx66DeWYu5PmC82tAY2doIWUM/dTb//9kwFmXWSZ
 8mKSk2R+jcScA4x0dnKIRw4Kjg916AwiR60gVM0ygWgkFKL7J8hPDlb79nvI0n5b
 n8ADMSPMKuqazyTquj6LvPHNUlmLAeiFTpLhhTRu0u/G

The last remaining user of folio_write_one through the write_one_page
wrapper is jfs, so move the functionality there and hard code the
call to metapage_writepage.

Note that the use of the pagecache by the JFS 'metapage' buffer cache
is a bit odd, and we could probably do without VM-level dirty tracking
at all, but that's a change for another time.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Dave Kleikamp <dave.kleikamp@oracle.com>
---
 fs/jfs/jfs_metapage.c   | 39 ++++++++++++++++++++++++++++++++++-----
 include/linux/pagemap.h |  6 ------
 mm/page-writeback.c     | 40 ----------------------------------------
 3 files changed, 34 insertions(+), 51 deletions(-)

diff --git a/fs/jfs/jfs_metapage.c b/fs/jfs/jfs_metapage.c
index 2e8461ce74de69..961569c1115901 100644
--- a/fs/jfs/jfs_metapage.c
+++ b/fs/jfs/jfs_metapage.c
@@ -691,6 +691,35 @@ void grab_metapage(struct metapage * mp)
 	unlock_page(mp->page);
 }
 
+static int metapage_write_one(struct page *page)
+{
+	struct folio *folio = page_folio(page);
+	struct address_space *mapping = folio->mapping;
+	struct writeback_control wbc = {
+		.sync_mode = WB_SYNC_ALL,
+		.nr_to_write = folio_nr_pages(folio),
+	};
+	int ret = 0;
+
+	BUG_ON(!folio_test_locked(folio));
+
+	folio_wait_writeback(folio);
+
+	if (folio_clear_dirty_for_io(folio)) {
+		folio_get(folio);
+		ret = metapage_writepage(page, &wbc);
+		if (ret == 0)
+			folio_wait_writeback(folio);
+		folio_put(folio);
+	} else {
+		folio_unlock(folio);
+	}
+
+	if (!ret)
+		ret = filemap_check_errors(mapping);
+	return ret;
+}
+
 void force_metapage(struct metapage *mp)
 {
 	struct page *page = mp->page;
@@ -700,8 +729,8 @@ void force_metapage(struct metapage *mp)
 	get_page(page);
 	lock_page(page);
 	set_page_dirty(page);
-	if (write_one_page(page))
-		jfs_error(mp->sb, "write_one_page() failed\n");
+	if (metapage_write_one(page))
+		jfs_error(mp->sb, "metapage_write_one() failed\n");
 	clear_bit(META_forcewrite, &mp->flag);
 	put_page(page);
 }
@@ -746,9 +775,9 @@ void release_metapage(struct metapage * mp)
 		set_page_dirty(page);
 		if (test_bit(META_sync, &mp->flag)) {
 			clear_bit(META_sync, &mp->flag);
-			if (write_one_page(page))
-				jfs_error(mp->sb, "write_one_page() failed\n");
-			lock_page(page); /* write_one_page unlocks the page */
+			if (metapage_write_one(page))
+				jfs_error(mp->sb, "metapage_write_one() failed\n");
+			lock_page(page);
 		}
 	} else if (mp->lsn)	/* discard_metapage doesn't remove it */
 		remove_from_logsync(mp);
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 0acb8e1fb7afdc..853184a46411f4 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1066,12 +1066,6 @@ static inline void folio_cancel_dirty(struct folio *folio)
 bool folio_clear_dirty_for_io(struct folio *folio);
 bool clear_page_dirty_for_io(struct page *page);
 void folio_invalidate(struct folio *folio, size_t offset, size_t length);
-int __must_check folio_write_one(struct folio *folio);
-static inline int __must_check write_one_page(struct page *page)
-{
-	return folio_write_one(page_folio(page));
-}
-
 int __set_page_dirty_nobuffers(struct page *page);
 bool noop_dirty_folio(struct address_space *mapping, struct folio *folio);
 
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 516b1aa247e83f..db794399900734 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2583,46 +2583,6 @@ int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
 	return ret;
 }
 
-/**
- * folio_write_one - write out a single folio and wait on I/O.
- * @folio: The folio to write.
- *
- * The folio must be locked by the caller and will be unlocked upon return.
- *
- * Note that the mapping's AS_EIO/AS_ENOSPC flags will be cleared when this
- * function returns.
- *
- * Return: %0 on success, negative error code otherwise
- */
-int folio_write_one(struct folio *folio)
-{
-	struct address_space *mapping = folio->mapping;
-	int ret = 0;
-	struct writeback_control wbc = {
-		.sync_mode = WB_SYNC_ALL,
-		.nr_to_write = folio_nr_pages(folio),
-	};
-
-	BUG_ON(!folio_test_locked(folio));
-
-	folio_wait_writeback(folio);
-
-	if (folio_clear_dirty_for_io(folio)) {
-		folio_get(folio);
-		ret = mapping->a_ops->writepage(&folio->page, &wbc);
-		if (ret == 0)
-			folio_wait_writeback(folio);
-		folio_put(folio);
-	} else {
-		folio_unlock(folio);
-	}
-
-	if (!ret)
-		ret = filemap_check_errors(mapping);
-	return ret;
-}
-EXPORT_SYMBOL(folio_write_one);
-
 /*
  * For address_spaces which do not use buffers nor write back.
  */
-- 
2.39.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
