Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19C83DB96B
	for <ocfs2-devel@lists.linux.dev>; Fri,  9 Oct 2026 08:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791534614; cv=none; b=WkBUow/oOrVH9Rvf7yKNcnDfDVehwlyxThFYMFYT9IESOi5pBwnWA1HlS9qyP0u7dnXMbO39YbyyXNld3wGy5B1wPqrCox/Y70WE1j7XdTnyjVRHHQTSswuo5xgava3c9SX6p2lIH/MIFB0cUnO4yZwFRydRcxUY0/2I5HlRf0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791534614; c=relaxed/simple;
	bh=30YOVCnDGRqrA/ZLZsklI+Owzqo9CFMsX0FkpocexEk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=t9mlQ24/b2LUU8d5vC5rmFLItBEyNKoXHDBdhEsrtxk7qVnIqtAH2Ee00Z0BMLOXK0/ryIKiuvKrq3ILAcHtEL7X2AFriIv64WN0V5sywJeAT2Q2lrXsr+dIxdoNURl8IddR7mpwW2ZrV3oewkd3sTxHjkjS1/12Hlry19Pu0I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=KfqujQj4; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="KfqujQj4"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791534604; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=MAz7BXRPp/gmRVh1x/LPNL4/MYRX4agD3aYlLNECoPw=;
	b=KfqujQj4CWXvAGrWnjmzxVMrziCHWhhaaxxsU2PH8FDrIbIgauvl7Ya3d7hMZN6RF762QDr5cdguZKbAhR1KOPTjeAs32CR/Ku/XfMGD0FOPZXrwBfdtEnrJyCUK6DUMrEc5dI5qUM7uI0NhJN6gu0mGqjcazBOaPte3ehp7K28=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XCSp61D_1791534603;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XCSp61D_1791534603 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 09 Oct 2026 16:30:04 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>,
	Anderson Ferneda <anderson.ferneda@braza.com.br>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] ocfs2: deal with legacy signed dir index name hash values
Date: Fri,  9 Oct 2026 16:30:00 +0800
Message-Id: <20261009083002.2621201-2-joseph.qi@linux.alibaba.com>
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
load in str2hashbuf():

	val = msg[i] + (val << 8);

A name byte >= 0x80 used to sign-extend and now zero-extends, so
ocfs2_dx_dir_name_hash() computes a different hash pair for every name
containing one.  The pair is written into the dx leaf when the entry is
created, so an index built by an older kernel no longer matches and
ocfs2_dx_dir_search() returns -ENOENT for a name that readdir still
lists.

