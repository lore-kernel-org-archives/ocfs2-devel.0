Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82042265CD2
	for <ocfs2-devel@lists.linux.dev>; Tue,  8 Apr 2025 10:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744108465; cv=none; b=eOj/CTrVVeVDESfvJTOkzy+kmt6UxJXNMuYhI7DJNc87tPh7uP2YiFjDy2Eqa6sR9Eyu2+csnEmUwDG/TmUY2E/kH+SKIDnbQWrIQemxJj9nhZ6Up+Jm382wsBCj0NJvj/6psO1F5bKozoMfo8QLtakhASY2wbnjgFX8JLLEmww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744108465; c=relaxed/simple;
	bh=rReapcBGLGu8L+Hwbf2vZ5KOEKWoSxx7JuvvXrWRsdk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AHTzBV3bV93Rtv2O4Lu1DLUvNqNwt23E61i7+8qhkVUXPL/sT3XUVdnXOJogUYSBPE3S5cQri8cTIr1v+4JIbz4YC4BnOc0j/IPm/JLE2buhO/o3u1GYWHEHql9avrZjEDmyQqXVCaXYohURiv4oUeMsIXtluTGFJySVZJULXFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qN5dUub4; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qN5dUub4"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744108461;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Phsy5aVF/YSkL68ngrs2AHUyRpRPJWskhiyLV41VA4o=;
	b=qN5dUub4REq6sRDIlT6GRFaXgkqi/S3LWs3E/f5Cvsxfwnle4RZQfsO/6GXjRUOgwfQACv
	zkq53EgXyHeLrOnttLYupBUe1nqFuRt/mqS/a1RC4u4xhyhD7jtY4z6Q6b3MkU6Za3+tac
	KWH6vfBVtMpfYYwDD6MtFF4saDOWOdM=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ocfs2: Simplify return statement in ocfs2_filecheck_attr_store()
Date: Tue,  8 Apr 2025 12:34:07 +0200
Message-ID: <20250408103408.804253-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Don't negate 'ret' and simplify the return statement.

No functional changes intended.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 fs/ocfs2/filecheck.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/filecheck.c b/fs/ocfs2/filecheck.c
index 1ad7106741f8..3ad7baf67658 100644
--- a/fs/ocfs2/filecheck.c
+++ b/fs/ocfs2/filecheck.c
@@ -505,5 +505,5 @@ static ssize_t ocfs2_filecheck_attr_store(struct kobject *kobj,
 		ocfs2_filecheck_handle_entry(ent, entry);
 
 exit:
-	return (!ret ? count : ret);
+	return ret ?: count;
 }
