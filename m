From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 12 Nov 2008 19:48:12 -0800
Subject: [Ocfs2-devel] [PATCH 4/4] ocfs2: Introduce dir free space list
In-Reply-To: <1226543048-911-5-git-send-email-mfasheh@suse.com>
References: <1226543048-911-1-git-send-email-mfasheh@suse.com>
	<1226543048-911-5-git-send-email-mfasheh@suse.com>
Message-ID: <20081113034812.GF27602@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Nov 12, 2008 at 06:24:08PM -0800, Mark Fasheh wrote:
> The only operation which doesn't get faster with directory indexing is
> insert, which still has to walk the entire unindexed directory portion to
> find a free block. This patch provides an improvement in directory insert
> performance by maintaining a singly linked list of directory leaf blocks
> which have space for additional dirents.
> 
> As the disk format is now finalized, we also turn on directory indexing support.
> 
> Signed-off-by: Mark Fasheh <mfasheh@suse.com>

	Looks good.  I realize that you're going to add the versioning
support.  And that on-disk trailer structure needs offset annotation.

Joel

-- 

"And yet I find,
 And yet I find repeating in my head.
 If I can't be my own, 
 I'd feel better dead."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
