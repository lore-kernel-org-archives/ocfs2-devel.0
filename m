From: Louis Rilling <Louis.Rilling@kerlabs.com>
Date: Mon, 23 Jun 2008 14:05:49 +0200
Subject: [Ocfs2-devel] [PATCH] configfs: Fix failing symlink() making
	rmdir() fail
In-Reply-To: <20080620224420.GF21416@mail.oracle.com>
References: <20080619221605.GE10888@mail.oracle.com>
	<1213963762-11678-1-git-send-email-louis.rilling@kerlabs.com>
	<20080620224420.GF21416@mail.oracle.com>
Message-ID: <20080623120548.GT30804@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Fri, Jun 20, 2008 at 03:44:20PM -0700, Joel Becker wrote:
> On Fri, Jun 20, 2008 at 02:09:22PM +0200, Louis Rilling wrote:
> > What about this other solution? By the way, it does not even need to
> > rename CONFIGFS_USET_IN_MKDIR.
> 
> 	We don't need the check for USET_DROPPING either.  I like a lot!

I hope that you wasn't speaking about checking USET_DROPPING on the target. We
still need to check it, of course. I'm resending the updated, hopefully final,
patchset.

Louis

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes
-------------- next part --------------
A non-text attachment was scrubbed...
Name: not available
Type: application/pgp-signature
Size: 189 bytes
Desc: Digital signature
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080623/34c3ad8e/attachment.bin 
