From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Mar 24 21:17:07 2004
Subject: [Ocfs2-devel] [CRASH]Oops in journal_wip on first mount
In-Reply-To: <20040324015604.GA13687@penguin.co.intel.com>
References: <200403240138.i2O1cm5n013594@penguin.co.intel.com>
	<20040324015604.GA13687@penguin.co.intel.com>
Message-ID: <20040325031658.GM10672@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Mar 23, 2004 at 05:56:04PM -0800, Rusty Lynch wrote:
> Small update... I just pulled an older svn tree (version 798, the version
> that the OCFS_VERSION_2_BETA_2 tag was laid down), and the older version
> does not have the problem.
> 
> I can then go and load the version 807 module again, and attempt to mount
> the volume again to see the Oops once again. So... first time mount doesn't
> seem to matter.
Ok, I'm not seeing this at all :(
Can you assert on osb->journal.k_journal != NULL before the call to
ocfs_journal_wipe... I wonder if somehow it's not being initialized
properly.
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
