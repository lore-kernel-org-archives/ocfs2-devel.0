From: Manish Singh <manish.singh@oracle.com>
Date: Tue Apr 26 03:52:17 2005
Subject: [Ocfs2-devel] Re: [Ocfs2-commits] manish commits r2175 - in
	trunk/fs/ocfs2: . cluster dlm
In-Reply-To: <20050426082033.GA18736@lst.de>
References: <200504260323.j3Q3NC9V013089@oss.oracle.com>
	<20050426071825.GA17901@lst.de>
	<20050426081538.GA6750@ca-server1.us.oracle.com>
	<20050426082033.GA18736@lst.de>
Message-ID: <20050426084753.GA8236@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Apr 26, 2005 at 10:20:33AM +0200, Christoph Hellwig wrote:
> On Tue, Apr 26, 2005 at 01:15:38AM -0700, Manish Singh wrote:
> > The issue here is format string readability vs. printk argument
> > readability. Both magic format defines and verbose (unsigned long long)
> > casts make the code harder to read. Why is format string readability
> > preferred?
> 
> I don't know ;-)  But if magic format strings we preferred we'd have
> them in a common place.

Perhaps they should be in some common place then? The kernel could
provide the C99 macros for dealing with explicitly sized types.

It sounds like the reason it doesn't exist already is simply because
nobody has done it yet. Printing 64-bit types in non-arch specific code
is rare in the current kernel tree, which is probably why nobody has
cared yet. I don't really see any evidence of a specific precedent set
against doing so.

-Manish
