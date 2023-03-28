Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A73AAC77B60
	for <ocfs2-devel@archiver.kernel.org>; Tue, 28 Mar 2023 23:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=YmzGRiXwEdX2/m+WgPVbksiyZKwvvCYweXQhDh4n3qg=;
 b=tDGfo4WG90Z/d0dMn8VUJKbSMcVl5XSYVKcrcT0IL/aIZ+NjOvNTy7kFdSiFXIN0Kdai/gW/fELQ
   fWDmLgUiCvENUZu2b00xIzSDzlXbluopaXUF7FFYjhO0wAwBD8XvehlGjvJoMPbTg0QUMQDgTUw5
   WvvX459EZiYmmFTSai1m+hiK7SNe4qGJx/t0ZBWUv0ml1MTffM/DfVMJqfvQBwi1RxJp7Hw+KeJs
   2Yvb5HQ/5X4ppT2TDgyZkrjyeV5eXcHoBiTpEE2AtvxTVyIwNlNzG+Q9lcgb7Bxc2RSSU8o2PYOd
   SWsjkVs1+JeCHdAiPnDsjMFVhavd5KmFzP4Q2Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=YmzGRiXwEdX2/m+WgPVbksiyZKwvvCYweXQhDh4n3qg=;
 b=E3WADyilQLPNNE8LBPiQGiTixWYT9CVkYuIe/ppCHMQGLKYoGfET+FLEsRagzfoEuCBi+fliRTBE
   VenN74KvxpwX0k2R4uoLPFEiMDk02wSWkLW/tyAZnXthlnxQlEFNZ1Poeqo1GlEL4ecf3IuCrFb9
   nBOkpaUPkwunBDVM8nn0qiqbHqsNX/nM+Sf5f0DtSUIoo5l3oNLpjypFC/+f+Wys/BGBksq05vps
   zVIw/BqLGqVimAatMfsMk0xe4DR72N8tVUCjSrcT/5syWapIr+nTuJzvDX7jYZIsuHnFVP4tMAA7
   TMs4dUYhbHSPl7PnXCGFRQVDp9eCkRZ7In5S3g==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230317 64bit (built Mar 17
 2023))
 with ESMTPS id <0RS9006UI7KXMNC0@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 28 Mar 2023 23:22:09 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1680045713; bh=jAHx5t0Gh39f66wAp5EQbKg74n4Lsdu4IJBOkNih6pY=;
 h=Date:To:From:Subject:From;
 b=bExBHX5SIPTiRhg5lV9muTQxvTwgFnZxHZWjpDxh3hM7P0zqtELneXXesU2xCQm//
 38WL4JNJcox5c14+yGikZizF0LQo2vHmI2rtFQWWRGWrm0rbDwCgLLYpp5T+DH7AQX
 9AFV7IHgtLDH31/O4XjWTcbmHmK+uyc0L97foTnE=
Date: Tue, 28 Mar 2023 16:21:53 -0700
To: mm-commits@vger.kernel.org, willy@infradead.org, piaojun@huawei.com,
 ocfs2-devel@oss.oracle.com, mark@fasheh.com, junxiao.bi@oracle.com,
 joseph.qi@linux.alibaba.com, jlbec@evilplan.org, jiangqi903@gmail.com,
 jack@suse.cz, ghe@suse.com, gechangwei@live.cn, dushistov@mail.ru,
 dave.kleikamp@oracle.com, hch@lst.de, akpm@linux-foundation.org
Message-id: <20230328232153.9FC72C433D2@smtp.kernel.org>
X-Source-IP: 145.40.68.75
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10663
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 spamscore=0 suspectscore=0 adultscore=0 clxscore=199 lowpriorityscore=0
 priorityscore=90 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0
 mlxlogscore=968 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303280180
Subject: [Ocfs2-devel] [merged mm-stable]
	ufs-dont-flush-page-immediately-for-dirsync-directories.patch	removed from -mm
 tree
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
X-Proofpoint-GUID: FyCe_LDtbtJ4_buZL6Ibp3RR9AuXdZ98
X-Proofpoint-ORIG-GUID: FyCe_LDtbtJ4_buZL6Ibp3RR9AuXdZ98
Reporting-Meta:
 AAGtYfgx0YZHwgI721ScjAUCdyKHG3NpvT1ta1ZqNZyT2kGpnVBT/yGdUU5+hXeQ
 4AuK2jBXzFXC503gl4rayhjmeN/tKhqXKdGeh1+5tVjf2m5uSSRsfYqULhku/Qmv
 YJ8T8auzujXVO90yAUxqn/XwLzq6YDWgTlqn07mWj2t3nQgDCyxjAoZqxr7dTL3v
 eKe7FJFhFwlcrw1NSh3RAX38FlD7I4M00B04gfo9iRkH5PV+58ZS6zZIY0sgS5cM
 CeTi8HF4u+Y9X0Q9dPec2xggBRrURAjCD94YidibYQ7GBFch5+38HQ8y6JUWgJJN
 9jkYMRLrzDKtQgt/iyp3XMFJkt93Pvtcve6/JL2PU+Mfkvu2R61A3bK8Krmka/Xg
 +tQnAfmxwWjZ+16pqAc+VzaWeSsL22ken1Kz/2BaZ1kkebSnMqyBf8DXU5grvuN7
 KtOcYG4XNB1e87c8uE8YP6PHrsSatnc6DyyWp9I+GpPWQfCOejKSGmi1z1F7aFJG
 UvjcJbV1KIenOruRQCDQRcurpHtqFQqWVp/YveJeYbQSFA==


