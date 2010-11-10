From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 10 Nov 2010 14:19:37 -0800
Subject: [Ocfs2-devel] [PATCH 4/5] ocfs2: Add ocfs2_trace.h.
In-Reply-To: <4CDAAD41.8080900@oracle.com>
References: <4CDA08B6.2070002@oracle.com>
	<1289357543-2538-4-git-send-email-tao.ma@oracle.com>
	<20101110094803.GE31158@mail.oracle.com>
	<4CDAAD41.8080900@oracle.com>
Message-ID: <20101110221937.GP31158@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Nov 10, 2010 at 10:33:37PM +0800, Tao Ma wrote:
> Joel Becker wrote:
> Yeah, sorry, I forgot to add a "From:Wengang Wang
> <wen.gang.wang@oracle.com>" in my guilt.
> That way, it will generate the commit with Author of wengang wang
> automatically. Since this patch only
> includes about 19 lines of change, and I changed about 5-6 lines,
> the author should be him.

	No worries.  Sounds correct.

> As for the 2nd one, his original patch has this diffstat:
> fs/ocfs2/alloc.c | 47 +++++-----
> include/trace/events/ocfs2.h | 202
> ++++++++++++++++++++++++++++++++++++++++++
> 2 files changed, 224 insertions(+), 25 deletions(-)
> 
> My patch has
> 
> fs/ocfs2/alloc.c       |  165 +++++++++--------
> fs/ocfs2/ocfs2_trace.h |  485 ++++++++++++++++++++++++++++++++++++++++++++++++
> 2 files changed, 573 insertions(+), 77 deletions(-)
> 
> So I guess the author should be me(What's more, I have changed some
> of his modifications also.)?
> Or I should leave his patch there with his sob, while adding a new
> patch of mine?

	You are clearly the author.  You should credit him in the commit
text, and add him as a Cc: line at the bottom, but it is now your work.

Joel

-- 

"A narcissist is someone better looking than you are."  
         - Gore Vidal

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
