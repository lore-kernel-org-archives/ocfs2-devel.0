From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 2 Dec 2010 15:49:07 -0800
Subject: [Ocfs2-devel] [PATCH 1/2] Introduce ocfs2_recover_node
In-Reply-To: <4CF7EDDD.9020202@oracle.com>
References: <AANLkTikcDcWTXPqPMKxySo9CDOKBfgqHxHcoXj0UO66B@mail.gmail.com>
	<20101202052945.GG16604@mail.oracle.com>
	<4CF7EDDD.9020202@oracle.com>
Message-ID: <20101202234906.GC9864@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Dec 02, 2010 at 11:05:01AM -0800, Sunil Mushran wrote:
> On 12/01/2010 09:29 PM, Joel Becker wrote:
> > On Wed, Nov 17, 2010 at 09:50:04AM -0600, Goldwyn Rodrigues wrote:
> >> @@ -1470,7 +1451,11 @@ void ocfs2_recovery_thread(struct ocfs2_super
> >> *osb, int node_num)
> >>
> >>   	/* People waiting on recovery will wait on
> >>   	 * the recovery map to empty. */
> >> -	if (ocfs2_recovery_map_set(osb, node_num))
> >> +	ret = ocfs2_recovery_node_set(osb, node_num);
> >> +	if (ret == -ENOMEM) {
> >> +		mlog_errno(ret);
> >> +		goto out;
> >> +	} else if (ret)
> >>   		mlog(0, "node %d already in recovery map.\n", node_num);
> > 	This is a broken change.  If we get -ENOMEM, we won't block
> > other processes.  We can't have that happen.  There are two possible
> > solutions.  First, like Sunil said, we can preallocate max_slots recovery
> > entries.  Seems pretty sane.  The other solution would be to set an
> > in-recovery flag that others can check, so even when the recovery list
> > is empty because of a failed allocation, other processes still block.  I
> > prefer the preallocation because it doesn't fail recovery.
> 
> You could stick with the list but preallocate max_slots items during init.
> Attach all those to the s_init_reco_list. During set, move a item to
> s_active_reco_list. Clear moves it back.

	Exactly.

Joel

-- 

"You must remember this:
 A kiss is just a kiss,
 A sigh is just a sigh.
 The fundamental rules apply
 As time goes by."

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
