From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 13 Aug 2008 19:04:22 -0700
Subject: [Ocfs2-devel] [PATCH] Refactor ocfs2_insert_extent for
	not-merging.
In-Reply-To: <48A386D2.40108@oracle.com>
References: <20080812205225.GH21187@wotan.suse.de>
	<1218648792-5033-1-git-send-email-tao.ma@oracle.com>
	<20080813203240.GO21187@wotan.suse.de> <48A386D2.40108@oracle.com>
Message-ID: <20080814020422.GE21187@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Aug 14, 2008 at 09:13:54AM +0800, Tao Ma wrote:
> Mark Fasheh wrote:
> >On Thu, Aug 14, 2008 at 01:33:12AM +0800, Tao Ma wrote:
> >  
> >>From: taoma <taoma@tma-home.cn.oracle.com>
> >>
> >>Hi Mark,
> >>	Here is the patch we discussed this morning.
> >>
> >>In xattr bucket, we want to limit the maximum size of a btree leaf,
> >>otherwise we'll lose the benefits of hashing because we'll have to search
> >>large leaves.
> >>
> >>So add a new flag in ocfs2_extent_tree which will prevent 
> >>ocfs2_insert_extent
> >>from merging the leaf record even if they are contiguous.
> >>    
> >
> >Ok, this is close... The problem I see here though is that we've gone from
> >always merging when possible to *never* merging.
> >
> >What we want is "don't merge if the resulting extent is larger than a given
> >size".
> >  
> I leave this judgement to the caller itself(the flag) and I think the 
> caller should be responsible for telling ocfs2_insert_extent whether the 
> new added cluster should be merged or not.

Right.


> So if the caller say loudly that "please don't merge", we will not 
> merge.

Well, my point is it's better if the caller says (loudly) "don't exceed this
limit!"... That way, it doesn't have to look at the extents to the right and
left of the record being inserted and figure out whether a merge would be a
bad thing. Basically, it leaves the specifics of where extent records are to
the btree code...


> As for xattr extent tree, I have already judge the situation in 
> the caller(ocfs2_add_new_xattr_cluster), so it will not be a problem.

Ok, I didn't see that patch. Is it actually checking records on either side
of the insert?


> There is also another benefit. In future, other extent tree type may 
> have another type of things which will ask ocfs2_insert_extent to "not 
> merge", but not because of the leaf size. And we can also handle this.
> Make sense?

Yeah, I think we're about 90% in agreement. I also want this for future use
- indexed directories will need to do the same thing. I'd like them to just
just pass down a max size however, and never have to worry about the details
of extent merging.
	--Mark

--
Mark Fasheh
