From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 20 Jul 2009 17:28:22 -0700
Subject: [Ocfs2-devel] [PATCH] Fix compilation warning for
	fs/ocfs2/xattr.c
In-Reply-To: <20090713194928.32372.56679.sendpatchset@subratamodak.linux.ibm.com>
References: <20090713194928.32372.56679.sendpatchset@subratamodak.linux.ibm.com>
Message-ID: <20090721002822.GB9183@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Subrata Modak <subrata@linux.vnet.ibm.com>
Cc: ocfs2-devel@oss.oracle.com, Mark Fasheh <mfasheh@suse.com>, Sachin P Sant <sachinp@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, Balbir Singh <balbir@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>

On Tue, Jul 14, 2009 at 01:19:31AM +0530, Subrata Modak wrote:
> gcc 4.4.1 generates the following build warning on i386:
> 
> CC [M]  fs/ocfs2/xattr.o
> fs/ocfs2/xattr.c: In function ?ocfs2_xattr_block_get?:
> fs/ocfs2/xattr.c:1055: warning: ?block_off? may be used uninitialized in this function
> 
> The following fix is based on a similar approach by David Howells
> few days back: http://lkml.org/lkml/2009/7/9/109,
> 
> Signed-off-by: Subrata Modak<subrata@linux.vnet.ibm.com>,

	This is now in the fixes branch of ocfs2.git.

Joel

-- 

Life's Little Instruction Book #15

	"Own a great stereo system."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
