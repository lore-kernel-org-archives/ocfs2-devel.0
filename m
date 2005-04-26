From: Manish Singh <manish.singh@oracle.com>
Date: Tue Apr 26 03:18:36 2005
Subject: [Ocfs2-devel] Re: [Ocfs2-commits] manish commits r2175 - in
	trunk/fs/ocfs2: . cluster dlm
In-Reply-To: <20050426071825.GA17901@lst.de>
References: <200504260323.j3Q3NC9V013089@oss.oracle.com>
	<20050426071825.GA17901@lst.de>
Message-ID: <20050426081538.GA6750@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Apr 26, 2005 at 09:18:26AM +0200, Christoph Hellwig wrote:
> On Mon, Apr 25, 2005 at 10:23:12PM -0500, svn-commits@oss.oracle.com wrote:
> > Log:
> > Define MLFu64 and friends, for portable format strings for sized 64-bit types.
> > This gets rid of the tons on warnings on ia64 and ppc64.
> 
> Standard kernel practice is to cast a u64 to unsigned long (and a s64 to
> long), and not using such obsfucation.  I'd strongly suggest to follow
> that lead in ocfs.

I assume you meant to say "unsigned long long" and "long long".

The issue here is format string readability vs. printk argument
readability. Both magic format defines and verbose (unsigned long long)
casts make the code harder to read. Why is format string readability
preferred?

The nice thing about Documentation/CodingStyle is that it provides
cogent rationales for each of coding style precepts. I'm perfectly
willing to entertain the idea that magic format defines are horrible,
but having a good "why" helps the idea take root.


-Manish
