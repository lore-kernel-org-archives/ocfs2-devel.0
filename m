Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDE10C32793
	for <ocfs2-devel@archiver.kernel.org>; Wed, 18 Jan 2023 17:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=7NpcWo/OT5GMB9zLDFOtU+r7eBYYo4oMq7Xx6NFTjhs=;
 b=Kb1Z9da7rzUeXuthYN59TvzU66mTJfsXVIblvrRgjtohyNkBOQhGOW9lO/Aa9hW72TMsylJa95yN
   qkqhCQ61fWoyeNCnjZcHQzKbp12Ag4GL3DW89wndQtisrWo3qLdL8LJMxd3/IxuouS3OzNKV1sng
   FdqJkeYXOk3kF10TUmCx+SRtsu5Vi4Kb8AYncxUNKRWnwkphijqNm0w2qKxGN7D6HZi7YgXttPtK
   lgbhzVywZscDpf10bPqVWZoxVes0i0LQ5Sv/+Iir5w+MjAdCnvk4m455fNE/qDO2j7otSukDXT6b
   3lAwio0im2oSRo3P/8oBqruqdE4R2qDcIn/N0g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=7NpcWo/OT5GMB9zLDFOtU+r7eBYYo4oMq7Xx6NFTjhs=;
 b=LbCfh5HGD8c7jUnkoa0vIEXl2DHIYofzi3ObkZylVbaS+pxwpR46f3saWv5rRYxL30pouy9ZDWR6
   3MZkhj3bDa/7KuSgxnMk6eKpWQXRgkQQArBlCiXHIh+mwExBxUe60wxpw7yGR9n/ucMTIEOnz+iw
   d1zoM3XzsK6lMBG/c6YYSmxoWjM029nXzajXVDp/3ZMbdt/5e5J4ToJ0KN7y6g933LcwGixofTMG
   kd5Ymkd+WJBt9fW77KlE0GZ8pDg75prsqqnTWlQmJEf9GVFIuauimSuS0/VVJ6vu1XZltMD+I36r
   F7fUd/lv6WWM1FgLC5hOZS46hayCPgq/aC0hig==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0ROO00MKRZBSA8D0@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 18 Jan 2023 17:31:04 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=IK5go+LYlZzyyL0UG1E7ybATwbkUdMWL1x4AyvlHUwI=; b=22EHDJ091Mc3KuCstacxTn+6U1
 TtnzRBznDgrz0So3oaYkMeFGRgj57zvpXYFUDSdqIZCgYRkHBvwHfNjsXzrP/xQqOVenmai+nAW05
 fAdQseByMb+clpStiSc1jaAggo5QN6wpqlWBa4LFiuGeCZQTwywEGcNFv57TECBX0jtat3EobXTs3
 AAuTXZlnaD8uWKiY541D53Z2S5GCsZPQrhEooQxpEasFeFqVjWXpIG4T+M4rZXyBOYzvSLrlcDucJ
 OM2qASNW5swyWRdm0BMqklqdwx4TTiiRsUbp0AvE/p/fb51scw/1RLWSo3a+Nh0FNvVDREyxuYrqN
 vC+yzHTQ==;
To: Andrew Morton <akpm@linux-foundation.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Evgeniy Dushistov <dushistov@mail.ru>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Wed, 18 Jan 2023 18:30:23 +0100
Message-id: <20230118173027.294869-4-hch@lst.de>
X-Mailer: git-send-email 2.39.0
In-reply-to: <20230118173027.294869-1-hch@lst.de>
References: <20230118173027.294869-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10594
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 bulkscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 mlxlogscore=999 clxscore=228 malwarescore=0 phishscore=0 priorityscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301180148
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH 3/7] minix: fix error handling in	minix_set_link
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
X-Proofpoint-GUID: uf6z4MOBltQ5Wgp2TzdXS_NuGK8JOJcU
X-Proofpoint-ORIG-GUID: uf6z4MOBltQ5Wgp2TzdXS_NuGK8JOJcU
Reporting-Meta:
 AAF+DhxvWj2jXmkXIsfQdOfuZ0cAubSG4K4kz/zqFZ965ABGCJgyrMHUeU2mekH1
 ZLU3C3x6NuXjbFDQe2BnnzztGpeUePM3AM4apKzezd3ftEZ7VEY7fW5eVSYJR1jO
 tAlPHCm/ldpjtevZpZ3Q2BePadipu7EHczjxAWdMcOA2z45oHilXbga48rr0HmuA
 cdwI1Rwc4sqdZ+2aK/ZXMneZPNtXZku98CXzJbXYBPJQJhh3QDaaKYq86Ylyt3w+
 AES80DJGISSiJG6SFPQP/i4QerzjamPgWzJ/Cxs1ABJnA1H0l/FMxpafd7OAJmKM
 4s8NH15nn8vS0oSNixVQDmoW+1hVxetE1+YYgiISLyTWr/anpTomPCozwJ19Kucs
 ft92yjfenq2arsUTsZe4UQm8LoU0gqz63w/bHpzH/VD6JuL2GFSgsOn5a8hsR1ug
 iBliXYC6cgB1/sc9OFdf83PyfaRwFAdQcC7Ldp4i0R4+xX8HUZqJONOVirH3m9Q9
 WdmWpkkyHdX5IC2uIX7scz8P1JXzgoN5fHpQ/1/ozjE=

