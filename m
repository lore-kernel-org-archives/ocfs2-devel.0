From: Theodore Ts'o <tytso@mit.edu>
Date: Sat Mar  6 15:30:34 2004
Subject: [Ocfs2-devel] Re: [PATCH] Adding ocfs support to blkid
In-Reply-To: <20040205014555.GA15920@penguin.co.intel.com>
References: <200402040838.i148cCqU002632@penguin.co.intel.com>
	<20040205010819.GC3605@thunk.org>
	<20040205014555.GA15920@penguin.co.intel.com>
Message-ID: <20040305010149.GA31727@thunk.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Feb 04, 2004 at 05:45:55PM -0800, Rusty Lynch wrote:
> Yea, the first 1k off the disk is all I need.  Here is a version that
> utilizes the passed in buffer and also contains changes for all previous 
> feedback.

Hi Rusty,

My apologies for the delay in getting back to you.  I had a trip to
Japan, and when I got back, I was so backlogged that applying this
patch fell off my TODO list.  It's been committed to the tree now.

						- Ted
