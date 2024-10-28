Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CDD520493E;
	Mon, 28 Oct 2024 10:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730112828; cv=none; b=gWS+YP10NqfVBGcT5BTx2OYem3xTNHOxb36UV/bEJ3yC8eEr8H9rcWZZxQllBFJ9CWgWrv+ZOSJrDUK+z7aMoiMiuXE4NPcPtO/1wxsllZL+sNzHEnBfRZax+wpFeCajuNoJQKZ8v+DdOfchDVD0Y3q/bUJg9fWOoLIWvdItwoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730112828; c=relaxed/simple;
	bh=iY6hqw+w+5Uk+0uOnHmszNCdRWJRxWBSunc10i/cPdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SeUYgopsfk7zd5korW6Alhvp8PvtG6B/O6tBsd7N7OW9Y08hfqGeswr4LketkwqEo2y+lw7heCwpRJbFodHqXvcRZy9SBlt7Lla7pLgmA46Asbc8itmUEs7YH0s1lkimEt/4oqlSO/767HsZMW/X9llLXMplzFbxSy+2dyka4m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BjCGw/5U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BjCGw/5U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22959C4CEC3;
	Mon, 28 Oct 2024 10:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730112828;
	bh=iY6hqw+w+5Uk+0uOnHmszNCdRWJRxWBSunc10i/cPdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BjCGw/5UXSp2S1lyEGWe4JY0iWeJiXkmgRxiwR4eKwGbEdRlTbNTlnvMjKl+8CLF5
	 7Ms3XXIqR0l91ubrIFLTtOTak0LAzqDtr33GwlahTY8I783xjBKIfzOWP7pmCu6TSw
	 DuIlnBqz65KAfSnehqivcjQGRWDfeghU/EIQpBPtckwB+bCy2aG1Fr4OxW8vCePsj/
	 6r9wxSBl3vlayFPkdvtir7rU5nlQaOXRTUVku4MiHX++X1fRQWART7a9VHPjoDnjNO
	 FqcKxZqg1OFuU1VbK9zknrWC7WP6oQUwkFKYD9gHYWtZCIM1BfHe4F3zIdwQcElFJe
	 zXX+yYYJe9Zmw==
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
Subject: [PATCH AUTOSEL 4.19 2/3] fs: Fix uninitialized value issue in from_kuid and from_kgid
Date: Mon, 28 Oct 2024 06:53:42 -0400
Message-ID: <20241028105343.3560809-2-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241028105343.3560809-1-sashal@kernel.org>
References: <20241028105343.3560809-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 4.19.322
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
index a6f486f4138f5..2ad01ff8c1a8e 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1143,9 +1143,12 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
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

