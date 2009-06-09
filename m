From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 9 Jun 2009 10:05:24 -0700
Subject: [Ocfs2-devel] [PATCH 0/7] [RESEND] Fix some deadlocks in quota
	code and	implement lockdep for cluster locks
In-Reply-To: <20090604100936.GA2859@duck.suse.cz>
References: <1243945445-25847-1-git-send-email-jack@suse.cz>
	<20090604022646.GF7933@mail.oracle.com>
	<20090604100936.GA2859@duck.suse.cz>
Message-ID: <20090609170524.GB28311@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jun 04, 2009 at 12:09:36PM +0200, Jan Kara wrote:
> On Wed 03-06-09 19:26:46, Joel Becker wrote:
> > 	The fixes are now in the merge-window branch of ocfs2.git.  They
> > also live on the quota-fixes topic branch.  The lockdep changes still
> > need some marinating.
>   Thanks. With lockdep patch, there's this 'ip' parameter thing causing
> ifdefs but after we agree how to resolve this, it can go into linux-next
> branch, right?

	Yeah.  I'm going to hold off on merging it until the 2.6.32
window so that it can get some testing, as it's a significant change to
our locking code.  The rest of the fixes are going for 2.6.31.

Joel

-- 

"Sometimes when reading Goethe I have the paralyzing suspicion
 that he is trying to be funny."
         - Guy Davenport

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
