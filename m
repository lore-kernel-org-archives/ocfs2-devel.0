Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9329513AD1C
	for <ocfs2-devel@lists.linux.dev>; Sun,  9 Nov 2025 05:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762665821; cv=none; b=COvN71FCpCeiz4yNq+iWGmfgndrBRzElrzTduNs/XHU0k88rS/Tz6eHJQodbrAShKenRd3P/ccFYdShZdqLPrB8X84GDvy40fNnI3/ecs8CszPVNFUoRkr1nAPMUlpr/zgmYU1+Y7K+O7N3nq13NiJcSTa3SeONR4mGnQ3Vus5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762665821; c=relaxed/simple;
	bh=6Bi9ZRKh4CY1k/II0P3/eE8a51bWszSse+15YayrXzQ=;
	h=Date:From:To:Subject:Message-Id:Mime-Version:Content-Type; b=D/HONHuU9Jt5WJcKC7uPdEzi/Hl+bW0wMUsLiFxVOMcM8LlMrnKO4L6n1QhbebRcW/BEHxoZj6e/m04pQe0zyGjnMFDWRjNOr1SqjRojNAfcgcear9o65WXXtzdvbf5hxheaD8oEAvLeuDyRXC9hZsOS6FkOD15nTCpAwOmaWQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c9YJOmF0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c9YJOmF0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED4FC4CEF8
	for <ocfs2-devel@lists.linux.dev>; Sun,  9 Nov 2025 05:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762665821;
	bh=6Bi9ZRKh4CY1k/II0P3/eE8a51bWszSse+15YayrXzQ=;
	h=Date:From:To:Subject:From;
	b=c9YJOmF0WsKr3Ltcm43vxTO5IsASIrbE2hoTvfUQqNQw2UQoMKVHnptVnLFA5trVp
	 C0zJriCEstjZNHxa8TQRhsDMgPm6SuND26lfViyPVK/cM+n6+sCwk5OACBsfcMWpmB
	 fQfsTOBNPLdJO4Sa4L4x9qK/1oovRmmygnIXnNL0=
Date: Sat, 8 Nov 2025 21:23:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: ocfs2-devel@lists.linux.dev
Subject: arm build error
Message-Id: <20251108212340.4c815638a2c231ef45873446@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Is anyone else seeing this?  Current mm.git, arm allmodconfig;


In file included from ./include/linux/string.h:382,
                 from ./include/linux/bitmap.h:13,
                 from ./include/linux/cpumask.h:12,
                 from ./include/linux/smp.h:13,
                 from ./include/linux/lockdep.h:14,
                 from ./include/linux/spinlock.h:63,
                 from ./include/linux/wait.h:9,
                 from ./include/linux/wait_bit.h:8,
                 from ./include/linux/fs.h:7,
                 from fs/ocfs2/xattr.c:13:
In function 'fortify_memset_chk',
    inlined from 'ocfs2_reflink_xattr_header' at fs/ocfs2/xattr.c:6365:5:
./include/linux/fortify-string.h:480:25: error: call to '__write_overflow_field' declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror=attribute-warning]
  480 |                         __write_overflow_field(p_size_field, size);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors

Callsite is

				memset(last, 0,
				       sizeof(struct ocfs2_xattr_entry));

