Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C044C6F
	for <ocfs2-devel@lists.linux.dev>; Thu,  4 Apr 2024 01:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712195499; cv=none; b=fiAk/DPynSUUkoVG/5+mbSLTz8AMnMODXjKu9L8CQKNGGv3e2InE1XvKLJl1cWcgR7RYeYpYIVPZjaFBc8MeHDo0BO1BaI28mHGQCFqGplOfO30XCn6AB64lN04qSG9dmF4ZqzsT/qvhVpIrytjT1avmti7et3RycfWmJETYF04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712195499; c=relaxed/simple;
	bh=Kh9mXfCrOIMDniX+YZk8covBMvUQaJB35lA4bVEivJQ=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=re6HMY0/5ZtliS52xkoWcrJvry9naBd5zsoQEjwaibBkaXA8czhtpSHgHsVawR6oKzJFi8yu2/pXEg4kcsj9XC8XgAGNEE4qVebXe5CU2fET72C2CW02P81O+coYfUkqo2gFWzVo1V/EgVttbQRYMKM1vzQ3QMIHWoEPQGqRyWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yvSBqUPz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yvSBqUPz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91FBAC433F1;
	Thu,  4 Apr 2024 01:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712195498;
	bh=Kh9mXfCrOIMDniX+YZk8covBMvUQaJB35lA4bVEivJQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=yvSBqUPzJ7fJz8QeMZ4NM+Ua8iOgDFW4SmqvE/lMc8ekRTzygbC4J8oWO14TaQ62G
	 e41Nx8K0H88XKMTUctGLQq15iktXbPep5gBI9fOpgFFM6t9tbaqvabUSW/IjU2/Yrw
	 iyUEkhlxc91pj1KbhPx6AQg6LDPZGzTvi0BL1LIE=
Date: Wed, 3 Apr 2024 18:51:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Su Yue <glass.su@suse.com>
Cc: ocfs2-devel@lists.linux.dev, joseph.qi@linux.alibaba.com
Subject: Re: [PATCH v2 0/4] ocfs2 bugs fixes exposed by fstests
Message-Id: <20240403185138.3aaf5aace1b407eff7ed530d@linux-foundation.org>
In-Reply-To: <20240402014651.13723-1-glass.su@suse.com>
References: <20240402014651.13723-1-glass.su@suse.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  2 Apr 2024 09:46:47 +0800 Su Yue <glass.su@suse.com> wrote:

> The patchset is to fix some wrong behavior of ocfs2 exposed
> by fstests.

Thanks.  We should consider which of these fixes should be backported
into -stable kernels.  For that we should provide, for each patch:

- A description of the userspace-visible impact of the bug and

- A suitable Fixes: target to tell -stable maintainers how far back
these fixes are needed.

Please could we give some consideration to these matters?

