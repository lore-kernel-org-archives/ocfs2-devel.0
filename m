From: Mark Fasheh <mfasheh@suse.de>
Date: Mon, 17 Jun 2013 10:02:51 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: llseek need to inode cluster
	lock	and unlock for update the inode size in SEEK_END.
In-Reply-To: <51BF289D.9030706@oracle.com>
References: <51BF21D6.9080008@huawei.com> <51BF289D.9030706@oracle.com>
Message-ID: <20130617170251.GH29353@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Liu <jeff.liu@oracle.com>
Cc: shencanquan <shencanquan@huawei.com>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>

On Mon, Jun 17, 2013 at 11:17:49PM +0800, Jeff Liu wrote:
> Please add spaces between comments and annotation, i.e,
> 	   /*  Need to ...... */

yes, please describe while we're taking the lock here (describing the race
you're talking about would be fine).


> > +        ret = ocfs2_inode_lock(inode, NULL, 0);
> > +        if (ret < 0) {
> > +            mlog_errno(ret);
> > +            goto out;
> > +        }
> > +        ocfs2_inode_unlock(inode, 0);
> >           offset += inode->i_size;
> 
> Why not protect the offset adjustment insides ocfs2 inode locks?

If we're going through the trouble of locking we *need* to put the offset
calculation inside the lock otherwise we can still get stale i_size and
basically haven't fixed anything.


Btw, do you feel that this could impact performance for other workloads that
ocfs2 usually does?
	--Mark

--
Mark Fasheh
