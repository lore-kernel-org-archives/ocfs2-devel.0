From: Joe Perches <joe@perches.com>
Date: Fri, 27 Mar 2015 16:04:04 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: Neaten do_error,
 ocfs2_error and ocfs2_abort
In-Reply-To: <20150327151610.bcc26d7577d35ce636d21833@linux-foundation.org>
References: <cover.1427425496.git.joe@perches.com>
	<e05a1f6d65f0d6ff7f070f8dcb434129001986cf.1427425496.git.joe@perches.com>
	<20150327151610.bcc26d7577d35ce636d21833@linux-foundation.org>
Message-ID: <1427497444.24954.1.camel@perches.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Fri, 2015-03-27 at 15:16 -0700, Andrew Morton wrote:
> On Thu, 26 Mar 2015 20:07:08 -0700 Joe Perches <joe@perches.com> wrote:
> 
> > These uses sometimes do and sometimes don't have '\n' terminations.
> > Make the uses consistently use '\n' terminations and remove the
> > newline from the functions.
> 
> This is going to take a while to merge, as it's backed up behind a pile
> of needs-more-reviewing ocfs2 patches.

Thanks, no worries, this one's a trivial neatening patch.
