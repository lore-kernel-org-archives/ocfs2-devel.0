Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF232701D9;
	Thu, 27 Aug 2026 02:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787796875; cv=none; b=scnwrdOgsym7QjHgmDHtp9eu/91bi2C0rdjpr4bxWNxSyZUWIIh02hT26hcbrSeUMg8r4QY7W9EwG8LVdSrb8ELVKBB9obwTdx11rfDXZPBbSHU4rxOYIuEov1hKoxYud8Qb83FXwf9Z2lQUGXurbz/84SbQSmPgDmQ0REceMDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787796875; c=relaxed/simple;
	bh=EMz3CLlSruM1oLo6SYgpHfz8DCXHc0BUFVA833NUF/A=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=T9HWjGnGJqYTn5TT6dKW0ABUqFnmVAvxDnbhPNw6eU7caZvQ0Lobukb7720jPVlWk8w3dLoRq6fuk8Ed69NrfDx9tJgLdHcMRrBzu7iMPpKH7gdyOV6m2vuh3bdAvpJhT5F+Y6Y2QEQX2gHSfwpBGiwEozoLLUdUOeRj8eqOKFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iYs8oDAK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iYs8oDAK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3FFA1F000E9;
	Thu, 27 Aug 2026 02:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787796874;
	bh=Cane1AOlUQJyHZIyoy0KeSRwQewjcMOk/ZLKOeepJe0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=iYs8oDAKJjVJVud930jSrVlON9IqVlQIIVkzomxm7HhwsfXPPeiNpOjYUksZ+4bdd
	 K56fsXsFs3pMbR+BfTtO314sJurM1m/TFJszmmFHkBJ4kQoOTFxtRJEOwo1lGqZgTK
	 Y29BV8qbdTFqze3QWHK8lyevmOKRmKQkH35NzP00=
Date: Wed, 26 Aug 2026 19:14:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ZhengYuan Huang <gality369@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com
Subject: Re: [PATCH v2] ocfs2: reject inconsistent local xattr entries
Message-Id: <20260826191433.c9208982c4eb7ff97f755969@linux-foundation.org>
In-Reply-To: <20260806085012.2650042-1-gality369@gmail.com>
References: <20260806085012.2650042-1-gality369@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  6 Aug 2026 16:50:12 +0800 ZhengYuan Huang <gality369@gmail.com> wrote:

> [BUG]
> A corrupt OCFS2 xattr entry can set OCFS2_XATTR_ENTRY_LOCAL while
> keeping xe_value_size larger than OCFS2_XATTR_INLINE_SIZE. When that
> entry reaches namevalue_size_xe(), the filesystem hits its BUG_ON:
> 
> kernel BUG at fs/ocfs2/xattr.c:231!
>
> ...
>
> [FIX]
>
> ...

Thanks.  AI review might have found several issues - two are
pre-existing and two introduced by this patch:

	https://sashiko.dev/#/patchset/20260806085012.2650042-1-gality369@gmail.com
