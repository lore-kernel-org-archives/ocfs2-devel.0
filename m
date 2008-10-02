From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 1 Oct 2008 23:12:05 -0700
Subject: [Ocfs2-devel] [PATCH 11/39] ocfs2: Add extent tree operation
 for xattr value btrees
In-Reply-To: <1222293680-15451-12-git-send-email-mfasheh@suse.com>
References: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
	<1222293680-15451-12-git-send-email-mfasheh@suse.com>
Message-ID: <20081001231205.1652365b.akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.com>
Cc: linux-kernel@vger.kernel.org, joel.becker@oracle.com, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, tao.ma@oracle.com

> On Wed, 24 Sep 2008 15:00:52 -0700 Mark Fasheh <mfasheh@suse.com> wrote:
> +	if (eb_bh)
> +		brelse(eb_bh);

brelse(0) is legal.  Please do an fs-wide review for this.

It shouldn't affect code generation because brelse() is inlined.
