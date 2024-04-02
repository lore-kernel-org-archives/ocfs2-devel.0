Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F73C8C7
	for <ocfs2-devel@lists.linux.dev>; Tue,  2 Apr 2024 01:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712022441; cv=none; b=msEbwM0EtCOaBPe8JTplCJvSbJHjSgvNhSqQ1X7CWqFOOm4h/aITutvY3UMY0LhzoC1LMi4KXOUjgT4Ml/W01k8UvzGc2zufl6ukVQxT5zTNox9xlmy8/AehrcQX6Hj6EYn77XKi92fxf/wMzW7evkb1heB/MltnSvLWvHDWuLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712022441; c=relaxed/simple;
	bh=8oGjn3iRGkDedkAQsBFbxZDExs/2Ql0k8SR3maQAqdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uC6YtlXB1ZkbusIGrtLTK/tWjlFku4CBM8kSpQeqBne6mP6krbtkhDSou+mEDDZvX1IiAPVL8FrSehMyJTNI9yEeaUjPbJUYzFGLWieX+EZlEnZoZNSXqNdA7ZErtmRtLA4KbGdI1ODherMP/VJDx1riBt+DaPcnZAZ4L8d+XoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=T+jW1ip+; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="T+jW1ip+"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2d717603aa5so45715741fa.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 01 Apr 2024 18:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1712022437; x=1712627237; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PTWZKr+GPYmR6Lji/0XHBJhA+3gfx5XF9txCudo1MSU=;
        b=T+jW1ip+FvE9tGWd3P0ONhGpwzbliUS/Cd6P017sOnmjyoOX4Y8Ebmxo4otyI7KbKV
         PJpxqHBLv1TrbNYzr7roKlwLUZyhPhTumn3xGFihp3Hjbgdk3t7QYxDehSS4b5y0hEqy
         3YcO501wAEnYikbTT+ZFuvMvl40tjgwHAnPgO81t9p9xWWNKacVl/h9iyUkMt/cnqhWT
         CE0j7/i+pmrRxUxyssLGvx7DiEy/N6vGLcHdHTVfk2DEoIFCty0EE+bZrb5V9DwReg3U
         cMum/Zl3PV78LS3Ov6+kJNmSy3gogGFvfmYnnPXxXb0viSjlDNdWUGkcDRVdXP8DRDsv
         yCuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712022437; x=1712627237;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PTWZKr+GPYmR6Lji/0XHBJhA+3gfx5XF9txCudo1MSU=;
        b=wZdH9SPE0HZJsGs3KSyKIcI5vVrrOT4c73WMFrku7TfcQx9USeczc1QkTyNrFtGmQB
         KTPZy+rHljHMkiTWLU0Dej1lf/JUJYnR/2ocVDQ7Yq2DpuIumCH4uzT2W42WD6bn4fWT
         vTIey6tbp/5Zg/2iFKZDvK4jCfHu3PrsDKkUJBG4UdEpjrlVUQdXLSXya1Xpxn6CRsVt
         J8duQVrALjrrTum+JghSm/oxlgMyD8jt7hoBw+32xHfxSjE8MFH/+W+Y9yi7IhRYMG4G
         LUsZ05zWP6m/YGmR2deAum76fmBxvVnBRqHi2ukhXTk8BytXz3G3N2fb5cylzJm4eB+L
         t2Aw==
X-Gm-Message-State: AOJu0YxpmlrJVNG2RN6KebekqQJQmnHZL8q7TCNbc619Hioez9JBdeEC
	1/KtFj6YsQTNqQbZWHEY1T+sNEZcBad82LCSLWWzKSTCUpgxJ0p6MmB985mKsekrKaabpNuIGW7
	xTVI=
X-Google-Smtp-Source: AGHT+IHQXWxjmbycZcKlsiJbvvCH8mCHx9b7kklRaVFnSkSCAxs1kqB/fZOnsc4Q5mAaSpGtfRyn4A==
X-Received: by 2002:a2e:a169:0:b0:2d8:fe4:82b3 with SMTP id u9-20020a2ea169000000b002d80fe482b3mr3548498ljl.3.1712022437024;
        Mon, 01 Apr 2024 18:47:17 -0700 (PDT)
Received: from localhost.localdomain (ec2-13-212-91-37.ap-southeast-1.compute.amazonaws.com. [13.212.91.37])
        by smtp.gmail.com with ESMTPSA id le15-20020a056a004fcf00b006eade394613sm8049125pfb.198.2024.04.01.18.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Apr 2024 18:47:16 -0700 (PDT)
From: Su Yue <glass.su@suse.com>
To: ocfs2-devel@lists.linux.dev
Cc: joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v2 4/4] ocfs2: use coarse time for new created files
Date: Tue,  2 Apr 2024 09:46:51 +0800
Message-ID: <20240402014651.13723-5-glass.su@suse.com>
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

The default atime related mount option is '-o realtime'
which means file atime should be updated if atime <= ctime
or atime <= mtime. atime should be updated in the
following scenario, but it is not:
==========================================================
$ rm /mnt/testfile;
$ echo test > /mnt/testfile
$ stat -c "%X %Y %Z" /mnt/testfile
1711881646 1711881646 1711881646
$ sleep 5
$ cat /mnt/testfile > /dev/null
$ stat -c "%X %Y %Z" /mnt/testfile
1711881646 1711881646 1711881646
==========================================================

And the reason the atime in the test is not updated is that
ocfs2 calls ktime_get_real_ts64() in __ocfs2_mknod_locked during
file creation. Then inode_set_ctime_current() is called in
inode_set_ctime_current() calls ktime_get_coarse_real_ts64() to
get current time.
ktime_get_real_ts64() is accurater than ktime_get_coarse_real_ts64().
In my test box, I saw ctime set by ktime_get_coarse_real_ts64() is
less than ktime_get_real_ts64() even ctime is set later.
The ctime of the new inode is smaller than atime.

The call trace is like:

ocfs2_create
  ocfs2_mknod
    __ocfs2_mknod_locked
    ....

      ktime_get_real_ts64 <------- set atime,ctime,mtime, more accurate
      ocfs2_populate_inode
    ...
    ocfs2_init_acl
      ocfs2_acl_set_mode
        inode_set_ctime_current
          current_time
            ktime_get_coarse_real_ts64 <-------less accurate

ocfs2_file_read_iter
  ocfs2_inode_lock_atime
    ocfs2_should_update_atime
      atime <= ctime ? <-------- false, ctime < atime due to accuracy

So here call ktime_get_coarse_real_ts64 to set inode time coarser while
creating new files. It may lower the accuracy of file times. But it's not
a big deal since we already use coarse time in other places like
ocfs2_update_inode_atime and inode_set_ctime_current.

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Su Yue <glass.su@suse.com>
---
 fs/ocfs2/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 55c9d90caaaf..4d1ea8703fcd 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -566,7 +566,7 @@ static int __ocfs2_mknod_locked(struct inode *dir,
 	fe->i_last_eb_blk = 0;
 	strcpy(fe->i_signature, OCFS2_INODE_SIGNATURE);
 	fe->i_flags |= cpu_to_le32(OCFS2_VALID_FL);
-	ktime_get_real_ts64(&ts);
+	ktime_get_coarse_real_ts64(&ts);
 	fe->i_atime = fe->i_ctime = fe->i_mtime =
 		cpu_to_le64(ts.tv_sec);
 	fe->i_mtime_nsec = fe->i_ctime_nsec = fe->i_atime_nsec =
-- 
2.44.0

