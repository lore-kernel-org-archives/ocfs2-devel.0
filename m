Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62332264A83
	for <ocfs2-devel@lists.linux.dev>; Thu,  4 Sep 2025 15:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757000579; cv=none; b=Q5taebaiJjQ31Q+UFolFzchWSjsPo81MHs3g+mmch+ZT/Ciw2ZgIHG5k7kRgcXN+KFtX8KRHXYUYKB28xB6Cu5N61jZ/w9l86WI6f7Dc/Zr+QzNzN9Rt2Vt7lMbko3B9SDzEmwzaXJcfkZJDQ2517I+jilng2NfbvcOaUZuyXWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757000579; c=relaxed/simple;
	bh=gOe0pz0zArHDJpXSJ+UyWuJXMkKo6QQ0sqvBqWGwJFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QkYP6sJyLF9bCt1/xHKTOlfiMI96TxbHC7+UaqA52hRAO/ZjtnZwgEfgmKXWfqTbF153bqr6tGyICkTLsaYgnDXjGvxba1+lEqlcoYbx60xSshvA5TfOvXghTT9nbxeIv3jDW5RjlzbH50qh35nDaS2tzdGkYO/5D/saGbJ6neU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UgxnIXwV; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UgxnIXwV"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b043da5a55fso176724566b.0
        for <ocfs2-devel@lists.linux.dev>; Thu, 04 Sep 2025 08:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757000576; x=1757605376; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZxtEG0qwiZaZ8oHUoRK4vA/qZBBJzQqqcvVD5IAjpmA=;
        b=UgxnIXwV+jgZWz3m8RX617QCPAUBK8dV2ZJAPkaqGBYb6ZxTvpRnlO3/LtwSmo7s6g
         BWNkqoqMNA3v3rQ9yVnnkCfQ1MxrwJtjxdZqA+qjJZboSloHBNTX4I2VQ9XznOWQFljY
         V0bPU1ZRbv4ERzwA06pay+fSyblpFv0Jk//GWyvov5xCIzyQCa8G2C77RhURhMQN6LPL
         vLksVPgXrOUoP/pJaJpj2ZHdZAV38+TMhzVaNaVtJbt4+m3/EhCAfxqRl+ghf6+Kd202
         Slz0nEsAh9nbayJDJxUxtPkgFguJNrb2+Bn6GCSzjuNhNZrhtZr6oV+U3UyjvRN7QvM5
         m2Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757000576; x=1757605376;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZxtEG0qwiZaZ8oHUoRK4vA/qZBBJzQqqcvVD5IAjpmA=;
        b=JbqovRRqJYu/9JFJ9MCuwMlkpOgkBmOSBFUqTVVzF3fr0nP/wbpNTorUnQnXGrJb1X
         kvgQSb+vBLDntbFlNoR2K2INSWuyq8AcS2PEpJ40zZ0DZnuOrHrcY99p2x9NatVFlTtP
         TZkp5aTBxapw+bLqZn8lED2yI/PNxDOLik549ZnmUZOCh3wiBs40uxA+vp9wHQUj5r+S
         NtH5RLQx/Dr5H6YAMlwhY0hJwntyzz6RDY9nBIJSXQrbVZ7OlVugKvOhd5W5RTlO0TEH
         c1+4CenRYgBOA5zqufaars5VRV+ByBqvYiSI5/mtYlS99hHd/YRjdbQph4u/p24bzi01
         J2YA==
X-Gm-Message-State: AOJu0YzeUEQekn42Kbs/QjR5ZLEovwsG+WkfnKKfPNa+IVJn8BlO0s7R
	atL2IYrkOfI4rF7WnQyW0yXxlkeg1YdJQ+ixrb0BJCbkA59/8DRCXikKx58cpCyl
X-Gm-Gg: ASbGncuDq32jlKOcoUfsd8puHGgeuu0JbwXuM2gzVnXLv98bNt5enpoI/dSMfOpDZHN
	z0teJVwNClATNr9E4rWkOztqLNOe/r9I6IEHo674sQmGIXQGeYh4KaL/ZGKzbz0jZr7wnmnYcD2
	LAi4bbxOj+ju6JikKHQ6aioEHG1Bbi5u72nSqPRYxeA3yXw/jQIyTXf8Rg91K3cPxZOgZFTYeoB
	cEaBQxuhjZlAzR3CPzUxhLVBVKHdVD/3WGY1M+g8CvUxz/SGIHiiQ10wq7hmR79hXqDOFPV1/iM
	9bRLlDFBin1nVIjTm9rimemX/ZA5TbMerkQa2MXO1YBGnYTtMTSiGkCxjdeyIcbTyRUyg+SRDlW
	9g6SmYfze6wiLfzD109FhkTP42nwlFuqarPPrdFrWoImbcGnl1ek=
X-Google-Smtp-Source: AGHT+IFM3LxYoMMMqXwQh9SoZAimhtZroBuXTFmNhUUuKzs+mzhruTYm1oUTLuDrc1eRGUlI9Ahz8w==
X-Received: by 2002:a17:907:6e8d:b0:afe:94d7:775e with SMTP id a640c23a62f3a-b01d8a75726mr2093924266b.18.1757000575468;
        Thu, 04 Sep 2025 08:42:55 -0700 (PDT)
