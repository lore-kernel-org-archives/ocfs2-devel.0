Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF2615AC7;
	Wed, 20 Dec 2023 05:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="RVKU61um"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZHgu0AQ/45c1KhOXk4b/ywGXu8x5KY6GeTbYpQi4v/E=; b=RVKU61um3Adbdte+S06pAz6h57
	DWPdD4bODQ3cG/0V0l5INNZiU3oanM1z5gsIMc+bty+VDsZEG5jBC1UZwvPOCRQDphNyCFR6T8C/A
	41SpBERtJoxAmpRYrdbQxdXt6+47OjT5sMvIUg7xc4E4dJklT0tLKRXrKtu3wjh8Y+ucH5P2pD+7W
	31SG0CjHDSenwD6VT4JahkyvKu1NSj5oEoGzA003oc2kGoenCpdfHCAizxSmrkeO8vamZIUEVQUqO
	WBN7314J0Ma00qqgNJ1QLGIFcFUUrNT2Wc9nTmSTSVJu2usV88MdiMKDj4bQLQxyM4qzAyAJllbHB
	TrDgeJ7g==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rFpAd-00HJaz-0F;
	Wed, 20 Dec 2023 05:31:03 +0000
Date: Wed, 20 Dec 2023 05:31:03 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: ocfs2-devel@lists.linux.dev
Subject: [PATCH 19/22] ocfs2_find_match(): there's no such thing as NULL or
 negative ->d_parent
Message-ID: <20231220053103.GR1674809@ZenIV>
References: <20231220051348.GY1674809@ZenIV>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231220051348.GY1674809@ZenIV>
Sender: Al Viro <viro@ftp.linux.org.uk>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/ocfs2/dcache.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
index 04fc8344063a..a9b8688aaf30 100644
--- a/fs/ocfs2/dcache.c
+++ b/fs/ocfs2/dcache.c
@@ -124,17 +124,10 @@ static int ocfs2_match_dentry(struct dentry *dentry,
 	if (!dentry->d_fsdata)
 		return 0;
 
-	if (!dentry->d_parent)
-		return 0;
-
 	if (skip_unhashed && d_unhashed(dentry))
 		return 0;
 
 	parent = d_inode(dentry->d_parent);
-	/* Negative parent dentry? */
-	if (!parent)
-		return 0;
-
 	/* Name is in a different directory. */
 	if (OCFS2_I(parent)->ip_blkno != parent_blkno)
 		return 0;
-- 
2.39.2

