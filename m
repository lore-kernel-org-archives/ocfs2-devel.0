From: Joel Becker <jlbec@evilplan.org>
Date: Thu, 2 May 2013 15:00:31 -0700
Subject: [Ocfs2-devel] [PATCH v3 06/18] ocfs2: use ->invalidatepage()
	length argument
In-Reply-To: <20130423141604.GE31170@thunk.org>
References: <1365498867-27782-1-git-send-email-lczerner@redhat.com>
	<1365498867-27782-7-git-send-email-lczerner@redhat.com>
	<20130423141604.GE31170@thunk.org>
Message-ID: <20130502220030.GC26770@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>, Lukas Czerner <lczerner@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com

Acked-by: Joel Becker <jlbec@evilplan.org>

On Tue, Apr 23, 2013 at 10:16:04AM -0400, Theodore Ts'o wrote:
> On Tue, Apr 09, 2013 at 11:14:15AM +0200, Lukas Czerner wrote:
> > ->invalidatepage() aop now accepts range to invalidate so we can make
> > use of it in ocfs2_invalidatepage().
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > Cc: Joel Becker <jlbec@evilplan.org>
> 
> +Mark Fasheh, ocfs2-devel
> 
> To the ocfs2 development team,
> 
> Since half of this patch series modifies ext4 extensively, and changes
> to the other file systems are relatively small, I plan to carry the
> invalidatepage patch set in the ext4 tree for the next development
> cycle (i.e., not the upcoming merge window, but the next one).  To
> that end, it would be great if you take a look at this patch set and
> send us an Acked-by signoff.
> 
> Thanks!!
> 
> 						- Ted

-- 

"Ninety feet between bases is perhaps as close as man has ever come
 to perfection."
	- Red Smith

			http://www.jlbec.org/
			jlbec at evilplan.org
