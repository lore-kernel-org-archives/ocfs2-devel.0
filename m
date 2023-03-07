Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc254.phx1.oracleemaildelivery.com (aib29ajc254.phx1.oracleemaildelivery.com [192.29.103.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58924C6FD1E
	for <ocfs2-devel@archiver.kernel.org>; Tue,  7 Mar 2023 21:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=9cJ3EzqjHi9YuMJsb6lVlwjvlAwBPMWPDGZZID9FaIQ=;
 b=C6CIF54mzpevAQEteFps88aFsZ8bs8Tr3DDpBsObES1PyVCaWFhQTRN8dYK8RbIh9IpHeMGz/v6r
   Vroxn57Upa7J9ktaZndPvaqbUk4t5Z0I9WGJvaDnDrfd0kL6VVYvKxet5DWiIhfVKdaDs8nwyEb0
   FQK0LRwEwk/RkUadMPQdGUYt3xSS13+QpeaiJqsklA2BXJWNBYUlqyd2EKfk7Z/sN/YRCksZTJaD
   WYmce97BGdnhYsQno2obbDUK41Pi59nprspTpgjIaYmW38rKUa0FsYPMD3/4al6C+hkI+XvJqvbJ
   O88FkGhik+pzm5uCrat2YhhxUVx3OCBeCKTxkg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=9cJ3EzqjHi9YuMJsb6lVlwjvlAwBPMWPDGZZID9FaIQ=;
 b=mV6NBfdQHNNM863aarRy3ucq4LsjAu7ZWfPXCpOqHxRUUcdQoKksQMaH0d5hXriGocOtFKITWebF
   EVkY+77p9xBYTbFDS09kn01r8YQb6V+QcFBBO8SrqQatJoztiTdy8aOmLoo6aRrstjsPB9/tqD59
   3NtUtiQ7xpLrBqp+kBlRtrdS5cXKu3RReqX6xiaHSArDIk2z5QUiM4H0fKohKVN97mS+xW0yK9dw
   BfEKvvE/ywaUcxBs6RYIo1uwJGTiL4yDojvrBCHoSrTNh4RTK33fdXW8H8MQULWYGqZmNCQ+biLP
   wET3NEmbqF2CEPwqgqUFMJ5ZdwzIRuXCvnwKew==
Received: by omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RR600DP06TX9NA0@omta-ad3-fd3-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 07 Mar 2023 21:39:33 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1678225159; bh=223aj6oGJCFysBjSHeoKShAB27Le3O22HuA95rwl8bw=;
 h=Date:To:From:Subject:From;
 b=AnaHp0bD7DF61DkuvZBs8ZbyGndG7l9HHkgTbTWaozQc1ZMp+zVCgjTwlw5oMPbFg
 /lUEGi9gTfyBCsJ398/Fbi0TTIWg+SWgAgCCdmKKRlQ2/n6U/PTe76qlYIZuXNu7ll
 WTObyHTfl69XMukMi8J6UdK0dpHu/wy2DoHltavg=
Date: Tue, 07 Mar 2023 13:39:18 -0800
To: mm-commits@vger.kernel.org, willy@infradead.org, piaojun@huawei.com,
 ocfs2-devel@oss.oracle.com, mark@fasheh.com, junxiao.bi@oracle.com,
 joseph.qi@linux.alibaba.com, jlbec@evilplan.org, jiangqi903@gmail.com,
 jack@suse.cz, ghe@suse.com, gechangwei@live.cn, dushistov@mail.ru,
 dave.kleikamp@oracle.com, hch@lst.de, akpm@linux-foundation.org
Message-id: <20230307213919.2C618C4339B@smtp.kernel.org>
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10642
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 mlxscore=0 suspectscore=0 bulkscore=0 priorityscore=30 malwarescore=0
 mlxlogscore=999 adultscore=0 clxscore=20 phishscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303070192
Subject: [Ocfs2-devel] +	mmjfs-move-write_one_page-folio_write_one-to-jfs.patch
 added	to mm-unstable branch
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
X-ServerName: ams.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 ip4:140.211.169.12/30 include:_spf.kernel.org
 include:_spf.google.com ~all
X-Spam: Clean
X-Proofpoint-GUID: 43OC8UwSJ4Xi4ZZYWLnY7Jl-0XjkL7o3
X-Proofpoint-ORIG-GUID: 43OC8UwSJ4Xi4ZZYWLnY7Jl-0XjkL7o3
Reporting-Meta:
 AAGVrI5tduk2hfVg00MnFoydOrvtQg+1nhas1cPeZcIWEk2hwRTu6TczsjCIPIyi
 eTZH9CkE9ae9w4EDqq7Q8aTIAx2cYOY6RocSvOQG81IM6Pis0Bm6EexnIP27WHel
 Ufq6gWTcRkgVUw84cny2TWVLD4DBocFMAbl37cBmhhjF3j7SOPF4fHsy+CUi7osd
 mERdYazhs5ETEKUuciTmuwGXsvq1eWN59kprUzHgaCInJ4RiHy0xVVUeeKU4+uUs
 bRczKcFWX9BYxZHMrCeLYfOytlcW/DonElDL3B9ZoWgBM9KiROuuNZHJ7SQiw2Zx
 E6QrK0uMpYesHq3+3hY3h6Zu0HKM9dILaqRZ8m1kIZ0oWSMqZu58jFopWReg5rnE
 MeTiuTxGkARtJuhcj5AWluGR/u+AlWihj3QDEXqPwk5nHCr6j/5tMRFQ5hQxymUO
 x+ySGlSQNbnX4xPLuzXQXpmrGHT2ZPVEnxcQaSbBK4/2z8SKaygvnckg8+ivsW4Q
 Al94N51wqYqlxY15foJ8WWXa2bLYagH4W7jOK1E2W7g=


The patch titled
     Subject: mm,jfs: move write_one_page/folio_write_one to jfs
has been added to the -mm mm-unstable branch.  Its filename is
     mmjfs-move-write_one_page-folio_write_one-to-jfs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmjfs-move-write_one_page-folio_write_one-to-jfs.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

ufs-dont-flush-page-immediately-for-dirsync-directories.patch
ocfs2-dont-use-write_one_page-in-ocfs2_duplicate_clusters_by_page.patch
mmjfs-move-write_one_page-folio_write_one-to-jfs.patch


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
