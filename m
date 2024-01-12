Received: from mail.nfschina.com (unknown [42.101.60.195])
	by smtp.subspace.kernel.org (Postfix) with SMTP id F237B1A73F;
	Fri, 12 Jan 2024 04:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nfschina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nfschina.com
Received: from localhost.localdomain (unknown [180.167.10.98])
	by mail.nfschina.com (Maildata Gateway V2.8.8) with ESMTPSA id 2EF13604F04CD;
	Fri, 12 Jan 2024 12:26:45 +0800 (CST)
X-MD-Sfrom: suhui@nfschina.com
X-MD-SrcIP: 180.167.10.98
From: Su Hui <suhui@nfschina.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	nathan@kernel.org,
	ndesaulniers@google.com,
	morbo@google.com,
	justinstitt@google.com
Cc: Su Hui <suhui@nfschina.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	kernel-janitors@vger.kernel.org
Subject: [PATCH] ocfs2: remove useless code in ocfs2_try_to_merge_extent
Date: Fri, 12 Jan 2024 12:26:40 +0800
Message-Id: <20240112042639.3948236-1-suhui@nfschina.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Clang static checker warning: Value stored to 'rec' is never read.
Remove this useless code to silent this warning.

Signed-off-by: Su Hui <suhui@nfschina.com>
---
 fs/ocfs2/alloc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index ea9127ba3208..71729e4326d3 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -3743,8 +3743,6 @@ static int ocfs2_try_to_merge_extent(handle_t *handle,
 			goto out;
 		}
 
-		rec = &el->l_recs[split_index];
-
 		/*
 		 * Note that we don't pass split_rec here on purpose -
 		 * we've merged it into the rec already.
-- 
2.30.2

