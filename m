From: Christoph Hellwig <hch@lst.de>
Date: Tue Apr 26 03:25:29 2005
Subject: [Ocfs2-devel] Re: [Ocfs2-commits] manish commits r2175 - in
	trunk/fs/ocfs2: . cluster dlm
In-Reply-To: <20050426081538.GA6750@ca-server1.us.oracle.com>
References: <200504260323.j3Q3NC9V013089@oss.oracle.com>
	<20050426071825.GA17901@lst.de>
	<20050426081538.GA6750@ca-server1.us.oracle.com>
Message-ID: <20050426082033.GA18736@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Apr 26, 2005 at 01:15:38AM -0700, Manish Singh wrote:
> > Standard kernel practice is to cast a u64 to unsigned long (and a s64 to
> > long), and not using such obsfucation.  I'd strongly suggest to follow
> > that lead in ocfs.
> 
> I assume you meant to say "unsigned long long" and "long long".

Yes.

> The issue here is format string readability vs. printk argument
> readability. Both magic format defines and verbose (unsigned long long)
> casts make the code harder to read. Why is format string readability
> preferred?

I don't know ;-)  But if magic format strings we preferred we'd have
them in a common place.