Received: from f.. (cst-prg-84-152.cust.vodafone.cz. [46.135.84.152])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61cfc5622f0sm14172711a12.51.2025.09.04.08.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 08:42:54 -0700 (PDT)
From: Mateusz Guzik <mjguzik@gmail.com>
To: ocfs2-devel@lists.linux.dev
Cc: viro@zeniv.linux.org.uk,
	jack@suse.cz,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	josef@toxicpanda.com,
	joseph.qi@linux.alibaba.com,
	jlbec@evilplan.org,
	mark@fasheh.com,
	brauner@kernel.org,
	willy@infradead.org,
	david@fromorbit.com,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [PATCH] ocfs2: retire ocfs2_drop_inode() and I_WILL_FREE usage
Date: Thu,  4 Sep 2025 17:42:45 +0200
Message-ID: <20250904154245.644875-1-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <766vdz3ecpm7hv4sp5r3uu4ezggm532ng7fdklb2nrupz6minz@qcws3ufabnjp>
References: <766vdz3ecpm7hv4sp5r3uu4ezggm532ng7fdklb2nrupz6minz@qcws3ufabnjp>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This postpones the writeout to ocfs2_evict_inode(), which I'm told is
fine (tm).

The intent is to retire the I_WILL_FREE flag.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---

ACHTUNG: only compile-time tested. Need an ocfs2 person to ack it.

btw grep shows comments referencing ocfs2_drop_inode() which are already
stale on the stock kernel, I opted to not touch them.

This ties into an effort to remove the I_WILL_FREE flag, unblocking
other work. If accepted would be probably best taken through vfs
branches with said work, see https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git/log/?h=vfs-6.18.inode.refcount.preliminaries

 fs/ocfs2/inode.c       | 23 ++---------------------
 fs/ocfs2/inode.h       |  1 -
 fs/ocfs2/ocfs2_trace.h |  2 --
 fs/ocfs2/super.c       |  2 +-
 4 files changed, 3 insertions(+), 25 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 6c4f78f473fb..5f4a2cbc505d 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1290,6 +1290,8 @@ static void ocfs2_clear_inode(struct inode *inode)
 
 void ocfs2_evict_inode(struct inode *inode)
 {
+	write_inode_now(inode, 1);
+
 	if (!inode->i_nlink ||
 	    (OCFS2_I(inode)->ip_flags & OCFS2_INODE_MAYBE_ORPHANED)) {
 		ocfs2_delete_inode(inode);
@@ -1299,27 +1301,6 @@ void ocfs2_evict_inode(struct inode *inode)
 	ocfs2_clear_inode(inode);
 }
 
-/* Called under inode_lock, with no more references on the
- * struct inode, so it's safe here to check the flags field
- * and to manipulate i_nlink without any other locks. */
-int ocfs2_drop_inode(struct inode *inode)
-{
-	struct ocfs2_inode_info *oi = OCFS2_I(inode);
-
-	trace_ocfs2_drop_inode((unsigned long long)oi->ip_blkno,
-				inode->i_nlink, oi->ip_flags);
-
-	assert_spin_locked(&inode->i_lock);
-	inode->i_state |= I_WILL_FREE;
-	spin_unlock(&inode->i_lock);
-	write_inode_now(inode, 1);
-	spin_lock(&inode->i_lock);
-	WARN_ON(inode->i_state & I_NEW);
-	inode->i_state &= ~I_WILL_FREE;
-
-	return 1;
-}
-
 /*
  * This is called from our getattr.
  */
diff --git a/fs/ocfs2/inode.h b/fs/ocfs2/inode.h
index accf03d4765e..07bd838e7843 100644
--- a/fs/ocfs2/inode.h
+++ b/fs/ocfs2/inode.h
@@ -116,7 +116,6 @@ static inline struct ocfs2_caching_info *INODE_CACHE(struct inode *inode)
 }
 
 void ocfs2_evict_inode(struct inode *inode);
-int ocfs2_drop_inode(struct inode *inode);
 
 /* Flags for ocfs2_iget() */
 #define OCFS2_FI_FLAG_SYSFILE		0x1
diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
index 54ed1495de9a..4b32fb5658ad 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -1569,8 +1569,6 @@ DEFINE_OCFS2_ULL_ULL_UINT_EVENT(ocfs2_delete_inode);
 
 DEFINE_OCFS2_ULL_UINT_EVENT(ocfs2_clear_inode);
 
-DEFINE_OCFS2_ULL_UINT_UINT_EVENT(ocfs2_drop_inode);
-
 TRACE_EVENT(ocfs2_inode_revalidate,
 	TP_PROTO(void *inode, unsigned long long ino,
 		 unsigned int flags),
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 53daa4482406..e4b0d25f4869 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -129,7 +129,7 @@ static const struct super_operations ocfs2_sops = {
 	.statfs		= ocfs2_statfs,
 	.alloc_inode	= ocfs2_alloc_inode,
 	.free_inode	= ocfs2_free_inode,
-	.drop_inode	= ocfs2_drop_inode,
+	.drop_inode	= generic_delete_inode,
 	.evict_inode	= ocfs2_evict_inode,
 	.sync_fs	= ocfs2_sync_fs,
 	.put_super	= ocfs2_put_super,
-- 
2.43.0

