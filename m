Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED48DC6FD1F
	for <ocfs2-devel@archiver.kernel.org>; Tue,  7 Mar 2023 14:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=wDOaO/+eCqD3XsJSpTfChSbUkr4AQzRh6V2AFX2tgBo=;
 b=b/1rEoFaV4r6KJEVCvRt4zWI/9oA9so4XOMDSDi2EWD460labBlEaDb4tGWVTItBz2ZlkdHgH8ct
   pb63eHRNCA+4mwz2Oua1MJEnRtajegJjJfedrgsi6dLVyQcLYVNiSXLOzZjEwRla+76vbUwkrUMO
   ez/G6l+w62DiNzCTZQDHzZDzj7KLVOVUxYVablzzGU+cNDzuAYnkrBk+ea2IFbdjSgT/3ftP2npy
   Zgl/B+0BS76md24E6k1AWfm5jEGKlHiN+38MK08OTxw2E/k/KxXz4xaJKL6lUoMvhyqYfFlwanpC
   nrqwEyc1FZjResl2+OalJoP8PHWoWt/pwEXbPg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=wDOaO/+eCqD3XsJSpTfChSbUkr4AQzRh6V2AFX2tgBo=;
 b=I1m6m10S5HUFWBZ8hs2WdETvSGTZtbhkPsNPaUvhM4qiRdQN1iSQrt92riF1vtwcl9iMQb6wYEA/
   yxz33YOW9aKb0Lf/iK0LFRI9N1DxLSyxaStrnPiO3PbE4qPKmcvbRRG4OC+abhy+kRHXrHILpBJv
   FsEyzJk3Idbfw8ksaol7KS06RWuIJdktjS+UTD64c1xqfMI0mHzOp3km6ugqA5c/31lji9Aqg2Vu
   4JFlVrObZzegdNjkPPEYKgth9KDbBTq1gpIxxPUmnzIdk07RfUKblue18lhzwgROBPCpsdKUHPkg
   7ESeHwHub3mSAeftaTSnbUt0lC+BJ8uesrDZ0w==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230214 64bit (built Feb 14
 2023))
 with ESMTPS id <0RR5006M2N1J8R50@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 07 Mar 2023 14:32:07 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=e7+CDOA4124JBRCEvFKTPsUneLuiXf/X6sOT6LF5JYU=; b=3VLrWMLIKSJjYMH4ZGWGdhRkYI
 fyOCFd3v+NtSl8hn7DOZBGlkXjhNRGKJYK1KJUbmqVvGjBXHbQ4pWxEj1Xy+AasYVTEGNLDA0nS1E
 DApI3LDqQ4EeNdTFmdhqZH8EamjAPqPF1ANyX1+LcIG+ww+EPmqmM1n0eGfjt8ypjqTWKkQcFfZI3
 29DLkn35ry7LUTKVec6PhJljXJBWoIfj05k/ZYOthsYc/5hOIyyu8WxT/F5yWqt8X/+Ba3Y6yPWgR
 d4dvdU+RHPFfWx5iVW+Me+OkDdg6zig4ymm/VKchIINJUHz6at9sFZkydHrpDJIf10pTV7LLzSWnH
 drG+kNQw==;
To: Andrew Morton <akpm@linux-foundation.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Evgeniy Dushistov <dushistov@mail.ru>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Tue,  7 Mar 2023 15:31:23 +0100
Message-id: <20230307143125.27778-2-hch@lst.de>
X-Mailer: git-send-email 2.39.1
In-reply-to: <20230307143125.27778-1-hch@lst.de>
References: <20230307143125.27778-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10642
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 priorityscore=0 mlxlogscore=341
 mlxscore=0 spamscore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0
 clxscore=262 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303070130
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH 1/3] ufs: don't flush page immediately for
	DIRSYNC directories
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
X-Proofpoint-GUID: bXHRKk61sUnsCEWUCZF119HymibfDp6l
X-Proofpoint-ORIG-GUID: bXHRKk61sUnsCEWUCZF119HymibfDp6l
Reporting-Meta:
 AAEVDElBLEcIvx6eg8v20E1sPv+UwWdUTFBg/mnLl8+kiDFa/JnHgSMIUoFYUb2P
 3ez4oz+pRr0BmP0pWphgXgWF7PvgzIp2BagpcEnw0RV4EF1RAY9Vi4UWkWlcY+VA
 7ZSK+WNN1t6tfWD7kwl/bIZnR0uERtJBK0PUB2LQ8SB09E88H1khFjWA3PAn2Ng5
 6GR5GCwiuXccaQ8ZPq6JYdsS26Wi/yroeFMyZdN0cJncz4RX7WdQVwTnykWZP86P
 1fTCqnYVVHX/68Uko+8XlV320832aqsqJ0jENjlBgqTqa3KJE6ePZ1x6C7i3J/b9
 0R23u5KsirhMbmXDGNxAVuAjNo0Xnf+ALOL6QEzNTGTaQU8W4TSe6oYTOGHmzv8p
 8OBl8yEgFya1HyJ4tZErSJRSTs9O6Anp1qBobvzX6X5Ei/iefE6bfNJk/wUF2ypt
 wwTA5Ut+PnKk1HDs76osdmRchenljcOjXRZ4R3YyedbjTjwfFxusW0xwbIixNZyg
 c8A/9pPjn5ilVIZ1qdZNXM8VrFx3+mG6k6RKrRML1cfZ

We do not need to writeout modified directory blocks immediately when
modifying them while the page is locked. It is enough to do the flush
somewhat later which has the added benefit that inode times can be
flushed as well. It also allows us to stop depending on
write_one_page() function.

Ported from an ext2 patch by Jan Kara.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/ufs/dir.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/fs/ufs/dir.c b/fs/ufs/dir.c
index 391efaf1d52897..379d75796a5ce3 100644
--- a/fs/ufs/dir.c
+++ b/fs/ufs/dir.c
@@ -42,11 +42,10 @@ static inline int ufs_match(struct super_block *sb, int len,
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
@@ -54,10 +53,16 @@ static int ufs_commit_chunk(struct page *page, loff_t pos, unsigned len)
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
 
@@ -99,11 +104,12 @@ void ufs_set_link(struct inode *dir, struct ufs_dir_entry *de,
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
 
 
@@ -390,10 +396,11 @@ int ufs_add_link(struct dentry *dentry, struct inode *inode)
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
@@ -531,9 +538,10 @@ int ufs_delete_entry(struct inode *inode, struct ufs_dir_entry *dir,
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
@@ -579,7 +587,8 @@ int ufs_make_empty(struct inode * inode, struct inode *dir)
 	strcpy (de->d_name, "..");
 	kunmap(page);
 
-	err = ufs_commit_chunk(page, 0, chunk_size);
+	ufs_commit_chunk(page, 0, chunk_size);
+	err = ufs_handle_dirsync(inode);
 fail:
 	put_page(page);
 	return err;
-- 
2.39.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
