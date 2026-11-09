Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794226935;
	b=yZr0JrNBP3X34U7i2YyHbI7bwDecncE44cm32MdTryJEcBsmosGpzruZnsYCN8nKGJMQ
	 2qAK8rUuj4HHHC8cXnrWKN7F7i1r2BrtyU4Kdjk2FUXr03YxuXl3dQV7qZ2yzhTQHIjZp
	 bkEsxZWq3lRBE9XL7C4Mw7YFdCpS495MAaPZcC3KOXg4z7SZm7cy8egfiAH0NPXtr9pHl
	 ERAaqWUxFrihnni+ygCCC95sCe108HyYoEm4cNIj6OfWv6X4GaTS0Yy2s0IOrgmlLf+sw
	 zJu9R+1Ns+v8AwfHBx007qU+kVuZ4bv9/6OEm5LW9hDNPguoszuRrZ1Sm/hlXUqbDeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794226935;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=t1jr+N8q/84nj0SkOO7CwCiAwfsp+2LZnqxc1s5AnwM=;
	b=Hi1CrM6fp6+FKJ82CzqMo0wMInU2GK/HPZvVpC4Jijqywa70KMm+ot63LW9gBcNsXEIV
	 qbvndUkF0Z2TT56JcSyJmUNzkvaodjn1qLVytFT8ThHd+bJ+U8dr93qvAqUAZLR69FQyH
	 TJ+Mkr6ksVuxYTBzpt9RHY5QRv8xozHXK26dEGYf3KhlP1ngk4vCYqr3RVw8n7GEXMtFv
	 Hns8BvH+l3X3tfuLuTDYxfB1OM+gw0XSEYMCqCGK6v8mcX/OTTRmBK/SfEyw86SDo4/SN
	 /pQb43EUEslDP9lIZli+gf/TmcLmTdBwUnfCJHG41gDPPKd4K4J5M3EIcwDL4A66K4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=RZCS3Uz8;
	arc=none smtp.remote-ip=115.124.30.133
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D80606EE87
	for <ocfs2-devel@lists.linux.dev>; Mon,  9 Nov 2026 12:22:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C1D80606EE87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=RZCS3Uz8
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794226928; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=t1jr+N8q/84nj0SkOO7CwCiAwfsp+2LZnqxc1s5AnwM=;
	b=RZCS3Uz8lBeZ5aKaF/QmaOjSeohDeso3GJUGRuMQf95YcNujjgNdzNfIqU4+H/61WgmsLtZXzfHUaBnPnjMlsK4PXbL4NN0EoNRObrWdxASlqmYxUFMIDGKvgDeQ3AFxi0fvPma2/Rcc5PECR8GSvV7780CAxC0PUlSdWZLMdDI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0XEP8auu_1794226927;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEP8auu_1794226927 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 09 Nov 2026 20:22:08 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	stable@vger.kernel.org
Subject: [PATCH v3 22/31] ocfs2: report unrepairable corruption from online filecheck fix
Date: Mon,  9 Nov 2026 20:21:12 +0800
Message-Id: <20261109122121.21473-23-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20261109122121.21473-1-joseph.qi@linux.alibaba.com>
References: <20261109122121.21473-1-joseph.qi@linux.alibaba.com>
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
Every early return restores it too, including the readonly and jbd gates.

Take the snapshot before the initial validation rather than after it.
ocfs2_validate_meta_ecc() -> ocfs2_block_check_validate() applies a
hamming fixup in place and restores only the ocfs2_block_check field on
the way out, so when the post-fix crc32 still fails the flipped bit stays
in bh->b_data and a later snapshot would record it.  Undo that flip
before repairing fields when the initial validation reported BLOCKECC:
the fixup did not produce a crc32 valid block, so the bit is bogus and
recomputing the ecc over it would stamp the corruption with a valid
checksum.  An ecc check that passed leaves good data behind, a successful
single bit fixup included, and is kept.

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
 fs/ocfs2/inode.c | 85 +++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 76 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 9db147de1982..ad40cd6baaa0 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -2062,9 +2062,25 @@ static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
 {
 	int changed = 0;
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)bh->b_data;
+	void *orig;
+	int rc;
 
