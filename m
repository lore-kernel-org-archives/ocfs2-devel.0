From: Jan Kara <jack@suse.cz>
Date: Mon, 13 Apr 2015 14:19:00 +0200
Subject: [Ocfs2-devel] vfs: Add general support to enforce project quota
	limits
In-Reply-To: <20150413114851.GP16501@mwanda>
References: <20150409193954.GA19913@mwanda>
	<20150413101016.GB3633@quack.suse.cz>
	<20150413114851.GP16501@mwanda>
Message-ID: <20150413121900.GD3633@quack.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon 13-04-15 14:48:51, Dan Carpenter wrote:
> Ah.  Thanks for looking into it.  Smatch can't understand bit flags like
> that yet.  And it also still doesn't track pointers very well.
> Eventually those things will be improved.
> 
> I see now that this out of bounds is also prevented in
> vfs_load_quota_inode().  We don't allow "(type == PRJQUOTA &&
> sb->dq_op->get_projid == NULL)".  Since, ->get_projid() is always NULL
> for OCFS2 that means "type" can't equal to PRJQUOTA (2).
> 
> Hm..  is ->get_projid set anywhere?  Cscope and smatch can't find it if
> it is.
  Not yet. There are ext4 patches floating around that will use this.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
