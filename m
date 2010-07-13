From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 13 Jul 2010 01:10:13 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] OCFS2: Allow huge (> 16 TiB) volumes
 to mount
In-Reply-To: <AANLkTinsQjWD1t1lO_BHnM-afzYyl7TKKdIcNZEVMg6n@mail.gmail.com>
References: <871vbax86w.fsf@patl.com> <87zkxyvtjt.fsf@patl.com>
	<3BB069D5-B193-43A4-B678-B3CEA4873B58@dilger.ca>
	<AANLkTikAEycm5PKTLPuRFcB0e4qNp5EuQbKUx5aruNrh@mail.gmail.com>
	<DA64905D-C83B-4CF5-9405-65F7F82F9563@dilger.ca>
	<AANLkTinsQjWD1t1lO_BHnM-afzYyl7TKKdIcNZEVMg6n@mail.gmail.com>
Message-ID: <20100713081013.GA31479@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Patrick J. LoPresti" <lopresti@gmail.com>
Cc: Andreas Dilger <adilger@dilger.ca>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Mon, Jul 12, 2010 at 10:00:10PM -0700, Patrick J. LoPresti wrote:
> On Mon, Jul 12, 2010 at 9:46 PM, Andreas Dilger <adilger@dilger.ca> wrote:
> > On 2010-07-12, at 19:08, Patrick J. LoPresti wrote:
> >>
> >> Are you suggesting I need to do this before my patch is accepted at
> >> all? ?Or is this a refactoring that can happen later?
> >
> > I'm just suggesting it should be done at some point. ?I thought it would be better to do it first, rather than add yet another copy of this code. ?That said, I hate to block useful fixes because of cleanup (and I have no control over OCFS2 anyway :-). ?However, I've found that once the fix is in people usually forget (or become too busy) to do the cleanup and it just lingers on unseen.
> 
> I hear you.
> 
> I do not object to factoring out the basic addressability test and
> using it in my patch, leaving it for others -- like yourself :-) -- to
> modify other file systems to invoke it.

	I think you should modify ext3 and xfs, as they clearly are
partaking of this functionality.  I'll happily review it for you.  Put
the call in fs/libfs.c.  Call it generic_check_addressable(struct
super_block *super).

Joel


-- 

"The only way to get rid of a temptation is to yield to it."
         - Oscar Wilde 

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
