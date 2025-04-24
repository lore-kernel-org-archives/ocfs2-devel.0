Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DFF41EA84
	for <ocfs2-devel@lists.linux.dev>; Thu, 24 Apr 2025 22:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745533066; cv=none; b=XRZtIb9GXd6MhMltqJdcoZ7Nz47uskzWGYQPUWdbWG0QrHWzxAM+RvmDuNGednncgjh5Hd6s5Jgs0XEB5qd1jQgidekd8qu/++P+KW+IU4rJADw96oqKCuk6GRBUrrvvj7o2610xlQG57uS1PgpKvyC5omH4MD/z+PPfceGpdfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745533066; c=relaxed/simple;
	bh=GVjN+Z2/dk+bBrm0lOWi6lFSRPJFGjAj5rZkGCehDwc=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=uODawNf0o4mEJMlXW33J1z3GJES4UeHySYYTYLt1pzhbASnmvXYDpdKtayO8d9jldQmOlGHavTlBa3pKGQK8d2EmWCFNtgGv0CJErJO6YjP6UyzX9xqwUj2BF2zT8Q0uTVGJUn/BhfSxu7HStux44muXA1VT27Rg5CP4k26jnRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QK9PoX01; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QK9PoX01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1533C4CEE3;
	Thu, 24 Apr 2025 22:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745533065;
	bh=GVjN+Z2/dk+bBrm0lOWi6lFSRPJFGjAj5rZkGCehDwc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=QK9PoX01qR+hw2Q1UDADZvdSUCqrTtk/re3WAF24vatRy+LxWugAXGV2b3aZqgmcx
	 uwIQLW0DyNgnByeYnw4VJqyDJSF39WCWnh8uVM1A+ZC/B32wBZna1pI33FzcuASiOh
	 AH0kW+fLTR4kYTJK0+0SSigMAqJ95KFEQ81azZRM=
Date: Thu, 24 Apr 2025 15:17:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: ocfs2-devel@lists.linux.dev, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Heming Zhao <heming.zhao@suse.com>, Murad Masimov
 <m.masimov@mt-integration.ru>
Subject: Re: [PATCH v3 0/3] ocfs2: Fix deadlocks in quota recovery
Message-Id: <20250424151745.5a62839115508bcaf05f3dcc@linux-foundation.org>
In-Reply-To: <20250424134301.1392-1-jack@suse.cz>
References: <20250424134301.1392-1-jack@suse.cz>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 24 Apr 2025 15:45:10 +0200 Jan Kara <jack@suse.cz> wrote:

> this implements another approach to fixing quota recovery deadlocks. We avoid
> grabbing sb->s_umount semaphore from ocfs2_finish_quota_recovery() and instead
> stop quota recovery early in ocfs2_dismount_volume(). Andrew, patches seem
> to be ready. Can you please merge them? Thanks!

No probs.

Should these be backported into -stable?  I assume there's no
identifiable Fixes:.

