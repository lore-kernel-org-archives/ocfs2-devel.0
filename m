Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC2633F8C1;
	Thu,  2 Apr 2026 04:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775103574; cv=none; b=GEafHWsC5qjzXTG3NbufruxR/w+0CqE0Ee/wdHHhtvfJ8rNcK6EArkEh14KcfBmJTTosRmGGMnuTyEZQj+WytVAjs2eOL4HCzBBx5mGTZREtxNsXlpB7Sr5czrCAEl08qQ2LZZAynSCGQoq25g1O9NNuSefULT68a0MwGHnlc9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775103574; c=relaxed/simple;
	bh=VEXvu6NnfF5+EZDF6n1tMScAs2uObPCBGeR5oV1yrZw=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=i/+N4t2yojhaza5VTFqH2ID9U3nnPm4jF9MIwGiidOTbbRUOn+bAJyxtGhfyNIH+MYcZfVGLdyXrGWz0T9JsOSQPcz1WozvIq5tgxgbVWHvRgamYGe/8A1N/SbfmuDa8FJV4Y9TmATihTPJ4Dqn2DVvrkSlOk4Ye8A/z362MHTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Paazlben; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Paazlben"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F2EC19423;
	Thu,  2 Apr 2026 04:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775103574;
	bh=VEXvu6NnfF5+EZDF6n1tMScAs2uObPCBGeR5oV1yrZw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=PaazlbenAq+ppMX8xj36HwsQT6v4EKUvN7wVTURAczVtxCjSBuvsVvSvzcuB+fgAu
	 xK4HPKgEw98tsMHKDMv5FmH13OOd/WMaKjnkUmis2g2nkvhc0vHbSiJwqqxfhCjFuh
	 jzB5Rh7p5zLOOD8+rYtMGKn6mpqAuXY5GEAhQp1Q=
Date: Wed, 1 Apr 2026 21:19:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejas Bharambe <thbharam@gmail.com>
Cc: ocfs2-devel@lists.linux.dev, mark@fasheh.com, jlbec@evilplan.org,
 joseph.qi@linux.alibaba.com, linux-kernel@vger.kernel.org,
 syzbot+a49010a0e8fcdeea075f@syzkaller.appspotmail.com, Tejas Bharambe
 <tejas.bharambe@outlook.com>
Subject: Re: [PATCH v3] ocfs2: fix use-after-free in ocfs2_fault() when
 VM_FAULT_RETRY
Message-Id: <20260401211933.966503e5ddda33281ed4e8ef@linux-foundation.org>
In-Reply-To: <20260402040234.92432-1-tejas.bharambe@outlook.com>
References: <20260402040234.92432-1-tejas.bharambe@outlook.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  1 Apr 2026 21:02:34 -0700 Tejas Bharambe <thbharam@gmail.com> wrote:

> From: Tejas Bharambe <thbharam@gmail.com>
>
> ...
>
> Signed-off-by: Tejas Bharambe <tejas.bharambe@outlook.com>

These are different!  Which would you prefer for upstreaming?  I'll assume
@outlook.com.

To eliminate confusion you can include an explicit From: line at
start-of-changelog and this will override the From: in the email
headers.
