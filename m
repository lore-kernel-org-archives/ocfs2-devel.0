From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 5 May 2009 16:12:16 -0700
Subject: [Ocfs2-devel] [RFC][PATCH] masklog: update comments in	masklog.h
In-Reply-To: <4A002B10.1070004@suse.de>
References: <4A002B10.1070004@suse.de>
Message-ID: <20090505231216.GU7835@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, May 05, 2009 at 08:03:28PM +0800, Coly Li wrote:
> In upstream ocfs2 code, /proc interface for mask log is updated into files under
> /sys/fs/o2cb/masklog, comments in fs/ocfs2/cluster/masklog.h are out of date.
> 
> This patch modifies the commens in cluster/masklog.h, which also provides a bash
> script example on how to change the log mask bits.
> 
> Signed-off-by: Coly Li <coly.li@suse.de>

	This is in 'fixes' now with the addition of the 'debugfs.ocfs2
-l' syntax to the comment.

Joel
-- 

The Graham Corollary:

	The longer a socially-moderated news website exists, the
	probability of an old Paul Graham link appearing at the top
	approaches certainty.

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
