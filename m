Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.111
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794226933;
	b=kKUUWiBpbb1Rr+KhEiRLe5RgVsMhnR1hLO1nQ1Q9UeK9viAgZ2N3p1vA1AlwYRmV9yQp
	 Ha/8Y7sC43KSJzArR6wkGuVDOEQxyoyvjbrbhEJvi824yMhsqU6t2I3A/pTI7NGblNPBf
	 v4eb9QS7ocpM59o/D81uz/+k7WUF2dRR3elfZsuUwEFkciFYAFpVYQzIURGTCCRzHHQjd
	 4lnxjO36/Jrwmzjkj5DsVvfZFWYQkQX8JZNkCESx4xh8jmXEYxeuTG8xzrg++PFMO+mnH
	 T8+CMVb05XW+I0+O8MF6SixsO6ZgcNvWi53TNxkMZ4i4Wz1gYls4CwxKTie9P13+Crg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794226933;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=gCw0QLDVy6qOvZHnnCGs9bwGAYTtGDNXvuId7QF2hlM=;
	b=A04HbR2O3DdJfFz+SCTEhTbOcTVsLZXkWvcc53cNHenHkPNE7vfwcG/WI3MSRRvDkW0V
	 mFnKqyHS0H84vxnVzrZHTDqiJK5Q2p9JJa/y7DSrwZZN7iYxbzFtvO/SOKWY8pjnl9Yg5
	 3G7Fvr+XFPhxdWJ5MYS5Vw2eiurLMRDu9yT0zkGcvHKqo5jXZ98IjigsbLmy3gkdGeEIG
	 4RVdZRQcMzvG0qZyYQp/Z4zXQDSM6q1w24qBlP9SCZsN9HyvCefZCGAXhn7B6rAQF2v7b
	 FB5QMd6V1agcPCSGdzctOXdRO2YfN8CKVC34g5XyWGkYHTb30fj5UU0ozjIkA+kVeNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=j3ubuMp5;
	arc=none smtp.remote-ip=115.124.30.111
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE76606D814
	for <ocfs2-devel@lists.linux.dev>; Mon,  9 Nov 2026 12:22:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BDE76606D814
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=j3ubuMp5
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794226930; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=gCw0QLDVy6qOvZHnnCGs9bwGAYTtGDNXvuId7QF2hlM=;
	b=j3ubuMp5tm66lBQK8YdTAI7RWfXqKPJR/MM61PnQKLNi37YWVTf1BxKGiyAHKmkDsUyoLSjTJe+QV6JK46RBAu8wRMB6bvjIJA1JEKGrhHtV+sJJ0HunYqgChEXJBG3cvtJST8hVBx3XwVhm9j9FPQjoWrABI0GTmGyI3n1Y9gQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R971e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XEP8avB_1794226928;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEP8avB_1794226928 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 09 Nov 2026 20:22:09 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v3 23/31] ocfs2: check dinode nlink and mode in online filecheck
Date: Mon,  9 Nov 2026 20:21:13 +0800
Message-Id: <20261109122121.21473-24-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20261109122121.21473-1-joseph.qi@linux.alibaba.com>
References: <20261109122121.21473-1-joseph.qi@linux.alibaba.com>
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

The filecheck validator shares most of its conditions with
ocfs2_validate_inode_block(), but skips the zero nlink or mode check.
Wire it in using the predicate the two now share.

Filecheck reports OCFS2_FILECHECK_ERR_INVALIDINO and logs with the
Filecheck prefix rather than calling ocfs2_error(), which would escalate
to ocfs2_handle_error() and could force the filesystem read-only while
an administrator is only asking for a diagnosis.

The check is placed after the ecc and signature gate so that the
existing coupling is preserved: a bad signature still overrides a
checksum failure with INVALIDINO, and every later check still runs only
on an ecc-clean block.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index ad40cd6baaa0..6d2fb46e6c38 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -2020,6 +2020,15 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	if (ocfs2_dinode_has_zero_nlink_or_mode(di)) {
+		mlog(ML_ERROR,
+		     "Filecheck: invalid dinode #%llu: nlink = %u or mode = %u\n",
+		     (unsigned long long)bh->b_blocknr,
+		     ocfs2_read_links_count(di), le16_to_cpu(di->i_mode));
+		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+		goto bail;
+	}
+
 	if (!ocfs2_valid_inode_mode(le16_to_cpu(di->i_mode))) {
 		mlog(ML_ERROR,
 		     "Filecheck: invalid dinode #%llu: mode 0%o has unknown file type\n",
-- 
2.39.3

