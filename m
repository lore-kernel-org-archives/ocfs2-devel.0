Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc251.phx1.oracleemaildelivery.com (aib29ajc251.phx1.oracleemaildelivery.com [192.29.103.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFCDEC54EBD
	for <ocfs2-devel@archiver.kernel.org>; Sun,  8 Jan 2023 16:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Lw9djdnQibzTES31sAfzBzyuXksmcG0q056leQVmjVs=;
 b=Nu4a30JqHwsCfKz/90/LSFIEqfN6i6MQsV+Cczsj6He3Rzth2n6wocvviFIOkVyNcyxZot5nDRNy
   A7l5B5q+7lK0pyGotZ2/xmqP+ael193OQjnMqvCCY519hicrN03Pckj5BOg+P3wSb73Gx1cbcPKJ
   1E+S/4/pOuwrHGo07tiiVy/cVprSH0m+sO5dcg/CvKVOSMXb2/QHSH3toLYKhQOqbLAjrUINXo7j
   tX2nsCRKnHhev0KgrltsXlkZrt2/AaIiGZTI/Kkw87YuiRewzFz/Mq72QGqN7Rkb5XTNLyoE10ad
   QrNpb1/zgwdIiBp8AFS1xds/fwcO4X51vB2wMA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=Lw9djdnQibzTES31sAfzBzyuXksmcG0q056leQVmjVs=;
 b=HzEL3PkHh/2Usz58dFGTb5F0DxaX1duP/CFHanYYJ2YD3IVpBXeNWXgYGDNhBuQgtv1+NuHz4BNr
   Ftvo/fzeKjC+MPliwz4MbElLonhFDYQ60hZ+IsC26C0wjdkE8v9Y4Ox5ICSODDf04YPits71N3mJ
   0TCBUeO5svunD+8aZsS+I/YCWuJGaysz1Z6kRz2o3VFC0O+HCFLIlQIDppjnp3r4Dar9pKGnwNtB
   9ejIrkdVXy6xXGHbcsiGVSbammiIisjTLMIs5OkJbmAp8aKuFVmTWN7FTCIRfXMdieQc3oQa85hW
   +NhvypRSPZ0OkfWNs7xJLx3LME7/BJd39dtXig==
Received: by omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0RO600L4CF3XMCF0@omta-ad2-fd3-202-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 08 Jan 2023 16:57:33 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=oMPhLOYpJNBqa4dwFa8oL6UthrVrVH8Rk8f8kVGsTX8=; b=PKwRols7MQFA6r90zKuNxTrBwU
 rDshHiaWkYRgvGWSV5BX9ARC7MnPg6FQjItWl5iozMErhRr/Myxp7ECTVJlvIhcjk2Vg/2LTqbzNh
 88GmfJGxKVNRHcx2n7V9pWxYXUFEFMMmqXaMPAjXflzSLusxgchlMH5lAKPklqrMQsPKoIGsEjeOl
 amYtRU5bsHvGaTKx7PCEiCK91nyhaRkzZmd/GYz/MD+VwBAYP+oqFKTZfqNTMsoDUniL2++T+s5Wt
 TsUxel7JrvdxmSTtPAyuHGghIaZzQSAvOeMlwx5HJY49qQL0jDsVZaUe43cAoHOWJHlgEg8Fb6fd2
 tQphvRNg==;
To: Andrew Morton <akpm@linux-foundation.org>, Chris Mason <clm@fb.com>,
 Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
 Dave Kleikamp <shaggy@kernel.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Evgeniy Dushistov <dushistov@mail.ru>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Sun,  8 Jan 2023 17:56:43 +0100
Message-id: <20230108165645.381077-6-hch@lst.de>
X-Mailer: git-send-email 2.35.1
In-reply-to: <20230108165645.381077-1-hch@lst.de>
References: <20230108165645.381077-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10584
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=273
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=419 spamscore=0
 phishscore=0 impostorscore=0 malwarescore=0 priorityscore=156 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301080126
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 jfs-discussion@lists.sourceforge.net, ocfs2-devel@oss.oracle.com,
 linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH 5/7] ufs: don't flush page immediately for
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
X-Proofpoint-GUID: RZFG15KnYiNmVIAkhd_HE_oFrtMAzuOZ
X-Proofpoint-ORIG-GUID: RZFG15KnYiNmVIAkhd_HE_oFrtMAzuOZ
Reporting-Meta:
 AAFeRtKARYZgCRCLmbX6IPTWZQyYtzAswwO1LiZwnZ3x9BLsYll47Hpfc5HkeNlM
 hjcbUJnNeBeGdCma196ijrrCf1wwCDQSp8ebHiHOuxnriuPkXSC521sg088J+FdJ
 TRv0t1kvCHOMO/DVz4TLNYaoRANQycNvVw/soD5fSUcFPQLOG9W/uwGexzdvJozv
 RR7hWrgvUsq7WLSOqb5sCuRE086QYV5uIOJ0Gv7a9l7r58TRgfhjoa+k7fDgImN4
 1pn/q4wz1incoFX8gtwLS6WOy35J4EwJZn+sI118jMdlODPBsOrHVF1lZeQiRT0K
 1aKobTQ8mq/q1no88cs6uShmNmNoE4qI+NkXQOCm3tjvbwGxhg92sSuoT7QnPhAn
 Lz6KqQoLM77k43iici6VVNCaOGcdFuZSVO9oIs3o99bfh74UDm6fCCQWTg0DDrPt
 bIK6V/kqY+9tjkxQhPbJAn6Tsc0K/Du7jqdvsXZIqVvaqSkq0fXgFiAQzl6J6MZq
 dT2IfmkT/n16LGs7R07RAx7gXo1I86ZkG19RPZ07pbg=

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
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
