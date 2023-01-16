Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc248.phx1.oracleemaildelivery.com (aib29ajc248.phx1.oracleemaildelivery.com [192.29.103.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD43CC678D6
	for <ocfs2-devel@archiver.kernel.org>; Mon, 16 Jan 2023 08:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=F1auAvIMZEMOti+brYay4j0Wk9vbu4v2Z9rSsrjpsW4=;
 b=uGsdAdNQnIQKKGxNuPcy/m9iTMlj6pFCum+x+R5kXpuExulbOk2jWeeG7KkTJMfTD4aC0NHbr6lM
   SPF1pb+546OZsTEXXLqSwb7W1fQJxBGKbE0vP5nOmYk3AZMItXjWtvNBqV1Au+X6wb88VoQOAw8b
   xQ1WwmPL4k/97ObjzRivnVpW3RbecACgRdLa+HI1QxqpKUnuq/VyTKEsaIIaIVmtpPsfXAZOg97t
   SZzG/Zo40dT41zYwWe+edW4O7xi749WDfOHv1q9I2H/YFaRRjHI5JPQkxzizefnT6PyTCWLUrQtK
   7O7a3Ig7OPvWr4BsPM5FAatFmr6899z/1nbwYQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=F1auAvIMZEMOti+brYay4j0Wk9vbu4v2Z9rSsrjpsW4=;
 b=rw7/E+SblHCuooA+F424RzXO//wsTpmzv4WQI01zfF9NhZ3noaSZdzCeWM40uIu1E3/z6bit6SUW
   KO/5iLQD2u7VRkxx5tMcGcv9vgcRkohPEnemD4PUNaQ3WbYnLVSBWjgvlD1tKXfBLYfsnSeV6a9l
   /6TuD936V08fm4G7liCUIG4S+681orKEPq2zDWz/4LuhjOzlNQNM4UwXY+l9S3F0SPw3UQIsT3ie
   5vL5jl8wHH7ja56dOYTdh41m/lIUEWHHHarAwACHjlbQRaZDAKsM+U8uROXztuigpNJxSCPF4Bk/
   hpdVvFIAY93hlartDKfbQOJkGfnp5EcUXBByrw==
Received: by omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0ROK00GDTM59PF20@omta-ad2-fd1-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 16 Jan 2023 08:55:57 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=QCNp0MjEp23ArfIJ213HXzBCfkQxI9y/8H4Y/9jbIO4=; b=mRy4maM935+DV+YcCBIpsd71Lr
 7sZO4iblXJf5AMYHhO9W/mCToFpztmdszLYgqR5sKv/vM9fAVUnf8efucn9dFSYbGcXlFHeiTHAf3
 0C0h/yd1xVkdjYOBQQHk4u+/ydG55Gjr1yOASZm1MR2zrEQViFDCxXIc0GJEMZNHUtEr3KS1spLKr
 2SaJQ5nr+iG1qcoZcGMaZCop5lBypWU0JzxeBIminN4jXsulD9HnMZYB4ZV/fu1AVAnVEoX3fjx/0
 TRpSLxdIeo8qB9j6igNDIPhTzcuk/YMJbKfUZnM9nwuogF3O1RN/a//yMYM1fCsddLUO9lVdY4xA8
 02hxatDw==;
To: Andrew Morton <akpm@linux-foundation.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Evgeniy Dushistov <dushistov@mail.ru>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Mon, 16 Jan 2023 09:55:20 +0100
Message-id: <20230116085523.2343176-4-hch@lst.de>
X-Mailer: git-send-email 2.39.0
In-reply-to: <20230116085523.2343176-1-hch@lst.de>
References: <20230116085523.2343176-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10591
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 priorityscore=0
 phishscore=0 suspectscore=0 bulkscore=0 spamscore=0 impostorscore=0
 malwarescore=0 mlxscore=0 lowpriorityscore=0 mlxlogscore=544 adultscore=0
 clxscore=280 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301160065
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH 3/6] minix: don't flush page immediately for
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
X-Proofpoint-GUID: 2Hv26w6oInA3zUlsBFT6DzQQmCNo6JuJ
X-Proofpoint-ORIG-GUID: 2Hv26w6oInA3zUlsBFT6DzQQmCNo6JuJ
Reporting-Meta:
 AAEmll2kw/q7mz8YJY77ANaDo51nlTSwck8H9vBb+35GXh94j7QbYTe7PDMoY7Rf
 nYMIqA/6BXmf75jpHqiWjGDl8sGJ7sBNtYUcUrqUE6mbm1SUIwTyb8f/EFJ+Y63O
 YKoyhYnMRVefMa7XFyszdVfOXJAfJDEjhhbDpNG1jYiFVXvB6WSegh+5p43AEKcU
 pFXU5hZtHJwCLhoy5OWfVam5Pbls5GV2AXXvWOU1oSkW5fFiIpNdctUcoKsOYZMU
 +vTGwIPowTKraoiDuELodcA5497WycB5pd76ik1KTXqx7mg4RMzYgnGx97t3SWR6
 l3CcDzch00IksLltONicrrcuLmNlN6zMy+VW24a0SY2iwSN13D9YaHloEn72tP8T
 EeRgHZ7nGaZk5nitgq4Ut5D4RajhlHhkU6IewZyGaJqIR12bcc0cXrCWIuuU+SXn
 YnWa+cH9/ux6Hn6DMuDletygLuXk0e51wDc/TSFL5ifP7yBHPwONoFJh4DmNcW9q
 hZCBQCSUpr6h2EentC0N2NAfow7AzUG9qwhXeqsxdDI=

We do not need to writeout modified directory blocks immediately when
modifying them while the page is locked. It is enough to do the flush
somewhat later which has the added benefit that inode times can be
flushed as well. It also allows us to stop depending on
write_one_page() function.

Ported from an ext2 patch by Jan Kara.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/minix/dir.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/fs/minix/dir.c b/fs/minix/dir.c
index c9a3d520b72671..e9a1dc6bdfb0a1 100644
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
@@ -305,9 +312,11 @@ int minix_delete_entry(struct minix_dir_entry *de, struct page *page)
 		((minix3_dirent *)de)->inode = 0;
 	else
 		de->inode = 0;
-	err = dir_commit_chunk(page, pos, len);
+	dir_commit_chunk(page, pos, len);
 	inode->i_ctime = inode->i_mtime = current_time(inode);
 	mark_inode_dirty(inode);
+	if (!err)
+		err = minix_handle_dirsync(inode);
 out_put_page:
 	dir_put_page(page);
 	return err;
@@ -350,7 +359,8 @@ int minix_make_empty(struct inode *inode, struct inode *dir)
 	}
 	kunmap_atomic(kaddr);
 
-	err = dir_commit_chunk(page, 0, 2 * sbi->s_dirsize);
+	dir_commit_chunk(page, 0, 2 * sbi->s_dirsize);
+	err = minix_handle_dirsync(inode);
 fail:
 	put_page(page);
 	return err;
@@ -429,9 +439,10 @@ int minix_set_link(struct minix_dir_entry *de, struct page *page,
 		((minix3_dirent *)de)->inode = inode->i_ino;
 	else
 		de->inode = inode->i_ino;
-	err = dir_commit_chunk(page, pos, sbi->s_dirsize);
+	dir_commit_chunk(page, pos, sbi->s_dirsize);
 	dir->i_mtime = dir->i_ctime = current_time(dir);
 	mark_inode_dirty(dir);
+	err = minix_handle_dirsync(dir);
 out_put_page:
 	dir_put_page(page);
 	return err;
-- 
2.39.0


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
