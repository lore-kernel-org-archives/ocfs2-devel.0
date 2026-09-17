Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D211448E0;
	Thu, 17 Sep 2026 04:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789619016; cv=none; b=CRpmVUEogZXi7dpuU1X0b+79R4IFa9JNjCWGes8z4zlRogMLBVcUYUddlh8PNgXoYDcRDdmimgqdmdvvc7fRskWD+jhF2HLOveAxl8JPQ6+QUJWmt1KX26y9VD1ZhEqWsgdQjarqz6WLSi83A71khnQWnhaRTNE5EN6D7urNxs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789619016; c=relaxed/simple;
	bh=qdxkTLD9uoCFIhxrWKxe+s5FfwMI+0AafQ4TgFMyO8c=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=SJ2C48wDGDeniqHYoPjiATspWxRMl2wal+FjHmv1j4wqEdlslokMLPWd+I1+iJ47Bz+06X7Zo1f6ASYaKQhfUrvssIR/jp2RvC2qz8/x4FOxatzt8qYxq4/xwAc9YxePpKMp4PJd48UFte0Wgi3kLDoW/rKoMuiszcEBmn1URkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZH7Y94zI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZH7Y94zI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61181F000FF;
	Thu, 17 Sep 2026 04:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789619015;
	bh=rd16Z3y1fpySyhEkogFEnRO8utyQhjZLXwvtXuG7Bp0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ZH7Y94zI/yrzYEtQjEX0axYEYvUsl6B97k2rWU/E/DLg/Fw043lmuu+9DG5fW0A/M
	 2IUe7l3rhkdbsXxsyTk9Layg3wj6ZaD0hL3ai28AQsK91sgLdBUJz0sZVr2vkUAUu8
	 5ICVj4dd6pparLZXuQ+cWYpty/rTUSkw+V4IXCy4=
Date: Wed, 16 Sep 2026 21:23:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiaming Zhang <r772577952@gmail.com>
Cc: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, mark@fasheh.com,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 syzkaller@googlegroups.com, stable@vger.kernel.org
Subject: Re: [PATCH] ocfs2: fix chunk number of the first chunk in a local
 quota file
Message-Id: <20260916212334.033cfa1f0113f3614ef7baa9@linux-foundation.org>
In-Reply-To: <CANypQFZMpExoykmy8kM=G5yYN0hJvuHmw0hVMKDvzZ7-qX6ang@mail.gmail.com>
References: <CANypQFZ05tpth0Xc33gmP6jgPnkY4VuezyHcsajV-SqCsmN_gg@mail.gmail.com>
	<20260914034940.4070970-1-r772577952@gmail.com>
	<20260915180721.1914e74dc8da69e58399d7a6@linux-foundation.org>
	<CANypQFZMpExoykmy8kM=G5yYN0hJvuHmw0hVMKDvzZ7-qX6ang@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 16 Sep 2026 12:58:22 +0800 Jiaming Zhang <r772577952@gmail.com> wrote:

> > When fixing a bug please always describe the userspace-visible effects
> > of that bug.
> 
> Mounting a crafted OCFS2 image can corrupt kernel memory.  When the
> local quota file header of such an image claims zero chunks, the first
> quota entry allocated during the mount gets a chunk number taken from
> a kernel pointer, and releasing that entry clears a bit far outside
> the chunk bitmap.

Great, thanks.  I did some lazy pasting into the changelog and came up
with the below.

I see that cc:stable is well justified!


From: Jiaming Zhang <r772577952@gmail.com>
Subject: ocfs2: fix chunk number of the first chunk in a local quota file
Date: Mon, 14 Sep 2026 11:49:40 +0800

Mounting a crafted OCFS2 image can corrupt kernel memory.  When the
local quota file header of such an image claims zero chunks, the first
quota entry allocated during the mount gets a chunk number taken from a
kernel pointer, and releasing that entry clears a bit far outside the
chunk bitmap.

The write will corrupt the data stored at that address, and the
corruption may lead to a system crash or damage unrelated data. 
Mounting requires CAP_SYS_ADMIN, so it takes an untrusted image, such
as removable media or a loop mount of a file from elsewhere.

