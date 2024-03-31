Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC7C1442FA
	for <ocfs2-devel@lists.linux.dev>; Sun, 31 Mar 2024 11:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711883892; cv=none; b=XROPrcsz/SdzQY3MKZ8qNV+owTPUzYGO7QkUfyL4XZ5buqsriUzQWLZLGY/Pe+r8bV9dgjNBGLY0SSZHvglytVjq5Z1U5IJC+HPYNQ3fLXt4qTysR3l4Wru7sET9TJ4drt/4++O68hHWaCF9qknU2bQRdE+rwKaOWBBI37AnJXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711883892; c=relaxed/simple;
	bh=DOex7CGw7TFwaQd5ETH7zR+CC9p5DbgZCd6vAL+rEkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PdnXguvACxAj3y9iNCmPEFbxnmVpSft7zlJwYeky2qi3oUxPzC4iR/VcO4fVqvLPVeZgyUIZ6n1+pf1BHgVgli1M+WAF/SwIUgyOadfl9O0c4Mhy5jv7atcBqy7xu22vT4MoUVM8dBqAeD1hHSQwdcCiWKtIGZh8TAn8XYN5054=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Nd6YzTWJ; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Nd6YzTWJ"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2d4360ab3daso40662651fa.3
        for <ocfs2-devel@lists.linux.dev>; Sun, 31 Mar 2024 04:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1711883888; x=1712488688; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Km+jDANif7I/AMHSXKPmlrg/mE66VhLcfDV4Zun9vdk=;
        b=Nd6YzTWJaLBNbNGAwo8KJfdPRqqbLmCj3tr8CvClITVdFIHNpU8rqp8ENe0bpWiU4w
         zWYccan8Ze+IEzeLXShAMlnjleX5A8Qb3ed60b/VaDbkP/Um5AyjNaSU+7vOFMTA//zz
         1f/D/qqQQ5OgWOmMBou0xOmOXpcIipXbQfLf6nIw8t4apW+hjeRvv3IS7p3n9+5hUvV3
         GD3JaD7iRZfLhBF3RRpNKdk7nkMVplRYYhEcSMja1p27QDnQha8BOMh6Rzb+MMoIe/cB
         ERpvSpowcTGRijeWEEpesZHislFzf5pz8ljd6o1Yy+JrswCSZ5neZQbmbu+plObTp7Ir
         Oz2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711883888; x=1712488688;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Km+jDANif7I/AMHSXKPmlrg/mE66VhLcfDV4Zun9vdk=;
        b=vhFLw1I6VXY+oZsnDB9RJx5Rd0t6XCh7/O5n9VNsvAM44BhYb41guLuip+rNa+yrJk
         3w6b6KKBwKON1q+dqeB6hDIgUsEIwqwVa3vhMp+kofhonSYCRTQ+SpbQvpMmkaao6q/n
         cqiYz/5XsJAtW2Bpa1l1VWdwlyGJUGg3tbziM6HBjDqoxnxuFYtaeuUx/n1owcJWB957
         u2O6EXpRhPPOvpH9o4OGh8dpApbBhP6oXRHPKNWYF9Js1ADEp+PjqP3m1NJJnas+fbp9
         DDKoy0iuPMvP6rSjHqVrgRjQ2f8/8Chmv4le5+2sMCEKmA8iUxl7NB7Cs8znGlU1kTJQ
         GyNA==
X-Gm-Message-State: AOJu0YwkvQcZGqFFLbKX1XVpt6dWgY8JGnv+eTV7vdcusrbpxcVIJHXQ
	VyyHP7JHtPQJ7d1nrUY/TfZeuMsKlYIVLJwnCdI6DiN984bZJfvfsXUnfzceouXerPOSK6bRadn
	m
X-Google-Smtp-Source: AGHT+IE0XEHWUnYla2VxDyG8r/pvDe2tsMZHTRSr29/mrcGxJ0sjqGPqcVHufWY/U7Ehc7YqUqfnjg==
X-Received: by 2002:a2e:3812:0:b0:2d5:9703:263c with SMTP id f18-20020a2e3812000000b002d59703263cmr3683533lja.4.1711883888041;
        Sun, 31 Mar 2024 04:18:08 -0700 (PDT)
Received: from localhost.localdomain (ec2-13-212-91-37.ap-southeast-1.compute.amazonaws.com. [13.212.91.37])
        by smtp.gmail.com with ESMTPSA id bf7-20020a170902b90700b001dd82855d47sm6675406plb.265.2024.03.31.04.18.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Mar 2024 04:18:07 -0700 (PDT)
From: Su Yue <glass.su@suse.com>
X-Google-Original-From: Su Yue <l@damenly.org>
To: ocfs2-devel@lists.linux.dev
Cc: joseph.qi@linux.alibaba.com,
	Su Yue <glass.su@suse.com>
Subject: [PATCH 4/4] ocfs2: use coarse time for new created files
Date: Sun, 31 Mar 2024 19:17:44 +0800
Message-ID: <20240331111744.7224-5-l@damenly.org>
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

