From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 10 Dec 2008 16:46:58 -0800
Subject: [Ocfs2-devel] [PATCH 08/18] ocfs2: Use
	metadata-specific	ocfs2_journal_access_*() functions.
In-Reply-To: <49405F4D.60302@oracle.com>
References: <1228871395-10273-1-git-send-email-joel.becker@oracle.com>
	<1228871395-10273-9-git-send-email-joel.becker@oracle.com>
	<493F2A16.5070109@oracle.com>
	<20081210111540.GB16888@ca-server1.us.oracle.com>
	<49405F4D.60302@oracle.com>
Message-ID: <20081211004658.GH21455@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Dec 11, 2008 at 08:31:09AM +0800, Tao Ma wrote:
> > 	But then you start dereferencing the path bh list.  That's
> > breaks the abstraction of the path structure.  It also drops the
> > consistency of always using ocfs2_path_bh_journal_access() for paths.
> > Conversely, there is no real loss to calling
> > ocfs2_path_bh_journal_access(); the extra function call is
> > insignificant.
> fail enough. actually this piece of code make me think of the use of 
> ocfs2_journal_access_eb.
> in ocfs2_rotate_subtree_left:
> 	if (le16_to_cpu(right_leaf_el->l_next_free_rec) > 1) {
> 		ret = ocfs2_journal_access_eb(handle, inode,
> 					path_leaf_bh(right_path),
> 					OCFS2_JOURNAL_ACCESS_WRITE);
> So according to your policy, we should change it to 
> ocfs2_path_bh_journal_access also? ;)

	Nope, because it's not based on an index, it's using the
path_leaf_bh() func.  I know you were being humourous here ;-)
> >> This is really a good chance for us to modify the comments also. ;)
> > 
> > 	You mean something like 'may update the tree root'?
> yeah.

	Done.

Joel

-- 

 Joel's Second Law:

	If a code change requires additional user setup, it is wrong.

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
