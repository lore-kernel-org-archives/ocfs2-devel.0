Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.111
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793963723;
	b=hK2jpt+a404n8MQBz6UKrGisdMDh9zCTRGwnlFnq7Y8BbQ/hxYJuJhviOmoOhj5TC7Ve
	 P4eFHJU69u9ZeBmAHPp/A1Cw03KE8BOs0O6LB1Mk7Wc/8e7rT4JYEyJG/xrR51xqI5In8
	 w9IrZJmAbr+AspbgoW7jLdaV/EsRis3nrTNGuYgojZ4G4Nro0J1+vjmYTBfOT8m/sCB1S
	 gOCEObOkhUL8wFgKHw7OQBKOHtr+Nvceiu+ILfhSn3aqAn+dkTGA5Y5TiEbw2UJQb/ZIM
	 JcDWrPsmA5F7EBVpX0aosgz4oQAPn1nkvmBoYxadCeXX0hl8zTYI24eSKK8XaoE3j1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793963723;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=xZGCRzjF0Suob/TajMbYz0/O23Ff7/SeAE1sL/FDGf0=;
	b=PYmYvRenooYRQBN4WOYX+S6gGBu0XXkiQAWY4d00Su3/c542YoJA5ykWgzgD0D1I4D9A
	 bN4MLYKal7IQPMg07Ttx6hgWI2e8BPd7RZupAWlsfLQRX5gAC1FHNN6dJb9X5gCfT0i2f
	 oA5b6/wBLRa/rvTOOuiLcfA+4qsYJ5mMvEkiF7M/fwJVweSXBDbpDha7hNeua7hFQqqOv
	 i9Rf/cQS4bqMNWgUqi0yiSlQmTs3j2gQk3tx/WFizY4ItfAhdyc+cZ/m0ZupyqyH5ZbzX
	 ocoPjzS0MuQbALkc8w6IaSbyFfFfUs0So5Z3kI3RHJ15Y47L+MUEH8BeliGUDuu039Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=NwVNnxj6;
	arc=none smtp.remote-ip=115.124.30.111
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743AA60A2631
	for <ocfs2-devel@lists.linux.dev>; Fri,  6 Nov 2026 11:15:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 743AA60A2631
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=NwVNnxj6
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793963720; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=xZGCRzjF0Suob/TajMbYz0/O23Ff7/SeAE1sL/FDGf0=;
	b=NwVNnxj6aDOTUNkoKzqs9kVwhw3a5T2p4LjOaH6dhMP7whj1GW3nSyd+iPTNKTIcvwdLDvcK0mGcXTIKZo/DV3q32ZEqlv6z1LH7uVVksIdIfRCKSOdONCJ5oobjeLI+oe/dwZBKxbxW4AccBOP7gAK/JMpWJaymyOhQOdiovLo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R671e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XEBa-7a_1793963719;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEBa-7a_1793963719 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Nov 2026 19:15:19 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v2 22/31] ocfs2: report unrepairable corruption from online filecheck fix
Date: Fri,  6 Nov 2026 19:14:49 +0800
Message-Id: <20261106111458.1467464-23-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20261106111458.1467464-1-joseph.qi@linux.alibaba.com>
References: <20261106111458.1467464-1-joseph.qi@linux.alibaba.com>
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_filecheck_repair_inode_block() proceeds when validation fails but
then returns 0 unconditionally, after repairing only i_blkno,
fs_generation and l_next_free_rec.  An inode failing any other check is
reported to userspace as SUCCESS while still corrupt.  Revalidate after
the repairs and return the residual code.
Documentation/filesystems/ocfs2-online-filecheck.rst already describes
this: "the inode must first be checked for errors before performing a
final fix".

Returning an error from the validate callback is not free, though.
ocfs2_read_blocks() clears BH_Uptodate on failure, and
ocfs2_read_locked_inode() bails out before upgrading the cluster lock to
exclusive and calling ocfs2_write_block().  Simply revalidating at the
end would therefore leave a dirty non-uptodate buffer in the block device
cache: the next OCFS2_BH_IGNORE_CACHE read of that block sees
buffer_dirty(), skips submitting the read, and then fails -EIO on
!buffer_uptodate(), so later filecheck requests report FAILED instead of
the real reason.  The half repaired dinode, stamped with a freshly
computed ecc, would also be flushed by generic writeback without the
exclusive cluster lock.

Snapshot the block instead and only mark it dirty once the repaired
dinode validates.  On residual failure restore the snapshot and return
the error with the buffer clean, so the next read goes to disk as usual.
The snapshot covers the whole block rather than just the three repaired
fields, because ocfs2_validate_meta_ecc() mutates it in place while
attempting a hamming fix.

The ecc is recomputed before revalidating, otherwise a bad ecc would
always fail the revalidation and roll back the ecc repair itself.  Whether
it needs recomputing is taken from the initial validation's error code
rather than a second ocfs2_validate_meta_ecc() call, since any field
repair invalidates the ecc anyway.

