Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc252.phx1.oracleemaildelivery.com (aib29ajc252.phx1.oracleemaildelivery.com [192.29.103.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99C35EB64D7
	for <ocfs2-devel@archiver.kernel.org>; Mon, 26 Jun 2023 05:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=SK95j2tuZC6vZfIq2qO3BKIER3tqAxvbEIyhBEeKgA8=;
 b=QjRE+W0pQLn7wV/c7eeSOpgcuS93f6db9dIPgfH/WvmGA/DjJkm1L7pmiPCbY6cvkgkMJD6myopo
   +2muHI4bR2NLYs4PzM26KCsJAyMNWU/3TtigjzaYSdPuDb1GGmsprgr3bkzc9qDVFnGLc4M+9RRX
   KEMGv/lr3eoFWQuYbK2kqxmU7WxoF8v3IXhbM4PaUyimVTJ7pnhrdzdCxozg/zpu1jTEdhBmzI95
   7+gaB+Waw9GEdfL11WnxJ3s5En1IdA/pSekDFLqc1so5v+AdTC4XcH4tSG0NKqpah7AoMBiNhT0d
   bkS239NAkcByB+DgLSKGPmsG/RnG9n4SveD/lw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=SK95j2tuZC6vZfIq2qO3BKIER3tqAxvbEIyhBEeKgA8=;
 b=rm+YVHf4L2MiYmgVJN+X7CweOw1yORsHrk+bbDch/ZKcZ+h5mC+9iSij8B/TY4I8HJjuiTX/auef
   Du+FeDcdc2T3otoKatLgUsSIJFw8+kQA6Ra6+hXVeBq6wyo8mhGza+swklCyNIVQiKRhtaHzqCGJ
   9FSkKcWa5zDXmF+ruWm/4qdmTNdMPAH3gjIPhR3zhhOcZZI6oNxWM7bMo0w8iAHnB9Q7BqzAE4ge
   AMG6yhj/c3EBOxY/OfctczOqMC6o25/EAMbu/NO/8JKJPeQF/xFMy9bugl898vlhm9+UZDZZBQTy
   +l//t0sfDuqQin/vpZq6AzIuzJBUvl3+ER2g8w==
Received: by omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWU00LQQIIXGA80@omta-ad3-fd1-301-us-phoenix-1.omtaad3.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 26 Jun 2023 05:42:33 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; t=1687758123; cv=none; d=strato.com;
 s=strato-dkim-0002;
 b=bnJRzWfzHwjyB7ocNXxbvZ76SzDqFZN/I4n6xQ/j31yApH1TFFzJoqny3ZUswsXekA
 dEfeYFs0XkDl08jamZyv7Q17VemdpiIe7idJ9r7c7kRMDmRDBspOSdwIRW1d/S9LIa9k
 EQDLecC+wWw22gX2nDwWCw++AOgqpDvAzThjbuv9fTEhb7yDkHz7TfFjPPSWJl2Sf6e8
 4cGxoikplIRjy5lQrzuSpSQc0nAV8nk76h+7+s9latytYAd5EJTyU4gz9nP7KtHCsVPl
 VTSo/N38sS2SB5CkLpm5kIlNz4Y3lNey5Fs4QziOjjkiN272YIQumuuPN+B8aU32l0jm kTUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1687758123;
 s=strato-dkim-0002; d=strato.com;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
 From:Subject:Sender; bh=A/OYsWzLIZKxnT1gYGuMS7er5Q0yQLzWN1fJj1HH19U=;
 b=RIl8OAFYRJ7KsB1WkyllCOnDwVeEU/vor31scEtqwExfEomdiUlgO78z0dilwdLgls
 qo9jMu35Is7LYXO49JsxWy4fK8hYoZEhSH/8oyK7EySOPBqNwz+2ujnLLWDXuIQG8giJ
 6U56Qwf3UPkJutNlkZ13wskz4bcs5JJg31gDTZ4FtH7cDCDnP12fAB8nmMolrC3f2I1n
 CMDsfIIwBBTnWLuzekbvzyYpVSuMwJ+s3Dl50VcXxJI00pdb2puaHqA990yPqE0PpBnQ
 PyH2J1Hu3RoTh/oG/X8DxcvEWChQY/oAqfrvNO1akiRN/QC2BN/LzpRGqiJGG7XPwvEI R79Q==
ARC-Authentication-results: i=1; strato.com;    arc=none;    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1687758123;
 s=strato-dkim-0002; d=iokpp.de;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
 From:Subject:Sender; bh=A/OYsWzLIZKxnT1gYGuMS7er5Q0yQLzWN1fJj1HH19U=;
 b=NfcZcgTIIC8nSgDtlQSSa/VC0elwH/QlqHg71C486VKy72d36LtSjg9h1Jj4rHJnYZ
 QXUVsE30iG4+Qqx/pTlHI8PJdDwWv9S4ylRm2pUujvLRhmKKNlG4kElEbQYvgV+kqBFQ
 0I/MbWxALI2QqKHmgy3uQVeRd9hbyjUke/3P4DY3qAMFa6vBJP0hai0mqEYZP1++YQc8
 YMiWMxbiQZz03BatPwROeGyPG3krTB6pPFHdMpSaYmek8ML9RqxrxNI8991xSrtwwJno
 c5bs6usNL532qxfxnnYxusV3a88v/zAKC7cpTbiM/hoVhE+9nFJJcm2/vvpXcWKJkOrU JQKQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1687758123;
 s=strato-dkim-0003; d=iokpp.de;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
 From:Subject:Sender; bh=A/OYsWzLIZKxnT1gYGuMS7er5Q0yQLzWN1fJj1HH19U=;
 b=SF1SPiN2eE0txi4FPUdYG5FT1wVWtyEx21AJODjSRBmvV7KGi6Vt+/ekcbZhmVZLju
 7KjrV69IoWMcH5mtFTBw==
To: viro@zeniv.linux.org.uk, brauner@kernel.org, akpm@linux-foundation.org,
 jack@suse.cz, jack@suse.com, tytso@mit.edu, adilger.kernel@dilger.ca,
 mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 willy@infradead.org, hch@infradead.org
Date: Mon, 26 Jun 2023 07:41:53 +0200
Message-id: <20230626054153.839672-3-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
In-reply-to: <20230626054153.839672-1-beanhuo@iokpp.de>
References: <20230626054153.839672-1-beanhuo@iokpp.de>
MIME-version: 1.0
X-Source-IP: 85.215.255.83
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10752
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 mlxscore=0 mlxlogscore=796 lowpriorityscore=0 phishscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 priorityscore=0 adultscore=0 clxscore=110
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306260051
Cc: linux-kernel@vger.kernel.org, Bean Huo <beanhuo@iokpp.de>,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 ocfs2-devel@oss.oracle.com, beanhuo@micron.com
Subject: [Ocfs2-devel] [PATCH v3 2/2] fs: convert block_commit_write to	return
 void
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
From: Bean Huo via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Bean Huo <beanhuo@iokpp.de>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-RZG-CLASS-ID: mo02
X-RZG-AUTH:
 ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSedrgBzPc9DUyubU4DD1QLj68UeUr1+U1RrW5o+P9bSFaHg+gZu+uCjL2b+VQTRnVQrIOQ=="
X-ServerName: mo4-p02-ob.smtp.rzone.de
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-ORIG-GUID: HvCseG7aL3SES3fg-qmJw49E-5703gRW
X-Proofpoint-GUID: HvCseG7aL3SES3fg-qmJw49E-5703gRW
Reporting-Meta:
 AAHc49slmunvD69zj5tpO4q5g4TOAefVzHRUMTJKyHGIBDiBygAPZSEH6UYt3WbJ
 G/OjADulN/KXuCuF9LYBXaCu2c7YhnYECBMoY1ESklNrAzjqYR6NfKdEE1TtvpsU
 B9H28vn4Bs9hV0xufSVSr5C2AwPsQRmlDevFwlSsLabD5UF+vcTKPIzefSi4HXbL
 XvUkjlHtSX4lCvsXli3KAIzd0iVLcEa6LOhnVztgKxQSq5/c/qSXgyz9Ov5MU3sz
 yNOIeCKsH0qyGQoh8nDyGB7gxOF7Wege9bVJ/Dc+zP++jazXDOo6r9UoopnQzq/D
 P1aIhtPhdq/uluVMVkXWLk3AKEXHYmKJRToQvu4n9Jywtvt4oVMR5wnOlrYg8YBY
 ZnARNVzHDjrfUs01Trawgf7BSpdftZQTDBwN4TVFTXwmv1Y0uxvV3J7tpyOeKjpM
 wYkrcZ28p4Jf6A0QG9AVUN68lc4xsus6DtM8FYd9+DC95rO/GMYor76PeO/aoZ0f
 tYLD/iWvI0AefxZq5U7C+APQWSrbv33o/+NL+vPZqAI=

From: Bean Huo <beanhuo@micron.com>

From: Bean Huo <beanhuo@iokpp.de>

block_commit_write() always returns 0, this patch changes it to
return void.

Signed-off-by: Bean Huo <beanhuo@iokpp.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/buffer.c                 | 14 ++++++--------
 fs/ext4/move_extent.c       |  7 ++-----
 fs/ocfs2/file.c             |  7 +------
 fs/udf/file.c               |  6 +++---
 include/linux/buffer_head.h |  2 +-
 5 files changed, 13 insertions(+), 23 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 50821dfb02f7..1568d0c9942d 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2180,7 +2180,7 @@ int __block_write_begin(struct page *page, loff_t pos, unsigned len,
 }
 EXPORT_SYMBOL(__block_write_begin);
 
-static int __block_commit_write(struct folio *folio, size_t from, size_t to)
+static void __block_commit_write(struct folio *folio, size_t from, size_t to)
 {
 	size_t block_start, block_end;
 	bool partial = false;
@@ -2215,7 +2215,6 @@ static int __block_commit_write(struct folio *folio, size_t from, size_t to)
 	 */
 	if (!partial)
 		folio_mark_uptodate(folio);
-	return 0;
 }
 
 /*
@@ -2597,11 +2596,10 @@ int cont_write_begin(struct file *file, struct address_space *mapping,
 }
 EXPORT_SYMBOL(cont_write_begin);
 
-int block_commit_write(struct page *page, unsigned from, unsigned to)
+void block_commit_write(struct page *page, unsigned from, unsigned to)
 {
 	struct folio *folio = page_folio(page);
 	__block_commit_write(folio, from, to);
-	return 0;
 }
 EXPORT_SYMBOL(block_commit_write);
 
@@ -2647,11 +2645,11 @@ int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 		end = size - folio_pos(folio);
 
 	ret = __block_write_begin_int(folio, 0, end, get_block, NULL);
-	if (!ret)
-		ret = __block_commit_write(folio, 0, end);
+	if (unlikely(ret))
+		 goto out_unlock;
+
+	__block_commit_write(folio, 0, end);
 
-	if (unlikely(ret < 0))
-		goto out_unlock;
 	folio_mark_dirty(folio);
 	folio_wait_stable(folio);
 	return 0;
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index b5af2fc03b2f..f4b4861a74ee 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -392,14 +392,11 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
 	for (i = 0; i < block_len_in_page; i++) {
 		*err = ext4_get_block(orig_inode, orig_blk_offset + i, bh, 0);
 		if (*err < 0)
-			break;
+			goto repair_branches;
 		bh = bh->b_this_page;
 	}
-	if (!*err)
-		*err = block_commit_write(&folio[0]->page, from, from + replaced_size);
 
-	if (unlikely(*err < 0))
-		goto repair_branches;
+	block_commit_write(&folio[0]->page, from, from + replaced_size);
 
 	/* Even in case of data=writeback it is reasonable to pin
 	 * inode to transaction, to prevent unexpected data loss */
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 91a194596552..9e417cd4fd16 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -808,12 +808,7 @@ static int ocfs2_write_zero_page(struct inode *inode, u64 abs_from,
 
 
 		/* must not update i_size! */
-		ret = block_commit_write(page, block_start + 1,
-					 block_start + 1);
-		if (ret < 0)
-			mlog_errno(ret);
-		else
-			ret = 0;
+		block_commit_write(page, block_start + 1, block_start + 1);
 	}
 
 	/*
diff --git a/fs/udf/file.c b/fs/udf/file.c
index 243840dc83ad..0292d75e60cc 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -63,13 +63,13 @@ static vm_fault_t udf_page_mkwrite(struct vm_fault *vmf)
 	else
 		end = PAGE_SIZE;
 	err = __block_write_begin(page, 0, end, udf_get_block);
-	if (!err)
-		err = block_commit_write(page, 0, end);
-	if (err < 0) {
+	if (err) {
 		unlock_page(page);
 		ret = block_page_mkwrite_return(err);
 		goto out_unlock;
 	}
+
+	block_commit_write(page, 0, end);
 out_dirty:
 	set_page_dirty(page);
 	wait_for_stable_page(page);
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 6cb3e9af78c9..a7377877ff4e 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -288,7 +288,7 @@ int cont_write_begin(struct file *, struct address_space *, loff_t,
 			unsigned, struct page **, void **,
 			get_block_t *, loff_t *);
 int generic_cont_expand_simple(struct inode *inode, loff_t size);
-int block_commit_write(struct page *page, unsigned from, unsigned to);
+void block_commit_write(struct page *page, unsigned int from, unsigned int to);
 int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 				get_block_t get_block);
 /* Convert errno to return value from ->page_mkwrite() call */
-- 
2.34.1


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
