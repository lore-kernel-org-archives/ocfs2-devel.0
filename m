From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon May 24 20:40:43 2004
Subject: [Ocfs2-devel] [Patch] Patch to fix OCFS bug 73 and 74.
In-Reply-To: <37FBBA5F3A361C41AB7CE44558C3448E03B65ED0@PDSMSX403.ccr.corp.intel.com>
References: <37FBBA5F3A361C41AB7CE44558C3448E03B65ED0@PDSMSX403.ccr.corp.intel.com>
Message-ID: <20040525014036.GR879@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, May 25, 2004 at 08:20:13AM +0800, Zhang, Sonic wrote:
> 	After investigate in the JBD code in kernel 2.6.6 and OCFS2 svn
> 929 on IPF, I think I find the cause of dead lock bug 73 and 74.
> 
> 	In kernel 2.6.6, the bit 12 to 19 of variable b_state in
> structure buffer_head is occupied by the linux journaling code as
> follows.

	Yeah, we saw that already, and I've managed to fail to commit
the change.  Anyway, this is something that cannot depend on JBD numbers
or anything, we just have to be vigilant wrt BH_flags.  I'll commit.

Joel

-- 

"Win95 file and print sharing are for relatively friendly nets."
	- Paul Leach, Microsoft

Joel Becker
Senior Member of Technical Staff
Oracle Corporation
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
