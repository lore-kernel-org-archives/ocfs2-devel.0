From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Jan  3 14:22:57 2008
Subject: [Ocfs2-devel] [PATCH 2/7] ocfs2: Make ocfs2_slot_info private.
In-Reply-To: <1199396425-7012-3-git-send-email-joel.becker@oracle.com>
References: <1199396425-7012-1-git-send-email-joel.becker@oracle.com>
	<1199396425-7012-3-git-send-email-joel.becker@oracle.com>
Message-ID: <20080103222207.GL23506@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jan 03, 2008 at 01:40:20PM -0800, Joel Becker wrote:
> Just use osb_lock around the ocfs2_slot_info data.  This allows us to
> take the ocfs2_slot_info structure private in slot_info.c.  All access
> is now via accessors.
> 
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
