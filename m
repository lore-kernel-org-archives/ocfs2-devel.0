Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A440229BD66;
	Tue, 29 Apr 2025 23:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745970734; cv=none; b=YuIwcTQHiKWnbCM3ZP9PZlBBfOmzpxz8cUXnj0/u/TIpgXCwNhbJmIKiMvf0hrh1SqF/5Ei5v1w4aEv8SRf7a6gZmkY5PDGYHbyPKDgkuggzCyQqqFatJeWMpStmgHm3OQ569S/N+EtuSLoFcZz5tidatXtdEEMLlKqwiMRZvGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745970734; c=relaxed/simple;
	bh=jkTG/RVDQOw7PEikM62j/r5Iu3Ph4QkQB24TuvLKQPE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=o3LPpvyQvgfxd2vv7Lq7MjMD3M32nI2rftl6osu9ZfODUMiVXLYdf1ARnsSz7BdztsTtOhqOkWRggu/o/TsUhrxZFxvwEdzZVbIrVG7Rc/Rz4gulLSVp8SPxfo7hCHj57JtQyLCny9J0DjloSTORiOooJO0EvdSaLmhz1kyVlWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TKcMEi0z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TKcMEi0z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 389C8C4CEE3;
	Tue, 29 Apr 2025 23:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745970734;
	bh=jkTG/RVDQOw7PEikM62j/r5Iu3Ph4QkQB24TuvLKQPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TKcMEi0zgAXyOvOuFfjySEfnG/NyPeWpf27Gb9vg76jhl9KrlTsLu7lfncBf18v0f
	 9lw9xs/3mF07vtbo2lpSgoqOKgd4KrOZt1ZyVrTw3Q1+J/mRT7jxbhVWXCY2ZS+tvv
	 pUy3QhrA4+Mc++QqAj2PcoH8j9U4H9HURoUkRpqxPN1dN0gasRq52o6qKWXidfBIOy
	 8PBNqnQtRRMyDUV0ujFaSUfJj+t81jspuJnaJCAGby3NLEBRzppAS7zpXIP0eJOvxl
	 YBL3bzNaUwxanJ7X2dhQE/gpluuyvW3cyav8wAWcx+/yWL9H0LF1ZNf/bVTKiKFSis
	 TfFfwxDCnp5yQ==
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
Subject: [PATCH AUTOSEL 6.12 28/37] fs/ocfs2: use sleeping version of __find_get_block()
Date: Tue, 29 Apr 2025 19:51:13 -0400
Message-Id: <20250429235122.537321-28-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250429235122.537321-1-sashal@kernel.org>
References: <20250429235122.537321-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.25
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
index 1bf188b6866a6..ad3d7e63be3d3 100644
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

