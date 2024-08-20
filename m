Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110D9190462
	for <ocfs2-devel@lists.linux.dev>; Tue, 20 Aug 2024 12:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.163.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724156268; cv=none; b=ccCkYRKKS56P0DyInoM/iU4uRxM7UvyNQsyxhwcjanpOXd6eeFQTygz6fm8ndylkWsbEr3gpF04rN36pIKtRpXzNhIu3fmW2fnIaaQLqTm38iNG5OBoFFaBA2BlhA0gas3BQNrh+VJk2kp6YxrLOAipd3p4thMlKz5lNY4Whr+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724156268; c=relaxed/simple;
	bh=S50PeNGLLYC54M5FyDXyqvjnu5GWYnNr3f0atY4Z+so=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=HQty8OZB5uZ9CYmLcK560JVRKdSfw5qx7EUYv9SPAFvyyYEUOT1Hsc/ap1774C5cKnbl/J3RiAFlg4AKt/z1VR60QlZRHXhn+hSKgyguU4Bd4Qn/XL0Z2FKrNU9Feh+rHzp9lw9fdB1AdRphtc+GAdmzuo98cgqAhvQXVW0uM9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=PDIbVg/2; arc=none smtp.client-ip=43.163.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="PDIbVg/2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1724156248; bh=46r17CzYPvxoYDwAKCyXtsfXX2O1n+ZtU/svMrYG7Wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PDIbVg/2aFno2IgVzMfVUlJhnCDLiYQoZyBa8dzUQKPE4iln1xfBCubWmj/oBz/b7
	 WNm/S91zkmD9JLkXJUzQkD8qTL85MDTVoW9aI01lGZo+zbXxHj2625OaMc4R5xespX
	 +f9Z7acRyDEjzhWBdEWER3UIm0By6PvPS8ywsQNY=
Received: from pek-lxu-l1.wrs.com ([111.198.225.4])
	by newxmesmtplogicsvrsza10-0.qq.com (NewEsmtp) with SMTP
	id 23A1CEDA; Tue, 20 Aug 2024 20:08:58 +0800
X-QQ-mid: xmsmtpt1724155738t6m2xanqe
Message-ID: <tencent_EC9ACDC0793A6F742D7D6FA094F0E96AEF0A@qq.com>
X-QQ-XMAILINFO: NfyThBV/OCX5milxwBW/FlfEKiZVbdflebNR9IzfdiZ2orYiq75o+/rYgaaAbK
	 9hL895WWGDoXGn+8G7uZFj0Fu/ph/Qg/Ee0yHtTZC6WqbmZBLMXvtw2eCoffPSGoVAk37hpC3it5
	 WJsFRmQaTDsi3uux89KvDqQuvXLOKYkfZbTRQ6pcCzB3X1F2mjIrEE0Yomm0Ox2Vg1kP5rALcJkO
	 U6lpkZW+DH8gnsX4qROlUGchmd/u4o6pjvRQ8dDXQKOts8Xb7svpD3uC202wXiuWI1878qljMPAB
	 wujU3MEL53bd4q7dy3my9E9VyZxcuZ5EYbEMeuLYnVCQQwUK0II+3OLgShgAedn6IyO/qx3mBYeV
	 6q8QY124re/q2b3jos118HViuG5psUCUMvDlAaJ4W7KEl9FzPEQpBucLODUCuy+xUHWq8bDmQSfz
	 l2kXpxVNmrCy3XIWABtX25Ooce1/2CNG5OGCsx0qYQKswjdby5Rb5QihPVJEJTYWR5ZTJ+4qTwme
	 y3pvL8ftb2zjIYZNmc8chLw1+BNn57ZE1Nr4I/AkJ74dkyKcUtI6GZ1pw7lUW1h/cFFRFxuCCxBK
	 vsx8TW+dAi1dpqXLdNy2Iu0mV5StXYWhxaLrckGS6OGpk51K0NoiXhC6v7T142Ie6GfcLIBzeDMA
	 ix0wkPT9DwNU6LoEFh7UbXBIzFosDzYxj5Rqb3vWahEKIptnsIuujXl6p2QPoKrc0W9rHFiLc6FY
	 6RnAsacCf9lLkHAFGZyiok/jCl0xESSNylJqS4YYSVK0YatL7uhcaJaqa3w/LS+pDVhm/fTj3S9I
	 vhE36AW6xuPbaz4fGqzS35E77ecEgMBkH1U8tcc7IYsW1v6sNIs7d0pNmmb+kAfDke4tFDutExaL
	 DUegdoPRshE53zp/YyeXudLCJsPI5i2pPhWyjqZXgwKzYAevjEwf+bm2OMnrApfZvaFCVHUYZm
X-QQ-XMRINFO: Mp0Kj//9VHAxr69bL5MkOOs=
From: Edward Adam Davis <eadavis@qq.com>
To: syzbot+5a64828fcc4c2ad9b04f@syzkaller.appspotmail.com
Cc: jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	linux-kernel@vger.kernel.org,
	mark@fasheh.com,
	ocfs2-devel@lists.linux.dev,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH] ocfs2: Add i_size check for dir
Date: Tue, 20 Aug 2024 20:08:38 +0800
X-OQ-MSGID: <20240820120837.3948179-2-eadavis@qq.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <0000000000005894f3062018caf1@google.com>
References: <0000000000005894f3062018caf1@google.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the i_size of dir is too large, it will cause limit to overflow and
be less than de_buf, ultimately resulting in last_de not being initialized
and causing uaf issue.

Reported-and-tested-by: syzbot+5a64828fcc4c2ad9b04f@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
 fs/ocfs2/dir.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index d620d4c53c6f..c308dba6d213 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -3343,6 +3343,8 @@ static int ocfs2_find_dir_space_id(struct inode *dir, struct buffer_head *di_bh,
 	unsigned long offset = 0;
 	unsigned int rec_len, new_rec_len, free_space;
 
+	if (i_size_read(dir) > OCFS2_MAX_BLOCKSIZE)
+		return -EINVAL;
 	/*
 	 * This calculates how many free bytes we'd have in block zero, should
 	 * this function force expansion to an extent tree.
-- 
2.43.0

