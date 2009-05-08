From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 7 May 2009 18:38:53 -0700
Subject: [Ocfs2-devel] [PATCH 37/39] ocfs2: Don't merge in 1st
	refcount	ops of reflink.
In-Reply-To: <1241045931-24607-37-git-send-email-tao.ma@oracle.com>
References: <49F95A79.6040806@oracle.com>
	<1241045931-24607-37-git-send-email-tao.ma@oracle.com>
Message-ID: <20090508013853.GF31624@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Apr 30, 2009 at 06:58:49AM +0800, Tao Ma wrote:
> Actually the whole reflink will touch refcount tree 2 times:
> 1. It will add the clusters in the extent record to the tree if it
>    isn't refcounted before.
> 2. It will add 1 refcount to these clusters when it add these
>    extent records to the tree.
> 
> So actually we shouldn't do merge in the 1st operation since the 2nd
> one will soon be called and we may have to split it again. Do a merge
> first and split soon is a waste of time. So we only merge in the 2nd
> round. This is done by adding a new internal __ocfs2_increase_refcount
> and call it with "not-merge" for 1st refcount operation in reflink.
> 
> This also has a side-effect that we don't need to worry too much about
> the metadata allocation in the 2nd round since it will only merge and
> no split will happen for those records.

	Hmm.  My first thought was "eww, awful special case".  But
you're right, the second pass is simpler if we don't have to re-split.
If we crash in between, we may have some could-have-been-merged records,
but the lookup code handles them just fine.

Joel

-- 

"Three o'clock is always too late or too early for anything you
 want to do."
        - Jean-Paul Sartre

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
