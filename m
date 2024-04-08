Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF682C859
	for <ocfs2-devel@lists.linux.dev>; Mon,  8 Apr 2024 08:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712564466; cv=none; b=TRz+xz3s0vZWl2xm5q/fbUs6oMljstGsp2LLRKDVM1m5n5l0vdfM2bWSCSuK9Sv5snvNcRFZSWg5YogiI8FW8R3L10W0cuS7DpLGOI3gIfcohCXybuadlDs7pKPHs1oBYlSeM/hkQZxZKFqtWfPXprzytHulpA1pbjA4hpVka3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712564466; c=relaxed/simple;
	bh=E8uSWe7pC+CVsWMJcUUu1kL8RPlbZxsgmhC0boH9X+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HXAg2U6Grll+vX09B+ic3bfgiR/u+334h7Cos1E4JUeLj/OJsZiY4d4C256rZ2wxdOg9J5cMliiygyINxIrNFNeQwrxd3W7Dpj5Qx5O6NJqkgIuYgEe7wAaIOTzJC+omm8mVOkKW2cDU/Xmxwg6V22LEKLCf8uC0Ph+IRKsjuuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DnKkB6V0; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DnKkB6V0"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2d6fc3adaacso52738061fa.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 08 Apr 2024 01:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1712564460; x=1713169260; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uFmqypw/aseL1xkegBMxmm6qJqyDfXccXXSHs6zN11E=;
        b=DnKkB6V02/BUTIdiGsgFlBf3ZxthbqmeFy6pkX62qN6i0I3bTSbsGZvCKJN55IL0L5
         KiS98EQlbHU496OlulVhHpcDnpABM/Ae+h0Avbl93QI0kzBPYwWkLydw9g5vAYri4V1i
         XD0B+eBDfnVSquvOiMBxN2NmhE/A5eUF3kCO7m1p8qZqQ2aIWzU1xtlRWfRkQ1ob2CfS
         oo08jTBZZT2y6QzEvfmYp0zhIlfUbKX/t7WUvkcj7hCWGAolBZKi7dYMI4CvMP/OwpwM
         47q0ICG5KJr8h0M+D6MupaRIPsxgqy+sW8NEE6qBMEsmMpxowORZlsO8CKVpAAlprhxu
         3UNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712564460; x=1713169260;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uFmqypw/aseL1xkegBMxmm6qJqyDfXccXXSHs6zN11E=;
        b=cZEjd0UCpYnBSHpL3dsfA0TEUOnEUMu0AXLtj2rkqmiiVz/U5go82V5UYqtGtVfLiK
         whvKpVSctqQbX/rDjJ9bcJIhtfeIZkxIBqDvSDmaqSiq2NjmJhCRg2sJ8y27yL0eSSCs
         Ofunvtuj6XMgc+ztWPHwKylrO2xFq3rRJsiJWz5B0tdWPAPBAVXghL+MBVPHspR//fdv
         kxtGzCeA9L9cfRKyJ5JgkxnI0SV9TLP7kLNSm+3DJyj1UX8szbcU46BLSlbwGv9YhgHc
         n2id5d4k+XflM5nT7WNC2eV/e4hvpmzvinXbcUlgSdc6E+k0N0DQiPTiKCncC+0MuM1D
         z4Vw==
X-Gm-Message-State: AOJu0YxaZ+DMUJl7Q3YvmARoFzsxpsy45Ag3T1tnRQRjBMSrPuTUPduJ
	mGrvUQm4mmyCutxgJq4kt/sewoCGHUlri9jqR9bybWFrfzqw91bb/wG/q4s6lUEemnbJltjQr08
	E
X-Google-Smtp-Source: AGHT+IEqq1vha+qKaVfI1kyySiExDvzAayata71PCI5zFqSP6Oueu4/iT+nyoyyycsFGyfuAHTXxZQ==
X-Received: by 2002:a2e:8755:0:b0:2d8:687e:4fef with SMTP id q21-20020a2e8755000000b002d8687e4fefmr5189466ljj.12.1712564460545;
        Mon, 08 Apr 2024 01:21:00 -0700 (PDT)
