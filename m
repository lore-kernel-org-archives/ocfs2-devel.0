From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Feb 24 16:20:52 2004
Subject: [Ocfs2-devel] Re: [PATCH]2.6 fixes in hash.c
In-Reply-To: <200402241629.i1OGTUxx023956@penguin.co.intel.com>
References: <200402241629.i1OGTUxx023956@penguin.co.intel.com>
Message-ID: <20040224222048.GM1421@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Feb 24, 2004 at 08:29:30AM -0800, Rusty Lynch wrote:
> I still have a few items missing to enable a clean compile against
> a 2.6 kernel.  The following is a patch to hash.c that:
> 
> * kicks off the block-io run queues in the new non-task_queue 
>   oriented way
> * utilizes the new io_schedule() method
Committed.
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
