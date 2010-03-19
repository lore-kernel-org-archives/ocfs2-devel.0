From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 19 Mar 2010 16:54:08 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] Ocfs2: Journaling i_flags and
 i_orphaned_slot when adding inode to orphan dir.
In-Reply-To: <20100319234246.GI11402@wotan.suse.de>
References: <1268961670-4712-1-git-send-email-tristan.ye@oracle.com>
	<20100319234246.GI11402@wotan.suse.de>
Message-ID: <20100319235407.GG15539@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Mar 19, 2010 at 04:42:46PM -0700, Mark Fasheh wrote:
> On Fri, Mar 19, 2010 at 09:21:09AM +0800, Tristan Ye wrote:
> > Currently, some callers were missing to journal the dirty inode after
> > adding it to orphan dir.
> > 
> > Now we're going to journal such modifications within the ocfs2_orphan_add()
> > itself, It's safe to do so, though some existing caller may duplicate this,
> > and it makes the logic look more straightforward anyway.
> > 
> > Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
> 
> I would have liked to see if any of the callers could be cleaned up.
> Otherwise though, this patch looks good and it fixes a bug :)

	Let's call this the fix and expect the followup.

Joel

-- 

"Anything that is too stupid to be spoken is sung."  
        - Voltaire

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
