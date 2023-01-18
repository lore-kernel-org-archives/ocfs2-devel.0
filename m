Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FB7AC678DB
	for <ocfs2-devel@archiver.kernel.org>; Wed, 18 Jan 2023 17:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=xyzvg/rCCly/SrrfRleNW2jwCQ0kCf7XT3oFjPPb4Ao=;
 b=zGqMEYPNK/XN2TrPGkJTsj5AekOhHligG+K41g+UWm4jF1ZE9l6PAc4+YZE628fz4KKlyTpStMS3
   C/Z7eTMheNY8B6uU9h1oyJclY2c8CLzH7Livt07cwJ4vdLtSXPj50zb8hMCeKUUt/BzBcK/yF5Nm
   pPHbK96xWGDyDFfWDlzkIpwCjQ9BrgkYsOKpeO2rt5PonKyFARJVBYY4bIYLrP4HvnYil6+WUFNO
   hbOJOccTz5ogg/DaJTSbb2m0fhxSjdDRQ1AOG+yfNl/bSI79EsG/D5hf67WCSH3hbS1l8lYDw0CQ
   DUOjZh8e1xYpCrcJljzpWWa40VWJgpE0WDrKRg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=xyzvg/rCCly/SrrfRleNW2jwCQ0kCf7XT3oFjPPb4Ao=;
 b=tqyNZgm82qhRMw0hC3E6QZ658Z+l6LyqyP1urgwcQMG1L9+bLRWDXC9nxMNOnhqZ3JwNF+vp6Red
   zR+a4JoRGWriy+FQMZJaBOB86uiRSx9czhCYKkX7z1b13cXUrTCo0IHWPpZqk7i49yU1INBEHKUI
   LQ722T0PINJDEJ8HJX+1S3/5RI7+ptW0p/st+Eo5aAGWPx5lEHn1dfwWG8u67TQOoWq5Q063Y0/e
   pwEpRCdogaMMAsb2eXTrPiQB4gcceCmrdpDnQcOG+xnrhW/9L/05nzOaSV/W4DQekA8bBuArKBQN
   dj+onA7QYoAo6Pkm0+7mbpMipeRe2mwnbcJJQw==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0ROO005SQZBTBR00@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 18 Jan 2023 17:31:05 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=v3PglRWzIOokZtWskK857KErIsUBx1dUWoEIj+rmors=; b=U05qheovgxBUbMhTKKemw5ZM2W
 +lw1zqiSw0fTKUbYGe4qcdGWpVpSVtuCixVD8X05UaJPzH0rV12qgPwg6yrdCoj58546B7wZkvItN
 aFBV6i6UuPYSTlEDevcYjEqKtWYeXCL9YJuF2o0ktbYV85kZYtLzrPpqLCUnrQOdm9tdrLM0zEJTT
 YGK7YdkqWaEvFJ/1iWN+aLUbVyyZE/fW3pvAcev6gYBqg4UUNvQ7LL3/j/TMEsY9lwC2STBR+1xQ3
 OAGX583TWkypdhRyd5ZIFMj5ZNc1iYMPGalHjY5KsPCHBup21MLTKOruniP8ileEqsqVnakRllDNF
 lm4B09wg==;
To: Andrew Morton <akpm@linux-foundation.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Evgeniy Dushistov <dushistov@mail.ru>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Wed, 18 Jan 2023 18:30:26 +0100
Message-id: <20230118173027.294869-7-hch@lst.de>
X-Mailer: git-send-email 2.39.0
In-reply-to: <20230118173027.294869-1-hch@lst.de>
References: <20230118173027.294869-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10594
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 bulkscore=0
 adultscore=0 impostorscore=0 phishscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=184 priorityscore=0 mlxscore=0 spamscore=0
 mlxlogscore=416 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301180148
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH 6/7] ufs: don't flush page immediately for
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
X-Proofpoint-GUID: KVuykJSwydx4_jvdcZcxT23HLiuN9Z3n
X-Proofpoint-ORIG-GUID: KVuykJSwydx4_jvdcZcxT23HLiuN9Z3n
Reporting-Meta:
 AAEW5g+1e6Jr/1cRe95bTspHdlJLgYjsE32pYrSU2yNlNa1ff1DlOpYPWxamsKYz
 hlubtFaDqLsMSEBSdZaDEK5pw1DjoCV7m3bmquxrbD/wWJ+4AD815eUhWexkNW6E
 DN6n+lCUc+2odbEFPs8IfKoJmcGgpQbY0HuQujfJhv7xWwKrtC0kp3VX6q4sAuEP
 iYrJXrwm5Enl52WMMRBY5kIThF3DNRfh7VRfLrfAlTm6VA1nLzq9MbqGsGm/vBW+
 Wv/i+hpLHVQTDnCYTAGIIjtcSAEpW4a5ge4oj8t5tvC1+DXq0f+QtmI1cK9oq0GB
 63B6k+bKVaxPO1AN0B0hMqZd4uzkx3bJvr2w8P6JwXdyYA17AZG/G8e2cArKYqyG
 NJSR8ZtxQ68zpb2ylj6vNPW4fmrzGxYk5OV51iUQZ9hXqnfgNtgdK/C1i/7C6EMA
 xOlGS1gAnJz+qX/D/B/e8jkYZaINUzcF8u9wvVL04gOcdwKxIdTWsuRT+X9TbU/W
 NBU+v5Bsj/3iRj7qu7xQt1KvnxLepCvmUPHutBDwbLeK

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
2.39.0


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
