Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59F6BC6FA99
	for <ocfs2-devel@archiver.kernel.org>; Tue,  7 Mar 2023 21:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=g9ikusNweO3x8b+i25rVjCyVCmD/v2PiGLH7cx52lLE=;
 b=jlkzB/ztaE3dE5tFLST1cSNIsXq8iUiPUV8Ctt+auC7Uthm9J1Db5xhDR1fSNLbmI28WGjpI1hgv
   IOB348TcABj4krYWHUsQiYJBuVOZrEV1eFcUlBNKp0XcwrXwFh1fD4GtpE+Upkex9DKosLrzPuCt
   +75WToqgPZE7B2N5ojdIRaTsKv/MHtDagPaPvLUqxapeofpmc8wntL5RSLiymjt+fNG64Rj1ZnaC
   VWxBqyxOYvc76uxQocsfsdZP1L3S1V9jPtwmuhhiOojzEiK07QdnC9iPFOmkGV1diTAGyVMd/7M5
   2Wy7R7nt0HJSIzsavITM42Cio4XR2FbJMggalQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=g9ikusNweO3x8b+i25rVjCyVCmD/v2PiGLH7cx52lLE=;
 b=qEcB7u26cxrnnaThqo9xSYPsemHXGtJLIH/zkwB818lX04QmKp0+X732aFbXOvFwyUdP6yTHdxs7
   erlza3uA3Pr1ISrN+fJUPxps3zR0JxYrAzuKTVk1wt0wTdQblzJApIWYgTI/9F0/ubE3DUK0sP8H
   wcX6yzRynELQPyNreHfDFYM3SrQzHsezKWLsBLDBVHABwdTuQY8dvEa4K/Ng8kElog5VDtnTGbWV
   44GB+m8YCm42nd4faB0oWpNg0jRFPk6/RtoxZ0C5P5NHGzCHXR3g2Y33lqaSAopIXkaJHBltg8aA
   Wnh8hapdzO8AXjm3D6jV7JYNB4UNlLcpST149w==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RR600AOC6TU9KE0@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 07 Mar 2023 21:39:30 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
 s=korg; t=1678225155; bh=ysFThpMEQbZoB7iDCdZm4s8DKek5/klD/j67X3ipwIc=;
 h=Date:To:From:Subject:From;
 b=VlCmVgUg5Gs7g4tFqMvQC8P6t2awNrMczNchFgPYWBgKl8q+O2/j0ppjJCEBnsP2U
 QLcIF6+nSeCht6/y53rmFg9u4tG4/UU02unrFkVVAvWayYHwYdSt2fjE7IcffIowQ5
 mOiq2zghpKVKbovJ+DlajHnF6Qf4/WtkuQU2DJhA=
Date: Tue, 07 Mar 2023 13:39:14 -0800
To: mm-commits@vger.kernel.org, willy@infradead.org, piaojun@huawei.com,
 ocfs2-devel@oss.oracle.com, mark@fasheh.com, junxiao.bi@oracle.com,
 joseph.qi@linux.alibaba.com, jlbec@evilplan.org, jiangqi903@gmail.com,
 jack@suse.cz, ghe@suse.com, gechangwei@live.cn, dushistov@mail.ru,
 dave.kleikamp@oracle.com, hch@lst.de, akpm@linux-foundation.org
Message-id: <20230307213915.1E81FC433D2@smtp.kernel.org>
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10642
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 phishscore=0
 bulkscore=0 clxscore=36 malwarescore=0 priorityscore=203 adultscore=0
 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303070192
Subject: [Ocfs2-devel] +
	ufs-dont-flush-page-immediately-for-dirsync-directories.patch	added to
 mm-unstable branch
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
X-Proofpoint-GUID: iY9KrqN-inUix69sIfwV06Q7MKUnC0f-
X-Proofpoint-ORIG-GUID: iY9KrqN-inUix69sIfwV06Q7MKUnC0f-
Reporting-Meta:
 AAGBKMT9sWQr1FefXCs2gzLAGERO+xLubRPIo62NxPcCO1al+5YbGfbOVJK52S+s
 XMRCym0g78pbRCJSXsBE+rBoWlKSmBssjkH+gZh9kG/fagDMbA6bDZxbtSXz+ZZ7
 bRoLjMu3kAofjsICqS6aCgLKSZV0SWqNTx2rL6pG+5r3lgdqT/3Sq2DqlK8sOa1b
 0jZPnugeu19pGTcvi4gx3KeUuFPrcXgSbhGabQhea+ubSmIh3+eytDGp+TRPsMSz
 iSKdVnNHfpSlSdvmqCW8zl717JY0Fl/pIbiQ5dZM66Wi7AUkC20KaQcxHXZPJLf1
 Ebp4tfjf7ioRgJ7HpGP0RZhBan6nfGXhTxg7I8qoCzdodYGrQdWdPXdTng9ZjMCs
 OL2eD7U9jYHWWYdgGG/JNd+oqwoWejBDNOu/9WLFnjIQw0mOM2k4jyiuxAYm6FdU
 kd/V2YRkozODUnRkqb36zh7wJEqwekXf0wHmjgbI5yor/3nW6/Qmawmbnlu4VDnO
 z1HwAco5KtiZynnuf4TO+wvz3OSetTmI0iCdxpi138YE


The patch titled
     Subject: ufs: don't flush page immediately for DIRSYNC directories
has been added to the -mm mm-unstable branch.  Its filename is
     ufs-dont-flush-page-immediately-for-dirsync-directories.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ufs-dont-flush-page-immediately-for-dirsync-directories.patch

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

ufs-dont-flush-page-immediately-for-dirsync-directories.patch
ocfs2-dont-use-write_one_page-in-ocfs2_duplicate_clusters_by_page.patch
mmjfs-move-write_one_page-folio_write_one-to-jfs.patch


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
