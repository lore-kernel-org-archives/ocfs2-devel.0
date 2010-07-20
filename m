From: Jiri Kosina <jkosina@suse.cz>
Date: Tue, 20 Jul 2010 17:20:26 +0200 (CEST)
Subject: [Ocfs2-devel] [PATCH 27/36] fs/ocfs2: Remove unnecessary casts
 of private_data
In-Reply-To: <20100712223731.GH12179@mail.oracle.com>
References: <cover.1278967120.git.joe@perches.com>
	<c75b92bbfb63964703ae99733f39696af4550f07.1278967121.git.joe@perches.com>
	<20100712223731.GH12179@mail.oracle.com>
Message-ID: <alpine.LNX.2.00.1007201720100.4741@pobox.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com

On Mon, 12 Jul 2010, Joel Becker wrote:

> On Mon, Jul 12, 2010 at 01:50:19PM -0700, Joe Perches wrote:
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> >  fs/ocfs2/dlm/dlmdebug.c |    6 +++---
> >  fs/ocfs2/dlmfs/dlmfs.c  |    3 +--
> >  fs/ocfs2/dlmglue.c      |    4 ++--
> >  3 files changed, 6 insertions(+), 7 deletions(-)
> 
> Acked-by: Joel Becker <joel.becker@oracle.com>

As this change is not present in linux-next as of today, I have applied 
it. Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
