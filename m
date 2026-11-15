Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794739623;
	b=jHhBBDlbBjm6FTvO6zVxL6o6LqN8j6d4FjcDFG2XIEkz83L9mQKtzUSmp+Q/XAvDp/2J
	 CQa0nQZ3KYufWkaQ1w8bqU095f6WtfZ4AfwRCTprmMwAl3rDYGOSElUGcrLBWlfGr38GZ
	 boxh8hStYh+lrHgn3rwOnjZmnFvjGF6WEOfgVS+WjuUabITeUHLb9CMb3ScxrGjTKF/ss
	 cWlhgnxBPhvee7+TT9D7EJY7rA/yX1cESMWeMM+h1jST2ldnorZ0rJz8rE5kuDLtziT/X
	 DI7Z22S1zY4RICOQFURmWxXi3a7jE/qCATlAU2FU3ABIesSX9flTsV/Jy6pa8J7GCPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794739623;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=rZeatOF2xnBGrPevhx5lyGz8NiH/abT6xKA3mZc4/us=;
	b=RHdgQl7nbC3A52UGhF1WnVY3wLPVzSdm+M6spoWJYhrhnbbRhFQmESw9quApyPR/kpfW
	 kMhcmFCSIY7uVnGxJ3+JUX28blvoy+4/OlWOn/FY6/MkXCl80mj9e8g8Wfs3uGuIeG+C6
	 svlL/kYYEmi8E4OM1QcB9Zrub9jzK3rSKs+3YTczQMOEDO2r8bB/Gpg+9zJex17xp4h9y
	 JkFnWCaG1JXhSm76+YqQ06CO7SA2Ei5LFgt/mAfbQA6+9JJ9sGaj017YjkcJelzfwWihR
	 0KRH7tq7y31RzDtJgN9vcsPFfah1D1Jy9XV/C7f+dnrTHvpwFgTQeTFBX3ysNLzmtNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xmOnuSaH;
	arc=none smtp.remote-ip=74.125.82.171
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95168606A31E
	for <ocfs2-devel@lists.linux.dev>; Sun, 15 Nov 2026 10:47:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 95168606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xmOnuSaH
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-36a315ed211so2419696eec.0
        for <ocfs2-devel@lists.linux.dev>; Sun, 15 Nov 2026 02:47:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794739622; x=1795344422; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rZeatOF2xnBGrPevhx5lyGz8NiH/abT6xKA3mZc4/us=;
        b=xmOnuSaHUFpYIk8QzJqVbscAqSIBM4KucaV8YDfYLqqI6/wEBa6K7r81k5fRoRMYCK
         HVOgkFHlfqen8aKnxKyMFi3nK1GWf1evyXNuTFUN7jxzGoeTGZgbCLABQmnMHWGQcnYE
         kiijEAGk9/tSG0g9wOcxxcR0O0xzxg/lsjrXQ1YPz/OxJ+MW3QNwAjUh9XaTjFCt24ru
         WVLT3NuXQ1Z0OiKSyQpqjCDSbHdE78p/xNrw85DD0UttDWz+sEpSjPkrEjZ6+KrQsI7g
         +DWPvrr03FZVmz9DWvuYBYmId30YkrpirlZYZMILLQWmrZKn498mEWqYaEa5W7uHC48z
         yRaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794739622; x=1795344422;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rZeatOF2xnBGrPevhx5lyGz8NiH/abT6xKA3mZc4/us=;
        b=LksLcKDdZMtYYmuJH9TZr8bsi0h48bG0hHfprIPOUwJDbswUfnuVcmDKCRrX6IwEDE
         JtPing7uj62xzEJRnKaPZp+CvqIRSsI7hBLGq9nWGfsSntc/D7+LTj95UoyUSmS70ELA
         eBJyvti6E3vMPHGy5dMY6ovjcZFdU3i4QSTwCmytkZuO+3gUt0crQhQ9fOVDvGXguRFs
         9zo9+x57qY1qfrd0f4dbla7jYoCnLJVJv+JFaCmtJzGvtSzYQ1+dedA9Tn5J9crfjylf
         k2YXDmYq/LgY99RJobqTRKzvCBV62Y1etmbko50yym9rC4FHW6SykSQ29+HUB+G8D92f
         IL9w==
X-Forwarded-Encrypted: i=1; AL+hErHizzSMBQERHBQRYGySVxm3C213SqTo7LMeRr0Uvuf1pYWGu57OntazTfDLG8bhA/75uGgYn1krcAiPnA==@lists.linux.dev
X-Gm-Message-State: APuU4Z/YLd5OWBHhDz/M8JIPRfXYX8J8c8ekyaUh4N/7iuB5kgADbm84
	we0vZIiq8x2L9xkj+6aTIsfTFRacnvVxwouiyZAV+LOdV6Gz2XFKbfUS
