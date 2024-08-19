Received: from out162-62-57-49.mail.qq.com (out162-62-57-49.mail.qq.com [162.62.57.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93FDE154C19
	for <ocfs2-devel@lists.linux.dev>; Mon, 19 Aug 2024 13:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724074663; cv=none; b=MX51F8DqG/EkpsKcv7gBYbITKTeZ6MBwbxpal42fOEMlkRucbNTNDkk5JkT/lVqQ80G680TRib17H580ySHCP867cnI0v+5/NW5BnFW8aK0p/Y8TZ8PrN/D8+PUHz3d3Oe+a5/PgxYrsHz0CWWzjK8PLAeys+ln19+MDv7b9Urg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724074663; c=relaxed/simple;
	bh=zqQnjPLRzcXO7/t3xlo9e0xwX8HTbgYJiHZTVnSB7PQ=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=XJpSDaL96rCife1oaAdlQ5e0C4t01lBbPFEpXfANemVCUx9/OWIskc42l0e3DhNY+BBMDyLdJ8NS+m4PTdXbIB+1bq9VGWr4vyURoEKi0C4+M4HUl5VuU+Z6g6asoJhPv7RHa/gQxtOSOBlawR6o8DUpyp8reepeI9jIUlSI0Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=GPz4bWYY; arc=none smtp.client-ip=162.62.57.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="GPz4bWYY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1724074649; bh=2wMqJMCOY7StTOp6eQQXkHi+RNUVnlidZ7g7RNmnJWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GPz4bWYY+f0qBkYyom5koO5Xl5QsCAz3M0PJx3UVWRbP4eeiZhMNzLQJ6zqSi8m2J
	 Et4s39tTyLlBSw6/D1NOP/8uaX6SXXJIMgH9t8LyDWHBl+8W0ZyxrPNYuR5dS4BhkG
	 5NG8p0By0rGQ/uX7Wq52KWPdw4COQT7zmBWBgGY8=
Received: from pek-lxu-l1.wrs.com ([111.198.225.4])
	by newxmesmtplogicsvrszb9-1.qq.com (NewEsmtp) with SMTP
	id 906174C2; Mon, 19 Aug 2024 21:36:06 +0800
X-QQ-mid: xmsmtpt1724074566tidpeyyso
Message-ID: <tencent_879750E9E2EF32CD287A2E6C9C2C856F1C0A@qq.com>
X-QQ-XMAILINFO: NQR8mRxMnur9PJ3oCcHFUsB6EnKTTSyPOh3P8Ccawdoe1YxxEcwTNkKGAdMYC5
	 v9KZzQ/WJCM6J1YXHlFlHoFwYOuXepPxbZF7TC6T5Dhd+qgepvkmA+WO31Nnbh1szb+clVRlGjaY
	 CZD/IjrVNJl32qKun7+jawezUNkS4a0ZoLl4W4Zu8XQyHoAf2j7h8vJfQR5kT+ygiVOxcwyHb2+u
	 U532pQatigC9vGtx4QIBJNnu6hxqV2F+IRgpjdrDHSSy1rxS1k8nbHiX524jCYu+zzaykpwpVF1e
	 kM1TxYorQH5zEhqVcRr6/h1+jxz2HUMQM7jWaSI7PnoPMwFVLW/WsEIs3XAxieQJm2Pi1GVuNo1G
	 o1/WlGPa1A9PqcX4GIKBCJ1GXBvMZuz97ALTeP0FCL0owa6raxdRFUgGTtkXp6MJ5n3l1zgS0XI5
	 F1bWILXkJpKO4TCaCOR/LOH+/0baDOpFtY9gs7AXzzocn76as1XdO8n3zlcFqrEI9bNz55ahAZ7r
	 lBibt37HgTfhjsSWxH5rLMe267XcCmMGKRdXvCvewwZZzzT5Zmi3b0sgyDzeShMpGMAuUqeyTT5u
	 T2vHUDlLCCGPsuQ+EkR40mBvgWBONJw5DwdLAH2l7DEdmaOJintUm0Ya98ghqH9hNWdJY0Fyuy0G
	 7zZsbw9XDZnNseBhgIDmxXW5JAfuno+oSZ6rgKllohrCPd0O0eBnFR4GcnN2KPZeYy5rBtGQpY12
	 m0Wzffqp2XEHJe3hLgg2iEWMKgf4WMfZdkw3oRxLvDiKFZj4lWYifxii8j3FmpwM92HF5tEAhSha
	 ueuNQOgrm7FfGl9eT+PDctpvSGM9wa9sLYtpo87Fhl4FjU+liKU4gEZX/XzdA60QuxIvQ5LdBGXu
	 agWVGcU6fkjIc/EaF8GuQcgc7mJNTx6HWu2+PhmBAMKA95IVIWI2LHFON2S4OG5vwiTW8371U2Ds
	 4kBnmFvQY=
X-QQ-XMRINFO: Mp0Kj//9VHAxr69bL5MkOOs=
From: Edward Adam Davis <eadavis@qq.com>
To: syzbot+05b9b39d8bdfe1a0861f@syzkaller.appspotmail.com
Cc: jack@suse.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mark@fasheh.com,
	ocfs2-devel@lists.linux.dev,
	syzkaller-bugs@googlegroups.com,
	tytso@mit.edu
Subject: [PATCH] ocfs2: Fix null-ptr-deref in jbd2_journal_update_sb_log_tail
Date: Mon, 19 Aug 2024 21:36:06 +0800
X-OQ-MSGID: <20240819133605.3256941-2-eadavis@qq.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <000000000000742b9d062005fc1c@google.com>
References: <000000000000742b9d062005fc1c@google.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Journal too short will cause ocfs2_check_volume failed, and will set
journal->j_sb_buffer to NULL in journal_fail_superblock before running
journal shutdown.

Reported-and-tested-by: syzbot+05b9b39d8bdfe1a0861f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=05b9b39d8bdfe1a0861f
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
 fs/ocfs2/journal.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 530fba34f6d3..25821077b855 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1077,9 +1077,11 @@ void ocfs2_journal_shutdown(struct ocfs2_super *osb)
 	BUG_ON(atomic_read(&(osb->journal->j_num_trans)) != 0);
 
 	if (ocfs2_mount_local(osb)) {
-		jbd2_journal_lock_updates(journal->j_journal);
-		status = jbd2_journal_flush(journal->j_journal, 0);
-		jbd2_journal_unlock_updates(journal->j_journal);
+		if (journal->j_journal->j_sb_buffer) {
+			jbd2_journal_lock_updates(journal->j_journal);
+			status = jbd2_journal_flush(journal->j_journal, 0);
+			jbd2_journal_unlock_updates(journal->j_journal);
+		}
 		if (status < 0)
 			mlog_errno(status);
 	}
-- 
2.43.0

