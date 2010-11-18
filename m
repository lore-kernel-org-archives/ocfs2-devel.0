From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 18 Nov 2010 15:38:33 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Stop tracking a negative
 dentry after dentry_iput().
In-Reply-To: <4CE48A84.3090405@oracle.com>
References: <1289828349-24098-1-git-send-email-tristan.ye@oracle.com>
	<20101117232344.GF25677@mail.oracle.com>
	<4CE48469.2090102@oracle.com> <4CE48A84.3090405@oracle.com>
Message-ID: <20101118233833.GG19821@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Nov 18, 2010 at 10:08:04AM +0800, Tristan Ye wrote:
> Tristan Ye wrote:
> >>     I'm going to take this fix for now, because it is clearing the
> >> problem.  However, it looks like the original code _should_ work.  If we
> >> have created a file, the directory's generation should have been
> >> updated.  Thus, the pgen shouldn't match the generation set when the old
> >> inode was deleted.  Right?
> I'm afraid it was not the case,
> 
> Say nodeA deleted the file(after Node B 'ls' it), Yes, now the 
> generation number of
> parent directory gets updated, and the newly-generated negative dentry 
> inherits the
> pgen, then we continue to do the creation(touch file) on nodeA without 
> nodeB interleaves
> the operation at all. in this case, pgen will not change since no 
> dlmlock gets converted here,
> reasonable?

	Makes sense.  And since we're trying to avoid the cluster lock
with our validation, we can't take it to check.  Thanks.

Joel

-- 

"Anything that is too stupid to be spoken is sung."  
        - Voltaire

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
