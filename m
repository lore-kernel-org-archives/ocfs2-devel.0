Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69BB042E417
	for <ocfs2-devel@lists.linux.dev>; Fri,  2 Oct 2026 19:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790970499; cv=none; b=eRMyp4U2jU1lxjzef8FkKRDdCH817Q1UCQiU3kMo2KYopXtcWz8Ik26zx2cU4iOCy3JWXc5AHZ+RHz/XDCCGamb9dCIROcqesEVx9evXY0daZCm+hL0J0JIMft6fJEKpyM13mIaMf/Jlfg1L0/v0Ca4V1wDk7/NeOiNljYFheOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790970499; c=relaxed/simple;
	bh=kp3aRPj0yrJneSRrwqt3a3WCuPfKKaOvNaPQ5Y5IZvs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uXkCtJ64qZE6ikz4KIraYF1TTdZxulBhJWRn3peNTQ9WANiLg0umPaHMUgUfQLXjX0nvDbYXQOZc8UTL5nXZMNyV3WcqmQ3X0XedNelL9laHQqKyIO+MYYzLWPPbGvhceKfarowx3iVuURgC30i5pmxPpNSDSNAraBIWojGKAbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=GxHVHAvu; arc=none smtp.client-ip=74.125.82.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="GxHVHAvu"
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-34bb8b31647so410446eec.0
        for <ocfs2-devel@lists.linux.dev>; Fri, 02 Oct 2026 12:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1790970493; x=1791575293; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZPRt5eKpQYZLRacEDFzRrkBIy6qGtNsmMHZIyJ1pN3M=;
        b=GxHVHAvuvwdZPpJbcFg2WbwEStpzJGI/ZFPHishqkepXm5TimyJZWDEeDN+wSyERQR
         lrdSxieMqXigmrs9h3AGEokyG/JxTwyXcXqgnHzvei/ihabC5RQLqjUKxBCW6CWS3OF/
         lhzuufluLR+TvpwVwggoSEb3S0WpAexp5MhPnEcypzpEI6+Pewgu/cSB9JosMeVfdwQM
         vr+k2I5FcpUsGkHugzFb7GYIH8LFMlTVyzjwdBbdE2LljApDmvsXHI+u+hRYBSJTeXf+
         g8irnPQ6QEqbPe+yPiy2CDM+C+MQw1tlRM8Au58yAr08BXHmY9pcLxeqV6MnAylBMxAY
         a2Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790970493; x=1791575293;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZPRt5eKpQYZLRacEDFzRrkBIy6qGtNsmMHZIyJ1pN3M=;
        b=sLmOBeekVj7TUYyKLAh5xATGQItBSeqUom5Gk2vePPLKFRvL8RP7pHY0rFL6fwDlep
         eGg5Nli3utZc3Tvc4GwgIWGlZvvOF22RuiJ09EcX+JzihRxu9obBZThJkp1DDfG0Q4Cd
         l9kuJ+LJvYqw1CmyhEW4dzfSJcTfSnS6JMjhlLqxiA3Hy19/19ajkM4i4KtRwQ3lsASs
         2aF2lFSzMqNk3I5iR0PZS/FE0IbtcaAEJfTpp8V1bT1wdhVYqtDBxyLF1Vfzg8XAcypf
         EbDeNqsv69KV3qMSfkpWtk7MfjrBQA+M45MdwpmVRodU1/4VViRO0wh6GgbGdat339jh
         xpMg==
X-Forwarded-Encrypted: i=1; AKwUvBzN6XPi7DRuMKkZ43/vKid7mW3IRx8yAJyhVoX6R94mU5hhjTxAf8KsnXtx3fHgWKMKICD3vA+y5iILBQ==@lists.linux.dev
X-Gm-Message-State: AFuF++kBSJPfG8G+JJfgVYSjqB8N5GZeyEwQDPx+KgeUmFju7KTtHaI+
	D0w/0Ui402eKMLSKCjegWqr7tFG9EDoVk7fQseOc/KHN3aUF+wX++tDuD/VZRmIGDqA=
