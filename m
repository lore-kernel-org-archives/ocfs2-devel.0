Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D5AC3F6C59
	for <ocfs2-devel@lists.linux.dev>; Sat, 10 Oct 2026 11:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791632108; cv=none; b=Mo/7cDK4E1zPNYW2FIJuHM1Av0Y38MqKSsbJDGJUd5Fxxzd2igE2tcB1t8VPCOK+7kIew4Ywn8iTWSYIqUrxqx3bJMBdwKH9RnjutaK9W6I92MQtvOkwX0U6eRdHBrISjn5BsKhkjDfonpmdTTmQkyJtsshDhNGqUr6ajr21NdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791632108; c=relaxed/simple;
	bh=55BEUqMQybT6SsH+aSDD9pXiyy4Iy9LMch3qXDVOV2w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Nx7Ey2RBSOwQ2zxOBkVisWtZWc7s8uZS3xf8mxOTNiVfR+lQTLcS7/jTY1FPzFuFrkosWgLQ+LMew/iZUMhyVyN2ce3xzWR2waBAQ/C36kJqJqb1ekYhy8hyxwuTxMjiCZMHvV9CU4S/QApYax//2aSp6CCtSxbLWPUWmDRLDnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=wp4LlSk7; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="wp4LlSk7"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791632098; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=HuE0ZqpJImGBD+wfbyR8QOA3iebjqSmF9i8Q97aNrGY=;
	b=wp4LlSk7+1t+9PHZfDpbJ4n7zv9OzTLyc/sZbDONHMUMxpmZMNIzLPccET96LN/2zbSFgXZqODPKYnrKsUQKSrlTXl+OojFBVgLf5BYLEiLCNs7ca3jJyi7XdIDnor0eGkKqsIGMxKJbt+bfbTI6d0FMKEV4N1uj6FrFFI2mEVA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R301e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XCW0FZi_1791632097;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XCW0FZi_1791632097 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 10 Oct 2026 19:34:57 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] ocfs2: reserve xattr value tree metadata only once
Date: Sat, 10 Oct 2026 19:34:54 +0800
Message-Id: <20261010113454.1420939-4-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20261010113454.1420939-1-joseph.qi@linux.alibaba.com>
References: <20261010113454.1420939-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_calc_xattr_set_need() asks for the new value's extent tree twice
when it replaces an inline value smaller than a value root with one
large enough to be stored outside.  The "stored outside" branch reserves
the tree and then falls through to meta_guess instead of going out:

        if (!ocfs2_xattr_is_local(xe)) {
                ...
                xv = (struct ocfs2_xattr_value_root *)
                     (base + name_offset + name_len);
                value_size = OCFS2_XATTR_ROOT_SIZE;
        } else
                xv = &def_xv.xv;

        if (old_clusters >= new_clusters) {
                ...
                goto out;
        } else {
                meta_add += ocfs2_extend_meta_needed(&xv->xr_list);
                ...
                if (value_size >= OCFS2_XATTR_ROOT_SIZE)
                        goto out;
        }

On the fall-through xv is def_xv, so what gets added here is the two
blocks ocfs2_extend_meta_needed() wants for an empty value root -- and
both sides of meta_guess reserve that same tree again.  The create side
has done so since commit 3ed2be719eb9 ("ocfs2: allow for more than one
data extent when creating xattr"), which ported this reservation to the
create case without noticing it was already on the way in, and the
existing-block side since commit 0cdc7dde00ec ("ocfs2: fix missing
metadata reservation for large xattrs").  Both were chasing the same
RESTART_META failure in ocfs2_xattr_extend_allocation(), for xattr
create and then for xattr update.

ocfs2_init_xattr_set_ctxt() hands the total straight to
ocfs2_reserve_new_metadata_blocks(), so the surplus is two blocks held
for the whole transaction.  A setxattr that would otherwise fit can come
back -ENOSPC on a filesystem whose metadata allocator is nearly
exhausted.

Move the reservation into the branch that stops there, leaving meta_guess
as the only place that reserves for a value tree the fall through is
about to create.  The paths that do go out keep reserving against the
value root they already have, which for an external old value is the
on-disk one and so can legitimately ask for more than two blocks.

Both sides of meta_guess have to come out even on their own now that the
copy covering for them is gone.  The existing-block side only started
reserving the value tree in the commit this one is tagged against.  The
create side has reserved the tree since 3ed2be719eb9, but only the tree:
the block ocfs2_create_xattr_block() claims came out of the same two, and
on the fall-through it was the duplicate removed here that made up the
difference.  So "ocfs2: reserve metadata for a new xattr block and its
value tree" has to land first -- without it the create side reserves 2
where 3 are needed and the value tree is back to RESTART_META.  That one
fixes a shortfall of its own on the path that reaches meta_guess
directly, where there was never a duplicate to cover it, so it is worth
taking alone; this patch is not.

Fixes: 0cdc7dde00ec ("ocfs2: fix missing metadata reservation for large xattrs")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/xattr.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 53ba52381112..cc6a64eb7d07 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -3509,12 +3509,21 @@ static int ocfs2_calc_xattr_set_need(struct inode *inode,
 			credits += ocfs2_remove_extent_credits(inode->i_sb);
 			goto out;
 		} else {
-			meta_add += ocfs2_extend_meta_needed(&xv->xr_list);
 			clusters_add += new_clusters - old_clusters;
 			credits += ocfs2_calc_extend_credits(inode->i_sb,
 							     &xv->xr_list);
-			if (value_size >= OCFS2_XATTR_ROOT_SIZE)
+			/*
+			 * The old value occupies at least as much room as a
+			 * value root, whether it sat outside or inline, so the
+			 * new root fits where it was and no new xattr block or
+			 * bucket is needed -- only the metadata to extend the
+			 * tree hanging off it.  A smaller one is replaced
+			 * outright, which meta_guess below reserves for.
+			 */
+			if (value_size >= OCFS2_XATTR_ROOT_SIZE) {
+				meta_add += ocfs2_extend_meta_needed(&xv->xr_list);
 				goto out;
+			}
 		}
 	} else {
 		/*
@@ -3566,6 +3575,10 @@ static int ocfs2_calc_xattr_set_need(struct inode *inode,
 		 * Reserve metadata for the new xattr's value extent tree.
 		 * The not_found path above adds credits for this tree but
 		 * omits meta_add, leaving meta_ac NULL for large values.
+		 *
+		 * This is all of meta_ac on this side beyond the xattr tree
+		 * above: no xattr block is allocated here, and a new bucket or
+		 * index block is paid for out of data_ac.
 		 */
 		if (xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE)
 			meta_add += ocfs2_extend_meta_needed(&def_xv.xv.xr_list);
-- 
2.39.3

