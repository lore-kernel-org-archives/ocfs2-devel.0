Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5AF6C54EBE
	for <ocfs2-devel@archiver.kernel.org>; Sun,  8 Jan 2023 16:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=s+KBtfcRaVnOOVVZzz3Z+I1XODRoJF2pIwba/gH0iG0=;
 b=gQdZP++TNkLAbe5zkFQjuA0rmJLO1arbh6CudfQGdlq66v/RpF9VUAj8Wvofe88AGLJt0HeHIPg0
   zpGGQPRJwKCP41aGBbAN7mkZtYCJ+4LFkuK+/XgfjJ6NLn1BhtfRaQUdo10INndBwbya8pdZuxEC
   I5t6aEN/cCmo6ljXDKo7GB4XDJVDVibTgXhYyQNpGJBt59wC2omk45X/+DXBN7Td5a08oRHhk/Ch
   HsHl7MY+1KiI7D/MLOJlVbmKhY75Tb7Q5aO9EyesgPWgS+kVcEyYAog36p/KL2O/qteoMNg/uxAl
   tP9d4N968CpCLLdxd3LvEq56c7xYKC5tN72Bpw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=s+KBtfcRaVnOOVVZzz3Z+I1XODRoJF2pIwba/gH0iG0=;
 b=pQlLjl5OACNIRNtCrZV3TvyaDZ26rFDQceQtqEmT1x0TlkEwGS9G1S54PVkp75Z7aYKIZPYCQttj
   9onrPeDl+eZOdUlzWjp9AXh4Sew4Wy+Y75PxLp9m4Kb2Ubn1gHpJoODzNNOFE7JYYuMxNYOoG0Ns
   MiHJvczgW+Is/3YyBglf3CGVcYgTQB9o5+93PbHruhUoUulYRXlC2zJn9SUuKHz5KXTMXeITkSID
   +XcpKhxf+wf/S/KaeQxvQqEC0S/carGDURjQGFVbxRQOuXv7S875dpiyWAqsy3eLmLh8Q0mK9GmR
   /QTm4aLaSagcU6YAcD1bh9PTsdXVyFlyTrXioA==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0RO600KI9F3SC3A0@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Sun, 08 Jan 2023 16:57:28 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
 :Reply-To:Content-Type:Content-ID:Content-Description;
 bh=w04Rctw8qyCjwLO2i1OjkI+LN8twYupiOrnbVDTEa+0=; b=3xxKbUYOQBIbQYRO8w6HvdN1R4
 9OQTx9rAbhFdmf+fGmYydYTlIuwJkr3F4bGLLwPJxxUSG0Uwx2aYZvNXu9JdVOqkigNLVSMVUnDIE
 Psz+/plZU4G45A3la//6lBz9RAD3770Mote9HxQPVLHNRllqYg4M2m23173VtyGQo1F73drNUgmeW
 tbNy3JqZ6/44QmJbTmELuKvI/sJbV+e/ZzhVrXUj82kr1WETchKqaxpv82mrFBTS4cyy/ReyZU8N+
 YsqCclyRwnDWYY6aAcNiM4Zo29IqQ4Vx8WyirZV+wC4u9rt5mnPNCpuwYKtyXQJjKrUS4Sd+CfwVD
 k1TB835w==;
To: Andrew Morton <akpm@linux-foundation.org>, Chris Mason <clm@fb.com>,
 Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
 Dave Kleikamp <shaggy@kernel.org>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Evgeniy Dushistov <dushistov@mail.ru>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Sun,  8 Jan 2023 17:56:41 +0100
