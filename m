Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc249.phx1.oracleemaildelivery.com (aib29ajc249.phx1.oracleemaildelivery.com [192.29.103.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A701C53210
	for <ocfs2-devel@archiver.kernel.org>; Sun,  8 Jan 2023 16:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=yiB09Ahf5KPwFvnQtoUJ/OwIQp3hALbh/b10fuQe4jY=;
 b=wQZLv1/JRPr1/TyhMrwMvhPwxOADqDZAUNq8GKXEZmNx7USDVqnizd5u93GDrLGHxh1NqTq9oBST
   R2CN+nB2LdHUYTv6PRsg0fSpYw6Exk8N2GP4o/XcBe8Ad49JqjAzOupP6Xkbcc5yRw1jw5K8FR0O
   vJSLqoZBgeM8Itb39qxvDJdXALSvQTHNmbqb/12fpc439jx8ucFjDur3CU7Bm/zGvrtDUBwFkhyF
   AkUSx5Aiwl9INXMRVD64mCMGhPxvmOHXjquuWjZU6BKXRnrjv4BwA+gkXQoZ4Vbr4g81RhPKSbW0
   sTkbQzifN8i37EfJGHrXEjNnSzbn09RX0rfQVg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=yiB09Ahf5KPwFvnQtoUJ/OwIQp3hALbh/b10fuQe4jY=;
 b=GscybR5jNRiwrIVyc0+I2U3YlcIhHDME3TFthpAwI8dW52cOVTNkrAG6s6PFQAgFaAXiU+Ttbx8e
   XEjkJWs+gCFmdgp4NE3O+HUoZ+LcqYSFfhGWqhVF2Q9TMcqOE3pguya2xepW0HzimOpJQKPNIvZ/
   HhmKfuJn5iIC1cLYymwdmQfLYWINcFIZUwLEC9SN0xiQqZhSJ4d4TFARf6yb91hGm4h/C61CGQvv
   ydxlRRxLc7LtwtMosSysSvdHHg1mJqR3ZWwBTs4l25yLeuAkkLAEvybm2+TLRW/K9437be3gWB6f
   oV4z9WtmZ912oxTVilq3t4yWIUeKsFHp80tOWQ==
Received: by omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0RO60034WF3Z9D30@omta-ad2-fd1-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 08 Jan 2023 16:57:35 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=LRWqWW8CxEBUBZTClfw9RwYeRYBhCeQ4pIrtvl3s68o=; b=oQx7Rv3KHPp6gTVM17C0X1F/0A
 Ss7aKkMKn13YqMFTiyj9UovpO3YmHbFIkdRu6P1lm0x3YzRL/33E+Nm0c8v7BQiUB9dtCG6vzzb9d
 G41l8V5rOwy6wLPJHKKUyuQ6evYLtxQubPvataSaZCelc+12PgJfW96pThp+vHnLueP3p23yrcT4r
 T4i62q0kSRL41BsGk/4004k+MK+VqsohoC8D9EslgyHPJVq8uN74IO2CqRkbKPz+ZTHIKdyRRSA1J
 LI9sFgAsTdSHr/VGk8960vHaAhlEZaxW4aRfr5eGg0W61z0hBEv5IpN8Y2QgFE8AkE/5sr+NKzDRt
 VGJHblOw==;
To: Andrew Morton <akpm@linux-foundation.org>, Chris Mason <clm@fb.com>,
 Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
 Dave Kleikamp <shaggy@kernel.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Evgeniy Dushistov <dushistov@mail.ru>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Sun,  8 Jan 2023 17:56:42 +0100
Message-id: <20230108165645.381077-5-hch@lst.de>
X-Mailer: git-send-email 2.35.1
In-reply-to: <20230108165645.381077-1-hch@lst.de>
References: <20230108165645.381077-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10584
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=273
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=485 spamscore=0
 phishscore=0 impostorscore=0 malwarescore=0 priorityscore=156 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301080126
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 jfs-discussion@lists.sourceforge.net, ocfs2-devel@oss.oracle.com,
 linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH 4/7] sysv: don't flush page immediately for
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
X-Proofpoint-GUID: ppiCeQ-alhAInzjQOWWub38qWCXfwxV1
X-Proofpoint-ORIG-GUID: ppiCeQ-alhAInzjQOWWub38qWCXfwxV1
Reporting-Meta:
 AAFhFXs1/da6lqp+wuJi+V/C6ohBDHJCghOPykRWjbnqP/lfG4iBO0+4BZlfWNy7
 mjYdILYxAMbzLBmJ5GyoBcgo0+IBLgfVczVE0B5PYCXdV1cA1MLciCEMlwlt+pbp
 4d4M8BaaF86PqLMIcAXMkz8eU3XBKlaqM4626NEKZHJICmRxyGE4uwEAe4rweptX
 k3Kkk/R30Ryr1aYa1iyKXsc1aS6EsgiY/niSSHMMAdg1ciDbFJlC1X9bmnakHG7P
 7DPEREiHoqIMzvjLVPKjYbBVacdmoNBRIcwuWzWNqjG0RcYpMLxZ65pGm7r+k2wQ
 gkfV1MlUAj5u/0cyoTiqcWfvdFlgJWOBFJ2bMFRKg6L3u1gHH5iFH/d19+g+lAsX
 PNcCGjTmdcQcPVxG8sU3ZOa3C/hOl2AdZbROa4ii6yEYKEx6//Xg+81G/rdv6YLP
 zTNQQihm7kpZqjw8yXqsz22NlAFSusN071HSZHGT0CXpw15CtPRFCDVg80iPv+I5
 ch6JmknAkrxGAPB8SAhKa+R+zwdbjVJ34jvBmhIaarZR

We do not need to writeout modified directory blocks immediately when
modifying them while the page is locked. It is enough to do the flush
somewhat later which has the added benefit that inode times can be
flushed as well. It also allows us to stop depending on
write_one_page() function.

Ported from an ext2 patch by Jan Kara.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/sysv/dir.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/fs/sysv/dir.c b/fs/sysv/dir.c
index 88e38cd8f5c9ae..1d852ca6388297 100644
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
+	sysv_handle_dirsync(dir);
 out_page:
 	dir_put_page(page);
 out:
@@ -238,10 +244,11 @@ int sysv_delete_entry(struct sysv_dir_entry *de, struct page *page)
 	err = sysv_prepare_chunk(page, pos, SYSV_DIRSIZE);
 	BUG_ON(err);
 	de->inode = 0;
-	err = dir_commit_chunk(page, pos, SYSV_DIRSIZE);
+	dir_commit_chunk(page, pos, SYSV_DIRSIZE);
 	dir_put_page(page);
 	inode->i_ctime = inode->i_mtime = current_time(inode);
 	mark_inode_dirty(inode);
+	sysv_handle_dirsync(inode);
 	return err;
 }
 
@@ -272,7 +279,8 @@ int sysv_make_empty(struct inode *inode, struct inode *dir)
 	strcpy(de->name,"..");
 
 	kunmap(page);
-	err = dir_commit_chunk(page, 0, 2 * SYSV_DIRSIZE);
+	dir_commit_chunk(page, 0, 2 * SYSV_DIRSIZE);
+	err = sysv_handle_dirsync(inode);
 fail:
 	put_page(page);
 	return err;
@@ -336,10 +344,11 @@ void sysv_set_link(struct sysv_dir_entry *de, struct page *page,
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
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
