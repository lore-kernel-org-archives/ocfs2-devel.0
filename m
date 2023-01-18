Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 465A9C678D6
	for <ocfs2-devel@archiver.kernel.org>; Wed, 18 Jan 2023 17:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=BFKHqQxdouWxcT+IpZ9iu/mIXvx/WLBwuejRKD/oK0c=;
 b=z0oTVi3MWP1QTS0300auz+xcgPnQ+b5tvc9qS8ksFdK/IZ7NX8dHxQAWAvaRsNbec7nH0Y1W8zof
   p6tXMhG7Tv72XjGQfqgoXMNvF5cYAMzTAVQxxMw1K718Anyl/MMIsXH8J7psTdM8hg05KAUP6Bbv
   BiG09T1XgvxRP8Uf09aQMgYGRcZ+gc+rzLN+S2v+JNMEIscQfGR2Yy6ZIFmDcLmQ2th5D/vPymOW
   v7g5KsN69607fdSa3XeOQt02eelriDhKRYS2ivbUJXYrHC6b6PGNVO9p4IPtnjsMZnGALpmcvfIK
   aza2mRhIcgdOlmhX1VnlZ+/Q0PzZv+B5759sjA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=BFKHqQxdouWxcT+IpZ9iu/mIXvx/WLBwuejRKD/oK0c=;
 b=NMUe4Ldf52n9KU4ejBBe9iHUmwprqt0Rt/nyeySZDDAI1o1YrtGfRcH2g5V2lT1DlSux0/8gKmmC
   9RoNEP3VhhQcXxgyHTAC+vYuUGJKdDgQdbGpy5o+hfPOJpPNRgFxVho63gMVC/MGJKBJDOUGpd2O
   C9f7AVjDUddnvyH4i/pMDbKNFIR0sBmUccNz7PuipGHTpHPGd160D74lpkYYFTO9voqNxO3lIgE9
   Uq1+RFOQzLy4u4ZGrX3a4V/qkI/toTPgbrYrtKM+wBudP8o4fB24SBTROGbUiadu+IBQ+usZmob5
   Wx7FYCC/DEVPErdYLHbcvoV2T5PLszA+ttiPQA==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0ROO00DOHZBTD170@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 18 Jan 2023 17:31:05 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=BoUmolxcC4WWev3Bomon8s2I6PcBF6tpLGBKR42OIV8=; b=ZQCLvKpSD0KCAbbeXHpyfp33/6
 qx0a/KrfAFDWErK41OUDp0S+BSBMCboHO/UrxmMoAIzr7RofHT8nUn9Z0cYLsDia4oBqBcxHsEsHn
 DgtNTzw6mUh3h1qKIMi1ccvVMnNrnywN2365w7y0YciLh0/5mUI7c5mAAgggpDJlVo+a2gYS6j5gf
 HQzin5r1Wvq09X86pLvUuXLWnxta7uxx9qHcpSS3UDz48bByC9KuOuV8pfOh+heFHaBsutGEMTzsQ
 vOflyNklFdlV19i73Z1dwLI408NnZpyVftwfyeJ2kdNGM7wV4We11Q58QrO+8b3qIuK5wmELaRtd5
 YdSZhIIA==;
To: Andrew Morton <akpm@linux-foundation.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Evgeniy Dushistov <dushistov@mail.ru>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Wed, 18 Jan 2023 18:30:24 +0100
Message-id: <20230118173027.294869-5-hch@lst.de>
X-Mailer: git-send-email 2.39.0
In-reply-to: <20230118173027.294869-1-hch@lst.de>
References: <20230118173027.294869-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10594
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 bulkscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 mlxlogscore=488 clxscore=181 malwarescore=0 phishscore=0 priorityscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301180148
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH 4/7] minix: don't flush page immediately for
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
X-Proofpoint-GUID: xaigb9Uu7yS6EHsVX4CTe04UV2m4irEa
X-Proofpoint-ORIG-GUID: xaigb9Uu7yS6EHsVX4CTe04UV2m4irEa
Reporting-Meta:
 AAFtBdav8nJZ6QjCjUiBH/XplsIlh2RbNxr1pPaJHEKe2nZVRzJFILtEg8KQmWk5
 azcrL/+aXnG65318UQe13GhThJGj+oCGl32PhtimnOzCagGqA+52bffg1I7ofpRh
 DUcp+JcsD02BBmr3MBivmBDOEuYa0q4t9XUncnqMBM5NU9CcgglkyjINg8DQ2XZ0
 UKy+jeC6n3dUEcfwlGKDGjyXIoCm03bmBDw2YwdJjA77iw9Hk0lMcr4VACSS8w5r
 twu44WeAjBdlw9l3O1/9HNsDBSkFQHJmYciAbei0AByqqmd8CXDAkjv6OGurLLP2
 WXQZdhqot/av1oJHqVgPdlTtBbBfbSCq8aXywvYApJvHlMqUhJ8nJUGwbmmhy40p
 pYIgzTDCPlxu6Q4XnLHM2s+gIDy7ZJTpouKaI1/eDAKKgziSX6u2WSn3RiiNh6ST
 HtLzCYNaSlNQ/TpYNWx8uK8D6blMIKW0Vebp2V/U2iNQ9R3ytbp0WhAacZDUVyZ/
 A8z30Axd7a6khW+3ud6xqpBe8DchTjkO3MnUOCfDeUY=

