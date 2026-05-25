Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E9E26E6F3
	for <ocfs2-devel@lists.linux.dev>; Mon, 25 May 2026 20:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779740383; cv=none; b=LlYlNHWHxnhxl+e2MFtUHfxIkVVqLyvLvNK+X7f+TKgkzOgr5ZvD2JCYocK6r88MlevOO7QimaVnKdBHXqE2SfigzYyq9WOxN/RjZofbCMH9TGq7d6PZ8IWQvlHYtsbwyPhysReKS61BUckw97egaHJTpZf4T0j0f4CQr8m6oos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779740383; c=relaxed/simple;
	bh=qwiXIvhCiT7tndNwe+0F+dj1oWOl6U7QsUq7KV/MfBk=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=CDAeRvB8CjqXnGnTUSHEu5ViwlP8YNwBpF7LZvRQrSXYxlsRRJh4NVPpV+kA7qWucBbIu1rtkmtN9FgDP3/PskR2TGgzHfkq2jvzC8P8XLPsbgmTDkktbiuDEjNVawzEsVbGZaNpb8KvdBOgVAWAnSQTc4PJY7ReJRD4dlR7laY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Pw5ZXcdB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Pw5ZXcdB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC221F000E9;
	Mon, 25 May 2026 20:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779740382;
	bh=zAsTgrDqX97wWNwv+D82EzYEw+coM7LuQWBcgnIc0yo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Pw5ZXcdBd90pKY/v6HrD+Yt1k9Vf9IlAh+JN2TvmyChNWMQYGobxwVjpjLgwAZuDa
	 wdnaXZ+UrxE1hHv4HLq5oWVbK1zxTnsiHkbWtMBIpTNQ9Ppw9+k5AAlnX33qqK2cWx
	 LZyXvdixtNeTlmR1XxpfH+UmNHIzdqESjG+bfhcA=
Date: Mon, 25 May 2026 13:19:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Zhang Cen <rollkingzzc@gmail.com>, ocfs2-devel@lists.linux.dev,
 zerocling0077@gmail.com, 2045gemini@gmail.com, Mark Fasheh
 <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
Subject: Re: [PATCH] ocfs2: reject oversized group bitmap descriptors
Message-Id: <20260525131941.479295e62c0b3a4d598a495c@linux-foundation.org>
In-Reply-To: <cb815654-3702-4aa6-a43e-8a2215e66314@linux.alibaba.com>
References: <20260524111248.1429884-1-rollkingzzc@gmail.com>
	<cb815654-3702-4aa6-a43e-8a2215e66314@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 25 May 2026 11:49:45 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:

> > +	suballocator = le64_to_cpu(di->i_blkno) != OCFS2_SB(sb)->bitmap_blkno;
> 
> This seems can use !ocfs2_is_cluster_bitmap() helper instead.
> 

Thanks.  So I'll await a v3 and shall take no action at this time?
