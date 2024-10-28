Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75F01FAF17;
	Mon, 28 Oct 2024 10:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730112779; cv=none; b=F2RSr65dYVkAPJ+7/zCST6UV46hBbUWwzv9d6elSTr9Hde8IdesDvKPxhiIruQAY62+eChtUQSogsd+brVuIr+xrTJfrfb0T9cupw52NwddHzz3gRm9SI/Pm+0K27voL1z9rli9gz8mVX1heiJNNltrKG0G9xyLvv8kuUoLUoqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730112779; c=relaxed/simple;
	bh=dCkTMusFHGqhHmNia7+KA2uBQORiyhj/Ukzp/dcBfa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DJvA+ckH/wvIkY3sfN6IJuOVwqTBDFwX1qs5Pi8JtVI8RTLo9YyNf8INpYrv9Vc4XEWDWi10kw3+MBpmS+3bjgpsoeJkwdmwWjqO/048LKwNY8ITsjCDrHm7mbPaoj2lX1mXr6vs1cAGFbeeEW7HCAaok5sP5p9JyO3PSvu74Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PuyIm70h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PuyIm70h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDBBBC4CEC3;
	Mon, 28 Oct 2024 10:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730112779;
	bh=dCkTMusFHGqhHmNia7+KA2uBQORiyhj/Ukzp/dcBfa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PuyIm70hSnr5USnhCmhndEw0nbm21CDyS2OdP783sZU+1saZIHZCYlilvQEW8FsLi
	 mQgfV75BCROb2pkoJaox6XRPC6/mHD2XPYq4kEhn0LMri0O45D1EOdKueu5a+pTllh
	 ibrfDHQWtJ84kpIc87e98FkT88u7CEt3Gp9JF14kzIQfGo96NQyWiiyLWlAMHoQ5ZO
	 3ldf97flcheeXQrwtbCFXJT0Yx/elX3QvGhD1AiOhEoTxrMHEZZ+48sJd3/bggym0j
	 MOUcEMGQwQKNW8+7wpcghWAhMT5FQ2FA9xIGAqe2ePutjkmClrfgU3JGladYfFjHbJ
	 2WnApmdbJa3iQ==
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
Subject: [PATCH AUTOSEL 6.1 3/8] fs: Fix uninitialized value issue in from_kuid and from_kgid
Date: Mon, 28 Oct 2024 06:52:44 -0400
Message-ID: <20241028105252.3560220-3-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241028105252.3560220-1-sashal@kernel.org>
References: <20241028105252.3560220-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.114
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
index f502bb2ce2ea7..cac806174d10c 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1129,9 +1129,12 @@ int ocfs2_setattr(struct user_namespace *mnt_userns, struct dentry *dentry,
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

