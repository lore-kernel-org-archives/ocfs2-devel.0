Received: from forward102d.mail.yandex.net (forward102d.mail.yandex.net [178.154.239.213])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F1A2F12DA
	for <ocfs2-devel@lists.linux.dev>; Tue, 21 Oct 2025 10:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.213
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761044158; cv=none; b=NgkKHnOyaDBZH0QUrRwTxM7X/3rcypiTTEvRVIilYSLRHJuyaKYOlZpwQZvIROmFcPUCJlMb2pj3H0b7S4F6LjTY0x2OO+NLd6/WLqeeFhgR9DG2afekK0r+bvrZLaYXCbKrXnmUcutL9PRSrqCmurURJWaFK/zmyvJnFFEPR8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761044158; c=relaxed/simple;
	bh=o0lNNja5hp83VSf8t+6/tVspEp/KkOPN7OOQ3casIzI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZYj7AWlRJIBbQNkoXbU0noyPsxHrOg6CTDbFuY0Ix7GI/7d1dnl2rO+5USJ2vXFqYazKusct09+cJoPAyLvCDZCyIXhLezjO1GYUbNIdkZTjKXnRTrmQy6exvOR9d5P6WfyJKHZb/r8FD/iCLDWjjRqnGRWYhc7kTptvNq++XG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=kgT/f5iI; arc=none smtp.client-ip=178.154.239.213
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="kgT/f5iI"
Received: from mail-nwsmtp-smtp-production-main-99.klg.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-99.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:d7c6:0:640:5e67:0])
	by forward102d.mail.yandex.net (Yandex) with ESMTPS id 9F59BC00DC;
	Tue, 21 Oct 2025 13:55:43 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-99.klg.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id gtTQZV1L28c0-n2KbhhJ8;
	Tue, 21 Oct 2025 13:55:43 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1761044143; bh=zXGCb/tYZS0vzR5dbt/WPOwyD8Fa3h+M2AaeT3AL1fY=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=kgT/f5iIrH9UffhoEhFPxYMyeogkhVvow1leyLlaLkigDLd86twpeEgntpfw4uY93
	 ZfxvVcxitt1eaVEObS0Rh6R8jRQkdwNk6zG55GhI3oATMsxE3xjEXri8mXAIGdXA67
	 B68hnChkh7JzOXrb1FWmfh9nMjvHEDl5iqXH3cfI=
Authentication-Results: mail-nwsmtp-smtp-production-main-99.klg.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Heming Zhao <heming.zhao@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] ocfs2: annotate more flexible array members with __counted_by_le()
Date: Tue, 21 Oct 2025 13:55:18 +0300
Message-ID: <20251021105518.119953-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Annotate flexible array members of 'struct ocfs2_local_alloc' and
'struct ocfs2_inline_data' with  '__counted_by_le()' attribute to
improve array bounds checking when CONFIG_UBSAN_BOUNDS is enabled,
and prefer the convenient 'memset()' over an explicit loop to
simplify 'ocfs2_clear_local_alloc()'.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 fs/ocfs2/localalloc.c | 4 +---
 fs/ocfs2/ocfs2_fs.h   | 4 ++--
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index d1aa04a5af1b..56be21c695d6 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -905,13 +905,11 @@ static int ocfs2_local_alloc_find_clear_bits(struct ocfs2_super *osb,
 static void ocfs2_clear_local_alloc(struct ocfs2_dinode *alloc)
 {
 	struct ocfs2_local_alloc *la = OCFS2_LOCAL_ALLOC(alloc);
-	int i;
 
 	alloc->id1.bitmap1.i_total = 0;
 	alloc->id1.bitmap1.i_used = 0;
 	la->la_bm_off = 0;
-	for(i = 0; i < le16_to_cpu(la->la_size); i++)
-		la->la_bitmap[i] = 0;
+	memset(la->la_bitmap, 0, le16_to_cpu(la->la_size));
 }
 
 #if 0
diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
index f7763da5c4a2..c501eb3cdcda 100644
--- a/fs/ocfs2/ocfs2_fs.h
+++ b/fs/ocfs2/ocfs2_fs.h
@@ -641,7 +641,7 @@ struct ocfs2_local_alloc
 	__le16 la_size;		/* Size of included bitmap, in bytes */
 	__le16 la_reserved1;
 	__le64 la_reserved2;
-/*10*/	__u8   la_bitmap[];
+/*10*/	__u8   la_bitmap[] __counted_by_le(la_size);
 };
 
 /*
@@ -654,7 +654,7 @@ struct ocfs2_inline_data
 				 * for data, starting at id_data */
 	__le16	id_reserved0;
 	__le32	id_reserved1;
-	__u8	id_data[];	/* Start of user data */
+	__u8	id_data[] __counted_by_le(id_count);	/* Start of user data */
 };
 
 /*
-- 
2.51.0

