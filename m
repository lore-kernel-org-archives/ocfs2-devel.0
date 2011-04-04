From: Joel Becker <jlbec@evilplan.org>
Date: Mon, 4 Apr 2011 10:51:50 -0700
Subject: [Ocfs2-devel] [PATCH 3/3] Ocfs2: Cleanup for OCFS2_IOC_RESVSP &
 OCFS2_IOC_UNRESVSP.
In-Reply-To: <4D94EE85.1010808@oracle.com>
References: <1301556866-8460-1-git-send-email-tristan.ye@oracle.com>
	<1301556866-8460-3-git-send-email-tristan.ye@oracle.com>
	<4D94EE85.1010808@oracle.com>
Message-ID: <20110404175150.GB17656@noexit>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Mar 31, 2011 at 02:13:41PM -0700, Sunil Mushran wrote:
> On 03/31/2011 12:34 AM, Tristan Ye wrote:
> >Given that VFS has alreay supported an entry to handle the unwritten_extents
> >and punching-hole(is to be supported) by filp->f_op->fallocate(), our path of
> >OCFS2_IOC_RESVSP becomes a bit redundant somehow, especially given the fact
> >that ocfs2_fallocate() is working well.

Josef is planning to genericize the RESVP code via fallocate().  Let's
wait until he is done to clean up our side.

Joel

-- 

"But then she looks me in the eye
 And says, 'We're going to last forever,'
 And man you know I can't begin to doubt it.
 Cause it just feels so good and so free and so right,
 I know we ain't never going to change our minds about it, Hey!
 Here comes my girl."

			http://www.jlbec.org/
			jlbec at evilplan.org
