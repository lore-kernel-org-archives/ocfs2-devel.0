From: Christoph Hellwig <hch@lst.de>
Date: Tue Apr 26 03:58:15 2005
Subject: [Ocfs2-devel] Re: [Ocfs2-commits] manish commits r2175 - in
	trunk/fs/ocfs2: . cluster dlm
In-Reply-To: <20050426084753.GA8236@ca-server1.us.oracle.com>
References: <200504260323.j3Q3NC9V013089@oss.oracle.com>
	<20050426071825.GA17901@lst.de>
	<20050426081538.GA6750@ca-server1.us.oracle.com>
	<20050426082033.GA18736@lst.de>
	<20050426084753.GA8236@ca-server1.us.oracle.com>
Message-ID: <20050426085537.GA19262@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Apr 26, 2005 at 01:47:53AM -0700, Manish Singh wrote:
> Perhaps they should be in some common place then? The kernel could
> provide the C99 macros for dealing with explicitly sized types.

I don't think we wanted this, but feel free to bring it up on lkml
again.

> It sounds like the reason it doesn't exist already is simply because
> nobody has done it yet. Printing 64-bit types in non-arch specific code
> is rare in the current kernel tree,

There are lots of places printinkg 64bit values in filesystem and block
layer code.
