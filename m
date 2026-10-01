Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D992449B01;
	Thu,  1 Oct 2026 13:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790862748; cv=none; b=jciu7ZuRY5HVWdxb904+x/NOPzorbeNjzl1FVsVpj3KCg7HROcJJVx5SyRDpM6DfU1dWBme2KXcZk6xOwvMgdh6V3T0FeeU1JwjC97sG+lc/8Gm69V74MXnKUZFwISegWtM2DMIcRDdL6NU/bhNSFeXHVqCRCQShhMYZrzVPPTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790862748; c=relaxed/simple;
	bh=RgvO7A73hYuI34zwd2ool69WzjPc/jAB/4RgJc5nHpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eyu4eZ2+Wl/CtxGjhQVyPru3NI9tMUzLhushSlYcyeFBM+cOjibwwxPFDK25Um3L7+r1u9b/G3O0ZPz80vNHldrryA6QawVrepkoKKEctlh0v0rDvtCZU3Pks8lE0CpN1ZtyTCQPX/aZ8r5kn5rZleoVrFf4d2bfS8CeVSErtjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RGBuDea9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RGBuDea9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F891F00898;
	Thu,  1 Oct 2026 13:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790862746;
	bh=mFi5I7HQK84Ib+iDtZze4HE621RCVaFeIv6SOtARZgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RGBuDea9nPyP4vdTYdpAjYnbQZ7HCBq9/5W8p1VnbX3gP4VKQHmiTmQpARXlNaGPJ
	 c6tP+iJPvbOGovx1y1NAduRPOUSyaTTJ5EEWr2UHXamPFMGFlx2VFXVoqTFkBjOVDJ
	 sTWiQdGo5Y65WMSxr5hTVNQw9NSSL/aEfFzJfTHgMUbm9GKGyPImyA5+jk9FJfOT1I
	 oAlP6+lSqZV7IT8WD2FaqH69acexRee9llmcPhDD+1RnXscsJOwX19VF6g78PLNhq+
	 nwXR5qbVp/LWtZdRnUi0x/9mXr3LHRMrjDpfrSWEHCd76J+YmBq/YptxtAmXcPI5AX
	 BH8HU9SfHcZUQ==
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
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.6.y] ocfs2: Avoid touching renamed directory if parent does not change
Date: Thu,  1 Oct 2026 09:52:06 -0400
Message-ID: <2026-09-30-1-daily-reply-0002-ocfs2-renamed-dir-6-6@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260930010728.94306-1-artem@trailofbits.com>
References: <20260930010728.94306-1-artem@trailofbits.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> This one addresses CVE-2023-52590. It avoids updating a renamed directory
> without the VFS lock when its parent is unchanged.

Queued for 6.6, thanks.

-- 
Thanks,
Sasha
