From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 13 May 2010 16:44:24 -0700
Subject: [Ocfs2-devel] [PATCH 1/7] quota: Refactor dquot_transfer code
 so that OCFS2 can pass in its references
In-Reply-To: <1273780683-3638-2-git-send-email-jack@suse.cz>
References: <1273780683-3638-1-git-send-email-jack@suse.cz>
	<1273780683-3638-2-git-send-email-jack@suse.cz>
Message-ID: <20100513234424.GC13692@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, May 13, 2010 at 09:57:57PM +0200, Jan Kara wrote:
> Currently, __dquot_transfer() acquires its own references of dquot structures
> that will be put into inode. But for OCFS2, this creates a lock inversion
> between dq_lock (waited on in dqget) and transaction start (started in
> ocfs2_setattr). Currently, deadlock is impossible because dq_lock is acquired
> only during dquot_acquire and dquot_release and we already hold a reference to
> dquot structures in ocfs2_setattr so neither of these functions can be called
> while we call dquot_transfer. But this is rather subtle and it is hard to teach
> lockdep about it. So provide __dquot_transfer function that can be passed dquot
> references directly. OCFS2 can then pass acquired dquot references directly to
> __dquot_transfer with proper locking.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

	I like this patch.  Very clean solution.

Joel

-- 

"You don't make the poor richer by making the rich poorer."
	- Sir Winston Churchill

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
