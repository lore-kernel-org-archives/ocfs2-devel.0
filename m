From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 10 Nov 2010 22:39:25 +0800
Subject: [Ocfs2-devel] [PATCH 5/5] ocfs2: Remove mlog(0) from
	fs/ocfs2/alloc.c
In-Reply-To: <20101110095058.GF31158@mail.oracle.com>
References: <4CDA08B6.2070002@oracle.com>
	<1289357543-2538-5-git-send-email-tao.ma@oracle.com>
	<20101110095058.GF31158@mail.oracle.com>
Message-ID: <4CDAAE9D.8020102@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Wed, Nov 10, 2010 at 10:52:23AM +0800, Tao Ma wrote:
>   
>> So this patch removes all mlog(0,...) from alloc.c and adds
>> the corresponding tracepoints. Different mlogs have different
>> solutions.
>> 1. Some are replaced with trace event directly.
>> 2. Some are replaced and some new parameters are added since
>>    I think we need to know the btree owner in that case.
>> 3. Some are combined into one trace events.
>> 4. Some redundant mlogs are removed.
>>     
>
> 	These decisions are what I stressed to Wengang when he did his
> first pass.  I don't want to log data just because it used to have an
> mlog().  We should only be logging things that are interesting.
>   
yeah, that is also my thought. So I will only change those mlog(0,...) 
that I think I am familar with and
leave others there(I guess I won't touch dlm, cluster and dlmglue).
> 	In this patch, I see a lot of things that make sense.  "Hey,
> we're growing the tree" is a good thing to log.  So I'm not saying that
> you did anything wrong.  I'm just mentioning my goals up front to be
> clear.
> 	Overall, the patch looks good.
>   
Glad to hear that. So I will continue. I guess I can work on most files 
under fs/ocfs2/ except dlmglue.c. ;)
>   
>> What's more, it defines some event classes so that we can use
>> them later.
>>     
>
> 	This is cool.
>   
yeah, they are really cool.

Regards,
Tao
