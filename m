Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB16A27A44B;
	Tue, 29 Apr 2025 23:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745970662; cv=none; b=J12WM0E0xMoXzBztAbZGokhQOVdoNqbBUIqV5+Ni0IuSKPDwOz2XRU+vyHuhzy5+axNrPiO53nXM3UunPY4VYz5fWHESKjhI191OSGQGZpuJJOoeKAS+hq6MlLcZKxtn3WRwMSWFWynBYcpfZ5GL9wW1juwwzgvZPraWxfXHW+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745970662; c=relaxed/simple;
	bh=1J2hzhC3kpU4hDEKzEGSiPRt6TotDvIR4PwTVCRpnK4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ivYIRGlsB8TiMd2pIXwA50p4l4BrYnw5PX9Tgy/uIgYI+wX5/VWGWPGe+RXWGVBXFvB8VxuOPVAtTxgg+kyAp+rxspoNeB4Upo7S+fZhXCXu33h1urjMQvfB9ILfm5B735ColSpqeXLvzuBTOnFNPLm6xarfJ80djhpJt33+BQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DveS6gNw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DveS6gNw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC945C4CEE3;
	Tue, 29 Apr 2025 23:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745970662;
	bh=1J2hzhC3kpU4hDEKzEGSiPRt6TotDvIR4PwTVCRpnK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DveS6gNwkDnwxd1wrJ+xtp5Z19VM96M1uGOcZ29LTeK9N0gNe5yybq50nPI+uik5+
	 0VZX4bjbZO0JCMjGWYWt91rkihF2IA+Hi/kqmcmTxCfTfWj7hWb/DMZ/Zna9IeN8Nd
	 muxA+QxlXH2Wc/7YVd3F5kl4GSRa7ZZnu7ZgG9YdxPIBPnpkkfEH9p+RTj68zYyLIk
	 qaAoOowhDsr0uN36crcpe0fx3nWnDChaDJ/5bvM9d+AY0sDXT77bgMAZ5v7U9E6iWu
	 YO/HymHC+1guRjLLOj8UsP6t3c6X4D9Ld6fsAVG5OdfxXVZpZq5yw9slbunoJK/jQv
	 LUH8nQB8wf5vA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Davidlohr Bueso <dave@stgolabs.net>,
	Jan Kara <jack@suse.cz>,
	kdevops@lists.linux.dev,
	Luis Chamberlain <mcgrof@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	ocfs2-devel@lists.linux.dev
Subject: [PATCH AUTOSEL 6.14 29/39] fs/ocfs2: use sleeping version of __find_get_block()
Date: Tue, 29 Apr 2025 19:49:56 -0400
Message-Id: <20250429235006.536648-29-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250429235006.536648-1-sashal@kernel.org>
References: <20250429235006.536648-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.4
Content-Transfer-Encoding: 8bit

From: Davidlohr Bueso <dave@stgolabs.net>

[ Upstream commit a0b5ff07491010789fcb012bc8f9dad9d26f9a8b ]

This is a path that allows for blocking as it does IO. Convert
to the new nonatomic flavor to benefit from potential performance
benefits and adapt in the future vs migration such that semantics
are kept.

Suggested-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Link: https://kdevops.org/ext4/v6.15-rc2.html # [0]
Link: https://lore.kernel.org/all/aAAEvcrmREWa1SKF@bombadil.infradead.org/ # [1]
Link: https://lore.kernel.org/20250418015921.132400-5-dave@stgolabs.net
Tested-by: kdevops@lists.linux.dev
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/journal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index f1b4b3e611cb9..c7a9729dc9d08 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1249,7 +1249,7 @@ static int ocfs2_force_read_journal(struct inode *inode)
 		}
 
 		for (i = 0; i < p_blocks; i++, p_blkno++) {
-			bh = __find_get_block(osb->sb->s_bdev, p_blkno,
+			bh = __find_get_block_nonatomic(osb->sb->s_bdev, p_blkno,
 					osb->sb->s_blocksize);
 			/* block not cached. */
 			if (!bh)
-- 
2.39.5

