Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45B6171A5
	for <ocfs2-devel@lists.linux.dev>; Mon,  8 Apr 2024 08:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712564470; cv=none; b=MvX0McHqo5qDUn+c7EjCNGoj4a7hebaorWQdOLD7ioTNBh5RlNKzhjt246h2lKl4/8urMcY6hmREP46nIwFxkgjzj/EsWKWbaImrnjmCQAwa55KUPdcbIiYCfM/37USJwanccg+dtbQ8zB5c+DvIyURI6VcWi5OqxXIKjjd6Czs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712564470; c=relaxed/simple;
	bh=mK7rcVaB2D0toNvRyCcgZ1X3G+t/7C+8rbRG8O1FM04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SfN5mAW9HKy/LW7zdMLs/a9NWDv+6j/jfuKm0/m3fNXT6oCxg/mCyDiqbs5/axWlIB9IF5uOl+PU3ZgpEFaw7TftCd1Rv8NyAFqaE9pmKu2L64KVcxd8irfBfSJBlDoc0pyfykxHlUrXlVoQ36v8+b09TWiTo2BJsamqv3oOm4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=c5KRKQ4k; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="c5KRKQ4k"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2d8743ecebdso20673851fa.1
        for <ocfs2-devel@lists.linux.dev>; Mon, 08 Apr 2024 01:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1712564466; x=1713169266; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i/UfPcAmlpDEI2X3qdBAd3zI4r9LsmLNdFyUr1d0two=;
        b=c5KRKQ4k3e8UYt+vJ+OtttFfsvtKVskq6qlKVCqkpmEVF3CD34V/WoNmxn/payoU3C
         N1lV5kXakB8SWvxzlIGhKa0kOI796BOONUUhdXNL/4EeYQ3/xeA9fC2sr6PWhulN1bj4
         78xEQ9USwKgpbTeNAoABxAIupFn6Ar08yZas7Qo3xOMkklllm1HyBFMm1jOjRsbLveNo
         Ct1azBE9uU2x8JBWlN0HWpFq540pbxzbDjMCF1FMqs3cBIa/erzGD6XCjpCJMjfb0Wcz
         38/kL28jfJGJzq2YnaGHxlIoBjizn30Gt9LnTh3t5YdGn0WBzObkgXgOBrNrJ6l/zBZP
         sVNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712564466; x=1713169266;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i/UfPcAmlpDEI2X3qdBAd3zI4r9LsmLNdFyUr1d0two=;
        b=thZGHJTJmetAKa+TQ0DaGvs307Bhv/9d79++g0fkkjle47D4DlCDlGKfvHdumI2tk8
         TsapQ0OKbcQeEB6ayqbUct6WBlW+l8dr/dyOI4bbGBk8m0tqpaGhCBuLR57nd7tyyvGX
         FCswiup+Ek4KIWtm2DFWHYBgeq9kNo+KKI9H+Fc9KhGaz6rKetxdmEUw+ApylepHlBm2
         MDQOlnlkIHenMxQOzqQ1CVRwKHcvbpOV3fKMsUe/B7EYLahukuC9IDqbr3WHlXfw45AS
         xgl/CjcN378zf7NY/e6+Q6RdyLhpAfpwUfqYS/kbDW2RtI16EXKITrGrf5aJMfW2NxoI
         N44A==
X-Gm-Message-State: AOJu0Yw6oFvubon3n3yIqh0hnMfLxwpx9pjXA0TqobUvb5IF3Efgk/30
	wHdB+VB8mdEREC+8o/i6JyR6zOTIogup0zPYUVZr4NmczxhbQSzhdEeI5KPSpbwIVa+mxW9TBJb
	g
X-Google-Smtp-Source: AGHT+IHzVSOiezSBXFvSq3/0put944IgNKdojUNy3Mick3/iwkhlz1nMjmrUTxqhXCFWs6ozpGuKOg==
X-Received: by 2002:a2e:b049:0:b0:2d8:1c09:cdc4 with SMTP id d9-20020a2eb049000000b002d81c09cdc4mr5919805ljl.21.1712564466129;
        Mon, 08 Apr 2024 01:21:06 -0700 (PDT)
Received: from localhost.localdomain ([23.247.139.60])
        by smtp.gmail.com with ESMTPSA id ft4-20020a17090b0f8400b002a54c4dd0f2sm213894pjb.43.2024.04.08.01.21.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Apr 2024 01:21:04 -0700 (PDT)
From: Su Yue <glass.su@suse.com>
To: ocfs2-devel@lists.linux.dev
Cc: joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v3 4/4] ocfs2: use coarse time for new created files
Date: Mon,  8 Apr 2024 16:20:41 +0800
Message-ID: <20240408082041.20925-5-glass.su@suse.com>
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

Fixes: c62c38f6b91b ("ocfs2: replace CURRENT_TIME macro")
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

