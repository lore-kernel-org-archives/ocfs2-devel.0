Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800801442FA
	for <ocfs2-devel@lists.linux.dev>; Sun, 31 Mar 2024 11:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711883888; cv=none; b=PedkiDqCqkLZOSkVah6p7G7VFXWrsNDtMqYKx9NVk5Zaxie7xri20K69vIOitQUptWqaHVzppXDQE4NrROyiX907gW9TlsNyjoxc6M14Z4kw7pxEfSJCXVt82tvDgiTW9FcJIKi/yDV+SsD0S6RX1dfo6hTHfXAxCevVqudrGLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711883888; c=relaxed/simple;
	bh=sbjMr5jfwkPXJ/O8gGM00uKG1NThXFSW+JiOZTT3VpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o08PXEZdk2Kh36zQ1FohuL/51+/amsih8u4dZ1eNIy5IDLzxX3EaX0dgjK67nWwGeB3ceTYJHj6VSrTKmTPoK09/DKDVqn0WMhiUeNny+A8fj3UJRsJ41Qt6ugw5dcqqxlxYTcB3Eo4l39fH/mqfN7R5mV/0UAqGIcfi597/KQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EYQ6MJTp; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EYQ6MJTp"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-415446af364so15607715e9.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 31 Mar 2024 04:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1711883883; x=1712488683; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nk1prEhmGw+YU4Esrv9p4w9EPzRb8tVvXPFv1JsN7rM=;
        b=EYQ6MJTpVLdpeqHLaEqhbc37YmdK0d3vSYlLxIVu/eGYhTmaXuggk7yNdu7mQG/BvL
         Aury/1jXoqFjPdFxsrsMa1SeiFg9j8NAzZpgaQeBjEqQj72d6n2asMR7mJTnSDXgGu7b
         ta2epq39cFXh1pNek80euNfPvFA7tseumqBgR2zPjpl91Iw8A4A/ZJzlKTaQ9RHNMpte
         lYUSc4Yx+gx0L8eiZ9Ua+mOE5hk9zRh8i44wrk1XpsX4hXREKDhqh+iGOPf9qCQ8mzoY
         8QrbO/v1TH4/DbUBkvSEbsvM0yIfRf9d6ovfpumAGLhbhbMhG5v2lo6hXrfcrzI+CF0P
         o0PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711883883; x=1712488683;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nk1prEhmGw+YU4Esrv9p4w9EPzRb8tVvXPFv1JsN7rM=;
        b=jIQuxfzsGU7HmWy7vZODvFOkre3b3K4mXXy9qJMlIIeFen068U6wlKmzqTZLDV7tDI
         7aWNLr0TW3d8LV7L86ILCfbFNsiRafi3zn9v0SQ/RKgd37uRMivJ61GlAsxLIrSk8Odt
         B93X6z7Ts/UCgNGelkHK6hxrJ3bQ8GBUreFbKMtMe5efj12dROuQpog2nhQ0pHAtpfoF
         8sOFFEhpzkYOD1kCGNx10/n67qXEU8zr9DhCfRiB2TvBVxqKyHzK5M/UEidiDWTHGlLM
         P882I37f8a+7uz9nyhC9p1m1Ly6Ft53I5+L4k1gzMQz0EnQ6H48/mnCLWyKMDxOo81kx
         PdGg==
X-Gm-Message-State: AOJu0YwsVvuaaHCigcxO2lvAebTERBgnxUnL9PHtqOgRCnWzh4eOizGn
	01T47MtmcXM7k2Zg3DNYf5FgG2d42Qdkese3TMApV7S/tXBKi8wHbOcNj+SfejvYatQ+S4J0wCk
	j
X-Google-Smtp-Source: AGHT+IFsXIh+vQDry68Gi0ZTf6Cf6jep1pe6+vRbfXa2WrRx+e58G7EwJFSpxWsiTb9MrAxKn0JXRw==
X-Received: by 2002:adf:f287:0:b0:33e:c91b:9083 with SMTP id k7-20020adff287000000b0033ec91b9083mr8122299wro.16.1711883882977;
        Sun, 31 Mar 2024 04:18:02 -0700 (PDT)
Received: from localhost.localdomain (ec2-13-212-91-37.ap-southeast-1.compute.amazonaws.com. [13.212.91.37])
        by smtp.gmail.com with ESMTPSA id bf7-20020a170902b90700b001dd82855d47sm6675406plb.265.2024.03.31.04.18.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Mar 2024 04:18:02 -0700 (PDT)
From: Su Yue <glass.su@suse.com>
X-Google-Original-From: Su Yue <l@damenly.org>
To: ocfs2-devel@lists.linux.dev
Cc: joseph.qi@linux.alibaba.com,
	Su Yue <glass.su@suse.com>
Subject: [PATCH 2/4] ocfs2: fix races between hole punching and AIO+DIO
Date: Sun, 31 Mar 2024 19:17:42 +0800
Message-ID: <20240331111744.7224-3-l@damenly.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240331111744.7224-1-l@damenly.org>
References: <20240331111744.7224-1-l@damenly.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Su Yue <glass.su@suse.com>

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

