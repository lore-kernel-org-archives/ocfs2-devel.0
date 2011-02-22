From: Joel Becker <jlbec@evilplan.org>
Date: Tue, 22 Feb 2011 00:15:31 -0800
Subject: [Ocfs2-devel] [PATCH 2/3] Ocfs2: Add a new code
 'OCFS2_INFO_FREEINODE' for o2info ioctl.
In-Reply-To: <4D636D87.9050306@oracle.com>
References: <1298350792-6734-1-git-send-email-tristan.ye@oracle.com>
	<20110222060913.GA30966@noexit> <4D636D87.9050306@oracle.com>
Message-ID: <20110222081530.GB30966@noexit>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Feb 22, 2011 at 04:02:15PM +0800, Tristan Ye wrote:
>     Thanks for putting forward the point. I'm afraid that I'm not an 
> enough experienced
> user to talk issues on 'GFP_NOFS VS GFP_KERNEL' too much;-)
>    
>     Per my understanding, can the GFP_NOFS become a real overkill when 
> claiming around 2k memory?
> Having known that GFP_NOFS is more restrictive and more secure to 
> filesystem code for avoiding potential
> deadlock, do we really need to use GFP_KERNEL instead of GFP_NOFS there?

	In general, we should use the least restrictive mode that is
safe.  GFP_KERNEL tries the hardest to get memory, and it sleeps the
most, but it therefore gives the user the fewest ENOMEMs.

>     Btw, is there a explicit rule/convention on when to use GFP_NOFS or 
> GFP_KERNEL? e.g:

	One uses GFP_NOFS when filesystem writeback cannot be used to
free memory.  So if you're in the ocfs2 writeback code, you can't have
an allocation try to start writeback ;-)  That's why you use GFP_NOFS.
	When you are holding no locks, and blocking nothing related to
writeout, there is no reason to limit yourself.

Joel

-- 

Life's Little Instruction Book #197

	"Don't forget, a person's greatest emotional need is to 
	 feel appreciated."

			http://www.jlbec.org/
			jlbec at evilplan.org
