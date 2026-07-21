Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144CE78F26
	for <ocfs2-devel@lists.linux.dev>; Tue, 21 Jul 2026 03:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784603828; cv=none; b=sfytPjngwcyjoPW3mS/ozCrllzUN6aesGhdUPPi2XiZHcOCxrsvqL/7yLXKkqCnZDpLk3z5SpjqUD4tkUWMuLd49KUUz72uEZkN1H+ljAvyAh2LExpgaE0szyjY2fMV2APrhj6K/1l3vPr34qmDppkVXWDRpAPBqTLt85SWYM/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784603828; c=relaxed/simple;
	bh=eScV4YeA5zv2KK1LKtQ7hggQ9+HsUfj971T6ke68lHU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jcnwVsWnrPxvJlh35+GVaP0guVPc0n3LKgfVlVozWcCW4Tfnq080t/x75qpBCaX4oxQX9/ZSJNfOiSUQH0Qym9Z9CzoqSRxVlicsdkClPu2JsTHCDx9Yy+IsitBQzKh4IP8B1Ozcl4jki2XjY+OLPcgTkf31D96wnWA7tU2sHMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=FJM8Bb2L; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="FJM8Bb2L"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784603820; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=toukfyqmXDmMerOwHqcc4lnDM0bZeFkabON0/jZ/k5U=;
	b=FJM8Bb2LJNshAInWHSC/H7oMFAfju0QEzOzO98jkDVemA3usapzUSQA+S6mRFfO5nE/+w4hndrqVaZ1HdTVvTU86SsVKkwAynbmFFh+kdO/lL/Ep30F+wH1Q4DCGLXRk78pooRtkEn4Cy7Rm1G+DtdINlpjyC93nKxRmItizdn4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R481e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0X7YAk63_1784603819;
Received: from 30.221.129.34(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X7YAk63_1784603819 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 21 Jul 2026 11:16:59 +0800
Message-ID: <568ee04e-8f56-445b-b04a-7b2fd7450bd3@linux.alibaba.com>
Date: Tue, 21 Jul 2026 11:16:59 +0800
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ocfs2: free unused clusters on defrag move errors
To: Andrew Morton <akpm@linux-foundation.org>,
 Guangshuo Li <lgs201920130244@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Tristan Ye <tristan.ye@oracle.com>, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260720141944.485212-1-lgs201920130244@gmail.com>
 <20260720181535.158f43328e1f6c3d2036352e@linux-foundation.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260720181535.158f43328e1f6c3d2036352e@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 7/21/26 9:15 AM, Andrew Morton wrote:
> On Mon, 20 Jul 2026 22:19:43 +0800 Guangshuo Li <lgs201920130244@gmail.com> wrote:
> 
>> ocfs2_defrag_extent() claims new clusters before calling
>> __ocfs2_move_extent(). If the move fails before ocfs2_split_extent()
>> succeeds, the claimed clusters are not referenced by the inode and must
>> be released.
>>
>> The current error path only logs the error and continues to
>> ocfs2_cow_sync_writeback(), which can overwrite the original error with
>> zero and leave the claimed clusters allocated.
>>
>> Not every __ocfs2_move_extent() error can free the new clusters. Once
>> ocfs2_split_extent() succeeds, the extent tree references them even if
>> ocfs2_decrease_refcount() or ocfs2_truncate_log_append() subsequently
>> fails. Freeing the clusters in that case would leave the extent tree
>> pointing to clusters marked free.
>>
>> context->new_phys_cpos is updated immediately after a successful extent
>> split. Compare it with the newly claimed physical cluster on error. If
>> they differ, the split for the current move did not complete and the
>> claimed clusters can be freed. If they match, leave the clusters
>> allocated because the extent tree already references them.
>>
>> Return move errors through the transaction cleanup path so that the
>> original error is preserved instead of being overwritten by writeback.
> 
> Thanks.  AI review has flagged a couple of possible issues with this
> change.  Please check?
> 
> 	https://sashiko.dev/#/patchset/20260720141944.485212-1-lgs201920130244@gmail.com

Thanks sashiko. Yes, it indeed introduces a regression.

In data=writeback mode, ocfs2_should_order_data() returns 0, so
ocfs2_jbd2_inode_add_write() is never called. The dirty buffers are not
flushed at commit, they survive, still mapped to new_block. The patch's
need_free path frees new_block immediately.  The VM later writes those
dirty buffers to new_block at an arbitrary time — after it may have been
reallocated to another inode. That's the cross-file corruption.

Before this changes, the cluster were leaked, so new_block stayed allocated
forever and the stale writeback was harmless.

Thanks,
Joseph
