Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01076D502
	for <ocfs2-devel@lists.linux.dev>; Tue,  2 Apr 2024 01:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712022436; cv=none; b=fkup0FIzsIQB3acRJ2DaWtzfwTVEAeO/g+s93LyZt3EkLxVvdadqydfYqwLtqP6ieRymvLOEBH8BJXrIkp5bsvmjgw7p5XGcpu2ujytBnKHTHcVxflCdbiCCHYsIBffTqUvm01NlR/URwtnL/H85xA2XO5iCssXge4Jv5Q5wW+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712022436; c=relaxed/simple;
	bh=TIoj4b8I1jHFhfIoJ65OFf4T7AVTmE6ONB18D06FN+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DQ7H6bSYuxVdffwXKMJnUw3uNzLY0YU6K3bcLVT3w8qbnkbE2SNE0ct3Ob65E9t9S4yt5Jvakqu2rEW865OlG4Log/5GMIiSKSRj8uiYWU565NLcixD5VLTdl6j1VwlQ26FC8witBCtFJWidY4r1+P7WYDHvnXWoEMoPjHjxDrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZpSUunAU; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZpSUunAU"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2d6ee6c9945so34331491fa.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 01 Apr 2024 18:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1712022431; x=1712627231; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dCUgws6X8Sh5TTfS/1uimD3a4eMEXUsrpssDQsUE2PY=;
        b=ZpSUunAU4k6jYbLS4lC/0P0VIPFkhiJFZM0myQeSI1xwwo4gk2aVvyz36r/PMJFsm+
         5fKSj8lF8LKmAYtBICK1VCafm7rTes2lsoWKGLKxiAkuBKpya7s3umAUaYnLSROIIOCx
         RpGaCFkFPRWy+q/nhgvkThOrL70+4rB/9y87m4uGIoAop04YxcWm3zNKFiw37tnqBIji
         G/Yq3JElMwg8IjZo6BG2M3JiSwPK7miHD1JaPJrW7tStkVdvMlJtjneaFG3XuDeth3uE
         Hz17tkg/FNxHd6rfvoDG2Py9YTtN73C76sKDKGsv3FdzZ9qiWhOWGNQBP+2UKn77hjNZ
         61oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712022431; x=1712627231;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dCUgws6X8Sh5TTfS/1uimD3a4eMEXUsrpssDQsUE2PY=;
        b=UZcUq94O1pAcViC+x7OQNvevTx3sAF+V0peOeVLwqoyGjbd2a4F5SzUeBs/08e0CXz
         EFEPJEdfT7xHnSwcTYWCtUTyrgjeyQk2SgXA+yX4TbmCX9yzGoaV49RefvqSzmffTE3T
         vMawIbM3Dc7bwSonGmN7ApqJKa5nZJuQdjfwc6wNaeZQy5N0PsnXNu8vekYqkvSk34ht
         iV7fsC5GwopC0c25r0CtXAM265Af1AJt9CzFscWIxkpImVE+WlPN7BQveSm/JdloyENN
         85jbE/fWU34uHdOLMdqkZSd50LIvSdK09EOFalvS70STy8oG8Y2VfAxkL6y8zAXzQeuk
         TeXw==
X-Gm-Message-State: AOJu0Yw1KLKhqu9KqQbcuudW1uZBwP0NvLTDN7HCNXuogYzrJmSIx9BU
	cUOFpRvtFApwt/cT+XWMV5h2hoI0MbR7QoJS+vMV1XEebsI0N7NOEN8P8RIsWuBhv43ISIOck3K
	x5FE=
X-Google-Smtp-Source: AGHT+IH/Lyjv2zbbb+yO9QBNG6yXqj3OrpJfC/SOBYYJPWr7HOljF4ZAEAiIHE/EOrEPUZTFIbwWLQ==
X-Received: by 2002:a2e:9059:0:b0:2d8:2714:6d2 with SMTP id n25-20020a2e9059000000b002d8271406d2mr746401ljg.3.1712022431451;
        Mon, 01 Apr 2024 18:47:11 -0700 (PDT)
Received: from localhost.localdomain (ec2-13-212-91-37.ap-southeast-1.compute.amazonaws.com. [13.212.91.37])
        by smtp.gmail.com with ESMTPSA id le15-20020a056a004fcf00b006eade394613sm8049125pfb.198.2024.04.01.18.47.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Apr 2024 18:47:10 -0700 (PDT)
From: Su Yue <glass.su@suse.com>
To: ocfs2-devel@lists.linux.dev
Cc: joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v2 2/4] ocfs2: fix races between hole punching and AIO+DIO
Date: Tue,  2 Apr 2024 09:46:49 +0800
Message-ID: <20240402014651.13723-3-glass.su@suse.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240402014651.13723-1-glass.su@suse.com>
References: <20240402014651.13723-1-glass.su@suse.com>
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

