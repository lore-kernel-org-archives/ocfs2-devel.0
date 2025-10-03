Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5FF2D6E78
	for <ocfs2-devel@lists.linux.dev>; Fri,  3 Oct 2025 02:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759459025; cv=none; b=qVpsAvNqA7vD9jANS4W5lD4OrOz7F6o0PlJBhbCsYG39+KejhA6S7ORlVYhcnJtHdQ8LQqVULH/gqSRvGiLzUUoSYMw5mSRVrhg1HwU+7IJ2r+EJjfGUh3ETW4jfELJ+1OpbbHTyEzMbVTbAfsAu6XiFb5/CirPo9MqVBt6tFCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759459025; c=relaxed/simple;
	bh=PMyWwSVypT6YzQkLu9bGNQp85E1aA4w3ZEet4c0nf08=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ukhwRwUwGFojPpufLGfloWyfnwSKlJweMMlOZObBDtRVs1nj1sAkhV4Hd2V4j15SlPjqkrRz5XoAuU954oVdyQIQa2qLE3VUs5gYhzq5/MvnsW/KaheyP9lZzEtJJ4HrhL1Iavnmdru/Pi1zu7kH2SS3fUrdbwg3ye//1Pd+Ly0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j4mNl1BO; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j4mNl1BO"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-46e2826d5c6so13416685e9.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 02 Oct 2025 19:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759459019; x=1760063819; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kInZH3ybt0N4GUH4VhcSZWifxUtF3rFyE9dacK0tDJw=;
        b=j4mNl1BOR2YoArDc+aqjpmKgLP9HHlEEusDJOZ9x+ZIFIPGFDuNIrlr1+Z/IG6TF4g
         vybDhhPWycoQcjxn8Mta+oqvk9Qp5PIZFN+eztCTXyYMA1uII5X70lC+HC5VGtSjw+27
         aH323AOYfhtaf/LNH/0tfencgTvj0VDXvJ8mdIoEGAS3arBdeQsLlxdtpe7Pdzwkbxs8
         Gx54CP+nX+sLjuoy3Xxs1xGxBSg8CQK/RjRXCkLrpIVRRvJdkNIFVJzbnU2U9UYJ7fUl
         +rkcWr1njh0vrTMZ4l+L9zI+XPBU4UnyIDyhsiqry9SdTD69G1AnO5pGbZY/4tXwXGUJ
         CBUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759459019; x=1760063819;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kInZH3ybt0N4GUH4VhcSZWifxUtF3rFyE9dacK0tDJw=;
        b=YyMbCU3LFwP41+pLxnDi7RIlSB8cDdtEJFdCxI45LV2sRN22oIRESFof3R52wPPChB
         +M4GKdKtZo3SKLJtGxXXsF7pOPNGWo1vKLQ5j1U/+Q5EE8L6KNFzb0McK0PxxRdeJtMW
         fvXTjHRaei8P80ZCagRjRLVpDgYMBMrCT+qAjKLF6OoqIuoU//VKoJ8PXkCfznChxnxw
         cg2zJVNe7j+/6/YOPXLntF4aaEXzFNexOIb2oH4zM6GEA+icoOh6Mr2Z9jv5mC+kcIxX
         R7WnB6WjXHSaff0m1OEETJR6L7TV+1bxhVQKjQsUXT8/PYlcsMGw57630xUqUVnY4IFS
         87dQ==
X-Gm-Message-State: AOJu0Yy7FG149xSUX8TI4l6+z4nbtHBka8KD+3Xykz2RCcI5vRMBAHTx
	kfh3QmVPJDvBaL04xovxKRe9JspkNXM2zp2yBa04rjT+UdqseLIwjeI+9wqWHA==
X-Gm-Gg: ASbGncuL1xAzXGSRp9ofxpSXjYDs4uiNpbCMFkq/XQaUNbeg2+dxwAED8T5TqLyOmhS
	Nv48IUNsiDEsgIXtGR+kX4rGcYiEN/8pEhBt1ucsIR1ZEVxe0dHKFk3bRYZj9EJ0QIR/rK+obi3
	bac9MziksHir9rAXIqgm3UcHfjKNqAIWiUi/GZ62a2yd71ffA4oSAf2XTIql6umyPYe0R2ZJeOY
	PiESU/L0Iih292afg17RuoD1eIqnNPN0Mt58o6bnj5eghJuDobtSGY1xgn6UH49vUoIc/wgCPGI
	p6zpGFBcGrpgEunsnzezZjXuXsKSijJr5z+VXJiuBRCfyqAzhG5Vmu+4ouNRGKjonDZBNcge/im
	ixDzSouNNsYcpeQLGJkDW4QuzwHyj0VDtMjCpL+P5dS2KuZik8ekDtjqdG5K4FUhtDePshwxi+L
	jDxchGVK0xa+aYmM3zmpZKgargc4xwdg==
X-Google-Smtp-Source: AGHT+IFnJmy/ISWGEMnszAV7obn8uhvVoBfP0ixq0j6PZ8m6J96bhx4tpgaPl980VA8pVhJ6UOgtKg==
X-Received: by 2002:a05:600c:8b6e:b0:46e:3d50:362a with SMTP id 5b1f17b1804b1-46e710ffff6mr8234125e9.4.1759459019014;
        Thu, 02 Oct 2025 19:36:59 -0700 (PDT)
Received: from f.. (cst-prg-21-74.cust.vodafone.cz. [46.135.21.74])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e619c3ac3sm108743995e9.9.2025.10.02.19.36.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Oct 2025 19:36:58 -0700 (PDT)
From: Mateusz Guzik <mjguzik@gmail.com>
To: ocfs2-devel@lists.linux.dev
Cc: jack@suse.cz,
	viro@zeniv.linux.org.uk,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	joseph.qi@linux.alibaba.com,
	brauner@kernel.org,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [PATCH v2] ocfs2: retire ocfs2_drop_inode() and I_WILL_FREE usage
Date: Fri,  3 Oct 2025 04:36:52 +0200
Message-ID: <20251003023652.249775-1-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
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

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---

v2:
- rebase -- generic_delete_inode -> inode_just_drop

The original posting got derailed and then this got lost in the shuffle,
see: https://lore.kernel.org/linux-fsdevel/20250904154245.644875-1-mjguzik@gmail.com/

This is the only filesystem using the flag. The only other spot is in
iput_final().

I have a wip patch to sort out the writeback vs iput situation a little
bit and need this out of the way.

Even if said patch does not go in, this clearly pushes things forward by
removing flag usage.

 fs/ocfs2/inode.c       | 23 ++---------------------
 fs/ocfs2/inode.h       |  1 -
 fs/ocfs2/ocfs2_trace.h |  2 --
 fs/ocfs2/super.c       |  2 +-
 4 files changed, 3 insertions(+), 25 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index fcc89856ab95..84115bf8b464 100644
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
index 53daa4482406..2c7ba1480f7a 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -129,7 +129,7 @@ static const struct super_operations ocfs2_sops = {
 	.statfs		= ocfs2_statfs,
 	.alloc_inode	= ocfs2_alloc_inode,
 	.free_inode	= ocfs2_free_inode,
-	.drop_inode	= ocfs2_drop_inode,
+	.drop_inode	= inode_just_drop,
 	.evict_inode	= ocfs2_evict_inode,
 	.sync_fs	= ocfs2_sync_fs,
 	.put_super	= ocfs2_put_super,
-- 
2.43.0

