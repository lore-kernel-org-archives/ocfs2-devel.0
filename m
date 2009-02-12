From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 12 Feb 2009 14:15:10 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: add IO error check
	in	ocfs2_get_sector() -v2
In-Reply-To: <49947EB2.5090503@oracle.com>
References: <200902120748.n1C7mVqx020705@acsinet13.oracle.com>
	<4994773E.6020609@oracle.com>
	<20090212194626.GC14638@ca-server1.us.oracle.com>
	<49947EB2.5090503@oracle.com>
Message-ID: <20090212221510.GA12965@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Feb 12, 2009 at 11:55:30AM -0800, Sunil Mushran wrote:
> I am looking at the brelse() in ocfs2_fill_super().

	Oh, right.  Then Wengang's patch should null out *bh when
brelsing it.  No point in passing a garbage bh all the way up.


Joel

> 
> Joel Becker wrote:
> > On Thu, Feb 12, 2009 at 11:23:42AM -0800, Sunil Mushran wrote:
> >   
> >> The matching brelse() is in ocfs2_fill_super(). So you shouldn't
> >> need it. Cross check though please.
> >>     
> >
> > 	No, if we get an error from ocfs2_get_sector() we return without
> > brelse().  So the patch is correct.
> >
> > Joel
> >
> >   
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

"The one important thing i have learned over the years is the
 difference between taking one's work seriously and taking one's self
 seriously.  The first is imperative and the second is disastrous."
	-Margot Fonteyn

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
