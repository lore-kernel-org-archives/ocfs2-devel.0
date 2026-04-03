Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E82367F46;
	Fri,  3 Apr 2026 19:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775244436; cv=none; b=NcAIMUoxsVH/cm0an8aonZVNWs+9uIZeqyY17CZQ2+/vBFgcRIVkbHW+GcbSbiK2laBZiDzCpGPjiuATDp9gP868h8zj6MMwc/6/37+gyRLSd38fbXyx8YeoQViKNN4s4eg6jXWzLeji6vDWbSP9KCROROxAKYWi8385Y6AFmm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775244436; c=relaxed/simple;
	bh=/u2CYTPrnvjsNdO3A4qWB3D4WAchJwyhzH4OJfpqH8Y=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=i3cm0a/tsL6UBqTlSjjlHVG2388fCoHSKZPurWdpapVH0nH4olYIXyOCsT6ynTErcnPxPlinImSXsBSvQ25/r6S7AakZK6pQ47jCW7H4BIkXGg51zp/gvVyXIW8RvDhlO18/5jgDZf5rm0qfZ8XfDjSqDT/gy7pVan6mLaADI2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hE4KIZZL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hE4KIZZL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 753C3C2BCB3;
	Fri,  3 Apr 2026 19:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775244435;
	bh=/u2CYTPrnvjsNdO3A4qWB3D4WAchJwyhzH4OJfpqH8Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hE4KIZZL7kSVvTat1S8sJPSdB7tX8O+muowrZsSAG12/smSqVobSOOwIbKKGHC3y/
	 DeKPv5/KiCCVN+SVwa5UZb4OL+WA8jx4yExn8uUvJImIjfvcWGWN3Q6tZ98nOoiy5R
	 +NqZcUV3izi9UXkRSxoN9VwnJq9r49olPt/WS2RY=
Date: Fri, 3 Apr 2026 12:27:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Heming Zhao <heming.zhao@suse.com>, ZhengYuan Huang
 <gality369@gmail.com>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] ocfs2: consolidate extent list validation into
 block read callbacks
Message-Id: <20260403122714.d01b268f8ac8148aaf55dc3c@linux-foundation.org>
In-Reply-To: <20260403090803.3860971-1-joseph.qi@linux.alibaba.com>
References: <20260403090803.3860971-1-joseph.qi@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri,  3 Apr 2026 17:07:59 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:

> ocfs2 validates extent list fields (l_count, l_next_free_rec) at various
> points during extent tree traversal. This is fragile because each caller
> must remember to check for corrupted on-disk data before using it.
> 
> This series moves those checks into the block read validation callbacks
> (ocfs2_validate_dx_root and ocfs2_validate_extent_block), so corrupted
> fields are caught early at block read time. Redundant post-read checks
> are then removed.

AI review asked a few questions - mainly suggesting additional changes.
https://sashiko.dev/#/patchset/20260403090803.3860971-1-joseph.qi@linux.alibaba.com
