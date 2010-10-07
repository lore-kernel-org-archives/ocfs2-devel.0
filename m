From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 7 Oct 2010 15:38:39 -0700
Subject: [Ocfs2-devel] odirect hack
In-Reply-To: <4CA65C29.7030001@oracle.com>
References: <4CA65C29.7030001@oracle.com>
Message-ID: <20101007223838.GI8031@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Oct 01, 2010 at 03:09:45PM -0700, Sunil Mushran wrote:
> I was discussing with Joel whether it was time for us to special
> case the odirect hack we've had since day 1. The one that allows
> concurrent odirect writes.

Right.


> I am wondering whether we should allow users control that behavior
> via a mount option. parallel_directio, maybe.

I think that's got a lot of usefulness, so yeah I'd definitely be behind
this. IMHO, we should take the opportunity to clearly define what it means
for the customer too:

"With this, parallel direct I/O from multiple nodes will be allowed. This
increases throughput on some workloads dramatically but at the expense of
inode mtime updates..." etc etc.
	--Mark

--
Mark Fasheh
