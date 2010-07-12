From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 12 Jul 2010 15:37:31 -0700
Subject: [Ocfs2-devel] [PATCH 27/36] fs/ocfs2: Remove unnecessary casts
 of private_data
In-Reply-To: <c75b92bbfb63964703ae99733f39696af4550f07.1278967121.git.joe@perches.com>
References: <cover.1278967120.git.joe@perches.com>
	<c75b92bbfb63964703ae99733f39696af4550f07.1278967121.git.joe@perches.com>
Message-ID: <20100712223731.GH12179@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com

On Mon, Jul 12, 2010 at 01:50:19PM -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  fs/ocfs2/dlm/dlmdebug.c |    6 +++---
>  fs/ocfs2/dlmfs/dlmfs.c  |    3 +--
>  fs/ocfs2/dlmglue.c      |    4 ++--
>  3 files changed, 6 insertions(+), 7 deletions(-)

Acked-by: Joel Becker <joel.becker@oracle.com>

Btw, how hilarious is the comment for private_data?

Joel

-- 

A good programming language should have features that make the
kind of people who use the phrase "software engineering" shake
their heads disapprovingly.
	- Paul Graham

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
