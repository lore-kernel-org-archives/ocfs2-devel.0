Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06032AD0D;
	Tue, 11 Nov 2025 03:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762830085; cv=none; b=VrhfRh4s5577m7Y70DsB718VXqxVokxZ0+PsspSc0CbaZLBUH+DFoLh3iSy8ffX1fVnag8Ett3/MbAWl9G83fA2a2wXcXurOPGUyQJ7zMmHEXgwPqtkaOLAT+bex3SbwlaB7lg/n4ZkVa4BZqehJ4sZIb/VNTrFbKXa2ymfjbJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762830085; c=relaxed/simple;
	bh=ffT4XRgc3gSzu/oLyQRC6VgHEbyS3+VNOYHJPEHQBhU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=DxHgn1m2mQ0JgbTAzszSWhg/0od/YDzpJqpqI6inKcYCJX7lPP6Tq0dMXm1QO5ryQuuHgB2VLxk4hhrdWlTP0apViV57zHW7XtWw5L7jEWN6WUMxRrFpYbZ/7hiMC5eFHfiQQvAjbYCNvVIz0isXG9168CvUJn3sEB3kCtwEThw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iVUwICY5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iVUwICY5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7713C113D0;
	Tue, 11 Nov 2025 03:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762830084;
	bh=ffT4XRgc3gSzu/oLyQRC6VgHEbyS3+VNOYHJPEHQBhU=;
	h=Date:From:To:Cc:Subject:From;
	b=iVUwICY50goymhKgmwYiHDyBVgytrpH8KVrWFHdL0Kd0zFdvm5i4wQfHVv5jlhzzC
	 GgGpDaZXB0TEtnCtbc3cmVruYKOe182KYFh1/W5401K29VMB/Eso6gjJPDSxw7iP6Q
	 yDoG0Fr+kDfP3oLLh03DTqHNF4yRLzzahP1hgJvOC0AukCFfck10DjfHUuPt513UCn
	 sJBLby32K7041Lu92hL8i4Dl/ZN9SZ9rDgEVUF7NuSs2C7tfbrTpaFywNkRyto0cKv
	 jJsfpneTspz5Sn3isDXvif+y1dzlXeNriIwJzgIWoVuMqWzwjDoRfceOXZEFnEaDEN
	 5ivzKhHV5O7jQ==
Date: Tue, 11 Nov 2025 12:01:19 +0900
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
To: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH][next] ocfs2: Avoid -Wflex-array-member-not-at-end warning
Message-ID: <aRKm_7aN7Smc3J5L@kspp>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

-Wflex-array-member-not-at-end was introduced in GCC-14, and we are
getting ready to enable it, globally.

Use the new TRAILING_OVERLAP() helper to fix the following warning:

fs/ocfs2/xattr.c:52:41: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]

This helper creates a union between a flexible-array member (FAM) and a
set of MEMBERS that would otherwise follow it.

This overlays the trailing MEMBER struct ocfs2_extent_rec er; onto the
FAM struct ocfs2_xattr_value_root::xr_list.l_recs[], while keeping the
FAM and the start of MEMBER aligned.

The static_assert() ensures this alignment remains, and it's
intentionally placed inmediately after the related structure --no
blank line in between.

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 fs/ocfs2/xattr.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index d70a20d29e3e..09069defd7e1 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -49,9 +49,13 @@
 #include "ocfs2_trace.h"
 
 struct ocfs2_xattr_def_value_root {
-	struct ocfs2_xattr_value_root	xv;
-	struct ocfs2_extent_rec		er;
+	/* Must be last as it ends in a flexible-array member. */
+	TRAILING_OVERLAP(struct ocfs2_xattr_value_root, xv, xr_list.l_recs,
+		struct ocfs2_extent_rec		er;
+	);
 };
+static_assert(offsetof(struct ocfs2_xattr_def_value_root, xv.xr_list.l_recs) ==
+	      offsetof(struct ocfs2_xattr_def_value_root, er));
 
 struct ocfs2_xattr_bucket {
 	/* The inode these xattrs are associated with */
-- 
2.43.0

