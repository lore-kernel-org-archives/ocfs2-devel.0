From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 10 Aug 2009 13:38:57 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix possible deadlock when
 extending quota file
In-Reply-To: <1249594174-1539-1-git-send-email-jack@suse.cz>
References: <1249594174-1539-1-git-send-email-jack@suse.cz>
Message-ID: <20090810203857.GE31168@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Aug 06, 2009 at 11:29:34PM +0200, Jan Kara wrote:
> In OCFS2, allocator locks rank above transaction start. Thus we
> cannot extend quota file from inside a transaction less we could
> deadlock.
> 
> We solve the problem by starting transaction not already in
> ocfs2_acquire_dquot() but only in ocfs2_local_read_dquot() and
> ocfs2_global_read_dquot() and we allocate blocks to quota files before starting
> the transaction.  In case we crash, quota files will just have a few blocks
> more but that's no problem since we just use them next time we extend the
> quota file.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

	This patch is now in the fixes branch of ocfs2.git.

Joel

-- 

Life's Little Instruction Book #43

	"Never give up on somebody.  Miracles happen every day."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
