From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Mon, 13 Apr 2015 14:48:51 +0300
Subject: [Ocfs2-devel] vfs: Add general support to enforce project quota
	limits
In-Reply-To: <20150413101016.GB3633@quack.suse.cz>
References: <20150409193954.GA19913@mwanda>
	<20150413101016.GB3633@quack.suse.cz>
Message-ID: <20150413114851.GP16501@mwanda>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Ah.  Thanks for looking into it.  Smatch can't understand bit flags like
that yet.  And it also still doesn't track pointers very well.
Eventually those things will be improved.

I see now that this out of bounds is also prevented in
vfs_load_quota_inode().  We don't allow "(type == PRJQUOTA &&
sb->dq_op->get_projid == NULL)".  Since, ->get_projid() is always NULL
for OCFS2 that means "type" can't equal to PRJQUOTA (2).

Hm..  is ->get_projid set anywhere?  Cscope and smatch can't find it if
it is.

I haven't investigated v1_read_file_info() but presumably it's the same.

regards,
dan carpenter