If minix_prepare_chunk fails, updating c/mtime and marking the
dir inode dirty is wrong, as the inode hasn't been modified.  Also
propagate the error to the caller.

Note that this moves the dir_put_page call later, but that matches
other uses of this helper in the directory code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/minix/dir.c   | 22 ++++++++++++----------
 fs/minix/minix.h |  3 ++-
 fs/minix/namei.c | 10 ++++++----
 3 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/fs/minix/dir.c b/fs/minix/dir.c
index 242e179aa1fbeb..34c1cdb5dc7d47 100644
--- a/fs/minix/dir.c
+++ b/fs/minix/dir.c
@@ -410,8 +410,8 @@ int minix_empty_dir(struct inode * inode)
 }
 
 /* Releases the page */
-void minix_set_link(struct minix_dir_entry *de, struct page *page,
-	struct inode *inode)
+int minix_set_link(struct minix_dir_entry *de, struct page *page,
+		struct inode *inode)
 {
 	struct inode *dir = page->mapping->host;
 	struct minix_sb_info *sbi = minix_sb(dir->i_sb);
@@ -420,19 +420,21 @@ void minix_set_link(struct minix_dir_entry *de, struct page *page,
 	int err;
 
 	lock_page(page);
-
 	err = minix_prepare_chunk(page, pos, sbi->s_dirsize);
-	if (err == 0) {
-		if (sbi->s_version == MINIX_V3)
-			((minix3_dirent *) de)->inode = inode->i_ino;
-		else
-			de->inode = inode->i_ino;
-		err = dir_commit_chunk(page, pos, sbi->s_dirsize);
-	} else {
+	if (err) {
 		unlock_page(page);
+		return err;
 	}
+	if (sbi->s_version == MINIX_V3)
+		((minix3_dirent *)de)->inode = inode->i_ino;
+	else
+		de->inode = inode->i_ino;
+	err = dir_commit_chunk(page, pos, sbi->s_dirsize);
+	if (err)
+		return err;
 	dir->i_mtime = dir->i_ctime = current_time(dir);
 	mark_inode_dirty(dir);
+	return 0;
 }
 
 struct minix_dir_entry * minix_dotdot (struct inode *dir, struct page **p)
diff --git a/fs/minix/minix.h b/fs/minix/minix.h
index 20217336802570..8f7a636bd1b241 100644
--- a/fs/minix/minix.h
+++ b/fs/minix/minix.h
@@ -69,7 +69,8 @@ extern int minix_add_link(struct dentry*, struct inode*);
 extern int minix_delete_entry(struct minix_dir_entry*, struct page*);
 extern int minix_make_empty(struct inode*, struct inode*);
 extern int minix_empty_dir(struct inode*);
-extern void minix_set_link(struct minix_dir_entry*, struct page*, struct inode*);
+int minix_set_link(struct minix_dir_entry *de, struct page *page,
+		struct inode *inode);
 extern struct minix_dir_entry *minix_dotdot(struct inode*, struct page**);
 extern ino_t minix_inode_by_name(struct dentry*);
 
diff --git a/fs/minix/namei.c b/fs/minix/namei.c
index 5fc696e032c543..bfbadd85d01032 100644
--- a/fs/minix/namei.c
+++ b/fs/minix/namei.c
@@ -223,10 +223,11 @@ static int minix_rename(struct user_namespace *mnt_userns,
 		new_de = minix_find_entry(new_dentry, &new_page);
 		if (!new_de)
 			goto out_dir;
-		err = 0;
-		minix_set_link(new_de, new_page, old_inode);
+		err = minix_set_link(new_de, new_page, old_inode);
 		kunmap(new_page);
 		put_page(new_page);
+		if (err)
+			goto out_dir;
 		new_inode->i_ctime = current_time(new_inode);
 		if (dir_de)
 			drop_nlink(new_inode);
@@ -243,8 +244,9 @@ static int minix_rename(struct user_namespace *mnt_userns,
 	mark_inode_dirty(old_inode);
 
 	if (dir_de) {
-		minix_set_link(dir_de, dir_page, new_dir);
-		inode_dec_link_count(old_dir);
+		err = minix_set_link(dir_de, dir_page, new_dir);
+		if (!err)
+			inode_dec_link_count(old_dir);
 	}
 out_dir:
 	if (dir_de) {
-- 
2.39.0


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
