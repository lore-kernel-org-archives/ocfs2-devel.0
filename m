From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 5 May 2010 18:36:55 -0700
Subject: [Ocfs2-devel] [PATCH 00/17 V2] ocfs2: Support for discontiguous
	block group.
In-Reply-To: <4BCFEF22.7080607@oracle.com>
References: <4BCFEF22.7080607@oracle.com>
Message-ID: <20100506013654.GC9955@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Apr 22, 2010 at 02:39:30PM +0800, Tao Ma wrote:
> Hi all,
> 	This is the v2 of discontiguous block group support in ocfs2.

Hey Tao,
	 Your current discontig-bg branch at oss doesn't pull cleanly
against merge-window.  I was trying to pull it into ALL for visibility.
;-)  I hope to have it in 2.6.35, so it will go atop the current
merge-window stuff anyway.  Can you rebase atop that?  I think the code
is in good shape aside from any bugs found in testing.

Joel

-- 

Life's Little Instruction Book #347

	"Never waste the oppourtunity to tell someone you love them."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
