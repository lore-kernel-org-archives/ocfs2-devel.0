Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59785203712;
	Mon, 28 Oct 2024 10:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730112813; cv=none; b=aCQsBST5zzZWotNyhOvvnW3Egv4NOvN910rd/zBaYSLoBK/khoK7nbMjYBd67QsUk1V/EDbJel2bUx5ElVvc60KcBtHEMa1nZ9bSA9hTCqsM5r45HgI9FuFckguufymOr5xrqpch3NmRmIcO1yrA+KpSy+y34HP1MC7hBF8sY+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730112813; c=relaxed/simple;
	bh=5sGIjL7wdVbJxTSTNLF1P3ztjNzHxtaRoXFM3tm8Ek8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=okQwJnE9FL+jK5xJbXWuhlskcVJQUMd5ADWecajucw4gv7pxacqg9XyJIMLAwsE0Cinwq9en4hOn4E6mdDLGzpYHSnNBWlspR/aWNONNmaaEfvMwMXFVWWPkm6mOCGsgX4IoyKu/7IaO16LBH1BgYVkoRj72/XrJytqXX5qCw8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jc3RxdG6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jc3RxdG6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE3FC4CEE8;
	Mon, 28 Oct 2024 10:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730112813;
	bh=5sGIjL7wdVbJxTSTNLF1P3ztjNzHxtaRoXFM3tm8Ek8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jc3RxdG65XoCDlovNYk86Qp4dDClnhcKfCnz7NTSuD1HIWN9yXiOVi3BVst9xbIPU
	 DMbmOOSBqRoD57oAYc+G65w5Ovyir5KnGEthbEcmXzzxUD7k91F5LLB7yeznDJk0ux
	 JgcvMQzhufyt6mYm8oNqN7mgSNH+lMQwSir4vs8zbgeWPEsj0uStofZHvVAoWGOMn4
	 wwGHV9pVTMVS6MPNm0nyBa8OLmZbaGMFekoM7R9ktu3sbulaExB3C7jbKWu82td0FX
	 7TYdNeYkow820cZO0RscC3CjKmK4ABV4SIWRUbYJwnHFsouGJYcw8RqF72xMeAUbh1
	 6sF4SdzKQibZA==
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
Subject: [PATCH AUTOSEL 5.10 3/4] fs: Fix uninitialized value issue in from_kuid and from_kgid
Date: Mon, 28 Oct 2024 06:53:24 -0400
Message-ID: <20241028105327.3560637-3-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241028105327.3560637-1-sashal@kernel.org>
References: <20241028105327.3560637-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.10.228
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
index 5fd565a6228f7..22ce4c171b7bd 100644
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

