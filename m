Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946803FF1CD
	for <ocfs2-devel@lists.linux.dev>; Fri, 15 May 2026 15:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860324; cv=none; b=lAQCVBDsZ9A4N1EjCS1nWKJi78+5N2kjXt++XCSv33P/vfiK90naYUQ4NLwJ16Uz6WVfrwlZBRtH3GKWfIbyof5F/P/JXAcf+BQ+zMBFnW79NM1fVgUv3N3JBpsmzFTgGIcKqmRg4wNVRnmfTbihn0kvWxHHNtv4Cuqa1JFs1u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860324; c=relaxed/simple;
	bh=0tRV31QAhwa/d9iYA44xOjPH2j21dUD8U1vlEX70waE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fwO8XYT1qVlQ6MovUgmlB8IAwsGiM+2cddYsQ6VzvbOTHsNBb26h2qY+/nEBHZO8x1RMjAEHLhj+NtlWGcAcoLvEAB5wxLbMohdpS4V3mX2O/L1kKDt/09RlVbe8bRajqwlXYBLMfdPleoX8NTzFVQ2Z4qs9N9RPmiuUiOeKk8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 64FFpZ4P054501;
	Sat, 16 May 2026 00:51:35 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.5] (M106072072000.v4.enabler.ne.jp [106.72.72.0])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 64FFpZWW054498
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Sat, 16 May 2026 00:51:35 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <b0e9c4c2-9ea1-4d41-b8b2-5f2f6c15b80a@I-love.SAKURA.ne.jp>
Date: Sat, 16 May 2026 00:51:32 +0900
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: kill osb->system_file_mutex lock
To: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        jiangyiwen <jiangyiwen@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>, ocfs2-devel@lists.linux.dev,
        LKML <linux-kernel@vger.kernel.org>
References: <934355dd-a0b1-4e53-93ac-0a7ae7458051@I-love.SAKURA.ne.jp>
 <831c4fc1-c89f-48bc-84c6-25b2cefc2b20@I-love.SAKURA.ne.jp>
 <agc8kA2wxC_7091p@c73>
Content-Language: en-US
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <agc8kA2wxC_7091p@c73>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Anti-Virus-Server: fsav303.rs.sakura.ne.jp
X-Virus-Status: clean

On 2026/05/16 0:35, Heming Zhao wrote:
> Hi,
> 
> The logic here is incorrect. The purpose of the refcount is to track how many
> consumers are using the inode.

The igrab(inode) for the first time is for getting a refcount for the slot, isn't it?
The igrab(inode) for the subsequent times is for getting a refcount which is supposed to be dropped by the caller, isn't it?
_ocfs2_get_system_file_inode() always gets a refcount which is supposed to be dropped by the caller when it succeeds, doesn't it?

So why do you want one more refcount?

