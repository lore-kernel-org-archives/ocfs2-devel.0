Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D30125DB
	for <ocfs2-devel@lists.linux.dev>; Mon,  2 Sep 2024 02:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725244919; cv=none; b=g1q8bhPI23/JSe1+hrB4m0HZqXOMeGEANy5lrNw4wSjFf9kBaBT5OS2EqbE+yEdMv8E3T+36GcaQ2vSOchv8DcB0TFSwhLDzP+gpdUTptQi69N8Zq6efyQMyJ7qV6GM/RXdQCBQdLKrW7HzbR9WS0X9hDPc3sfjxeH+nDgaAq88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725244919; c=relaxed/simple;
	bh=/v5+Nj5heAtqiXqJxuumZ0IQx01iQfXW6VTPVS7QrSY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bDNA0wuUkpmpORVPc6tX4vmJrKWcxQ4VQ9uJY0UPSVjLVSdHMgF1C4Oc3nMj4q/lCVp/N9KM0OCKJhF2cSOQa9DRUT/jmLQxW6OV6BkL07Zx1AKbd82Ssft9J2OmZiRjhTrf9Ut6Td6CcBomBSuLkuNTx2Q4qtG2CZDIlIf2+S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=J+B2ZCzD; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="J+B2ZCzD"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1725244914; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=ChehcMT61sXTyQ7rRVqr54vujGM9pbYTlJ0+I2dxfp8=;
	b=J+B2ZCzD5g01FSRXdVwu0krOXtWYTkA5nv6dvq/DHfZjYaloLpsTZTZRAy/cwCWtbjiGTbpg6Dpbuh0Y20vwCo+rDVjYyc9ks9AemghYS5ikkKb14g93KRtTNknIY5l3DC9aLm522nYIH57lj9ZFGRP5sV0rz9bETMPMQ6x/920=
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0WE1gx-G_1725244596)
          by smtp.aliyun-inc.com;
          Mon, 02 Sep 2024 10:36:37 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Heming Zhao <heming.zhao@suse.com>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	jlbec@evilplan.org,
	mark@fasheh.com,
	syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH v5 RESEND 0/2] Misc fixes for ocfs2_read_blocks
Date: Mon,  2 Sep 2024 10:36:34 +0800
Message-Id: <20240902023636.1843422-1-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series contains 2 fixes for ocfs2_read_blocks().
The first patch fix the issue reported by syzbot, which detects bad
unlock balance in ocfs2_read_blocks().
The second patch fix an issue reported by Heming Zhao when reviewing
above fix.

Lizhi Xu (2):
  ocfs2: remove unreasonable unlock in ocfs2_read_blocks
  ocfs2: Fix possible null-ptr-deref in ocfs2_set_buffer_uptodate

 fs/ocfs2/buffer_head_io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
2.39.3