Since the chunk number comes from a kernel pointer, the address of the
bit that gets cleared differs from boot to boot, and the issue has been
reported under several titles:

- BUG: unable to handle kernel paging request in ocfs2_local_release_dquot
- KASAN: use-after-free Write in ocfs2_local_release_dquot
- KASAN: slab-out-of-bounds Write in ocfs2_local_release_dquot
- KASAN: slab-use-after-free Write in ocfs2_local_release_dquot
- KFENCE: use-after-free write in ocfs2_local_release_dquot

Note that none of these is a use-after-free in the quota code: the
chunk and its buffer head are alive.  The bit that gets cleared lies
far outside the bitmap.  KASAN and KFENCE name each report based on the
object occupying that address, which explains why the same issue is
reported under so many different titles.  In the report I sent, the
address fell in a free page, which KASAN labels use-after-free.

The local quota file in OCFS2 is divided into chunks, and each chunk
begins with a header block holding a bitmap of the quota entries that
chunk has handed out.  Chunks are numbered from zero, and that number is
used to convert the file offset of an entry back into a bit position in
the bitmap.  ocfs2_local_quota_add_chunk() appends a new chunk to the
in-memory list and numbers it one past the chunk that was last:

	list_add_tail(&chunk->qc_chunk, &oinfo->dqi_chunk);
	chunk->qc_num = list_entry(chunk->qc_chunk.prev,
				   struct ocfs2_quota_chunk,
				   qc_chunk)->qc_num + 1;

The predecessor is looked up after the new chunk is added to the list, so
if the list was empty, the prev pointer is the list head itself.  The head
is the dqi_chunk member of struct ocfs2_mem_dqinfo and is not a chunk, so
reading qc_num through it lands 16 bytes past the start of the head, on
the dqi_gqinode pointer that follows it.  The first chunk of the file is
then numbered with the lower half of a kernel pointer instead of 0.

The list is empty when the local quota file header claims the file has no
chunks.  ocfs2_local_read_info() takes dqi_chunks from that header without
validating it, so an image with dqi_chunks == 0 takes this path when the
first quota entry is allocated.

ocfs2_create_local_dquot() turns the bad number into a file offset with
ol_dqblk_off(), which shifts a 32-bit block number left by the block size
bits, so the top bits of such a large block number are lost. 
ocfs2_local_release_dquot() turns the offset back into a bit index with
ol_dqblk_chunk_off(), using the full chunk number, so the lost bits push
that index far outside the bitmap, and clearing it corrupts unrelated
memory.

Compute the chunk number before putting the chunk on the list, and use 0
when the list is empty.

Link: https://lore.kernel.org/20260914034940.4070970-1-r772577952@gmail.com
Fixes: 9e33d69f553a ("ocfs2: Implementation of local and global quota file handling")
Signed-off-by: Jiaming Zhang <r772577952@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://lore.kernel.org/lkml/CANypQFZ05tpth0Xc33gmP6jgPnkY4VuezyHcsajV-SqCsmN_gg@mail.gmail.com/
Assisted-by: Claude Code:claude-opus-5
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
---

 fs/ocfs2/quota_local.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/fs/ocfs2/quota_local.c~ocfs2-fix-chunk-number-of-the-first-chunk-in-a-local-quota-file
+++ a/fs/ocfs2/quota_local.c
@@ -1071,10 +1071,13 @@ static struct ocfs2_quota_chunk *ocfs2_l
 		goto out;
 	}
 
+	if (list_empty(&oinfo->dqi_chunk))
+		chunk->qc_num = 0;
+	else
+		chunk->qc_num = list_entry(oinfo->dqi_chunk.prev,
+					   struct ocfs2_quota_chunk,
+					   qc_chunk)->qc_num + 1;
 	list_add_tail(&chunk->qc_chunk, &oinfo->dqi_chunk);
-	chunk->qc_num = list_entry(chunk->qc_chunk.prev,
-				   struct ocfs2_quota_chunk,
-				   qc_chunk)->qc_num + 1;
 	chunk->qc_headerbh = bh;
 	*offset = 0;
 	return chunk;
_

