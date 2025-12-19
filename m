Received: from out203-205-221-233.mail.qq.com (out203-205-221-233.mail.qq.com [203.205.221.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0062C234A
	for <ocfs2-devel@lists.linux.dev>; Fri, 19 Dec 2025 07:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766130141; cv=none; b=E2ZghIBEqSgWFjYW71g670v3rEC3iJW9NO9jWtgAOUtJTv9C50+eyc79ktk7dTEkEeml18KrDDC8vivpTSB6Gl+O94mS7wbMFWpDCPrsZIdSp77ERcAxGgyVxNAu9WrJF42pfsCbMv51FLxEEzwPmUSn/UBIuXUmhgj3BJ2q8Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766130141; c=relaxed/simple;
	bh=rVAAm7SYH0uCDRqATFJKjxm8NYy6eemyOELzvBUxfQQ=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=QVLVlzkPvu735bC6mzudGjrf5oKCe+3XzO6IkzBlADnAhEvuoPxNvbzxVPwouD2SPNL/j5bYH39wWu5QwkDmzlWPP8X61kXVdIzpSoaayvwtgwt27kBo5ch7i8lJWP+ip588WdMj/kZsXWHlk6ZTG5RSOC81bsMre9a0kFPrr/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=Tn8jU+j+; arc=none smtp.client-ip=203.205.221.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="Tn8jU+j+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1766130129; bh=KRRRuCpHgnGRb3mKzLcCiNXEQN4QA1IZZeoCIwMrqYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tn8jU+j+hUJdzWiEGhKhZmboxQW7F1YsuBvtLeqJFhim5QOJoJ4Io8CxTymrvOwxX
	 OLdD8I9s31NyKZCuO0JatvjJ5QOhi+wmTtJwqvCVwsx0PwppH6VSR0sl6KadnkAr1e
	 nH+AA3wZ2Bysv/RlANlQtdR+eBZelNARxWrhnbgM=
Received: from lxu-ped-host.. ([111.201.7.117])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id A868CA95; Fri, 19 Dec 2025 15:42:06 +0800
X-QQ-mid: xmsmtpt1766130126t011pnl3b
Message-ID: <tencent_5D38CFC68DB3A5DA8D96924A5D995D8B1907@qq.com>
X-QQ-XMAILINFO: Nx5J06Esz7r70VVMNjhjxdmvBkA5B7msYihvbYAhfiIqgJ5SMaiCI+D4sPsP8U
	 jqYjNwIEkuxSkLXppUnJr+GviExWbcyRZr1hSa/7VKPdq1BCY56meXzO5C/0XUNtIBBUJ/UlbpRB
	 tHFMybZRPMjMe/L8tkRKHfog7NZtSW1ipyBe5iG5hN029YG91OnXN5VxlgyJ0Sm2YRkKdXaAKpuV
	 Vpo411eXgWVno+my/GO+Ig9BpvEZ+RWAjxygCPUu3MAUE578Ftl15id4syeH5LnExvmG6gBkuAX8
	 NoxjvUf19QxjAhFnhDBrEEFKkHWAQsqBP8GDqtNxNGR/vh+Ls3YeSz43XK5UWHJzBytvar7yl28z
	 ZWspZGGf48zGdHucn0XFDoIrvqxOBpo7oeZu7hSutHvvYPYG1dzL+V+EdHXdYKgELpZvxpPytmGa
	 B9Y/c3+3kHM+DvlAmTcVd5o1FeMLpK+C9aJVDDIBCTWKHCt4DDOvlAi1QtzKriNlZuHNmeZhArxU
	 kFRZ47ciPiQX/UwnoI9YWfaIggm2qkE9IixW9p+oxYqfQ+UOapcgyde2TRKYcT6GDDPKtLj2qw7o
	 HA9Iyxm+ue8K+8xcCxWnInA0Ki6VtyP0sgJj+AwmI25Qo89v9Gtrky67g5W19K0diF2J0k5PxJ0P
	 XrJhK9vnqsaUBEENP9l2edqJZhjfWMth0F4LrgNyKafoCK6C47Xm0Rm5Vm/9dpoJW8pEB8aoxUU7
	 sq2il4Ur7FhRr4C81Yu4K/wGamNTAxoSoC76DhSGy7HVvvePbnKBF4jlBBZUX/u6cYtXYGrUaImS
	 qF6Ku900gXuV7Yx2LjV+onWtZSkBgqsYV9IZz6wUiIu7YAdkZMK7+kei+67qIxyCOmDYDx8tcJYG
	 3bcyq2qrqUtjwLaQpo0vT2EUjKln0XLWz/J3KWEdLXgAc6dPVo70F2twxFDgf9pVBx9rxj/RBRUe
	 4YZcVxXpXH84gEoUWa7K98YVa9LEzSwBbNBxYMCcaXnj8ynOmd9KGdUs5siLPgRUKB8EKgaVtHF9
	 yc1ZstvH4PfVGht7MI11z0B3R7GC0=
X-QQ-XMRINFO: M/715EihBoGSf6IYSX1iLFg=
From: Edward Adam Davis <eadavis@qq.com>
To: heming.zhao@suse.com
Cc: eadavis@qq.org,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	linux-kernel@vger.kernel.org,
	mark@fasheh.com,
	ocfs2-devel@lists.linux.dev,
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH v2] ocfs2: fix oob in __ocfs2_find_path
Date: Fri, 19 Dec 2025 15:42:07 +0800
X-OQ-MSGID: <20251219074206.119137-2-eadavis@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <5hyc4g4g6uxix5jncqi7ukhmdzq6xoxvou5dkvpj2o5y6v7zoe@qgvucbpcvbqn>
References: <5hyc4g4g6uxix5jncqi7ukhmdzq6xoxvou5dkvpj2o5y6v7zoe@qgvucbpcvbqn>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 19 Dec 2025 14:31:58 +0800, Heming Zhao wrote:
> What are the bits representation of zero? Is byte-swapping necessary for
> different-endian architectures?" We just need to perform the conversion in the
> error msg log. 
That's valid point.

