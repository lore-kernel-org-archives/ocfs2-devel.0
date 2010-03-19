From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 19 Mar 2010 15:43:10 -0700
Subject: [Ocfs2-devel] [PATCH 3/5] ocfs2: use allocation reservations
 for directory data
In-Reply-To: <1268809154-1020-4-git-send-email-mfasheh@suse.com>
References: <1268809154-1020-1-git-send-email-mfasheh@suse.com>
	<1268809154-1020-4-git-send-email-mfasheh@suse.com>
Message-ID: <20100319224310.GF15539@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Mar 16, 2010 at 11:59:12PM -0700, Mark Fasheh wrote:
> Use the reservations system for unindexed dir tree allocations. We
> don't bother with the indexed tree as reads from it are mostly random
> anyway. By default this behavior is turned off and can be turned on
> via mount option 'dir_resv'. Workloads which create many large
> directories will want to turn it on.
> 
> A future improvement will be to use a different window size for
> directory inodes. Once done, we should change the default for this
> feature to be enabled.

	Why can't we turn this on and avoid a mount option?  Sure, the
reservation holds out some space, but it will be cannibalized if
the directory doesn't grow, right?

Joel

-- 

"I inject pure kryptonite into my brain.
 It improves my kung fu, and it eases the pain."


Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
