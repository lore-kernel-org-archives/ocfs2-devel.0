Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089E4199E80
	for <ocfs2-devel@lists.linux.dev>; Mon, 23 Sep 2024 13:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727098154; cv=none; b=r8UMG0FkTeJyR4SOowPF3B/pvSzxuijCWPoE2ypeP7AJ0pTNkBtsXoYzf+HgZIRZ1xZIS5WuyOuApnQYYXp46maj1v9Br8FeL8tPmOAsGSG0nBE5TickXaZ+i1FyDy/JlIw/es4FAzrNGBQtaHUIIXI8x5DqKUIfHfPkZ+oYZ40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727098154; c=relaxed/simple;
	bh=fA1caZBG5nKM86v8pgROglEl/a7P1ZoaIM8TTpkv+20=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YrwSEKgH1yHKyR7Gmer66SGn8F/21fta3lnzA6unGrQYvvwfRHcscaBgr4E86oDH8BJnU2TZ92p3sch/32O6LhCQLcBq8voa34zCxK8HrGwyl4UlSkske372Xk2uZu4fD+jFSp5wJP4oL5w339lOjJwTliBUTjahzQQLaDN7Lig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FlpHlZ4k; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FlpHlZ4k"
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-3e034fac53bso1886789b6e.3
        for <ocfs2-devel@lists.linux.dev>; Mon, 23 Sep 2024 06:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727098152; x=1727702952; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZXEl1hOP9YAeajQxkxfICFrSdnHviVjv168PjTg2DCA=;
        b=FlpHlZ4kvaHZVkxAe8e/JMCeMvRlJ4o+uFojoflzfzwc7op8/xO8M1ZwyFtNo6leVo
         A2fSgjlFGpA5CZ/9ZTF+u/IR4An2HbvgGdX+uwckOKEt2lo4uENmFfziDW1P+EfIEpri
         RD+piAh5IROnDyKqgBz+/zk8rSAeuKfvby6AghQAiG2oL2g1igVcGI1Y+urJbhNotJt8
         r+I37RpHmT9Wz6N1hSd/CeK2fdwvIxlhUKKdHe7B2KKwg+6wUe13JLqphdWMGuNl7lIr
         4USLWAAMRjZFjscQLmRAZ3ojPDpFsnf3wyOK31tSV/5iGvKM6M7HoOcDDTKgcu1V5G/5
         eIsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727098152; x=1727702952;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZXEl1hOP9YAeajQxkxfICFrSdnHviVjv168PjTg2DCA=;
        b=f/mgDZRPTdpFef6tXyaoKOpJ0GtyekEZUJIq1gv7S7mFGd6Dpxzd46x2Trjd4anBod
         A5PWNevhIOVFHj9gcAqPyumPiJ2Efy4onfJIJrIi1KUZtqFmrYHuO6b/VP/GVtNEVoiV
         oKBOgK2W2j9+5zYKRKIBYhYo0PyUqHxUnrvy8cCIYu8TWRbE7zbgp9p0YOiGsk1thPty
         exiEZcIxYTZ51ATl+ZA9OWPVMU4DI6t8Eu0kpo1N0NGRv+i/WB/0MjgpLQIH3wjlYY0k
         bJ6mdhz+Yn1l+Bu0XcjkFbvUe4ntXMic9R6AoRuEueFZ4d2ld3h2JADp4SCPWUmqRvR0
         yCdA==
X-Gm-Message-State: AOJu0YzEYdelY11KUftnZyvrmnEzOcQynafLVhbR21L233DocoVmqcEN
	auq27F9WcCjUs9GAoLCJBnNc6ZLNYc/RMz9y6tHxcFkJObEK1K/HQqEdEwG0
X-Google-Smtp-Source: AGHT+IEtMp1dtNK760vUQmqf5mZ8ZEYPjoY4hTHyW3phHAlm3RmlQ0e6Co508kW8A/IADca7dM7IvA==
X-Received: by 2002:a05:6808:3089:b0:3e0:515c:ff5e with SMTP id 5614622812f47-3e271b8af16mr7995854b6e.1.1727098151727;
        Mon, 23 Sep 2024 06:29:11 -0700 (PDT)
Received: from archlinux.. ([2405:201:e00c:517f:5e87:9cff:fe63:6000])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-7db498d9850sm15154604a12.10.2024.09.23.06.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Sep 2024 06:29:11 -0700 (PDT)
From: Mohammed Anees <pvmohammedanees2003@gmail.com>
To: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mohammed Anees <pvmohammedanees2003@gmail.com>,
	syzbot+e0055ea09f1f5e6fabdd@syzkaller.appspotmail.com
Subject: [PATCH v2] ocfs2: Fix deadlock in ocfs2_get_system_file_inode
Date: Mon, 23 Sep 2024 13:28:54 +0000
Message-ID: <20240923132854.13936-1-pvmohammedanees2003@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

syzbot has found a possible deadlock in ocfs2_get_system_file_inode [1].

The scenario is depicted here,

	CPU0					CPU1
lock(&ocfs2_file_ip_alloc_sem_key);
                               lock(&osb->system_file_mutex);
                               lock(&ocfs2_file_ip_alloc_sem_key);
lock(&osb->system_file_mutex);

The function calls which could lead to this are:

CPU0
ocfs2_mknod - lock(&ocfs2_file_ip_alloc_sem_key);
.
.
.
ocfs2_get_system_file_inode - lock(&osb->system_file_mutex);

CPU1 -
ocfs2_file_super - lock(&osb->system_file_mutex);
.
.
.
ocfs2_read_virt_blocks - lock(&ocfs2_file_ip_alloc_sem_key);

This issue can be resolved by making the down_read -> down_read_try
in the ocfs2_read_virt_blocks.

[1] https://syzkaller.appspot.com/bug?extid=e0055ea09f1f5e6fabdd

Reported-and-tested-by: syzbot+e0055ea09f1f5e6fabdd@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e0055ea09f1f5e6fabdd
Signed-off-by: Mohammed Anees <pvmohammedanees2003@gmail.com>
---
v2:
- Remove retries when doing down_read_trylock() and fail directly
---
 fs/ocfs2/extent_map.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index 70a768b62..48919464a 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -973,7 +973,12 @@ int ocfs2_read_virt_blocks(struct inode *inode, u64 v_block, int nr,
 	}
 
 	while (done < nr) {
-		down_read(&OCFS2_I(inode)->ip_alloc_sem);
+		if (!down_read_trylock(&OCFS2_I(inode)->ip_alloc_sem))
+			rc = -EAGAIN;
+		if (rc) {
+			mlog(ML_ERROR, "Resource is temporarily unavailable\n");
+			break;
+		}
 		rc = ocfs2_extent_map_get_blocks(inode, v_block + done,
 						 &p_block, &p_count, NULL);
 		up_read(&OCFS2_I(inode)->ip_alloc_sem);
-- 
2.46.0
