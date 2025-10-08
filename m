Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28BDA218AB9
	for <ocfs2-devel@lists.linux.dev>; Wed,  8 Oct 2025 04:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759897415; cv=none; b=K8bF+64yk5TMjorQqTkT/wo8glM3B0um/Dt8gI/VAmuEvtYRBx03z+pCz3dMHCX6uzdsdp2qmWVv/KRhwKh21YAQVy/bx4jEJ8AUgRELAFblg43CP8DH0NjzRCNKgxYSj25/XH1WLHym9RZ2tZxFen2ipEmVgfLyfrhJP5CBls8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759897415; c=relaxed/simple;
	bh=D8oStHzcz7/r9I2ztl+yPQZW7adQ4HY7aBSQCA8STv0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BSC2lBSCjnmaoiSepUoLbc+Sa8RDRtdFf3FiKSOrPo66uEn9BF0SL9LrURQTRofnphYfgyH6YFY5441b8txyCM6MPlvmQYtnoB2LIzLt1+/0M7Cj/7Yfl+EqXhcVOpugKkRUg/s8xspVmFGDqEVz3gHsPLMXdtj+E5/zoYWWiHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iuTKQic9; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iuTKQic9"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b55517e74e3so8127524a12.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 07 Oct 2025 21:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759897413; x=1760502213; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hEVi0oUCP/S6neTrRa1ElmpxEMfl3lohtPyax+Yify4=;
        b=iuTKQic9ZjEPwqQJGc2w6dNXq1/nA6UNWS6AeI22Lv0/SUICUnUiziDT5ErtrIcyfi
         5Zsu2PnkHIcrIlSJWHcKKTVvnUgVpIJuRhaXdrjZGA5Fvc1gOLHjOSZw4KjJWTJDLRC8
         D11cHoNU8Ebefb4b8tLkBwsHcS1lTe9a92p/1X6dZf1awBjQCpt0Ebgzty9dubMi83mN
         aLi1oHI4ReuYl5xLJ16Y6MJ7py82yGiup7LVuSYEHFT2B7lz4A9B6kOFYwLCRAsTvqUS
         5tkQVboGQvxSfVjBqogZpX/iWHQqCgTIn5TFZ5tLhMK65oRQdhwp7Fa0ijL/huE7kv2j
         kFZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759897413; x=1760502213;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hEVi0oUCP/S6neTrRa1ElmpxEMfl3lohtPyax+Yify4=;
        b=AFQFGH2cX8Tn9+ihPM21ZSmm5QnslM8EmPdpTI+KLTDTkikVH9M3Fx3WUgWak4rGGg
         IzKMQEgKSUL2AnTHaI1LOxa3rcR4twceWZTdDzxBxtLXTFxdfC1QL7IoNQmI2xv8MnSR
         Xs0jP5kjX7tel/h2PbgNvgdOA60xJ4Cr36yOe6NpAb6ni+n2/M5CoGmof6yjEvpGyWpd
         oLVk6KljEtSVJW/wb+dUuhnvaYpq66RT1sXeZiWaDmXTIedxXOC/2W4MJx9l6mhE0rXk
         hZyrGc4WsUaV4vmlX4RI96O+G8J6YQDiV6RorEjMe85wBq7viFItcJX7UWjhyy/t2i+0
         dmIg==
X-Gm-Message-State: AOJu0YzE1T/zLYbC4YUnhKrMyaNlV9UGZAwyA1e77AFxub56sSMrBDJN
	Lz0UhsUYTibBWNv14I0psYAwfYGRnpSgP9SbTDsbRnzjq9KoZzwPPfrkPIzrXe7dNTA=
X-Gm-Gg: ASbGncsYK7+MynnL5P3tAuM59cbtL41C3FPCzesuXEj4SgEoCKaaZiAWxuv398bpgr6
	50FNiZSDHhOHoEuqo+mVAs+azag/6r/yhQk7DfzJy2MN2Cz6QbrN5tc5tQSma1WQ6pxD4zgtEYS
	sYwF11vQIEDyy5leesrD4vJ/LIRNiVynMi4TDBGbGWfLuEeP5e3LEuIUeqPunZcUwarP4CC4GL7
	bstT12VWBmAglkdBwiqBO5AmkgPDSGV1RqKxJyaAfUifqzJTyYpTMNFzwMJzH/HvmruFeJpPWjy
	wIvzPlXTmUeGwVni1HL//S+SBwvxtIkvb+W68N61aOHDn9INKWUVJPJRKUeHEd7lmlwIzrDzN5G
	UVtjvfpM9YSv8t8IkMJT9f/7nWJbW3kGm89ErvEaaKXc1Tdsz2ZuipO97vE4ucCDP+9aW3auIEO
	cmUmYrF/EF2SY9t0v+pOWjhWOSkA==
X-Google-Smtp-Source: AGHT+IEJBnMCIgvoHdyBF9yP6PCao/mGhzvPLHd4Wu9DKbCAPpFelf/olPSoc4LkwkiKMOEZWgCxEg==
X-Received: by 2002:a17:903:2446:b0:25c:2ed4:fd7f with SMTP id d9443c01a7336-290273ffdd8mr25857445ad.42.1759897413285;
        Tue, 07 Oct 2025 21:23:33 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:b64c:5a0:15b6:8522])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-28e8d1d5e36sm183392215ad.114.2025.10.07.21.23.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Oct 2025 21:23:32 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+6fdd8fa3380730a4b22c@syzkaller.appspotmail.com
Subject: [PATCH] ocfs2: fix stale extent map cache during COW operations
Date: Wed,  8 Oct 2025 09:53:25 +0530
Message-ID: <20251008042325.468846-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The extent map cache can become stale during COW operations, causing
ocfs2_refcount_cal_cow_clusters() to see an outdated extent state.

The problem occurs when:
1. ocfs2_get_clusters() reads and caches an extent with OCFS2_EXT_REFCOUNTED
2. ocfs2_refcount_cow_hunk() performs COW, clearing the REFCOUNTED flag
3. The extent map cache still contains the stale REFCOUNTED flag
4. Subsequent access on the same extent via the cache gets incorrect flags,
   triggering BUG_ON(!(rec->e_flags & OCFS2_EXT_REFCOUNTED))

Fix by clearing the extent map cache at the start of COW operations.
This ensures that ocfs2_get_clusters() always reads fresh extent data
from disk during COW instead of using stale cached data.

Reported-by: syzbot+6fdd8fa3380730a4b22c@syzkaller.appspotmail.com
Tested-by: syzbot+6fdd8fa3380730a4b22c@syzkaller.appspotmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
 fs/ocfs2/refcounttree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 267b50e8e42e..e8c8fcdc3dd9 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -3451,7 +3451,8 @@ int ocfs2_refcount_cow(struct inode *inode,
 	int ret = 0;
 	u32 p_cluster, num_clusters;
 	unsigned int ext_flags;
-
+	/* Clear extent map cache before COW operations to avoid stale data */
+	ocfs2_extent_map_trunc(inode, 0);
 	while (write_len) {
 		ret = ocfs2_get_clusters(inode, cpos, &p_cluster,
 					 &num_clusters, &ext_flags);
-- 
2.43.0

