From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 19 Mar 2010 18:27:48 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] Ocfs2: Journaling i_flags and
 i_orphaned_slot when adding inode to orphan dir.
In-Reply-To: <1268961670-4712-1-git-send-email-tristan.ye@oracle.com>
References: <1268961670-4712-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <20100320012748.GJ15539@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Mar 19, 2010 at 09:21:09AM +0800, Tristan Ye wrote:
> Currently, some callers were missing to journal the dirty inode after
> adding it to orphan dir.
> 
> Now we're going to journal such modifications within the ocfs2_orphan_add()
> itself, It's safe to do so, though some existing caller may duplicate this,
> and it makes the logic look more straightforward anyway.
> 
> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>

	This patch has been added to the 'fixes' branch of ocfs2.git.
Can you go over the callers of ocfs2_orphan_add() to see if there is any
cleanup you can do?  Redundant dirty calls where nothing else is
dirtied, etc.  That cleanup will be a separate patch that I push to the
merge window when done.

Joel

-- 

 Joel's First Law:

	Nature abhors a GUI.

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
