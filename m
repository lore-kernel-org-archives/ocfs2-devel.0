Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797653DB333
	for <ocfs2-devel@lists.linux.dev>; Fri,  9 Oct 2026 08:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791534611; cv=none; b=T6roTp+ODO6sRB2ZvJ6+qOmgLB55/zp4dIAETRtvPlwxqKbQ91rmHzWCQ95CXDH6+7BPzEPJ3LKXOX89ujfGSk1y4ofiNzHBqIzqUj/6K/0xrageQgsd3sYEcL4VLGfWz+E8s3ofbSBNp6PbBGpincoOFkcg2hiAVdhB6sJ9sb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791534611; c=relaxed/simple;
	bh=5zwacK/Gc38nadTZUH2vPiMUbvwYpKVI9nA4dwUMIMY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=A8+iSUZUPUWu2qOMCrNovgxLzSqEqFYmg9WEVydRGK5P6mJAvpfB7K2mE7VQtUZ0YSVxTWDO5hJuHpX19ku+OSzIo7nP1GHvbjTLiDXaRYNjpMfs5J5dim5plaq4HdhGz5tobra+tbj9r400rly4lc4sfouKIwZD4FBCDcWfKPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=b/mzHSLf; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="b/mzHSLf"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791534606; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=YQKBa1gzvgKM0qZwKOWAKXlUR8SKlxgpXGAwB/IqbXs=;
	b=b/mzHSLf3E+tjA33ypsIg6jAFQUgJdHKPmG6qLpuoauRoN24S1ov6SdrWaLD2WMI2OhvvFyHb8aE4zkWuPdDGxwqzU3C1uYQj7lpHpFgePJzwvLpnZvOqJW0SC29QiRhvHHfFnxDADCTogyX3vdhTX39N2gfVk2UPmg/0IJTzWQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R851e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XCSo.Tz_1791534604;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XCSo.Tz_1791534604 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 09 Oct 2026 16:30:05 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>,
	Anderson Ferneda <anderson.ferneda@braza.com.br>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] ocfs2: use the stored hash when checking xattr bucket collision
Date: Fri,  9 Oct 2026 16:30:01 +0800
Message-Id: <20261009083002.2621201-3-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20261009083002.2621201-1-joseph.qi@linux.alibaba.com>
References: <20261009083002.2621201-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2_check_xattr_bucket_collision() decides whether splitting a full
bucket can make room for the entry being set by recomputing the hash of
the name:

	u32 name_hash = ocfs2_xattr_name_hash(inode, name, strlen(name));

	if (name_hash != le32_to_cpu(xh->xh_entries[0].xe_name_hash))
		return 0;

For a new entry that is the hash it will be stored under, so comparing it
is correct.  An existing entry keeps the hash it already has: an update
never rewrites xe_name_hash, since ocfs2_xa_add_entry() is the only
writer of that field for a real entry and ocfs2_xa_prepare_entry() calls
it only when loc->xl_entry is NULL.

An entry stored by a kernel that sign-extended the name bytes when
hashing can still be updated, because ocfs2_xattr_find_entry() searches
a non-indexed xattr block by memcmp on the name and never looks at
xe_name_hash.  Growing it past the space left in the block converts the
block into a tree, ocfs2_cp_xattr_block_to_bucket() fills the bucket in
stored hash order, and the update runs out of room in the bucket too.
The collision check then compares the unsigned hash against the legacy
hashes in the bucket and reports no collision.

ocfs2_xattr_set_entry_index_block() goes on to allocate a bucket that
ocfs2_divide_xattr_bucket() cannot fill: a bucket whose entries all share
one hash has no divide position, so all it does is append an empty bucket
with a sentinel hash one above the last entry's.

The re-search that follows depends on where the unsigned hash sorts.
Below the legacy ones, it comes back to the full bucket and the set fails
with -ENOSPC, having grown the tree for nothing.  Above them, it lands on
the new empty bucket, which ocfs2_xattr_bucket_find() handles explicitly
and ocfs2_find_xe_in_bucket() scans zero times, so the set stores a second
copy of the entry under the unsigned hash and returns success.  The
original stays in the full bucket, listxattr reports the name twice and
getxattr returns the new copy.

Pass the hash the entry is stored under instead: the stored one for an
existing entry, the unsigned one for a new entry.  A tree whose entries
are all stored under the unsigned hash sees no change, since there the
two are the same value.

Exposed-by: 3bc753c06dd0 ("kbuild: treat char as always unsigned")
Cc: <stable@vger.kernel.org> # 6.2+
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/xattr.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index a428fe908116..c5a39a7d43d0 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -5896,16 +5896,14 @@ static int ocfs2_rm_xattr_cluster(struct inode *inode,
 
 /*
  * check whether the xattr bucket is filled up with the same hash value.
- * If we want to insert the xattr with the same hash, return -ENOSPC.
- * If we want to insert a xattr with different hash value, go ahead
- * and ocfs2_divide_xattr_bucket will handle this.
+ * If the entry being set carries that same hash, return -ENOSPC, since
+ * ocfs2_divide_xattr_bucket() has no divide position to work with.
+ * Otherwise go ahead and ocfs2_divide_xattr_bucket() will handle this.
  */
-static int ocfs2_check_xattr_bucket_collision(struct inode *inode,
-					      struct ocfs2_xattr_bucket *bucket,
-					      const char *name)
+static int ocfs2_check_xattr_bucket_collision(struct ocfs2_xattr_bucket *bucket,
+					      u32 name_hash)
 {
 	struct ocfs2_xattr_header *xh = bucket_xh(bucket);
-	u32 name_hash = ocfs2_xattr_name_hash(inode, name, strlen(name));
 
 	if (name_hash != le32_to_cpu(xh->xh_entries[0].xe_name_hash))
 		return 0;
@@ -5974,6 +5972,7 @@ static int ocfs2_xattr_set_entry_index_block(struct inode *inode,
 					     struct ocfs2_xattr_search *xs,
 					     struct ocfs2_xattr_set_ctxt *ctxt)
 {
+	u32 name_hash;
 	int ret;
 
 	trace_ocfs2_xattr_set_entry_index_block(xi->xi_name);
@@ -5993,10 +5992,18 @@ static int ocfs2_xattr_set_entry_index_block(struct inode *inode,
 	 * the maximum number of collisions we will allow for then is
 	 * one bucket's worth, so check it here whether we need to
 	 * add a new bucket for the insert.
+	 *
+	 * An existing entry keeps the hash it was stored under, and that is
+	 * the hash a split has to work with.  A new entry is stored under the
+	 * unsigned one, which is what ocfs2_xa_add_entry() will write.
 	 */
-	ret = ocfs2_check_xattr_bucket_collision(inode,
-						 xs->bucket,
-						 xi->xi_name);
+	if (xs->not_found)
+		name_hash = ocfs2_xattr_name_hash(inode, xi->xi_name,
+						  xi->xi_name_len);
+	else
+		name_hash = le32_to_cpu(xs->here->xe_name_hash);
+
+	ret = ocfs2_check_xattr_bucket_collision(xs->bucket, name_hash);
 	if (ret) {
 		mlog_errno(ret);
 		goto out;
-- 
2.39.3

