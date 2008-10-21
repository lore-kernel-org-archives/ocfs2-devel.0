From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 21 Oct 2008 10:29:57 -0700
Subject: [Ocfs2-devel] [PATCH] quota: Remove bogus 'optimization'
	in	check_idq() and check_bdq()
In-Reply-To: <1224523440201-git-send-email-jack@suse.cz>
References: <1224523440201-git-send-email-jack@suse.cz>
Message-ID: <20081021172956.GB10060@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Oct 20, 2008 at 07:23:36PM +0200, Jan Kara wrote:
> Checks like <= 0 for an unsigned type do not make much sence. The value
> could be only 0 and that does not happen often enough for the check
> to be worth it.

	Why not worth it?  Certainly the '<' isn't valid, but is it even
possible to call these functions with 0?  I don't know enough to answer
that, but I'm wondering if it should BUG_ON(inodes == 0).  If not, what
happens after this change?  Obviously inodes==0 means the quota doesn't
change, but could they get a soft warning they wouldn't get before?

Joel

-- 

Life's Little Instruction Book #222

	"Think twice before burdening a friend with a secret."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
