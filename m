Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8EE3264FD
	for <ocfs2-devel@lists.linux.dev>; Sun, 18 Oct 2026 11:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792323722; cv=none; b=UWd2ndYyRNlCKBNJ8n42jkNCf6dMCfKbaa9U4v3cBYM1wH62XiNUPtbPCWBxEg7WluI16stJygYFhmOYbi3NfiFy/14nfdzcceUoSivmEExZgZQhFEaGR6CgPNmzKH9nXKRkxaDmboo7Z49C1cKOYUYRhBeJX0naC6SwVj8jF0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792323722; c=relaxed/simple;
	bh=MKO8sUr3s2DYtswXsCRYLWd6shx1Mz7Sv3h+p/jZ2zQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Zju1Re5L9KoCHVX3ok604lrFIVaUHuCIkJaPr8anozoAK6J+a544wwZOt8mjkbcfSBxsGb41xNX97zyq40qj07uq2rizLUeP6AFA1VLOrliybwHGi6sTLA0wZAQtkRstQIiwRLIeAsASuVyV2rum5cqP7R21e6FWQeVNxkfvAic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=mAWAypNE; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="mAWAypNE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=pA
	JV6ndl+LoSI158hLZI0dGxxOXR9P4+L6TBh9+PTBI=; b=mAWAypNEcr9VoRyPk3
	IU0GfP0yHWLlNUmHVifY0FMA89YQ85sOkmGLHKwl/XZGw/8KoCK97tV2veSbRqXC
	2bbE5IBW8QuvXR5rIFuxwERCDGbiG6Z83XZfGVEZL84FFQc1dCTR8kmmmQN0WXDS
	t+TkFSihrLvo+t2JN0QlS6WkQ=
Received: from pc.localdomain (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgDHt3tgsNRqLpIMAg--.32387S2;
	Sun, 18 Oct 2026 19:41:21 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Tristan Ye <tristan.ye@oracle.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH] ocfs2: validate non-coherent freefrag bitmap inode
Date: Sun, 18 Oct 2026 19:41:18 +0800
Message-Id: <20261018114118.927071-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCgvCgDHt3tgsNRqLpIMAg--.32387S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZw4UtFykWr17Wr45CrW5Awb_yoWfuwcE9F
	Z7CrWq9w4UKF1fZ34qvrn5ZrZ5Kw4vg3WfWws7t34UCr9rX3WDArs2vF93AryUur1DAFs8
	JryfJryj9r45ZjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRCMKCtUUUUU==
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC7wEUTmrUsGGshQAA3y

The non-coherent freefrag ioctl path reads the global bitmap inode
directly and trusts its chain list. A malformed cl_next_free_rec value
can therefore index beyond cl_recs while scanning chains.

Validate the inode block before consuming its bitmap and chain metadata.

Fixes: d24a10b9f8ed ("Ocfs2: Add a new code 'OCFS2_INFO_FREEFRAG' for o2info ioctl.")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 fs/ocfs2/ioctl.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index cbe59d231666..8383f900c847 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -575,6 +575,12 @@ static int ocfs2_info_freefrag_scan_bitmap(struct ocfs2_super *osb,
 			mlog_errno(status);
 			goto bail;
 		}
+
+		status = ocfs2_validate_inode_block(osb->sb, bh);
+		if (status < 0) {
+			mlog_errno(status);
+			goto bail;
+		}
 	}
 
 	gb_dinode = (struct ocfs2_dinode *)bh->b_data;
-- 
2.34.1

