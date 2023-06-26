Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D736FEB64D7
	for <ocfs2-devel@archiver.kernel.org>; Mon, 26 Jun 2023 05:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=+GRT/r79h4UL043r6lhVPE4uE8EFrtgPcvxqouWWSgo=;
 b=sOaHB01wl27axd0+QYejPINaIf12roUG+Y35fdQP6PpQG7u8NEEzZ8sE1MAr1pcxN5mr0wTVLjo+
   amOnfuhJ1ziMvhrehYFY/hAYApF3dUSh6aKubsg8jOrHNsAQi2IV3/Ig1nokRynXlCUGkApqQ+SJ
   b6zGluAJmxXyISDMS+6Z6VvjnYXIB8ckNSEVKZqBIH00pG7JL0SSO54XqnzwzGJ4pKBVp8KEFWg9
   vsgRhNZP358HMjvuNnYzv6BSlvWZ9E0PZeivf8pjFTXrINV4iJjqkUVXynuwcUORVc39fMEa3d+k
   1ZkL/T6JI0HM1hLhQ+2trcvKLVfOu1uqHOB1Bw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=+GRT/r79h4UL043r6lhVPE4uE8EFrtgPcvxqouWWSgo=;
 b=urnYpXacGraDBgxMtUrhF9sjhf1i8tLt4XBOXQS+IC+nJaXoxBC4/fXNH73YXxO8UsKEUwPAhFIf
   dnEpe82TPIh3P1RVh0SW4CgrLIIfZ9lNfWy3D9cnhMfqUZiSL+Z2PJHGwmuxVrrVgd3Uzpa/mBE/
   4Z5qo+WPRt6vqEh7h20JESaFwsF9fGxG6oqTPIlJfN92jKoJyzwU2XvLIuuoFonqJATYG0TeC6Wg
   eZhBSgSGAuJw1tECwkZyjSUiE8gkSO0De56b7RKhIsAPBha5Jcpm+6v6F2JbF575zbzwruXEZn9K
   9eVSDycPNE7G6Wv7mnvoOVM6JG5XR8UZLgG4BQ==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230523 64bit (built May 23
 2023))
 with ESMTPS id <0RWU003LYJ4V2110@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 26 Jun 2023 05:55:43 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; t=1687758929; cv=none; d=strato.com;
 s=strato-dkim-0002;
 b=KCFHkdXuXKL614HKgnUoEQo7yk5SlN8MLjBfXPy/btdfqtXFebfa9OjuyKVQLDKMcH
 Boz9tXO+ikw7FG+5REewQvOYuNTaflP8xJrUgBQtvqe6YdeuCeNimCzCifVBsue27zG0
 eZVDK8ffkQ7Y9gGgmY2MZ1VgSsFbK6veYJ4TU4haP3LQyW4v9w+aqd2hukcUH///vBMr
 LkksbmUrQ2a7irthbgzUZVNx0tDRb/Jv/Sm6IJj4NadfKP1b9vTBgkgdyg8a1i0e8/1i
 J6EKL0YOPzjp6OaNXrFLSCvA+n7HxY4cIgn0LioYEd0L3l039BCS9MaCINdf9XZEONxw A6OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1687758929;
 s=strato-dkim-0002; d=strato.com;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
 From:Subject:Sender; bh=ESdM3OWkSgg54SJpW5SbnYofQslhV1eHwOkfE07L59Y=;
 b=Ade28D7DTus485H0MFvdFWP7KmZ6yYwRoKoimw5rTbRwoE/+KSEkDxBQhNvLjbIlfP
 JnAAIuPdbBfp6yaEPz+2KIGhnREnsaMLtcOd3skleoabaOQpEcG00f+2mwzP75Z/WB1V
 9opXd9RA1rqb01cCFLXH+BS5dGLujAGw5vHWlfYnRcpwkUjd71Hmvlo4lTojlZLkMLbE
 ZFvaUxqaSiN1UB3tcTzSOhh1TeK0wZwN2yUQrgBJ/KphS3PhFO5CFaRp7V06aovSVfFM
 PbwoC6p1GCRWC+Uhwp0CPYaUcFt//2ice21WT47+3VHmJQLkWC43ANyb8VCpFKy08eWB TkYA==
