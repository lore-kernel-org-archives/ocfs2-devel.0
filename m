Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C51220402F;
	Mon, 28 Oct 2024 10:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730112821; cv=none; b=qxOaPtRNnCLszg9IP0cjfm3jBt2ajcEWQI+M9K/JJhHCDzEoj5q7zvNc9VkutlWh9qldyFAM/Ll3IcmZ/UIFApr4ZutfaXiLIFHDZFaL5lFYrHPpX8iSvAFw7kstTKMpgQOfjkhXzdBa/QVvuCwy47oonvmJ5hQ/AClhxUHfGNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730112821; c=relaxed/simple;
	bh=5e1nmkZ5/ECJMyMGXwdkRBz6swVHwDFg+oeIimFOypc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PrBkRE0UT5HKO1JCTxpfyEAbvZk57stYooFNt6KnNB+kmO9MCOpttNEMCG4Ai3W2BcYOE8+9cHkxn9Dfx1WBU17+zJ7SYO0SBYigs7w6DW/N1Olbd85a3eXqv8xLT55QCAsYcK49zazarPCmS6lE4CGvic73vcOlCNdafceI+2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iTL9YqfQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iTL9YqfQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A22DBC4CEE8;
	Mon, 28 Oct 2024 10:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730112820;
	bh=5e1nmkZ5/ECJMyMGXwdkRBz6swVHwDFg+oeIimFOypc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iTL9YqfQKr4Vgal95UjkOkTrrk8uKaj3tDxM6yhRwKyY45RMdeWqRcZ5ADy3uTa0/
	 kzyF9Ey9nICmXLWcnB+8ZoXpDWzcaDjg8lk/Zo0pDIxWu3I/ZzTS16R3l3fC7a7jst
	 WMcrWcEUT9YKlDwkmNHCcDEfR1rTzFfUdZfrUWHJQtfmLKxLkdi4g9snGfFzJ9XBKa
	 S3aHGtlxINSjEMwVTgVje7vH9qRjr0s9JPGPTAptJvpiidqGuBjS37Qg0vv0nSKNdv
	 xGXrd/+nN8RGkKQQPxzH/zj58/6W6lsCw/N13aN/TbCtKxH332ZjmPp4mftXfD09dg
	 cB6yHHhS4ceww==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Alessandro Zanni <alessandro.zanni87@gmail.com>,
	syzbot+6c55f725d1bdc8c52058@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	ocfs2-devel@lists.linux.dev
Subject: [PATCH AUTOSEL 5.4 2/3] fs: Fix uninitialized value issue in from_kuid and from_kgid
Date: Mon, 28 Oct 2024 06:53:34 -0400
Message-ID: <20241028105336.3560730-2-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241028105336.3560730-1-sashal@kernel.org>
References: <20241028105336.3560730-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.284
Content-Transfer-Encoding: 8bit

From: Alessandro Zanni <alessandro.zanni87@gmail.com>

[ Upstream commit 15f34347481648a567db67fb473c23befb796af5 ]

ocfs2_setattr() uses attr->ia_mode, attr->ia_uid and attr->ia_gid in
a trace point even though ATTR_MODE, ATTR_UID and ATTR_GID aren't set.

Initialize all fields of newattrs to avoid uninitialized variables, by
checking if ATTR_MODE, ATTR_UID, ATTR_GID are initialized, otherwise 0.

Reported-by: syzbot+6c55f725d1bdc8c52058@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6c55f725d1bdc8c52058
Signed-off-by: Alessandro Zanni <alessandro.zanni87@gmail.com>
Link: https://lore.kernel.org/r/20241017120553.55331-1-alessandro.zanni87@gmail.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/file.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 7294d5b3d80fe..5aac660d66452 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1133,9 +1133,12 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 	trace_ocfs2_setattr(inode, dentry,
 			    (unsigned long long)OCFS2_I(inode)->ip_blkno,
 			    dentry->d_name.len, dentry->d_name.name,
-			    attr->ia_valid, attr->ia_mode,
-			    from_kuid(&init_user_ns, attr->ia_uid),
-			    from_kgid(&init_user_ns, attr->ia_gid));
+			    attr->ia_valid,
+				attr->ia_valid & ATTR_MODE ? attr->ia_mode : 0,
+				attr->ia_valid & ATTR_UID ?
+					from_kuid(&init_user_ns, attr->ia_uid) : 0,
+				attr->ia_valid & ATTR_GID ?
+					from_kgid(&init_user_ns, attr->ia_gid) : 0);
 
 	/* ensuring we don't even attempt to truncate a symlink */
 	if (S_ISLNK(inode->i_mode))
-- 
2.43.0

