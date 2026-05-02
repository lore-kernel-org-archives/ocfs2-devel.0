Received: from out162-62-57-49.mail.qq.com (out162-62-57-49.mail.qq.com [162.62.57.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C189381AEA
	for <ocfs2-devel@lists.linux.dev>; Sat,  2 May 2026 13:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777727517; cv=none; b=M6XcWb55My/tq6yEV6/xk+BlsmF0VXeNwv+XLBueThRdpKb01MvAdXK/kjGcxd3kXGUOzc0COC0UfsEEG/kz+e7xZu30Wm/47cXLNceVXYGVoj8K/Vr2RKMAzWykf4Om4xa9KPILOK0uceTM82zBs45JadWHo3vfoXsMyVEPVew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777727517; c=relaxed/simple;
	bh=oNSjQWHxRTq69WpRdhbiQ6d3uRt7E6zt8TDMptL2FGU=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=VnFvZP1lbhd0hV7jjYUfenXwDv4iESMLuEx1BwxK+fAnfa92QPkbHTnYGmywYgzj2CQ6UNnXWTf0IlHad0FpFWtWxzbYE5IWaIgabs1jqcyMl3aLAM+f2OirVVckgAzig4E9gue1t4m6Bzfyto63hwT9w2voy6ES8XsWnmJZLS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=B+G8Q++y; arc=none smtp.client-ip=162.62.57.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="B+G8Q++y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1777727505; bh=uldAaFaYBCJ0v58ed3zzzu+Cek0k4rB6RpuqJXzjVHg=;
	h=From:To:Cc:Subject:Date;
	b=B+G8Q++yoBAFdBELxaND7P+QOLlrjJU/JEUT73msu/SFkNym1cAj60uAlHLpxpJaY
	 JacJxPMlZfUjbyvpgJfjv9Cgv4QI1dYb3jZQUNeJLEf1oRrhSSuc9jBJwzmJR6GqeA
	 3svScscHXQvjCkDHBb1U2HxyD38b2UdztAy0VI3Q=
Received: from Lang.smartont.net ([2409:8a44:2312:14e1:56d8:1e1e:3f0b:d0f3])
	by newxmesmtplogicsvrszb51-1.qq.com (NewEsmtp) with SMTP
	id 2EA24AE4; Sat, 02 May 2026 21:11:42 +0800
X-QQ-mid: xmsmtpt1777727502t6dbgo2wj
Message-ID: <tencent_7DF4CD0946ED97EC2B19DC11A0975CB32408@qq.com>
X-QQ-XMAILINFO: M2dBUVw0X9hns92/FGQ0Qkh5CqZgPwv1+LpCDE9IYnKBjQuQWlxPCBEovbXQBP
	 T+mEEs3tLmm2v09BGuuhSnkMGtbBldrdam8rC4QMW99YE8aW5ltIMvGtXwiEHLanf4oB4TyrQw78
	 cphX+Y/iZwfVE3Qcdr+jkHGdCI4L7ba3KYYlka7nqjtUo2Q9aU15KDZrBvPYamLk/EYJ2wEQtfak
	 JMUAQncFbUk3eVXlDjDzaKNBCfG94dIhgGx6puxpxffR+GB5e4rapHIoSC3YPO/vLZN2nbpSIkO/
	 10j8PLbW15p5JOgf9tl1/ZSfvFtd1XUV0r2MoHI3uaKvApmFRViFMtebWdPcAMGLzjiAeOxn+8Wb
	 rW/3Y80f4UQFXrg8yIZjoxA7dFaOs+xMJPLGgfd7MGYFOUbRQYbu2Sk8PGtFKIPy3hTc9fsa957c
	 wk98R+fDvcjYy3eQHMqS67jz9uSf5dJKHF60QTGvJpuQTQuCS3SjVA+OKWsK6LIxO6BOXr4y7wzL
	 mrPLdT+QRWuSN7nv+XCDZBNDR0Dr5xevu3bbIaMqZ/G3gQCnjyAphYu+iNXRJYJnYDAXz9rd0/pG
	 iMD2YjDaTW5SO8cmRt8INVk5kgCRq64IJLfDyh6jL/Rh3JO29QyThakxnbRT1xCvVhxlrKbNjbYj
	 4zREyiok1+wkYAmoFTUub5DfWmkJ9rfWPHw6Q+1DQFUlhcCcJbHXMANywPOk3aax/xxB68d5NojW
	 1/CakPR26EuR/zVkRu/VIzHc/UiEK1oQ+69SDLSCWZGKOulbG70QumhFJmm9TPuxkVuvjNT2uT3R
	 X82Jpn0unl+dIZvegYQfvXWkoDD+vtyuyq2ATI6MfUwTAwtac2wd7rHSp3vtYdPKquee0WltaICI
	 YRMxpsvpK2FtJvRu0SR6SDhImxH3lJd9G8gEFl+3X8Lc6RkbcnV/C97jkRutXkXSBQN5UzhkEFWG
	 4OrojldvfcrqiCM01tZqQGBCpPyKnQP5yUIBBLcHeZgWqMG13C0JkXyvPEzO8MN4/kaAQCcs/mlu
	 6V4iuhFbPr+2ZsrFtUw6Kfng3aRtNG0xnHg1FIujwRIG8ciUzzVMMekIk5tWZpSA8oeQa7LC0CHO
	 PRrLJ+GrSqLV8pZ6RqYLoF0Ijg5WthBproJghp/nuwsewy4wI=
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
From: Wang Zihan <jiyu03@qq.com>
To: ocfs2-devel@lists.linux.dev
Cc: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	linux-kernel@vger.kernel.org,
	Wang Zihan <jiyu03@qq.com>
Subject: [PATCH] ocfs2: Fix typo in copyright notice
Date: Sat,  2 May 2026 21:11:42 +0800
X-OQ-MSGID: <20260502131142.671765-1-jiyu03@qq.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix "Linux Torvalds" -> "Linus Torvalds" in the copyright notice.

Found by Christian Marillat.

Signed-off-by: Wang Zihan <jiyu03@qq.com>
---
 fs/ocfs2/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 1277666c7..40db43868 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -17,7 +17,7 @@
  *
  *   linux/fs/minix/dir.c
  *
- *   Copyright (C) 1991, 1992 Linux Torvalds
+ *   Copyright (C) 1991, 1992 Linus Torvalds
  */
 
 #include <linux/fs.h>
-- 
2.54.0