X-Gm-Gg: AYBFou1fweWbyoOCk3XWdQ0wTYTto9qaycC84sHuBKW2Vt1gGHhAWBVdB1RgCLM3W2a
	56AWkDi06LCpH9wcVXUCPvSf6Gv720ItcbNRife7KEHnhyGCkNNc7NJZ7AHFAl20pi4yJVfewuF
	0GkMxsey47jVo7vInzY9fQd5LTD2QmQ21WIEwDPFd5JOpapB0MRftnB+yafSP1+aJ/cvn44hQOq
	woFVGHN/eflT0AQ4qDrt26YSAj5z17TIdfjgYS5g6lbI3oh2CjVPzxqL9VND2zXMFaaBTCqPluV
	0VoMfKdfkl9QyeXTt05Gd37+7qbCqh3mRGcPuQ3vFl73zUisaOp9J8QmqDDy7V+Z11ysWu/uB12
	HeKg4lq7O1R8JoL7u2eimX8Wk0eTmxRxW2c49VrAUluYYPD+bHgCFQCHKFkIEiWfyTx73N/KSTW
	+kvuActYQXPJ/xS8sOj8ZEsCg/OWshUk7P5oPvF9uR5L5ump96iu3BZfJb50QIbeynZCCu2uzAa
	rIOIyEcdSb7KHJzz1gy2E1Xea0k275x2wsiH4EOfyZE86a3Ucp9ZoO/U5G8B14JarD05wlXhkh8
	5+6s5XDDhXCLMxnDBG+5tdtHbpx7CBFq1y+c6RaWYuE51CQwiA==
X-Received: by 2002:a05:693c:87d4:10b0:371:197b:5ade with SMTP id 5a478bee46e88-377e1016802mr10069978eec.11.1794739621412;
        Sun, 15 Nov 2026 02:47:01 -0800 (PST)
Received: from thangnn-ASUS.. ([2a09:bac5:d45c:e6::17:34a])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-379559189e8sm24543858eec.11.2026.11.15.02.46.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 02:47:00 -0800 (PST)
From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Heming Zhao <heming.zhao@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	syzbot+3f66416993279938e957@syzkaller.appspotmail.com
Subject: [PATCH] ocfs2: don't reuse SINGLE_DEPTH_NESTING for unpublished inode ip_alloc_sem
Date: Sun, 15 Nov 2026 17:46:56 +0700
Message-ID: <20261115104656.210945-1-ngocthang2710.1999@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Post: <mailto:ocfs2-devel@lists.linux.dev>
List-Help: <mailto:ocfs2-devel+help@lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:ocfs2-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit c204bf5ac3ee ("ocfs2: fix deadlock in inline-data truncate
transactions") made ocfs2_xattr_set_handle() take ip_alloc_sem of a
not-yet-published inode inside the create transaction, under subclass
OCFS2_IP_ALLOC_SEM_UNPUBLISHED = 1, so lockdep records:

  sb_internal -> j_trans_barrier -> ip_alloc_sem/1

But subclass 1 is SINGLE_DEPTH_NESTING, which ocfs2_remap_file_range()
already uses for the destination inode, and the remap then starts a
transaction in ocfs2_duplicate_inline_data():

  ip_alloc_sem/1 -> sb_internal

Lockdep merges the two and reports a circular dependency.  It cannot
deadlock, since the unpublished inode is unreachable by anyone else,
but the warning hides real reports.

Give the unpublished subclass its own value past SINGLE_DEPTH_NESTING.

Fixes: c204bf5ac3ee ("ocfs2: fix deadlock in inline-data truncate transactions")
Reported-by: syzbot+3f66416993279938e957@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3f66416993279938e957
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
---
Tested in QEMU (x86_64, syzbot config with lockdep) using the syzbot C
reproducer on top of 23c62304dde2:
  - before: "possible circular locking dependency" after ~8s
  - after:  no lockdep report in 3 x 180s runs, debug_locks stays 1;
            /proc/lockdep shows both ip_alloc_sem/2 (create) and
            ip_alloc_sem/1 (remap) exercised.

 fs/ocfs2/xattr.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 71e5986bafaa..9f2d5797e4d6 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -3867,10 +3867,11 @@ static int __ocfs2_xattr_set_handle(struct inode *inode,
  * ip_alloc_sem there adds a transaction -> ip_alloc_sem order that would
  * form a lockdep cycle with the ip_alloc_sem -> transaction order used
  * elsewhere, if not for this separate subclass.  The inode is unpublished
- * so the acquisition can never contend.
+ * so the acquisition can never contend.  It must not collide with the
+ * SINGLE_DEPTH_NESTING subclass ocfs2_remap_file_range() uses.
  */
 enum {
-	OCFS2_IP_ALLOC_SEM_UNPUBLISHED = 1,
+	OCFS2_IP_ALLOC_SEM_UNPUBLISHED = SINGLE_DEPTH_NESTING + 1,
 };
 
 /*
-- 
2.43.0

