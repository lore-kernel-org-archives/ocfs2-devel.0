Received: from forward206b.mail.yandex.net (forward206b.mail.yandex.net [178.154.239.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C69E2EDD58
	for <ocfs2-devel@lists.linux.dev>; Tue, 21 Oct 2025 08:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761034199; cv=none; b=YhZPcnSBxfKd5RpCPRMvoo1sya6l8SwyFsOnkKUeGbp37N9PQL96pNAyiFMYEFJZHiOgg1aKvEPR/0hAOni6kUiBFpGIR9U4TeuHDUcspn7G02xi1TIlq1DQSdTDl163pTFjcQBqTsVY76r9Eo1wKH1HRaHDgxrxBPvfOqwqsNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761034199; c=relaxed/simple;
	bh=ekeDFEGmA8+inZJV1odBI07Qo5dsmwohUmLzHlAUuyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LTdQJDKy5TJr6JyQUnH44er+slVI1w/1If81qrmAYtKCsOazQpgeUfltMhYjRh+qMiw63505lbfUtGR2LD65WQnvI0NaYaAAYxQ2EHOfjdeXtsBSB9/kdzlc1Qgn5cGLt0AeQ22bNF9CUzE3hnn4HdRNQard1hLKTc9/MgbnDnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=YjoShUS4; arc=none smtp.client-ip=178.154.239.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="YjoShUS4"
Received: from forward100b.mail.yandex.net (forward100b.mail.yandex.net [IPv6:2a02:6b8:c02:900:1:45:d181:d100])
	by forward206b.mail.yandex.net (Yandex) with ESMTPS id 03D5582EE7
	for <ocfs2-devel@lists.linux.dev>; Tue, 21 Oct 2025 11:04:15 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-98.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-98.sas.yp-c.yandex.net [IPv6:2a02:6b8:c23:1ba8:0:640:1638:0])
	by forward100b.mail.yandex.net (Yandex) with ESMTPS id D562D80B67;
	Tue, 21 Oct 2025 11:04:05 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-98.sas.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id 34R9ieCLr0U0-8avS9R0Z;
	Tue, 21 Oct 2025 11:04:05 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1761033845; bh=3052+ZuQzRM2rvThKgzWC7yIsu/CL+ioN12ukuxGPuo=;
	h=Message-ID:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=YjoShUS4mueNckdoyYKuwfV5Q4b2jA7fNGYbp/H/WypRMJa6F/l5A79pMkMNtAKRS
	 NYZLXKm940jv6rGq9+zbylUfCmtYukN/y3UYc0nxWRgfa09ukTXToFewtRI4JUKcMy
	 9sXyoQA2oCkmtLmGE3iw04dq+fU2xrezpTfHfes0=
Authentication-Results: mail-nwsmtp-smtp-production-main-98.sas.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Heming Zhao <heming.zhao@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	lvc-project@linuxtesting.org,
	Dmitry Antipov <dmantipov@yandex.ru>,
	syzbot+4d55dad3a9e8e9f7d2b5@syzkaller.appspotmail.com
Subject: [PATCH v3] ocfs2: add extra consistency check to ocfs2_replay_truncate_records()
Date: Tue, 21 Oct 2025 11:03:44 +0300
Message-ID: <20251021080344.86238-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <5d5f0edc-1251-4c15-8d3c-dc3c8023a871@suse.com>
References: <5d5f0edc-1251-4c15-8d3c-dc3c8023a871@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In 'ocfs2_replay_truncate_records()', check whether truncate log
length matches the one comes from the superblock parameters defined
when making a filesystem and current record index is within the valid
range, thus preventing an out-of-bounds accesses while iterating over
the log records below.

Reported-by: syzbot+4d55dad3a9e8e9f7d2b5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=4d55dad3a9e8e9f7d2b5
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
v3: bail on tl->tl_used > tl->tl_count since array indexing always uses tl->tl_used - 1
v2: adjust commit message (Heming Zhao)
---
 fs/ocfs2/alloc.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 162711cc5b20..657a9becc870 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -5941,6 +5941,16 @@ static int ocfs2_replay_truncate_records(struct ocfs2_super *osb,
 
 	di = (struct ocfs2_dinode *) tl_bh->b_data;
 	tl = &di->id2.i_dealloc;
+	if (le16_to_cpu(tl->tl_count) != ocfs2_truncate_recs_per_inode(osb->sb)) {
+		status = -EINVAL;
+		mlog_errno(status);
+		goto bail;
+	}
+	if (le16_to_cpu(tl->tl_used) > le16_to_cpu(tl->tl_count)) {
+		status = -EINVAL;
+		mlog_errno(status);
+		goto bail;
+	}
 	i = le16_to_cpu(tl->tl_used) - 1;
 	while (i >= 0) {
 		handle = ocfs2_start_trans(osb, OCFS2_TRUNCATE_LOG_FLUSH_ONE_REC);
-- 
2.51.0

