From: Mark Fasheh <mfasheh@suse.de>
Date: Tue, 1 Sep 2015 15:36:27 -0700
Subject: [Ocfs2-devel] [patch 11/28] ocfs2: extend enough credits for
 freeing one truncate record while replaying truncate records
In-Reply-To: <20150901151207.2306af0e.akpm@linux-foundation.org>
References: <55de39a4.mm24W9YHh8D6r9FS%akpm@linux-foundation.org>
	<20150828235543.GQ1145@wotan.suse.de> <55E11B11.8000701@huawei.com>
	<20150901175403.GG1145@wotan.suse.de>
	<20150901151207.2306af0e.akpm@linux-foundation.org>
Message-ID: <20150901223627.GI1145@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Sep 01, 2015 at 03:12:07PM -0700, Andrew Morton wrote:
> On Tue, 1 Sep 2015 10:54:03 -0700 Mark Fasheh <mfasheh@suse.de> wrote:
> 
> > > > Why is this particular change here?
> > > > 	--Mark
> > > > 
> > > I think Joyce wants to get enough credits at first and then call
> > > ocfs2_replay_truncate_records.
> > 
> > Oh ok I see. That's fine then, the patch otherwise looked good to me,
> > thanks.
> > 
> > Reviewed-by: Mark Fasheh <mfasheh@suse.de>
> 
> Cool.  And where are we at with
> http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-extend-transaction-for-ocfs2_remove_rightmost_path-and-ocfs2_update_edge_lengths-before-to-avoid-inconsistency-between-inode-and-et.patch
> 
> ?

I had a couple questions, we're waiting for a response:

https://www.mail-archive.com/ocfs2-devel at oss.oracle.com/msg10167.html
	--Mark

--
Mark Fasheh
