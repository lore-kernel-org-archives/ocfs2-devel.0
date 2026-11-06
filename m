Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.113
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793963729;
	b=sW4IGXa5MSWdeSwAmj7K3naoVdIMdDxO1RckQ/KB/B7XIk2cpkiEPzgRDrP40wWXie3+
	 7dBW21uUw8BhQU/SvJQzfxhS0pIAT1m/aOPiHFHgh4rhm9kgloVkLF8Jf3BqFcSyoT5n5
	 zs8jI/ow9VnOwk7C5faZ8MnXgsn+VUn5HhFE9l9LkKAwK9BiTWLCvQdy4l9/CNOrgvzGP
	 7HkXoYoEtcEz8JPbidRf3LLB9ODnNIyTsZQHWSaoVvDsnsQD6ggt0BklTQKZnGk7GcNNV
	 4tCWmO8WzaFqAlkdQ9VMuD2tjJutmOVrYk+lKo9RlRr1LbqsLfl2ltmdI9v/KLJTmWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793963729;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=X8/tG7p3Z/1CMBGJfdq7rhmdOPizUsyvuQ5IiSE2iUQ=;
	b=Fi6V9MBw7qtVZKveCvEPS+T6VB3G5YSbI0/8xW96xWoeUhpn0vm/RvGnF4Kjzngut1Un
	 d1DQDWx0EbwnKmYPlZKI0ZuAiG9s3giLpPNajKdv3KTqdODI+SGJu671wnn+FXqhe+/Kz
	 h08inW5L7X17yZl4Y7ZdR4O7RQNUTsW3FFqUwXm2lekFWJsJOzy+oBxFNDg/8p0j/CVq5
	 4d/Ut1i/iLZNeitxS8umI3aeF3dZoOS6MChTQGGDH6bPLALuUGSR0BK4ml5nJ9I+5DvFh
	 yT+Jc2zUbuugdf9x1TVUJNRSblHtN3fCP3ZxoP1V4nIPsZO0ip6f9rKHPn4PR0Dj9CQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b="k85i/bx9";
	arc=none smtp.remote-ip=115.124.30.113
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D979560A6F65
	for <ocfs2-devel@lists.linux.dev>; Fri,  6 Nov 2026 11:15:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D979560A6F65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=k85i/bx9
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793963725; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=X8/tG7p3Z/1CMBGJfdq7rhmdOPizUsyvuQ5IiSE2iUQ=;
	b=k85i/bx9Nvh1K6a2exQTqLqnN/Cl1c3bree+eYm/9uAFmSp7l5yhcY43m4Cm2su7cFbr+HLKhb/2jap9jeeusTT3OH1MA8Iz2oaUBsvuKwrudLkqXhmGUvnqmSVbCKd00mgpGe0pKzUOlctleoOOsJFyGIQmffwqENTw/amySXg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XEBa-93_1793963724;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEBa-93_1793963724 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Nov 2026 19:15:25 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v2 28/31] ocfs2: check fast symlink dinodes in online filecheck
Date: Fri,  6 Nov 2026 19:14:55 +0800
Message-Id: <20261106111458.1467464-29-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20261106111458.1467464-1-joseph.qi@linux.alibaba.com>
References: <20261106111458.1467464-1-joseph.qi@linux.alibaba.com>
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

Wire the fast symlink guard and its two sub-checks into the filecheck
validator: an i_size beyond the space available for id2.i_symlink, and a
target that is not NUL-terminated at i_size.

ocfs2_dinode_has_unterminated_fast_symlink() bounds its own strnlen()
against ocfs2_fast_symlink_chars(), so this caller does not have to rely
on the size check having run first to stay inside the inode block.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 2ded2ee9d32c..1679ed7d09db 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -2141,6 +2141,30 @@ static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
 		}
 	}
 
+	if (ocfs2_dinode_is_fast_symlink(di)) {
+		int max_inline = ocfs2_fast_symlink_chars(sb);
+		u64 i_size = le64_to_cpu(di->i_size);
+
+		if (ocfs2_dinode_has_oversized_fast_symlink(sb, di)) {
+			mlog(ML_ERROR,
+			     "Filecheck: invalid dinode #%llu: fast symlink i_size %llu exceeds max %d\n",
+			     (unsigned long long)bh->b_blocknr,
+			     (unsigned long long)i_size,
+			     max_inline - 1);
+			rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+			goto bail;
+		}
+
+		if (ocfs2_dinode_has_unterminated_fast_symlink(sb, di)) {
+			mlog(ML_ERROR,
+			     "Filecheck: invalid dinode #%llu: fast symlink is not NUL-terminated at i_size %llu\n",
+			     (unsigned long long)bh->b_blocknr,
+			     (unsigned long long)i_size);
+			rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
+			goto bail;
+		}
+	}
+
 bail:
 	return rc;
 }
-- 
2.39.3