X-Gm-Gg: AYBFou0Zse7jUjvRT06N4EzFd7QI8G08NjAI8awK6lC0YAXuFthFjskrvhqNbrgq7vH
	qH2LdrlA48/G/hizkE96FsJP4yuFzDWK78kL60cSz0s0LGSqVu69BjID6zgyplhaSkxh96A6GqS
	5YjiY8F6G+VL6RFHxUhjKbK9W77dC17S3o0mXfVW+qdEZDi2DbmVkyQ30yOIU0lTGhm580BFqAX
	4/L6e+5WUkhwossz56OIGSuPHlsZiZ7erRpiQSdWpjknbWHRdeiO5OTjPl+y/Ya/qaOLIIorphs
	kay1dHjR6X+4qYI5pavNH1DRKEFiXSC9EBA8uiMV3nfrF7XwwGbCb9MBAXk8I17AEKqxoyZrFd9
	zlTmZC8RcwL/e7gNS9MoCRm/nIwCKRfu/FtZtrvMMeLegZwJ8U/xyaiiVBQqTzXDoAQm5rHXUzr
	ZZ1xSZimjUIN/WlaIoQmV/ZaMc/2AVjzDVqwCortExf3zdZrfuPp2vEhrxjYpctw/CFG5ZXaNcM
	0NCfw+NComx6YP3oyS4CkzAByEg+iADPFEaQz18hENZ4mCFEP7GkL3yhrOHDPScayyVA6R7
X-Received: by 2002:a05:701b:221c:b0:14a:8cff:fbb8 with SMTP id a92af1059eb24-151c38b1453mr554659c88.28.1790970492218;
        Fri, 02 Oct 2026 12:48:12 -0700 (PDT)
Received: from localhost.localdomain ([2603:8001:5f01:8bab:bcf9:6140:24a9:d1e7])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34f14f97a5fsm12698196eec.15.2026.10.02.12.48.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 02 Oct 2026 12:48:11 -0700 (PDT)
From: Artem Dinaburg <artem@trailofbits.com>
To: stable@vger.kernel.org
Cc: Artem Dinaburg <artem@trailofbits.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Heming Zhao <heming.zhao@suse.com>
Subject: [PATCH 6.1.y] ocfs2: Avoid touching renamed directory if parent does not change
Date: Fri,  2 Oct 2026 15:48:06 -0400
Message-ID: <20261002194807.21118-1-artem@trailofbits.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jan Kara <jack@suse.cz>

[ Upstream commit 9d618d19b29c2943527e3a43da0a35aea91062fc ]

The VFS will not be locking moved directory if its parent does not
change. Change ocfs2 rename code to avoid touching renamed directory if
its parent does not change as without locking that can corrupt the
filesystem.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
---
Hi Greg, Sasha, and fs ocfs2 maintainers,

I am working through the small CVE backports still missing from 6.1.y.
This one addresses CVE-2023-52590. It avoids updating a renamed directory
without the VFS lock when its parent is unchanged.

The corresponding 6.6.y backport is already in the 6.6.y stable queue.
The fix is already present in 6.12.y, 6.18.y, and 7.2.y, but not
in 6.1.y.
The code change is identical to upstream.

Could you please queue it for 6.1.y?

CVE: CVE-2023-52590
Upstream: 9d618d19b29c2943527e3a43da0a35aea91062fc

AI assistance: An LLM helped identify, adapt, and validate this backport; I
reviewed the resulting code and validation evidence.

Thanks,
Artem Dinaburg

 fs/ocfs2/namei.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index c97c6fdb8cec23..a4804694cf1fd5 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -1345,7 +1345,7 @@ static int ocfs2_rename(struct user_namespace *mnt_userns,
 		goto bail;
 	}
 
-	if (S_ISDIR(old_inode->i_mode)) {
+	if (S_ISDIR(old_inode->i_mode) && new_dir != old_dir) {
 		u64 old_inode_parent;
 
 		update_dot_dot = 1;
@@ -1362,8 +1362,7 @@ static int ocfs2_rename(struct user_namespace *mnt_userns,
 			goto bail;
 		}
 
-		if (!new_inode && new_dir != old_dir &&
-		    new_dir->i_nlink >= ocfs2_link_max(osb)) {
+		if (!new_inode && new_dir->i_nlink >= ocfs2_link_max(osb)) {
 			status = -EMLINK;
 			goto bail;
 		}
@@ -1606,6 +1605,9 @@ static int ocfs2_rename(struct user_namespace *mnt_userns,
 	if (update_dot_dot) {
 		status = ocfs2_update_entry(old_inode, handle,
 					    &old_inode_dot_dot_res, new_dir);
+	}
+
+	if (S_ISDIR(old_inode->i_mode)) {
 		drop_nlink(old_dir);
 		if (new_inode) {
 			drop_nlink(new_inode);
-- 
2.39.5

