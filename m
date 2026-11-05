Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793872191;
	b=5GWpguoVwLnxpRuFqhMw/DrDcWBftln+IJKgtDsfqUKNGzZ8xGtl0kmXaHU9L4PRgokd
	 cYoXBwCyFrVPH+IuotvRY599ETijOXZETRmBIJc67FRW2s3QfcdqKnLa3uDXjPpXAIQvX
	 bWlpkM+dHpitYG/LYfnWUu7K6x/W8+7AviPGr6FD7/s0ZQizBK9x72me9w+pr/TW2FhxC
	 9tKGI7KfDscZRtCmo8tgB/Op9kAqMm3i88ood5AAkb0PgIe+e6OiL9WiPnUA2jkDleWNV
	 /AzaopMVvXr6DqWZ+OYDYgjtD6uUoAUMb/kSAWTRt7bbdZMoc7yaHOyHiDPCXZalU5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793872191;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=7QGekZKeU5NIbSkQMt4Oy3eQXlB5HoLpBgq2tkOxVKU=;
	b=4R4+A/KYlQ6uRsDWbmlmmzeC+OswIXjcvkci2QNduQwjVV1yZQ1n5Q5/FXQJpFSaymsc
	 lxXp8kA65XCkrriHGq2jWGhCJhDY2SRi1Ej1lkJMg6utuk3yOM8wXp/4XZKqubEx0DhoT
	 oJ7S5mhsR68Ma5mrMnXcbiuYHj2PETy5vjAM+AxMjT0oRHO731y0YcvXvjuBfm/KG/7xz
	 OiS43GTNxMcuxOFKt2hF3OZlbqB44fhKyUQESzRgBCkYKRl02VI9IY+Lxat3tByab5JlO
	 vlCDU7GcIa49Jiwh0W1LNkcyc263fDFCAKWhuBSzMv0N9Ktvv9ShC+swPSGdB0iSzww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=JaxB5vlp;
	arc=none smtp.remote-ip=115.124.30.99
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A90606D836
	for <ocfs2-devel@lists.linux.dev>; Thu,  5 Nov 2026 09:49:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A7A90606D836
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=JaxB5vlp
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793872188; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=7QGekZKeU5NIbSkQMt4Oy3eQXlB5HoLpBgq2tkOxVKU=;
	b=JaxB5vlpu1CXGKVhDllEiZsse/p59I2EDNcjT08WqlQPWUBTtnfPOwGx5IeR2jAgBrcMUlbTz4jW2AQbp1F1o6ZgDpddrCmY+VAQgOV1fIxRmQccqpgvKiKD6TA4toaHNYCWiFEiV0Sn+7h3GsCiqODAFYayoWf6ykaoRkfw50k=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XE8RZeX_1793872186;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XE8RZeX_1793872186 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Nov 2026 17:49:47 +0800
From: Joseph Qi <joseph.qi@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 21/30] ocfs2: report unrepairable corruption from online filecheck fix
Date: Thu,  5 Nov 2026 17:49:17 +0800
Message-Id: <20261105094926.3203416-22-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20261105094926.3203416-1-joseph.qi@linux.alibaba.com>
References: <20261105094926.3203416-1-joseph.qi@linux.alibaba.com>
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

ocfs2_filecheck_repair_inode_block() starts with

	if (!ocfs2_filecheck_validate_inode_block(sb, bh))
		return 0;

so it proceeds when validation fails, but then returns 0 unconditionally
after repairing only i_blkno, fs_generation and l_next_free_rec.  An
inode that fails any other check passes the signature and OCFS2_VALID_FL
gates, leaves changed at 0, and since its ecc was valid the final
recompute is skipped too.  Nothing is written and userspace is told
SUCCESS for an inode that is still corrupt.

This already happens for the mode, i_rdev and size-without-clusters
checks.  Re-validate after the repairs and return the residual code, so
the fix interface reports what it could not fix.
Documentation/filesystems/ocfs2-online-filecheck.rst already describes
this: "the inode must first be checked for errors before performing a
final fix".

Three consequences worth noting:

 - Inodes failing those three existing checks now report INVALIDINO
   instead of SUCCESS.  No new error code is introduced, so the
   ocfs2_filecheck_errs[] table and its userspace-visible names are
   unchanged.

 - A partial repair still marks the buffer dirty and is written back even
   when an error is returned.  The fields that were fixed are real
   improvements and are not rolled back.

 - The revalidation runs ocfs2_validate_meta_ecc() a second time, which
   increments osb_ecc_stats again and emits a second
   ocfs2_filecheck_validate_inode_block trace event per fix request.

Fixes: d56a8f32e4c6 ("ocfs2: check/fix inode block for online file check")
Cc: <stable@vger.kernel.org>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/ocfs2/inode.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 115aad1b8926..cfa545981310 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -2122,7 +2122,11 @@ static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
 		     (unsigned long long)bh->b_blocknr);
 	}
 
-	return 0;
+	/*
+	 * Only i_blkno, fs_generation and l_next_free_rec are repairable here,
+	 * so report whatever is still wrong instead of claiming success.
+	 */
+	return ocfs2_filecheck_validate_inode_block(sb, bh);
 }
 
 static int
-- 
2.39.3

