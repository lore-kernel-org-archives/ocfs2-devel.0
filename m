Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897E023098E
	for <ocfs2-devel@lists.linux.dev>; Sat, 23 Nov 2024 13:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732368520; cv=none; b=uauC3iMRny165HWF8ZFHAN7qPHSYQhb4V0HcX48FvxXjfYViUrZ1nauSZWtQ+SPkcyED+CaPge7ChXcKwwd6C9ImG7AxwjeP7/ubJZDbnPgLfQHmdNLfP3Y1UxGeuNT1wOZLiEOWY7k4i100DBzk+ak9i+BUt4MTRSB3ELqCM0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732368520; c=relaxed/simple;
	bh=t5GEo7AXVS0PGr5nZCVv7Kq2qs+YwtQUjlgLOFfXQM8=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=Ctk6BpBJgqfMRxK49kKAmzNfQ9v+reLnwe66VONG6GtkAyb9dy1P7Cjh4Cj9YUjAnhavpiE7LgjlGzqh/OApUBFPGSxVnsaWbD7gqITneevO2wYXZ7jlEalZA5jnWOjYpJO6lK7NnBEtxTXRLpGkjsZcluEveNF9h5OmnT3G2B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 4ANDSZFt089116;
	Sat, 23 Nov 2024 22:28:35 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.6] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 4ANDSYtP089112
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Sat, 23 Nov 2024 22:28:35 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <e68c0224-b7c6-4784-b4fa-a9fc8c675525@I-love.SAKURA.ne.jp>
Date: Sat, 23 Nov 2024 22:28:34 +0900
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: ocfs2-devel@lists.linux.dev
Cc: LKML <linux-kernel@vger.kernel.org>, Junxiao Bi <junxiao.bi@oracle.com>,
        Jan Kara <jack@suse.com>
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH] ocfs2: free inode when ocfs2_get_init_inode() fails
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Anti-Virus-Server: fsav202.rs.sakura.ne.jp
X-Virus-Status: clean

syzbot is reporting busy inodes after unmount, for commit 9c89fe0af826
("ocfs2: Handle error from dquot_initialize()") forgot to call iput()
when new_inode() succeeded and dquot_initialize() failed.

Reported-by: syzbot+0af00f6a2cba2058b5db@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0af00f6a2cba2058b5db
Tested-by: syzbot+0af00f6a2cba2058b5db@syzkaller.appspotmail.com
Fixes: 9c89fe0af826 ("ocfs2: Handle error from dquot_initialize()")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 fs/ocfs2/namei.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 59c92353151a..5550f8afa438 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -200,8 +200,10 @@ static struct inode *ocfs2_get_init_inode(struct inode *dir, umode_t mode)
 	mode = mode_strip_sgid(&nop_mnt_idmap, dir, mode);
 	inode_init_owner(&nop_mnt_idmap, inode, dir, mode);
 	status = dquot_initialize(inode);
-	if (status)
+	if (status) {
+		iput(inode);
 		return ERR_PTR(status);
+	}
 
 	return inode;
 }
-- 
2.47.0
