From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Thu Feb  5 01:59:47 2004
Subject: [Ocfs2-devel] [PATCH] Adding ocfs support to blkid
In-Reply-To: <20040204233149.GA25620@ca-server1.us.oracle.com>
References: <200402040838.i148cCqU002632@penguin.co.intel.com>
	<20040204185952.GA13452@ca-server1.us.oracle.com>
	<20040204233149.GA25620@ca-server1.us.oracle.com>
Message-ID: <20040205001132.GA12919@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Feb 04, 2004 at 03:31:49PM -0800, Manish Singh wrote:
> On Wed, Feb 04, 2004 at 10:59:52AM -0800, Mark Fasheh wrote:
> > Could we call it "ocfs" instead of "ocfs2" below? We will likely be bumping
> > up the version number in the header for ocfs version 2 when it's released.
> 
> Yeah, call it "ocfs" and set SEC_TYPE to "ocfs1", "ocfs2", and "ntocfs"
> for version 1, version 2, and windows ocfs, respectively. For ocfs1 the
> major version is 1, ocfs2 is 2, and ntocfs it's >= 9.

The current ocfs2 code has major=1 and minor=2... is the increase of the
major number just not done yet, or did you mean to switch off the minor?

    --rusty 
