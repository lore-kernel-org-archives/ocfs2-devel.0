Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1BE47F785;
	Thu,  6 Aug 2026 20:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786048153; cv=none; b=Naapa/p45lyALNFw7oEFV1HbIFbC1U4L5yFfzIdfFQCMiJe5ns23IChbK1FCS+KjDzZgHt1uBaIIgbA7TlVUVf211yCn3xAZ6vSEVeVoLxsohdgVhbyezpyH9Gy4WTwnJWH5Cgne1z9dwNUr33EZr4ujffzPNBcU5KPK3JOmUTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786048153; c=relaxed/simple;
	bh=T0Kb1OhiOC5LxlLwSI2Oio2lJkjhUluHvIWLrscYpRs=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=QNUj/E3voPxUbqTONO+4X5F7FNstz//1zSqj8Lov8BR/3tWJ8LplgrDjpXl/VnuLQ6bwyAj2x7wGZarBHMrw/tt02+X9JPREdDk6JMp6BrcdsR4O0qSpemRDJCteET6tfNYcT9GFNTXhMV3/FGmkOmzXu01WjjKqf2g2O7/8di4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x+Df9oTh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x+Df9oTh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B69301F000E9;
	Thu,  6 Aug 2026 20:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786048152;
	bh=2ElkEzdzb1Sgo7VeskPG8NK1agAOU+QhlLl81GdDC6A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=x+Df9oThSVF1XxB0cksDwi92XqXu1yEzqQzD6scbeqEnJ6gYT7EZQiD/ObkQQSFPD
	 VYFoq4c4erkJPg+FECR6aZ07QcIvhmofNzOs7rIvE1RAiemos5GGt+u0ASMRfsRkgi
	 wYGV+FNWF5lxHXiruEghRHDhckih85idje7/euK4=
Date: Thu, 6 Aug 2026 13:29:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhan Xusheng <zhanxusheng1024@gmail.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 zhanxusheng@xiaomi.com
Subject: Re: [PATCH] ocfs2: bound-check dir entries in the readdir
 re-validation scan
Message-Id: <20260806132911.57ad21a8be14277f298f8a89@linux-foundation.org>
In-Reply-To: <20260806122133.956847-1-zhanxusheng@xiaomi.com>
References: <20260806122133.956847-1-zhanxusheng@xiaomi.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  6 Aug 2026 20:21:33 +0800 Zhan Xusheng <zhanxusheng1024@gmail.com> wrote:

> When the inode version changed since the last readdir(),
> ocfs2_dir_foreach_blk_el() re-scans the directory block from its start to
> relocate the current position:
> 
> 	for (i = 0; i < sb->s_blocksize && i < offset; ) {
> 		de = (struct ocfs2_dir_entry *)(bh->b_data + i);
> 		if (le16_to_cpu(de->rec_len) < OCFS2_DIR_REC_LEN(1))
> 			break;
> 		i += le16_to_cpu(de->rec_len);
> 	}
> 
> The loop dereferences de->rec_len (at byte offset 8 within the entry)
> guarded only by i < sb->s_blocksize.  `offset` is derived from ctx->pos,
> which userspace controls via lseek() on the directory fd, so i can reach
> the last bytes of the block; reading de->rec_len then reads a few bytes
> past the s_blocksize-sized block buffer (an out-of-bounds read).
> 
> The main emit loop below already guards this via ocfs2_check_dir_entry(),
> which rejects entries too close to the buffer end before touching de.
> Apply the same lower bound to the re-validation scan so that a full
> minimal directory entry is known to fit before de is dereferenced.  For a
> consistent directory this changes nothing: entries are at least
> OCFS2_DIR_REC_LEN(1) bytes, so no valid entry starts in the excluded tail.
> 
> Found by the sashiko review tool; fix approach suggested by Joseph Qi.

Thanks.

When fixing a bug, please always describe the userspace-visible runtime
effects of that bug.

> Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> Fixes: ccd979bdbce9 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
> Cc: stable@vger.kernel.org

Especially when proposing a backport.

I asked Gemini "what are the userspace-visible effects of this bug"
then pasted in your email.  The answer was, basically, "there aren't any".

	https://share.gemini.google/FiBJNo4qIz7J

So I don't believe that a cc:stable is justified,
Documentation/process/stable-kernel-rules.rst says "it must fix a real
bug that bothers people".

So if maintainers are agreeable I think I'll remove that cc:stable. 
But I think the -stable maintainers will go and backport it anyway
because of the Fixes: (thereby breaking their own rules ;)).  We can
stop that happening by removing the Fixes: also.

> Link: https://sashiko.dev/#/patchset/20260806022044.167962-1-zhanxusheng@xiaomi.com

Your patch prompted Sashiko to complain about more pre-existing things:

	https://sashiko.dev/#/patchset/20260806122133.956847-1-zhanxusheng@xiaomi.com

Anyway, I'll queue this one and shall await maintainer input.
