Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C08A292B20
	for <ocfs2-devel@lists.linux.dev>; Mon, 14 Jul 2025 22:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752531366; cv=none; b=dTqhxEDdBibi7j6qSo3rO8/A9QMWbblik3F7ow8KZSUAeCLlGAPjSl6TPk8v5HUgh/qj34q7wrKugjXLybCoZ7GWnL0z+6HdaOx1GeVRTNj79kWWiInZX3/GUKybnH4oa7UVwA0/JMEDUomHarIlTQdVy1WlevaT+6scExFxFjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752531366; c=relaxed/simple;
	bh=x4i3F36zur0SCPEBSIihXNVHrrhQtaP9gSe3rusIcKA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mP5wEW4izuCD9Fr0dmL6LNOsi0dhXi4oRcpPNJM6H9roKDyJXCCU5f6ly2PEw56N7sFUgC5uBrtgy/4A9n0H3NonN1xReYXGjdEYrfle6WwyKpHpXxSxI71RmP93s+4jeeah/1LJvaAlLMW+9kYQpjyhp7Gj+PWtJCEiVzvsofw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aM5Ds1Gm; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aM5Ds1Gm"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-31393526d0dso3468283a91.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 14 Jul 2025 15:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752531365; x=1753136165; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nOrDcippQTVHdM8Im6lXJg7pxH380YZvu5sA6YJz/hM=;
        b=aM5Ds1Gm/Ru06Ma9xW6/UY9WrIBK07QvlsPv1PJ0HHlQqEjAZdbdiXd2TdqkcCBjT5
         gaLDGSq9kb/3e043DkBjBfI0v6ixPvCnZKpmGLHSWu13gvblADcNLgRUw4p8n94qm6A7
         hRrDEa0XcS92Lkq1BEtEZ9zp8uUE+jqYJcRvvrDL1CKrZzQuAZDMiRCRKdV2p0Pj9UVQ
         KPDR1oLNNQ34rU/TOE3OEMsALX836wy94rad9QlfdVjx7ZFqkJPiS7H8GM9mrJbG7Dk8
         GUyoaeACO4BUEGzCERDDnG1a6sryCAZUXsNcCyu4lKq95P6rva8D5AjOjl1OucD6R+4B
         vBAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752531365; x=1753136165;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nOrDcippQTVHdM8Im6lXJg7pxH380YZvu5sA6YJz/hM=;
        b=VskeUSkT1t6eEDC4dvPggUSiWvD4NgSZABsN+eoAGRwPWYBRh2vPCUFZDTRDkHZyjL
         z1ZzskL8l114IKEGaRUr5o/EpDEt9NDphxoUNbIUagnmjb29al6aLdQRUIvxJeJm8yAQ
         cUjNGx7oEAilD/uI5dbch48YLNVkEd9TfOXVHtDsbRjVvqL3HuKyZD+EBMJRb3YpkzmK
         wSZXYPq8wOCF4il0jTSrNkupR7lleJeYUePSEteKQZzct5yb+wQ8DmqVgI31yPw9aLCz
         Y6GoMNPwMMmTXwTfzv3m72zEkr0831qx/UL3KTTtg4FIlIcnFCNCudsY39IjHGkd2xEw
         PQjw==
X-Forwarded-Encrypted: i=1; AJvYcCVyOh8XxnUue9kYJskVb/LCRv6zQ6HoF23UZy2K1c3e0sFutMtv4oJyFRmq8CvYcTmY1lZSqo/2zqnaUg==@lists.linux.dev
X-Gm-Message-State: AOJu0YzVytETJBWmqNMkRH5CPt/wu4WIdcsGIhQCN90hMB/m5s60ickS
	pnOqMYKFP+R7QY9l3vzEqMg+YnSijZfEGWGGAY2VeZlsVfdpWsTAKzONRBpKMw==
X-Gm-Gg: ASbGncvEzozEcsdf3KTGXvbNxUhjS25G9F7JEH54dISHWmzdN6OVe6CjqEjXJu70dS8
	AiKvw86jSIul20qSkSghFz4YCmJeV3Tf3yzwGcpyd9uxWBn5o7DgCN1QSjhNoPNR+7Ap/Jm/Iku
	Ij1jyW6hhdYL5Pky3MiY3O6kS/NVFDtIrj1wSsaI/KXDeeF+pWoKcKPSgHqkxloiZb5IklhY8qm
	Imhj6yzuuFIKjXevgeY8Gt/fEbYy6wA8QJjUdxSK5GmZ8Sq40DYausl3cCxMDs9gFTndnLVcRyo
	jsiNXJnDmeHGMc5h8nYGpXumtYr78tAO9cEQwQMfHr+C9gPHxSED5iL4Cq5fKqJNs+G+DOTojTH
	BCgcga2WNaNnRHYDwPoFcK85eOz+EGgH6c31M6vlJ
X-Google-Smtp-Source: AGHT+IGEDtw8J5mq4n3QR7e0NMdWhjFjPhLHYhyib35yYfZ/xubqWOItnQ0j+sZBQfSH0+Dy1wDpHQ==
X-Received: by 2002:a17:90b:268b:b0:312:25dd:1c86 with SMTP id 98e67ed59e1d1-31c4cd65841mr26348729a91.18.1752531364522;
        Mon, 14 Jul 2025 15:16:04 -0700 (PDT)
Received: from localhost.localdomain ([2804:14c:96:9a2a:564d:ba07:e7f5:17b2])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31c3003f96dsm13821273a91.2.2025.07.14.15.16.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jul 2025 15:16:04 -0700 (PDT)
From: Diogo Jahchan Koike <djahchankoike@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Diogo Jahchan Koike <djahchankoike@gmail.com>,
	syzbot+1fed2de07d8e11a3ec1b@syzkaller.appspotmail.com,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ocfs2: fix lock acquisition order in refcounttree
Date: Mon, 14 Jul 2025 19:15:32 -0300
Message-ID: <20250714221552.4853-1-djahchankoike@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Acquiring the locks in refcounttree should follow
the ip_alloc --> ip_xattr ordering, as done by multiple
code paths in ocfs2; otherwise, we risk an ABBA deadlock
(i.e in the start transaction path).

Reported-by: syzbot+1fed2de07d8e11a3ec1b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1fed2de07d8e11a3ec1b
Tested-by: syzbot+1fed2de07d8e11a3ec1b@syzkaller.appspotmail.com
Reviewed-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Diogo Jahchan Koike <djahchankoike@gmail.com>
---
 fs/ocfs2/refcounttree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 8f732742b26e..c8467b92b64e 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -928,8 +928,8 @@ int ocfs2_try_remove_refcount_tree(struct inode *inode,
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 
-	down_write(&oi->ip_xattr_sem);
 	down_write(&oi->ip_alloc_sem);
+	down_write(&oi->ip_xattr_sem);
 
 	if (oi->ip_clusters)
 		goto out;
@@ -945,8 +945,8 @@ int ocfs2_try_remove_refcount_tree(struct inode *inode,
 	if (ret)
 		mlog_errno(ret);
 out:
-	up_write(&oi->ip_alloc_sem);
 	up_write(&oi->ip_xattr_sem);
+	up_write(&oi->ip_alloc_sem);
 	return 0;
 }
 
-- 
2.43.0

