From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 17 Jul 2008 15:30:18 -0700
Subject: [Ocfs2-devel] [git patches] Ocfs2 and Configfs updates
	for	2.6.27
In-Reply-To: <20080717214512.GB8283@ca-server1.us.oracle.com>
References: <20080717175146.GH28014@wotan.suse.de>
	<alpine.LFD.1.10.0807171056520.2959@woody.linux-foundation.org>
	<20080717212038.GA8283@ca-server1.us.oracle.com>
	<20080717214512.GB8283@ca-server1.us.oracle.com>
Message-ID: <20080717223018.GC8283@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>, Mark Fasheh <mfasheh@suse.com>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Andrew Morton <akpm@linux-foundation.org>

On Thu, Jul 17, 2008 at 02:45:12PM -0700, Joel Becker wrote:
> On Thu, Jul 17, 2008 at 02:20:38PM -0700, Joel Becker wrote:
> > On Thu, Jul 17, 2008 at 11:01:40AM -0700, Linus Torvalds wrote:
> > > I pulled it, but I want to register my protest.
> > 
> > 	I wish you hadn't, because it won't be to difficult to go back
> > to PTR_ERR().  However, don't revert it - that affects some of the
> > follow-on patches that were affected by the change.
> 
> 	I lied.  I'll cleanup the fallout.  You can revert it or wait
> for my revert + PTR_ERR.  Let me know if you revert it.

Linus,
	Pull this to get the revert and the PTR_ERR() version:

git://oss.oracle.com/git/jlbec/linux-2.6.git configfs-fixup-ptr-error

It's tested with the same testing I did before - ocfs2 and netconsole.

Joel

-- 

"But all my words come back to me
 In shades of mediocrity.
 Like emptiness in harmony
 I need someone to comfort me."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
