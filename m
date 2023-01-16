Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc255.phx1.oracleemaildelivery.com (aib29ajc255.phx1.oracleemaildelivery.com [192.29.103.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D31FBC678D7
	for <ocfs2-devel@archiver.kernel.org>; Mon, 16 Jan 2023 08:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=trOpjgJk2GZZm7axUl/DEU8hjzTQYBLQK9GRo7R+Dlk=;
 b=JjIolYYO4MatI69LyFL/nQKJJ+1k6gOl7WgS2ji96hVnr2HVxgZCqFtHbZkT8dj9Sr84i2ioFCv4
   rAiK46iIDEobW9+iB4NYyWPXxhMKAUwHIfFDANMvHXmam3fNP6fHpbGiIzbNLaZShd3HPUmuw8Pb
   KCsnFqAPVeQtd9vy75OSJxDnTJt46KMzobizSe7F1IwF4Q6iGOabv/T2OfC+JaVx7a6eya38cjVK
   ArFAfUuXArbNVaJna0I3V/hI8qU4W2c/kdaBH0Fwt3yb6u55S9zB8VzHxG98TRWbCG0yTMeNa+UY
   SbkssV9VBn+a/sNI9wiUtnK7TtFuGDGRv1uXOQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=trOpjgJk2GZZm7axUl/DEU8hjzTQYBLQK9GRo7R+Dlk=;
 b=gruit+A6hhiKjllRK5lDJAqT1PpXpT6Lk0LDEkt8TojTe7gh0Y+yb7pNoOm23PWGrz7z4I/igz9T
   doe+ttoaUW9BnP1Pw/hJsCGAhxUIZQLPFbDNMeHzDPVFQRf0+lZIERTpAJTwsOOXQqAUOaNhSU6d
   c4PfVnhDm/IqDcXqBGkZ4Tpxh4y2u/EhaFymTPiR6pk6akzps/DkQHZvRborIu/++cE2Vb12QqNF
   5TSCln6pgnwCcudeo/5eq+zRxs/gQP4eb4kENpfwsBSlRwhDysy4tN+RkkAU91Izs4r1aRz01cG6
   5awVWIOCelIBRD8HN1DOej0bLeUNVC8/7WGNJQ==
Received: by omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0ROK00LHKM59H4A0@omta-ad3-fd3-302-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 16 Jan 2023 08:55:57 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=RiDLIEceuZ9xYcAquYO1xUuvp0itrlt5jINwhutKHnw=; b=45KjjDK9HcGMupbHi8/ccd2lsk
 fppYv0+p3TbWlTYws63J9CCnCl/AjpUsqGf6TmfN1ePwYYudyAtmZ7Unotrxgp2ANUKUK5KL7BHR4
 XA4mCttnzQ8oVfaW6fBs2R/evPrQ3GwRokqUv7AfYrw/mu4L2IROYrxoD9Yw7fUYfhtP00HKihi/q
 Y87KScBT9rsWb3KqrM9iZM2WU0eTnF9eVl8y+AFynnB6puXTb1ojZ3/NatLxoXwNQJ5LMF2tkinht
 tR4wbttPfOvNRgbB+u/+C0jDHTsi82wKIzzYrY9Nmmejm1QgKrISw+bDPG+QRL4x4PZmRF3knVCA8
 Gg+V8y5A==;
To: Andrew Morton <akpm@linux-foundation.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Evgeniy Dushistov <dushistov@mail.ru>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Mon, 16 Jan 2023 09:55:21 +0100
Message-id: <20230116085523.2343176-5-hch@lst.de>
X-Mailer: git-send-email 2.39.0
In-reply-to: <20230116085523.2343176-1-hch@lst.de>
References: <20230116085523.2343176-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10591
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 malwarescore=0
 bulkscore=0 phishscore=0 adultscore=0 priorityscore=0 lowpriorityscore=0
 mlxlogscore=483 mlxscore=0 impostorscore=0 spamscore=0 suspectscore=0
 clxscore=276 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301160065
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH 4/6] sysv: don't flush page immediately for
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
X-Proofpoint-GUID: b5Qd5vdMELa2agFA0YXcpPHKdLvi5A6v
X-Proofpoint-ORIG-GUID: b5Qd5vdMELa2agFA0YXcpPHKdLvi5A6v
Reporting-Meta:
 AAEjYhdOjgDA6VEfS04/4tcQu8BI6IeubDUIwZJ+sTI1dSWzpaxsx6UhxpKotcdO
 I5gFJb4w93S6y6XcZEh3fmyoTRVeNP1dvWsv7zWLYdmJnL1vD+5sYro3kPmpJQOz
 jSG44djkC/J59o9AGqJucKZyQ7ChNUGavRl7agPrWHcZQ8TDXhOmr9g0eUtOiquJ
 MIezsIZitZ9QgE/VFrCXTtOYvnBERVgCMBU3S7BJvwV9HxjKEDt+vokAziXeeI1A
 LT6Nu3fC176KNFmNkgPoLlGp/F8gZdordQUGj6pm0FoyoIyAnfXOGDqHkqrv8WS9
 59ZXjHp90CQkGnEBB9KH4hhubORcGum8xIB+jTo2QGQBoWcTHbNOGN/cSjomKPV/
 LwreVipZo9RAjepxdMi+JZXL0z0YrG8wosaRbqXtZzFucN7N2+PJoiwusvM4aLZ7
 jz6OOlP9X2YKiMB65Sba/JlFJQZk5iePR5rsnNPonRW1ywd2RkUup9knJZM0tMt+
 4Pt7y5hMiBctQDpHBY8qfE3mJ3sk7tXhLXcpHdUw6dJQ

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
