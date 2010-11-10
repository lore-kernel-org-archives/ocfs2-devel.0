From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 10 Nov 2010 22:33:37 +0800
Subject: [Ocfs2-devel] [PATCH 4/5] ocfs2: Add ocfs2_trace.h.
In-Reply-To: <20101110094803.GE31158@mail.oracle.com>
References: <4CDA08B6.2070002@oracle.com>
	<1289357543-2538-4-git-send-email-tao.ma@oracle.com>
	<20101110094803.GE31158@mail.oracle.com>
Message-ID: <4CDAAD41.8080900@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Wed, Nov 10, 2010 at 10:52:22AM +0800, Tao Ma wrote:
>   
>> About one year ago, Wengang Wang tried some first steps
>> to add tracepoints to ocfs2. But at that time we don't
>> have ocfs2 1.6 introduced, so we delay this work until now
>> after ocfs2 1.6 and UEK(Unbreakable Enterprise Kernel) are
>> released.
>>
>> Wengang's original patch is here:
>> http://oss.oracle.com/pipermail/ocfs2-devel/2009-November/005512.html
>>
>> But as Steven Rostedt indicated in his article
>> http://lwn.net/Articles/383362/, we'd better have our trace
>> files resides in fs/ocfs2, so I rewrited the patch using the
>> method Steven mentioned in that article.
>>
>> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
>> Signed-off-by: Tao Ma <tao.ma@oracle.com>
>>     
>
> 	Did you author this or did Wengang?  If you are the author, only
> your signoff is necessary.  You should, of course, credit him in the
> description, and you can get his Acked-by: if you feel it necessary.
>   
Yeah, sorry, I forgot to add a "From:Wengang Wang 
<wen.gang.wang@oracle.com>" in my guilt.
That way, it will generate the commit with Author of wengang wang 
automatically. Since this patch only
includes about 19 lines of change, and I changed about 5-6 lines, the 
author should be him.
> 	I realize this patch is only a slight difference from his
> original, so he could perhaps still be considered the author.  I'm
> unsure how much rewriting you did in the second patch, though.
>   
As for the 2nd one, his original patch has this diffstat:
fs/ocfs2/alloc.c | 47 +++++-----
include/trace/events/ocfs2.h | 202 
++++++++++++++++++++++++++++++++++++++++++
2 files changed, 224 insertions(+), 25 deletions(-)

My patch has

fs/ocfs2/alloc.c       |  165 +++++++++--------
fs/ocfs2/ocfs2_trace.h |  485 ++++++++++++++++++++++++++++++++++++++++++++++++
2 files changed, 573 insertions(+), 77 deletions(-)

So I guess the author should be me(What's more, I have changed some of 
his modifications also.)?
Or I should leave his patch there with his sob, while adding a new patch 
of mine?

Regards,
Tao
