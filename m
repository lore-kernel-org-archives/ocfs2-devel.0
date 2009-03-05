From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 4 Mar 2009 18:36:17 -0800
Subject: [Ocfs2-devel] [PATCH 0/2] ocfs2: two bug fixes about xattr and
	inline-data
In-Reply-To: <49ADF2FB.6060503@oracle.com>
References: <49ADF2FB.6060503@oracle.com>
Message-ID: <20090305023617.GA18729@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Mar 04, 2009 at 11:18:19AM +0800, Tiger Yang wrote:
> I found two serious bugs about xattr and inline-data.

Tristan,
	Can you add tests for this in the xattr suite?  Thanks!

Joel

>
> the first bug:
> in ocfs2_mknod(), we check and found the ACL or security xattr entry  
> could be set into inode in ocfs2_calc_xattr_init(), then don't reserve  
> block for them. But in ocfs2_mknod_locked(), if we found ocfs2 support  
> inline-data, then set id_count with the max_inline_data. After that, we  
> set acl/security xattr entry in ocfs2_init_acl() or  
> ocfs2_init_security_set(), but in there we found inode is full, then  
> panic at ocfs2_claim_metadata in ocfs2_xattr_block_set.
>
> the second bug:
> we don't check inline xattr in ocfs2_try_to_write_inline_data(), so the  
> inline data may overwrite the xattr entries which have already in inode.
>
>
> thanks,
> tiger

-- 

"Here's something to think about:  How come you never see a headline
 like ``Psychic Wins Lottery''?"
	- Jay Leno

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
