From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 24 Oct 2008 14:42:30 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Let inode be really deleted
	when	ocfs2_mknod_locked() fails
In-Reply-To: <20081021203945.GF2871@mail.oracle.com>
References: <1224523443843-git-send-email-jack@suse.cz>
	<20081021203945.GF2871@mail.oracle.com>
Message-ID: <20081024214230.GE9302@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Oct 21, 2008 at 01:39:45PM -0700, Joel Becker wrote:
> On Mon, Oct 20, 2008 at 07:23:54PM +0200, Jan Kara wrote:
> > We forgot to set i_nlink to 0 when returning due to error from ocfs2_mknod_locked()
> > and thus inode was not properly released via ocfs2_delete_inode() (e.g. claimed
> > space was not released). Fix it.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
> 
> For upstream too.

	Also in my xattr-28 branch.

Joel

-- 

Life's Little Instruction Book #237

	"Seek out the good in people."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