Message-id: <20230108165645.381077-4-hch@lst.de>
X-Mailer: git-send-email 2.35.1
In-reply-to: <20230108165645.381077-1-hch@lst.de>
References: <20230108165645.381077-1-hch@lst.de>
MIME-version: 1.0
X-Source-IP: 198.137.202.133
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10584
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 clxscore=301
 spamscore=0 phishscore=0 priorityscore=60 lowpriorityscore=0 mlxscore=0
 malwarescore=0 adultscore=0 bulkscore=0 impostorscore=0 mlxlogscore=545
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301080126
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 jfs-discussion@lists.sourceforge.net, ocfs2-devel@oss.oracle.com,
 linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH 3/7] minix: don't flush page immediately for
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
X-Proofpoint-GUID: CDKisM3cgsgMJcOmdVCiyqrAW_K5HRot
X-Proofpoint-ORIG-GUID: CDKisM3cgsgMJcOmdVCiyqrAW_K5HRot
Reporting-Meta:
 AAGfAWcuTdqMkV1b6n/Db34FieZRjQfxJw08BfmITaPN7a4S2Ekuhgxlg03zFhEP
 w5Wjtdbo6nH7WHMBD0e30IRdQkJTQB4s8bD/4lyTBDyPcGrsNkBAnScp6WMlLnI5
 Pu5w4ExauhUwTHaDYigt012gu8nhiAqAfjeUmapWb/3zRS7bJV3VxCGXSWJQtYQT
 FamkQEDT+GbKtmSMONU1AlosR2u0QY+A/29veCytW3pPKXihD7rQob8uxRTE1lAh
 vi6Ui2gucMLl+Vng6snuzpu92NtpeXzxZQm+CMx/AcXhg+1+sfrGXxBFPMBbd8kb
 RawLQpV+AXfkbf4B+hp0y/FlbJySUqQW5yZt23kpL/pJvydKYYEYRqNGbzv5IcXW
 pa8g2oLrvZJK14d9/26zJg4/Zs5CHegMF1r1LjmSCStz8Lu0jAwgr1OvBUSzP7Xh
 W9OHcRkoYJjgZN9+149MbJYaN7IKfcPtiOT56bbFZhU97akbE3ZReM8TaqKn+0KC
 aI0pkOlkvJfcMgSk7VHzgmstxjQStHnNJ0HdKSxxds5E

We do not need to writeout modified directory blocks immediately when
modifying them while the page is locked. It is enough to do the flush
somewhat later which has the added benefit that inode times can be
flushed as well. It also allows us to stop depending on
write_one_page() function.

Ported from an ext2 patch by Jan Kara.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/minix/dir.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/fs/minix/dir.c b/fs/minix/dir.c
index dcfe5b25378b54..d48b09271dc48f 100644
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
+	minix_handle_dirsync(dir);
 out_put:
 	dir_put_page(page);
 out:
@@ -302,13 +309,15 @@ int minix_delete_entry(struct minix_dir_entry *de, struct page *page)
 			((minix3_dirent *) de)->inode = 0;
 		else
 			de->inode = 0;
-		err = dir_commit_chunk(page, pos, len);
+		dir_commit_chunk(page, pos, len);
 	} else {
 		unlock_page(page);
 	}
 	dir_put_page(page);
 	inode->i_ctime = inode->i_mtime = current_time(inode);
 	mark_inode_dirty(inode);
+	if (!err)
+		err = minix_handle_dirsync(inode);
 	return err;
 }
 
@@ -349,7 +358,8 @@ int minix_make_empty(struct inode *inode, struct inode *dir)
 	}
 	kunmap_atomic(kaddr);
 
-	err = dir_commit_chunk(page, 0, 2 * sbi->s_dirsize);
+	dir_commit_chunk(page, 0, 2 * sbi->s_dirsize);
+	err = minix_handle_dirsync(inode);
 fail:
 	put_page(page);
 	return err;
@@ -426,7 +436,7 @@ void minix_set_link(struct minix_dir_entry *de, struct page *page,
 			((minix3_dirent *) de)->inode = inode->i_ino;
 		else
 			de->inode = inode->i_ino;
-		err = dir_commit_chunk(page, pos, sbi->s_dirsize);
+		dir_commit_chunk(page, pos, sbi->s_dirsize);
 	} else {
 		unlock_page(page);
 	}
-- 
2.35.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
