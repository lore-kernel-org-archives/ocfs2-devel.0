Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc253.phx1.oracleemaildelivery.com (aib29ajc253.phx1.oracleemaildelivery.com [192.29.103.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87BC3C678D6
	for <ocfs2-devel@archiver.kernel.org>; Mon, 16 Jan 2023 08:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=r3sNFF30Jb5j31at7//39hlfpCm9ShvYjX1GGodt/tc=;
 b=oyaHrVWziMrmhiJCT25M9KoToN34vTGSnKdBmmaKQ6iokWXOfftKOGOOXfZ07kyRFRKFwgQ5zahM
   b7JIXEwAhTWbBcAk33BgQtbszxc2iBCSMR6BBNTIpRwweXkPBbsBzZAO0a6HD7rj1NZ1XpcgGkDI
   JhDNAd4pMLa82K+9yHkA0D1FdHlY6LswgkgsYnzO2lmbsa06APxGQoKIj9UUno8MJ95WnPzD1Dx7
   p9XxC64JhI94+aIcvjrJ8QEl0ooTFezJJVwajTt6qw3+kHf7OoUODOoyHpsTeOrrRC7pOaMkenvk
   1hHtfBjml84wGojQxcisvgwy2Rx6XsZk7ntmxw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=r3sNFF30Jb5j31at7//39hlfpCm9ShvYjX1GGodt/tc=;
 b=DSS6YpTz3e52pIhN8S5D+V0Mb2vtlSCnVST/NTaUXUA2m71qHcRafMJ1Z4LXPdG3+YSsxKanx+/b
   6kDIEK41IMZbsfzv1B45N1CBE9eCJ9SOdjhGuqZ4meAWl+5mK/R8ZMgV7ZdsbJdIf4MGHm/wREjA
   fe89G+aJ1iAMTyBf+yqsSkV7dSo3voCFTDdK84c5EmwWrfvhqPQCOEuzahaTgAGDL/ELqBiR+uqb
   sBLp5cYhKlsMToQap9AuxEKzyTklrRhxjzWWg7Nbtb7VEIpAJ8A0QS84ueKJ0ZFBRLyG26weC25x
   PDKHYlZ0LpLRJH48lqxabqkkO6DtUgATvj20hg==
Received: by omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0ROK0043CM56J040@omta-ad3-fd1-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 16 Jan 2023 08:55:54 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=NG71ox6jr7uM23QDAMDsMfdxiN0WqWQj6pY4BZkkyg4=; b=ax/Y5gnTZrhv4w+jf2OeQVm0tO
 ApYJIKsK4ZXfMVwKWlqPdLSJGP7kZIKwE+8CcUbfwwIAFByrMjNSd07pUOBcF66nJ5xWCREc2zMkU
 6mQdASNdx+VRTkGlDR6nv34V1Gyn0I0mgWr5vC6NPNwqutc4UvBh0Fclq2irNimI4eewwgg36uQdO
 fLLkCZXLsoD2eFF6L1iPPsq0srwwA50/WBOJGtJgd6NxY3jjsggeAISiUmyxXvl/WudhRuyFHtfm1
 mUmQWnGtNpkbvWi694jhOU5G5hCEQcsB1/CbOSDSPOS+AuNO46i3WVwUrCXrGG3oKZbpzYuFdcpMd
 vHS2daEQ==;
To: Andrew Morton <akpm@linux-foundation.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Evgeniy Dushistov <dushistov@mail.ru>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Mon, 16 Jan 2023 09:55:19 +0100
Message-id: <20230116085523.2343176-3-hch@lst.de>
X-Mailer: git-send-email 2.39.0
In-reply-to: <20230116085523.2343176-1-hch@lst.de>
References: <20230116085523.2343176-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10591
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=275
 lowpriorityscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 impostorscore=0
 mlxscore=0 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0
 priorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301160065
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH 2/6] minix: fix error handling in	minix_set_link
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
X-Proofpoint-GUID: 0nBdLdAVXX77i_YjZY8Qy1T6NkKpxvQd
X-Proofpoint-ORIG-GUID: 0nBdLdAVXX77i_YjZY8Qy1T6NkKpxvQd
Reporting-Meta:
 AAFnVytbt0/eJ7/RdC2BiIivGX9wK+sJZBVltpOYkowhFnx3Uy1k5whBcKwCCL7i
 /REqb++KN70BnDf28oTf7JRfSUFhVOxLvYpqHPTdk+oeTnuLpeFLTXFMGemgg5NJ
 6X8i5s0JyGlnTLuTXlpKTe00rhDB2GpZI9FP1Td2ggW50YCecm131ItzJPWTKKdV
 cUa+cVsokNu396o72TB1XFYDiww6tK7K1lVwS9eT6T+ZUVJEuQRQ9Sar9hg4wpKc
 I7EjkWecYTNAo9MhM7dKDTSnEuZHo1TANHvsRqWpySgYSUBVRWBzOcoV8d5ZGfrT
 5AgvZjD0Ok+wyZpHjVD/htMbrjlYsbGmUFdyKVJ0yMZ0YCm5mfKi6W99jRvdin7M
 3u2Br+YQXcUcP9OTnZtiB3JGR8z1wJjETBdvUcu4/ilqWEQUUw6Lj3QcExcxgT43
 dEhoD+GomOBx5HgjLrEuSyHYwMXJxA4oqS8lWJ1PaNTzBTE+MZleyHm4eiWzWl70
 EfRNKihqL/N5bDsbUXKG3wqlDeeEdL4b6USVURYhsKRH

If minix_prepare_chunk fails, updating c/mtime and marking the
dir inode dirty is wrong, as the inode hasn't been modified.  Also
propagate the error to the caller.

Note that this moves the dir_put_page call later, but that matches
other uses of this helper in the directory code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/minix/dir.c   | 23 ++++++++++++-----------
 fs/minix/minix.h |  3 ++-
 fs/minix/namei.c |  8 +++++---
 3 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/fs/minix/dir.c b/fs/minix/dir.c
index a8e76284cb71ec..c9a3d520b72671 100644
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
@@ -420,20 +420,21 @@ void minix_set_link(struct minix_dir_entry *de, struct page *page,
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
+		goto out_put_page;
 	}
-	dir_put_page(page);
+	if (sbi->s_version == MINIX_V3)
+		((minix3_dirent *)de)->inode = inode->i_ino;
+	else
+		de->inode = inode->i_ino;
+	err = dir_commit_chunk(page, pos, sbi->s_dirsize);
 	dir->i_mtime = dir->i_ctime = current_time(dir);
 	mark_inode_dirty(dir);
+out_put_page:
+	dir_put_page(page);
+	return err;
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
index 8afdc408ca4fd5..82d46c28f01b01 100644
--- a/fs/minix/namei.c
+++ b/fs/minix/namei.c
@@ -223,7 +223,9 @@ static int minix_rename(struct user_namespace *mnt_userns,
 		new_de = minix_find_entry(new_dentry, &new_page);
 		if (!new_de)
 			goto out_dir;
-		minix_set_link(new_de, new_page, old_inode);
+		err = minix_set_link(new_de, new_page, old_inode);
+		if (err)
+			goto out_dir;
 		new_inode->i_ctime = current_time(new_inode);
 		if (dir_de)
 			drop_nlink(new_inode);
@@ -240,10 +242,10 @@ static int minix_rename(struct user_namespace *mnt_userns,
 	mark_inode_dirty(old_inode);
 
 	if (dir_de) {
-		minix_set_link(dir_de, dir_page, new_dir);
+		err = minix_set_link(dir_de, dir_page, new_dir);
 		inode_dec_link_count(old_dir);
 	}
-	return 0;
+	return err;
 
 out_dir:
 	if (dir_de) {
-- 
2.39.0


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
