From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Jan  3 14:02:28 2008
Subject: [Ocfs2-devel] Re: [PATCH 1/7] ocfs2: Move slot map access into
	slot_map.c
In-Reply-To: <1199396425-7012-2-git-send-email-joel.becker@oracle.com>
References: <1199396425-7012-1-git-send-email-joel.becker@oracle.com>
	<1199396425-7012-2-git-send-email-joel.becker@oracle.com>
Message-ID: <20080103220056.GK23506@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jan 03, 2008 at 01:40:19PM -0800, Joel Becker wrote:
> From: Mark Fasheh <mark.fasheh@oracle.com>
> 
> journal.c and dlmglue.c would refresh the slot map by hand.  Instead, have
> the update and clear functions do the work inside slot_map.c.  The eventual
> result is to make ocfs2_slot_info defined privately in slot_map.c
> 
> Signed-off-by: Joel Becker <joel.becker@oracle.com>

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
