From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 30 Jan 2009 17:37:18 -0800
Subject: [Ocfs2-devel] [PATCH 7/7] ocfs2: add quota call to
	ocfs2_remove_btree_range()
In-Reply-To: <1233351753-14640-8-git-send-email-mfasheh@suse.com>
References: <1233351753-14640-1-git-send-email-mfasheh@suse.com>
	<1233351753-14640-8-git-send-email-mfasheh@suse.com>
Message-ID: <20090131013718.GG6155@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jan 30, 2009 at 01:42:33PM -0800, Mark Fasheh wrote:
> We weren't reclaiming the clusters which get free'd from this function,
> so any user punching holes in a file would still have those bytes accounted
> against him/her. Add the call to vfs_dq_free_space_nodirty() to fix this.
> Interestingly enough, the journal credits calculation already took this into
> account.
> 
> Cc: Jan Kara <jack@suse.cz>
> Signed-off-by: Mark Fasheh <mfasheh@suse.com>

Looks good to me, though I think it's for Jan's Ack.

Joel

-- 

"For every complex problem there exists a solution that is brief,
     concise, and totally wrong."
                                        -Unknown

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
