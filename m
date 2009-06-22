From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 22 Jun 2009 09:17:08 -0700
Subject: [Ocfs2-devel] [PATCH 5/5] ocfs2: Disable orphan scanning for
 local and hard-ro mounts
In-Reply-To: <20090620044129.GA1993@mail.oracle.com>
References: <1245455599-23348-1-git-send-email-sunil.mushran@oracle.com>
	<1245455599-23348-4-git-send-email-sunil.mushran@oracle.com>
	<20090620044129.GA1993@mail.oracle.com>
Message-ID: <20090622161707.GA8805@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jun 19, 2009 at 09:41:30PM -0700, Joel Becker wrote:
> On Fri, Jun 19, 2009 at 04:53:19PM -0700, Sunil Mushran wrote:
> > @@ -2392,11 +2398,13 @@ void ocfs2_orphan_scan_unlock(struct ocfs2_super *osb, u32 seqno, int ex)
> >  	struct ocfs2_orphan_scan_lvb *lvb;
> >  	int level = ex ? DLM_LOCK_EX : DLM_LOCK_PR;
> >  
> > -	lockres = &osb->osb_orphan_scan.os_lockres;
> > -	lvb = ocfs2_dlm_lvb(&lockres->l_lksb);
> > -	lvb->lvb_version = OCFS2_ORPHAN_LVB_VERSION;
> > -	lvb->lvb_os_seqno = cpu_to_be32(seqno);
> > -	ocfs2_cluster_unlock(osb, lockres, level);
> > +	if (!ocfs2_is_hard_readonly(osb) && !ocfs2_mount_local(osb)) {
> > +		lockres = &osb->osb_orphan_scan.os_lockres;
> > +		lvb = ocfs2_dlm_lvb(&lockres->l_lksb);
> > +		lvb->lvb_version = OCFS2_ORPHAN_LVB_VERSION;
> > +		lvb->lvb_os_seqno = cpu_to_be32(seqno);
> > +		ocfs2_cluster_unlock(osb, lockres, level);
> 
> 	This should only be setting the LVB if the level was EX.

	Actually, this lock is only ever taken as EX.  Why is there even
an ex argument to the function?

Joel

-- 

Life's Little Instruction Book #30

	"Never buy a house without a fireplace."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
