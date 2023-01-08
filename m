Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D167CC63797
	for <ocfs2-devel@archiver.kernel.org>; Sun,  8 Jan 2023 16:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=a41aF9AGuYyiJkKxi5F2xDPcOkTvqOZsoj7JW1cWO2M=;
 b=K1EZJ5AX24rnHDh6DwgcDU5RSXQWsBE34d8IHi8oJ6R5LeMUrL+5Zznvt1PN00gxPNRJdgrDy/NM
   OkHV17Lf35W5RtF/nr7Fk1J33daedqR2JrEh8xlUE5tGXZafLYaK59G9XqueIcQMgLvxUJPywGh+
   3ZGYzTr1gw9VbhplLjngZCAHi3hbwLcZVG67x3mhVrcRjuG+ynN0F6wEdg3uUcBT6uJS5+RJvmgf
   +U/OS1difxAvNt80yaezyn0Knx3NTmG75WWkEMLxG+fLKrupbF1RThRrBjWye3ZC8+Jp4HRdjS6D
   6cdYiVfMO16pRtqT7v8hZdLRsEoKj7XsNyKPsQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=a41aF9AGuYyiJkKxi5F2xDPcOkTvqOZsoj7JW1cWO2M=;
 b=gsK0omyvG2so1goNOdFjQ6suXsmFZS8to9QNQGXbAlgb5RUMVKmJE/3KupxpQZQFzKPq7nUSAyBI
   /lcJbbU6Edl1CI1q9arMn9xg1yw0ZMtjxZULr1p9m9YDpRabdFC0qMziFedgSOoF/daSLI/R+rbS
   1RP1woOoTO99LeW4oVItEMaT/z8qFFepF/c8WBqn5maD7GbDfukMRCNqLtFc3ZiQWO2I4CHhG4Go
   rh0hctzWbswotGJWGk0ehEw0JanXOH+wuJYlUFI2ns5AqnCv6UxZmlk965C5Heo+B1v8FiiYDsfG
   y7fVINztcNd+cWwUBapo9bnfXNyYACza7M4hyQ==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0RO600L50F3YMCF0@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 08 Jan 2023 16:57:34 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=35W1DfUpdKcvHvkmZd/iv7iohwTShFaTRVBTVeGN8KQ=; b=ptbBbqyy8J9QwzNlwXFf0pVSC9
 FObnajdrui3AnmwdcRqx7yS108dlZjq/LA1FcxnBsuCPU71ZtX9OCCm2Jm8xGwS0YPhXrtKcMGdZQ
 aKbo16bAYFtfrmPEZ3n7MYwDAGEsyygCRN2tTqfvEQyxzZbYdOUzQfkdu8aQI8Yd/qSaCa4uRm3v1
 A3aIxTvDqqrWc1GXgBRTfAWdjWi5FuMdOZZqzsr6BcukKQjm8ah9DRASE27rB0bk3R/hAO7T3QdKg
 jVUW5uVfr+iTFuvvy2ys19Nhv6xvcopqJwiQPvNINiTvL/wDHu+DlU8jvFyW2hJ7jgs+Q1PXdu5Qt
 qDlB/z8A==;
To: Andrew Morton <akpm@linux-foundation.org>, Chris Mason <clm@fb.com>,
 Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
 Dave Kleikamp <shaggy@kernel.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Evgeniy Dushistov <dushistov@mail.ru>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Sun,  8 Jan 2023 17:56:45 +0100
Message-id: <20230108165645.381077-8-hch@lst.de>
X-Mailer: git-send-email 2.35.1
In-reply-to: <20230108165645.381077-1-hch@lst.de>
References: <20230108165645.381077-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10584
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 spamscore=0 lowpriorityscore=0 mlxscore=0 priorityscore=60 malwarescore=0
 phishscore=0 suspectscore=0 impostorscore=0 mlxlogscore=796 adultscore=0
 clxscore=302 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301080126
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 jfs-discussion@lists.sourceforge.net, ocfs2-devel@oss.oracle.com,
 linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH 7/7] mm,	jfs: move write_one_page/folio_write_one
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
X-Proofpoint-GUID: l2FLspSij0-wXf0gmGbqk3zidtmInvHn
X-Proofpoint-ORIG-GUID: l2FLspSij0-wXf0gmGbqk3zidtmInvHn
Reporting-Meta:
 AAEmc7Up1U1ofCmH4xYCdlLaPjAFSVIqTy+Vx4hAI3MjUo2Z+9Zw8/xIHJTyF3gD
 7CHuylDhACd1HrgCR/OTFWa8+a0DJHWLa4QWx7Hj3toQIv7qVm/UB3N+OnfIrmaK
 2H4VVMepumNxWt9RL0xoxyZFx2/+Q6Ah2DGGNTpuwB1BbNCYGAP7RWEOeN4Hwe2t
 1ui0K8PaUAwiY2nA/2xeGIdofNJ+r58oVKFeYBTCpPLrab6+1bWG3vT3ub0tVact
 QFV77ftVE8+6odLwswhf6guK4FmUWHO69xmi3SqGNb2I9QDfKqpRfIeTZlbx9MYm
 99BmPDs3IfSDBEjvDaPvcMopoNSTqRTyNHTMvWQhDW5dqHrj7NdWMI/D084FHHOk
 q2kNO0ueEesqu6vLSvWa6H0QQ3lV/+GfylP2C0AodtcSPK7RIUaKtf1gYtCRVDXu
 dt+YQ5/n1Fe4K/L1li4fQL8ZL6V/CuO6040w0DuclcodrPmYelwDone/gd6Kngh3
 HofWeYofeHSxhLHaTx7c06unnV3L66BBe08K9Qoh+N8=

The last remaining user of folio_write_one through the write_one_page
wrapper is jfs, so move the functionality there and hard code the
call to metapage_writepage.

Note that the use of the pagecache by the jfs 'metapage' buffer cache
is a bit odd, and we could probably do without VM-level dirty tracking
at all, but that's a change for another time.

Signed-off-by: Christoph Hellwig <hch@lst.de>
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
index 29e1f9e76eb6dd..4b3a7124c76712 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1062,12 +1062,6 @@ static inline void folio_cancel_dirty(struct folio *folio)
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
index dfeeceebba0ae0..2430fd09607742 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2581,46 +2581,6 @@ int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
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
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
