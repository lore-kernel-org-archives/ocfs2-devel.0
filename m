From: TaoMa <tao.ma@oracle.com>
Date: Wed, 26 Aug 2009 16:17:00 +0800
Subject: [Ocfs2-devel] [PATCH 17/41] ocfs2: Add CoW support.
In-Reply-To: <20090825193053.GC9812@mail.oracle.com>
References: <20090821205800.GC4330@mail.oracle.com>
	<1251126252-8276-1-git-send-email-tao.ma@oracle.com>
	<20090825193053.GC9812@mail.oracle.com>
Message-ID: <4A94EF7C.7020706@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Mon, Aug 24, 2009 at 11:04:12PM +0800, Tao Ma wrote:
>   
>> This patch try CoW support for a refcounted record.
>>     
>
> 	Overall the series looks good.  It needs to be rebased against
> the latest merge-window branch.
> 	I was wondering, though.  In ocfs2_refcount_cow(), should we
> make sure that write_len is sane wrt max_cpos?  You added that (correct)
> check for max_cpos in cal_cow_clusters().  but ocfs2_refcount_cow() is
> defined as ensuring cpos+write_len is safe.
> 	Now, I think this is correct in the code.  The truncate CoW
> passes a write_len of 1 and a max_cpos of cpos+1.  So perhaps at the top
> of ocfs2_refcount_cal_cow_clusters() we should BUG_ON(cpos+write_len >
> max_cpos)?  Does that sound correct to you?
>   
should be. Although our current code handle this gracefully, we can't 
tell whether future caller forget this basic condition.  So I have no 
objection to it. I will add it later.
> 	If yes, add it.  If no, don't.  Rebase against merge-window and
> I'll pull later tonight or in the morning (my time) depending on when I
> see it.
>   
Sure. thanks.

Regards,
Tao
