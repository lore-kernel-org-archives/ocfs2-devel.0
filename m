From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 1 Apr 2010 10:44:49 -0700
Subject: [Ocfs2-devel] [PATCH 12/15] ocfs2: Some tiny bug fixes for
 discontiguous block allocation.
In-Reply-To: <4BB421DD.9090708@oracle.com>
References: <4BB40AB4.8040205@oracle.com>
	<1270090752-18935-12-git-send-email-tao.ma@oracle.com>
	<20100401033406.GI28680@mail.oracle.com>
	<4BB421DD.9090708@oracle.com>
Message-ID: <20100401174448.GI19666@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Apr 01, 2010 at 12:32:29PM +0800, Tao Ma wrote:
> Joel Becker wrote:
> >On Thu, Apr 01, 2010 at 10:59:09AM +0800, Tao Ma wrote:
> >> 	le32_add_cpu(&fe->id1.bitmap1.i_total, le16_to_cpu(bg->bg_bits));
> >>-	le32_add_cpu(&fe->i_clusters, le16_to_cpu(cl->cl_cpg));
> >>+	le32_add_cpu(&fe->i_clusters,
> >>+		     le16_to_cpu(bg->bg_bits) / le16_to_cpu(cl->cl_bpc));
> >
> >	You don't need to change this.  Either we've allocated cpg or
> >we've failed out.
> Current we don't fail out in ocfs2_block_group_grow_discontig when
> we used up all the extent record in the list. So actually our bitmap
> size can be less than cpg. So you think we need to bail out?
> 
> I removed your
> if (needed > 0) {
> }

	Um, there's supposed to be the -ENOSPC in there.  Looks like
something I didn't complete.
	We will NOT support block groups that are smaller than cpg.

Joel

-- 

"But then she looks me in the eye
 And says, 'We're going to last forever,'
 And man you know I can't begin to doubt it.
 Cause it just feels so good and so free and so right,
 I know we ain't never going to change our minds about it, Hey!
 Here comes my girl."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