The quilt patch titled
     Subject: ufs: don't flush page immediately for DIRSYNC directories
has been removed from the -mm tree.  Its filename was
     ufs-dont-flush-page-immediately-for-dirsync-directories.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: ufs: don't flush page immediately for DIRSYNC directories
Date: Tue, 7 Mar 2023 15:31:23 +0100

Patch series "remove most callers of write_one_page", v4.

This series removes most users of the write_one_page API.  These helpers
internally call ->writepage which we are gradually removing from the
kernel.


This patch (of 3):

We do not need to writeout modified directory blocks immediately when
modifying them while the page is locked.  It is enough to do the flush
somewhat later which has the added benefit that inode times can be flushed
as well.  It also allows us to stop depending on write_one_page()
function.

Ported from an ext2 patch by Jan Kara.

Link: https://lkml.kernel.org/r/20230307143125.27778-1-hch@lst.de
Link: https://lkml.kernel.org/r/20230307143125.27778-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Jan Kara via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/dir.c |   29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

--- a/fs/ufs/dir.c~ufs-dont-flush-page-immediately-for-dirsync-directories
+++ a/fs/ufs/dir.c
@@ -42,11 +42,10 @@ static inline int ufs_match(struct super
 	return !memcmp(name, de->d_name, len);
 }
 
-static int ufs_commit_chunk(struct page *page, loff_t pos, unsigned len)
+static void ufs_commit_chunk(struct page *page, loff_t pos, unsigned len)
 {
 	struct address_space *mapping = page->mapping;
 	struct inode *dir = mapping->host;
-	int err = 0;
 
 	inode_inc_iversion(dir);
 	block_write_end(NULL, mapping, pos, len, len, page, NULL);
@@ -54,10 +53,16 @@ static int ufs_commit_chunk(struct page
 		i_size_write(dir, pos+len);
 		mark_inode_dirty(dir);
 	}
-	if (IS_DIRSYNC(dir))
-		err = write_one_page(page);
-	else
-		unlock_page(page);
+	unlock_page(page);
+}
+
+static int ufs_handle_dirsync(struct inode *dir)
+{
+	int err;
+
+	err = filemap_write_and_wait(dir->i_mapping);
+	if (!err)
+		err = sync_inode_metadata(dir, 1);
 	return err;
 }
 
@@ -99,11 +104,12 @@ void ufs_set_link(struct inode *dir, str
 	de->d_ino = cpu_to_fs32(dir->i_sb, inode->i_ino);
 	ufs_set_de_type(dir->i_sb, de, inode->i_mode);
 
-	err = ufs_commit_chunk(page, pos, len);
+	ufs_commit_chunk(page, pos, len);
 	ufs_put_page(page);
 	if (update_times)
 		dir->i_mtime = dir->i_ctime = current_time(dir);
 	mark_inode_dirty(dir);
+	ufs_handle_dirsync(dir);
 }
 
 
@@ -390,10 +396,11 @@ got_it:
 	de->d_ino = cpu_to_fs32(sb, inode->i_ino);
 	ufs_set_de_type(sb, de, inode->i_mode);
 
-	err = ufs_commit_chunk(page, pos, rec_len);
+	ufs_commit_chunk(page, pos, rec_len);
 	dir->i_mtime = dir->i_ctime = current_time(dir);
 
 	mark_inode_dirty(dir);
+	err = ufs_handle_dirsync(dir);
 	/* OFFSET_CACHE */
 out_put:
 	ufs_put_page(page);
@@ -531,9 +538,10 @@ int ufs_delete_entry(struct inode *inode
 	if (pde)
 		pde->d_reclen = cpu_to_fs16(sb, to - from);
 	dir->d_ino = 0;
-	err = ufs_commit_chunk(page, pos, to - from);
+	ufs_commit_chunk(page, pos, to - from);
 	inode->i_ctime = inode->i_mtime = current_time(inode);
 	mark_inode_dirty(inode);
+	err = ufs_handle_dirsync(inode);
 out:
 	ufs_put_page(page);
 	UFSD("EXIT\n");
@@ -579,7 +587,8 @@ int ufs_make_empty(struct inode * inode,
 	strcpy (de->d_name, "..");
 	kunmap(page);
 
-	err = ufs_commit_chunk(page, 0, chunk_size);
+	ufs_commit_chunk(page, 0, chunk_size);
+	err = ufs_handle_dirsync(inode);
 fail:
 	put_page(page);
 	return err;
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
