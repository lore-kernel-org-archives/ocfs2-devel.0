Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E124E50A6
	for <ocfs2-devel@lists.linux.dev>; Thu, 17 Sep 2026 04:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789619524; cv=none; b=CSuXBaguZKTA+U1DkKIgwgA8nPa+B2LgWT43NnblZSMH3/Mgnyrx4hW1MagPMtszM6rlSK9KkX7OIlJF2UEZwr6tiohKceLJucmLCgBbWa+OkyErXBkFzTHJTJWRK43lOhvv7Gj+keskVhevtEsB+JL6HJ1YLlLmfFh+61qHt5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789619524; c=relaxed/simple;
	bh=3NEYcgD2T/N8d8i3kHKxDZyeYcSCMgggu+3s6ZWAwnU=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=Tom/HKpjJRJHyhNqUZJfilEkvuWeEiJe3EXp/NTt3t63pzZo/bQEFIvudOJFeeniYycPXt7vdEHpHBgj31snqG6YhuE8lIVdceR9OZQhmldrAEqufc2R6QuqVCzUiSnkiGntupioo/GNqqk69ySqv1cf87SVVdYCN/kAPfopWDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jKKw5cE8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jKKw5cE8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A79C1F000FF;
	Thu, 17 Sep 2026 04:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789619522;
	bh=pkmJlAtF/dMHGyfTroUFjxsBHgFL49ATZw117w394xk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=jKKw5cE873mS2CviFj5ve4gPBx7uFKcjlCP5qE7+dosD9gfzzEFVu/EDgny+cgoLJ
	 2wDGpSiW6G9hKdk0ypztbuIm0pj5/7OPN3la5/uVfJWTNKwS5V+xIcvLEx8uk/YwK6
	 B/musbrq7bMclecJxWFyZzWvro8eL8E2D7FNCWKc=
Date: Wed, 16 Sep 2026 21:32:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Su Yue <glass.su@suse.com>
Cc: ocfs2-devel@lists.linux.dev, joseph.qi@linux.alibaba.com,
 heming.zhao@suse.com
Subject: Re: [PATCH v2] ocfs2: update xattr count before moving bucket
 entries
Message-Id: <20260916213201.d2e5b8fe5094c8d49244c8fe@linux-foundation.org>
In-Reply-To: <20260916024750.9450-1-glass.su@suse.com>
References: <20260916024750.9450-1-glass.su@suse.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 16 Sep 2026 10:47:50 +0800 Su Yue <glass.su@suse.com> wrote:

> Since commit 2f26f58df041 ("ocfs2: annotate flexible array members
> with __counted_by_le()"), the xh_entries array is annotated with
> __counted_by_le(xh_count), so FORTIFY uses xh_count to determine its
> bounds. When inserting an entry into a bucket, ocfs2_xa_bucket_add_entry()
> shifts existing entries before incrementing xh_count.
> The destination therefore extends one entry past the bounds described
> by the old count.
> 
> With CONFIG_CC_HAS_COUNTED_BY and CONFIG_FORTIFY_SOURCE enabled,
> ocfs2-test: single_run-WIP.sh -t reflink triggers the following failure
> while adding an extended attribute:
> 
> [  150.156484] memmove: detected buffer overflow: 352 byte write of buffer size 336
> [  150.156487] WARNING: lib/string_helpers.c:1036 at __fortify_report+0x3d/0x50, CPU#15: reflink_test/2336
> [  150.160496] RIP: 0010:__fortify_report+0x40/0x50
> [  150.164031] Call Trace:
> [  150.164141]  <TASK>
> [  150.164232]  __fortify_panic+0x9/0xb
> [  150.164383]  ocfs2_xa_bucket_add_entry.cold+0x17/0x28 [ocfs2]
> [  150.164661]  ocfs2_xa_set+0x8fb/0xf40 [ocfs2]
> 
> Increment xh_count before memmove() so the destination bounds include
> the new entry. Keep the local count unchanged to calculate the insertion
> position and move length from the original number of entries. The caller
> has already checked that there is enough space for the new entry.
> 

Thanks, I added

Fixes: 2f26f58df041 ("ocfs2: annotate flexible array members with __counted_by_le()")
Cc: <stable@vger.kernel.org>

to this, which I assume is appropriate.
