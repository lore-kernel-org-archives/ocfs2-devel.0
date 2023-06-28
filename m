Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7379E1377
	for <ocfs2-devel@lists.linux.dev>; Wed, 28 Jun 2023 01:40:43 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CF8591F37F;
	Wed, 28 Jun 2023 01:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1687916441; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7mUtj70hfffhSf0LgmJM3owstq8QZo7b9VRHZ1Xui5o=;
	b=XpQ3HRHtLemkPbOKHMI6rmnrvwcBEBEpGenJY1paHUdCC0k/GIC7VGbnLcHDa4bA0S/MdT
	CpzV6EXABuR/cJiQnTJJ+bWhw0n+S7Wi5t2Iq0uldiaIfuP6RFYUVR1vMewAIjhH8KQ1v9
	PLAHkYMNWI80AOUzeGoACwprCRv7+F0=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5B008138E8;
	Wed, 28 Jun 2023 01:40:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id 8Mq5EpmPm2TpLQAAMHmgww
	(envelope-from <ailiop@suse.com>); Wed, 28 Jun 2023 01:40:41 +0000
From: Anthony Iliopoulos <ailiop@suse.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [PATCH 1/2] MAINTAINERS: Update ocfs2-devel mailing list address
Date: Wed, 28 Jun 2023 03:34:36 +0200
Message-Id: <20230628013437.47030-2-ailiop@suse.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230628013437.47030-1-ailiop@suse.com>
References: <20230628013437.47030-1-ailiop@suse.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ocfs2-devel mailing list has been migrated to the kernel.org
infrastructure, update the related entry to reflect the change.

Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4545d4287305..2e95a8eb924e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15969,7 +15969,7 @@ ORACLE CLUSTER FILESYSTEM 2 (OCFS2)
 M:	Mark Fasheh <mark@fasheh.com>
 M:	Joel Becker <jlbec@evilplan.org>
 M:	Joseph Qi <joseph.qi@linux.alibaba.com>
-L:	ocfs2-devel@oss.oracle.com (moderated for non-subscribers)
+L:	ocfs2-devel@lists.linux.dev
 S:	Supported
 W:	http://ocfs2.wiki.kernel.org
 F:	Documentation/filesystems/dlmfs.rst
-- 
2.35.3

