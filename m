Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc246.phx1.oracleemaildelivery.com (aib29ajc246.phx1.oracleemaildelivery.com [192.29.103.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5405C76196
	for <ocfs2-devel@archiver.kernel.org>; Tue, 28 Mar 2023 23:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=4rSESCZ2hQLIxCp+JAqV+IxmFrob1yI8BC40O+M9hu0=;
 b=nRLSrDQj4l4duSY4MWaiq97Gy1tiTVgQIgo7svodEeSwLRUkKSyMblVx7GHLvRtKKr6SEFuzd6rW
   EcpXBAfhSBG3Rgdkrpd0XXpU/9YqjSu6i069gwMJBRdrlzG2XDtl+/vcmT3ZcVHM0AxBDG7EieYu
   0f2PASts4DZQFZNAk/Ylt8LxR06HnSJJNxtKfsKlTiAHx+Bny+5x9EItJnaFPgtMBw/Fw7CdTeKh
   ExMQaDtjRiUbgLwEm45VlrAkOtqriVixudAHC4buYD0aCr2SqnmphOB9HW9OPUTOtKcs0V3u+lTs
   IIcqKORH5mSPjZ9VWrp1Gf9Jl5G2ITXOPi8onQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=4rSESCZ2hQLIxCp+JAqV+IxmFrob1yI8BC40O+M9hu0=;
 b=oSTpW4sNKh6xxhjYfE4lTkuHSsULnsFMBRIyeM+l/9QBRV2ujTUbiJ/n/dvSY7mjwUsrcQaZDPO4
   8Y1lzYdMLbmQxYJNi9jhIhXvO+8HI3n4i/jjHKCw6IjYMNwl98vG/y2Wa57xMzJLq0k/DHlQn8i3
   W5TzcAeUD8JrWV38wlqlVFdzceImhzv6R6egFJHLMtb2BImEUByUO2hCYVZoe8SKNxo9JEui5coz
   uBxw4mv//+30Re4jkPHfAOqYL62PB1AVCTUdVoqWNxuJDnnZlB2A+Ew2pMwXQ0azzlQ0x0dMElp+
   3yRAeUElVchzDFVvGssQXxnwQeAJt/FA/FwS9Q==
Received: by omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230317 64bit (built Mar 17
 2023))
 with ESMTPS id <0RS9003NG7L1AO50@omta-ad1-fd3-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 28 Mar 2023 23:22:13 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1680045716; bh=jZQPVKOSUXvAt2kIzPdEBoxNldkAPgUL8YEkckj+EDQ=;
 h=Date:To:From:Subject:From;
 b=2HE4c2Dbs0ao5eSZsiDtenev6cqAE5ICoEE8006d0BpDozhnGkg2g6QRSL+q3k9D6
 ie1N6kt4xdBtUus0kPtkYAxK/vrOddcaXdx7NaZz/Vd6nM/6/Qi5ckAt343wyr90O1
 KYO05ZRGDd9nm83IT6/c4umg9wcY27gVYgYM7AQk=
Date: Tue, 28 Mar 2023 16:21:56 -0700
To: mm-commits@vger.kernel.org, willy@infradead.org, piaojun@huawei.com,
 ocfs2-devel@oss.oracle.com, mark@fasheh.com, junxiao.bi@oracle.com,
 joseph.qi@linux.alibaba.com, jlbec@evilplan.org, jiangqi903@gmail.com,
 jack@suse.cz, ghe@suse.com, gechangwei@live.cn, dushistov@mail.ru,
 dave.kleikamp@oracle.com, hch@lst.de, akpm@linux-foundation.org
Message-id: <20230328232156.86B1DC433D2@smtp.kernel.org>
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10663
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 adultscore=0
 bulkscore=0 priorityscore=90 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 lowpriorityscore=0 phishscore=0 impostorscore=0 clxscore=199
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303280180
Subject: [Ocfs2-devel] [merged mm-stable]
	mmjfs-move-write_one_page-folio_write_one-to-jfs.patch	removed from -mm tree
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
From: Andrew Morton via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Andrew Morton <akpm@linux-foundation.org>
MIME-version: 1.0
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:140.211.169.12/30 include:_spf.kernel.org
 include:_spf.google.com ~all
X-Spam: Clean
X-Proofpoint-GUID: 3nFW6YbxhU9-7TkYzmScsgMVc0aLSs43
X-Proofpoint-ORIG-GUID: 3nFW6YbxhU9-7TkYzmScsgMVc0aLSs43
Reporting-Meta:
 AAGkciMxu3PXCgNfcNLyNVpgE5qVhRIWS/svBwqyvHF/9U8AOhXFVBLnhzt0kKDC
 GB7aS9RYvdA6SkydASOb9nrqaSsdkIILxX4dkdW/oeu9CeRV5NHvauNGDt4nV/c6
 c76T45v9QRyOHJ1rS9tmhNnRqEWfTt7eeC6HLWoTpB5OB1FrZVskF+yXOLmmZW1F
 nKAF3K7kTjjOT2KzdzW/U7XauR167CC2ihJATCniV2dG9x0U2c9VlD8tSrqkFuR8
 KWjZH1M1RRPkzeTiE6pEb0JjPw5f+2o+3GdTzu6AdSB7N9TWPbGiVXRISTbrIC91
 c1oumx33jZ2CYFM6tlT6dLBXrXEjBsViajnUnKfU6TPKige82WSFCIpuByOpDud7
 a87qMTvOjMQQJp0F/3d18RVEiTsHC3gRU/+xD64QMj0ax1iVKdo3ErpT2WWa7MZ2
 FuaIvvLs5QaVnQP7j2ZQT+IM9aDSX70i9MAS+nUf/32i/paTs0n77YjOWXhu7gfE
 cz0PyncVcWbVJyktZqpgTtZEHBT8tDVWAl4T1QzhRXoa


The quilt patch titled
     Subject: mm,jfs: move write_one_page/folio_write_one to jfs
has been removed from the -mm tree.  Its filename was
     mmjfs-move-write_one_page-folio_write_one-to-jfs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm,jfs: move write_one_page/folio_write_one to jfs
Date: Tue, 7 Mar 2023 15:31:25 +0100

The last remaining user of folio_write_one through the write_one_page
wrapper is jfs, so move the functionality there and hard code the call to
metapage_writepage.

Note that the use of the pagecache by the JFS 'metapage' buffer cache is a
bit odd, and we could probably do without VM-level dirty tracking at all,
but that's a change for another time.

Link: https://lkml.kernel.org/r/20230307143125.27778-4-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Gang He <ghe@suse.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jan Kara via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jfs/jfs_metapage.c   |   39 ++++++++++++++++++++++++++++++++-----
 include/linux/pagemap.h |    6 -----
 mm/page-writeback.c     |   40 --------------------------------------
 3 files changed, 34 insertions(+), 51 deletions(-)

--- a/fs/jfs/jfs_metapage.c~mmjfs-move-write_one_page-folio_write_one-to-jfs
+++ a/fs/jfs/jfs_metapage.c
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
@@ -746,9 +775,9 @@ void release_metapage(struct metapage *
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
--- a/include/linux/pagemap.h~mmjfs-move-write_one_page-folio_write_one-to-jfs
+++ a/include/linux/pagemap.h
@@ -1066,12 +1066,6 @@ static inline void folio_cancel_dirty(st
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
 
--- a/mm/page-writeback.c~mmjfs-move-write_one_page-folio_write_one-to-jfs
+++ a/mm/page-writeback.c
@@ -2583,46 +2583,6 @@ int do_writepages(struct address_space *
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
_

Patches currently in -mm which might be from hch@lst.de are

mm-dont-look-at-xarray-value-entries-in-split_huge_pages_in_file.patch
mm-make-mapping_get_entry-available-outside-of-filemapc.patch
mm-use-filemap_get_entry-in-filemap_get_incore_folio.patch
shmem-open-code-the-page-cache-lookup-in-shmem_get_folio_gfp.patch
mm-remove-fgp_entry.patch
mm-return-an-err_ptr-from-__filemap_get_folio.patch
mm-return-an-err_ptr-from-__filemap_get_folio-fix.patch


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
