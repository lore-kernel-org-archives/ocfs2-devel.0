Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36AC620125C;
	Mon, 28 Oct 2024 10:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730112798; cv=none; b=ShzoP9Kn359sYIt/U1A7IutubX4NOCJ3hcE18CpWbnItb5QKqmiCtaXaERw3C2GCyOShWyLNlmiZxHU9YlezIPxuJEnAQVcKcOneBT06KfELSFoGRZSf3swqKTRptghfbMKgZ5mh325wve70M61nWN7NiXig1fJdvj2Z4Y0XkZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730112798; c=relaxed/simple;
	bh=Zv5f3wAxuKS7gSm5wJ050Eht1FihpdQF4qBpwsFA6y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FyFzYbF8FUKA/RRC4HgkH5O9f/BdlV9gkbmZ/1w8piz/R5eOOGUBaVDTCsDZd8Vh2xfCJ5YdLhdjbaO7OpeUFoypYJJaJrXDtuM+5xNJmQ8MvsMYoT8AwzetTmx4f4nlcUP61xyCGZYJ/qPwduGXdEp8BB/uUZkrvsxnxP8gsuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EYcg9KMy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EYcg9KMy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C140AC4CEC3;
	Mon, 28 Oct 2024 10:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730112798;
	bh=Zv5f3wAxuKS7gSm5wJ050Eht1FihpdQF4qBpwsFA6y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EYcg9KMyvF1GY/ljIlXOmks2+NTplbWvj3ekagQPFa86Z++BGNVzLAQk3J6m1HWUl
	 y/El4+euTaDeuwK3LYr8jeLceUmLi42QPNEc07vUX6igzIRoOFg2jgnZrwZmaNPM3x
	 74EmwO3fKAwjMJjZwHQEwCcUoEfxif/TNZrQJLF/Gf10F7AgSKOkvzFC+FCBf35yKx
	 RKT4llnOJmqM5WjOKeofRp3KzEvL1t/4oXxsDux+8XEKNAarzWhLiLlshJfkkv11GT
	 S3ZzAYnHTUTSo+sv01FLfH0aDFVUkCc9lovtrGFxOukNNlc0FSFaw9ELQr4yfDoi3O
	 lIB1u0T8TKiOQ==
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
Subject: [PATCH AUTOSEL 5.15 3/7] fs: Fix uninitialized value issue in from_kuid and from_kgid
Date: Mon, 28 Oct 2024 06:53:05 -0400
Message-ID: <20241028105311.3560419-3-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241028105311.3560419-1-sashal@kernel.org>
References: <20241028105311.3560419-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.169
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
index 403c71a485c7c..259e019efe4f2 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1132,9 +1132,12 @@ int ocfs2_setattr(struct user_namespace *mnt_userns, struct dentry *dentry,
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

