From: Joel Becker <jlbec@evilplan.org>
Date: Thu, 17 Nov 2011 00:35:11 -0800
Subject: [Ocfs2-devel] [PATCH] vfs: Correctly set the dir i_mutex
	lockdep class
In-Reply-To: <20111110152848.GA5421@boyd>
References: <1320907500-3767-1-git-send-email-tyhicks@canonical.com>
	<20111110143319.GB26644@quack.suse.cz> <20111110152848.GA5421@boyd>
Message-ID: <20111117083510.GA7319@noexit.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tyler Hicks <tyhicks@canonical.com>
Cc: John Johansen <john.johansen@canonical.com>, Jan Kara <jack@suse.cz>, Josh Boyer <jwboyer@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Mark Fasheh <mfasheh@suse.com>, Ingo Molnar <mingo@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Thu, Nov 10, 2011 at 09:28:49AM -0600, Tyler Hicks wrote:
> On 2011-11-10 15:33:19, Jan Kara wrote:
> > On Thu 10-11-11 00:45:00, Tyler Hicks wrote:
> > > This patch removes the negation from the conditional so that the i_mutex
> > > lockdep class is properly set for directory inodes. Special classes are
> > > preserved and directory inodes with unmodified classes are set with
> > > i_mutex_dir_key.
> >   Duh, you are right. I wonder how come this did not trigger any lockdep
> > messages during my testing with ocfs2 for which I wrote the patch...
> 
> Good question. Adding the ocfs2 maintainers and devel list to cc, as
> this patch is likely to change up their lockdep warnings.

	We don't set special classes for dir->i_mutex.  We set special
classes on our DLM stuff, and we do it for our system files, but not for
regular directories.

Joel


-- 

Life's Little Instruction Book #356

	"Be there when people need you."

			http://www.jlbec.org/
			jlbec at evilplan.org
