From: Tristan Ye <tristan.ye@oracle.com>
Date: Tue, 22 Feb 2011 16:02:15 +0800
Subject: [Ocfs2-devel] [PATCH 2/3] Ocfs2: Add a new code
 'OCFS2_INFO_FREEINODE' for o2info ioctl.
In-Reply-To: <20110222060913.GA30966@noexit>
References: <1298350792-6734-1-git-send-email-tristan.ye@oracle.com>
	<20110222060913.GA30966@noexit>
Message-ID: <4D636D87.9050306@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Tue, Feb 22, 2011 at 12:59:51PM +0800, Tristan Ye wrote:
>> +	oifi = kzalloc(sizeof(struct ocfs2_info_freeinode), GFP_NOFS);
>
> 	Why NOFS?  Are we under any filesystem locks?  I'm pretty sure
> this is the first thing you do for this operation, so why wouldn't
> GFP_KERNEL work?

Joel,

    Thanks for putting forward the point. I'm afraid that I'm not an 
enough experienced
user to talk issues on 'GFP_NOFS VS GFP_KERNEL' too much;-)
   
    Per my understanding, can the GFP_NOFS become a real overkill when 
claiming around 2k memory?
Having known that GFP_NOFS is more restrictive and more secure to 
filesystem code for avoiding potential
deadlock, do we really need to use GFP_KERNEL instead of GFP_NOFS there?

    Btw, is there a explicit rule/convention on when to use GFP_NOFS or 
GFP_KERNEL? e.g:

*) Use GFP_NOFS after some locks being held.
*) Use GFP_NOFS in functions which are called by filesystems?


Regards,
Tristan

>
> Joel
>
