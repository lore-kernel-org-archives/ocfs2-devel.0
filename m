From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 11 Aug 2010 17:32:42 -0700
Subject: [Ocfs2-devel] [PATCH 1/2 v3] ocfs2: Flush drive's caches on
	fdatasync
In-Reply-To: <1281033166-12485-2-git-send-email-jack@suse.cz>
References: <1281033166-12485-1-git-send-email-jack@suse.cz>
	<1281033166-12485-2-git-send-email-jack@suse.cz>
Message-ID: <20100812003241.GE8985@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Aug 05, 2010 at 08:32:45PM +0200, Jan Kara wrote:
> When 'barrier' mount option is specified, we have to issue a cache flush
> during fdatasync(2). We have to do this even if inode doesn't have
> I_DIRTY_DATASYNC set because we still have to get written *data* to disk so
> that they are not lost in case of crash.
> 
> Acked-by: Tao Ma <tao.ma@oracle.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

        This patch is now in the merge-window branch of ocfs2.git

Joel

-- 

Life's Little Instruction Book #335

	"Every so often, push your luck."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
