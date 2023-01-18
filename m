Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 657F9C678DC
	for <ocfs2-devel@archiver.kernel.org>; Wed, 18 Jan 2023 17:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=trOpjgJk2GZZm7axUl/DEU8hjzTQYBLQK9GRo7R+Dlk=;
 b=leGHZhJnYB8rsJ/PUQtKYAyqHp7BuMK7B6kdd0U/GHf72vRQ8bp61hOJ5hK78+wdsApE3D43nm+W
   TfRpjl2FIeoBhoxGg8Aq46hkVJZq4hKPXU2YGbdNX0OmpFUokoa/cYkDiotsJGhr8I3wdhJ+qAz9
   O/ohRQZ4X3R3zfZHG2DwuU0070tGAt2SC9fyIeG+/Oa5w2qlR8kAI4YeBJg87pVx7qLPb+LwWsmx
   a3+b9UpfmzGhMVsFwfPbxFCAi/3mvfTjLM3Eetb+z4UNAuFJT2oyhEqYaqOEEJ3Wwq0jTF+w8l6X
   vxdWo6vbi5hwL/Fv+y6eHfy4ZJoYDeU/paN3/g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=trOpjgJk2GZZm7axUl/DEU8hjzTQYBLQK9GRo7R+Dlk=;
 b=aU4iRrbDbIGDa8fciLiIjiwjDcenwGwDntEAdVCXA+WSVgAUllARvjMhKtyS8KwPL7SW8qzTbJNS
   AvKmMAWFf6dbNsPRASPEHz0AbGUDEVW1dCnu/KyN2lzv/X+Riz6lXIzIoGrr7brYBt/UbFe8Wjkd
   8GF2SbBe7b/A5vbKaAVwBQwAzMF0H8BTBGhhH8oynujkAxtDCCy9SNltRKhFmf3owBuz1VezTBij
   pAVId1BVkJIaR9dvmJc55cIcqUOKZ7m1Lgk6WzfCy/Pbu6ia5T01cd10hTWX+LBmFp0xiroV8MRr
   uc5n4gMV3Xyrjw2RgCnSqOPFPpU6WZ5kMCnk2A==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0ROO001ZBZBTZZ20@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 18 Jan 2023 17:31:05 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=RiDLIEceuZ9xYcAquYO1xUuvp0itrlt5jINwhutKHnw=; b=n97J6P4Lj3rjm3/TGFmVVg8Wrr
 u/Z8bas8ry+fHYEM5YBXc8LfZPJatmLG0er+p8+/5CozJDOufcBh+tyW0g+wakyIsB/9H5FBTQ/B0
 P9RF3jbwsVQOKtVzVYq7n5OOzt7LsHupFBPGD8lmcE/OHd7pBxTqExpqoyUj+zhmPtrIzvY6WCi74
 ejoYGQAJZLfGPwCd34tL2WZjX757TewJV/7vUp0+iZHuP6KbIZypE49r+dwszdbfXvfZ0yZgwPc6T
 5DRNKtiiyQUMu2UyCmj+gIm6vlzuH7QZqDupe5mw9DI9tktHePHc6C+y8Gg4JuWOk1p9RZQn4I0sW
 n3a9GVtw==;
To: Andrew Morton <akpm@linux-foundation.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Evgeniy Dushistov <dushistov@mail.ru>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Wed, 18 Jan 2023 18:30:25 +0100
Message-id: <20230118173027.294869-6-hch@lst.de>
X-Mailer: git-send-email 2.39.0
In-reply-to: <20230118173027.294869-1-hch@lst.de>
References: <20230118173027.294869-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10594
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 bulkscore=0 phishscore=0 adultscore=0 priorityscore=0 lowpriorityscore=0
 mlxlogscore=482 mlxscore=0 impostorscore=0 spamscore=0 suspectscore=0
 clxscore=181 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301180148
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH 5/7] sysv: don't flush page immediately for
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
X-Proofpoint-GUID: TKMoey65ppqveZaw98LpIwjMftQR_AO0
X-Proofpoint-ORIG-GUID: TKMoey65ppqveZaw98LpIwjMftQR_AO0
Reporting-Meta:
 AAFtBdav8nJZ6QjCjUiBH/XplsIlh2RbNxr1pPaJHEKe2nZVRzJFILtEg8KQmWk5
 azcrL/+aXnG65318UQes3GhThJGj+oCGl31zCcRf9midnyS2NDDGhC8qWjZusjSo
 yd1yBJPsKBK6QXLvs8aLJW03tzAhCRVztmTRMlBX2iJvWvwkb+ISinFAnrxFklEU
 SPAT8KhmP1fMP9LJS0zuQTjfITlMJWMIpIhqQyL1VNRW1OQJYcjFUtXxqrRAJSy1
 uI01ODDrl4T1Bx9cuFKLUgMoNZlCzYVIulhFP/WJCDpq7gJY0sWZP4AniBu6RGWS
 QmTbXcm+NPQQeaJ/vXJr1aVxw0VsL5k/Tse8YMgNxD7pJzDws7V/Psfn2Lo5BAax
 9VesxN55QvCXjFrJu2TcE6TXvHRoVDPa+B4d8WocqdWYqe7mloSzCGyEvaeN/zm+
 E1yXXr9BSqqdguDjt7x+AnVRNZ/uYqjHkLdChA9i9Abm3hSC1yjRtCDSYQTcXLqB
 MEa5ihqCTqHqTHbc4suJBzCxn8fdxoFiX/QUgr6fRRna

