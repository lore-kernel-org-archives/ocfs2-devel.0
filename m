From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Mar 24 16:37:06 2004
Subject: [Ocfs2-devel] [PATCH]Enable 2.6 file data flushing
In-Reply-To: <20040324055857.GA14337@penguin.co.intel.com>
References: <200403240411.i2O4BrRr014124@penguin.co.intel.com>
	<20040324042306.GE1516@ca-server1.us.oracle.com>
	<20040324055857.GA14337@penguin.co.intel.com>
Message-ID: <20040324223658.GG10672@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Mar 23, 2004 at 09:58:57PM -0800, Rusty Lynch wrote:
> the equivilant call in 2.4 would be filemap_fdatasync().  I gave it a 
> try and it does fix the mmap issue talked about in bug #50.
Ok, excellent. I verified that this bug does indeed exist, and the patch
seems to fix it. I'll put it in SVN today. Nice catch Rusty!
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
