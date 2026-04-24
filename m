Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859242AD3D;
	Fri, 24 Apr 2026 14:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777039812; cv=none; b=dOvguuhDeSoVVSo9UQHQ5TSlJ3OQUq0jNBUEzEfHsyDsygZ9quFkcl0q1HxOWYMshsltpaTmacyuLGeQ9Lw09FhwM9W06w56+fBp7zS8oru8mtS88xZBv/aFEnQvlCm7KLtoBVMaCBkTtLHqevfvCCQP6EiL2K9oT4kC4L3G8q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777039812; c=relaxed/simple;
	bh=XkLsiFiRRRLF/EKsBuIFCMgoLXx6ZYr6KouRTnY/LmI=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=t5/HeSlsg9dnsk2AboiVNiSPXD8lhTnHPJJxWClrEtal1qSkr/cXukUQIsCCrO64R0G9y3QY67qg7UdcLcv/MPD+aNX6tNMxKfh84r4VjjxpDOLqgrd1BYsc8EGERk78NKGlsivT4lO9eUGcBQqNbDTpOQx9V8gbXfjG1PsODSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Kjisi8L2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Kjisi8L2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4BB5C19425;
	Fri, 24 Apr 2026 14:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777039812;
	bh=XkLsiFiRRRLF/EKsBuIFCMgoLXx6ZYr6KouRTnY/LmI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Kjisi8L2wZJ6FuHo9GGqa+e77p/pyPY7C8yysjuy3MtrVtcTFVcMMKHkTN6zAbkh+
	 /th1KYk39D18WG6EdCfAHqX6QAn6h7mkTmHP3ym/mAJ/3Jf0ipR7GyyDS1gJozV3qH
	 mruPGa+s5Y3dXi2T8P88MeLxobfYTKEaMTj22/F4=
Date: Fri, 24 Apr 2026 07:10:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tristan Madani <tristmd@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 syzbot+7ea0b96c4ddb49fd1a70@syzkaller.appspotmail.com
Subject: Re: [PATCH] ocfs2: use kzalloc for quota recovery bitmap allocation
Message-Id: <20260424071011.2ddf2d37f9cb5f992fdcfac4@linux-foundation.org>
In-Reply-To: <20260418131048.1052507-1-tristmd@gmail.com>
References: <20260418131048.1052507-1-tristmd@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 18 Apr 2026 13:10:48 +0000 Tristan Madani <tristmd@gmail.com> wrote:

> ocfs2 quota recovery allocates a bitmap buffer with kmalloc and does
> not fully initialize it. This can lead to use of uninitialized bits
> during quota recovery from a corrupted filesystem image.
> 
> Use kzalloc instead to ensure the bitmap is zero-initialized.

AI review asks a question about the nearby code:
	https://sashiko.dev/#/patchset/20260418131048.1052507-1-tristmd@gmail.com
