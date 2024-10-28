Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4C71D63F1;
	Mon, 28 Oct 2024 10:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730112690; cv=none; b=TZsllIORweIx5zgyBF/Ew9oOfItV5E+8EVFXOY5AUTho3gpwAp0kUDqBXZUzIIA0ss3cSBQ/aAM/gJp2x7nODpyCU99f3ZwZZe+f+AaRkNAOxTmQ4C0gNoDJR+8IFx2L/y+HxcLWiSBibKAU1ekihqQv2YA5PJPLF+GXD9PvwMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730112690; c=relaxed/simple;
	bh=E+FH3jjpqV5vvtaT2OrB0vidObJVqTBRDahSFj3xrws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kRCtgrJJ2Z2B2aaT9LZVIfMcto4+MHL4QlAysiPmNpfa3CqpA1s9hhDbqbrleHTFV2WEIYRnM+eD3BlHeQpzSB9gy+6iVvM3nz/+6vwbgAu6DxMaOSNjda2UfQRPJu1f+nzAzG7YWRgTsOz0zQS5nMlgQzMJ+BynPkwqP3xohzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p0Qtn7Fv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p0Qtn7Fv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04BD8C4CEE8;
	Mon, 28 Oct 2024 10:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730112690;
	bh=E+FH3jjpqV5vvtaT2OrB0vidObJVqTBRDahSFj3xrws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p0Qtn7FvuBErVWfnPKs5CBhH5yt/KmFnNczlRPyoDH0jI2DQqmq8v0cIXU2RrOhP1
	 N7cBgM5/N9dzgSL7nSPOIMrFsijABzLz/89+6bWps4/kLJaJaLW2vF8SwI0Ez5K5LV
	 IQFz77yrW8fTsPX/Fw8A+WR789+v4sZ8a7aHn1ZdVMNiOz7MCn5CCF8xSiNES25REU
	 OOQHKv1RwkCMEWIcMxAmlOg/KpUaX26+IVKkJjL8SNoM/LYxUxRRBHNVW/fepnUxy7
	 I/pje3VlDeXNZEt03wInkEsk75knAyeodyfw3aJi4L87/0r833XQEpAnzf57E0Bc5w
	 /2WzHGboCjeow==
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
Subject: [PATCH AUTOSEL 6.11 13/32] fs: Fix uninitialized value issue in from_kuid and from_kgid
Date: Mon, 28 Oct 2024 06:49:55 -0400
Message-ID: <20241028105050.3559169-13-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241028105050.3559169-1-sashal@kernel.org>
References: <20241028105050.3559169-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.11.5
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
index ccc57038a9779..849783ecaa3cb 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1128,9 +1128,12 @@ int ocfs2_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
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

