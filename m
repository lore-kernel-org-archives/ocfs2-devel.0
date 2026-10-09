Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F70B3DB324
	for <ocfs2-devel@lists.linux.dev>; Fri,  9 Oct 2026 08:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791534615; cv=none; b=swMSYfcjA9sUjAIbNigN3xQaL51ojJfnmHCVhm7bBueNjYwAeXtojHgk8LSIpD7aJoWXb6WTd1uMIuCdnuKLKH/uAURGshIcbGCn+UyjIcLL743vAIPvTK7CjqiieQPSy3g0U1ys+d0dN8bk9K1hwESlLi1UWJ6cEtJRxzV7rAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791534615; c=relaxed/simple;
	bh=Roq5OjsrhAOr2X2YdP4L+KZ9JDIx92+OahIYh8znlMk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pHIlp54FMj1FhEb9mEgLrQi+2AzecpP6riKSafN8EAFQJ6AFWgBUoGgLhoatihF2e+7b7k9wTyLnGie8XBMHfQNXpLzFLbdRqJ4JcQ0y7aaz6Ie6gzNRbZbFZBoKfGKYXjNg8TjOPfPMH3AV5Um2hEYYjE41XNoZpPFkasVav+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=oFeRW/eA; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="oFeRW/eA"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791534606; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=ytqFLFUeFiEek8MRBP5i5/HqSfFch5xnomDhnh4oqCw=;
	b=oFeRW/eAHiVKALfJr8ZdeMoAQHzpyHm5foK5IiBcLLrCdYwvyTI/xA/8zBCn2e3uHw1JKqePG97OZi3ShPEk1UyHMBDOh8cYiXwEp/3UJ7nYprKE/5USF01Dvr09m1fgwmqsck+8a74fswDxId6UHPUmtmiWGVyONGsZivGkNko=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R441e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XCSo.UY_1791534605;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XCSo.UY_1791534605 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 09 Oct 2026 16:30:06 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>,
	Anderson Ferneda <anderson.ferneda@braza.com.br>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] ocfs2: deal with legacy signed xattr name hash values
Date: Fri,  9 Oct 2026 16:30:02 +0800
Message-Id: <20261009083002.2621201-4-joseph.qi@linux.alibaba.com>
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

Commit 3bc753c06dd0 ("kbuild: treat char as always unsigned") set
-funsigned-char globally, which changed the result of the naked 'char'
load in ocfs2_xattr_name_hash():

	hash = (hash << OCFS2_HASH_SHIFT) ^
	       (hash >> (8*sizeof(hash) - OCFS2_HASH_SHIFT)) ^
	       *name++;

A name byte >= 0x80 used to sign-extend and now zero-extends, so the
hash no longer matches the xe_name_hash an older kernel stored.  An
indexed xattr tree is searched by that hash alone, and both the bucket
binary search and the entry scan within it stop as soon as the wanted
hash falls below an entry's, so the entry is never reached: getxattr,
setxattr and removexattr return -ENODATA for a name that listxattr
still lists.

