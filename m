From: Christoph Hellwig <hch@lst.de>
Date: Tue Nov 23 02:31:03 2004
Subject: [Ocfs2-devel] Re: [Ocfs2-commits] mfasheh commits r1663 -
	branches/dlm-glue/src
In-Reply-To: <200411230337.iAN3bJSS015490@oss.oracle.com>
References: <200411230337.iAN3bJSS015490@oss.oracle.com>
Message-ID: <20041123083052.GA8945@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Nov 22, 2004 at 09:37:19PM -0600, svn-commits@oss.oracle.com wrote:
> Author: mfasheh
> Date: 2004-11-22 21:37:18 -0600 (Mon, 22 Nov 2004)
> New Revision: 1663
> 
> Modified:
>    branches/dlm-glue/src/journal.c
>    branches/dlm-glue/src/namei.c
>    branches/dlm-glue/src/ocfs.h
>    branches/dlm-glue/src/super.c
> Log:
> * ocfs_malloc was hardly used so lets take this opportunity to get rid of it.

You never opencode the memset ocfs_malloc did.  Did you do an audit that
it's never needed?
