From: tristan.ye <tristan.ye@oracle.com>
Date: Mon, 09 Mar 2009 14:28:10 +0800
Subject: [Ocfs2-devel] [PATCH 0/2] ocfs2: two bug fixes about xattr and
	inline-data
In-Reply-To: <20090305023617.GA18729@mail.oracle.com>
References: <49ADF2FB.6060503@oracle.com>
	<20090305023617.GA18729@mail.oracle.com>
Message-ID: <1236580090.6816.43.camel@tristan-laptop.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, 2009-03-04 at 18:36 -0800, Joel Becker wrote:
> On Wed, Mar 04, 2009 at 11:18:19AM +0800, Tiger Yang wrote:
> > I found two serious bugs about xattr and inline-data.
> 
> Tristan,
> 	Can you add tests for this in the xattr suite?  Thanks!
> 
> Joel
> 
> >
> > the first bug:
> > in ocfs2_mknod(), we check and found the ACL or security xattr entry  
> > could be set into inode in ocfs2_calc_xattr_init(), then don't reserve  
> > block for them. But in ocfs2_mknod_locked(), if we found ocfs2 support  
> > inline-data, then set id_count with the max_inline_data. After that, we  
> > set acl/security xattr entry in ocfs2_init_acl() or  
> > ocfs2_init_security_set(), but in there we found inode is full, then  
> > panic at ocfs2_claim_metadata in ocfs2_xattr_block_set.

Actually, my acl tests have included such case in default acl test by
looking back to my previous testcases.
ocfs2-test/programs/acl_tests/acl_tests.sh

> >
> > the second bug:
> > we don't check inline xattr in ocfs2_try_to_write_inline_data(), so the  
> > inline data may overwrite the xattr entries which have already in inode.

And xattr's combination test has had it already too:-)


Regards,
Tristan

> >
> >
> > thanks,
> > tiger
> 