ARC-Authentication-results: i=1; strato.com;    arc=none;    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1687758929;
 s=strato-dkim-0002; d=iokpp.de;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
 From:Subject:Sender; bh=ESdM3OWkSgg54SJpW5SbnYofQslhV1eHwOkfE07L59Y=;
 b=Ts9OC6oNOUvl/4+ygsRV1kJUz8K7BS0lPa8ZLLFO1+7Y6j/9ef2ZAj2tjb5dKpnJM8
 us0LuNBMXyXjErDQ3qXOlp62fz0dYxH0t4L6f6FzQ29tjZYkXCkZZo1CGKyzHI9cURU0
 YaYVey3Uqe3UIMlZXEQjtKKFW1MKpWffOzn/MOLwV15UtqlZUWLWQci6wIAOIJJHCT7+
 zpXsyyLTlK7UNQXZ022I9+cASpOqWO2yrrl/5vDqwlmoftcemXNGtsJJ4/sCnJqKVpLN
 UaGVpQcV1sII29e2zk5xq9gXHm/QBN0PKQT/WxA0OpbFiFPb23m46Xglr+M8JgBCrWbV w43g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1687758929;
 s=strato-dkim-0003; d=iokpp.de;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
 From:Subject:Sender; bh=ESdM3OWkSgg54SJpW5SbnYofQslhV1eHwOkfE07L59Y=;
 b=H58EcjG+FiWUmSa6c8Umxj4arjvzkksYLVih8QEJGf9s04ldvSYFMdsTsiLCga3aWW
 WHeraGf7hjXyhyP5rbDQ==
To: viro@zeniv.linux.org.uk, brauner@kernel.org, akpm@linux-foundation.org,
 jack@suse.cz, jack@suse.com, tytso@mit.edu, adilger.kernel@dilger.ca,
 mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 willy@infradead.org, hch@infradead.org
Date: Mon, 26 Jun 2023 07:55:18 +0200
Message-id: <20230626055518.842392-3-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
In-reply-to: <20230626055518.842392-1-beanhuo@iokpp.de>
References: <20230626055518.842392-1-beanhuo@iokpp.de>
MIME-version: 1.0
X-Source-IP: 85.215.255.100
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10752
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 mlxscore=0 mlxlogscore=796 lowpriorityscore=0 phishscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 unknownsenderscore=20 priorityscore=181
 adultscore=0 clxscore=136 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2305260000 definitions=main-2306260053
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, beanhuo@micron.com
Subject: [Ocfs2-devel] [RESEND PATCH v3 2/2] fs: convert block_commit_write	to
 return void
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
X-RZG-CLASS-ID: mo03
X-RZG-AUTH:
 ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSedrgBzPc9DUyubU4DD1QLj68UeUr1+U1RrW5o+P9bSFaHg+gZu+uCjL2b+VQTRnVQrIOQ=="
X-ServerName: mo4-p03-ob.smtp.rzone.de
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-GUID: 8-s9j3VoC8bPBDKjzuWzlMY91iUS5D4i
X-Proofpoint-ORIG-GUID: 8-s9j3VoC8bPBDKjzuWzlMY91iUS5D4i
Reporting-Meta:
 AAE4gt6BjfJkhq4N/z9agZ5EDt5I/TaHAA4BNroyg5tyBAl9KoAKm2fmE0R24R7e
 Uoxq53/eHRZNksOqtXReqb6Djd/sCNM9I9nfOreMBVi8fz4qx14/ZfkMZ4imkypo
 p4efMtVmLZR1IBIXQ+Fz9z3vIzUEQAfJfuJWwwdGU2uIRqPWflPAqokQxf0PaSSm
 OIrihGXfjId3DzDZJ/PY8TKX2uIk9N+lARvk0N/kU6MVw4yeTjEmjFd3EL9PZlvs
 1aYnUY/x0YDCGHlJ6O+g+4euuKyYO6bQcr1dc9vXfp7mpR0ttma1IXnuHpg5yZhm
 rFcvWT6Tk8aoB/akWomyvXE6LSm9xTDf66w8o3zcGIiLMBGp8gkF2i5yHchgyYSK
 RbDxeAErxHaSYO6LXQfpSCgATWbpamZuzGSsHDFLcMEKeSqwGIQsFBNyDyooIaOH
 b1iJLCG+p0kwOuxqDZXRVsGTiTajesAu44awlVTeJPMiOE9cIcEfXrgzdw63B3r3
 mJqOkLWFHuemfn920dJVTO5IDC5WwhhqU4r+l76XetHG

From: Bean Huo <beanhuo@micron.com>

block_commit_write() always returns 0, this patch changes it to
return void.

Signed-off-by: Bean Huo <beanhuo@micron.com>
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