Search with the current unsigned hash and, on a miss, retry with the
legacy signed one, as ext4 does in commit f3bbac32475b2 ("ext4: deal
with legacy signed xattr name hash values").  New entries are always
stored under the unsigned hash.  Skip the retry when the two hashes are
equal, so that a miss on an ASCII name does not walk the tree twice.

A miss is not empty handed: ocfs2_xattr_bucket_find() leaves xs->bucket
holding the bucket a new entry would go into.  So after a double miss
drop it and search once more with the unsigned hash, otherwise a new
entry would be placed by its legacy hash and stored under its unsigned
one, breaking the ordering the search relies on.

Only indexed trees are affected; inline xattrs and non-indexed xattr
blocks compare names with memcmp and never look at the hash.

Also spell out the signedness instead of leaving the current hash to
-funsigned-char, as commit 854f0912f813 ("ext4: make xattr char
unsignedness in hash explicit") did, so that both variants stay correct
if this is backported to a kernel without the flag.

Exposed-by: 3bc753c06dd0 ("kbuild: treat char as always unsigned")
Cc: <stable@vger.kernel.org> # 6.2+
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/xattr.c | 93 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 82 insertions(+), 11 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index c5a39a7d43d0..e92bcf401490 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -601,9 +601,10 @@ static inline const char *ocfs2_xattr_prefix(int name_index)
 	return handler ? xattr_prefix(handler) : NULL;
 }
 
-static u32 ocfs2_xattr_name_hash(struct inode *inode,
-				 const char *name,
-				 int name_len)
+static u32 __ocfs2_xattr_name_hash(struct inode *inode,
+				   const char *name,
+				   int name_len,
+				   bool legacy_signed)
 {
 	/* Get hash value of uuid from super block */
 	u32 hash = OCFS2_SB(inode->i_sb)->uuid_hash;
@@ -612,13 +613,30 @@ static u32 ocfs2_xattr_name_hash(struct inode *inode,
 	/* hash extended attribute name */
 	for (i = 0; i < name_len; i++) {
 		hash = (hash << OCFS2_HASH_SHIFT) ^
-		       (hash >> (8*sizeof(hash) - OCFS2_HASH_SHIFT)) ^
-		       *name++;
+		       (hash >> (8*sizeof(hash) - OCFS2_HASH_SHIFT));
+		if (legacy_signed)
+			hash ^= (signed char)name[i];
+		else
+			hash ^= (unsigned char)name[i];
 	}
 
 	return hash;
 }
 
+static u32 ocfs2_xattr_name_hash(struct inode *inode,
+				 const char *name,
+				 int name_len)
+{
+	return __ocfs2_xattr_name_hash(inode, name, name_len, false);
+}
+
+static u32 ocfs2_xattr_name_hash_signed(struct inode *inode,
+					const char *name,
+					int name_len)
+{
+	return __ocfs2_xattr_name_hash(inode, name, name_len, true);
+}
+
 static int ocfs2_xattr_entry_real_size(int name_len, size_t value_len)
 {
 	return namevalue_size(name_len, value_len) +
@@ -4304,11 +4322,12 @@ static int ocfs2_xattr_bucket_find(struct inode *inode,
 	return ret;
 }
 
-static int ocfs2_xattr_index_block_find(struct inode *inode,
-					struct buffer_head *root_bh,
-					int name_index,
-					const char *name,
-					struct ocfs2_xattr_search *xs)
+static int __ocfs2_xattr_index_block_find(struct inode *inode,
+					  struct buffer_head *root_bh,
+					  int name_index,
+					  const char *name,
+					  u32 name_hash,
+					  struct ocfs2_xattr_search *xs)
 {
 	int ret;
 	struct ocfs2_xattr_block *xb =
@@ -4317,7 +4336,6 @@ static int ocfs2_xattr_index_block_find(struct inode *inode,
 	struct ocfs2_extent_list *el = &xb_root->xt_list;
 	u64 p_blkno = 0;
 	u32 first_hash, num_clusters = 0;
-	u32 name_hash = ocfs2_xattr_name_hash(inode, name, strlen(name));
 
 	if (le16_to_cpu(el->l_next_free_rec) == 0)
 		return -ENODATA;
@@ -4348,6 +4366,59 @@ static int ocfs2_xattr_index_block_find(struct inode *inode,
 	return ret;
 }
 
+static int ocfs2_xattr_index_block_find(struct inode *inode,
+					struct buffer_head *root_bh,
+					int name_index,
+					const char *name,
+					struct ocfs2_xattr_search *xs)
+{
+	u32 name_hash, legacy_hash;
+	int name_len = strlen(name);
+	int ret;
+
+	name_hash = ocfs2_xattr_name_hash(inode, name, name_len);
+
+	ret = __ocfs2_xattr_index_block_find(inode, root_bh, name_index, name,
+					     name_hash, xs);
+	if (ret != -ENODATA)
+		return ret;
+
+	/*
+	 * Nothing under the current hash.  The entry may have been stored by
+	 * an older kernel, which sign-extended the name bytes when hashing.
+	 * Skip the retry when the two hashes are equal, so that a name made
+	 * only of ASCII does not have to walk the tree twice.
+	 */
+	legacy_hash = ocfs2_xattr_name_hash_signed(inode, name, name_len);
+	if (legacy_hash == name_hash)
+		return ret;
+
+	/*
+	 * A miss still leaves xs->bucket holding the bucket a new entry would
+	 * be inserted into, so drop it before searching again.
+	 */
+	ocfs2_xattr_bucket_relse(xs->bucket);
+
+	ret = __ocfs2_xattr_index_block_find(inode, root_bh, name_index, name,
+					     legacy_hash, xs);
+	if (!ret) {
+		pr_warn_once("ocfs2: xattr tree with signed name hash\n");
+		return ret;
+	}
+	if (ret != -ENODATA)
+		return ret;
+
+	/*
+	 * Not under either hash.  Restore the unsigned placement, since that
+	 * is where a new entry is stored: leaving the bucket where the legacy
+	 * hash put it would break the ordering the search relies on.
+	 */
+	ocfs2_xattr_bucket_relse(xs->bucket);
+
+	return __ocfs2_xattr_index_block_find(inode, root_bh, name_index, name,
+					      name_hash, xs);
+}
+
 static int ocfs2_iterate_xattr_buckets(struct inode *inode,
 				       u64 blkno,
 				       u32 clusters,
-- 
2.39.3

