Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53868395D8C;
	Mon, 18 May 2026 21:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779140423; cv=none; b=QJG2rL2guSvU4b67nWpKNTdY7FLxmi+8GGZnVWOxjXisoptZ0pTYjP509FYWyBHCT5X+K4R817U2ENC8qBNh//e/4SfgHM+vJZdg3n2wCNJ34LDUoi4Iu6uo7VdDUk+CRHUXrwh1XSiG6+p9DSwVDXICRIWoFVqvPvzJ2EHFgHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779140423; c=relaxed/simple;
	bh=qybiXIdg78xjCaPCX4qTy9N5tIC+Q8pFhyzLh/Ltlx4=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=MP/WP3m1IEBj5VeaZFbtDSKwbEYve30D7sAlOMXlUx0bSnKUgcAhrOGcudNxatY6s0yL1uyhBXwcej811oij98y2cQViYynGOiXZFQaqIUpoyirysLhTRRgHvdPRbuGseHRkDp07b3B5PGm9JYSP3k0AmKBwGowYlDvVbjsxM08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yVUrCj/8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yVUrCj/8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877C9C2BCB7;
	Mon, 18 May 2026 21:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779140422;
	bh=qybiXIdg78xjCaPCX4qTy9N5tIC+Q8pFhyzLh/Ltlx4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=yVUrCj/8v+rbc3HT7LJZAhOz54fg3IiJ3//sp6SJf8w9u2Getzn43fXlkrQFEGQG0
	 Q/oa6f/TRIYXMTWuRYZbcKXXeEF6c7mXXl8nCMDjGhBC65MYn+AJUOVZv7S8/dLVH2
	 eFzbX+O7IYZ6ZTgqPEWQzW+/M7QL/p696M/Q8SGY=
Date: Mon, 18 May 2026 14:40:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Bommarito <michael.bommarito@gmail.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, ZhengYuan Huang <gality369@gmail.com>,
 ocfs2-devel@lists.linux.dev, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] ocfs2: harden inode validators against forged
 metadata
Message-Id: <20260518144022.4d0d0056d304d5fd9607bc10@linux-foundation.org>
In-Reply-To: <20260517111015.3187935-1-michael.bommarito@gmail.com>
References: <20260517111015.3187935-1-michael.bommarito@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 17 May 2026 07:10:11 -0400 Michael Bommarito <michael.bommarito@gmail.com> wrote:

> 
> This series adds three structural checks to
> ocfs2_validate_inode_block() that catch attacker-controlled bytes
> in a freshly read dinode before ocfs2_populate_inode() copies them
> verbatim into the in-core inode.  All three checks fire on the
> mount, lookup, and read-after-cache-invalidation paths and reject
> the block with ocfs2_error(), the same error-propagation
> mechanism the existing suballoc-slot, inline-data, chain-list,
> and refcount checks use.

Thanks.  Sashiko review might have found a few issues:
	https://sashiko.dev/#/patchset/20260517111015.3187935-1-michael.bommarito@gmail.com
