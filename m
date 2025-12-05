Received: from forward103b.mail.yandex.net (forward103b.mail.yandex.net [178.154.239.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64092DF128
	for <ocfs2-devel@lists.linux.dev>; Fri,  5 Dec 2025 06:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764917550; cv=none; b=e07OBSMZozdFqeSnZwCMsfKLYJIjjFfLGu5oTdnBfyYL3LOv7SONFz9xy8a7avMj+i37V6LAC/yd/NaeEfuaNE/7iuQAa6iMankBwJgwYAxC81P3R4MQSse/WXKn7zsWtQzia2qgZar1o4637yPKK31bcDlXO2HlxeurT4mnuLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764917550; c=relaxed/simple;
	bh=4jZsE1qGVjha1qSFySQez3yGDI8HrucOZSartJ8Hv4o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AqNsqCNVQQcAda2engIQIu2g9LfHEMAtQeJ+5QS21omT59juaAi3r+ILsSzxU3Il4k0+2Wvc+7p8FOk1aSjrjIXa40BqPuaS+f/iB4vHBg4zbh1d7OFAPshLLMe4neuHn55rSI75cvSRnqfmdv5qgddV4iyzDTwZMaBYEfcLcuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=frBD0YCy; arc=none smtp.client-ip=178.154.239.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="frBD0YCy"
Received: from mail-nwsmtp-smtp-production-main-89.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-89.sas.yp-c.yandex.net [IPv6:2a02:6b8:c08:ec27:0:640:5ac1:0])
	by forward103b.mail.yandex.net (Yandex) with ESMTPS id BB772C0089;
	Fri, 05 Dec 2025 09:52:22 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-89.sas.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id Lqf93s8LN0U0-chdMY9tY;
	Fri, 05 Dec 2025 09:52:21 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1764917542; bh=8PiOkXWsIXYjlWYJBVOuPoM8TbBDRCog76wdgSnKOjk=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=frBD0YCyEwUDg6CUnMKag+J/cwW/+LeW0ublsk5I+OHM7nQ3IfgMhL2ysFc8UMNh0
	 ewQgMbH9n04n+NO6eTNNDiY4jhBVhY3RCgRIa1aoqNId+WBX2XiZExRDbQQphh80gh
	 6RUhskfqqYAD0J3KchAmJrdbJdUhHN+OHOhgVkEQ=
Authentication-Results: mail-nwsmtp-smtp-production-main-89.sas.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	lvc-project@linuxtesting.org,
	Dmitry Antipov <dmantipov@yandex.ru>,
	syzbot+cfc7cab3bb6eaa7c4de2@syzkaller.appspotmail.com
Subject: [PATCH] ocfs2: fix memory leak in ocfs2_merge_rec_left()
Date: Fri,  5 Dec 2025 09:51:59 +0300
Message-ID: <20251205065159.392749-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In 'ocfs2_merge_rec_left()', do not reset 'left_path' to NULL after
move, thus allowing 'ocfs2_free_path()' to free it before return.

Reported-by: syzbot+cfc7cab3bb6eaa7c4de2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=cfc7cab3bb6eaa7c4de2
Fixes: 677b975282e4 ("ocfs2: Add support for cross extent block")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 fs/ocfs2/alloc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index b267ec580da9..0ab9b06643f4 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -3654,7 +3654,6 @@ static int ocfs2_merge_rec_left(struct ocfs2_path *right_path,
 			 * So we use the new rightmost path.
 			 */
 			ocfs2_mv_path(right_path, left_path);
-			left_path = NULL;
 		} else
 			ocfs2_complete_edge_insert(handle, left_path,
 						   right_path, subtree_index);
-- 
2.52.0

