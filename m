From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 17 Feb 2010 20:05:15 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Add current->comm in trace output
In-Reply-To: <4B7C41CE.2020507@oracle.com>
References: <1266012546-13865-1-git-send-email-sunil.mushran@oracle.com>
	<20100217042908.GA13798@mail.oracle.com>
	<4B7C41CE.2020507@oracle.com>
Message-ID: <20100218040515.GB5215@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Feb 17, 2010 at 11:21:50AM -0800, Sunil Mushran wrote:
> Joel Becker wrote:
> >On Fri, Feb 12, 2010 at 02:09:06PM -0800, Sunil Mushran wrote:
> >>Add current->comm to the standard mlog() output to help with debugging.
> >>
> >>Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> >	Do you have sample output?  This could get long, no?
> 
> It is a bit longer. But it is much more readable.
> 
> (thisisalongname,16751,0):ocfs2_drop_lock:3202 EXIT: 0
> (thisisalongname,16751,0):ocfs2_lock_res_free:734 ENTRY:
> (thisisalongname,16751,0):ocfs2_lock_res_free:761 EXIT
> (kjournald2,16039,1):ocfs2_bmap:499 ENTRY:(block = 117)
> (kjournald2,16039,1):ocfs2_bmap:533 EXIT: 33493
> (kjournald2,16039,1):ocfs2_bmap:499 ENTRY:(block = 118)

	Yeah, this is nice.  It's now in the 'merge-window' branch of
ocfs2.git.

Joel

-- 

Life's Little Instruction Book #452

	"Never compromise your integrity."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