-	if (!ocfs2_filecheck_validate_inode_block(sb, bh))
-		return 0;
+	/*
+	 * Snapshot the whole block before validating it, and keep the snapshot
+	 * until the repair is known to be good.  ocfs2_validate_meta_ecc()
+	 * mutates the block in place while attempting a hamming fix and leaves
+	 * the flipped bit behind when the crc32 still fails, so a snapshot
+	 * taken afterwards would record that stray flip rather than what was
+	 * read from disk.  A field by field undo would not restore it either.
+	 */
+	orig = kmalloc(sb->s_blocksize, GFP_NOFS);
+	if (!orig)
+		return -OCFS2_FILECHECK_ERR_FAILED;
+	memcpy(orig, bh->b_data, sb->s_blocksize);
+
+	rc = ocfs2_filecheck_validate_inode_block(sb, bh);
+	if (!rc)
+		goto out_free;
 
 	trace_ocfs2_filecheck_repair_inode_block(
 		(unsigned long long)bh->b_blocknr);
@@ -2074,7 +2090,8 @@ static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
 		     "Filecheck: cannot repair dinode #%llu "
 		     "on readonly filesystem\n",
 		     (unsigned long long)bh->b_blocknr);
-		return -OCFS2_FILECHECK_ERR_READONLY;
+		rc = -OCFS2_FILECHECK_ERR_READONLY;
+		goto out_restore;
 	}
 
 	if (buffer_jbd(bh)) {
@@ -2082,21 +2099,35 @@ static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
 		     "Filecheck: cannot repair dinode #%llu, "
 		     "its buffer is in jbd\n",
 		     (unsigned long long)bh->b_blocknr);
-		return -OCFS2_FILECHECK_ERR_INJBD;
+		rc = -OCFS2_FILECHECK_ERR_INJBD;
+		goto out_restore;
 	}
 
 	if (!OCFS2_IS_VALID_DINODE(di)) {
 		/* Cannot fix invalid inode block */
-		return -OCFS2_FILECHECK_ERR_INVALIDINO;
+		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+		goto out_restore;
 	}
 
 	if (ocfs2_dinode_has_no_valid_flag(di)) {
 		/* Cannot just add VALID_FL flag back as a fix,
 		 * need more things to check here.
 		 */
-		return -OCFS2_FILECHECK_ERR_VALIDFLAG;
+		rc = -OCFS2_FILECHECK_ERR_VALIDFLAG;
+		goto out_restore;
 	}
 
+	/*
+	 * A failed ecc check means the hamming fixup did not produce a crc32
+	 * valid block, so the bit it flipped is bogus.  Undo that before
+	 * repairing fields, otherwise the ecc recompute below would stamp the
+	 * stray flip with a valid checksum and write it out.  An ecc check that
+	 * passed leaves good data behind, a successful single bit fixup
+	 * included, and must be kept.
+	 */
+	if (rc == -OCFS2_FILECHECK_ERR_BLOCKECC)
+		memcpy(bh->b_data, orig, sb->s_blocksize);
+
 	if (ocfs2_dinode_has_wrong_blkno(di, bh->b_blocknr)) {
 		di->i_blkno = cpu_to_le64(bh->b_blocknr);
 		changed = 1;
@@ -2115,7 +2146,14 @@ static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
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
@@ -2125,15 +2163,44 @@ static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
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
 
-	return 0;
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
+	if (rc)
+		goto out_restore;
+
+	mark_buffer_dirty(bh);
+	goto out_free;
+
+out_restore:
+	/* Leave the buffer exactly as it was read from disk. */
+	memcpy(bh->b_data, orig, sb->s_blocksize);
+out_free:
+	kfree(orig);
+	return rc;
 }
 
 static int
-- 
2.39.3

