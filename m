Received: from forward201a.mail.yandex.net (forward201a.mail.yandex.net [178.154.239.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF4E25A65B
	for <ocfs2-devel@lists.linux.dev>; Fri, 10 Oct 2025 09:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760088542; cv=none; b=NgT4z8/RSruSuQUoRLxfBV1VR+rRa+Og8ulXW65IqziiJ+S46IFqrJuRMyaQzdH6WtHDxgDsUpdFZL2PmIH+4F641kVBVtn2SOA2an20OoHW7TCr820IzLe47Sf6tyBxSlue+v86UkAIW+C5ZT5lflp+yC9UlPATCBNb1WL2uO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760088542; c=relaxed/simple;
	bh=t57QBDo4Jai7Ua2Kj3O0V93aqYNCIFTXLyoFndmnoPY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CYGS5w8FiUEvmYh0KQMS6oy6Q6aqMIro1mP5nc19oSxDlCiwcpR8Fd1yVneJL2HL8SEVrDNIx7lUhwSTsjJgkofOYaG2lab916ChyAoRoiAnYFau+ywQ2w0WRxmVrjMN6gzfPOfpEwQ44nKHATV9fzNRM2br0FJV05b2DHANWcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=aVbdSmla; arc=none smtp.client-ip=178.154.239.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="aVbdSmla"
Received: from forward101a.mail.yandex.net (forward101a.mail.yandex.net [IPv6:2a02:6b8:c0e:500:1:45:d181:d101])
	by forward201a.mail.yandex.net (Yandex) with ESMTPS id 2271584F99
	for <ocfs2-devel@lists.linux.dev>; Fri, 10 Oct 2025 12:21:57 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-84.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-84.vla.yp-c.yandex.net [IPv6:2a02:6b8:c1f:1311:0:640:df31:0])
	by forward101a.mail.yandex.net (Yandex) with ESMTPS id 9AE3380C37;
	Fri, 10 Oct 2025 12:21:48 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-84.vla.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id lLHPqbkLQ0U0-gVAzoh19;
	Fri, 10 Oct 2025 12:21:48 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1760088108; bh=+Dsv2SmgYtPv8sD3EpC/uSTadJoBBJ+EbovdoM/VX3o=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=aVbdSmlaA6tR/ZSM3qu5XIMdzgLv8TMWfX4pHnO2IbfKDsHQ1/5WFE7A9mvhsVyEt
	 tFmCISwjkbx2YIe2Uo6Uh8ZUTYF8vWB0RnkxTyO4YiRlz0sVW5/WzXjGMEI00SZ0PB
	 fvM2jbufCSbj0b/f0F8XrWR1bAg6znkm6XYJt2ec=
Authentication-Results: mail-nwsmtp-smtp-production-main-84.vla.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Heming Zhao <heming.zhao@suse.com>,
	ocfs2-devel@lists.linux.dev,
	lvc-project@linuxtesting.org,
	Dmitry Antipov <dmantipov@yandex.ru>,
	syzbot+b20bbf680bb0f2ecedae@syzkaller.appspotmail.com
Subject: [PATCH] ocfs2: add boundary check to ocfs2_check_dir_entry()
Date: Fri, 10 Oct 2025 12:21:30 +0300
Message-ID: <20251010092130.621495-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In 'ocfs2_check_dir_entry()', add extra check whether at least the
smallest possible dirent may be located at the specified offset
within bh's data, thus preventing an out-of-bounds accesses below.

Reported-by: syzbot+b20bbf680bb0f2ecedae@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b20bbf680bb0f2ecedae
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 fs/ocfs2/dir.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 8c9c4825f984..c523816a3ebb 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -302,8 +302,20 @@ static int ocfs2_check_dir_entry(struct inode *dir,
 				 unsigned long offset)
 {
 	const char *error_msg = NULL;
-	const int rlen = le16_to_cpu(de->rec_len);
-	const unsigned long next_offset = ((char *) de - buf) + rlen;
+	unsigned long next_offset;
+	int rlen;
+
+	if (offset > size - OCFS2_DIR_REC_LEN(1)) {
+		/* Dirent is (maybe partially) beyond the buffer
+		 * boundaries so touching 'de' members is unsafe.
+		 */
+		mlog(ML_ERROR, "out-of-bounds entry in directory #%llu: offset=%lu",
+		     (unsigned long long)OCFS2_I(dir)->ip_blkno, offset);
+		return 0;
+	}
+
+	rlen = le16_to_cpu(de->rec_len);
+	next_offset = ((char *) de - buf) + rlen;
 
 	if (unlikely(rlen < OCFS2_DIR_REC_LEN(1)))
 		error_msg = "rec_len is smaller than minimal";
-- 
2.51.0

