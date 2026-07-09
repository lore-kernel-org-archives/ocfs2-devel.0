Received: from sender-op-o17.zoho.eu (sender-op-o17.zoho.eu [136.143.169.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F198287E
	for <ocfs2-devel@lists.linux.dev>; Thu,  9 Jul 2026 13:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783603584; cv=pass; b=obWHymMr3JRACTp4UV6+SdjlDNZopt+sTjnNmWh69Isy+fUGAYpefnAzWssXqCZc0LzFzm42PMr7YdS8cWAi7tdOZt2DT9ad7mYBdJbggYI+Ul0QaGsRkOYNysrRmV91BxJ2c/Z8zNQmgQb2FA5bo0NT00EGyEWe9eLl8PY8kZg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783603584; c=relaxed/simple;
	bh=w/d/dfi1uYU2FljV31b0JYK0IRKR5t87+DRqt1LBkec=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mpf+h27VzoC91Rf4wUOMORGsBW/JfytA2+Lox+gHtu4/yd2nhlu9QH8gJQdsvxrQ05JKGFmF9cV0VYPwc7UbpXmHLcM5PIin9PqV1Usg1OVDf0DrLAETB7wLDTJpDW8610Rw87/UrH8rM8IsCB4WSUk/7Dw0Sm5QZsKbm8jTo8w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=auditcode.ai; spf=pass smtp.mailfrom=auditcode.ai; dkim=pass (1024-bit key) header.d=auditcode.ai header.i=security@auditcode.ai header.b=r9LC+etG; arc=pass smtp.client-ip=136.143.169.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=auditcode.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=auditcode.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=auditcode.ai header.i=security@auditcode.ai header.b="r9LC+etG"
ARC-Seal: i=1; a=rsa-sha256; t=1783603576; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=kTIV2mfjg9J+7cPZPIsq8zhrO62Ulvj7aOq7QDKbAGvblHyoheKu+ZfVC3Tt4sC/IsgxazQZOGugNcPqlX4OSl9Uz1Ugf7MBg5N5uIc6w7J3HsZ7uf4D6lbST09HpJyVdbQ5pH8rdcgiicwZeRWq3m8ih7e/jaC4HwN/vqLxizA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1783603576; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=CJ/OdBFNwMigPP4T1S8vhOUX8dCMJZ3B9cVRxR+1zdI=; 
	b=H0Be4M70YhhjZPF41bcgfNUJ04BaLXqDHhg6Tj9MIW0hQdzfXUxr8+FhpHe5dV9iupw5fYK9R4nAuOLaG8nW0PtC9bxsQUhgN27VOEHLyUR6cJblv7n9obNxG+0EP8q3fAXLhctTVciNwtqoIBZKLx+dGBEW2sStmoUforYWiX4=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=auditcode.ai;
	spf=pass  smtp.mailfrom=security@auditcode.ai;
	dmarc=pass header.from=<security@auditcode.ai>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1783603576;
	s=zmail; d=auditcode.ai; i=security@auditcode.ai;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=CJ/OdBFNwMigPP4T1S8vhOUX8dCMJZ3B9cVRxR+1zdI=;
	b=r9LC+etGWO6cyD3rrD15263csHyfMFMXSULYf6DJGv2MQEWygV3UAaUSCOUk5BA5
	HPI5AJWDwL3dvRWexf2RJ9JliIm016N6+IoJSQ4dUaFNEN1qkVx7AMnPUXL4n0bOsQe
	QpP+JP00tNxUV4/cmJHpBS+MLRwqY8VGE5sYUjUA=
Received: by mx.zoho.eu with SMTPS id 1783603575137934.2333414984581;
	Thu, 9 Jul 2026 15:26:15 +0200 (CEST)
From: Ibrahim Hashimov <security@auditcode.ai>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] ocfs2: validate rl_used against rl_count in refcount block validator
Date: Thu,  9 Jul 2026 15:26:09 +0200
Message-ID: <20260709132609.44233-1-security@auditcode.ai>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

ocfs2_find_refcount_rec_in_rl() walks the on-disk refcount record
array with:

	for (; i < le16_to_cpu(rb->rf_records.rl_used); i++) {
		rec = &rb->rf_records.rl_recs[i];
		...

rl_recs[] lives in a single metadata block (4096 bytes on the common
configuration), so its real capacity is fixed by
ocfs2_refcount_recs_per_rb(sb) (247 records for a 4K block with the
16-byte ocfs2_refcount_rec). rl_used and rl_count are both read
directly off disk by ocfs2_validate_refcount_block() and are never
checked against that capacity, nor against each other, before any
refcount/reflink/CoW operation walks the array.

A crafted (or corrupted) refcount block with rl_used == 0xffff makes
the loop above walk far past the end of the block, dereferencing
rl_recs[i] for i up to 65534. The resulting index is then handed to
the sibling ocfs2_insert_refcount_rec(), whose insert-shift does:

	if (index < le16_to_cpu(rf_list->rl_used))
		memmove(&rf_list->rl_recs[index + 1],
			&rf_list->rl_recs[index],
			(le16_to_cpu(rf_list->rl_used) - index) *
			 sizeof(struct ocfs2_refcount_rec));

i.e. a memmove() of up to (0xffff - index) * 16 bytes (~1 MiB) from an
offset already past the block. This is reachable from an ordinary
reflink (FICLONE) against a crafted/corrupted ocfs2 image: attaching
an extent whose cpos sorts past every real record in the leaf forces
the lookup to run off the end instead of returning early on a match.
The attacker model is local: CAP_SYS_ADMIN mounting a crafted or
corrupted ocfs2 image, or a raw write to the block device backing an
already-mounted ocfs2 filesystem.

ocfs2_validate_refcount_block() already validates the block's ECC,
signature, rf_blkno and rf_fs_generation, but never rl_count/rl_used
against the block's actual on-disk capacity. This is the same class
of gap that ocfs2_validate_extent_block() (fs/ocfs2/alloc.c) already
closes for the sibling extent-list header, which checks both the
record capacity and the "used" bound before any code walks
h_list.l_recs[]:

	if (le16_to_cpu(eb->h_list.l_count) != ocfs2_extent_recs_per_eb(sb)) {
		rc = ocfs2_error(...);
		goto bail;
	}

	if (le16_to_cpu(eb->h_list.l_next_free_rec) >
	    le16_to_cpu(eb->h_list.l_count)) {
		rc = ocfs2_error(...);
		goto bail;
	}

Add the equivalent pair of checks to ocfs2_validate_refcount_block():
reject a refcount block whose rl_count does not match the fixed
per-block capacity returned by ocfs2_refcount_recs_per_rb(), and
reject rl_used > rl_count. Both checks are skipped when
OCFS2_REFCOUNT_TREE_FL is set, because in that case the same union
bytes hold an ocfs2_extent_list (rf_list), not the refcount record
list (rf_records) -- that layout is already validated separately by
ocfs2_validate_extent_block() when the referenced extent block is
read. This mirrors the existing
"!(rb->rf_flags & OCFS2_REFCOUNT_TREE_FL)" guard used elsewhere in
this file (e.g. ocfs2_get_refcount_rec()) to decide whether
rf_records or rf_list is the live member of the union.

With this in place, a forged rl_used/rl_count is caught at block
validation time (ocfs2_error()), consistent with every other
corruption check in this function, instead of driving an
out-of-bounds read in ocfs2_find_refcount_rec_in_rl() and a
subsequent out-of-bounds memmove() in ocfs2_insert_refcount_rec().

Verified against a crafted image on a v6.19 KASAN (KASAN_GENERIC)
build: replaying the same reflink (FICLONE) reliably hit a KASAN
report in __ocfs2_increase_refcount()/ocfs2_insert_refcount_rec()
before this patch, and triggers no report once
ocfs2_validate_refcount_block() rejects the forged rl_used/rl_count.

Fixes: f2c870e3b12e ("ocfs2: Add ocfs2_read_refcount_block.")
Cc: stable@vger.kernel.org
Signed-off-by: Ibrahim Hashimov <security@auditcode.ai>
Assisted-by: AuditCode-AI:2026.07
---
 fs/ocfs2/refcounttree.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 7323bde70caa..63d6cb326e30 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -116,6 +116,33 @@ static int ocfs2_validate_refcount_block(struct super_block *sb,
 				 le32_to_cpu(rb->rf_fs_generation));
 		goto out;
 	}
+
+	/*
+	 * rf_records (rl_count/rl_used/rl_recs[]) is only meaningful when
+	 * this block is not an interior tree block (OCFS2_REFCOUNT_TREE_FL);
+	 * in that case the same union bytes hold an extent list (rf_list)
+	 * instead, which is validated by ocfs2_validate_extent_block().
+	 */
+	if (!(le32_to_cpu(rb->rf_flags) & OCFS2_REFCOUNT_TREE_FL)) {
+		if (le16_to_cpu(rb->rf_records.rl_count) !=
+		    ocfs2_refcount_recs_per_rb(sb)) {
+			rc = ocfs2_error(sb,
+					 "Refcount block #%llu has an invalid rl_count of %u\n",
+					 (unsigned long long)bh->b_blocknr,
+					 le16_to_cpu(rb->rf_records.rl_count));
+			goto out;
+		}
+
+		if (le16_to_cpu(rb->rf_records.rl_used) >
+		    le16_to_cpu(rb->rf_records.rl_count)) {
+			rc = ocfs2_error(sb,
+					 "Refcount block #%llu has an invalid rl_used of %u (rl_count %u)\n",
+					 (unsigned long long)bh->b_blocknr,
+					 le16_to_cpu(rb->rf_records.rl_used),
+					 le16_to_cpu(rb->rf_records.rl_count));
+			goto out;
+		}
+	}
 out:
 	return rc;
 }
-- 
2.50.1 (Apple Git-155)