We do not need to writeout modified directory blocks immediately when
modifying them while the page is locked. It is enough to do the flush
somewhat later which has the added benefit that inode times can be
flushed as well. It also allows us to stop depending on
write_one_page() function.

Ported from an ext2 patch by Jan Kara.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/sysv/dir.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/fs/sysv/dir.c b/fs/sysv/dir.c
index 88e38cd8f5c9ae..16730795a62161 100644
--- a/fs/sysv/dir.c
+++ b/fs/sysv/dir.c
@@ -34,21 +34,26 @@ static inline void dir_put_page(struct page *page)
 	put_page(page);
 }
 
-static int dir_commit_chunk(struct page *page, loff_t pos, unsigned len)
+static void dir_commit_chunk(struct page *page, loff_t pos, unsigned len)
 {
 	struct address_space *mapping = page->mapping;
 	struct inode *dir = mapping->host;
-	int err = 0;
 
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
+static int sysv_handle_dirsync(struct inode *dir)
+{
+	int err;
+
+	err = filemap_write_and_wait(dir->i_mapping);
+	if (!err)
+		err = sync_inode_metadata(dir, 1);
 	return err;
 }
 
@@ -215,9 +220,10 @@ int sysv_add_link(struct dentry *dentry, struct inode *inode)
 	memcpy (de->name, name, namelen);
 	memset (de->name + namelen, 0, SYSV_DIRSIZE - namelen - 2);
 	de->inode = cpu_to_fs16(SYSV_SB(inode->i_sb), inode->i_ino);
-	err = dir_commit_chunk(page, pos, SYSV_DIRSIZE);
+	dir_commit_chunk(page, pos, SYSV_DIRSIZE);
 	dir->i_mtime = dir->i_ctime = current_time(dir);
 	mark_inode_dirty(dir);
+	err = sysv_handle_dirsync(dir);
 out_page:
 	dir_put_page(page);
 out:
@@ -238,11 +244,11 @@ int sysv_delete_entry(struct sysv_dir_entry *de, struct page *page)
 	err = sysv_prepare_chunk(page, pos, SYSV_DIRSIZE);
 	BUG_ON(err);
 	de->inode = 0;
-	err = dir_commit_chunk(page, pos, SYSV_DIRSIZE);
+	dir_commit_chunk(page, pos, SYSV_DIRSIZE);
 	dir_put_page(page);
 	inode->i_ctime = inode->i_mtime = current_time(inode);
 	mark_inode_dirty(inode);
-	return err;
+	return sysv_handle_dirsync(inode);
 }
 
 int sysv_make_empty(struct inode *inode, struct inode *dir)
@@ -272,7 +278,8 @@ int sysv_make_empty(struct inode *inode, struct inode *dir)
 	strcpy(de->name,"..");
 
 	kunmap(page);
-	err = dir_commit_chunk(page, 0, 2 * SYSV_DIRSIZE);
+	dir_commit_chunk(page, 0, 2 * SYSV_DIRSIZE);
+	err = sysv_handle_dirsync(inode);
 fail:
 	put_page(page);
 	return err;
@@ -336,10 +343,11 @@ void sysv_set_link(struct sysv_dir_entry *de, struct page *page,
 	err = sysv_prepare_chunk(page, pos, SYSV_DIRSIZE);
 	BUG_ON(err);
 	de->inode = cpu_to_fs16(SYSV_SB(inode->i_sb), inode->i_ino);
-	err = dir_commit_chunk(page, pos, SYSV_DIRSIZE);
+	dir_commit_chunk(page, pos, SYSV_DIRSIZE);
 	dir_put_page(page);
 	dir->i_mtime = dir->i_ctime = current_time(dir);
 	mark_inode_dirty(dir);
+	sysv_handle_dirsync(inode);
 }
 
 struct sysv_dir_entry * sysv_dotdot (struct inode *dir, struct page **p)
-- 
2.39.0


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
