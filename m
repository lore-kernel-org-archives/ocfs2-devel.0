Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84480126C0B
	for <ocfs2-devel@lists.linux.dev>; Tue, 24 Sep 2024 09:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727170404; cv=none; b=i3Gwfi31M5n2iqILZrgCpkmgHpqkn4rV7m/mfaia02BfqwEJszLUYgx0+Yisgup+JJ6LMrgqioQvDLI8jzr5/JXnxrT1W8k/desFKhbPVEgMrV7CzoCc3noivo0cpsqvR082QuIPQTvUarJiEc8h0tMkI1C7CQGUGKuHczsIyNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727170404; c=relaxed/simple;
	bh=ybic+sCgpR/QC33pW8bXAKOWuMIhYF5HrHX0o9G9U2k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IIbd4K6nRTTCj2nA6LK8UWGC8n9EXtQ0bFT3GgCjjIr/MYlV5cvxckT6Afb91+oNnf6bUx0FOniCmI81NchtFIiFyCZGQAWaocqp9UDegseq0k7XRjSkp/wE0yJqJvP9RCxryzjWhKgdInxXIEf5XVGPT382hnwGGakpFiIkkbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lVEZHVhD; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lVEZHVhD"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2da4ea973bdso4160989a91.1
        for <ocfs2-devel@lists.linux.dev>; Tue, 24 Sep 2024 02:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727170402; x=1727775202; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=s9w2nHZP8l77rsPJ1L+c0ysp873CjxK+gREviiZn4r8=;
        b=lVEZHVhDEkD/wHUFKH+rUmRv9KJj1i1P9TcU/Nw/KcwsELrLjsDuM9LsIZFg4nJz/E
         CjpiWfujrBY5/YG4NCvETZBb+ZLghDCiaqmYY16A0b4WXEbAIBQJ8n4HxmS29nFiXnxL
         wSkttT/RJTDyhDM/mSGe5qP7Mwte0PcdEvJIwU245oXp+K4jN9QrkfZWOvbgy+5g76Hn
         ArM4tqZ3ApSJsmPHRC9b9Z9Ez/EuTOgQe4sMCxK5r0xSuugJ263QYu0xuWgjpK/+sn3I
         Xa1aBn1Hhv9ufKLcxh8WVp0OpkcI07Hkg9rElOIJJDSSOMwRtcNU+fVFTxihxv3GOIw+
         xSMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727170402; x=1727775202;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s9w2nHZP8l77rsPJ1L+c0ysp873CjxK+gREviiZn4r8=;
        b=mj0T2SCjVh63n3ADhaNGl0xNMmUvCFRjdWXyiZvy+gai4JQoh1SOe3PHkZWgjZqHRM
         xa7tIW3y4Kymxfhnb7NYwnd86LKE5iE1zH1HF+ziXHxITElVjOffeedoS1ZjXPa+RseI
         7noue8E8Ji5WkOr9BF5E26XwCboJXmc57+2HRU5WtE63XCFOdwFv9pTzPDmED9Uk4QIr
         fiPmNwJ8Uiw0/wL/W1gv/qJHIDyKPjYr+d8hBOtQDwYWeTsmTDWBBnhBT59B0NYpWgZb
         BSYbz0CwIGarr/GcwymzAZxWY6nhmLvMyKryoKW8MwLCqQTT1wjpN45Ie0nzvb3suHkn
         xIDw==
X-Gm-Message-State: AOJu0YwO8VcKCJmWzsFLgVu4NPShHXl2m3qYIIG36bObwZ0dPDn1osij
	Vhe1oQHJlX1Y0DFxVZdaQPciyPo/qrZfi+GJA/glKRWaFkPxtQg90NtLZ6Xi
X-Google-Smtp-Source: AGHT+IEUTmu8LdfTUocvphq1s92C+7rCJBcnIf+Z7si29T6cXZ28HH0iLRJbenbJAQ3LYa0z1dWdMw==
X-Received: by 2002:a17:90b:80c:b0:2d3:bc5e:8452 with SMTP id 98e67ed59e1d1-2dd7f71b8ebmr18331729a91.32.1727170402262;
        Tue, 24 Sep 2024 02:33:22 -0700 (PDT)
Received: from archlinux.. ([2405:201:e00c:517f:5e87:9cff:fe63:6000])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-2dd6ef95903sm10818845a91.53.2024.09.24.02.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 02:33:21 -0700 (PDT)
From: Mohammed Anees <pvmohammedanees2003@gmail.com>
To: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mohammed Anees <pvmohammedanees2003@gmail.com>,
	syzbot+e0055ea09f1f5e6fabdd@syzkaller.appspotmail.com
Subject: [PATCH v3] ocfs2: Fix deadlock in ocfs2_get_system_file_inode
Date: Tue, 24 Sep 2024 09:32:57 +0000
Message-ID: <20240924093257.7181-1-pvmohammedanees2003@gmail.com>
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
ocfs2_fill_super - lock(&osb->system_file_mutex);
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
v3:
- Removed multiple if conditions
---
 fs/ocfs2/extent_map.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index 70a768b62..f7672472f 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -973,7 +973,13 @@ int ocfs2_read_virt_blocks(struct inode *inode, u64 v_block, int nr,
 	}
 
 	while (done < nr) {
-		down_read(&OCFS2_I(inode)->ip_alloc_sem);
+		if (!down_read_trylock(&OCFS2_I(inode)->ip_alloc_sem)) {
+			rc = -EAGAIN;
+			mlog(ML_ERROR,
+				 "Inode #%llu ip_alloc_sem is temporarily unavailable\n",
+				 (unsigned long long)OCFS2_I(inode)->ip_blkno);
+			break;
+		}
 		rc = ocfs2_extent_map_get_blocks(inode, v_block + done,
 						 &p_block, &p_count, NULL);
 		up_read(&OCFS2_I(inode)->ip_alloc_sem);
-- 
2.46.0

