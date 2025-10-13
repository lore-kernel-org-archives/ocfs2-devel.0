Received: from forward200a.mail.yandex.net (forward200a.mail.yandex.net [178.154.239.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CCF834BA46
	for <ocfs2-devel@lists.linux.dev>; Mon, 13 Oct 2025 06:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760337290; cv=none; b=GcMuhOCS8Od1lpfHQbIItuIaH7ILKitNK8pJ86SDljtoddRLcj+ukPqTyIPnN+f90sCNgGZtq708Hz9fZ+kZaHDgl9ZCNVMVn4Omw4o+hGJ0IQ/lYAAx9qE02VQOiYFLfxIZSV1DO5hkq1n79lGBQ/JYHOvnNc5FECfGxsRgEaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760337290; c=relaxed/simple;
	bh=H0Nz5JUITsxUtIDTAfdb1eLzBX3KtjPITr58DSpryqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aZzQ0AGLpPXXEWbb8YcGaT6/NBCdf4Oo5O2g2BMPQ9wt4yqu5DnzBu6AtGHkt5yZpLzDr364mutta7zDzR16wiFL3uzkZvrhUCQxzv7UpGEW34i22pblU5UgVyos+P+Nv+GnG+MQ2bRuf237D4QQtArgD/+GDejPOk4t5VWIoSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=cc79FnsB; arc=none smtp.client-ip=178.154.239.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="cc79FnsB"
Received: from forward102a.mail.yandex.net (forward102a.mail.yandex.net [IPv6:2a02:6b8:c0e:500:1:45:d181:d102])
	by forward200a.mail.yandex.net (Yandex) with ESMTPS id 94F1983EC6
	for <ocfs2-devel@lists.linux.dev>; Mon, 13 Oct 2025 09:29:08 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-84.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-84.vla.yp-c.yandex.net [IPv6:2a02:6b8:c1f:1311:0:640:df31:0])
	by forward102a.mail.yandex.net (Yandex) with ESMTPS id 80EBFC00BA;
	Mon, 13 Oct 2025 09:29:00 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-84.vla.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id xSHF3JMLNuQ0-jdbQozN5;
	Mon, 13 Oct 2025 09:28:59 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1760336939; bh=i7OVrYCjuHckDVlu2odmSoUlZRsNjhBX8xbhRJ11PUQ=;
	h=Message-ID:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=cc79FnsBXNxta9YKGrXyqBK7dKI16A7N0ZphnTJpf1//svp4Yvz6x22NH3B7PIyAi
	 vrkgj4zBMr+sROtKHjnfCStH8XbNr4xWXTR9En2OstLIv8qq2ycIbUqziQwAixL/Dq
	 7+gZGseI36YYQ/mYq+s5bT4+A+l4IcHSs5KkD0ds=
Authentication-Results: mail-nwsmtp-smtp-production-main-84.vla.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Heming Zhao <heming.zhao@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	lvc-project@linuxtesting.org,
	Dmitry Antipov <dmantipov@yandex.ru>,
	syzbot+b20bbf680bb0f2ecedae@syzkaller.appspotmail.com
Subject: [PATCH v2] ocfs2: add boundary check to ocfs2_check_dir_entry()
Date: Mon, 13 Oct 2025 09:28:26 +0300
Message-ID: <20251013062826.122586-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <f5c8060f-fff2-4c16-afec-ac750550cc30@suse.com>
References: <f5c8060f-fff2-4c16-afec-ac750550cc30@suse.com>
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
v2: adjust error message (Heming Zhao)
---
 fs/ocfs2/dir.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index ece0462a5d26..b9bf1428a3d9 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -302,8 +302,21 @@ static int ocfs2_check_dir_entry(struct inode *dir,
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
+		mlog(ML_ERROR, "directory entry (#%llu: offset=%lu) "
+		     "too close to end or out-of-bounds",
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

