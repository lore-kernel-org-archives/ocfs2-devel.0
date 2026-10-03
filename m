Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5750345EA4;
	Sat,  3 Oct 2026 22:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791066889; cv=none; b=opBmGk4wNpuCIVmLyjvPpgDvf/ypRLvDED6q6OLtZUvETngU09By+CrKJdbr3sqyKNC1qu1W7X5txajnHTrYBOiLdOgdpAymU6ib2BKV9O+E/ZgmQe7PObZ7g2thVIjkymehVl5+OXoJgWdk7cvY3orre6j/ZQ+3aYoeXR9efHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791066889; c=relaxed/simple;
	bh=JARHsbMZ3W/zP5nkowwxQwvol1Ts06/sxFNKWusp6Z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uyVABG4bRFvdehHes8y2VUtPhg5hqfLSzLdT4iZadThAnh3szC8LndcViDZUDPxS144NEokg/qdg6f84KRUqQZF3zW3GNSM9XoJdI8GuqF+ecRWhGaZLg7IBVrIEwjJrv2/L6naaL0vlUnSe7uNyCscyKW7OzLNZkJSz+JRN44k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m61QrQ+L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m61QrQ+L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1640D1F0089B;
	Sat,  3 Oct 2026 22:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791066887;
	bh=o6Gz5R7zxR2i6Omxsoi3Yfp1bwSvPrH8E7vz6kUnBaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m61QrQ+Lq2KJo1vQWtou8mQ6iPHUDmwtppPhFgXODCErmvX+3i12njnpNdRvXk0Jf
	 IhO8xZCwr2K1b3OpMNFyeUybRj9RU1kV+SGfdPe39FVRqVln1Zq5SG6kncU7N74+sD
	 nfTUV2RB+5f9YYT3kBOYBVXAeINlZwe+C8kwrxOvdWeLNrRhpyoEaV3Qbe7XNWctVs
	 13RS0jIkFQVWNe9Rm0BMZFR6vvsG7Q/OM+XLrUnoW1ZYpVi9D3dijyGVFE1Xq9dfk8
	 5atIt89OBVE1Z8egc/jruRKhVkHTA1J+HNIgR+ZeHVbVxB7cNXoMD+CCcpgRC/6Wle
	 W0XOCVjH0FKZA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Artem Dinaburg <artem@trailofbits.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.cz>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Heming Zhao <heming.zhao@suse.com>
Subject: Re: [PATCH 6.1.y] ocfs2: Avoid touching renamed directory if parent does not change
Date: Sat,  3 Oct 2026 18:32:50 -0400
Message-ID: <2026-10-03-1-daily-reply-0009-re-ocfs2-renamed-dir-6-1@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261002194807.21118-1-artem@trailofbits.com>
References: <20261002194807.21118-1-artem@trailofbits.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> [ Upstream commit 9d618d19b29c2943527e3a43da0a35aea91062fc ]

Queued for 6.1, thanks.

-- 
Thanks,
Sasha
