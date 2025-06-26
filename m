Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85371E4AB
	for <ocfs2-devel@lists.linux.dev>; Thu, 26 Jun 2025 02:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750904137; cv=none; b=Mxs6hFZorvdptcklqhEBL5Z860lLg3CTewL0H4iSkFQUCmLy9HPiH2soqxVRk2qbtMZ8SqjhbLyAvjwIC40p6Xj2zrIbT1C8E3wdU1Wtz3wOLhmMAXVbWXVHG/2hVUf44hPqakTxY1jHZSXfPdUDZiltvYQaZybTpn3tL5OC58Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750904137; c=relaxed/simple;
	bh=+dRX2AVflqAwHDhDktn+4p4n+goMhVeeIqK/XjI75m0=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=hs50NJqnPxw+SIXQJCn7xcnC9azix85W7BT5CBdruvWKC53PDHu0nZ2B58CoxGeUcIWVC50scq59/mpSaS+eeSDMVhop8HaIRGtnXbGGQe/t5+ZfT3yHmwlWRlZq5WEXZ5g4nBa/1fompgOJFpoS9+AUSsw1QBiaOYfRVJCPTEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 55Q2F2Mc028149;
	Thu, 26 Jun 2025 11:15:02 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.6] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 55Q2F0Cq028142
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Thu, 26 Jun 2025 11:15:00 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <d689279f-03ed-4f9b-8fde-713b2431f303@I-love.SAKURA.ne.jp>
Date: Thu, 26 Jun 2025 11:14:59 +0900
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Richard Weinberger
 <richard@nod.at>,
        Al Viro <viro@zeniv.linux.org.uk>, ocfs2-devel@lists.linux.dev,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH] ocfs2: update d_splice_alias() return code checking
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Anti-Virus-Server: fsav101.rs.sakura.ne.jp
X-Virus-Status: clean

When commit d3556babd7fa ("ocfs2: fix d_splice_alias() return code
checking") was merged into v3.18-rc3, d_splice_alias() was returning
one of a valid dentry, NULL or an ERR_PTR.

But when commit b5ae6b15bd73 ("merge d_materialise_unique() into
d_splice_alias()") was merged into v3.19-rc1, d_splice_alias() started
returning -ELOOP as one of ERR_PTR values.

As a result, when syzkaller mounts a crafted ocfs2 filesystem image that
hits d_splice_alias() == -ELOOP case from ocfs2_lookup(), ocfs2_lookup()
fails to handle -ELOOP case and generic_shutdown_super() hits "VFS: Busy
inodes after unmount" message.

Don't call ocfs2_dentry_attach_lock() nor ocfs2_dentry_attach_gen()
when d_splice_alias() returned -ELOOP.

Reported-by: syzbot <syzbot+1134d3a5b062e9665a7a@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=1134d3a5b062e9665a7a
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
This patch wants review from maintainers. I'm not familiar with this change.

 fs/ocfs2/namei.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 99278c8f0e24..4ccb39f43bc6 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -142,6 +142,8 @@ static struct dentry *ocfs2_lookup(struct inode *dir, struct dentry *dentry,
 
 bail_add:
 	ret = d_splice_alias(inode, dentry);
+	if (ret == ERR_PTR(-ELOOP))
+		goto bail_unlock;
 
 	if (inode) {
 		/*
-- 
2.49.0

