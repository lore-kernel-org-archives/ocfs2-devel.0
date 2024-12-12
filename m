Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6871F0E57;
	Thu, 12 Dec 2024 11:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734003632; cv=none; b=ZHuPpmPfbm69PdsotlSLKMk7qvVRAy+BM2KvFkRtrToRjVliX5D+2pLXEsiaayZqJkDEJA7JX3dZsgeM7EMOBqwkfCzJut4/wg3qoCYJEdh0lQXpLTvZP8s53rSPWbHebH8ll4VzC62m8/IHxljR1Be4UdgBc7w+xox8SqPrvyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734003632; c=relaxed/simple;
	bh=U7AatVVT2oJtVGVlO2MLqwMnAJuz+xhJcPre01YmgKc=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=l4TzuIYmq/ifTTqzq/LPMfy4aTuNYmPzVM5oNxmXhF9TfWGAri8hHWYVz4emKnNl11VXLrY/keilNWnaUqy61byg7V835HaI37V5A/vaXCVvz+0dHuEyVytMgXdqzN/4DMeIzU6bds0ViVBd/sRSxqFVZ90g6d07fHp/4Uy7YNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E+JVwreK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E+JVwreK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B278BC4CED1;
	Thu, 12 Dec 2024 11:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734003632;
	bh=U7AatVVT2oJtVGVlO2MLqwMnAJuz+xhJcPre01YmgKc=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=E+JVwreK4G2J+EThjB+jueGyXDdJ2uKhDumtzqisW9KHg3QNrVp06PJKXRDAQGuwx
	 akanS2irYsFcXzAxdBF4KF6pwJVgCd6cRP7w4+G+7J0qGJch1Y9c7q3mhzzo90ihDB
	 siFGyyUeKcfugiuK+FAu8s8DMGJAmHaM2FlqHX3w=
Subject: Patch "ocfs2: Revert "ocfs2: fix the la space leak when unmounting an ocfs2 volume"" has been added to the 5.10-stable tree
To: gregkh@linuxfoundation.org,heming.zhao@suse.com,joseph.qi@linux.alibaba.com,ocfs2-devel@lists.linux.dev
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Thu, 12 Dec 2024 12:40:29 +0100
In-Reply-To: <20241212113107.9792-1-heming.zhao@suse.com>
Message-ID: <2024121229-finicky-sulfur-2a96@gregkh>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    ocfs2: Revert "ocfs2: fix the la space leak when unmounting an ocfs2 volume"

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ocfs2-revert-ocfs2-fix-the-la-space-leak-when-unmounting-an-ocfs2-volume.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From heming.zhao@suse.com  Thu Dec 12 12:39:14 2024
From: Heming Zhao <heming.zhao@suse.com>
Date: Thu, 12 Dec 2024 19:31:05 +0800
Subject: ocfs2: Revert "ocfs2: fix the la space leak when unmounting an ocfs2 volume"
To: joseph.qi@linux.alibaba.com, gregkh@linuxfoundation.org
Cc: Heming Zhao <heming.zhao@suse.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, ocfs2-devel@lists.linux.dev
Message-ID: <20241212113107.9792-1-heming.zhao@suse.com>

From: Heming Zhao <heming.zhao@suse.com>

This reverts commit dfe6c5692fb5 ("ocfs2: fix the la space leak when
unmounting an ocfs2 volume").

In commit dfe6c5692fb5, the commit log "This bug has existed since the
initial OCFS2 code." is wrong. The correct introduction commit is
30dd3478c3cd ("ocfs2: correctly use ocfs2_find_next_zero_bit()").

The influence of commit dfe6c5692fb5 is that it provides a correct
fix for the latest kernel. however, it shouldn't be pushed to stable
branches. Let's use this commit to revert all branches that include
dfe6c5692fb5 and use a new fix method to fix commit 30dd3478c3cd.

Fixes: dfe6c5692fb5 ("ocfs2: fix the la space leak when unmounting an ocfs2 volume")
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/localalloc.c |   19 -------------------
 1 file changed, 19 deletions(-)

--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -1010,25 +1010,6 @@ static int ocfs2_sync_local_to_main(stru
 		start = bit_off + 1;
 	}
 
-	/* clear the contiguous bits until the end boundary */
-	if (count) {
-		blkno = la_start_blk +
-			ocfs2_clusters_to_blocks(osb->sb,
-					start - count);
-
-		trace_ocfs2_sync_local_to_main_free(
-				count, start - count,
-				(unsigned long long)la_start_blk,
-				(unsigned long long)blkno);
-
-		status = ocfs2_release_clusters(handle,
-				main_bm_inode,
-				main_bm_bh, blkno,
-				count);
-		if (status < 0)
-			mlog_errno(status);
-	}
-
 bail:
 	if (status)
 		mlog_errno(status);


Patches currently in stable-queue which might be from heming.zhao@suse.com are

queue-5.10/ocfs2-revert-ocfs2-fix-the-la-space-leak-when-unmounting-an-ocfs2-volume.patch