Also guard the l_next_free_rec repair with a valid l_count.  Copying a
zero or oversized l_count into l_next_free_rec spread the corruption to a
second field and stamped it with a good ecc.

Inodes failing an unrepairable check now report INVALIDINO instead of
SUCCESS.  No new error code is introduced, so ocfs2_filecheck_errs[] and
its userspace-visible names are unchanged.  A failed repair no longer
leaves any modification behind, and revalidation runs the ecc check a
second time, which increments osb_ecc_stats again and emits a second
ocfs2_filecheck_validate_inode_block trace event per fix request.

Fixes: d56a8f32e4c6 ("ocfs2: check/fix inode block for online file check")
Cc: <stable@vger.kernel.org>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 52 +++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 49 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 9db147de1982..47b539edb764 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -2062,8 +2062,11 @@ static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
 {
 	int changed = 0;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)bh->b_data;
+	void *orig;
+	int rc;
 
-	if (!ocfs2_filecheck_validate_inode_block(sb, bh))
+	rc = ocfs2_filecheck_validate_inode_block(sb, bh);
+	if (!rc)
 		return 0;
 
 	trace_ocfs2_filecheck_repair_inode_block(
@@ -2097,6 +2100,16 @@ static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
 		return -OCFS2_FILECHECK_ERR_VALIDFLAG;
 	}
 
+	/*
+	 * Snapshot the whole block, not just the fields repaired below:
+	 * ocfs2_validate_meta_ecc() also mutates it in place while trying a
+	 * hamming fix, so a field by field undo would not restore it.
+	 */
+	orig = kmalloc(sb->s_blocksize, GFP_NOFS);
+	if (!orig)
+		return -OCFS2_FILECHECK_ERR_FAILED;
+	memcpy(orig, bh->b_data, sb->s_blocksize);
+
 	if (ocfs2_dinode_has_wrong_blkno(di, bh->b_blocknr)) {
 		di->i_blkno = cpu_to_le64(bh->b_blocknr);
 		changed = 1;
@@ -2115,7 +2128,14 @@ static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
 		     le32_to_cpu(di->i_fs_generation));
 	}
 
+	/*
+	 * Only copy l_count into l_next_free_rec when l_count itself is
+	 * sane, otherwise the repair would spread the corruption to a
+	 * second field and stamp it with a freshly computed ecc.
+	 */
 	if (ocfs2_dinode_has_extents(di) &&
+	    !ocfs2_dinode_has_zero_extent_count(di) &&
+	    !ocfs2_dinode_has_oversized_extent_count(sb, di) &&
 	    ocfs2_dinode_has_bad_extent_next_free(di)) {
 		di->id2.i_list.l_next_free_rec = di->id2.i_list.l_count;
 		changed = 1;
@@ -2125,14 +2145,40 @@ static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
 		     le16_to_cpu(di->id2.i_list.l_next_free_rec));
 	}
 
-	if (changed || ocfs2_validate_meta_ecc(sb, bh->b_data, &di->i_check)) {
+	/*
+	 * Recompute the ecc before revalidating, but do not mark the buffer
+	 * dirty yet.  The initial validation already told us whether the ecc
+	 * was bad, and any field repair above invalidates it anyway.
+	 */
+	if (changed || rc == -OCFS2_FILECHECK_ERR_BLOCKECC) {
 		ocfs2_compute_meta_ecc(sb, bh->b_data, &di->i_check);
-		mark_buffer_dirty(bh);
 		mlog(ML_ERROR,
 		     "Filecheck: reset dinode #%llu: compute meta ecc\n",
 		     (unsigned long long)bh->b_blocknr);
 	}
 
+	/*
+	 * Only i_blkno, fs_generation and l_next_free_rec are repairable, so
+	 * report whatever is still wrong instead of claiming success.
+	 *
+	 * Validate before dirtying.  ocfs2_read_blocks() clears BH_Uptodate
+	 * when the validate callback fails, and a dirty non-uptodate buffer
+	 * left in the block device cache makes every later
+	 * OCFS2_BH_IGNORE_CACHE read of this block skip the disk read and
+	 * fail with -EIO.  ocfs2_read_locked_inode() also bails out before
+	 * upgrading to an exclusive cluster lock and writing the block, so
+	 * the repair would be flushed later without that lock.  Roll back
+	 * instead, leaving the buffer clean.
+	 */
+	rc = ocfs2_filecheck_validate_inode_block(sb, bh);
+	if (rc) {
+		memcpy(bh->b_data, orig, sb->s_blocksize);
+		kfree(orig);
+		return rc;
+	}
+
+	mark_buffer_dirty(bh);
+	kfree(orig);
 	return 0;
 }
 
-- 
2.39.3

