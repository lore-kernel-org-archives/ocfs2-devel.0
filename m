From: Ashish Samant <ashish.samant@oracle.com>
Date: Wed, 14 Sep 2016 15:54:23 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix start offset to
 ocfs2_zero_range_for_truncate()
In-Reply-To: <20160914154324.c74ecfb4755e3d8958d02461@linux-foundation.org>
References: <1470957147-14185-1-git-send-email-ashish.samant@oracle.com>
	<20160914154324.c74ecfb4755e3d8958d02461@linux-foundation.org>
Message-ID: <57D9D51F.6010308@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 09/14/2016 03:43 PM, Andrew Morton wrote:
> On Thu, 11 Aug 2016 16:12:27 -0700 Ashish Samant <ashish.samant@oracle.com> wrote:
>
>> If we do fallocate with punch hole option on a reflink, with start offset
>> on a cluster boundary and end offset somewhere in another cluster, we
>> dont COW the first cluster starting at the start offset. But in this
>> case, we were wrongly passing this cluster to
>> ocfs2_zero_range_for_truncate() to zero out.
>>
>> Fix this by skipping this cluster in such a scenario.
> How serious is this bug?  It sounds like a data-corrupting error?  As
> such, this is a high priority fix and it should be backported into the
> -stable kernels?
>
>
> Please always include such info when fixing bugs.
Yes, it is quite serious, I should have cc'ed stable. Will do it going 
forward.

Thanks,
Ashish