Received: from localhost.localdomain ([23.247.139.60])
        by smtp.gmail.com with ESMTPSA id ft4-20020a17090b0f8400b002a54c4dd0f2sm213894pjb.43.2024.04.08.01.20.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Apr 2024 01:20:59 -0700 (PDT)
From: Su Yue <glass.su@suse.com>
To: ocfs2-devel@lists.linux.dev
Cc: joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v3 2/4] ocfs2: fix races between hole punching and AIO+DIO
Date: Mon,  8 Apr 2024 16:20:39 +0800
Message-ID: <20240408082041.20925-3-glass.su@suse.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408082041.20925-1-glass.su@suse.com>
References: <20240408082041.20925-1-glass.su@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After commit "ocfs2: return real error code in ocfs2_dio_wr_get_block",
fstests/generic/300 become from always failed to sometimes failed:

========================================================================
[  473.293420 ] run fstests generic/300

[  475.296983 ] JBD2: Ignoring recovery information on journal
[  475.302473 ] ocfs2: Mounting device (253,1) on (node local, slot 0)
with ordered data mode.
[  494.290998 ] OCFS2: ERROR (device dm-1): ocfs2_change_extent_flag:
Owner 5668 has an extent at cpos 78723 which can no longer be found
[  494.291609 ] On-disk corruption discovered. Please run fsck.ocfs2
once the filesystem is unmounted.
[  494.292018 ] OCFS2: File system is now read-only.
[  494.292224 ] (kworker/19:11,2628,19):ocfs2_mark_extent_written:5272
ERROR: status = -30
[  494.292602 ] (kworker/19:11,2628,19):ocfs2_dio_end_io_write:2374
ERROR: status = -3
fio: io_u error on file /mnt/scratch/racer: Read-only file system: write
offset=460849152, buflen=131072
=========================================================================

In __blockdev_direct_IO, ocfs2_dio_wr_get_block is called to add
unwritten extents to a list. extents are also inserted into extent tree
in ocfs2_write_begin_nolock. Then another thread call fallocate to
puch a hole at one of the unwritten extent. The extent at cpos was
removed by ocfs2_remove_extent(). At end io worker thread,
ocfs2_search_extent_list found there is no such extent at the cpos.

    T1                        T2                T3
                              inode lock
                                ...
                                insert extents
                                ...
                              inode unlock
ocfs2_fallocate
 __ocfs2_change_file_space
  inode lock
  lock ip_alloc_sem
  ocfs2_remove_inode_range inode
   ocfs2_remove_btree_range
    ocfs2_remove_extent
    ^---remove the extent at cpos 78723
  ...
  unlock ip_alloc_sem
  inode unlock
                                       ocfs2_dio_end_io
                                        ocfs2_dio_end_io_write
                                         lock ip_alloc_sem
                                         ocfs2_mark_extent_written
                                          ocfs2_change_extent_flag
                                           ocfs2_search_extent_list
                                           ^---failed to find extent
                                          ...
                                          unlock ip_alloc_sem

In most filesystems, fallocate is not compatible with racing with
AIO+DIO, so fix it by adding to wait for all dio before
fallocate/punch_hole like ext4.

Fixes: b25801038da5 ("ocfs2: Support xfs style space reservation ioctls")
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Su Yue <glass.su@suse.com>
---
 fs/ocfs2/file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 0da8e7bd3261..ccc57038a977 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1936,6 +1936,8 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 
 	inode_lock(inode);
 
+	/* Wait all existing dio workers, newcomers will block on i_rwsem */
+	inode_dio_wait(inode);
 	/*
 	 * This prevents concurrent writes on other nodes
 	 */
-- 
2.44.0

