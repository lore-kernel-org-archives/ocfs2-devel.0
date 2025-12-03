Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B16135965
	for <ocfs2-devel@lists.linux.dev>; Wed,  3 Dec 2025 01:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764723660; cv=none; b=uqxeDDIl8Vzu3L+PFGh2wbzpqDYwbVoUSo8RJOamW+YqubA3VM1Nq9nnb22T1GMJaRWVXNZye+12vYQr+Y9hqVMTMti93BqVnHE+EHeC72NbjzTrhW6X/8PXZ8VZoMVFPnpOotfcDlpfujgANe6yJCktZFJy/SoEuZxdYrbObsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764723660; c=relaxed/simple;
	bh=lr5pXsxUcWLfkqZAg0qzLa12pjBAc+Aentv9KqDvb1s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QPUNNDQjDF6zTk0ueydBNjPig/FN+sWg7xvJfKIua4n68D/J6F+H5I5n3OlKemh4rq6W4OELY03uTLC4MuIZec5q2HTmHbMfjMx/Mck5ZtrMt44WsckU1Y/HdRaQlJ8awv6S1SNtjXbVUuZJkrb7rfkJkn4aXqN2vYr8nRUwvW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=sFsS6/J+; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="sFsS6/J+"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764723654; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=gyeHCMAxLGd8eT3LlJiE48RJIDPNI/dNIOrA+Hef13s=;
	b=sFsS6/J+4JqgELQGTMgj3amtwbToG4fzZ1dlFYk4SUtV6rv8sqWH5qK/VsHSkV0UmPecKK9Oz5frlQhbsSiT8lNscm2DEFCnTWx3HCHG/2GSo9EAv/RLSeU4B9fe3vKcrjzLMme97fQppyqZkcPVXe/EVsAvVthvKrDusWeaDNA=
Received: from 30.221.128.156(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0Wtymzvg_1764723653 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 03 Dec 2025 09:00:53 +0800
Message-ID: <c160b184-8411-40d9-94b7-3fe6caea907e@linux.alibaba.com>
Date: Wed, 3 Dec 2025 09:00:53 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] ocfs2: Convert remaining read-only checks to
 ocfs2_emergency_state
To: Ahmet Eray Karadag <eraykrdg1@gmail.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, Heming Zhao <heming.zhao@suse.com>,
 ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 david.hunter.linux@gmail.com, skhan@linuxfoundation.org,
 Albin Babu Varghese <albinbabuvarghese20@gmail.com>
References: <cover.1764643790.git.eraykrdg1@gmail.com>
 <1f329fa8f8b0496ecb88c6c48174ca3d8e339f8d.1764643790.git.eraykrdg1@gmail.com>
 <1636840d-0b22-4df7-8a54-2795583ae83d@linux.alibaba.com>
 <aS-IVZyCZgE115f6@eray-kasa>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <aS-IVZyCZgE115f6@eray-kasa>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/12/3 08:46, Ahmet Eray Karadag wrote:
> On Tue, Dec 02, 2025 at 03:39:30PM +0800, Joseph Qi wrote:
>>
>>
>> On 2025/12/2 10:54, Ahmet Eray Karadag wrote:
>>> To centralize error checking, follow the pattern of other filesystems
>>> like ext4 (which uses `ext4_emergency_state()`), and prepare for
>>> future enhancements, this patch introduces a new helper function:
>>> `ocfs2_emergency_state()`.
>>>
>>> The purpose of this helper is to provide a single, unified location
>>> for checking all filesystem-level emergency conditions. In this
>>> initial implementation, the function only checks for the existing
>>> hard and soft read-only modes, returning -EROFS if either is set.
>>>
>>> This provides a foundation where future checks (e.g., for fatal error
>>> states returning -EIO, or shutdown states) can be easily added in
>>> one place.
>>>
>>> This patch also adds this new check to the beginning of
>>> `ocfs2_setattr()`. This ensures that operations like `ftruncate`
>>> (which triggered the original BUG) fail-fast with -EROFS when the
>>> filesystem is already in a read-only state.
>>>
>>
>> The above commit log is the same with patch 1 and doesn't reflect
>> the following changes.
>>
>>> Co-developed-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
>>> Signed-off-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
>>> Signed-off-by: Ahmet Eray Karadag <eraykrdg1@gmail.com>
>>> ---
>>> v2:
>>>  - Use `unlikely()` for status check
>>> ---
>>>  fs/ocfs2/buffer_head_io.c |  4 ++--
>>>  fs/ocfs2/file.c           | 17 ++++++++++-------
>>>  fs/ocfs2/inode.c          |  3 +--
>>>  fs/ocfs2/move_extents.c   |  5 +++--
>>>  fs/ocfs2/resize.c         |  8 +++++---
>>>  fs/ocfs2/super.c          |  2 +-
>>>  6 files changed, 22 insertions(+), 17 deletions(-)
>>>
>>> diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
>>> index 8f714406528d..61a0f522c673 100644
>>> --- a/fs/ocfs2/buffer_head_io.c
>>> +++ b/fs/ocfs2/buffer_head_io.c
>>> @@ -434,8 +434,8 @@ int ocfs2_write_super_or_backup(struct ocfs2_super *osb,
>>>  	BUG_ON(buffer_jbd(bh));
>>>  	ocfs2_check_super_or_backup(osb->sb, bh->b_blocknr);
>>>  
>>> -	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb)) {
>>> -		ret = -EROFS;
>>> +	ret = ocfs2_emergency_state(osb);
>>> +	if (unlikely(ret)) {
>>
>> I'd like use the following style:
>> if (ocfs2_emergency_state(osb)) {
>> 	ret = -EROFS;
>> 	...
>> }
>>
>> So that ocfs2_emergency_state() can be expended with other cases(properly
>> other return code), without touching these code flows.
> 
> In the future, there might be other return codes added to ocfs2_emergency_state().
> Correct me if I'm wrong, but with your proposed style, we would only return
> -EROFS in any case. Shouldn't we consider future improvements?
> 
> Thanks,
> Ahmet Eray
>>
Return EROFS here is to be consistent with before.
i.e. No functional change.

Joseph

