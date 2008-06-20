From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 20 Jun 2008 15:44:20 -0700
Subject: [Ocfs2-devel] [PATCH] configfs: Fix failing symlink() making
	rmdir() fail
In-Reply-To: <1213963762-11678-1-git-send-email-louis.rilling@kerlabs.com>
References: <20080619221605.GE10888@mail.oracle.com>
	<1213963762-11678-1-git-send-email-louis.rilling@kerlabs.com>
Message-ID: <20080620224420.GF21416@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Louis Rilling <louis.rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Fri, Jun 20, 2008 at 02:09:22PM +0200, Louis Rilling wrote:
> What about this other solution? By the way, it does not even need to
> rename CONFIGFS_USET_IN_MKDIR.

	We don't need the check for USET_DROPPING either.  I like a lot!

Joel

-- 

"I don't want to achieve immortality through my work; I want to
 achieve immortality through not dying."
        - Woody Allen

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
