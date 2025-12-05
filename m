Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825762F9DAB
	for <ocfs2-devel@lists.linux.dev>; Fri,  5 Dec 2025 09:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764925658; cv=none; b=NdzvwCO8KW4DwHRoGf3mEMRqREA43ydhP5YR2D80X+CVvAHzkLS0/S4Xfn808boD+vnphFvdBHoHbVD77+/y7s5N3ghXApmeMXK3XmKbGPruzy1v4kXMS/E7umQhpLR6m/pz5CGFJypgxyQ7iSdH4qvAY4/jqd9xONLiJQEDH9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764925658; c=relaxed/simple;
	bh=4W8MIYNZR+MQODP8CBPdA3/46SEOxgNwBcE/Z6Kuw8o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PQp6jDOl6ThP4HAgR38kgOgybGtipMNyHJ22QLxSvxuQpEvxTm7tlLEusQ5uxHVECvy1DWlnOylgGc/8oEzqkfMpF5e8xRehAFgim4YYG3vKAJJiHmmwReyr1JoJn14tnnI6RKoqsyP+08dUkquvhATm7OBR3OFH5oJkeQAzPn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=q2uE2kWm; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="q2uE2kWm"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764925647; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Pr5iTmXMD0yyoGU9zAyJWWkpdsejoZZvMlmU8snjbPo=;
	b=q2uE2kWmeuTBPAom93XKVjDhJZXkVpL4Plnz5OcTU6MO1ZWTH4uItU+yiS1M2NPCZVu7mouBUMRTsq3hMMkXA+DhKnZ66OhuKf0Q2oxDy2rtP5zc06EwBjU6VmswS6y2LtDnGZzvx5oj42Jb13gjty9Ags1ney6rrPqmFLRnn3w=
Received: from 30.221.144.199(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0Wu7P.5V_1764925645 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 05 Dec 2025 17:07:26 +0800
Message-ID: <29c376c8-df70-4bc8-bd19-6fa534fe2979@linux.alibaba.com>
Date: Fri, 5 Dec 2025 17:07:25 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: fix memory leak in ocfs2_merge_rec_left()
To: Heming Zhao <heming.zhao@suse.com>, Dmitry Antipov <dmantipov@yandex.ru>,
 akpm <akpm@linux-foundation.org>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org,
 syzbot+cfc7cab3bb6eaa7c4de2@syzkaller.appspotmail.com
References: <20251205065159.392749-1-dmantipov@yandex.ru>
 <2u6dw5pw225v72iiezztbokptt5vv6kbgv2zijmkpewurcrupl@gar3iu3eukbw>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <2u6dw5pw225v72iiezztbokptt5vv6kbgv2zijmkpewurcrupl@gar3iu3eukbw>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2025/12/5 15:05, Heming Zhao wrote:
> On Fri, Dec 05, 2025 at 09:51:59AM +0300, Dmitry Antipov wrote:
>> In 'ocfs2_merge_rec_left()', do not reset 'left_path' to NULL after
>> move, thus allowing 'ocfs2_free_path()' to free it before return.
>>
>> Reported-by: syzbot+cfc7cab3bb6eaa7c4de2@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=cfc7cab3bb6eaa7c4de2
>> Fixes: 677b975282e4 ("ocfs2: Add support for cross extent block")
>> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> 
> LGTM.
> Reviewed-by: Heming Zhao <heming.zhao@suse.com>

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
>> ---
>>  fs/ocfs2/alloc.c | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
>> index b267ec580da9..0ab9b06643f4 100644
>> --- a/fs/ocfs2/alloc.c
>> +++ b/fs/ocfs2/alloc.c
>> @@ -3654,7 +3654,6 @@ static int ocfs2_merge_rec_left(struct ocfs2_path *right_path,
>>  			 * So we use the new rightmost path.
>>  			 */
>>  			ocfs2_mv_path(right_path, left_path);
>> -			left_path = NULL;
>>  		} else
>>  			ocfs2_complete_edge_insert(handle, left_path,
>>  						   right_path, subtree_index);
>> -- 
>> 2.52.0
>>
>>

