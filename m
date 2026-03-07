Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6822330B38
	for <ocfs2-devel@lists.linux.dev>; Sat,  7 Mar 2026 23:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772927717; cv=none; b=JoH2gzbELRa+1u70YsMgkTPfsXY1q+aC8nFid+GXi3MEWRxYgnSw3bzZ4HV7DS8+02yGocL/o7cLDAMD3KMmotHoauX+hZJypJjK7hPCoIjxeSpuCWDDJj0ijcqbIsudrkF0idO6O8q9sew9MBFO08P5qWaoCQGbEI8SgCGRF4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772927717; c=relaxed/simple;
	bh=BUs/tmrgPmVRQGJeQiAm5+FLv8p944pEW88fLOssMiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bsucxi/9Z1XlZyTf3A0xh9Cf73M8JakQv24MXaZ2kNoKBJPezNM8BeadIyLPl7VA9iNcpbBESuGtLXdpsPja3JXuxuF1audnnRT/QVfHt/KfabvQslimNRDpBKDdI90w40TlbBeIIAkMWoixx28QqW7WYmXQj9ZXvArofsmVcVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=PsFSrOmZ; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="PsFSrOmZ"
Received: from VelichayshiyPC.Dlink (unknown [178.64.226.167])
	by mail.ispras.ru (Postfix) with ESMTPSA id BBDF3413A4A1;
	Sat,  7 Mar 2026 23:48:53 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru BBDF3413A4A1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1772927334;
	bh=egaosrV3/XhKYBl1g3f49jCCkavHb/986Vem2Y1UR5o=;
	h=From:To:Cc:Subject:Date:From;
	b=PsFSrOmZ4ZnGDEAPgWLqwJIrmqSp3wxiC2ybq1FZqLO1LIjHzxWwnOaz51fnTaD8e
	 lzuk9u6pSjxChMZLGHrDqrJRKdfydE1KHTDkfG80uEtdQaaYuutqBbjtUtHbO9SnfW
	 z+AIVPRMdEUFVW0soIlwPgVtdGEMh2WZqqjvrM70=
From: Alexey Velichayshiy <a.velichayshiy@ispras.ru>
To: a.velichayshiy@ispras.ru,
	Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH] ocfs2: remove redundant error code assignment
Date: Sun,  8 Mar 2026 02:47:53 +0300
Message-ID: <20260307234809.88421-1-a.velichayshiy@ispras.ru>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Removed the error assignment for variable 'ret' during correct code
execution. In subsequent execution, variable 'ret' is overwritten.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Alexey Velichayshiy <a.velichayshiy@ispras.ru>
---
 fs/ocfs2/dlm/dlmmaster.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index eb62724bbe9b..93eff38fdadd 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -930,7 +930,6 @@ struct dlm_lock_resource * dlm_get_lock_resource(struct dlm_ctxt *dlm,
 	if (blocked)
 		goto wait;
 
-	ret = -EINVAL;
 	dlm_node_iter_init(mle->vote_map, &iter);
 	while ((nodenum = dlm_node_iter_next(&iter)) >= 0) {
 		ret = dlm_do_master_request(res, mle, nodenum);
-- 
2.43.0