We do not need to writeout modified directory blocks immediately when
modifying them while the page is locked. It is enough to do the flush
somewhat later which has the added benefit that inode times can be
flushed as well. It also allows us to stop depending on
write_one_page() function.

Ported from an ext2 patch by Jan Kara.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/minix/dir.c | 36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/fs/minix/dir.c b/fs/minix/dir.c
index 34c1cdb5dc7d47..bf9858f76b6ae1 100644
--- a/fs/minix/dir.c
+++ b/fs/minix/dir.c
@@ -46,21 +46,27 @@ minix_last_byte(struct inode *inode, unsigned long page_nr)
 	return last_byte;
 }
 
-static int dir_commit_chunk(struct page *page, loff_t pos, unsigned len)
+static void dir_commit_chunk(struct page *page, loff_t pos, unsigned len)
 {
 	struct address_space *mapping = page->mapping;
 	struct inode *dir = mapping->host;
-	int err = 0;
+
 	block_write_end(NULL, mapping, pos, len, len, page, NULL);
 
 	if (pos+len > dir->i_size) {
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
+static int minix_handle_dirsync(struct inode *dir)
+{
+	int err;
+
+	err = filemap_write_and_wait(dir->i_mapping);
+	if (!err)
+		err = sync_inode_metadata(dir, 1);
 	return err;
 }
 
@@ -274,9 +280,10 @@ int minix_add_link(struct dentry *dentry, struct inode *inode)
 		memset (namx + namelen, 0, sbi->s_dirsize - namelen - 2);
 		de->inode = inode->i_ino;
 	}
-	err = dir_commit_chunk(page, pos, sbi->s_dirsize);
+	dir_commit_chunk(page, pos, sbi->s_dirsize);
 	dir->i_mtime = dir->i_ctime = current_time(dir);
 	mark_inode_dirty(dir);
+	err = minix_handle_dirsync(dir);
 out_put:
 	dir_put_page(page);
 out:
@@ -305,12 +312,10 @@ int minix_delete_entry(struct minix_dir_entry *de, struct page *page)
 		((minix3_dirent *)de)->inode = 0;
 	else
 		de->inode = 0;
-	err = dir_commit_chunk(page, pos, len);
-	if (err)
-		return err;
+	dir_commit_chunk(page, pos, len);
 	inode->i_ctime = inode->i_mtime = current_time(inode);
 	mark_inode_dirty(inode);
-	return 0;
+	return minix_handle_dirsync(inode);
 }
 
 int minix_make_empty(struct inode *inode, struct inode *dir)
@@ -350,7 +355,8 @@ int minix_make_empty(struct inode *inode, struct inode *dir)
 	}
 	kunmap_atomic(kaddr);
 
-	err = dir_commit_chunk(page, 0, 2 * sbi->s_dirsize);
+	dir_commit_chunk(page, 0, 2 * sbi->s_dirsize);
+	err = minix_handle_dirsync(inode);
 fail:
 	put_page(page);
 	return err;
@@ -429,12 +435,10 @@ int minix_set_link(struct minix_dir_entry *de, struct page *page,
 		((minix3_dirent *)de)->inode = inode->i_ino;
 	else
 		de->inode = inode->i_ino;
-	err = dir_commit_chunk(page, pos, sbi->s_dirsize);
-	if (err)
-		return err;
+	dir_commit_chunk(page, pos, sbi->s_dirsize);
 	dir->i_mtime = dir->i_ctime = current_time(dir);
 	mark_inode_dirty(dir);
-	return 0;
+	return minix_handle_dirsync(dir);
 }
 
 struct minix_dir_entry * minix_dotdot (struct inode *dir, struct page **p)
-- 
2.39.0


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
