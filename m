From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 7 Oct 2008 14:19:12 -0700
Subject: [Ocfs2-devel] [PATCH 11/39] ocfs2: Add extent tree operation
	for xattr value btrees
In-Reply-To: <20081001231205.1652365b.akpm@linux-foundation.org>
References: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
	<1222293680-15451-12-git-send-email-mfasheh@suse.com>
	<20081001231205.1652365b.akpm@linux-foundation.org>
Message-ID: <20081007211912.GF26373@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, joel.becker@oracle.com, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, tao.ma@oracle.com

On Wed, Oct 01, 2008 at 11:12:05PM -0700, Andrew Morton wrote:
> > On Wed, 24 Sep 2008 15:00:52 -0700 Mark Fasheh <mfasheh@suse.com> wrote:
> > +	if (eb_bh)
> > +		brelse(eb_bh);
> 
> brelse(0) is legal.  Please do an fs-wide review for this.

Ok, I'll queue that up. I'll watch to make sure that new patches from here
on won't do this.


> It shouldn't affect code generation because brelse() is inlined.

Fair enough, thanks.
	--Mark


--
Mark Fasheh
