From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Mon Feb 23 17:52:42 2004
Subject: [Ocfs2-devel] [PATCH]2.6 fixes in super.c
In-Reply-To: <20040223234618.GB1421@ca-server1.us.oracle.com>
References: <200402180312.i1I3CH7Y015248@penguin.co.intel.com>
	<20040219233755.GA24928@penguin.co.intel.com>
	<20040223233523.GA1421@ca-server1.us.oracle.com>
	<20040223234618.GB1421@ca-server1.us.oracle.com>
Message-ID: <20040223235222.GA16485@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Feb 23, 2004 at 03:46:18PM -0800, Mark Fasheh wrote:
> Also, can we get rid of the rest of the LINUX_2_5 macros in super.c?  :)
> 	--Mark
> 

Can do.  The last comment was also on target... I think I pushed ocfs_statfs()
aside to quickly fix the compile error and never got back to it.

    --rusty
