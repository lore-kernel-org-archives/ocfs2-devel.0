Received: from mail-dy2-f12.google.com (mail-dy2-f12.google.com [74.125.229.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F714B1D19
	for <ocfs2-devel@lists.linux.dev>; Tue, 22 Sep 2026 20:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790108625; cv=none; b=F3XNlbTM6PKDxzQNycjcqK0mLUKdUQnEDiM8h3TfX0wHhnmxBLXRMh90FRE6XpFftGAwT4eOQjPKAw2a4Kukh0HJGej8nnMRBGx736yrRe5XyhlBYa+d+FGCIYtMK0qqc97n+LPC535W3EKO8xrxKSh8JQKmv7z79tnQ1J0qOco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790108625; c=relaxed/simple;
	bh=oXR+0JqHfu87eukEokpNsmREiUMPTo8HO88BW1JCCrc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AbHgjzbRTA2vCbTovOhyPez59RYj9zsLAz+F1ZzirzxUuYI+DD51FjcxEm1LqLF/ADri83lX9vfRrUvn50/RJScmfmHIXsWclg5GnCA0XqZjqSpp38kId3fCSJHvyM5b7abewMzxqZnQ8iZAxIniBHU6KqLgDLVmuM1uMPsOi6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=dJUw4u9v; arc=none smtp.client-ip=74.125.229.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="dJUw4u9v"
Received: by mail-dy2-f12.google.com with SMTP id 5a478bee46e88-33bf5a1c4d9so206120eec.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 22 Sep 2026 13:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1790108612; x=1790713412; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5DjzabZ8BjMpxlg7TQnuj38a/x4OpYjoDV9Zo35NcDE=;
        b=dJUw4u9vPZ/ZqB3s1ySAriLTvuf+H7Shwc+V1rqioo05JyMxfOKcrI2lBIepj89Qt1
         YgEoy9ekRabJ8cvjZejHDO0isz2ATyixzAv9gRWUbqHjx8DLjlHznXOUq6dqvZoiFNxj
         IRvBAS6usZHNG281bFjoZLr83yeQbBNtKHqoQQw1XLFMmT2JCObskWfCmYhMWG2KfE/c
         7C+8sTMbVwwNeffM+pEcNqsFxpfi6ZEv9cS/auzoig2TO7bcezh6fmfHpT60eY39wrLv
         ZiBcot5gkt3SKUkjGsqJ1AaIUZIs40dYOgZgk9lIItWU00lC9G4UPdXA5dc8nEEd9OeW
         REwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790108612; x=1790713412;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5DjzabZ8BjMpxlg7TQnuj38a/x4OpYjoDV9Zo35NcDE=;
        b=mKqIhmqnDgLOwV4RQGXJwO9WTXl534sDFzZ0Ubu981Xc0x4nxtjlwF9ijmoMaVoOGm
         DborY893RRkLa9EoN7EFmHFpr4KJW3ltTkEOz2+Fab+QdshZ1GFOOVGb33CDiLlf6RHd
         C4pLqJ4IVdL7D0LyxQyxGmn24JlPHinyvq4uVkmiDF5/3QuX1pfYprLTju/fBxmkWg0i
         HTIOI3PWVVayBpV/SabL4Zbycipa+weEsYT1TUa9h0yN/ah7KF6Kl5LvhU+GKdW/2S/p
         xE0ci8O3uqHzPC8jMuKIeBpyYijPKSKGhmVFbB0pz3X+ZZL8QeaofgdG4AvOymhPGvYY
         uU3A==
X-Gm-Message-State: AFuF++kD73Dty3nMSHiEA/ECsP/uodLZmzP76mOgKuI8v33Qls7DvzVv
	ZYIkJyieDyrT2yqLrSi2XDJA7tACGCpCYct7U46th/8WzDyJFV6VHMnYT4fJMepl4g==
X-Gm-Gg: AYBFou2ngitAE0Cm5qUtA+SxuJEoBwUoc4MYfay1+daaFvu7IrQbqGZwVjFD8ghRhwQ
	4jLgCI2PkUMFPz5j3bzlTWaEFsOahfY7mfHRjn/QiqzrsNrF3+Ua652GP6qypBsWkHjaD9fHI27
	Ry7NEddciCXeAQiqHzFXmXUbh7wBgUopOd9z317vR5PRDWn/YaK4CRMcuBwvGTH7WvkuhfZQBun
	yzLA+QwMnYFn5mbDlrx4T5BQ4fC/4kafMaLD0WEu0O+qRi8zukmJOAU1jLWGARluRwheM9pIZwj
	EdMoMeFGLhtsch6KA5aoQmi6kyKutJAuPn5+TKfWMhqFFSbtZ+fuZ4ogiCSiUVZyw/B0Jkm49ZQ
	aP2OMGxORb9A3va/ArYuba5vKVz2a5qQQBnFz2V3aDQPHuGMGgyKATRiSNx5dl+NscvdVR5B/Yg
	GoNaWkJWgdGXZG5iOFhf9bqyn+Y07NRHr7hgHMN2qCbB7DOW7OqrARham5KYr4xV1v1lJcshkKr
	JreMIr+qcUH5Kf9PyqWVj+rKjAk9lkHSQ==
X-Received: by 2002:a05:7301:540d:b0:33c:130b:458 with SMTP id 5a478bee46e88-33e8e986d8emr312080eec.41.1790108611306;
        Tue, 22 Sep 2026 13:23:31 -0700 (PDT)
Received: from gio.scai.dhcp.asu.edu (209-147-138-22.nat.asu.edu. [209.147.138.22])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33e939fe502sm627194eec.2.2026.09.22.13.23.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 13:23:30 -0700 (PDT)
From: Giorgi Kobakhia <gkobakhi@asu.edu>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Xiang Mei <xmei5@asu.edu>,
	Giorgi Kobakhia <gkobakhi@asu.edu>,
	stable@vger.kernel.org
Subject: [PATCH] ocfs2: fix array out of bound access in __ocfs2_find_path()
Date: Tue, 22 Sep 2026 13:21:59 -0700
Message-ID: <20260922202159.2421642-1-gkobakhi@asu.edu>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__ocfs2_find_path() walks down the extent tree and records path by calling
find_path_ins(), which appends entry to path->p_node[]. It only has 5
spots.

A corrupted ocfs2 image whose extent block is pointing to itself causes
__ocfs2_find_path() descent endlessly, writing past the end of
path->p_node[] array.

 UBSAN: array-index-out-of-bounds in fs/ocfs2/alloc.c:677:14
 index 5 is out of range for type 'ocfs2_path_item [5]'
 Call Trace:
  <TASK>
  find_path_ins (fs/ocfs2/alloc.c:677 fs/ocfs2/alloc.c:1914)
  __ocfs2_find_path.constprop.0 (fs/ocfs2/alloc.c:1882)
  ocfs2_commit_truncate (fs/ocfs2/alloc.c:1924 fs/ocfs2/alloc.c:7286)
  ocfs2_truncate_file (fs/ocfs2/file.c:515)
  ocfs2_setattr (fs/ocfs2/file.c:1224)
  notify_change (fs/attr.c:556)
  do_truncate (fs/open.c:68)
  do_ftruncate (fs/open.c:194 (discriminator 1))
  ksys_ftruncate (fs/open.c:206)
  __x64_sys_ftruncate (fs/open.c:211 fs/open.c:209 fs/open.c:209)

Commit a406aff8c051 ("ocfs2: validate l_tree_depth to avoid
out-of-bounds access") already restricts el->l_tree_depth to be less than
OCFS2_MAX_PATH_DEPTH, which is equal to 5. However, does not handle the
infinite descent case.

Check if the el->l_tree_depth decreases on each descent. Maximum
descents are restricted to 4 and the path->p_node[] array does not
overflow.

Fixes: dcd0538ff4e8 ("ocfs2: sparse b-tree support")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Tested-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Giorgi Kobakhia <gkobakhi@asu.edu>
---
 fs/ocfs2/alloc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index be09e766ac1f..c85a472965d5 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -1817,6 +1817,7 @@ static int __ocfs2_find_path(struct ocfs2_caching_info *ci,
 	int i, ret = 0;
 	u32 range;
 	u64 blkno;
+	u32 prev_depth = OCFS2_MAX_PATH_DEPTH;
 	struct buffer_head *bh = NULL;
 	struct ocfs2_extent_block *eb;
 	struct ocfs2_extent_list *el;
@@ -1824,14 +1825,16 @@ static int __ocfs2_find_path(struct ocfs2_caching_info *ci,
 
 	el = root_el;
 	while (el->l_tree_depth) {
-		if (unlikely(le16_to_cpu(el->l_tree_depth) >= OCFS2_MAX_PATH_DEPTH)) {
+		if (unlikely(le16_to_cpu(el->l_tree_depth) >= prev_depth)) {
 			ocfs2_error(ocfs2_metadata_cache_get_super(ci),
-				    "Owner %llu has invalid tree depth %u in extent list\n",
+				    "Owner %llu has invalid tree depth %u in extent list (max %u)\n",
 				    (unsigned long long)ocfs2_metadata_cache_owner(ci),
-				    le16_to_cpu(el->l_tree_depth));
+				    le16_to_cpu(el->l_tree_depth), prev_depth - 1);
 			ret = -EROFS;
 			goto out;
 		}
+		prev_depth = le16_to_cpu(el->l_tree_depth);
+
 		if (!el->l_next_free_rec || !el->l_count) {
 			ocfs2_error(ocfs2_metadata_cache_get_super(ci),
 				    "Owner %llu has empty extent list at depth %u\n"
-- 
2.43.0

