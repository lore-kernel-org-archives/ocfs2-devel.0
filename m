Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D6615853B
	for <ocfs2-devel@lists.linux.dev>; Tue, 24 Jun 2025 01:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750730225; cv=none; b=kK24ewHNna16tyzTC1mJR+Z4yo8MKMjgwCXoMd9R04b2cfj846+bt8Dbf540Lq2+u5MM/5VBjtcHFroUplM1yhtbp24n9AIPgxXVYLz0kPmkG7q5m6WuA4SLO0j4VGqTpNNu1wDU5A4OCRn4iqPQy3a55aVojEfeMGhL0KuEfL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750730225; c=relaxed/simple;
	bh=fjJUluiUV0jFld53GkIQxGvraehfT1fvsKV6Vu5F2es=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fHFA4R2KE5P1N3rfcHVh3APsDD456zw/DzPHg7Sk2NhL9uLvxiJUEaTI+BzMBcD7HVjmjZJG0dDNTqKS0iiAFwmxBUldTE98YwGCtpRq9rJuW36YJlRml0n8X7Zd9lI3wSXaEYifNF5ya4vyvJr7Hu+evR1qoty26VM9ifE2XWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 55O1tKFn064509;
	Tue, 24 Jun 2025 10:55:20 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.6] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 55O1tKE0064505
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 24 Jun 2025 10:55:20 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <1c0f49ac-2634-4126-abcd-7859fc71f134@I-love.SAKURA.ne.jp>
Date: Tue, 24 Jun 2025 10:55:20 +0900
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: kill osb->system_file_mutex lock
To: Heming Zhao <heming.zhao@suse.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        jiangyiwen <jiangyiwen@huawei.com>,
        Andrew Morton
 <akpm@linux-foundation.org>,
        ocfs2-devel@lists.linux.dev,
        Diogo Jahchan Koike <djahchankoike@gmail.com>
References: <934355dd-a0b1-4e53-93ac-0a7ae7458051@I-love.SAKURA.ne.jp>
 <faf70481-09dd-4c7a-bd43-f1e8bec877cb@suse.com>
Content-Language: en-US
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <faf70481-09dd-4c7a-bd43-f1e8bec877cb@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Anti-Virus-Server: fsav201.rs.sakura.ne.jp
X-Virus-Status: clean

On 2025/06/24 10:33, Heming Zhao wrote:
> Hello,
> 
> Protecting refcnt with a mutex is the right approach, and commit 43b10a20372d
> did it properly.
> However, I don't see how your patch fixes the syzbot report [1]. Could you
> elaborate on the root cause analysis?
> 
> My review comments are inline below.
> 
> [1]: https://syzkaller.appspot.com/bug?extid=1fed2de07d8e11a3ec1b

My patch does not fix [1]. My patch fixes a bug which syzbot reported at
https://lkml.kernel.org/r/000000000000ff2d7a0620381afe@google.com
when testing with Diogo's patch at
https://syzkaller.appspot.com/x/patch.diff?x=178f93d5980000 for [1].

>> Reported-by: Diogo Jahchan Koike <djahchankoike@gmail.com>
> 'Reported-by' should be: https://syzkaller.appspot.com/bug?extid=1fed2de07d8e11a3ec1b

Since there is not yet a bug link for my patch, I don't choose syzbot as reporter.
Diogo will post a formal patch for fixing [1] after returning from vacation.

