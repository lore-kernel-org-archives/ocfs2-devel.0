Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7302874E6;
	Wed, 16 Sep 2026 01:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789520844; cv=none; b=R+IrV+C1caeFm6mL3FV9f/rvFXFcS86NcLm0bsdOYvHWShC4ckct8phz9zqnD4UTK4gvDLU+VcoJNlNXrOuVvYxhOeYMclW8IJzAl43AL1XK3f0RVV4rdO8LzTqa+hxNGvVTazR9H1mlO9wKTA1k4Mhndy4X9jByLtOso9epVdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789520844; c=relaxed/simple;
	bh=2bDaLvokrw5PalTlJ0DxkspfkFvNbvj9si4zl6W0dJ4=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=IvxAL9vwLNlmV4udabU10ophks6NH59a+67cuF2EQvYe3/rUsE5nsNPef5HduuL3zFRRQQq3YOrD1wOGlxUOFAea0hJ82nGbNJDXxPA3dcwTOHyee39ZogLlfpkZDTG4nChw9M2M1/en9jWtNp3Bt7FQenae/hBVQ5XealZxd4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PqTnLRle; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PqTnLRle"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F216A1F000FF;
	Wed, 16 Sep 2026 01:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789520842;
	bh=F8rLOmaDy5Alst+sW5lGwCSqiKIKXBBJqz4YrzC1das=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=PqTnLRlecmpF316WnrJbPFPJVncRksSE0lygGK2wmbjcEmAiGdrxvsZQkSuvDzR4m
	 nft97ovIi9DUe6j+Yz9UEVEGRp7TwUX3Ie6270fH1/Rl8LoWNO61fAYG3KY8tJJDwY
	 g3V+oVe9ElFwHIgnt2NiJd3Z1dsrk4QgHS/459+w=
Date: Tue, 15 Sep 2026 18:07:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiaming Zhang <r772577952@gmail.com>
Cc: jlbec@evilplan.org, joseph.qi@linux.alibaba.com, mark@fasheh.com,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 syzkaller@googlegroups.com, stable@vger.kernel.org
Subject: Re: [PATCH] ocfs2: fix chunk number of the first chunk in a local
 quota file
Message-Id: <20260915180721.1914e74dc8da69e58399d7a6@linux-foundation.org>
In-Reply-To: <20260914034940.4070970-1-r772577952@gmail.com>
References: <CANypQFZ05tpth0Xc33gmP6jgPnkY4VuezyHcsajV-SqCsmN_gg@mail.gmail.com>
	<20260914034940.4070970-1-r772577952@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 14 Sep 2026 11:49:40 +0800 Jiaming Zhang <r772577952@gmail.com> wrote:

> The local quota file in OCFS2 is divided into chunks, and each chunk
> begins with a header block holding a bitmap of the quota entries that
> chunk has handed out.  Chunks are numbered from zero, and that number is
> used to convert the file offset of an entry back into a bit position in
> the bitmap. ocfs2_local_quota_add_chunk() appends a new chunk to the
> in-memory list and numbers it one past the chunk that was last:
> 
> 	list_add_tail(&chunk->qc_chunk, &oinfo->dqi_chunk);
> 	chunk->qc_num = list_entry(chunk->qc_chunk.prev,
> 				   struct ocfs2_quota_chunk,
> 				   qc_chunk)->qc_num + 1;
> 
> The predecessor is looked up after the new chunk is added to the list,
> so if the list was empty, the prev pointer is the list head itself.  The
> head is the dqi_chunk member of struct ocfs2_mem_dqinfo and is not a
> chunk, so reading qc_num through it lands 16 bytes past the start of the
> head, on the dqi_gqinode pointer that follows it.  The first chunk of
> the file is then numbered with the lower half of a kernel pointer
> instead of 0.
> 
> The list is empty when the local quota file header claims the file has
> no chunks.  ocfs2_local_read_info() takes dqi_chunks from that header
> without validating it, so an image with dqi_chunks == 0 takes this path
> when the first quota entry is allocated.
> 
> ocfs2_create_local_dquot() turns the bad number into a file offset with
> ol_dqblk_off(), which shifts a 32-bit block number left by the block
> size bits, so the top bits of such a large block number are lost.
> ocfs2_local_release_dquot() turns the offset back into a bit index with
> ol_dqblk_chunk_off(), using the full chunk number, so the lost bits push
> that index far outside the bitmap, and clearing it corrupts unrelated
> memory.
> 
> Compute the chunk number before putting the chunk on the list, and use 0
> when the list is empty.

Thanks.

What's missing here is any description of how the fix affects our
users.  And that's really really important.

> Fixes: 9e33d69f553a ("ocfs2: Implementation of local and global quota file handling")
> Closes: https://lore.kernel.org/lkml/CANypQFZ05tpth0Xc33gmP6jgPnkY4VuezyHcsajV-SqCsmN_gg@mail.gmail.com/
> Cc: stable@vger.kernel.org

Especially when proposing a -stable backport.

I see from your KASAN report
(https://lore.kernel.org/CANypQFZ05tpth0Xc33gmP6jgPnkY4VuezyHcsajV-SqCsmN_gg@mail.gmail.com)
that there's a use-after-free.  But even that wasn't revealed in your
proposed changelog!

So.

When fixing a bug please always describe the userspace-visible effects
of that bug.

Describe whether there's a know reproducer.  Tell us whether it's some
LLM-found-this theoretical thing or whether it's affecting you in the
real world.

I and all the people downstream from me (Linus, -stable, LTS, distros,
android, hyperscalars, everyone else) all will want to know these
things and I'd like you to provide them.

> Assisted-by: Claude Code:claude-opus-5

Great.  Please add prompts to Claude to ensure that all the info I'm
asking for is included in your changelogs going forward.  Then share
these prompts across your organization.

> --- a/fs/ocfs2/quota_local.c
> +++ b/fs/ocfs2/quota_local.c
> @@ -1071,10 +1071,13 @@ static struct ocfs2_quota_chunk *ocfs2_local_quota_add_chunk(
>  		goto out;
>  	}
>  
> +	if (list_empty(&oinfo->dqi_chunk))
> +		chunk->qc_num = 0;
> +	else
> +		chunk->qc_num = list_entry(oinfo->dqi_chunk.prev,
> +					   struct ocfs2_quota_chunk,
> +					   qc_chunk)->qc_num + 1;
>  	list_add_tail(&chunk->qc_chunk, &oinfo->dqi_chunk);
> -	chunk->qc_num = list_entry(chunk->qc_chunk.prev,
> -				   struct ocfs2_quota_chunk,
> -				   qc_chunk)->qc_num + 1;
>  	chunk->qc_headerbh = bh;
>  	*offset = 0;
>  	return chunk;

whew.  Applied.

I'll retain the cc:stable for now, but I don't know why.

