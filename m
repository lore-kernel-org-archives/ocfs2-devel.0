From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 12 Oct 2010 12:55:35 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: flush truncate log in case it
 contains too many clusters.
In-Reply-To: <20101012002345.GL8031@wotan.suse.de>
References: <4C95B999.1080307@oracle.com>
	<1284880829-3795-1-git-send-email-tao.ma@oracle.com>
	<20101012002345.GL8031@wotan.suse.de>
Message-ID: <4CB3EA47.90003@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mark,

On 10/12/2010 08:23 AM, Mark Fasheh wrote:
> Hi Tao,
>
> On Sun, Sep 19, 2010 at 03:20:28PM +0800, Tao Ma wrote:
>> When we test whether we need to flush truncate log in
>> ocfs2_truncate_log_needs_flush, we only take care of
>> whether the truncate log is full. But if the volume is
>> small and  we have large block size(in this case truncate
>> log can store too many records), we may be too late
>> for flushing if the user create/write/delete files quickly.
>>
>> So I add a new FLUSH_TRUNCATE_LOG_RATIO so that we will also
>> check whether the number of truncated clusters has reached
>> a watermark, if yes, flush the truncate log.
>> It resolves the ossbug #1288 somehow.
>
> The problem with the ratio of course is that it doesn't necessarily
> correlate to when we actually run out of space. Also, I am concerned that a
> 10% disk-size limit on truncate log could hurt us in some cases (maybe
> truncate of a huge file in the middle of some other rms?)
>
>
> How about an alternate solution - at the time we see -ENOSPC (during write
> for example), why not drop all the allocator locks (global bitmap, local
> alloc) and then look at the truncate log for a sufficiently sized extent?
> Removing it from the truncate log at that point shouldn't be too hard and
> we'd always be able to fill it up completely.
Thanks for the review. Your suggestion does make sense, but I am afraid 
it will surely be more complicated than this patch.
Anyway, I will be on a trip until next week and I will work on it when I 
come back.

Regards,
Tao