Search with the current unsigned hash and, on a miss, retry with the
legacy signed one, as ext4 does in commit f3bbac32475b2 ("ext4: deal
with legacy signed xattr name hash values").  New entries are always
indexed under the unsigned hash.  Skip the retry when the two hashes
are equal, so that a miss on an ASCII name does not walk the index
twice.

The retry costs a second walk of the dx tree, so a negative lookup of a
name containing a byte >= 0x80 does twice the work.  That is bounded and
worth it, and directories whose dx root is still inline pay nothing
extra, since there the retry only rescans the root block that is already
loaded.  Nothing retires it at runtime: a legacy entry keeps its legacy
hash, because neither deleting nor updating an entry rewrites the dx
hash, and the only code that rehashes existing dirents is
ocfs2_expand_inline_dir() on the inline to extent conversion.
Rebuilding the index offline is what removes the cost for good.

Also spell out the signedness in str2hashbuf() instead of leaving the
current hash to -funsigned-char, as commit 854f0912f813 ("ext4: make
xattr char unsignedness in hash explicit") did, so that both variants
stay correct if this is backported to a kernel without the flag.

Reported-by: Anderson Ferneda <anderson.ferneda@braza.com.br>
Link: https://lore.kernel.org/ocfs2-devel/CP5P284MB2780AC2C3C2AB2CF2B6CB7AFBE942@CP5P284MB2780.BRAP284.PROD.OUTLOOK.COM/
Exposed-by: 3bc753c06dd0 ("kbuild: treat char as always unsigned")
Cc: <stable@vger.kernel.org> # 6.2+
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
---
 fs/ocfs2/dir.c | 76 ++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 65 insertions(+), 11 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 55c4a305a282..3f159a20a248 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -221,7 +221,8 @@ static void TEA_transform(__u32 buf[4], __u32 const in[])
 	buf[1] += b1;
 }
 
-static void str2hashbuf(const char *msg, int len, __u32 *buf, int num)
+static void str2hashbuf(const char *msg, int len, __u32 *buf, int num,
+			bool legacy_signed)
 {
 	__u32	pad, val;
 	int	i;
@@ -235,7 +236,10 @@ static void str2hashbuf(const char *msg, int len, __u32 *buf, int num)
 	for (i = 0; i < len; i++) {
 		if ((i % 4) == 0)
 			val = pad;
-		val = msg[i] + (val << 8);
+		if (legacy_signed)
+			val = (signed char)msg[i] + (val << 8);
+		else
+			val = (unsigned char)msg[i] + (val << 8);
 		if ((i % 4) == 3) {
 			*buf++ = val;
 			val = pad;
@@ -248,8 +252,9 @@ static void str2hashbuf(const char *msg, int len, __u32 *buf, int num)
 		*buf++ = pad;
 }
 
-static void ocfs2_dx_dir_name_hash(struct inode *dir, const char *name, int len,
-				   struct ocfs2_dx_hinfo *hinfo)
+static void __ocfs2_dx_dir_name_hash(struct inode *dir, const char *name,
+				     int len, struct ocfs2_dx_hinfo *hinfo,
+				     bool legacy_signed)
 {
 	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
 	const char	*p;
@@ -279,7 +284,7 @@ static void ocfs2_dx_dir_name_hash(struct inode *dir, const char *name, int len,
 
 	p = name;
 	while (len > 0) {
-		str2hashbuf(p, len, in, 4);
+		str2hashbuf(p, len, in, 4, legacy_signed);
 		TEA_transform(buf, in);
 		len -= 16;
 		p += 16;
@@ -290,6 +295,19 @@ static void ocfs2_dx_dir_name_hash(struct inode *dir, const char *name, int len,
 	hinfo->minor_hash = buf[1];
 }
 
+static void ocfs2_dx_dir_name_hash(struct inode *dir, const char *name, int len,
+				   struct ocfs2_dx_hinfo *hinfo)
+{
+	__ocfs2_dx_dir_name_hash(dir, name, len, hinfo, false);
+}
+
+static void ocfs2_dx_dir_name_hash_signed(struct inode *dir, const char *name,
+					  int len,
+					  struct ocfs2_dx_hinfo *hinfo)
+{
+	__ocfs2_dx_dir_name_hash(dir, name, len, hinfo, true);
+}
+
 /*
  * bh passed here can be an inode block or a dir data block, depending
  * on the inode inline data flag.
@@ -1021,10 +1039,10 @@ static int ocfs2_dx_dir_lookup(struct inode *inode,
 	return ret;
 }
 
-static int ocfs2_dx_dir_search(const char *name, int namelen,
-			       struct inode *dir,
-			       struct ocfs2_dx_root_block *dx_root,
-			       struct ocfs2_dir_lookup_result *res)
+static int __ocfs2_dx_dir_search(const char *name, int namelen,
+				 struct inode *dir,
+				 struct ocfs2_dx_root_block *dx_root,
+				 struct ocfs2_dir_lookup_result *res)
 {
 	int ret, i, found;
 	u64 phys;
@@ -1037,8 +1055,6 @@ static int ocfs2_dx_dir_search(const char *name, int namelen,
 	struct ocfs2_extent_list *dr_el;
 	struct ocfs2_dx_entry_list *entry_list;
 
-	ocfs2_dx_dir_name_hash(dir, name, namelen, &res->dl_hinfo);
-
 	if (ocfs2_dx_root_inline(dx_root)) {
 		entry_list = &dx_root->dr_entries;
 		goto search;
@@ -1135,6 +1151,44 @@ static int ocfs2_dx_dir_search(const char *name, int namelen,
 	return ret;
 }
 
+static int ocfs2_dx_dir_search(const char *name, int namelen,
+			       struct inode *dir,
+			       struct ocfs2_dx_root_block *dx_root,
+			       struct ocfs2_dir_lookup_result *res)
+{
+	struct ocfs2_dx_hinfo legacy;
+	int ret;
+
+	ocfs2_dx_dir_name_hash(dir, name, namelen, &res->dl_hinfo);
+
+	ret = __ocfs2_dx_dir_search(name, namelen, dir, dx_root, res);
+	if (ret != -ENOENT)
+		return ret;
+
+	/*
+	 * Nothing under the current hash.  The entry may have been indexed by
+	 * an older kernel, which sign-extended the name bytes when hashing.
+	 * New entries are always indexed under the unsigned hash, so only fall
+	 * back to the legacy signed one when it can actually differ: an ASCII
+	 * name hashes the same either way, and a genuine miss on one should
+	 * not have to walk the index twice.
+	 */
+	ocfs2_dx_dir_name_hash_signed(dir, name, namelen, &legacy);
+	if (legacy.major_hash == res->dl_hinfo.major_hash &&
+	    legacy.minor_hash == res->dl_hinfo.minor_hash)
+		return ret;
+
+	res->dl_hinfo = legacy;
+
+	ret = __ocfs2_dx_dir_search(name, namelen, dir, dx_root, res);
+	if (ret)
+		return ret;
+
+	pr_warn_once("ocfs2: directory index with signed name hash\n");
+
+	return 0;
+}
+
 static int ocfs2_find_entry_dx(const char *name, int namelen,
 			       struct inode *dir,
 			       struct ocfs2_dir_lookup_result *lookup)
-- 
2.39.3

