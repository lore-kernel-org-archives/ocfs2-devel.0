From: Christoph Hellwig <hch@lst.de>
Date: Tue Nov 23 03:04:01 2004
Subject: [Ocfs2-devel] Re: [Ocfs2-commits] mfasheh commits r1663 -
	branches/dlm-glue/src
In-Reply-To: <20041123085853.GC3179@ca-server1.us.oracle.com>
References: <200411230337.iAN3bJSS015490@oss.oracle.com>
	<20041123083052.GA8945@lst.de>
	<20041123085853.GC3179@ca-server1.us.oracle.com>
Message-ID: <20041123090355.GA9545@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Nov 23, 2004 at 12:58:53AM -0800, Mark Fasheh wrote:
> On Tue, Nov 23, 2004 at 09:30:52AM +0100, Christoph Hellwig wrote:
> > You never opencode the memset ocfs_malloc did.  Did you do an audit that
> > it's never needed?
> Yeah, stupidly, much of the code which called ocfs_malloc did the memset
> anyway so that's why you don't see any "+ memset( ..." lines in the patch :)

ok
