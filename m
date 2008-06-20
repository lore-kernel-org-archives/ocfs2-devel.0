From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 20 Jun 2008 15:42:42 -0700
Subject: [Ocfs2-devel] [PATCH] configfs: Fix failing symlink() making
	rmdir() fail
In-Reply-To: <1213963762-11678-1-git-send-email-louis.rilling@kerlabs.com>
References: <20080619221605.GE10888@mail.oracle.com>
	<1213963762-11678-1-git-send-email-louis.rilling@kerlabs.com>
Message-ID: <20080620224242.GE21416@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Louis Rilling <louis.rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Fri, Jun 20, 2008 at 02:09:22PM +0200, Louis Rilling wrote:
> What about this other solution? By the way, it does not even need to
> rename CONFIGFS_USET_IN_MKDIR.

	I like it.  My first thought was "why doesn't he take the mutex
during configfs_unlink()?", but the unlink is protected enough by
dirent_lock.

Joel

-- 

"Reality is merely an illusion, albeit a very persistent one."
        - Albert Einstien

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
