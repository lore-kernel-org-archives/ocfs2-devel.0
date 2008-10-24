From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 24 Oct 2008 14:42:14 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix checking of return value
	of	new_inode()
In-Reply-To: <20081021203503.GE2871@mail.oracle.com>
References: <12245234434014-git-send-email-jack@suse.cz>
	<20081021203503.GE2871@mail.oracle.com>
Message-ID: <20081024214214.GD9302@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Oct 21, 2008 at 01:35:03PM -0700, Joel Becker wrote:
> On Mon, Oct 20, 2008 at 07:23:53PM +0200, Jan Kara wrote:
> > new_inode() does not return ERR_PTR() but NULL in case of failure. Correct
> > checking of the return value.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
> 
> Another upstream candidate.

	This is now in my xattr-28 branch.

Joel

-- 

Life's Little Instruction Book #139

	"Never deprive someone of hope; it might be all they have."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
