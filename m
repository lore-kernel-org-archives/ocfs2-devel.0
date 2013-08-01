From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Thu, 1 Aug 2013 16:58:30 +0300
Subject: [Ocfs2-devel] [patch] ocfs2: fix recent memory corruption bug
In-Reply-To: <20130801135526.GA17153@elgon.mountain>
References: <20130801135526.GA17153@elgon.mountain>
Message-ID: <20130801135830.GA5102@mwanda>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Aug 01, 2013 at 04:55:26PM +0300, Dan Carpenter wrote:
> The pointer math in 6fdf3af1d2 "ocfs2: fix null pointer dereference in
> ocfs2_dir_foreach_blk_id()" isn't correct so it will zero out the wrong
> memory.
> 

I sent this patch prematurely...  Really the memset is not needed
because the values are already initialized to zero.  Let me send a
v2 patch that removes the memset.

Sorry, I just wanted to fix this right away because of the memory
corruption.

regards,
dan carpenter
