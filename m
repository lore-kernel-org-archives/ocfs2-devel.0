Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C6C3254B5
	for <ocfs2-devel@lists.linux.dev>; Fri,  5 Dec 2025 09:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764926588; cv=none; b=HRBpFDJlpMrwrI/N7dzOl7gb99KotrairpwOWRdOwoP1PwlPMiNTfH656jAh5R2i3NUw79mzjl3fdX9PGlTqcWnIlw9JgWcoBwwD//+4FOIXaQYXq6kt5CfCyvv/J6zq4Xl3tXFSeIus6BwyZy3tcF2GMNm6aY7VQUYKHKPC0KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764926588; c=relaxed/simple;
	bh=M3btekHkSqsQQisNNrsWIKtNGp/cxdigKuf6pE0+Ggs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VTGK5nKiCjiCj8/7/DV8pR2W7odB5JSOK8XVC1mvUOWDNg+ndTUTBV4AfDULizT0AObyP7Jq0MUyS9onBma0abykG/Zsp28Woi0htRoBhT5GIsDuN3DM3OkDzob4jrEpMf36u7ngYL6Pb2TpS6CEI7Wv8uyPN15VUsPa9vEZCng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Smma2ues; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Smma2ues"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764926568; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=T+WAhDFeLaA5o/SbXrqzbT/HDLutJ1k0w/ntvihXoLQ=;
	b=Smma2uesKWxGWaH094HMbLHh24CdnT3MC8DjFVhsyTUruoqFOr9ryhCyn09oxWxw9mu1Wko9wNdBPTJaSUIVmOLYZrAfHl7BLAgc6CFUvE0b88ZI9MipenTDAlnTZVD5PgkfMhov8Fyj7n3vVwKLIaRUmLjs5JMJ83+oqddehlI=
Received: from 30.221.144.199(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0Wu7S3MH_1764926567 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 05 Dec 2025 17:22:47 +0800
Message-ID: <973ba880-01b2-4d1c-992d-01140e24beb4@linux.alibaba.com>
Date: Fri, 5 Dec 2025 17:22:47 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND v4 0/2] ocfs2: give ocfs2 the ability to reclaim
 suballocator free bg
To: Heming Zhao <heming.zhao@suse.com>, mark@fasheh.com, jlbec@evilplan.org
Cc: ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 glass.su@suse.com
References: <20251202063938.9046-1-heming.zhao@suse.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20251202063938.9046-1-heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/12/2 14:39, Heming Zhao wrote:
> why resend?
> - the v4 summary description in the cover letter is incorrect.
> 
> v4:
> 
> Most of the changes involve revising comments. For the code itself, there are
> function renames and parameter usage adjustments, but no changes to the code
> logic.
> 
> For patch [1/2]:
> - Based on Joseph's v3 review comments:
>   1. Modify the caller to initialize the ocfs2_read_hint_group_descriptor()
>      input parameter '*released'.
>   2. Rename the _reclaim_to_main_bm() to _ocfs2_reclaim_suballoc_to_main()
>   3. Change the text "not empty rec" to "non empty rec"
> 
> - Revise the comments preceding the function _ocfs2_reclaim_suballoc_to_main().
> 
> - For the question: "How to distinguish the release case or a bug?"
>   I write a comment before ocfs2_read_hint_group_descriptor().
> 
> - Revise the commit log to make it clearer.
> 
> For patch [2/2]:
> - Revise the commit log to make it clearer.
> 
> Remove the v3 patch: "ocfs2: adjust spinlock_t ip_lock protection scope"
> - Reason: This patch belongs to a different topic/job and should be
>           handled separately.
> 
> v3:
> 
> For patch [1/3]:
> - Factor out the reclaim code into a new function '_reclaim_to_main_bm'.
> - The function ocfs2_read_hint_group_descriptor doesn't return -EIDRM
>   when the group descriptor is invalid. The new code logic returns 0,
>   and the input parameter '*released' is set to 1.
> 
> For patch [2/3]:
> - Modify the code to follow the new logic of ocfs2_read_hint_group_descriptor
>   as introduced in patch [1/3].
> 
> For patch [3/3]:
> - No new changes.
> 
> v3 patch has passed the xfstests:
> ./check -g quick -T -b -s ocfs2 -e generic/032 -e generic/076 \
> -e generic/081 -e generic/266 -e generic/272 -e generic/281 \
> -e generic/331 -e generic/338 -e generic/347 -e generic/361 \
> -e generic/479 -e generic/480 -e generic/628 -e generic/629 \
> -e generic/648 -e generic/650
> 

Hi, could you please send out the ocfs2-test results as well?

Thanks,
Joseph

> v2:
> 
> Create 2 new patches:
> - ocfs2: detect released suballocator bg for fh_to_[dentry|parent]
> - ocfs2: adjust spinlock_t ip_lock protection scope
> 
> In ocfs2_read_hint_group_descriptor()
> - bypass the validation of GD when the BH is already managed by jbd2.
> 
> In _ocfs2_free_suballoc_bits()
> - Move up the position of the vars 'idx' & 'rec'.
> - Move up the position of the ocfs2_journal_dirty.
> - Use le[16|32]_to_cpu() to access cl/fe/rec vars.
> - Add error handling for calling ocfs2_extend_trans().
> - adjust spin_lock ->ip_lock protection scope.
> - Follow Glass's review comments, add 'comment' & 'else-break' for the
>   'for-loop'.
> 
> v1:
> 
> Only create patch:
> - ocfs2: give ocfs2 the ability to reclaim suballoc free bg
> 
> Heming Zhao (2):
>   ocfs2: give ocfs2 the ability to reclaim suballoc free bg
>   ocfs2: detect released suballocator BG for fh_to_[dentry|parent]
> 
>  fs/ocfs2/suballoc.c | 336 +++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 317 insertions(+), 19 deletions(-)
> 

