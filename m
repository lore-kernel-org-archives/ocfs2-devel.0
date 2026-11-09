Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794226937;
	b=Sl8VH6+F6UuyJYEE5fLzBIaF+bWbNV+bOPHo1Tw/qzo8mvmcQK3FN7bqUe/CKo2g0qCz
	 +ZezZw84hEE2JYpaH7x3Jvt00vhUwBojBJmlQBLaoaP5QXi/onBrFaWqjAiVwFRbKe234
	 SChOsW4+GukmwRMx1DFBPfnsvAnSLyYVQJ1adB4eb758+iS5EewGKz56Jcv9ghDdodgVP
	 67Kp1YVeICv8eSfkcz5a7rSZC+JTOVg7j0UPQU3v/CERkhWJTCTQX8hnaD2oRKkzOcBlj
	 Y9L3Exr0bc46iHHzK/PweuN5WvLg4bsGcq6r7Z8yFuA8KSdvgpAGoYhHAgH3t8Cni0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794226937;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=n715x5jw976AkEUskxbeSGq1K7tROSl4ShNhGUvqQok=;
	b=vT0DLWIedw07ecsoyr3Fk+Ayv4XoyNeuIziJjIIks/YnKK1ezBAnHC/7IHzwu+o21dvw
	 11DOpH/LAehZn1K60qy+BQawvWJs/Wm2z9eUYEQPQfGYH8onE35R5rIBd3iEob9Pikdg8
	 VU4vEMQKYN98tVwmfLK/qjo2WuxPVKnXMXRcUC9lAtlTZvkyiCZXvDJTiDN8EWl+sdVEm
	 4A718TQeJLDAx9hPHkh/nhNQvp5hNC47uoYQfSv/w4ehueqBUm7X5JnMX8qE2j9USqN4J
	 d/IRoPRGmbmlsQ/CPHdy3Z0AzZDbhLdB+vx5gzlVsfZcaL3bQu7FnyQzKxiqRlr+UbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=iSD+M1FI;
	arc=none smtp.remote-ip=115.124.30.133
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546B46082BFC
	for <ocfs2-devel@lists.linux.dev>; Mon,  9 Nov 2026 12:22:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 546B46082BFC
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=iSD+M1FI
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794226934; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=n715x5jw976AkEUskxbeSGq1K7tROSl4ShNhGUvqQok=;
	b=iSD+M1FIpZUn5/PFmR4tl5rVgyIBvykgilNnUzKpjPsoxG4+p3AHCeYJ5HxQX46BTeHAo0Ab4CRezkYAB3hfMB91d6OKMa2ZDJAD6f4MQUiRldfLqReXzd3AExcq8a1RYv4FurKzaC5L2BeOwf69vZU5mT8zXC6eFt2ut40UYts=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XEP8awv_1794226933;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XEP8awv_1794226933 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 09 Nov 2026 20:22:13 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v3 28/31] ocfs2: check fast symlink dinodes in online filecheck
Date: Mon,  9 Nov 2026 20:21:18 +0800
Message-Id: <20261109122121.21473-29-joseph.qi@linux.alibaba.com>
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
index e01c3078d974..132864f860fa 100644
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

