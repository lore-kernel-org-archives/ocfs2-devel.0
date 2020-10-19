From: zhangqilong <zhangqilong3@huawei.com>
Date: Mon, 19 Oct 2020 08:07:48 +0000
Subject: [Ocfs2-devel] =?utf-8?b?562U5aSNOiBbcGF0Y2ggLW5leHRdIG9jZnMyOiBB?=
 =?utf-8?q?dd_the_trace=5Focfs2=5Fread=5Fblocks=5Fend?=
In-Reply-To: <6a644e29-a2a1-8f18-116f-a67c9a1c5653@linux.alibaba.com>
References: <20201016091157.29039-1-zhangqilong3@huawei.com>
	<6a644e29-a2a1-8f18-116f-a67c9a1c5653@linux.alibaba.com>
Message-ID: <5960811c6a3b477da371662494fecfa8@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, Joseph

I think it makes sense, the 'begin' trace entry will always be paired 
with 'end'. For the post processing the trace, it would be easier to 
reconstruct such reading block operation and mark immediately as 'not sent' (avoiding 
to bother about entries which only have 'begin'). Logging an error message could help 
locate problems quickly in case error.
It looks good to me, so feel free to add it.

Best wish, thanks,
Zhang Qilong

> -----????-----
> ???: Joseph Qi [mailto:joseph.qi at linux.alibaba.com]
> ????: 2020?10?19? 15:46
> ???: zhangqilong <zhangqilong3@huawei.com>; mark at fasheh.com;
> jlbec at evilplan.org
> ??: ocfs2-devel at oss.oracle.com
> ??: Re: [patch -next] ocfs2: Add the trace_ocfs2_read_blocks_end
> 
> 
> 
> On 2020/10/16 17:11, Zhang Qilong wrote:
> > Missing the trace_ocfs2_read_blocks_end when reading blocks fails.>
> Why do you need the trace in case error?
> In general, it will log an error message if fail.
> 
> Thanks,
> Joseph
> 
> > Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
> > ---
> >  fs/ocfs2/buffer_head_io.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
> > index f0b104e483d8..0e6ee6e9b201 100644
> > --- a/fs/ocfs2/buffer_head_io.c
> > +++ b/fs/ocfs2/buffer_head_io.c
> > @@ -395,11 +395,10 @@ int ocfs2_read_blocks(struct ocfs2_caching_info
> *ci, u64 block, int nr,
> >  	}
> >  	ocfs2_metadata_cache_io_unlock(ci);
> >
> > +bail:
> >  	trace_ocfs2_read_blocks_end((unsigned long long)block, nr,
> >  				    flags, ignore_cache);
> >
> > -bail:
> > -
> >  	return status;
> >  }
> >
> >
