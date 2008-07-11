From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 10 Jul 2008 17:46:19 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: Adds counter in
	struct	ocfs2_dinode to track journal replays
In-Reply-To: <20080711003113.GE32459@wotan.suse.de>
References: <1215731871-17351-1-git-send-email-sunil.mushran@oracle.com>
	<1215731871-17351-2-git-send-email-sunil.mushran@oracle.com>
	<20080711001544.GG11809@mail.oracle.com>
	<20080711003113.GE32459@wotan.suse.de>
Message-ID: <20080711004619.GJ11809@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jul 10, 2008 at 05:31:13PM -0700, Mark Fasheh wrote:
> On Thu, Jul 10, 2008 at 05:15:44PM -0700, Joel Becker wrote:
> And use the full word, "recovery"! If we can't stand the extra bytes, then
> how about "ij_recovery_count", which is actually 1 byte shorter than
> "ij_reco_generation" anyway...

	Hehe!  I told him to use 'generation' because 'count' made me
think was talking about something else :-)
	I don't care really, I agree that spelling it out is good for
something used in only a small bit of code.  Pick either name
(ij_recovery_generation or ij_recovery_count) and go with it.

Joel

-- 

Life's Little Instruction Book #497

	"Go down swinging."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
