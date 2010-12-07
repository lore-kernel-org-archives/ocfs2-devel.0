From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Tue, 7 Dec 2010 09:55:50 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: lock the page in
 __ocfs2_page_mkwrite() -v2
In-Reply-To: <20101118220552.GC19821@mail.oracle.com>
References: <201011181554.oAIFs5a5031128@rcsinet15.oracle.com>
	<20101118220552.GC19821@mail.oracle.com>
Message-ID: <20101207015549.GA3068@laptop.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mark,

Do you have any comment on this patch? Seems Joel wants your ACK.

regards,
wengang.
On 10-11-18 14:05, Joel Becker wrote:
> On Thu, Nov 18, 2010 at 11:52:14PM +0800, Wengang Wang wrote:
> > Lock the page in __ocfs2_page_mkwrite(). Or we may get -EINVAL error
> > from ocfs2_grab_pages_for_write() if the page(page cache) gets truncated
> > while someone is flushing the pagecache. In the original code, we are
> > checking mapping earlier in __ocfs2_page_mkwrite() but we don't lock it.
> > so the mapping can change during flushing pagecache.
> 
> 	This looks like a good implementation of the concept.  I'm still
> wary of holding the page lock that long, though I *think* it's the right
> thing.
> 	Mark, do you have any thoughts on this?  I believe this is
> originally your code.
> 
> Joel
> 
> -- 
> 
> "Not being known doesn't stop the truth from being true."
>         - Richard Bach
> 
> Joel Becker
> Senior Development Manager
> Oracle
> E-mail: joel.becker at oracle.com
> Phone: (650) 506-8127
