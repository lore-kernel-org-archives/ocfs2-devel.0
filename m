From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 19 Feb 2009 09:35:15 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: anti stale inode for nfs (V3)
In-Reply-To: <499D5A42.90702@oracle.com>
References: <200902171255.n1HCsxeo017544@acsinet13.oracle.com>
	<20090218013700.GA26431@mail.oracle.com>
	<499D5A42.90702@oracle.com>
Message-ID: <20090219173515.GB15753@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Feb 19, 2009 at 09:10:26PM +0800, Wengang Wang wrote:
>> It will need to be added to debugfs.ocfs2's lock displays.
> what's this in detail?
> the display for "debugfs.ocfs2 -d <lockres>"? such as the rename lock
>
> [root at ocfs2-2 ~]# debugfs.ocfs2 -d R000000000000000000000000000000
> Lockres:    R000000000000000000000000000000
> Type:       Rename
> Block:      0
> Generation: 0x00000000

	Basically, libocfs2/lockid.c needs to be updated to understand
the new lock type.  debugfs should then be able to encode/decode the
lockres nicely.  You should be able to copy the behavior of the rename
lock just like you did in the kernel.

Joel

-- 

"I always thought the hardest questions were those I could not answer.
 Now I know they are the ones I can never ask."
			- Charlie Watkins

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
